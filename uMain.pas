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
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frmMain : TfrmMain;

  Player : TPlayer;

  Laser : TLaser;
  iLaserAnz : integer;
  bLaserKollision : boolean;

  Aliens : array of TAlien;

implementation

{$R *.dfm}



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

//Initalisierung
procedure TfrmMain.INIT;
var i, AlienPosX, AlienPosY: integer;
begin
  //Spieler
  Player := TPlayer.Create(frmMain);
  Player.Render(frmMain, 425, 500, 96, 96, 'Grafiken/Player.png');
  tmrSpieler.Enabled := true;

  //Laser
  Laser := TLaser.Create;
  Laser.draw(frmMain);
  iLaserAnz := 0;

  //Aliens
  AlienPosX := 40;
  AlienPOsY := 10;
  SetLength(Aliens, 20);

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
end;

procedure TfrmMain.tmrAliensTimer(Sender: TObject);
var
  i, j : Integer;
begin
  //Aliens bewegen
  if Length(Aliens) = 0 then tmrAliens.Enabled := false;


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

procedure TfrmMain.tmrLaserTimer(Sender: TObject);
var i : integer;
begin

  //Laser bewegen
  Laser.SetiYpos(Laser.GetiYpos - Laser.GetiSpeed);

  //Kollisionsabfragen
  if bLaserKollision then
  begin
    iLaserAnz := 0;
    Laser.SetiXpos(-20);
    Laser.SetiYpos(-20);
    tmrLaser.Enabled := false;
  end;

  //Laser trifft bildschirmrand
  if Laser.GetiYpos <= 0then
    bLaserKollision := true;

  //Laser trifft Alien
  for i := Low(Aliens) to High(Aliens) do
  begin
      if (Laser.GetiYpos <= Aliens[i].Top) and ((Laser.GetiXpos >= Aliens[i].Left) and
         (Laser.GetiXpos + Laser.GetiWidth <= Aliens[i].Left + Aliens[i].Width)) then
          begin
            iLaserAnz := 0;
            Laser.SetiXpos(-20);
            Laser.SetiYpos(-20);
            tmrLaser.Enabled := false;
            Aliens[i].Free;
            DeleteArrayElement(i);
          end;
  end;

end;

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

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
//Bewegung
  if (Key = vk_Left) and (player.GetBorderL = false) then
    Player.SetMovingL(true);

  if (Key = vk_Right) and (Player.GetBorderR = false) then
    Player.SetMovingR(true);

  //Laser
  if (Key = vk_Space) and (iLaserANz = 0) then
  begin
      Laser.SetiXpos(Round(Player.Left + Player.Width / 2));
      Laser.SetiYpos(Player.Top - Laser.GetiHeight);
      iLaserAnz := iLaserAnz + 1;
      bLaserKollision := false;
      tmrLaser.Enabled := true;
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
