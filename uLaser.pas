unit uLaser;

interface

uses Winapi.Windows, System.SysUtils, VCL.Forms, Vcl.ExtCtrls;

type
  TLaser = Class
    private
      iXpos, iYpos, iSpeed : integer;
      strGFX : String;
    public
      Constructor Create;

      procedure SetiXpos(iXpos : integer);
      procedure SetiYpos(iYpos : integer);
      procedure SetiSpeed(iSpeed : integer);
      procedure SetstrGFX(strGFX : String);

      function GetiXpos : integer;
      function GetiYpos : integer;
      function GetiSpeed : integer;
  End;

const
  iHeight = 15;
  iWidth = 5;
var
  imgBox : Timage;

implementation

{ TLaser }

constructor TLaser.Create;
begin
  self.iSpeed := 10;
end;

//Getter
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
end;

procedure TLaser.SetiYpos(iYpos : integer);
begin
  self.iYpos := iYpos;
end;

procedure TLaser.SetstrGFX(strGFX : String);
begin
  self.strGFX := strGFX;
end;

end.
