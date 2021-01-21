unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.jpeg,
  Vcl.StdCtrls, Vcl.Imaging.pngimage, uSpieler, uLaser, uAlien;

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
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frmMain : TfrmMain;

  //Spieler
  Spieler : TSpieler;

  //Laser
  Laser : TLaser;
  iLaserAnz : integer;
  bLaserKollision : boolean;

  //Aliens
  Aliens : array[1..2, 1..10] of TAlien;

implementation

{$R *.dfm}



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
var i, j, iAlienPosX, iAlienPosY: integer;
begin
  //Spieler
  Spieler := TSpieler.Create;
  Spieler.draw(frmMain);
  tmrSpieler.Enabled := true;

  //Laser
  Laser := TLaser.Create;
  Laser.draw(frmMain);
  iLaserAnz := 0;

  //Aliens
  iAlienPosX := 40;
  iAlienPOsY := 10;

  for i := 1 to 2 do
  begin
    for j := 1 to 10 do
    begin
      Aliens[i][j] := TAlien.Create;
      Aliens[i][j].draw(frmMain);
      Aliens[i][j].SetiXpos(iAlienPosX);
      Aliens[i][j].SetiYpos(iAlienPosY);
      iAlienPosX := iALienPosX + 84;
    end;
    iAlienPosX := 40;
    iAlienPosY := iAlienPosY + 74;
  end;

  tmrAliens.Enabled := true;
end;

procedure TfrmMain.tmrAliensTimer(Sender: TObject);
var
  i, j: Integer;
begin
  //Aliens bewegen
  if Aliens[1][1].GetiXpos <= 0 then
  begin
    for i := 1 to 2 do
    begin
      for j := 1 to 10 do
      begin
        Aliens[i][j].SetiYpos(Aliens[i][j].GetiYpos + 10);
        Aliens[i][j].SetiRichtung(1);
      end;
    end;
  end;
  if Aliens[1][10].GetiXpos + Aliens[1][10].GetiWidth >= 900 then
  begin
    for i := 1 to 2 do
    begin
      for j := 1 to 10 do
      begin
        Aliens[i][j].SetiYpos(Aliens[i][j].GetiYpos + 10);
        Aliens[i][j].SetiRichtung(-1);
      end;
    end;
  end;

  for i := 1 to 2 do
  begin
    for j := 1 to 10 do
      Aliens[i][j].SetiXpos(Aliens[i][j].GetiXpos + Aliens[i][j].GetiSpeed * Aliens[i][j].GetiRichtung);
  end;

end;

procedure TfrmMain.tmrLaserTimer(Sender: TObject);
var i, j : integer;
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

  if Laser.GetiYpos <= 0then
    bLaserKollision := true;

  for i := 1 to 2 do
  begin
    for j := 1 to 10 do
    begin
      if (Laser.GetiYpos <= Aliens[i][j].GetiYpos) and ((Laser.GetiXpos >= Aliens[i][j].GetiXpos) and
         (Laser.GetiXpos + Laser.GetiWidth <= Aliens[i][j].GetiXpos + Aliens[i][j].GetiWidth)) and (Aliens[i][j].GetbGetroffen = false) then
          begin
            iLaserAnz := 0;
            Laser.SetiXpos(-20);
            Laser.SetiYpos(-20);
            tmrLaser.Enabled := false;
            Aliens[i][j].SetbGetroffen(true);
            Aliens[i][j].GetimgBox.Picture := nil;
          end;

    end;
  end;

end;

procedure TfrmMain.tmrSpielerTimer(Sender: TObject);
begin
//Spieler bewegen
  if Spieler.GetbMovingL = true then
    Spieler.SetiXpos(Spieler.GetiXpos - Spieler.GetiSpeed);

  if Spieler.GetbMovingR = true then
    Spieler.SetiXpos(Spieler.GetiXpos + Spieler.GetiSpeed);

  //Überprüfen, ob Spieler an den Bildschirmrand stößt
  if Spieler.GetiXpos <= 0 then
  begin
    Spieler.SetiXpos(0);
    Spieler.SetbMovingL(false);
  end
  else if Spieler.GetiXpos > 0 then
    Spieler.SetbBorderL(false);

  if Spieler.GetiXpos >= 810 then
  begin
    Spieler.SetiXpos(810);
    Spieler.SetbMovingR(false);
  end
  else if Spieler.GetiXpos > 810 then
    Spieler.SetbBorderR(false);
end;

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
//Bewegung
  if (Key = vk_Left) and (Spieler.GetbBorderL = false) then
    Spieler.SetbMovingL(true);

  if (Key = vk_Right) and (Spieler.GetbBorderR = false) then
    Spieler.SetbMovingR(true);

  //Laser
  if (Key = vk_Space) and (iLaserANz = 0) then
  begin
      Laser.SetiXpos(Round(Spieler.GetiXpos + Spieler.GetiWidth / 2));
      Laser.SetiYpos(Spieler.GetiYpos - Laser.GetiHeight);
      iLaserAnz := iLaserAnz + 1;
      bLaserKollision := false;
      tmrLaser.Enabled := true;
  end;
end;

procedure TfrmMain.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
//Bewegung
  if Key = vk_Left then
    Spieler.SetbMovingL(false);

  if Key = vk_Right then
    Spieler.SetbMovingR(false);
end;


end.
