unit Unit1;

interface

uses
  Winapi.Windows, TlHelp32, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Winapi.ShellAPI,  System.UITypes,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.WinXPanels, Vcl.ExtCtrls,
  uIniHelper, Clipbrd, FileCtrl, RegularExpressions,
  Vcl.OleCtrls, SHDocVw, Vcl.StdCtrls, Vcl.WinXCtrls,
  IdBaseComponent, IdThreadComponent, JvComponentBase, JvComputerInfoEx,
  Vcl.ComCtrls, Vcl.CheckLst, System.JSON, System.NetEncoding, DateUtils,
  System.JSON.Readers, System.JSON.Types, Vcl.Imaging.pngimage,
  Vcl.Touch.GestureMgr, System.IOUtils, Vcl.Menus, dxGDIPlusClasses,
  Vcl.Themes, Vcl.Styles;

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
    imgDirecX: TImage;
    imgWinamp: TImage;
    imgYouTube: TImage;
    tmSlide: TTimer;
    ActivityIndicator1: TActivityIndicator;
    imgStop: TImage;
    tmr2: TTimer;
    idthrdcmpnt3: TIdThreadComponent;
    img1: TImage;
    lblPRO: TLabel;
    KillProc: TIdThreadComponent;
    ProcThumbnail: TIdThreadComponent;
    imgRef: TImage;
    imgRecheck: TImage;
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
    procedure imgDirecXClick(Sender: TObject);
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
    procedure ComboBox1Change(Sender: TObject);
    procedure ImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImageMouseEnter(Sender: TObject);
    procedure ImageMouseLeave(Sender: TObject);
    procedure tmSlideTimer(Sender: TObject);
    procedure img11Click(Sender: TObject);
    procedure lbl41Click(Sender: TObject);
    procedure imgWinampClick(Sender: TObject);
    procedure imgYouTubeClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure imgStopClick(Sender: TObject);
    procedure idthrdcmpnt3Run(Sender: TIdThreadComponent);
    procedure lblPROClick(Sender: TObject);
    procedure KillProcRun(Sender: TIdThreadComponent);
    procedure ProcThumbnailRun(Sender: TIdThreadComponent);
    procedure imgRefClick(Sender: TObject);
    procedure imgRecheckClick(Sender: TObject);

  private
    StopNow: Boolean;
    SlideStep: Integer;
    SlideDirection: Integer; //
    SlideTarget: TCard;


    StyleManager: TStyleManager;
    FChangeHandle: THandle;
    procedure ProcessAllFiles;
    procedure ProcessAllFiles2;
    procedure SwitchCardAnimated;

    procedure StartWatching(const ADirectory: string);
    procedure StopWatching;
    procedure CheckForChanges;

    procedure RunCommandAndCaptureOutput(const CommandLine: string);

  public

    FActiveFFmpegCount: Integer;
    FMaxConcurrentFFmpeg: Integer;
    procedure KillStuckFFmpegProcesses;

    function WaitForFile(const FileName: string; Timeout: Integer): Boolean;
    function SafeReplaceFile(const TargetFile, SourceFile: string): Boolean;
    function IsFileAccessible(const FileName: string): Boolean;
    procedure SafeDeleteFile(const FileName: string);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

var
  command, Pathdll, Cur, ff: string;
  SlideDirection: Integer;
  SlideStep: Integer;
  SlideTotal: Integer;
  SlideNewCard, SlideOldCard: TCard;
  TProgress: double;
  TItemInfo, TnameMusic: string;
  artist, album ,genre  :string;

function TryRemoveFile(const FileName: string): Boolean;
var
  RetryCount: Integer;
begin
  Result := False;
  RetryCount := 0;
  while RetryCount < 3 do
  begin
    if not FileExists(FileName) then
      Exit(True);

    if DeleteFile(FileName) then
      Exit(True);

    Inc(RetryCount);
    Sleep(500);
  end;
end;

  procedure ParseYTDLPOutput(const OutputText: string;
  var ProgressPercent: Double; var CurrentItem: string);
var
  RegEx: TRegEx;
  Match: TMatch;
begin
  ProgressPercent := -1.0;
  CurrentItem := '';

  // Extract download progress percentage (e.g., "99.6%")
  RegEx := TRegEx.Create('\[download\]\s+(\d+\.?\d*)%');
  Match := RegEx.Match(OutputText);
  if Match.Success then
  begin
    ProgressPercent := StrToFloatDef(Match.Groups[1].Value, -1.0);
  end;

  // Extract current item information (e.g., "item 6 of 49")
  RegEx := TRegEx.Create('\[download\] Downloading item (\d+) of (\d+)');
  Match := RegEx.Match(OutputText);
  if Match.Success then
  begin
    CurrentItem := Format('item %s of %s', [Match.Groups[1].Value,
      Match.Groups[2].Value]);
  end;
end;


procedure KillProcessesByName(const ProcessNames: array of string);
var
  hSnapshot: THandle;
  ProcessEntry: TProcessEntry32;
  i: Integer;
  hProcess: THandle;
begin
  // Create a snapshot of all processes
  hSnapshot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if hSnapshot = INVALID_HANDLE_VALUE then
    Exit;

  try
    ProcessEntry.dwSize := SizeOf(TProcessEntry32);

    if Process32First(hSnapshot, ProcessEntry) then
    begin
      repeat
        // Check against each process name we're looking for
        for i := Low(ProcessNames) to High(ProcessNames) do
        begin
          if SameText(ExtractFileName(ProcessEntry.szExeFile), ProcessNames[i])
            or SameText(ProcessEntry.szExeFile, ProcessNames[i]) then
          begin
            // Try to open the process with terminate rights
            hProcess := OpenProcess(PROCESS_TERMINATE, False,
              ProcessEntry.th32ProcessID);
            if hProcess <> 0 then
              try
                // Terminate the process
                TerminateProcess(hProcess, 0);
              finally
                CloseHandle(hProcess);
              end;
            Break; // Move to next process
          end;
        end;
      until not Process32Next(hSnapshot, ProcessEntry);
    end;
  finally
    CloseHandle(hSnapshot);
  end;
end;

procedure StartSlide(CardPanel: TCardPanel; NewCard: TCard; Direction: Integer);
begin
  SlideOldCard := CardPanel.ActiveCard;
  SlideNewCard := NewCard;
  SlideDirection := Direction; // -1 = slide left, 1 = slide right
  SlideStep := 0;
  SlideTotal := 20;

  NewCard.Visible := True;
  NewCard.BringToFront;
  if Direction = -1 then
    NewCard.Left := CardPanel.Width
  else
    NewCard.Left := -CardPanel.Width;

  Form1.tmSlide.Enabled := True;
end;

procedure TForm1.ImageMouseEnter(Sender: TObject);
var
  Img: TImage;
begin
  Img := Sender as TImage;
  Img.Tag := (Img.Left shl 16) or Img.Top; // ซ่อนตำแหน่งเดิมใน Tag
  Img.Left := Img.Left - 1;
  Img.Top := Img.Top - 1;
end;

procedure TForm1.ImageMouseLeave(Sender: TObject);
var
  Img: TImage;
begin
  Img := Sender as TImage;
  Img.Left := Img.Tag shr 16;
  Img.Top := Img.Tag and $FFFF;
end;

procedure TForm1.ImageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Img: TImage;
begin
  Img := Sender as TImage;
  Img.Left := Img.Left + 2;
  Img.Top := Img.Top + 2;
end;

procedure TForm1.ImageMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Img: TImage;
begin
  Img := Sender as TImage;
  Img.Left := Img.Left - 2;
  Img.Top := Img.Top - 2;
end;

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
var
  r: Integer;
  FilePath, OldUrl, NewUrl: string;
  Lines: TStringList;
  i: Integer;
  Found: Boolean;
begin
  if SelectDirectory('เลือกโฟลเดอร์ปลายทาง', '', Cur) then
  begin
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

    // ✅ เช็คไฟล์ downloaded.txt
    FilePath := IncludeTrailingPathDelimiter(Cur) + 'downloaded.txt';
    if TFile.Exists(FilePath) then
    begin
      Lines := TStringList.Create;
      try
        Lines.LoadFromFile(FilePath);
        Found := False;
        for i := 0 to Lines.Count - 1 do
        begin
          if Lines[i].StartsWith('url ') then
          begin
            OldUrl := Trim(Copy(Lines[i], 5, MaxInt)); // ตัด 'url '
            Found := True;
            Break;
          end;
        end;

        if Found then
        begin
          if MessageDlg('พบ URL เดิม: ' + OldUrl + sLineBreak +
                        'คุณต้องการใช้ URL นี้หรือไม่?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
          begin
            edt1.Text := OldUrl;
          end;
        end;
      finally
        Lines.Free;
      end;
    end
    else
    begin
      // ❌ ไม่เจอ → สร้างใหม่
      NewUrl := edt1.Text;
      TFile.WriteAllText(FilePath, 'url ' + NewUrl);
    end;
  end;

  // จัดตำแหน่ง Indicator ให้อยู่กลาง lbl3
  r := lbl3.Width div 2;
  r := r - (ActivityIndicator1.Width div 2);
  ActivityIndicator1.Left := r;
end;



procedure DeleteTempDownloadFiles(const Cur: string);
var
  SearchRec: TSearchRec;
  FilePath: string;
begin
  // Make sure directory path ends with backslash
  FilePath := IncludeTrailingPathDelimiter(Cur);

  try
    // Delete *.ytdl files
    if FindFirst(FilePath + '*.ytdl', faAnyFile, SearchRec) = 0 then
    begin
      repeat
        if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
        begin
          try
            TryRemoveFile(FilePath + SearchRec.Name);
          except
            on E: Exception do
              OutputDebugString(PChar('Error deleting ' + SearchRec.Name + ': '
                + E.Message));
          end;
        end;
      until FindNext(SearchRec) <> 0;
      FindClose(SearchRec);
    end;

    // Delete *.mp4.par* files
    if FindFirst(FilePath + '*.mp4.par*', faAnyFile, SearchRec) = 0 then
    begin
      repeat
        if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
        begin
          try
            TryRemoveFile(FilePath + SearchRec.Name);
          except
            on E: Exception do
              OutputDebugString(PChar('Error deleting ' + SearchRec.Name + ': '
                + E.Message));
          end;
        end;
      until FindNext(SearchRec) <> 0;
      FindClose(SearchRec);
    end;

        // Delete *.m4a.par* lly ped Your Mind) [Official MV].m4a
    if FindFirst(FilePath + '*.m4a.par*', faAnyFile, SearchRec) = 0 then
    begin
      repeat
        if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
        begin
          try
            TryRemoveFile(FilePath + SearchRec.Name);
          except
            on E: Exception do
              OutputDebugString(PChar('Error deleting ' + SearchRec.Name + ': '
                + E.Message));
          end;
        end;
      until FindNext(SearchRec) <> 0;
      FindClose(SearchRec);
    end;

    // Delete *.mp3.par* files
    if FindFirst(FilePath + '*.mp3.par*', faAnyFile, SearchRec) = 0 then
    begin
      repeat
        if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
        begin
          try
            TryRemoveFile(FilePath + SearchRec.Name);
          except
            on E: Exception do
              OutputDebugString(PChar('Error deleting ' + SearchRec.Name + ': '
                + E.Message));
          end;
        end;
      until FindNext(SearchRec) <> 0;
      FindClose(SearchRec);
    end;

    // Delete *.webm.par* files
    if FindFirst(FilePath + '*.webm.par*', faAnyFile, SearchRec) = 0 then
    begin
      repeat
        if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
        begin
          try
            TryRemoveFile(FilePath + SearchRec.Name);
          except
            on E: Exception do
              OutputDebugString(PChar('Error deleting ' + SearchRec.Name + ': '
                + E.Message));
          end;
        end;
      until FindNext(SearchRec) <> 0;
      FindClose(SearchRec);
    end;

  except
    on E: Exception do
      OutputDebugString(PChar('Error in DeleteTempDownloadFiles: ' +
        E.Message));
  end;
end;


procedure TForm1.btn2Click(Sender: TObject);
var
  ExpiryDate: TDate;
  url: string;
  FilePath: string;
  Lines: TStringList;
  i: Integer;
  Found: Boolean;
begin
  DeleteTempDownloadFiles(Cur);
  url := edt1.Text;
  FilePath := IncludeTrailingPathDelimiter(Cur) + 'downloaded.txt';

  Lines := TStringList.Create;
  try
    Found := False;
    if TFile.Exists(FilePath) then
    begin
      Lines.LoadFromFile(FilePath);
      for i := 0 to Lines.Count - 1 do
      begin
        if Lines[i].StartsWith('url ') then
        begin
          // เปรียบเทียบเฉพาะถ้าไม่ตรงจึงค่อยอัพเดต
          if Trim(Copy(Lines[i], 5, MaxInt)) <> url then
            Lines[i] := 'url ' + url;
          Found := True;
          Break;
        end;
      end;
    end;

    if not Found then
      Lines.Add('url ' + url); // ยังไม่มี url ในไฟล์เลย

    Lines.SaveToFile(FilePath);
  finally
    Lines.Free;
  end;

  // ตรวจสอบวันหมดอายุ
  ExpiryDate := EncodeDate(2027, 1, 1);
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

procedure TForm1.Delete1Click(Sender: TObject);
var
  f,s: TFileName;
begin
  if fllst1.ItemIndex <> -1 then
  begin
    f := fllst1.FileName;
    s := ExtractFileName(f);
    if MessageDlg('Delete this file: "' +  s + '"?',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      if TryRemoveFile(f) then
        ShowMessage('File deleted.')
      else
        ShowMessage('Failed to delete file!');
    end;
  end
  else
    ShowMessage('Please select a file first.');
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
  i: Integer;
const
  ValidChars: TSysCharSet = ['a' .. 'z', 'A' .. 'Z', '0' .. '9', '-', '_'];
begin
  Result := Length(s) = 11;
  if Result then
    for i := 1 to 11 do
      if not CharInSet(s[i], ValidChars) then
      begin
        Result := False;
        Break;
      end;
end;

function RunProcessAndWait(const CommandLine: string): Boolean;
var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  TempDir: string;
begin
  Result := False;
  ZeroMemory(@StartupInfo, SizeOf(StartupInfo));
  ZeroMemory(@ProcessInfo, SizeOf(ProcessInfo));
  StartupInfo.cb := SizeOf(StartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := SW_HIDE;

  // กำหนด TEMP directory เป็น Working Directory
  TempDir := IncludeTrailingPathDelimiter(GetEnvironmentVariable('TEMP'));

  if CreateProcess(nil, PChar(CommandLine), nil, nil, False, CREATE_NO_WINDOW,
    nil, PChar(TempDir), StartupInfo, ProcessInfo) then
  begin
    // รอจนกว่าจะเสร็จ
    WaitForSingleObject(ProcessInfo.hProcess, INFINITE);
    CloseHandle(ProcessInfo.hProcess);
    CloseHandle(ProcessInfo.hThread);
    Result := True;
  end
  else
  begin
    OutputDebugString(PChar('⚠️ Failed to start process: ' + CommandLine));
  end;
end;

procedure TForm1.ProcessAllFiles;
var
  i: Integer;
  oldName, baseName, folderName, webpFile, jpgFile, mediaFile, tempFile,
    Ext: string;
begin
  if not FileExists(ff) then
    Exit;
  tempFile := IncludeTrailingPathDelimiter(GetEnvironmentVariable('TEMP'));
  folderName := ExtractFileName(ExcludeTrailingPathDelimiter(fllst1.Directory));
  mmo1.Lines.Clear;
  StopNow := False;
  ActivityIndicator1.Enabled := True;
  ActivityIndicator1.Visible := True;
  tmr1.Enabled := False;
  tmr2.Enabled := False;
  imgStop.Visible := True;
  for i := 0 to fllst1.Items.Count - 1 do
  begin

    if StopNow then
      Break;

    oldName := IncludeTrailingPathDelimiter(fllst1.Directory) + fllst1.Items[i];
    baseName := TPath.GetFileNameWithoutExtension(oldName);
    mmo1.Lines.Add(baseName);
    Ext := LowerCase(TPath.GetExtension(oldName));
    webpFile := IncludeTrailingPathDelimiter(fllst1.Directory) + baseName
      + '.webp';

    if TFile.Exists(webpFile) and ((Ext = '.mp3') or (Ext = '.mp4')) then
    begin
      // 1. สร้างภาพ JPG จาก WEBP
      jpgFile := IncludeTrailingPathDelimiter(fllst1.Directory) +
        baseName + '.jpg';
      ShellExecute(0, nil, 'ffmpeg',
        PChar(Format
        ('-i "%s" -vf "crop=min(in_w\,in_h):min(in_w\,in_h), scale=500:500" "%s"',
        [webpFile, jpgFile])), PChar(tempFile), SW_HIDE);
      mmo1.Lines.Add(webpFile);
      Sleep(1500);
      if not FileExists(jpgFile) then
        Break;

      mediaFile := oldName;
      tempFile := IncludeTrailingPathDelimiter(GetEnvironmentVariable('TEMP')) +
        baseName + Ext;
      mmo1.Lines.Add(tempFile);
      if Ext = '.mp3' then
      begin
        // 2A. ฝังภาพลง MP3
        RunProcessAndWait
          (Format('"%s" -i "%s" -i "%s" -map 0 -map 1 -c copy -id3v2_version 3 '
          + '-metadata:s:v title="%s" -metadata:s:v comment="BackSword ValenTine" '
          + '-metadata:s:v Decoder="BackSword ValenTine" "%s"',
          [ff, mediaFile, jpgFile, folderName, tempFile]));
      end
      else if Ext = '.mp4' then
      begin
        // 2B. ฝังภาพลง MP4 (แปะภาพเป็น stream cover)
        RunProcessAndWait(Format('"%s" -i "%s" -i "%s" -map 0 -map 1 -c copy ' +
          '-disposition:v:1 attached_pic "%s"', [ff, mediaFile, jpgFile,
          tempFile]));
      end;

      Sleep(2000);

      // 3. แทนที่ไฟล์เดิม
      try
        TFile.Delete(mediaFile);
      finally
        mmo1.Lines.Add('Delete ' + mediaFile);
      end;
      try
        TFile.Move(tempFile, mediaFile);
      finally
        mmo1.Lines.Add('Move ' + mediaFile);
      end;

      // 4. ลบไฟล์ชั่วคราว
      try
        TFile.Delete(webpFile);
      finally
        mmo1.Lines.Add('Delete ' + webpFile);
      end;
      try
        TFile.Delete(jpgFile);
      finally
        mmo1.Lines.Add('Delete ' + jpgFile);
      end;

    end;

  end;
  ActivityIndicator1.Enabled := False;
  ActivityIndicator1.Visible := False;
  tmr1.Enabled := True;
  tmr2.Enabled := True;
  imgStop.Visible := False;
end;

procedure TForm1.Renameall1Click(Sender: TObject);
begin
  idthrdcmpnt3.Start;

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

function RemoveYouTubeID(const FileName: string): string;
var
  StartBracket, EndBracket: Integer;
begin
  Result := FileName;
  StartBracket := LastDelimiter('[', FileName);
  EndBracket := LastDelimiter(']', FileName);

  // ตรวจสอบว่ามี [ID] อยู่จริงและอยู่ท้ายชื่อ
  if (StartBracket > 0) and (EndBracket > StartBracket) then
  begin
    // ตัดชื่อก่อน [ID]
    Result := Trim(Copy(FileName, 1, StartBracket - 1));
  end;

  // เอา .นามสกุล ออกถ้ายังเหลือ
  if Pos('.', Result) > 0 then
    Result := Copy(Result, 1, LastDelimiter('.', Result) - 1);
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

  Progress: Double;
  ItemInfo: string;

begin
  StopNow := False;
  FillChar(sa, SizeOf(sa), 0);
  sa.nLength := SizeOf(sa);
  sa.bInheritHandle := True;

  if not CreatePipe(hReadPipe, hWritePipe, @sa, 0) then
    Exit;

  ActivityIndicator1.Enabled := True;
  ActivityIndicator1.Visible := True;
  ComboBox1.Enabled := False;
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
      imgStop.Visible := True;
      repeat

        if StopNow then
        begin
          TerminateProcess(pi.hProcess, 1); // หยุด process ทันที
          Break;
        end;

        ReadFile(hReadPipe, buffer, SizeOf(buffer), bytesRead, nil);
        if bytesRead > 0 then
        begin
          output := Copy(buffer, 1, bytesRead);
          s := string(output);
          s := RemoveEmptyLines(s);
          s := s.Trim;
          j := Pos('[download] Destination:', s);
          if j = 1 then
          begin
            s := s.Remove(0, 23);

            s := RemoveYouTubeID(s);
            TnameMusic := s;
            lbl1.Caption := s;
          end
          else if Pos('[download]', s) = 1 then
          begin
            ParseYTDLPOutput(s, Progress, ItemInfo);
            if Progress >= 0 then
              TProgress := Progress;
            if ItemInfo <> '' then
              TItemInfo := ItemInfo;
            if ((TProgress <> 0) AND (TItemInfo <> '')) then
              lbl3.Caption := Format('🔄%.2f%% | 🎵%s | 📌%s'#13#10'💾: %s',
                [TProgress, TnameMusic, TItemInfo, Cur])
            else if TItemInfo <> '' then
              mmo1.Lines.Add('start ' + TItemInfo)
            else if TProgress <> 0 then
              mmo1.Lines.Add(TProgress.ToString);

          end
          else if Pos('s/12563', s) > 1 then
          begin
          {WARNING: [youtube] a1wW0AjQCI8: Some tv client https formats have been skipped as they are
DRM protected. The current session may have an experiment that applies DRM to all videos on the tv client. See
 https://github.com/yt-dlp/yt-dlp/issues/12563  for more details.}
              mmo1.Lines.Add('❗ บางฟอร์แมตที่เป็น tv client https ถูกข้ามไป เพราะมันถูกป้องกันด้วย DRM (Digital Rights Management)'+
'และ session ปัจจุบันอาจจะมี "experiment" บางอย่างจากฝั่ง YouTube ที่บังคับใช้ DRM กับทุกวิดีโอ เมื่อโหลดผ่าน client แบบ TV หมายถึง รองรับ MP4');
          end else

            mmo1.Lines.Add(s);
        end;
      until bytesRead = 0;

      WaitForSingleObject(pi.hProcess, INFINITE);
      CloseHandle(pi.hProcess);
      CloseHandle(pi.hThread);
      imgStop.Visible := False;
    end;

    // Result := string(output); // แปลง AnsiString → Unicode
  finally
    CloseHandle(hReadPipe);
  end;
  ActivityIndicator1.Enabled := False;
  ActivityIndicator1.Visible := False;
  imgStop.Visible := False;
  ComboBox1.Enabled := True;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  Ini: TIniHelper;
  p: string;
  i: Integer;
begin
  p := ExtractFilePath(ParamStr(0));
  Ini := TIniHelper.Create(p + 'config.ini');
  Ini.WriteString('setting', 'Cur', Cur);
  Ini.WriteString('setting', 'links', edt1.Text);
  if tglswtch1.State = tssOn then
    Ini.WriteBool('setting', 'tglswtch1', True)
  else
    Ini.WriteBool('setting', 'tglswtch1', False);
  Ini.WriteInteger('setting', 'style', ComboBox1.ItemIndex);
  for i := 0 to ComboBox1.Items.Count - 1 do
  begin
    p := ComboBox1.Items[i];
    Ini.WriteString('style', IntToStr(i), p);
    Ini.WriteInteger('style', 'count', i);
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

  DllPath := TPath.Combine(TempPath, 'avcodec-62.dll');
  if not FileExists(DllPath) then
  begin
    try
      ResStream := TResourceStream.Create(HInstance, 'Resource_1', RT_RCDATA);
      try
        ResStream.SaveToFile(DllPath);
      finally
        ResStream.Free;
      end;
    except
      raise Exception.Create('ไม่สามารถคลาย resource avcodec ได้');
    end;
  end;

  DllPath := TPath.Combine(TempPath, 'avdevice-62.dll');
  if not FileExists(DllPath) then
  begin
    try
      ResStream := TResourceStream.Create(HInstance, 'Resource_2', RT_RCDATA);
      try
        ResStream.SaveToFile(DllPath);
      finally
        ResStream.Free;
      end;
    except
      raise Exception.Create('ไม่สามารถคลาย resource avdevice ได้');
    end;
  end;

  DllPath := TPath.Combine(TempPath, 'avfilter-11.dll');
  if not FileExists(DllPath) then
  begin
    try
      ResStream := TResourceStream.Create(HInstance, 'Resource_3', RT_RCDATA);
      try
        ResStream.SaveToFile(DllPath);
      finally
        ResStream.Free;
      end;
    except
      raise Exception.Create('ไม่สามารถคลาย resource avfilter ได้');
    end;
  end;

  DllPath := TPath.Combine(TempPath, 'avformat-62.dll');
  if not FileExists(DllPath) then
  begin
    try
      ResStream := TResourceStream.Create(HInstance, 'Resource_4', RT_RCDATA);
      try
        ResStream.SaveToFile(DllPath);
      finally
        ResStream.Free;
      end;
    except
      raise Exception.Create('ไม่สามารถคลาย resource avformat-62 ได้');
    end;
  end;

  DllPath := TPath.Combine(TempPath, 'avutil-60.dll');
  if not FileExists(DllPath) then
  begin
    try
      ResStream := TResourceStream.Create(HInstance, 'Resource_5', RT_RCDATA);
      try
        ResStream.SaveToFile(DllPath);
      finally
        ResStream.Free;
      end;
    except
      raise Exception.Create('ไม่สามารถคลาย resource avutil-60 ได้');
    end;
  end;

  DllPath := TPath.Combine(TempPath, 'ffmpeg.exe');
  ff := DllPath;
  if not FileExists(DllPath) then
  begin
    try
      ResStream := TResourceStream.Create(HInstance, 'Resource_6', RT_RCDATA);
      try
        ResStream.SaveToFile(DllPath);
      finally
        ResStream.Free;
      end;
    except
      raise Exception.Create('ไม่สามารถคลาย resource ffmpeg ได้');
    end;
  end;

  DllPath := TPath.Combine(TempPath, 'ffplay.exe');
  if not FileExists(DllPath) then
  begin
    try
      ResStream := TResourceStream.Create(HInstance, 'Resource_7', RT_RCDATA);
      try
        ResStream.SaveToFile(DllPath);
      finally
        ResStream.Free;
      end;
    except
      raise Exception.Create('ไม่สามารถคลาย resource ffplay ได้');
    end;
  end;

  DllPath := TPath.Combine(TempPath, 'ffprobe.exe');
  if not FileExists(DllPath) then
  begin
    try
      ResStream := TResourceStream.Create(HInstance, 'Resource_8', RT_RCDATA);
      try
        ResStream.SaveToFile(DllPath);
      finally
        ResStream.Free;
      end;
    except
      raise Exception.Create('ไม่สามารถคลาย resource ffprobe ได้');
    end;
  end;

  DllPath := TPath.Combine(TempPath, 'swresample-6.dll');
  if not FileExists(DllPath) then
  begin
    try
      ResStream := TResourceStream.Create(HInstance, 'Resource_9', RT_RCDATA);
      try
        ResStream.SaveToFile(DllPath);
      finally
        ResStream.Free;
      end;
    except
      raise Exception.Create('ไม่สามารถคลาย resource swresample.dll ได้');
    end;
  end;

  DllPath := TPath.Combine(TempPath, 'swscale-9.dll');
  if not FileExists(DllPath) then
  begin
    try
      ResStream := TResourceStream.Create(HInstance, 'Resource_10', RT_RCDATA);
      try
        ResStream.SaveToFile(DllPath);
      finally
        ResStream.Free;
      end;
    except
      raise Exception.Create('ไม่สามารถคลาย resource swscale.dll ได้');
    end;
  end;

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
  i, c: Integer;
  Ini: TIniHelper;
  p, s: string;
  DllPath: string;

begin
  KillProc.Start;
  ActivityIndicator1.Enabled := False;
  ActivityIndicator1.Visible := False;
  StyleManager := TStyleManager.Create;
  p := ExtractFilePath(ParamStr(0));
  Ini := TIniHelper.Create(p + 'config.ini');
  SlideStep := 0;
  SlideDirection := 1;
  c := Ini.ReadInteger('style', 'count', 0);
  if c > 0 then
  begin
    for i := 0 to c do
    begin
      s := Ini.ReadString('style', IntToStr(i), '');
      if Length(s) > 1 then

        ComboBox1.Items.Add(s);
    end;
  end
  else
  begin
    for i := 0 to Length(TStyleManager.StyleNames) - 1 do
      ComboBox1.Items.Add(TStyleManager.StyleNames[i]);
  end;
  ComboBox1.ItemIndex := Ini.ReadInteger('setting', 'style', 15);
  Cur := Ini.ReadString('setting', 'Cur', p);
  artist := Ini.ReadString('default', 'artist', '');
  if artist='' then Ini.WriteString('default', 'artist', 'ดาบดำ');
  album := Ini.ReadString('default', 'album', '');
  if album='' then Ini.WriteString('default', 'album', 'ตะบันหู');
  genre := Ini.ReadString('default', 'genre', '');
  if genre='' then Ini.WriteString('default', 'genre', 'DEV ROCK');
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
    'https://music.youtube.com/playlist?list=PLT7YIx5xXTI_5jd0raarWZ63lkdhR7fKE')
    );
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

procedure TForm1.FormResize(Sender: TObject);
var
  r: Integer;
begin
  r := lbl3.Width div 2;
  r := r - (ActivityIndicator1.Width div 2);
  ActivityIndicator1.Left := r;
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

procedure TForm1.idthrdcmpnt3Run(Sender: TIdThreadComponent);
begin
  idthrdcmpnt3.Stop;
  ProcessAllFiles;
end;

procedure TForm1.KillProcRun(Sender: TIdThreadComponent);
begin
  KillProc.Stop;
  KillProcessesByName(['yt-dlp.exe', 'youtube.dll']);
end;

procedure TForm1.imgDirecXClick(Sender: TObject);
var
  URL: string;
begin
  URL := 'https://www.microsoft.com/en-us/download/details.aspx?id=35';
  URL := StringReplace(URL, '"', '%22', [rfReplaceAll]);
  ShellExecute(0, 'open', PChar(URL), nil, nil, SW_SHOWNORMAL);
  // Winapi.ShellAPI;
end;


function RunAndGetOutput(const Command: string): string;
var
  SA: TSecurityAttributes;
  StdOutRd, StdOutWr: THandle;
  SI: TStartupInfo;
  PI: TProcessInformation;
  Buffer: array[0..1023] of AnsiChar;
  BytesRead: DWORD;
  Output: AnsiString;
  TempDir: string;
begin
  Result := '';
  FillChar(SA, SizeOf(SA), 0);
  SA.nLength := SizeOf(SA);
  SA.bInheritHandle := True;

  if not CreatePipe(StdOutRd, StdOutWr, @SA, 0) then Exit;
  try
    FillChar(SI, SizeOf(SI), 0);
    SI.cb := SizeOf(SI);
    SI.dwFlags := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
    SI.hStdOutput := StdOutWr;
    SI.hStdError := StdOutWr;
    SI.wShowWindow := SW_HIDE;

    TempDir := GetEnvironmentVariable('TEMP'); // ใช้เป็น current directory

    if CreateProcess(
      nil,
      PChar('cmd.exe /C ' + Command),
      nil,
      nil,
      True,
      CREATE_NO_WINDOW,
      nil,
      PChar(TempDir), // Set current directory เป็น TEMP
      SI,
      PI) then
    begin
      CloseHandle(StdOutWr);
      try
        while ReadFile(StdOutRd, Buffer, SizeOf(Buffer), BytesRead, nil) do
        begin
          if BytesRead = 0 then Break;
          Output := Output + Copy(Buffer, 1, BytesRead);
        end;
        WaitForSingleObject(PI.hProcess, INFINITE);
        CloseHandle(PI.hProcess);
        CloseHandle(PI.hThread);
      finally
        Result := string(Output);
      end;
    end;
  finally
    CloseHandle(StdOutRd);
  end;
end;


function GetShortPath(const LongPath: string): string;
var
  buffer: array[0..MAX_PATH-1] of Char;
begin
  if GetShortPathName(PChar(LongPath), buffer, MAX_PATH) > 0 then
    Result := string(buffer)
  else
    Result := LongPath;
end;


function IsVideoValid(const FileName: string): Boolean;
var
  Output, Command, TempFFProbe, SafeFile, Ext: string;
begin
  Result := False;
  TempFFProbe := IncludeTrailingPathDelimiter(GetEnvironmentVariable('TEMP')) + 'ffprobe.exe';

  if not FileExists(TempFFProbe) then
  begin
    ShowMessage('ไม่พบ ffprobe.exe ใน TEMP');
    Exit;
  end;

  if not FileExists(FileName) then
  begin
    ShowMessage('ไม่พบไฟล์: ' + FileName);
    Exit;
  end;

  // หานามสกุลไฟล์จริง ๆ เพื่อ copy แล้วไม่พลาด
  Ext := ExtractFileExt(FileName);
  SafeFile := IncludeTrailingPathDelimiter(GetEnvironmentVariable('TEMP')) + 'a' + Ext;

  // Copy ไป temp
  CopyFile(PChar(FileName), PChar(SafeFile), False);

  try
    // รัน ffprobe ที่ TEMP ด้วยชื่อไฟล์ปลอดภัย
    Command := 'ffprobe -v error ' + 'a' + Ext ;
    Output := RunAndGetOutput(Command);

    // ffprobe จะไม่มี output ถ้าไฟล์ปกติ
    Result := Trim(Output) = '';

    Command := 'ffprobe -v error -select_streams a:0 -show_entries stream=duration -of default=noprint_wrappers=1:nokey=1 a' + Ext ;
     Output := RunAndGetOutput(Command);
     form1.mmo1.Lines.Add(' length '+ Output + ' < '+FileName);
  finally
    // ลบไฟล์ชั่วคราวทิ้ง
    DeleteFile(SafeFile);
  end;
end;



procedure TForm1.imgRecheckClick(Sender: TObject);
var
  i: Integer;
  FileName: string;
begin
  if fllst1.Items.Count = 0 then Exit;

  for i := 0 to fllst1.Items.Count - 1 do
  begin
    FileName := IncludeTrailingPathDelimiter(Cur) + fllst1.Items[i];
    if IsVideoValid(FileName) then
      mmo1.Lines.Add('✅ OK: ' + fllst1.Items[i])
    else
    begin
      mmo1.Lines.Add('❌ Invalid: ' + fllst1.Items[i]);
      TryRemoveFile(FileName);
    end;
  end;
end;


procedure TForm1.imgRefClick(Sender: TObject);
begin
ProcThumbnail.Start;
//fllst1.Update;
end;

procedure TForm1.imgStopClick(Sender: TObject);
begin
  StopNow := True;
  Sleep(1000);
  KillProc.Start;
end;

procedure TForm1.imgWinampClick(Sender: TObject);
var
  URL: string;
begin
  URL := 'https://download.winamp.com/winamp/winamp_latest_full.exe';
  URL := StringReplace(URL, '"', '%22', [rfReplaceAll]);
  ShellExecute(0, 'open', PChar(URL), nil, nil, SW_SHOWNORMAL);
  // Winapi.ShellAPI;
end;

procedure TForm1.imgYouTubeClick(Sender: TObject);
var
  URL: string;
begin
  URL := 'https://music.youtube.com/';
  URL := StringReplace(URL, '"', '%22', [rfReplaceAll]);
  ShellExecute(0, 'open', PChar(URL), nil, nil, SW_SHOWNORMAL);
  // Winapi.ShellAPI;
end;

procedure AnimateCardSlide(CardPanel: TCardPanel; NewCard: TCard;
  SlideLeft: Boolean);
const
  SlideSteps = 20;
  SlideDelay = 10;
var
  i, delta: Integer;
  OldCard: TCard;
begin
  OldCard := CardPanel.ActiveCard;
  NewCard.Visible := True;
  NewCard.BringToFront;

  if SlideLeft then
    NewCard.Left := CardPanel.Width
  else
    NewCard.Left := -CardPanel.Width;

  delta := CardPanel.Width div SlideSteps;

  for i := 1 to SlideSteps do
  begin
    Application.ProcessMessages;
    Sleep(SlideDelay);

    if SlideLeft then
    begin
      OldCard.Left := OldCard.Left - delta;
      NewCard.Left := NewCard.Left - delta;
    end
    else
    begin
      OldCard.Left := OldCard.Left + delta;
      NewCard.Left := NewCard.Left + delta;
    end;
  end;

  CardPanel.ActiveCard := NewCard;
  OldCard.Left := 0;
  NewCard.Left := 0;
end;

procedure TForm1.lbl41Click(Sender: TObject);
var
  URL: string;
begin
  URL := 'https://web.facebook.com/backswva';
  URL := StringReplace(URL, '"', '%22', [rfReplaceAll]);
  ShellExecute(0, 'open', PChar(URL), nil, nil, SW_SHOWNORMAL);
  // Winapi.ShellAPI;
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

procedure TForm1.lblPROClick(Sender: TObject);
var
  URL: string;
begin
  URL := 'https://www.backswv.com/pro';
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
var
  r: Integer;
begin
  r := lbl3.Width div 2;
  r := r - (ActivityIndicator1.Width div 2);
  ActivityIndicator1.Left := r;
  fllst1.Directory := Cur;
  if tglswtch1.State = tssOn then
  begin
command :=
  '-f bestvideo[ext=mp4]+bestaudio[ext=m4a]/best ' +
  '--add-metadata ' +
  '--embed-thumbnail ' +
  '--no-post-overwrites ' +
  '--merge-output-format mp4 ' +
  '--download-archive downloaded.txt ' +
  '--output "%(title)s.%(ext)s"';
fllst1.Mask := '*.mp4';

  end
  else
  begin             //
command :=
  '-f bestaudio[ext=m4a]/bestaudio ' +
  '--extract-audio --audio-format mp3 ' +
  '--embed-thumbnail --add-metadata ' +
  '--metadata artist="'+artist+'" ' +
  '--metadata album="'+album+'" ' +
  '--metadata genre="'+genre+'" ' +
  '--no-post-overwrites ' +
  '--download-archive downloaded.txt ' +
  '--output "%(title)s.%(ext)s"';

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
var
  r: Integer;
begin

 imgRecheck.Visible := not ActivityIndicator1.Visible ;


  CheckForChanges;
  if fllst1.Items.Count = 0 then
  begin
    if spltvw1.Visible then
    begin
      spltvw1.Visible := False;
      r := lbl3.Width div 2;
      r := r - (ActivityIndicator1.Width div 2);
      ActivityIndicator1.Left := r;
    end;
  end
  else
  begin
    if spltvw1.Visible = False then
    begin
      spltvw1.Visible := True;
      r := lbl3.Width div 2;
      r := r - (ActivityIndicator1.Width div 2);
      ActivityIndicator1.Left := r;
    end;
  end;
end;

procedure TForm1.tmSlideTimer(Sender: TObject);
begin
  SlideStep := SlideStep + 20; // ความเร็วในการเลื่อน
  SlideTarget.Left := crdpnl1.Width - SlideStep;

  if SlideTarget.Left <= 0 then
  begin
    tmSlide.Enabled := False;
    SlideTarget.Left := 0;
    crdpnl1.ActiveCard := SlideTarget;
    // ซ่อนการ์ดเก่าได้ตามต้องการ
  end;
end;

procedure TForm1.img11Click(Sender: TObject);
var
  URL: string;
begin
  URL := 'https://web.facebook.com/backswva';
  URL := StringReplace(URL, '"', '%22', [rfReplaceAll]);
  ShellExecute(0, 'open', PChar(URL), nil, nil, SW_SHOWNORMAL);
  // Winapi.ShellAPI;
end;

procedure TForm1.img3Click(Sender: TObject);
begin
  SwitchCardAnimated;
end;

procedure TForm1.btn5Click(Sender: TObject);
begin
  SwitchCardAnimated;
end;

procedure TForm1.crdpnl1Gesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
  SwitchCardAnimated;
end;

procedure TForm1.SwitchCardAnimated;
begin
  if crdpnl1.ActiveCard = crd1 then
    crdpnl1.ActiveCard := crd2
  else
    crdpnl1.ActiveCard := crd1;
end;

procedure TForm1.ProcessAllFiles2;
var
  i: Integer;
  oldName, baseName, folderName, webpFile, jpgFile, mediaFile, tempFile, Ext,
    TempDir: string;
begin
  try
    TempDir := IncludeTrailingPathDelimiter(GetEnvironmentVariable('TEMP'));

    if not System.SysUtils.DirectoryExists(TempDir) then
    begin
      mmo1.Lines.Add('❌ Error: Temporary directory not found');
      Exit;
    end;

    if not System.SysUtils.DirectoryExists(fllst1.Directory) then
    begin
      mmo1.Lines.Add('❌ Error: Source directory not found');
      Exit;
    end;

    folderName := ExtractFileName
      (ExcludeTrailingPathDelimiter(fllst1.Directory));

    for i := 0 to fllst1.Items.Count - 1 do
    begin
      if Application.Terminated then
        Break;

      oldName := IncludeTrailingPathDelimiter(fllst1.Directory) +
        fllst1.Items[i];

      if not FileExists(oldName) then
      begin
        mmo1.Lines.Add('⚠️ Warning: File not found - ' + oldName);
        Continue;
      end;

      if not IsFileAccessible(oldName) then
      begin
        mmo1.Lines.Add('⚠️ Warning: File is in use - ' + oldName);
        Continue;
      end;

      baseName := TPath.GetFileNameWithoutExtension(oldName);
      Ext := LowerCase(TPath.GetExtension(oldName));
      tempFile := TempDir + baseName + Ext;
      webpFile := IncludeTrailingPathDelimiter(fllst1.Directory) + baseName
        + '.webp';
      jpgFile := IncludeTrailingPathDelimiter(fllst1.Directory) +
        baseName + '.jpg';
      mediaFile := oldName;

      if not FileExists(webpFile) then
        Continue;

      // Step 1: Convert WEBP → JPG
      if not FileExists(jpgFile) then
      begin
        ShellExecute(0, nil, 'ffmpeg',
          PChar(Format
          ('-i "%s" -vf "crop=min(in_w\,in_h):min(in_w\,in_h),scale=500:500" "%s"',
          [webpFile, jpgFile])), PChar(TempDir), SW_HIDE);
      end;

      if not WaitForFile(jpgFile, 3000) then
      begin
        mmo1.Lines.Add('❌ Error: JPG not created - ' + jpgFile);
        Continue;
      end;

      if not IsFileAccessible(mediaFile) then
      begin
        mmo1.Lines.Add('⚠️ File locked before embed - ' + mediaFile);
        SafeDeleteFile(jpgFile);
        Continue;
      end;

      // Step 2: Embed image
      if Ext = '.mp3' then
      begin

        RunProcessAndWait
          (Format('"ffmpeg" -i "%s" -i "%s" -map 0:0 -map 1:0 -c copy -id3v2_version 3 '
          + '-metadata title="%s" ' + '-metadata artist="BackSword ValenTine" '
          + '-metadata album="ดาบดำ วาเลนไทน์" ' + '-metadata date="2027" ' +
          '-metadata genre="BackSwv" ' + '-disposition:v attached_pic "%s"',
          [mediaFile, jpgFile, baseName, tempFile]));
        // baseName = ชื่อเพลงไม่รวม .mp3

      end
      else if Ext = '.mp4' then
      begin
        RunProcessAndWait
          (Format('"ffmpeg" -i "%s" -i "%s" -map 0 -map 1 -c copy ' +
          '-disposition:v:1 attached_pic "%s"', [mediaFile, jpgFile,
          tempFile]));
      end
      else
      begin
        mmo1.Lines.Add('⚠️ Unsupported file type: ' + mediaFile);
        Continue;
      end;

      // Step 3: Check output
      if not WaitForFile(tempFile, 5000) then
      begin
        mmo1.Lines.Add('❌ Error: Output file not created - ' + tempFile);
        Continue;
      end;

      // Step 4: Replace original file
      try
        if not SafeReplaceFile(mediaFile, tempFile) then
        begin
          mmo1.Lines.Add('❌ Error replacing file: ' + mediaFile);
          Continue;
        end;
      except
        on E: Exception do
        begin
          mmo1.Lines.Add('❌ Exception during replacement: ' + E.Message);
          Continue;
        end;
      end;

      // Step 5: Clean up
      SafeDeleteFile(webpFile);
      SafeDeleteFile(jpgFile);

      mmo1.Lines.Add('✅ Done: ' + baseName);
    end;
  except
    on E: Exception do
      mmo1.Lines.Add('🔥 Fatal Error: ' + E.Message);
  end;
end;

function TForm1.WaitForFile(const FileName: string; Timeout: Integer): Boolean;
var
  WaitTime: Integer;
begin
  WaitTime := 0;
  while not FileExists(FileName) and (WaitTime < Timeout) do
  begin
    Sleep(100);
    Inc(WaitTime, 100);
    if Application.Terminated then
      Exit(False);
  end;
  Result := FileExists(FileName);
end;

function TForm1.IsFileAccessible(const FileName: string): Boolean;
var
  FileHandle: THandle;
begin
  Result := False;
  if not FileExists(FileName) then
    Exit;

  // พยายามเปิดไฟล์ในโหมดอ่าน/เขียนแบบเอกสิทธิ์
  FileHandle := CreateFile(PChar(FileName), GENERIC_READ or GENERIC_WRITE, 0,
    nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);

  if FileHandle <> INVALID_HANDLE_VALUE then
  begin
    CloseHandle(FileHandle);
    Result := True;
  end;
end;

function TForm1.SafeReplaceFile(const TargetFile, SourceFile: string): Boolean;
var
  RetryCount: Integer;
begin
  Result := False;
  RetryCount := 0;

  while RetryCount < 3 do
  begin
    try
      if FileExists(TargetFile) then
      begin
        // ตรวจสอบก่อนลบ
        if not IsFileAccessible(TargetFile) then
        begin
          Inc(RetryCount);
          Sleep(500);
          Continue;
        end;

        TFile.Delete(TargetFile);
        if FileExists(TargetFile) then
        begin
          Inc(RetryCount);
          Sleep(500);
          Continue;
        end;
      end;

      // ตรวจสอบไฟล์ต้นทางก่อนย้าย
      if not IsFileAccessible(SourceFile) then
      begin
        mmo1.Lines.Add('Error: Source file is locked - ' + SourceFile);
        Exit;
      end;

      TFile.Move(SourceFile, TargetFile);
      Result := True;
      Exit;
    except
      on E: Exception do
      begin
        Inc(RetryCount);
        Sleep(500);
        if RetryCount >= 3 then
          mmo1.Lines.Add('File replacement error after retries: ' + E.Message);
      end;
    end;
  end;
end;

procedure TForm1.SafeDeleteFile(const FileName: string);
begin
  try
    if FileExists(FileName) then
      TFile.Delete(FileName);
  except
    on E: Exception do
      mmo1.Lines.Add('Warning: Could not delete file ' + FileName + ': ' +
        E.Message);
  end;
end;

procedure TForm1.ProcThumbnailRun(Sender: TIdThreadComponent);

begin
  ProcThumbnail.Stop;

  if not FileExists(ff) then
    Exit;
  if not System.SysUtils.DirectoryExists(Cur) then
  Exit;
  if fllst1.Items.Count <= 0 then
    Exit;
  KillStuckFFmpegProcesses;

  ProcessAllFiles2;
  fllst1.Update;
end;

procedure TForm1.KillStuckFFmpegProcesses;
var
  Snapshot: THandle;
  ProcessEntry: TProcessEntry32;
  ProcessHandle: THandle;
begin
  // สร้าง snapshot ของกระบวนการทั้งหมด
  Snapshot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if Snapshot = INVALID_HANDLE_VALUE then
    Exit;

  try
    ProcessEntry.dwSize := SizeOf(ProcessEntry);

    // เริ่มต้นการค้นหา
    if Process32First(Snapshot, ProcessEntry) then
    begin
      repeat
        // ตรวจสอบชื่อกระบวนการ
        if SameText(ProcessEntry.szExeFile, 'ffmpeg.exe') then
        begin
          // เปิดกระบวนการด้วยสิทธิ์ TERMINATE
          ProcessHandle := OpenProcess(PROCESS_TERMINATE, False,
            ProcessEntry.th32ProcessID);
          if ProcessHandle <> 0 then
            try
              // สั่งปิดกระบวนการ
              TerminateProcess(ProcessHandle, 0);
              OutputDebugString(PChar('Terminated ffmpeg.exe (PID: ' +
                IntToStr(ProcessEntry.th32ProcessID) + ')'));
            finally
              CloseHandle(ProcessHandle);
            end;
        end;
      until not Process32Next(Snapshot, ProcessEntry);
    end;
  finally
    CloseHandle(Snapshot);
  end;
end;

end.
