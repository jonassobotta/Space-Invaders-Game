unit uAlien;

interface

uses Winapi.Windows, System.SysUtils, VCL.Forms, Vcl.ExtCtrls;

type
  TAlien = Class
    private
      iXpos, iYpos : integer;
      strGFX : String;
      imgBox : TImage;

      const
        iHeight = 64;
        iWidth = 64;
    public
      Constructor Create;

      procedure draw(parent : TForm);
      procedure SetiXpos(iXpos : integer);
      procedure SetiYpos(iYpos : integer);
      procedure SetstrGFX(strGFX : String);

      function GetiXpos : integer;
      function GetiYpos : integer;
  End;

implementation

{ TAlien }

constructor TAlien.Create;
begin
  self.iXpos := 0;
  self.iYpos := 0;
  self.strGFX := 'Grafiken/AlienI.png';
end;

procedure TAlien.draw(parent: TForm);
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
function TAlien.GetiXpos: integer;
begin
  result := self.iXpos;
end;

function TAlien.GetiYpos: integer;
begin
  result := self.iYpos;
end;

//Setter
procedure TAlien.SetiXpos(iXpos: integer);
begin
  self.iXpos := iXpos;
end;

procedure TAlien.SetiYpos(iYpos: integer);
begin
  self.iXpos := iYpos;
end;

procedure TAlien.SetstrGFX(strGFX: String);
begin
  self.strGFX := strGFX;
end;

end.
