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
    procedure DeleteArrayElement(index : integer);
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
  Aliens : array of TAlien;

implementation

{$R *.dfm}



procedure TfrmMain.DeleteArrayElement(index: integer);
begin
  if index > High(Aliens) then Exit;
  if index < Low(Aliens) then Exit;
  if index = High(Aliens) then
  begin
    SetLength(Aliens, Length(Aliens) - 1);
    Exit;
  end;
  Finalize(Aliens[Index]);
  System.Move(Aliens[Index +1], Aliens[Index],
  (Length(Aliens) - Index -1) * SizeOf(string) + 1);
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
var i, iAlienPosX, iAlienPosY: integer;
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
  SetLength(Aliens, 20);

  for i := Low(Aliens) to High(Aliens) do
  begin
      Aliens[i] := TAlien.Create;
      Aliens[i].draw(frmMain);
      Aliens[i].SetiXpos(iAlienPosX);
      Aliens[i].SetiYpos(iAlienPosY);
      iAlienPosX := iALienPosX + 84;

      if Aliens[i].GetimgBox.Left + Aliens[i].GetiWidth >= 810 then
      begin
        iAlienPosY := iAlienPosY + 74;
        iAlienPosX := 40;
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
    if Length(Aliens) = 10 then Aliens[i].SetiSpeed(10);
    if length(Aliens) = 5  then Aliens[i].SetiSpeed(15);
    if Length(Aliens) = 1  then Aliens[i].SetiSpeed(20);
    
    if Aliens[i].GetiXpos <= 0 then
      begin
        for j := Low(Aliens) to High(Aliens) do
        begin
          Aliens[j].SetiYpos(Aliens[j].GetiYpos + 10);
          Aliens[j].SetiRichtung(1);
        end;
      end;
    if Aliens[i].GetiXpos + Aliens[i].GetiWidth >= 900 then
      begin
        for j := Low(Aliens) to High(Aliens) do
        begin
          Aliens[j].SetiYpos(Aliens[j].GetiYpos + 10);
          Aliens[j].SetiRichtung(-1);
        end;
    end;
  end;


  for i := Low(Aliens) to High(Aliens) do
    Aliens[i].SetiXpos(Aliens[i].GetiXpos + Aliens[i].GetiSpeed * Aliens[i].GetiRichtung);

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

  if Laser.GetiYpos <= 0then
    bLaserKollision := true;

  //Laser trifft Alien
  for i := Low(Aliens) to High(Aliens) do
  begin
      if (Laser.GetiYpos <= Aliens[i].GetiYpos) and ((Laser.GetiXpos >= Aliens[i].GetiXpos) and
         (Laser.GetiXpos + Laser.GetiWidth <= Aliens[i].GetiXpos + Aliens[i].GetiWidth)) and (Aliens[i].GetbGetroffen = false) then
          begin
            iLaserAnz := 0;
            Laser.SetiXpos(-20);
            Laser.SetiYpos(-20);
            tmrLaser.Enabled := false;
            Aliens[i].GetimgBox.Destroy;
            Aliens[i].Destroy;
            DeleteArrayElement(i);
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
