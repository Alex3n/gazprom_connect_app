

class Player {
  String amplua;
  String born;
  String name;
  String number;
  String photo;


  Player(this.amplua, this.born, this.name, this.number, this.photo);

  Player.fromMap(Map snapshot)
      :
        amplua = snapshot['amplua'] ?? '',
        born = snapshot['born'] ?? '',
        name = snapshot['name'] ?? '',
        number = snapshot['number'] ?? '',
        photo = snapshot['photo'] ?? '';
  

}