// Skeleton Program code for the AQA A Level Paper 1 2018 examination
// this code should be used in conjunction with the Preliminary Material
// written by the AQA Programmer Team
// developed using Delphi XE5

program paper1_alvl_2018_pascal_pre_0_0_6;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Classes;

type
  //DICTIONARY CLASS BEGIN
  Tile = class
    public
      Key : char;
      Value : integer;
      constructor Create(KeyInput : char; ValueInput : integer);
  end;

  TTileDictionary = class
    public
      Tiles : array of Tile;
      TileCount : integer;
      constructor Create();
      procedure Add(KeyInput : char; ValueInput : integer);
      function FindTileScore(KeyInput : char) : integer;
  end;
  //DICTIONARY CLASS END

  QueueOfTiles = class
    protected
      Contents : array of string;
      Rear : integer;
      MaxSize : integer;
    public
      constructor Create(Max : integer);
      function IsEmpty() : boolean;
      function Remove() : string;
      procedure Add();
      procedure Show();
    end;

  TIntegerArray = array of integer;
  TStringArray = array of string;

//DICTIONARY ROUTINES BEGIN

constructor Tile.Create(KeyInput : char; ValueInput : integer);
  begin
    Key := KeyInput;
    Value := ValueInput;
  end;

constructor TTileDictionary.Create();
  begin
    TileCount := 0;
    SetLength(Tiles, 26);
  end;

procedure TTileDictionary.Add(KeyInput : char; ValueInput : integer);
  var
    TempTile : Tile;
  begin
    TempTile := Tile.Create(KeyInput, ValueInput);
    Tiles[TileCount] := TempTile;
    inc(TileCount);
  end;

function TTileDictionary.FindTileScore(KeyInput : char) : integer;
  var
    SelectedTile : Tile;
    Score : integer;
    Index : integer;
  begin
    for Index := Low(Tiles) to High(Tiles) do
      begin
        SelectedTile := Tiles[Index];
        if SelectedTile.Key = KeyInput then
          Score := Selectedtile.Value;
      end;
    FindTileScore := Score;
  end;

//DICTIONARY ROUTINES END

constructor QueueOfTiles.Create(Max : integer);
  var
    Count : integer;
  begin
    MaxSize := Max;
    SetLength(Contents, MaxSize);
    Rear := -1;
    for Count := 0 to MaxSize - 1 do
      begin
        Contents[Count] := '';
        Add();
      end;
  end;

function QueueOfTiles.IsEmpty() : boolean;
  begin
    if Rear = -1 then
      IsEmpty := True
    else
      IsEmpty := False;
  end;

function QueueOfTiles.Remove() : string;
  var
    Item : string;
    Count : integer;
  begin
    if IsEmpty() then
      Item := ''
    else
      begin
        Item := Contents[0];
        for Count := 1 to Rear  do
          Contents[Count-1] := Contents[Count];
        Contents[Rear] := '';
        Rear := Rear - 1;
      end;
    Remove := Item;
   end;

procedure QueueOfTiles.Add();
  var
    RandNo : integer;
  begin
    if Rear < MaxSize - 1 then
      begin
        RandNo := Random(26);
        Rear := Rear + 1;
        Contents[Rear] := chr(65 + RandNo);
      end;
  end;

procedure QueueOfTiles.Show();
  var
    Item : integer;
  begin
    if Rear <> -1 then
      begin
        writeln;
        writeln('The contents of the queue are: ');
        for Item := 0 to Rear do
          write(Contents[Item]);
        writeln;
      end;
  end;

function CreateTileDictionary() : TTileDictionary;
  var
    TileDictionary : TTileDictionary;
    Count : integer;
  begin
    TileDictionary := TTileDictionary.Create();
    for Count := 0 to 25 do
      begin
        case count of
          0, 4, 8, 13, 14, 17, 18, 19: TileDictionary.Add(chr(65 + count), 1);
          1, 2, 3, 6, 11, 12, 15, 20: TileDictionary.Add(chr(65 + count), 2);
          5, 7, 10, 21, 22, 24: TileDictionary.Add(chr(65 + count), 3);
          else TileDictionary.Add(chr(65 + count), 5);
        end;
      end;
      CreateTileDictionary := TileDictionary;
  end;

procedure DisplayTileValues(TileDictionary : TTileDictionary; AllowedWords : TStringArray);
  var
    Count : integer;
  begin
    writeln;
    writeln('TILE VALUES');
    writeln;
    for Count := 0 to length(TileDictionary.Tiles) - 1 do
      writeln('Points for ', TileDictionary.Tiles[Count].Key, ': ', TileDictionary.Tiles[Count].Value);
    writeln;
  end;

function GetStartingHand(TileQueue : QueueOfTiles; StartHandSize : integer): string;
  var
    Hand : string;
    Count : integer;
  begin
    Hand := '';
    for Count := 1 to StartHandSize do
      begin
        Hand := Hand + TileQueue.Remove();
        TileQueue.Add();
      end;
    GetStartingHand := Hand;
  end;

function LoadAllowedWords() : TStringArray;
  var
    AllowedWords : TStringArray;
    ListSize : integer;
    TFIn : textfile;
    Word : string;
  begin
    ListSize := 0;
    AssignFile(TFIn, 'aqawords.txt');
    try
      reset(TFIn);
      while not eof(TFIn) do
        begin
          inc(ListSize);
          SetLength(AllowedWords, ListSize);
          readln(TFIn, Word);
          Word := UpperCase(Word);
          AllowedWords[ListSize - 1] := Word;
        end;
      CloseFile(TFIn);
    finally
    end;
    LoadAllowedWords := AllowedWords;
  end;

function CheckWordIsInTiles(Word : string; PlayerTiles : string) : boolean;
  var
    InTiles : boolean;
    CopyOfTiles : string;
    Count : integer;
  begin
    InTiles := True;
    CopyOfTiles := PlayerTiles;
    for Count := 1 to length(Word) do
      begin
        if pos(Word[Count], CopyOfTiles) > 0 then
          Delete(CopyOfTiles, pos(Word[Count], CopyOfTiles), 1)
        else
          InTiles := False;
      end;
    CheckWordIsInTiles := InTiles;
  end;

function CheckWordIsValid(Word : string; AllowedWords : TStringArray) : boolean;
  var
    ValidWord : boolean;
    Count : integer;
  begin
    ValidWord := False;
    Count := 0;
    while (Count < length(AllowedWords)) and (ValidWord = False) do
      begin
        if AllowedWords[Count] = Word then
          ValidWord := True;
        Count := Count + 1;
      end;
    CheckWordIsValid := ValidWord;
  end;

procedure AddEndOfTurnTiles(var TileQueue : QueueOfTiles; var PlayerTiles : string; NewTileChoice : string; Choice : string);
  var
    NoOfEndOfTurnTiles : integer;
    Count : integer;
  begin
    if NewTileChoice = '1' then
      NoOfEndOfTurnTiles := length(Choice)
    else if NewTileChoice = '2' then
      NoOfEndOfTurnTiles := 3
    else
      NoOfEndOfTurnTiles := length(Choice) + 3;
    for Count := 1 to NoOfEndOfTurnTiles do
      begin
        PlayerTiles := PlayerTiles + TileQueue.Remove();
        TileQueue.Add();
      end;
  end;

procedure FillHandWithTiles(var TileQueue : QueueOfTiles; var PlayerTiles : string; MaxHandSize : integer);
  begin
    while length(PlayerTiles) <= MaxHandSize do
      begin
        PlayerTiles := PlayerTiles + TileQueue.Remove();
        TileQueue.Add();
      end;
  end;

function GetScoreForWord(Word : string; TileDictionary : TTileDictionary) : integer;
  var
    Score : integer;
    Count : integer;
  begin
    Score := 0;
    for Count := 1 to length(Word) do
      Score := Score + TileDictionary.FindTileScore(Word[Count]);
    if length(Word) > 7 then
      Score := Score + 20
    else if length(Word) > 5 then
      Score := Score + 5;
    GetScoreForWord := Score;
  end;

procedure UpdateAfterAllowedWord(Word : string; var PlayerTiles : string; var PlayerScore : integer; var PlayerTilesPlayed : integer; TileDictionary : TTileDictionary; var AllowedWords : TStringArray);
  var
    Letter : char;
    Index : integer;
  begin
    PlayerTilesPlayed := PlayerTilesPlayed + length(Word);
    for Index := 1 to length(Word) do
      begin
        Letter := Word[Index];
        Delete(PlayerTiles, pos(Letter, PlayerTiles), 1);
      end;
    PlayerScore := PlayerScore + GetScoreForWord(Word, TileDictionary);
  end;

procedure UpdateScoreWithPenalty(var PlayerScore : integer; PlayerTiles : string; TileDictionary : TTileDictionary);
  var
    Count : integer;
  begin
    for Count := 1 to length(PlayerTiles) do
      PlayerScore := PlayerScore - TileDictionary.FindTileScore(PlayerTiles[Count]);
  end;

function GetChoice() : string;
  var
    Choice : string;
  begin
    writeln;
    writeln('Either:');
    writeln('     enter the word you would like to play OR');
    writeln('     press 1 to display the letter values OR');
    writeln('     press 4 to view the tile queue OR');
    writeln('     press 7 to view your tiles again OR');
    writeln('     press 0 to fill hand and stop the game.');
    write('> ');
    readln(Choice);
    writeln;
    Choice := UpperCase(Choice);
    GetChoice := Choice;
  end;

function GetNewTileChoice() : string;
  var
    NewTileChoice : char;
  begin
    while Pos(NewTileChoice, '1234') = 0 do
      begin
        writeln('Do you want to:');
        writeln('     replace the tiles you used (1) OR');
        writeln('     get three extra tiles (2) OR');
        writeln('     replace the tiles you used and get three extra tiles (3) OR');
        writeln('     get no new tiles (4)?');
        write('> ');
        readln(NewTileChoice);
      end;
    GetNewTileChoice := NewTileChoice;
  end;

procedure DisplayTilesInHand(PlayerTiles : string);
  begin
    writeln;
    writeln('Your current hand: ', PlayerTiles);
  end;

procedure HaveTurn(PlayerName : string; var PlayerTiles : string; var PlayerTilesPlayed : integer;
var PlayerScore : integer; TileDictionary : TTileDictionary; var TileQueue : QueueOfTiles;
var AllowedWords : TStringArray; MaxHandSize : integer; NoOfEndOfTurnTiles : integer);
  var
    NewTileChoice : string;
    ValidChoice : boolean;
    ValidWord : boolean;
    Choice : string;
  begin
    writeln;
    writeln(PlayerName, ' it is your turn.');
    DisplayTilesInHand(PlayerTiles);
    NewTileChoice := '2';
    ValidChoice := False;
    while not ValidChoice do
      begin
        Choice := GetChoice();
        if Choice = '1' then
          DisplayTileValues(TileDictionary, AllowedWords)
        else if Choice = '4' then
          TileQueue.Show()
        else if Choice = '7' then
          DisplayTilesInHand(PlayerTiles)
        else if Choice = '0' then
          begin
            ValidChoice := True;
            FillHandWithTiles(TileQueue, PlayerTiles, MaxHandSize);
          end
        else
          begin
            ValidChoice := True;
            if length(Choice) = 0 then
              ValidWord := False
            else
              ValidWord := CheckWordIsInTiles(Choice, PlayerTiles);
            if ValidWord then
              begin
                ValidWord := CheckWordIsValid(Choice, AllowedWords);
                if ValidWord then
                  begin
                    writeln;
                    writeln('Valid word');
                    writeln;
                    UpdateAfterAllowedWord(Choice, PlayerTiles, PlayerScore, PlayerTilesPlayed, TileDictionary, AllowedWords);
                    NewTileChoice := GetNewTileChoice();
                  end;
              end;
            if not ValidWord then
              begin
                writeln;
                writeln('Not a valid attempt, you lose your turn.');
                writeln;
              end;
            if not(NewTileChoice = '4') then
              AddEndOfTurnTiles(TileQueue, PlayerTiles, NewTileChoice, Choice);
            writeln;
            writeln('Your word was: ', Choice);
            writeln('Your new score is: ', PlayerScore);
            writeln('You have played ', PlayerTilesPlayed, ' tiles so far in this game.');
          end;
      end;
  end;

procedure DisplayWinner(PlayerOneScore : integer; PlayerTwoScore : integer);
  begin
    writeln;
    writeln('**** GAME OVER! ****');
    writeln;
    writeln('Player One your score is ', PlayerOneScore);
    writeln('Player Two your score is ', PlayerTwoScore);
    if PlayerOneScore > PlayerTwoScore then
      writeln('Player One wins!')
    else if PlayerTwoScore > PlayerOneScore then
      writeln('Player Two wins!')
    else
      writeln('It is a draw!');
    writeln;
  end;

procedure PlayGame(AllowedWords : TStringArray; TileDictionary : TTileDictionary; RandomStart : boolean; StartHandSize : integer; MaxHandSize : integer; MaxTilesPlayed : integer; NoOfEndOfTurnTiles : integer);
  var
    PlayerOneScore : integer;
    PlayerTwoScore : integer;
    PlayerOneTilesPlayed : integer;
    PlayerTwoTilesPlayed : integer;
    PlayerOneTiles : string;
    PlayerTwoTiles : string;
    TileQueue : QueueOfTiles;
  begin
    PlayerOneScore := 50;
    PlayerTwoScore := 50;
    PlayerOneTilesPlayed := 0;
    PlayerTwoTilesPlayed := 0;
    TileQueue := QueueOfTiles.Create(20);
    if RandomStart then
      begin
        PlayerOneTiles := GetStartingHand(TileQueue, StartHandSize);
        PlayerTwoTiles := GetStartingHand(TileQueue, StartHandSize);
      end
    else
      begin
        PlayerOneTiles := 'BTAHANDENONSARJ';
        PlayerTwoTiles := 'CELZXIOTNESMUAA';
      end;
    while (PlayerOneTilesPlayed <= MaxTilesPlayed) and (PlayerTwoTilesPlayed <= MaxTilesPlayed) and (length(PlayerOneTiles) < MaxHandSize) and (length(PlayerTwoTiles) < MaxHandSize) do
      begin
        HaveTurn('Player One', PlayerOneTiles, PlayerOneTilesPlayed, PlayerOneScore, TileDictionary, TileQueue, AllowedWords, MaxHandSize, NoOfEndOfTurnTiles);
        writeln;
        write('Press Enter to continue');
        readln;
        writeln;
        HaveTurn('Player Two', PlayerTwoTiles, PlayerTwoTilesPlayed, PlayerTwoScore, TileDictionary, TileQueue, AllowedWords, MaxHandSize, NoOfEndOfTurnTiles);
      end;
    UpdateScoreWithPenalty(PlayerOneScore, PlayerOneTiles, TileDictionary);
    UpdateScoreWithPenalty(PlayerTwoScore, PlayerTwoTiles, TileDictionary);
    DisplayWinner(PlayerOneScore, PlayerTwoScore);
  end;

procedure DisplayMenu();
  begin
    writeln;
    writeln('=========');
    writeln('MAIN MENU');
    writeln('=========');
    writeln;
    writeln('1. Play game with random start hand');
    writeln('2. Play game with training start hand');
    writeln('9. Quit');
  end;

procedure Main();
  var
    AllowedWords : TStringArray;
    TileDictionary : TTileDictionary;
    MaxHandSize : integer;
    MaxTilesPlayed : integer;
    NoOfEndOfTurnTiles : integer;
    StartHandSize : integer;
    Choice : string;
  begin
    Randomize;
    writeln('++++++++++++++++++++++++++++++++++++++');
    writeln('+ Welcome to the WORDS WITH AQA game +');
    writeln('++++++++++++++++++++++++++++++++++++++');
    writeln;
    writeln;
    AllowedWords := LoadAllowedWords();
    TileDictionary := CreateTileDictionary;
    MaxHandSize := 20;
    MaxTilesPlayed := 50;
    NoOfEndOfTurnTiles := 3;
    StartHandSize := 15;
    Choice := '';
    while not(Choice = '9') do
      begin
        DisplayMenu();
        write('Enter your choice: ');
        readln(Choice);
        if Choice = '1' then
          PlayGame(AllowedWords, TileDictionary, True, StartHandSize, MaxHandSize, MaxTilesPlayed, NoOfEndOfTurnTiles)
        else if Choice = '2' then
          PlayGame(AllowedWords, TileDictionary, False, 15, MaxHandSize, MaxTilesPlayed, NoOfEndOfTurnTiles);
      end;
  end;

begin
  Main();
end.