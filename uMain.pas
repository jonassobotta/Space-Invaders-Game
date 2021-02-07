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
    �berschrift: TImage;
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

  Spieler : TSpieler;

  Laser : TLaser;
  iLaserAnz : integer;
  bLaserKollision : boolean;

  Aliens : array of TAlien;

implementation

{$R *.dfm}



procedure TfrmMain.DeleteArrayElement(index: integer);
begin
  if index > High(Aliens) then Exit; //Ist der �bergebene Index gr��er als der h�chste Array index
  if index < Low(Aliens) then Exit;  //Ist der �bergebene Index kleiner als der niedrigste Array index
  if index = High(Aliens) then //H�chstes element --> kein Move n�tig
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
  Spieler := TSpieler.Create;
  Spieler.draw(frmMain);
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
  if Spieler.GetbMovingL = true then
    Spieler.SetiXpos(Spieler.GetiXpos - Spieler.GetiSpeed);

  if Spieler.GetbMovingR = true then
    Spieler.SetiXpos(Spieler.GetiXpos + Spieler.GetiSpeed);

  //�berpr�fen, ob Spieler an den Bildschirmrand st��t
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
