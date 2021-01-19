unit Aliens;

interface

uses Winapi.Windows, System.SysUtils, VCL.Forms, Vcl.ExtCtrls;

type
  TAlien = Class
    private
      iXpos, iYpos : integer;
      strGFX : String;

    public
      Constructor Create;

      procedure SetiXpos(iXpos : integer);
      procedure SetiYpos(iYpos : integer);
      procedure SetstrGFX(strGFX : String);

      function GetiXpos(
  End;

implementation

end.
