class MatchModel {
  String homeTeam;
  String awayTeam;
  String homeLogo;
  String awayLogo;
  String date;
  String round;
  String translationURL;
  String buyTicketURL;
  String score;


  MatchModel.fromMap(Map snapshot)
      :
        homeTeam = snapshot['homeTeam'] ?? '',
        awayTeam = snapshot['awayTeam'] ?? '',
        homeLogo = snapshot['homeLogo'] ?? '',
        awayLogo = snapshot['awayLogo'] ?? '',
        date = snapshot['date'] ?? '',
        round = snapshot['round'] ?? '',
        translationURL = snapshot['translationURL'] ?? '',
        buyTicketURL = snapshot['buyTicketURL'] ?? '',
        score = snapshot['score'] ?? '';

  @override
  String toString() {
    return 'MatchModel{homeTeam: $homeTeam, awayTeam: $awayTeam, '
        'homeLogo: $homeLogo, awayLogo: $awayLogo, date: $date, round: $round'
        'translationURL: $translationURL, buyTicketURL: $buyTicketURL}';
  }


}