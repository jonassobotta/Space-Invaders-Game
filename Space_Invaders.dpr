program Space_Invaders;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {frmMain},
  uLaser in 'uLaser.pas',
  uPlayer in 'uPlayer.pas',
  uAlien in 'uAlien.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
