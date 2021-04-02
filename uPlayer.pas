unit uPlayer;

interface

uses  Winapi.Windows, System.SysUtils, Vcl.Forms, Vcl.ExtCtrls;

type
  TPlayer = Class(TImage)
    private
      speed, lives : integer;
      movingL, movingR, borderL, borderR : boolean;
    public

      procedure Render(parent : TForm; Xpos, Ypos, width, height : integer; GfxPath : String);

      procedure SetSpeed(speed : integer);
      procedure SetLives(lives : integer);
      procedure SetMovingR(movingR : boolean);
      procedure SetMovingL(movingL : boolean);
      procedure SetBorderR(borderR : boolean);
      procedure SetBorderL(borderL : boolean);

      function GetSpeed : integer;
      function GetLives : integer;
      function GetMovingL : boolean;
      function GetMovingR : boolean;
      function GetBorderL : boolean;
      function GetBorderR : boolean;
  End;

implementation

{ TPlayer}
procedure TPlayer.Render(parent: TForm; Xpos, Ypos, width, height: integer;
  GfxPath: String);
begin
  self.Parent := parent;
  self.Left := Xpos;
  self.Top := Ypos;
  self.Width := width;
  self.Height := height;
  self.Picture.LoadFromFile(GfxPath);
  self.Visible := true;
  self.speed := 6;
  self.lives := 100;
end;

//Getter
function TPlayer.GetBorderL: boolean;
begin
  result := self.borderL;
end;

function TPlayer.GetBorderR: boolean;
begin
  result := self.borderR;
end;

function TPlayer.GetLives: integer;
begin
  result := self.lives;
end;

function TPlayer.GetMovingL: boolean;
begin
  result := self.movingL;
end;

function TPlayer.GetMovingR: boolean;
begin
  result := self.movingR;
end;

function TPlayer.GetSpeed: integer;
begin
  result := self.speed;
end;

//Setter
procedure TPlayer.SetBorderL(borderL: boolean);
begin
  self.borderL := borderL;
end;

procedure TPlayer.SetBorderR(borderR: boolean);
begin
  self.borderR := borderR;
end;

procedure TPlayer.SetLives(lives: integer);
begin
  self.lives := lives;
end;

procedure TPlayer.SetMovingL(movingL: boolean);
begin
  self.movingL := movingL;
end;

procedure TPlayer.SetMovingR(movingR: boolean);
begin
  self.movingR := movingR;
end;

procedure TPlayer.SetSpeed(speed: integer);
begin
  self.speed := speed;
end;

end.
