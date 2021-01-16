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

    procedure INIT;
    procedure imgStartenClick(Sender: TObject);
    procedure imgEinstellungenClick(Sender: TObject);
    procedure imgTutorialClick(Sender: TObject);
    procedure imgEndeClick(Sender: TObject);
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

//Hauptmenü Prcedures
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
showmessage('Was geht ab');
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
end;

end.
