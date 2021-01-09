//Hauptfenster mit dem eigentlichen Spiel
//Main Unit, verwaltet alle anderen Units
//
unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls;

type
  TFormMain = class(TForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

uses uSpieler, uAliens, uLaser, uEinstellungen, uMenu; //Andere Units einbinden und deren VAriablen zugängig machen

{$R *.fmx}


end.
