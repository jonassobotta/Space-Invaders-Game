unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.jpeg,
  Vcl.StdCtrls, Vcl.Imaging.pngimage, uSpieler;

type
  TfrmMain = class(TForm)
    MainMenu: TPanel;
    lblTitel: TLabel;
    imgMMHintergrund: TImage;
    lblCredits: TLabel;
    imgStarten: TImage;
    imgEinstellungen: TImage;
    imgTutorial: TImage;
    imgEnde: TImage;
    imgHintergrund: TImage;
    tmrSpieler: TTimer;

    procedure INIT;
    procedure imgStartenClick(Sender: TObject);
    procedure imgEinstellungenClick(Sender: TObject);
    procedure imgTutorialClick(Sender: TObject);
    procedure imgEndeClick(Sender: TObject);
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
  Spieler : TSpieler;

implementation

{$R *.dfm}

//Hauptmenü
procedure TfrmMain.imgEinstellungenClick(Sender: TObject);
begin
showmessage('Kranke Sachen einstellen');
end;

procedure TfrmMain.imgEndeClick(Sender: TObject);
begin
IF MessageDlg ('Schon aufgeben, oder was???',mtConfirmation,[mbYes,mbNo,mbCancel],0)=mrYes
  THEN Close;
end;

procedure TfrmMain.imgStartenClick(Sender: TObject);
begin
MainMenu.Visible := false;
INIT;
end;

procedure TfrmMain.imgTutorialClick(Sender: TObject);
begin
showmessage('Wir zeigen euch wies geht');
end;

//Initalisierung
procedure TfrmMain.INIT;
begin
  Spieler := TSpieler.Create;
  Spieler.draw(frmMain);
  tmrSpieler.Enabled := true;
end;

procedure TfrmMain.tmrSpielerTimer(Sender: TObject);
begin
  //Spieler bewegen
  if Spieler.GetbMovingL = true then
    Spieler.SetiXpos(Spieler.GetiXpos - Spieler.GetiSpeed);

  if Spieler.GetbMovingR = true then
    Spieler.SetiXpos(Spieler.GetiXpos + Spieler.GetiSpeed);

  //Überprüfen, ob Spieler an den Bildschirmrand stößt
end;

//Tasteneingabe
procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = vk_Left) and (Spieler.GetbBorderL = false) then
    Spieler.SetbMovingL(true);

  if (Key = vk_Right) and (Spieler.GetbBorderR = false) then
    Spieler.SetbMovingR(true);
end;

procedure TfrmMain.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_Left then
    Spieler.SetbMovingL(false);

  if Key = vk_Right then
    Spieler.SetbMovingR(false);
end;
end.
