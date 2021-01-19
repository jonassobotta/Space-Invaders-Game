unit uLaser;

interface

uses Winapi.Windows, System.SysUtils, VCL.Forms, Vcl.ExtCtrls;

type
  TLaser = Class
    private
      iXpos, iYpos, iSpeed, iHeight, iWidth : integer;
      strGFX : String;
    public
      Constructor Create;

      procedure SetiXpos(iXpos : integer);
      procedure SetiYpos(iYpos : integer);
      procedure SetiSpeed(iSpeed : integer);
      procedure SetstrGFX(strGFX : String);
      procedure draw(parent : TForm);

      function GetiXpos : integer;
      function GetiYpos : integer;
      function GetiSpeed : integer;
      function GetiWidth : integer;
      function GetiHeight : integer;
  End;

var
  imgBox : Timage;

implementation

{ TLaser }

constructor TLaser.Create;
begin
  self.iSpeed := 5;
  self.iHeight := 30;
  self.iWidth := 5;
  self.iXpos := -20;
  self.iYpos := -20;
  self.strGFX := 'Grafiken/Laser.png';
end;

//Klassenfunktionen
procedure TLaser.draw(parent: TForm);
begin
  imgBox := TImage.Create(parent);
  imgBox.Left := self.iXpos;
  imgBox.Top := self.iYpos;
  imgBox.Width := iWidth;
  imgBox.Height := iHeight;
  imgBox.Visible := True;
  imgBox.Parent := parent;
  imgBox.Picture.LoadFromFile(self.strGFX);
end;


//Getter
function TLaser.GetiWidth : integer;
begin
  result := self.iWidth;
end;

function TLaser.GetiHeight: integer;
begin
  result := self.iHeight;
end;

function TLaser.GetiSpeed: integer;
begin
  result := self.iSpeed;
end;

function TLaser.GetiXpos: integer;
begin
  result := self.iXpos;
end;

function TLaser.GetiYpos: integer;
begin
  result := self.iYpos;
end;

//Setter
procedure TLaser.SetiSpeed(iSpeed : integer);
begin
  self.iSpeed := iSpeed;
end;

procedure TLaser.SetiXpos(iXpos : integer);
begin
  self.iXpos := iXpos;
  imgBox.Left := self.iXpos
end;

procedure TLaser.SetiYpos(iYpos : integer);
begin
  self.iYpos := iYpos;
  imgBox.Top := self.iYpos
end;

procedure TLaser.SetstrGFX(strGFX : String);
begin
  self.strGFX := strGFX;
end;

end.
