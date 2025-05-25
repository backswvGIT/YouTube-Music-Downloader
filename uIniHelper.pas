unit uIniHelper;

interface

uses
  System.SysUtils, System.IniFiles;

type
  TIniHelper = class
  private
    FIni: TIniFile;
    FFileName: string;
  public
    constructor Create(const AFileName: string);
    destructor Destroy; override;

    // Methods to read/write string, int, bool
    function ReadString(const Section, Key, Default: string): string;
    procedure WriteString(const Section, Key, Value: string);

    function ReadInteger(const Section, Key: string; Default: Integer): Integer;
    procedure WriteInteger(const Section, Key: string; Value: Integer);

    function ReadBool(const Section, Key: string; Default: Boolean): Boolean;
    procedure WriteBool(const Section, Key: string; Value: Boolean);

    procedure Save;
  end;

implementation

{ TIniHelper }

constructor TIniHelper.Create(const AFileName: string);
begin
  FFileName := AFileName;
  FIni := TIniFile.Create(FFileName);
end;

destructor TIniHelper.Destroy;
begin
  FIni.Free;
  inherited;
end;

function TIniHelper.ReadString(const Section, Key, Default: string): string;
begin
  Result := FIni.ReadString(Section, Key, Default);
end;

procedure TIniHelper.WriteString(const Section, Key, Value: string);
begin
  FIni.WriteString(Section, Key, Value);
  Save;
end;

function TIniHelper.ReadInteger(const Section, Key: string; Default: Integer): Integer;
begin
  Result := FIni.ReadInteger(Section, Key, Default);
end;

procedure TIniHelper.WriteInteger(const Section, Key: string; Value: Integer);
begin
  FIni.WriteInteger(Section, Key, Value);
  Save;
end;

function TIniHelper.ReadBool(const Section, Key: string; Default: Boolean): Boolean;
begin
  Result := FIni.ReadBool(Section, Key, Default);
end;

procedure TIniHelper.WriteBool(const Section, Key: string; Value: Boolean);
begin
  FIni.WriteBool(Section, Key, Value);
  Save;
end;

procedure TIniHelper.Save;
begin
  FIni.UpdateFile; // บังคับให้เขียนไฟล์ทันที (ในกรณีต้องการแน่ใจว่าไฟล์ถูกเขียน)
end;

end.

