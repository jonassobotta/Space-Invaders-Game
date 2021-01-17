unit uSpieler;

interface

uses  Winapi.Windows, System.SysUtils, Vcl.Forms, Vcl.ExtCtrls;

type
  TSpieler = Class
    private
      iXpos : integer;
      iYpos : integer;
      iSpeed : integer;
      iHeight : integer;
      iWidth : integer;
      iLeben : integer;

      strGFX : String;
    public
      Constructor Create;
      procedure draw(parent : TForm);
      procedure SetiXpos(iXpos : integer);
      procedure SetiYpos(iYpos : integer);
      procedure SetiSpeed(iSpeed : integer);
      procedure SetiLeben(iLeben : integer);
      procedure SetstrGFX(strGFX : String);
      function GetiXpos : integer;
      function GetiYpos : integer;
      function GetiSpeed : integer;
      function GetiLeben : integer;
  End;


var
  imgBox : TImage;

implementation



{ TSpieler }

constructor TSpieler.Create();
begin
  self.iXpos := 425;
  self.iYpos := 500;
  self.iHeight := 250;
  self.iWidth := 150;
  self.iSpeed := 5;
  self.iLeben := 3;

  self.strGFX := 'Grafiken/Raumschiff.png';
end;

//Klassen Procedures
procedure TSpieler.draw(parent: TForm);
begin
  imgBox := TImage.Create(parent);
  imgBox.Left := self.iXpos;
  imgBox.Top := self.iYpos;
  imgBox.Width := self.iWidth;
  imgBox.Height := self.iHeight;
  imgBox.Visible := True;
  imgBox.Parent := parent;

  imgBox.Picture.LoadFromFile(self.strGFX);
end;

function TSpieler.GetiLeben: integer;
begin
  result := self.iLeben;
end;

function TSpieler.GetiSpeed: integer;
begin
  result := self.iSpeed;
end;

function TSpieler.GetiXpos: integer;
begin
  result := self.iXpos;
end;

function TSpieler.GetiYpos: integer;
begin
  result := self.iYpos;
end;

//Setter
procedure TSpieler.SetiLeben(iLeben: integer);
begin
  self.iLeben := iLeben;
end;

procedure TSpieler.SetiSpeed(iSpeed: integer);
begin
  self.iSpeed := iSpeed;
end;

procedure TSpieler.SetiXpos(iXpos: integer);
begin
  self.iXpos := iXpos;
  imgBox.Left := self.iXpos;
end;

procedure TSpieler.SetiYpos(iYpos: integer);
begin
  self.iYpos := iYpos;
  imgBox.Top := self.iYpos;
end;

procedure TSpieler.SetstrGFX(strGFX: String);
begin
  self.strGFX := strGfx;
end;

end.
