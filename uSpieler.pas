unit uSpieler;

interface

uses  Winapi.Windows, System.SysUtils, Vcl.Forms, Vcl.ExtCtrls;

type
  TSpieler = Class
    private
      iXpos, iYpos, iSpeed, iLeben : integer;
      strGFX : String;
      bMovingL, bMovingR, bBorderL, bBorderR : boolean;
    public


      Constructor Create;

      procedure draw(parent : TForm);
      procedure SetiXpos(iXpos : integer);
      procedure SetiYpos(iYpos : integer);
      procedure SetiSpeed(iSpeed : integer);
      procedure SetiLeben(iLeben : integer);
      procedure SetstrGFX(strGFX : String);
      procedure SetbMovingR(bMovingR : boolean);
      procedure SetbMovingL(bMovingL : boolean);
      procedure SetbBorderR(bBorderR : boolean);
      procedure SetbBorderL(bBorderL : boolean);

      function GetiXpos : integer;
      function GetiYpos : integer;
      function GetiSpeed : integer;
      function GetiLeben : integer;
      function GetbMovingL : boolean;
      function GetbMovingR : boolean;
      function GetbBorderL : boolean;
      function GetbBorderR : boolean;
  End;

const
  iHeight = 250;
  iWidth = 150;
var
  imgBox : TImage;

implementation

{ TSpieler }

constructor TSpieler.Create();
begin
  self.iXpos := 425;
  self.iYpos := 500;
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
  imgBox.Width := iWidth;
  imgBox.Height := iHeight;
  imgBox.Visible := True;
  imgBox.Parent := parent;
  imgBox.Picture.LoadFromFile(self.strGFX);
end;

//Getter
function TSpieler.GetbBorderL: boolean;
begin
  result := self.bBorderL;
end;

function TSpieler.GetbBorderR: boolean;
begin
  result := self.bBorderR;
end;

function TSpieler.GetbMovingL: boolean;
begin
  result := self.bMovingL;
end;

function TSpieler.GetbMovingR: boolean;
begin
  result := self.bMovingR;
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
procedure TSpieler.SetbBorderL(bBorderL: boolean);
begin
  self.bBorderL := bBorderL;
end;

procedure TSpieler.SetbBorderR(bBorderR: boolean);
begin
  self.bBorderR := bBorderR;
end;

procedure TSpieler.SetbMovingL(bMovingL: boolean);
begin
  self.bMovingL := bMovingL;
end;

procedure TSpieler.SetbMovingR(bMovingR: boolean);
begin
  self.bMovingR := bMovingR;
end;

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
