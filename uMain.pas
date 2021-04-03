unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.jpeg,
  Vcl.StdCtrls, Vcl.Imaging.pngimage, uPlayer, uLaser, uAlien, ShellApi, mmSystem,
  Vcl.MPlayer;

type
  TfrmMain = class(TForm)
    MainMenu: TPanel;
    Hintergrudbild: TImage;
    Starten: TImage;
    Tutorial: TImage;
    Überschrift: TImage;
    Credits: TImage;
    Ende: TImage;
    tmrSpieler: TTimer;
    MainHintergrund: TImage;
    tmrLaser: TTimer;
    tmrAliens: TTimer;
    tmrAlienLaser: TTimer;
    panelWon: TPanel;
    btnNextLevel: TButton;
    lblLevel: TLabel;
    lblScore: TLabel;
    btnShop: TButton;
    panelShop: TPanel;
    btnSpeedUpgrade: TButton;
    btnLaserUpgrade: TButton;
    btnHealthUpgrade: TButton;
    btnShopExit: TButton;
    lblSpeedUpgrade: TLabel;
    lblHealthUpgrade: TLabel;
    lblLaserUpgrade: TLabel;
    lblShopCoins: TLabel;
    lblHealth: TLabel;
    panelLost: TPanel;
    YouLoose: TImage;
    YouLooseBackground: TImage;
    TryAgain: TImage;
    BackToMenu: TImage;
    RageQuit: TImage;
    YouWinBackground: TImage;
    YouWin: TImage;
    NextLevel: TImage;
    Back: TImage;
    Shop: TImage;
    Quit: TImage;
    ShopBackground: TImage;
    Engine: TImage;
    imgLaser: TImage;
    heart: TImage;

    procedure INIT(level : integer);
    procedure startenClick(Sender: TObject);
    procedure TutorialClick(Sender: TObject);
    procedure EndeClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure tmrSpielerTimer(Sender: TObject);
    procedure tmrLaserTimer(Sender: TObject);
    procedure tmrAliensTimer(Sender: TObject);
    procedure DeleteArrayElement(index : integer);
    procedure tmrAlienLaserTimer(Sender: TObject);
    procedure btnNextLevelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnShopClick(Sender: TObject);
    procedure btnSpeedUpgradeClick(Sender: TObject);
    procedure btnShopExitClick(Sender: TObject);
    procedure btnLaserUpgradeClick(Sender: TObject);
    procedure btnHealthUpgradeClick(Sender: TObject);

  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frmMain : TfrmMain;
  CurrentLevel : integer;

  Player : TPlayer;
  coins, SpeedUpgrade, LaserUpgrade, HealthUpgrade : integer;

  Laser : TLaser;
  LaserAnz : integer;
  LaserKollision : boolean;

  Aliens : array of TAlien;
  AlienLaser : array of TLaser;

implementation

{$R *.dfm}

//Hauptmenü
procedure TfrmMain.EndeClick(Sender: TObject);
begin
IF MessageDlg ('Schon aufgeben, oder was???',mtConfirmation,[mbYes,mbNo,mbCancel],0)=mrYes
  THEN Close;
end;

procedure TfrmMain.startenClick(Sender: TObject);
begin
MainMenu.Visible := false;
CurrentLevel := 1;
SndPlaySound(Pchar('Sounds\ButtonClick.wav'), SND_ASync )  ;
INIT(CurrentLevel);
end;

procedure TfrmMain.TutorialClick(Sender: TObject);
begin
ShellExecute(handle, 'open', PChar('tutorial.html'), nil, nil, SW_SHOW);
SndPlaySound(Pchar('Sounds\ButtonClick.wav'), SND_ASync )  ;
end;

//Next Level
procedure TfrmMain.btnNextLevelClick(Sender: TObject);
begin
  SndPlaySound(Pchar('Sounds\ButtonClick.wav'), SND_ASync )  ;
  panelWon.Visible := false;
  CurrentLevel := CurrentLevel + 1;
  if CurrentLevel = 4 then
  begin
    ShowMessage('Du hast gewonnen !');
    MainMenu.Visible := true;
  end
  else
    Init(CurrentLevel);
end;

//Shop öffnen
procedure TfrmMain.btnShopClick(Sender: TObject);
begin
  SndPlaySound(Pchar('Sounds\ButtonClick.wav'), SND_ASync )  ;
  panelShop.Visible := true;
  panelWon.Visible := false;
  lblShopCoins.Caption := IntToStr(Coins);
  lblSpeedUpgrade.Caption := IntToStr(1000 * SpeedUpgrade);
  lblLaserUpgrade.Caption := IntToStr(1000 * LaserUpgrade);
  lblHealthUpgrade.Caption := IntToStr(1000 * HealthUpgrade);
end;

//Shop verlassen
procedure TfrmMain.btnShopExitClick(Sender: TObject);
begin
  SndPlaySound(Pchar('Sounds\ButtonClick.wav'), SND_ASync )  ;
  panelShop.Visible := false;
  panelWon.Visible := true;
end;

//Speed Upgrade
procedure TfrmMain.btnSpeedUpgradeClick(Sender: TObject);
begin
  SndPlaySound(Pchar('Sounds\ButtonClick.wav'), SND_ASync )  ;
  if Coins >= 1000 * SpeedUpgrade then
  begin
    Coins := Coins - 1000 * SpeedUpgrade;
    Player.SetSpeed(Player.GetSpeed + 3);
    ShowMessage('Speed Upgraded!');
    SpeedUpgrade := SpeedUpgrade + 1;
    lblSpeedUpgrade.Caption := IntToStr(1000 * SpeedUpgrade);
    lblShopCoins.Caption := IntToStr(Coins);
  end
  else
    ShowMessage('Not enough Coins !');
end;

//Laser Upgrade
procedure TfrmMain.btnLaserUpgradeClick(Sender: TObject);
begin
  SndPlaySound(Pchar('Sounds\ButtonClick.wav'), SND_ASync )  ;
  if Coins >= 1000 * LaserUpgrade then
  begin
    Coins := Coins - 1000 * LaserUpgrade;
    Laser.SetSpeed(Laser.GetSpeed + 1);
    ShowMessage('Laser Upgraded!');
    LaserUpgrade := LaserUpgrade + 1;
    lblLaserUpgrade.Caption := IntToStr(1000 * LaserUpgrade);
    lblShopCoins.Caption := IntToStr(Coins);
  end
  else
    ShowMessage('Not enough Coins !');
end;

//Health Upgrade
procedure TfrmMain.btnHealthUpgradeClick(Sender: TObject);
begin
SndPlaySound(Pchar('Sounds\ButtonClick.wav'), SND_ASync )  ;
if Coins >= 1000 * HealthUpgrade then
  begin
    Coins := Coins - 1000 * HealthUpgrade;
    Player.SetLives(Player.GetLives + 50);
    ShowMessage('Health Upgraded!');
    HealthUpgrade := HealthUpgrade + 1;
    lblHealthUpgrade.Caption := IntToStr(1000 * HealthUpgrade);
    lblShopCoins.Caption := IntToStr(Coins);
  end
  else
    ShowMessage('Not enough Coins !');
end;



//Array Element löschen und Array kürzen
procedure TfrmMain.DeleteArrayElement(index: integer);
begin
  if index > High(Aliens) then Exit; //Ist der übergebene Index größer als der höchste Array index
  if index < Low(Aliens) then Exit;  //Ist der übergebene Index kleiner als der niedrigste Array index
  if index = High(Aliens) then //Höchstes element --> kein Move nötig
  begin
    SetLength(Aliens, Length(Aliens) - 1);
    Exit;
  end;
  System.Move(Aliens[Index +1], Aliens[Index],(Length(Aliens) - Index -1) * SizeOf(string) + 1);
  SetLength(Aliens, Length(Aliens) - 1);
end;

//Initalisierung
procedure TfrmMain.INIT(level : integer);
var i, maxAlienLaser,  AlienPosX, AlienPosY, sA, AlienSpeed: integer;
    AlienGFX : string;
begin

  //Label
  lblLevel.Caption := 'Level ' + IntToStr(CurrentLevel);
  lblScore.Caption := 'Coins: ' + IntToStr(Coins);

  //Spieler
  if level =  1 then
  begin
    Player := TPlayer.Create(frmMain);
    Player.Render(frmMain, 425, 650, 96, 126, 'Grafiken/Player.png');
    tmrSpieler.Enabled := true;
  end;

  if HealthUpgrade >= 2 then
    Player.SetLives(100 + (HealthUpgrade - 1) * 50)
  else
    Player.SetLives(100);
  lblHealth.Caption := 'Health ' + IntToStr(Player.GetLives);

  //Laser
  LaserAnz := 0;

  //Aliens
  AlienPosX := 80;
  AlienPOsY := 80;
  SetLength(Aliens, 20);
  maxAlienLaser := 1 + level;

  if level = 1 then
  begin
    AlienGFX := 'Grafiken/Alien1.png';
    AlienSpeed := 1;
  end
  else if level = 2 then
  begin
    ALienGFX := 'Grafiken/Alien2.png';
    AlienSpeed := 2;
  end
  else if level = 3 then
  begin
    ALienGFX := 'Grafiken/Alien3.png';
    AlienSpeed := 3;
  end;


  //Aliens auf Bildschirm rendern
  for i := Low(Aliens) to High(Aliens) do
  begin
      Aliens[i] := TAlien.Create(frmMain);
      Aliens[i].Render(frmMain, AlienPosX, AlienPosY, 64, 64, AlienGFX);
      Aliens[i].SetSpeed(AlienSpeed);
      AlienPosX := ALienPosX + 84;

      if Aliens[i].Left + Aliens[i].Width >= 900 then
      begin
        AlienPosY := AlienPosY + 74;
        AlienPosX := 80;
      end;
  end;

  //Alien Laser erzeugen
  Randomize;
  sA := Random(Length(Aliens) - 1) + 0;
  SetLength(AlienLaser, maxAlienLaser);

  for i := Low(AlienLaser) to High(AlienLaser) do
  begin
    sA := Random(Length(Aliens));
    AlienLaser[i] := TLaser.Create(frmMain);
    AlienLaser[i].Render(frmMain, Aliens[sA].Left + (Round(Aliens[sA].Width / 2)), ALiens[sA].Top + Aliens[sA].Height, 'Grafiken/AlienLaser.png');
    AlienLaser[i].SetSpeed(3);
  end;

  tmrAliens.Enabled := true;
  tmrAlienLaser.Enabled := true;
end;

//Alien Timer
procedure TfrmMain.tmrAliensTimer(Sender: TObject);
var
  i, j : Integer;
begin
  //Aliens bewegen

  if Length(Aliens) = 0 then
  begin
    SndPlaySound(Pchar('Sounds\Sieg.wav'), SND_ASync )  ; //Siegsong
    tmrAliens.Enabled := false;
    tmrAlienLaser.Enabled := false;
    for i := Low(AlienLaser) to High(ALienLaser) do
      ALienLaser[i].free;
    panelWon.Visible := true;
  end;

  for i := Low(Aliens) to High(Aliens) do
  begin
    if length(Aliens) = 5  then Aliens[i].SetSpeed(5);
    if Length(Aliens) = 1  then Aliens[i].SetSpeed(7);
    if Aliens[i].Top >= 550 then
    begin
      panelLost.visible := true;

      for j := Low(AlienLaser) to High(AlienLaser) do AlienLaser[i].Free;

      tmrAlienLaser.Enabled := false;
      tmrAliens.Enabled := false;
    end;

    if Aliens[i].Left <= 0 then
      begin
        for j := Low(Aliens) to High(Aliens) do
        begin
          Aliens[j].Top := (Aliens[j].Top + 15);
          Aliens[j].SetDirection(1);
        end;
      end;
    if Aliens[i].Left + Aliens[i].Width >= 1000 then
      begin
        for j := Low(Aliens) to High(Aliens) do
        begin
          Aliens[j].Top := (Aliens[j].Top + 30);
          Aliens[j].SetDirection(-1);
        end;
    end;
  end;


  for i := Low(Aliens) to High(Aliens) do
    Aliens[i].Left := Aliens[i].Left + Aliens[i].GetSpeed * Aliens[i].GetDirection;
end;

//Alien Laser Timer
procedure TfrmMain.tmrAlienLaserTimer(Sender: TObject);
var i, sA : integer;
begin
  for i := Low(AlienLaser) to High(AlienLaser) do
    AlienLaser[i].Top := AlienLaser[i].Top + AlienLaser[i].GetSpeed;

  //Kollision mit Bildschirmrand
  for i := Low(AlienLaser) to High(AlienLaser) do
  begin
    if AlienLaser[i].Top - 30 >= 800 then
    begin
      Randomize;
      sA := Random(Length(Aliens));
      AlienLaser[i].Top := Aliens[sA].Top + Aliens[sA].Height;
      AlienLaser[i].Left := Aliens[sA].Left + Round(Aliens[sA].Width / 2);
    end;
  end;

  //Kollision mit Spieler
  for i := Low(AlienLaser) to High(AlienLaser) do
  begin
    if (AlienLaser[i].Left >= Player.Left) and (AlienLaser[i].Left <= Player.Left + Player.Width) and
        (AlienLaser[i].Top - AlienLaser[i].Height >= Player.Top) then
    begin
      AlienLaser[i].Top := 900;
      Player.SetLives(Player.GetLives - 25);
      lblHealth.Caption := 'Health ' + IntToStr(Player.GetLives);
      if Player.GetLives <= 0 then
      begin
        //YouLoose.Visisble := true;
        SndPlaySound(Pchar('Sounds\Verloren.wav'), SND_ASync )  ; //Verloren
        tmrAlienLaser.Enabled := false;
        tmrAliens.Enabled := false;
        AlienLaser[i].Free;
      end;
    end;
  end;

end;

//Laser Timer
procedure TfrmMain.tmrLaserTimer(Sender: TObject);
var i : integer;
begin

  //Laser bewegen
  Laser.Top := Laser.Top - Laser.GetSpeed;

  //Laser trifft bildschirmrand
  if Laser.Top <= 0then
  begin
    LaserAnz := 0;
    tmrLaser.Enabled := false;
    Laser.Free;
  end;

  try
  //Laser trifft Alien
  for i := Low(Aliens) to High(Aliens) do
  begin
      if (Laser.Top <= Aliens[i].Top) and ((Laser.Left >= Aliens[i].Left) and
         (Laser.Left + Laser.width <= Aliens[i].Left + Aliens[i].Width)) then
          begin
            SndPlaySound(Pchar('Sounds\getroffen.wav'), SND_ASync )  ;   //Sound für Alien getroffen
            Coins := Coins + 100;
            lblScore.Caption := 'Coins: ' + IntToStr(Coins);
            Aliens[i].Free;
            DeleteArrayElement(i);
            LaserAnz := 0;
            tmrLaser.Enabled := false;
            Laser.Free;
          end;
  end;
  except
    on exception do
    begin
      Coins := Coins - 100;
      lblScore.Caption := 'Coins: ' + IntToStr(Coins);
    end;
  end;
end;

//Spieler Timer
procedure TfrmMain.tmrSpielerTimer(Sender: TObject);
begin
  //Spieler bewegen
  if Player.GetMovingL = true then
    Player.Left := Player.Left - Player.GetSpeed;

  if Player.GetMovingR = true then
    Player.Left := Player.Left + Player.GetSpeed;

  //Überprüfen, ob Spieler an den Bildschirmrand stößt
  if PLayer.Left <= 0 then
  begin
    Player.Left := 0;
    Player.SetMovingL(false);
  end
  else if Player.Left > 0 then
    Player.SetBorderL(false);

  if Player.Left >= 910 then
  begin
    Player.Left := 910;
    Player.SetMovingR(false);
  end
  else if Player.Left > 910 then
    Player.SetBorderR(false);
end;


procedure TfrmMain.FormCreate(Sender: TObject);
begin
  SndPlaySound(Pchar('Sounds\Hauptmenu.wav'), SND_ASync )  ;
  Coins := 0;
  SpeedUpgrade := 1;
  LaserUpgrade := 1;
  HealthUpgrade := 1;
end;

//Tasteneingabe
procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  LaserHeight: integer;
begin
  //Spieler Bewegung
  if (Key = vk_Left) and (player.GetBorderL = false) then
    Player.SetMovingL(true);

  if (Key = vk_Right) and (Player.GetBorderR = false) then
    Player.SetMovingR(true);

  if Key = vk_Up then
  begin
    ShowMessage(IntToStr(Length(Aliens)));
  end;
  //Laser
  LaserHeight := 30;
  if (Key = vk_Space) and (LaserAnz = 0) then
  begin
      Laser := TLaser.Create(frmMain);
      Laser.Render(frmMain, Player.Left + Round(Player.Width/2), (Player.Top - LaserHeight), 'Grafiken/Laser.png');
      Laser.SetSpeed(12);
      LaserAnz := LaserAnz + 1;
      LaserKollision := false;
      tmrLaser.Enabled := true;
      SndPlaySound(Pchar('Sounds\Schuss.wav'), SND_ASYNC );
  end;
end;

procedure TfrmMain.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
//Bewegung
  if Key = vk_Left then
    Player.SetMovingL(false);

  if Key = vk_Right then
    Player.SetMovingR(false);
end;

end.
