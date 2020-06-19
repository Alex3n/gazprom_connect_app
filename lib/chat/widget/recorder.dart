import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';

class RecorderPage extends StatefulWidget {
  RecorderPage(
      {Key key, this.groupChatId, this.userId, this.peerId, this.userName})
      : super(key: key);
  final String groupChatId;
  final String userId;
  final String peerId;
  final String userName;

  @override
  _RecorderPageState createState() => _RecorderPageState();
}
//todo удаление неотправленных записей
class _RecorderPageState extends State<RecorderPage> {
  FlutterAudioRecorder _recorder;
  Recording _recording;
  Timer _t;
  Widget _buttonIcon = Icon(Icons.do_not_disturb_on);
  String _alert = "";
  AudioPlayer player = AudioPlayer();
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _prepare();
    });
  }

  void _opt() async {
    switch (_recording.status) {
      case RecordingStatus.Initialized:
        {
          await _startRecording();
          break;
        }
      case RecordingStatus.Recording:
        {
          await _stopRecording();
          break;
        }
      case RecordingStatus.Stopped:
        {
          await _prepare();
          break;
        }

      default:
        break;
    }

    setState(() {
      _buttonIcon = _playerIcon(_recording.status);
    });
  }

  Future _init() async {
    String customPath = '/flutter_audio_recorder_';
    Directory appDocDirectory;
    if (Platform.isIOS) {
      appDocDirectory = await getApplicationDocumentsDirectory();
    } else {
      appDocDirectory = await getExternalStorageDirectory();
    }

    // can add extension like ".mp4" ".wav" ".m4a" ".aac"
    customPath = appDocDirectory.path +
        customPath +
        DateTime
            .now()
            .millisecondsSinceEpoch
            .toString();

    // .wav <---> AudioFormat.WAV
    // .mp4 .m4a .aac <---> AudioFormat.AAC
    // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.

    _recorder = FlutterAudioRecorder(customPath,
        audioFormat: AudioFormat.WAV, sampleRate: 22050);
    await _recorder.initialized;
  }

  Future _prepare() async {
    var hasPermission = await FlutterAudioRecorder.hasPermissions;
    if (hasPermission) {
      await _init();
      var result = await _recorder.current();
      setState(() {
        _recording = result;
        _buttonIcon = _playerIcon(_recording.status);
        _alert = "";
      });
    } else {
      setState(() {
        _alert = "Permission Required.";
      });
    }
  }

  Future _startRecording() async {
    await _recorder.start();
    var current = await _recorder.current();
    setState(() {
      _recording = current;
    });

    _t = Timer.periodic(Duration(milliseconds: 10), (Timer t) async {
      var current = await _recorder.current();
      setState(() {
        _recording = current;
        _t = t;
      });
    });
  }

  Future _stopRecording() async {
    var result = await _recorder.stop();
    _t.cancel();

    setState(() {
      _recording = result;
    });
  }

  void _play() {
    if (isPlaying)
      player.pause();
    else
      player.play(_recording.path, isLocal: true);
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  Widget _playerIcon(RecordingStatus status) {
    switch (status) {
      case RecordingStatus.Initialized:
        {
          return Icon(Icons.fiber_manual_record);
        }
      case RecordingStatus.Recording:
        {
          return Icon(Icons.stop);
        }
      case RecordingStatus.Stopped:
        {
          return Icon(Icons.replay);
        }
      default:
        return Icon(Icons.do_not_disturb_on);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Аудио сообщение',
            style: Theme
                .of(context)
                .textTheme
                .title,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            '${_recording?.duration ?? "-"}',
            style: Theme
                .of(context)
                .textTheme
                .body1,
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FloatingActionButton(
                backgroundColor: _recording?.status == RecordingStatus.Recording
                    ? Colors.red
                    : null,
                onPressed: _opt,
                child: _buttonIcon,
              ),
              FloatingActionButton(
                backgroundColor: _recording?.status != RecordingStatus.Stopped
                    ? Colors.grey.withOpacity(0.5)
                    : null,
                onPressed: _recording?.status == RecordingStatus.Stopped
                    ? _play
                    : null,
                child: isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
              ),
              FloatingActionButton(
                backgroundColor: _recording?.status != RecordingStatus.Stopped
                    ? Colors.grey.withOpacity(0.5)
                    : null,
                onPressed: () {
                  _sendMessage();
                },
                child: Icon(Icons.send),
              ),
            ],
          ),
          _alert.isEmpty
              ? Container()
              : Text(
            '${_alert ?? ""}',
            style: Theme
                .of(context)
                .textTheme
                .title
                .copyWith(color: Colors.red),
          ),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> _sendMessage() async {
    print("${_recording.path}");

    File audioFile = File(_recording.path);

    String fileName = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(audioFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      onSendMessage(downloadUrl);
    }, onError: (err) {
      Fluttertoast.showToast(msg: 'ошибка');
    });
    audioFile.delete();
    Navigator.pop(context);
  }

  void onSendMessage(String content) {
    var documentReference = Firestore.instance
        .collection('messages')
        .document(widget.groupChatId)
        .collection(widget.groupChatId)
        .document(DateTime
        .now()
        .millisecondsSinceEpoch
        .toString());

    Firestore.instance.runTransaction((transaction) async {
      await transaction.set(
        documentReference,
        {
          'idFrom': widget.userId,
          'idTo': widget.peerId,
          'name': widget.userName,
          'timestamp': DateTime
              .now()
              .millisecondsSinceEpoch
              .toString(),
          'content': content,
          'type': 3
        },
      );
    });
  }
}
