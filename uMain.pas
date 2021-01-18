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

    procedure INIT;
    procedure startenClick(Sender: TObject);
    procedure EinstellungenClick(Sender: TObject);
    procedure TutorialClick(Sender: TObject);
    procedure EndeClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure tmrSpielerTimer(Sender: TObject);
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
  bShooting : boolean;

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
  Laser := TLaser.Create;
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
  if Key = vk_Space then
  begin
    bShooting := true;
  end;
end;

procedure TfrmMain.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
//Bewegung
  if Key = vk_Left then
    Spieler.SetbMovingL(false);

  if Key = vk_Right then
    Spieler.SetbMovingR(false);

  //Laser
  if Key = vk_Space then
    bShooting := false;
end;


end.
