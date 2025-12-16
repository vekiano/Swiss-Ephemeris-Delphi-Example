#Swiss Ephemeris Delphi ExampleA complete **Delphi VCL Example** demonstrating how to integrate the high-precision **Swiss Ephemeris** library (by Astrodienst) into an Object Pascal application.

This project calculates a sample birth chart (Barack Obama) including Julian Day, planetary positions (Longitude, Latitude, Speed), and House Cusps (Placidus system). It handles the communication between Delphi (Unicode) and the DLL (ANSI C).

##🚀 Features* **DLL Integration:** Correctly loads and calls functions from `swedll32.dll`.
* **Dynamic Pathing:** Automatically detects the `/ephe` folder relative to the executable for loading ephemeris files.
* **Data Conversion:** Handles the necessary `String` (Delphi) to `AnsiString/PAnsiChar` (C) conversions.
* **Precision Modes:**
* **High Precision:** Uses `.se1` ephemeris files if found.
* **Fallback Mode:** Automatically switches to Moshier analytical mode if files are missing (marked with `(*)` in the output).


* **Calculations:**
* Julian Day (UT).
* Planetary bodies (Sun through True Node).
* House Cusps (Placidus).
* Ascendant (ASC) and Midheaven (MC).



##📋 PrerequisitesTo run or compile this project, you need:

1. **Delphi IDE:** (Delphi 10, 11, 12, or Community Edition).
2. **Swiss Ephemeris DLL:** You must download `swedll32.dll`.
3. **Ephemeris Files (Optional but recommended):** `.se1` files for high precision.

##🛠️ Installation & Setup###1. Clone the Repository```bash
git clone https://github.com/vekiano/Swiss-Ephemeris-Delphi-Example.git

```

###2. Download DependenciesThis repository contains the source code. You need to download the binary DLL manually due to licensing/size reasons.

* Download **swedll32.dll** from the [Astrodienst GitHub](https://www.google.com/search?q=https://github.com/aloistr/sweph/tree/master/bin) or their official site.
* Place `swedll32.dll` in the **same folder** where your compiled `.exe` will be (usually `Win32\Debug`).

###3. Setup Ephemeris Files (The `/ephe` folder)To enable high-precision calculations, create a folder named `ephe` next to your executable and add Swiss Ephemeris files (e.g., `sepl_18.se1`, `semo_18.se1`).

**Directory Structure:**

```text
MyProject\
  ├── Win32\
  │    └── Debug\
  │         ├── Project1.exe
  │         ├── swedll32.dll       <-- REQUIRED
  │         └── ephe\              <-- Create this folder
  │              ├── sepl_18.se1   <-- Planetary files (1800-2399 AD)
  │              └── semo_18.se1   <-- Moon files
  ├── U_MapaExemplo.pas
  └── ...

```

##💻 Code Explanation###The Bridge (`swissdelphi.pas`)This unit acts as the header translation. It defines the constants (like `SE_SUN`, `SEFLG_SPEED`) and imports the functions from the DLL using `stdcall`.

###The Logic (`U_MapaExemplo.pas`)The main logic happens in `BtnCalcularClick`.

**1. Setting the Path:**
The code uses `ExtractFilePath(Application.ExeName)` to find the local path. It is crucial to cast this path to `AnsiString` because the DLL expects a C-style string (1 byte per char), not Delphi's default Unicode string.

```delphi
// Delphi String -> AnsiString -> PAnsiChar
aEphePath := AnsiString(sEphePath);
swe_set_ephe_path(PAnsiChar(aEphePath));

```

**2. Handling Variables:**
The DLL requires variables passed by reference.

* **Input:** We pass `PAnsiChar` for strings.
* **Output:** We pass the first index of the Double array (`xx[0]`) by reference (`var`).

**3. Error Checking:**
The code checks the return flag of `swe_calc_ut`. If the flag `SEFLG_SWIEPH` is missing from the result, the program knows the DLL failed to read the file and used the fallback calculation method.

##📄 License & Credits* **Delphi Code:** Open Source (MIT or Unlicense).
* **Swiss Ephemeris:** The core logic belongs to **Astrodienst AG**.
* The Swiss Ephemeris is free for non-commercial use (GNU GPL).
* For commercial products, you must purchase a license from Astrodienst.
* See [Astrodienst License Information](https://www.astro.com/swisseph/swephinfo_e.htm).



---

*Created by [vekiano*](https://github.com/vekiano)
