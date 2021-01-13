program SpaceInvaders;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMain in 'uMain.pas' {FormMain},
  uEinstellungen in 'uEinstellungen.pas' {FormEinstellungen};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TFormEinstellungen, FormEinstellungen);
  Application.Run;
end.
