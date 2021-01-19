unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.jpeg,
  Vcl.StdCtrls, Vcl.Imaging.pngimage, uSpieler, uLaser;

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

    procedure INIT;
    procedure startenClick(Sender: TObject);
    procedure EinstellungenClick(Sender: TObject);
    procedure TutorialClick(Sender: TObject);
    procedure EndeClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure tmrSpielerTimer(Sender: TObject);
    procedure tmrLaserTimer(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frmMain : TfrmMain;
  //Spieler
  Spieler : TSpieler;
  Laser : TLaser;
  iLaserAnz : integer;
  bLaserKollision : boolean;

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
begin
  //Spieler
  Spieler := TSpieler.Create;
  Spieler.draw(frmMain);
  tmrSpieler.Enabled := true;

  //Laser
  Laser := TLaser.Create;
  Laser.draw(frmMain);
  iLaserAnz := 0;
end;

procedure TfrmMain.tmrLaserTimer(Sender: TObject);
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
