unit U_MapaExemplo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  // SWISS EPHEMERIS UNIT (Ensure swissdelphi.pas is in the project folder)
  swissdelphi;

type
  TFrmMapaExemplo = class(TForm)
    Panel1: TPanel;
    BtnCalcular: TButton;
    MemoLog: TMemo;
    procedure BtnCalcularClick(Sender: TObject);
  private
    procedure Log(const Text: string);
  public
    { Public declarations }
  end;

var
  FrmMapaExemplo: TFrmMapaExemplo;

implementation

{$R *.dfm}

const
  MAX_BUFFER = 256;

procedure TFrmMapaExemplo.Log(const Text: string);
begin
  MemoLog.Lines.Add(Text);
end;

procedure TFrmMapaExemplo.BtnCalcularClick(Sender: TObject);
var
  // Date and Location variables
  iday, imon, iyar: Integer;
  dhour, dlon, dlat: Double;
  ihsy: AnsiChar; // SwissDelphi requires AnsiChar for house system

  // Path variables
  sEphePath: string;     // Delphi String (Unicode)
  aEphePath: AnsiString; // ANSI String for the DLL

  // Swiss Ephemeris internal variables
  jd_ut: Double;
  ipl, i, iflag, iret: Longint;

  // Result Arrays
  xx: array[0..5] of Double;       // [0]=Long, [1]=Lat, [2]=Dist, [3]=Speed
  cusps: array[0..12] of Double;   // House cusps (indices 1..12)
  ascmc: array[0..9] of Double;    // [0]=ASC, [1]=MC, etc.

  // Text Buffers (C/DLL compatibility)
  serr: array[0..MAX_BUFFER] of AnsiChar;
  spname: array[0..MAX_BUFFER] of AnsiChar;

  // Display helpers
  PlanetName: string;
  OutputLine: string;
begin
  MemoLog.Lines.Clear;
  MemoLog.Lines.BeginUpdate;
  try
    try
      // =========================================================
      // 1. EPHEMERIS DIRECTORY CONFIGURATION
      // =========================================================

      // Define 'ephe' folder relative to the executable location
      sEphePath := ExtractFilePath(Application.ExeName) + 'ephe';

      // Check if directory exists (just for logging/debugging purposes)
      if not DirectoryExists(sEphePath) then
        Log('WARNING: "ephe" folder not found at: ' + sEphePath)
      else
        Log('Ephemeris folder detected: ' + sEphePath);

      Log('');

      // CRITICAL CONVERSION: Delphi String -> AnsiString -> PAnsiChar
      aEphePath := AnsiString(sEphePath);
      swe_set_ephe_path(PAnsiChar(aEphePath));

      // =========================================================
      // 2. INPUT DATA (Example: Barack Obama)
      // =========================================================
      iday := 5;
      imon := 8;
      iyar := 1961;
      dhour := 5.4;          // 05:24 UT
      dlon := -157.86666667; // Honolulu (West is negative)
      dlat := 21.3;          // Honolulu (North is positive)
      ihsy := 'P';           // Placidus House System

      Log('=== INPUT DATA ===');
      Log(Format('Date (UT): %d/%0.2d/%d at %.2f h', [iday, imon, iyar, dhour]));
      Log(Format('Coord    : Lat %.4f, Long %.4f', [dlat, dlon]));
      Log('');

      // =========================================================
      // 3. CALCULATIONS
      // =========================================================

      // A. Julian Day
      jd_ut := swe_julday(iyar, imon, iday, dhour, SE_GREG_CAL);
      Log(Format('Julian Day: %.6f', [jd_ut]));
      Log('');

      // B. Planets
      // SEFLG_SWIEPH: Try to use Swiss Ephemeris files (.se1)
      // SEFLG_SPEED:  Calculate speed
      iflag := SEFLG_SWIEPH or SEFLG_SPEED;

      Log(Format('%-12s %12s %12s %12s', ['Planet', 'Longitude', 'Latitude', 'Speed']));
      Log('-------------------------------------------------------');

      // Loop from Sun (0) to True Node (11)
      for ipl := SE_SUN to SE_TRUE_NODE do
      begin
        // Clear buffers
        FillChar(serr, SizeOf(serr), 0);
        FillChar(spname, SizeOf(spname), 0);

        // Get Planet Name
        swe_get_planet_name(ipl, PAnsiChar(@spname));
        PlanetName := String(PAnsiChar(@spname));

        // MAIN CALCULATION
        // Pass xx[0] by reference and serr as a pointer
        iret := swe_calc_ut(jd_ut, ipl, iflag, xx[0], PAnsiChar(@serr));

        // Error Handling
        if iret < 0 then
        begin
          Log('ERROR [' + PlanetName + ']: ' + String(PAnsiChar(@serr)));
          Continue;
        end;

        // Verification: Did it use the ephemeris file or the approximation?
        // If the SWIEPH flag is missing from the return 'iret', it fell back to Moshier.
        if (iret and SEFLG_SWIEPH) = 0 then
          PlanetName := PlanetName + ' (*)'
        else
          PlanetName := PlanetName + '    '; // Padding for alignment

        // Line Formatting
        OutputLine := Format('%-12s %12.6f %12.6f %12.6f',
          [Trim(PlanetName), xx[0], xx[1], xx[3]]);

        Log(OutputLine);
      end;

      Log('');
      Log('(*) If asterisk appears, .se1 file was not found (Moshier mode used).');
      Log('');

      // C. Houses and Angles
      iflag := 0;

      // Calculate houses
      iret := swe_houses_ex(jd_ut, iflag, dlat, dlon, ihsy, cusps[0], ascmc[0]);

      if iret < 0 then
      begin
        Log('Error calculating houses.');
        Exit;
      end;

      Log('=== ANGLES ===');
      Log(Format('Ascendant (ASC): %10.6f', [ascmc[0]])); // Index 0
      Log(Format('Midheaven (MC) : %10.6f', [ascmc[1]])); // Index 1
      Log('');

      Log('=== CUSPS (Placidus) ===');
      // Cusps are returned in indices 1..12
      for i := 1 to 12 do
      begin
        Log(Format('House %2d: %10.6f', [i, cusps[i]]));
      end;

    except
      on E: Exception do
        Log('CRITICAL EXCEPTION: ' + E.Message);
    end;
  finally
    MemoLog.Lines.EndUpdate;
  end;
end;

end.
