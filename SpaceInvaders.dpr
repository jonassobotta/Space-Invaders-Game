program SpaceInvaders;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMain in 'uMain.pas' {FormMain},
  uSpieler in 'uSpieler.pas',
  uAliens in 'uAliens.pas',
  uLaser in 'uLaser.pas',
  uEinstellungen in 'uEinstellungen.pas' {FormEinstellungen},
  uMenu in 'uMenu.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TFormEinstellungen, FormEinstellungen);
  Application.Run;
end.
