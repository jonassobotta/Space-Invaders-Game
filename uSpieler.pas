unit uSpieler;

interface

uses  Winapi.Windows, System.SysUtils, Vcl.Forms, Vcl.ExtCtrls;

type
  TSpieler = Class
    private
      iPositionX : integer;
      iPositionY : integer;
      iSpeed : integer;
      iHeight : integer;
      iWidth : integer;
      iLeben : integer;
      iOffset : integer;

      strGFX : String;
    public
      Constructor Create();
      procedure draw(parent : TForm);
  End;


var
  bBox : TImage;

implementation



{ TSpieler }

constructor TSpieler.Create();
begin
  self.iPositionX := 425;
  self.iPositionY := 500;
  self.iHeight := 250;
  self.iWidth := 150;
  self.iSpeed := 5;
  self.iLeben := 3;
  self.iOffset := 5;

  self.strGFX := 'Grafiken/Raumschiff.png';
end;

procedure TSpieler.draw(parent: TForm);
begin
  bBox := TImage.Create(parent);
  bBox.Left := self.iPositionX;
  bBox.Top := self.iPositionY;
  bBox.Width := self.iWidth;
  bBox.Height := self.iHeight;
  bBox.Name := 'bBox';
  bBox.Visible := True;
  bBox.Parent := parent;

  bBox.Picture.LoadFromFile(self.strGFX);
end;

end.
