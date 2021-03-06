unit uLaser;

interface

uses Winapi.Windows, System.SysUtils, VCL.Forms, Vcl.ExtCtrls;

type
  TLaser = Class(TImage)
    private
      speed : integer;
    public

      procedure Render(parent : TForm; Xpos, Ypos : integer; GfxPath : String);
      procedure SetSpeed(speed : integer);

      function GetSpeed : integer;
  End;


implementation

{ TLaser }

procedure TLaser.Render(parent: TForm; Xpos, Ypos: integer;
  GfxPath: String);
begin
  self.parent := parent;
  self.Width := 5;
  self.Height := 30;
  self.Left := Xpos;
  self.Top := Ypos;
  self.Picture.LoadFromFile(GfxPath);
  self.Visible := True;
  self.speed := 12;
end;

function TLaser.GetSpeed: integer;
begin
  result := self.speed;
end;

procedure TLaser.SetSpeed(speed: integer);
begin
  self.speed := speed;
end;

end.
