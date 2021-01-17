program Space_Invaders;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {frmMain},
  uSpieler in 'uSpieler.pas',
  uLaser in 'uLaser.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
