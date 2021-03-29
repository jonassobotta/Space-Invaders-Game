unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.jpeg,
  Vcl.StdCtrls, Vcl.Imaging.pngimage, uPlayer, uLaser, uAlien;

type
  TfrmMain = class(TForm)
    MainMenu: TPanel;
    Hintergrudbild: TImage;
    Starten: TImage;
    Tutorial: TImage;
    Überschrift: TImage;
    Credits: TImage;
    Einstellungen: TImage;
    Ende: TImage;
    tmrSpieler: TTimer;
    MainHintergrund: TImage;
    tmrLaser: TTimer;
    tmrAliens: TTimer;
    tmrAlienLaser: TTimer;

    procedure INIT;
    procedure startenClick(Sender: TObject);
    procedure EinstellungenClick(Sender: TObject);
    procedure TutorialClick(Sender: TObject);
    procedure EndeClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure tmrSpielerTimer(Sender: TObject);
    procedure tmrLaserTimer(Sender: TObject);
    procedure tmrAliensTimer(Sender: TObject);
    procedure DeleteArrayElement(index : integer);
    procedure tmrAlienLaserTimer(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frmMain : TfrmMain;

  Player : TPlayer;

  Laser : TLaser;
  LaserAnz : integer;
  LaserKollision : boolean;

  Aliens : array of TAlien;
  AlienLaser : array of TLaser;
  maxAlienLaser, ALC : integer;

implementation

{$R *.dfm}

//Hauptmenü
procedure TfrmMain.EinstellungenClick(Sender: TObject);
begin
showmessage('Kranke Sachen einstellen');
end;

procedure TfrmMain.EndeClick(Sender: TObject);
begin
IF MessageDlg ('Schon aufgeben, oder was???',mtConfirmation,[mbYes,mbNo,mbCancel],0)=mrYes
  THEN Close;
end;

procedure TfrmMain.startenClick(Sender: TObject);
begin
MainMenu.Visible := false;
INIT;
end;

procedure TfrmMain.TutorialClick(Sender: TObject);
begin
showmessage('Wir zeigen euch wies geht');
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
  Finalize(Aliens[Index]);
  System.Move(Aliens[Index +1], Aliens[Index],(Length(Aliens) - Index -1) * SizeOf(string) + 1);
  SetLength(Aliens, Length(Aliens) - 1);
end;

//Initalisierung
procedure TfrmMain.INIT;
var i, AlienPosX, AlienPosY: integer;
begin
  //Spieler
  Player := TPlayer.Create(frmMain);
  Player.Render(frmMain, 425, 500, 96, 96, 'Grafiken/Player.png');
  tmrSpieler.Enabled := true;

  //Laser
  LaserAnz := 0;

  //Aliens
  AlienPosX := 40;
  AlienPOsY := 10;
  SetLength(Aliens, 20);
  maxAlienLaser := 5;
  ALC := 0;

  //Aliens auf Bildschirm rendern
  for i := Low(Aliens) to High(Aliens) do
  begin
      Aliens[i] := TAlien.Create(frmMain);
      Aliens[i].Render(frmMain, AlienPosX, AlienPosY, 64, 64, 'Grafiken/Alien1.png');
      AlienPosX := ALienPosX + 84;

      if Aliens[i].Left + Aliens[i].Width >= 810 then
      begin
        AlienPosY := AlienPosY + 74;
        AlienPosX := 40;
      end;
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
    tmrAliens.Enabled := false;
    //Siegsbildschirm einblenden
    //...
  end;

  //Abfragen ob Spieler verloren hatt
  //...
  //

  for i := Low(Aliens) to High(Aliens) do
  begin
    if Length(Aliens) = 10 then Aliens[i].SetSpeed(3);
    if length(Aliens) = 5  then Aliens[i].SetSpeed(5);
    if Length(Aliens) = 1  then Aliens[i].SetSpeed(7);

    if Aliens[i].Left <= 0 then
      begin
        for j := Low(Aliens) to High(Aliens) do
        begin
          Aliens[j].Top := (Aliens[j].Top + 10);
          Aliens[j].SetDirection(1);
        end;
      end;
    if Aliens[i].Left + Aliens[i].Width >= 900 then
      begin
        for j := Low(Aliens) to High(Aliens) do
        begin
          Aliens[j].Top := (Aliens[j].Top + 10);
          Aliens[j].SetDirection(-1);
        end;
    end;
  end;


  for i := Low(Aliens) to High(Aliens) do
    Aliens[i].Left := Aliens[i].Left + Aliens[i].GetSpeed * Aliens[i].GetDirection;
end;

//Alien Laser Timer
procedure TfrmMain.tmrAlienLaserTimer(Sender: TObject);
var ShootingAlien, HalfOfALiens, i, LaserHeight : integer;
begin
  Randomize;
  ShootingAlien := Random(Length(Aliens) - 1) + 0;

  if ALC < maxAlienLaser then
  begin
    //überprüfen, ob vor dem schießenden Alien noch ein anderes Alien ist
    HalfOfALiens := Round(Length(Aliens) / 2) - 1;

    if (ShootingAlien < HalfOfAliens) and ((Aliens[ShootingAlien].Height + 20) >= Aliens[HalfOfALiens].Top) and
       (Aliens[ShootingAlien].Left + Aliens[ShootingAlien].Width <= Aliens[HalfOfALiens].Left + Aliens[HalfOfALiens].Width) then
          exit
    else
       begin
          //Alien Laser erzeugen
          ALC := ALC + 1;
          SetLength(AlienLaser, ALC);
          LaserHeight := 30;
          for i := Low(AlienLaser) to High(AlienLaser) do
          begin
            AlienLaser[i] := TLaser.Create(frmMain);
            AlienLaser[i].Render(frmMain, Aliens[ShootingAlien].Left + (Round(Aliens[ShootingAlien].Width / 2)), ALiens[ShootingAlien].Top + Aliens[ShootingAlien].Height, 'Grafiken/AlienLaser.png');
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

  //Kollisionsabfragen
  if LaserKollision then
  begin
    LaserAnz := 0;
    tmrLaser.Enabled := false;
    Laser.Free;
  end;

  //Laser trifft bildschirmrand
  if Laser.Top <= 0then
    LaserKollision := true;

  //Laser trifft Alien
  for i := Low(Aliens) to High(Aliens) do
  begin
      if (Laser.Top <= Aliens[i].Top) and ((Laser.Left >= Aliens[i].Left) and
         (Laser.Left + Laser.width <= Aliens[i].Left + Aliens[i].Width)) then
          begin
            LaserKollision := True;
            Aliens[i].Free;
            DeleteArrayElement(i);
            //Sound für Alien getroffen
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

  if Player.Left >= 810 then
  begin
    Player.Left := 810;
    Player.SetMovingR(false);
  end
  else if Player.Left > 810 then
    Player.SetBorderR(false);
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

  //Laser
  LaserHeight := 30;
  if (Key = vk_Space) and (LaserAnz = 0) then
  begin
      Laser := TLaser.Create(frmMain);
      Laser.Render(frmMain, Player.Left + Round(Player.Width/2), (Player.Top - LaserHeight), 'Grafiken/Laser.png');
      LaserAnz := LaserAnz + 1;
      LaserKollision := false;
      tmrLaser.Enabled := true;
      //Hier kann Sound eingebaut werden
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
