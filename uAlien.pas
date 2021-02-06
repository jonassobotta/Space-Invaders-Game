unit uAlien;

interface

uses Winapi.Windows, System.SysUtils, VCL.Forms, Vcl.ExtCtrls;

type
  TAlien = Class
    private
      iXpos, iYpos, iRichtung, iSpeed : integer;
      strGFX : String;
      imgBox : TImage;
      bGetroffen : boolean;
      const
        iHeight = 64;
        iWidth = 64;
    public
      Constructor Create;

      procedure draw(parent : TForm);
      procedure SetbGetroffen(bGetroffen : boolean);
      procedure SetiXpos(iXpos : integer);
      procedure SetiYpos(iYpos : integer);
      procedure SetstrGFX(strGFX : String);
      procedure SetiSpeed(iSpeed : integer);
      procedure SetiRichtung(iRichtung : integer);

      function GetbGetroffen : boolean;
      function GetiXpos : integer;
      function GetiYpos : integer;
      function GetiSpeed : integer;
      function GetiRichtung : integer;
      function GetiHeight : integer;
      function GetiWidth : integer;
      function GetimgBox : TImage;
  End;

implementation

{ TAlien }

constructor TAlien.Create;
begin
  self.iXpos := 0;
  self.iYpos := 0;
  self.iSpeed := 1;
  self.iRichtung := 1;
  self.strGFX := 'Grafiken/AlienI.png';
end;

procedure TAlien.draw(parent: TForm);
begin
  self.imgBox := TImage.Create(parent);
  self.imgBox.Left := self.iXpos;
  self.imgBox.Top := self.iYpos;
  self.imgBox.Width := iWidth;
  self.imgBox.Height := iHeight;
  self.imgBox.Visible := True;
  self.imgBox.Parent := parent;
  self.imgBox.Picture.LoadFromFile(self.strGFX);
end;

//Getter
function TAlien.GetbGetroffen: boolean;
begin
  result := self.bGetroffen;
end;

function TAlien.GetiHeight: integer;
begin
  result := self.iHeight;
end;

function TAlien.GetimgBox: TImage;
begin
 result := self.imgBox
end;

function TAlien.GetiWidth: integer;
begin
  result := self.iWidth;
end;

function TAlien.GetiRichtung: integer;
begin
  result := self.iRichtung;
end;

function TAlien.GetiSpeed: integer;
begin
  result := self.iSpeed;
end;

function TAlien.GetiXpos: integer;
begin
  result := self.iXpos;
end;

function TAlien.GetiYpos: integer;
begin
  result := self.iYpos;
end;

//Setter
procedure TAlien.SetbGetroffen(bGetroffen: boolean);
begin
  self.bGetroffen := bGetroffen;
end;

procedure TAlien.SetiRichtung(iRichtung: integer);
begin
  self.iRichtung := iRichtung;
end;

procedure TAlien.SetiSpeed(iSpeed: integer);
begin
  self.iSpeed := iSpeed;
end;

procedure TAlien.SetiXpos(iXpos: integer);
begin
  self.iXpos := iXpos;
  self.imgBox.Left := self.iXpos;
end;

procedure TAlien.SetiYpos(iYpos: integer);
begin
  self.iYpos := iYpos;
  self.imgBox.Top := self.iYpos;
end;

procedure TAlien.SetstrGFX(strGFX: String);
begin
  self.strGFX := strGFX;
end;

end.
