class TeamInTableModel {
  String team;
  String logo;
  String win;
  String draw;
  String lose;
  String games;
  String scores;
  String image;

  TeamInTableModel(this.team, this.logo, this.games, this.lose, this.win,
      this.draw, this.scores, this.image);

  TeamInTableModel.fromMap(Map snapshot)
      : team = snapshot['team'] ?? '',
        logo = snapshot['logo'] ?? '',
        win = snapshot['win'] ?? '',
        draw = snapshot['draw'] ?? '',
        lose = snapshot['lose'] ?? '',
        games = snapshot['games'] ?? '',
        scores = snapshot['scores'] ?? '',
        image = snapshot['image'] ?? '';

  @override
  String toString() {
    return 'TeamInTableModel{team: $team, logo: $logo, win: $win, draw: $draw, lose: $lose, games: $games, scores: $scores, image: $image}';
  }
}
