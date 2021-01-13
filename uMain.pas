//Space Invader Spiel
//Jonas Sobotta
//Maximilian Hauzel
//Leonardo Wafzig
//John Roppelt
unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls;

type
  TFormMain = class(TForm)
  procedure Initialisierung;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

  iSpeed : integer;

implementation

//Hier werden Variablen und Objekte initialisert, sofern erforderlich
procedure TFormMain.Initialisierung;
begin
  iSpeed := 5;
end;

{$R *.fmx}


end.
