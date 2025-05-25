unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Winapi.ShellAPI,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.WinXPanels, Vcl.ExtCtrls,
  uIniHelper, Clipbrd, FileCtrl, RegularExpressions,
  Vcl.OleCtrls, SHDocVw, Vcl.StdCtrls, Vcl.WinXCtrls,
  IdBaseComponent, IdThreadComponent, JvComponentBase, JvComputerInfoEx,
  Vcl.ComCtrls, Vcl.CheckLst, System.JSON, System.NetEncoding, DateUtils,
  System.JSON.Readers, System.JSON.Types, Vcl.Imaging.pngimage,
  Vcl.Touch.GestureMgr, System.IOUtils, Vcl.Menus, dxGDIPlusClasses,
  Vcl.Themes, Vcl.Styles, scStyleManager, dxSkinsCore, dxSkinBasic,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkroom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMetropolis, dxSkinMetropolisDark, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinOffice2013DarkGray,
  dxSkinOffice2013LightGray, dxSkinOffice2013White, dxSkinOffice2016Colorful,
  dxSkinOffice2016Dark, dxSkinOffice2019Black, dxSkinOffice2019Colorful,
  dxSkinOffice2019DarkGray, dxSkinOffice2019White, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringtime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinTheBezier, dxSkinValentine, dxSkinVisualStudio2013Blue,
  dxSkinVisualStudio2013Dark, dxSkinVisualStudio2013Light, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinWXI, dxSkinXmas2008Blue, dxCore, cxClasses,
  cxLookAndFeels, dxSkinsForm;

type
  TForm1 = class(TForm)
    crdpnl1: TCardPanel;
    crd1: TCard;
    tglswtch1: TToggleSwitch;
    lbl1: TLabel;
    edt1: TEdit;
    lbl2: TLabel;
    lbl3: TLabel;
    jvcmptrnfx1: TJvComputerInfoEx;
    idthrdcmpnt1: TIdThreadComponent;
    idthrdcmpnt2: TIdThreadComponent;
    mmo1: TMemo;
    gstrmngr1: TGestureManager;
    crd2: TCard;
    lbl6: TLabel;
    spltvw1: TSplitView;
    fllst1: TFileListBox;
    pnl1: TPanel;
    tmr1: TTimer;
    pm1: TPopupMenu;
    Play1: TMenuItem;
    Rename1: TMenuItem;
    Renameall1: TMenuItem;
    Delete1: TMenuItem;
    img2: TImage;
    img4: TImage;
    img5: TImage;
    img6: TImage;
    img3: TImage;
    img11: TImage;
    lbl41: TLabel;
    Label1: TLabel;
    ComboBox1: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure tglswtch1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure tglswtch2Click(Sender: TObject);
    procedure edt1Change(Sender: TObject);
    procedure idthrdcmpnt1Run(Sender: TIdThreadComponent);
    procedure idthrdcmpnt2Run(Sender: TIdThreadComponent);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure lbl4Click(Sender: TObject);
    procedure img1Click(Sender: TObject);
    procedure crdpnl1Gesture(Sender: TObject;
      const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure btn5Click(Sender: TObject);
    procedure btn4Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tmr1Timer(Sender: TObject);
    procedure fllst1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure Renameall1Click(Sender: TObject);
    procedure Rename1Click(Sender: TObject);
    procedure Play1Click(Sender: TObject);
    procedure img3Click(Sender: TObject);
    procedure dxSkinController1SkinForm(Sender: TObject; AForm: TCustomForm;
      var ASkinName: string; var UseSkin: Boolean);
    procedure ComboBox1Change(Sender: TObject);
  private
    StyleManager: TStyleManager;
    FChangeHandle: THandle;
    procedure StartWatching(const ADirectory: string);
    procedure StopWatching;
    procedure CheckForChanges;

    procedure RunCommandAndCaptureOutput(const CommandLine: string);
    function RunCommandAndCaptureOutputInfo(const CommandLine,
      WorkingDir: string): string;

  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

var
  command, Pathdll, Cur: string;

function StripUrlParams(const URL: string): string;
var
  p: Integer;
begin
  p := Pos('&', URL);
  if p > 0 then
    Result := Copy(URL, 1, p - 1)
  else
    Result := URL;
end;

procedure TForm1.btn1Click(Sender: TObject);
begin
  if SelectDirectory('เลือกโฟลเดอร์ปลายทาง', '', Cur) then
  begin
    // Cur := Ini.ReadString('setting', 'Cur', p);
    lbl3.Caption := 'save to ' + Cur;
    lbl3.Hint := Cur;
    img5.Hint := Cur;
    img5.ShowHint := True;
    lbl3.ShowHint := True;
    fllst1.Directory := Cur;
    if tglswtch1.State = tssOn then
      fllst1.Mask := '*.mp4'
    else
      fllst1.Mask := '*.mp3';
  end;
end;

procedure TForm1.btn2Click(Sender: TObject);
var
  ExpiryDate: TDate;
begin
  ExpiryDate := EncodeDate(2027, 1, 1);
  // ใช้แบบนี้แทน StrToDate เพื่อความปลอดภัย
  if Now > ExpiryDate then
    mmo1.Lines.Add('โปรแกรมหมดอายุ โปรดโหลดตัวใหม่')
  else
    idthrdcmpnt2.Start;
end;

procedure TForm1.btn3Click(Sender: TObject); // playlist       watch
var
  s: string;
begin
  s := Clipboard.AsText;
  if ((Pos('playlist', s) > 0) OR (Pos('watch', s) > 0)) then
  begin
    s := StripUrlParams(s);
    edt1.Text := Clipboard.AsText;
  end
  else
    ShowMessage('คัดลอก URL Youtube เป็นลิส หรือเพลงเดียว');

end;

procedure TForm1.btn4Click(Sender: TObject);
begin
  if crdpnl1.ActiveCard = crd1 then
    crdpnl1.ActiveCard := crd2
  else
    crdpnl1.ActiveCard := crd1;
end;

procedure TForm1.btn5Click(Sender: TObject);
begin
  if crdpnl1.ActiveCard = crd1 then
    crdpnl1.ActiveCard := crd2
  else
    crdpnl1.ActiveCard := crd1;
end;

procedure TForm1.crdpnl1Gesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
  if crdpnl1.ActiveCard = crd1 then
    crdpnl1.ActiveCard := crd2
  else
    crdpnl1.ActiveCard := crd1;

end;

procedure TForm1.Delete1Click(Sender: TObject);
var
  f: TFileName;
begin
  if fllst1.ItemIndex <> -1 then
  begin
    f := fllst1.FileName;

    if MessageDlg('Delete this file: "' + ExtractFileName(f) + '"?',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      if DeleteFile(f) then
        ShowMessage('File deleted.')
      else
        ShowMessage('Failed to delete file!');
    end;
  end
  else
    ShowMessage('Please select a file first.');
end;

procedure SetControlSkinName(AControl: TWinControl; const ASkinName: string);
var
  AIntf: IcxLookAndFeelContainer;
  I: Integer;
begin
  if Supports(AControl, IcxLookAndFeelContainer, AIntf) then
  begin
    AIntf.GetLookAndFeel.NativeStyle := False;
    AIntf.GetLookAndFeel.SkinName := ASkinName;
  end;
  for I := 0 to AControl.ControlCount - 1 do
    if AControl.Controls[I] is TWinControl then
      SetControlSkinName(TWinControl(AControl.Controls[I]), ASkinName);
end;

procedure TForm1.dxSkinController1SkinForm(Sender: TObject; AForm: TCustomForm;
  var ASkinName: string; var UseSkin: Boolean);
begin
  if AForm = Form1 then
  begin
    ASkinName := 'Metropolis';
    UseSkin := True;
    SetControlSkinName(AForm, ASkinName);
  end;
end;

procedure TForm1.edt1Change(Sender: TObject);
begin

  idthrdcmpnt1.Start;
end;

procedure TForm1.fllst1Click(Sender: TObject);
begin
  // pm1
  if fllst1.ItemIndex <> -1 then
  begin
    pm1.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y)
  end;
end;

function TForm1.RunCommandAndCaptureOutputInfo(const CommandLine,
  WorkingDir: string): string;
var
  sa: TSecurityAttributes;
  hReadPipe, hWritePipe: THandle;
  si: TStartupInfo;
  pi: TProcessInformation;
  buffer: array [0 .. 1023] of AnsiChar;
  bytesRead: DWORD;
  output: AnsiString;
begin
  Result := '';
  FillChar(sa, SizeOf(sa), 0);
  sa.nLength := SizeOf(sa);
  sa.bInheritHandle := True;

  if not CreatePipe(hReadPipe, hWritePipe, @sa, 0) then
    Exit;
  try
    FillChar(si, SizeOf(si), 0);
    si.cb := SizeOf(si);
    si.dwFlags := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
    si.hStdOutput := hWritePipe;
    si.hStdError := hWritePipe;
    si.wShowWindow := SW_HIDE;

    FillChar(pi, SizeOf(pi), 0);

    if CreateProcess(nil, PChar('cmd.exe /C ' + CommandLine), nil, nil, True,
      CREATE_NO_WINDOW, nil, PChar(WorkingDir),
      // 🟢 <<< ใส่โฟลเดอร์ output ตรงนี้
      si, pi) then
    begin
      CloseHandle(hWritePipe);

      repeat
        ReadFile(hReadPipe, buffer, SizeOf(buffer), bytesRead, nil);
        if bytesRead > 0 then
          output := output + Copy(buffer, 1, bytesRead);
      until bytesRead = 0;

      WaitForSingleObject(pi.hProcess, INFINITE);
      CloseHandle(pi.hProcess);
      CloseHandle(pi.hThread);
    end;

    Result := string(output);
  finally
    CloseHandle(hReadPipe);
  end;
end;

procedure TForm1.Rename1Click(Sender: TObject);
var
  OldFullPath, NewFullPath, DirPath, OldNameOnly, NewNameOnly, Ext: string;
begin
  if fllst1.ItemIndex <> -1 then
  begin
    // เตรียมข้อมูล
    DirPath := IncludeTrailingPathDelimiter(fllst1.Directory);
    OldFullPath := DirPath + fllst1.Items[fllst1.ItemIndex];
    OldNameOnly := ChangeFileExt(fllst1.Items[fllst1.ItemIndex], '');
    Ext := ExtractFileExt(fllst1.Items[fllst1.ItemIndex]);

    // รับชื่อใหม่จากผู้ใช้
    NewNameOnly := InputBox('Rename File', 'New file name (without extension):',
      OldNameOnly);

    // ถ้ามีการกรอกชื่อใหม่ และไม่ว่าง
    if (NewNameOnly <> '') and (NewNameOnly <> OldNameOnly) then
    begin
      NewFullPath := DirPath + NewNameOnly + Ext;

      if not FileExists(NewFullPath) then
      begin
        if RenameFile(OldFullPath, NewFullPath) then
          ShowMessage('Renamed successfully.')
        else
          ShowMessage('Rename failed!');
      end
      else
        ShowMessage('File "' + NewNameOnly + Ext + '" already exists.');
    end;
  end
  else
    ShowMessage('Please select a file to rename.');
end;

function IsYouTubeID(const s: string): Boolean;
var
  I: Integer;
begin
  Result := Length(s) = 11;
  if not Result then
    Exit;

  for I := 1 to 11 do
    if not(s[I] in ['a' .. 'z', 'A' .. 'Z', '0' .. '9', '-', '_']) then
      Exit(False);

  Result := True;
end;

procedure TForm1.Renameall1Click(Sender: TObject);
var
  I: Integer;
  oldName, newName, baseName, Ext: string;
  pStart, pEnd: Integer;
  bracketContent: string;
begin
  for I := 0 to fllst1.Items.Count - 1 do
  begin
    oldName := IncludeTrailingPathDelimiter(fllst1.Directory) + fllst1.Items[I];
    Ext := ExtractFileExt(oldName);
    baseName := ChangeFileExt(fllst1.Items[I], '');

    // หาตำแหน่งของ [ ... ] ที่อยู่ท้ายชื่อ
    pEnd := LastDelimiter(']', baseName);
    pStart := LastDelimiter('[', baseName);

    if (pStart > 1) and (pEnd = Length(baseName)) and (pEnd > pStart) then
    begin
      bracketContent := Copy(baseName, pStart + 1, pEnd - pStart - 1);

      // เงื่อนไขเฉพาะที่ดูเหมือน YouTube ID จริง ๆ
      if IsYouTubeID(bracketContent) then
      begin
        baseName := Trim(Copy(baseName, 1, pStart - 1));
        newName := IncludeTrailingPathDelimiter(fllst1.Directory) +
          baseName + Ext;

        if not SameText(oldName, newName) then
        begin
          if RenameFile(oldName, newName) then
            OutputDebugString(PChar('Renamed: ' + oldName + ' -> ' + newName))
          else
            ShowMessage('Failed to rename: ' + oldName);
        end;
      end;
    end;
  end;

  fllst1.Update;
end;

function RemoveEmptyLines(const Text: string): string;
var
  Lines: TArray<string>;
  Line: string;
begin
  Lines := Text.Split([sLineBreak]);
  Result := '';
  for Line in Lines do
    if not Line.Trim.IsEmpty then
      Result := Result + Line + sLineBreak;
  Result := Result.Trim;
end;

procedure TForm1.RunCommandAndCaptureOutput(const CommandLine: string);
var
  sa: TSecurityAttributes;
  hReadPipe, hWritePipe: THandle;
  si: TStartupInfo;
  pi: TProcessInformation;
  buffer: array [0 .. 1023] of AnsiChar;
  bytesRead: DWORD;
  output: AnsiString;
  s: string;
  j: Integer;
begin

  FillChar(sa, SizeOf(sa), 0);
  sa.nLength := SizeOf(sa);
  sa.bInheritHandle := True;

  if not CreatePipe(hReadPipe, hWritePipe, @sa, 0) then
    Exit;
  try
    FillChar(si, SizeOf(si), 0);
    si.cb := SizeOf(si);
    si.dwFlags := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
    si.hStdOutput := hWritePipe;
    si.hStdError := hWritePipe;
    si.wShowWindow := SW_HIDE;

    FillChar(pi, SizeOf(pi), 0);

    if CreateProcess(nil, PChar('cmd.exe /C ' + CommandLine), nil, nil, True,
      CREATE_NO_WINDOW, nil, PChar(Cur), si, pi) then
    begin
      CloseHandle(hWritePipe);

      repeat
        ReadFile(hReadPipe, buffer, SizeOf(buffer), bytesRead, nil);
        if bytesRead > 0 then
        begin
          output := Copy(buffer, 1, bytesRead);
          s := string(output);
          j := Pos('[download] Destination:', s);
          if j = 1 then
          begin
            s := s.Remove(1, 24);
            s := RemoveEmptyLines(s);
            lbl1.Caption := s;
          end
          else
            mmo1.Lines.Add(s); // [download] Destination:
        end;
      until bytesRead = 0;

      WaitForSingleObject(pi.hProcess, INFINITE);
      CloseHandle(pi.hProcess);
      CloseHandle(pi.hThread);
    end;

    // Result := string(output); // แปลง AnsiString → Unicode
  finally
    CloseHandle(hReadPipe);
  end;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  Ini: TIniHelper;
  p: string;
  I: Integer;
begin
  p := ExtractFilePath(ParamStr(0));
  Ini := TIniHelper.Create(p + 'config.ini');
  Ini.WriteString('setting', 'Cur', Cur);
  if tglswtch1.State = tssOn then
    Ini.WriteBool('setting', 'tglswtch1', True)
  else
    Ini.WriteBool('setting', 'tglswtch1', False);
  Ini.WriteInteger('setting', 'style', ComboBox1.ItemIndex);
  for I := 0 to ComboBox1.Items.Count - 1 do
  begin
    p := ComboBox1.Items[I];
    Ini.WriteString('style', IntToStr(I), p);
    Ini.WriteInteger('style', 'count', I);
  end;
  Ini.Free;
end;

procedure ListResources;
var
  hResInfo: HRSRC;
begin
  hResInfo := FindResource(HInstance, 'XXXX', PChar('RCDATA'));
  if hResInfo = 0 then
    ShowMessage('หา resource XXXX ไม่เจอ')
  else
    ShowMessage('เจอ XXXX แล้ว');
end;

function ExtractYoutubeDLLFromResource: string;
var
  ResStream: TResourceStream;
  TempPath, DllPath: string;
begin
  TempPath := TPath.GetTempPath;
  DllPath := TPath.Combine(TempPath, 'youtube.dll');

  if not FileExists(DllPath) then
  begin
    try
      // เปลี่ยน 'XXXX' เป็นชื่อ Resource จริง และตรวจสอบประเภท Resource
      ResStream := TResourceStream.Create(HInstance, 'YOUTUBE_DLL', RT_RCDATA);
      try
        ResStream.SaveToFile(DllPath);
      finally
        ResStream.Free;
      end;
    except
      raise Exception.Create('ไม่สามารถคลาย resource youtube.dll ได้');
    end;
  end;

  Result := DllPath;
end;

function ExtractDllFromResourceIfNeeded(const ResName, ResType,
  FileName: string): string;
var
  ResStream: TResourceStream;
  TempPath, FullPath: string;
begin
  SetLength(TempPath, MAX_PATH);
  GetTempPath(MAX_PATH, PChar(TempPath));
  SetLength(TempPath, StrLen(PChar(TempPath)));

  FullPath := IncludeTrailingPathDelimiter(TempPath) + FileName;

  if not FileExists(FullPath) then
  begin
    try
      ResStream := TResourceStream.Create(HInstance, ResName, PChar(ResType));
      try
        ResStream.SaveToFile(FullPath);
      finally
        ResStream.Free;
      end;
    except
      raise Exception.Create('ไม่สามารถคลาย resource ' + ResName + ' ได้');
    end;
  end;

  Result := FullPath;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  I, c: Integer;
  Ini: TIniHelper;
  p, s: string;
  DllPath: string;

begin
  StyleManager := TStyleManager.Create;
  p := ExtractFilePath(ParamStr(0));
  Ini := TIniHelper.Create(p + 'config.ini');

  c := Ini.ReadInteger('style', 'count', 0);
  if c > 0 then
  begin
    for I := 0 to c do
    begin
      s := Ini.ReadString('style', IntToStr(I), '');
      if Length(s) > 1 then

        ComboBox1.Items.Add(s);
    end;
  end
  else
  begin
    for I := 0 to Length(TStyleManager.StyleNames) - 1 do
      ComboBox1.Items.Add(TStyleManager.StyleNames[I]);
  end;
  ComboBox1.ItemIndex := Ini.ReadInteger('setting', 'style', 0);
  Cur := Ini.ReadString('setting', 'Cur', p);
  lbl3.Caption := 'save to ' + Cur;
  lbl3.Hint := Cur;
  img5.Hint := Cur;
  crdpnl1.ActiveCard := crd1;
  fllst1.Directory := Cur;
  StartWatching(Cur);
  tmr1.Interval := 1000;
  tmr1.Enabled := True;

  img5.ShowHint := True;
  lbl3.ShowHint := True;
  edt1.Text := StripUrlParams(Ini.ReadString('setting', 'links',
    'https://music.youtube.com/watch?v=9Ic6PWwTU8g&si=APuCTttNJqklrcpY'));
  if Ini.ReadBool('setting', 'tglswtch1', True) then
    tglswtch1.State := tssOn
  else
    tglswtch1.State := tssOff;

  Ini.Free;

  DllPath := ExtractYoutubeDLLFromResource;
  if FileExists(DllPath) then
    Pathdll := DllPath
  else if FileExists(p + 'youtube.dll') then
    Pathdll := p + 'youtube.dll';

  tglswtch1Click(Self);
  ComboBox1Change(Self);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  StopWatching;
end;

procedure TForm1.StartWatching(const ADirectory: string);
begin
  StopWatching; // เผื่อมีการเรียกซ้ำ

  FChangeHandle := FindFirstChangeNotification(PChar(ADirectory), False,
    FILE_NOTIFY_CHANGE_FILE_NAME or FILE_NOTIFY_CHANGE_DIR_NAME);

  if FChangeHandle = INVALID_HANDLE_VALUE then
    raise Exception.Create('ไม่สามารถเริ่มเฝ้าดูโฟลเดอร์ได้');
end;

procedure TForm1.StopWatching;
begin
  if FChangeHandle <> 0 then
  begin
    FindCloseChangeNotification(FChangeHandle);
    FChangeHandle := 0;
  end;
end;

procedure TForm1.CheckForChanges;
begin
  if (FChangeHandle <> 0) and (WaitForSingleObject(FChangeHandle, 0)
    = WAIT_OBJECT_0) then
  begin
    fllst1.Update;
    // ตั้งค่าสำหรับการเฝ้ารอบถัดไป
    FindNextChangeNotification(FChangeHandle);
  end;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  StyleManager.TrySetStyle(ComboBox1.Text);
end;

procedure TForm1.idthrdcmpnt1Run(Sender: TIdThreadComponent);
begin
  // mmo1.text := runcommandandcaptureoutputinfo (Pathdll + ' --print "%(playlist_title)s (%(playlist_count)s เพลง)" "' + edt1.Text +'"', cur);
  idthrdcmpnt1.Stop;
end;

procedure TForm1.idthrdcmpnt2Run(Sender: TIdThreadComponent);
begin
  idthrdcmpnt2.Stop;
  RunCommandAndCaptureOutput(Pathdll + ' ' + command + ' ' + edt1.Text);

end;

procedure TForm1.img1Click(Sender: TObject);
begin
  lbl4Click(Self);
end;

procedure TForm1.img3Click(Sender: TObject);
begin
  if crdpnl1.ActiveCard = crd1 then
    crdpnl1.ActiveCard := crd2
  else
    crdpnl1.ActiveCard := crd1;
end;

procedure TForm1.lbl4Click(Sender: TObject);
var
  URL: string;
begin
  URL := 'https://web.facebook.com/backswva';
  URL := StringReplace(URL, '"', '%22', [rfReplaceAll]);
  ShellExecute(0, 'open', PChar(URL), nil, nil, SW_SHOWNORMAL);
  // Winapi.ShellAPI;
end;

procedure TForm1.Play1Click(Sender: TObject);
var
  FilePath: string;
begin
  if fllst1.ItemIndex <> -1 then
  begin
    FilePath := IncludeTrailingPathDelimiter(fllst1.Directory) + fllst1.Items
      [fllst1.ItemIndex];
    ShellExecute(Handle, 'open', PChar(FilePath), nil, nil, SW_SHOWNORMAL);
  end
  else
    ShowMessage('กรุณาเลือกไฟล์ก่อน');
end;

procedure TForm1.tglswtch1Click(Sender: TObject);
begin
  fllst1.Directory := Cur;
  if tglswtch1.State = tssOn then
  begin
    command := '-f b';
    fllst1.Mask := '*.mp4';

  end
  else
  begin
    command := '-f bestaudio --extract-audio --audio-format mp3';
    fllst1.Mask := '*.mp3';
  end;

end;

procedure TForm1.tglswtch2Click(Sender: TObject);
begin
  if tglswtch1.State = tssOn then
  begin
    command := '-f best';
  end
  else
    command := '-f bestaudio --extract-audio --audio-format mp3';
end;

procedure TForm1.tmr1Timer(Sender: TObject);
begin
  CheckForChanges;
  if fllst1.Items.Count = 0 then
  begin
    if spltvw1.Visible then
      spltvw1.Visible := False;

  end
  else
  begin
    if spltvw1.Visible = False then
      spltvw1.Visible := True;
  end;
end;

end.
