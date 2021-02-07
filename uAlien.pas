unit uAlien;

interface

uses Winapi.Windows, System.SysUtils, VCL.Forms, Vcl.ExtCtrls;

type
  TAlien = Class(TImage)
    private
      Direction, Speed : integer;

    public
      procedure Render(parent : TForm; Xpos : integer; Ypos : integer; width : integer; height : integer; GfxPath : String);

      procedure SetDirection(direction : integer);
      procedure SetSpeed(speed : integer);

      function GetDirection : integer;
      function GetSpeed : integer;
  End;

implementation

{ TAlien }

//Getter
function TAlien.GetDirection: integer;
begin
  result := self.Direction;
end;

function TAlien.GetSpeed: integer;
begin
  result := self.Speed;
end;

//Setter
procedure TAlien.SetDirection(direction: integer);
begin
  self.Direction := direction
end;

procedure TAlien.SetSpeed(speed: integer);
begin
  self.Speed := speed;
end;

{ TAlien }

procedure TAlien.Render(parent : TForm; Xpos, Ypos: integer; width : integer; height : integer; GfxPath: String);
begin
  self.Parent := parent;
  self.Left := Xpos;
  self.Top := Ypos;
  self.Width := width;
  self.Height := height;
  self.Picture.LoadFromFile(GfxPath);
  self.Visible := True;
  self.Speed := 1;
  self.Direction := 1;
end;

end.
