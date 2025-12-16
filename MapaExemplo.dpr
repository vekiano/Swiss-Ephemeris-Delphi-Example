program MapaExemplo;

uses
  Vcl.Forms,
  U_MapaExemplo in 'U_MapaExemplo.pas' {FrmMapaExemplo},
  swissdelphi in 'swissdelphi.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMapaExemplo, FrmMapaExemplo);
  Application.Run;
end.
