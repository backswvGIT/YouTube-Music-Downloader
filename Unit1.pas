unit Unit1;

interface

uses
  Winapi.Windows, TlHelp32, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Winapi.ShellAPI, System.UITypes,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.WinXPanels, Vcl.ExtCtrls,
  uIniHelper, Clipbrd, FileCtrl, RegularExpressions,
  Vcl.OleCtrls, SHDocVw, Vcl.StdCtrls, Vcl.WinXCtrls,
  IdBaseComponent, IdThreadComponent, JvComponentBase, JvComputerInfoEx,
  Vcl.ComCtrls, Vcl.CheckLst, System.JSON, System.NetEncoding, DateUtils,
  System.JSON.Readers, System.JSON.Types, Vcl.Imaging.pngimage,
  Vcl.Touch.GestureMgr, System.IOUtils, Vcl.Menus, dxGDIPlusClasses,
  Winapi.ShlObj, Winapi.ActiveX,
  Vcl.Themes, Vcl.Styles, Vcl.Shell.ShellCtrls, Vcl.Shell.ShellConsts,
  DragDrop, DropSource, DragDropFile, System.Skia, Vcl.Skia, AdvBadge,
  AdvMetroProgressBar, System.ImageList, Vcl.ImgList, Unit2;

type
  TForm1 = class(TForm)

    crdpnl1: TCardPanel;
    crd1: TCard;
    lbl1: TLabel;
    edt1: TEdit;
    lbl3: TLabel;
    info: TJvComputerInfoEx;
    idthrdcmpnt2: TIdThreadComponent;
    mmo1: TMemo;
    crd2: TCard;
    spltvw1: TSplitView;
    fllst1: TFileListBox;
    pnl1: TPanel;
    tmr1: TTimer;
    pm1: TPopupMenu;
    Play1: TMenuItem;
    Rename1: TMenuItem;
    Renameall1: TMenuItem;
    Delete1: TMenuItem;
    img6: TImage;
    img11: TImage;
    lbl41: TLabel;
    Label1: TLabel;
    ComboBox1: TComboBox;
    imgDirecX: TImage;
    imgWinamp: TImage;
    imgYouTube: TImage;
    tmSlide: TTimer;
    ActivityIndicator1: TActivityIndicator;
    tmr2: TTimer;
    idthrdcmpnt3: TIdThreadComponent;
    lblPRO: TLabel;
    KillProc: TIdThreadComponent;
    ProcThumbnail: TIdThreadComponent;
    pnl2: TPanel;
    cmbQuality: TComboBox;
    gstrmngr1: TGestureManager;
    btnMP3: TSkSvg;
    btnMP4: TSkSvg;
    grdpnl1: TGridPanel;
    pnlg: TPanel;
    pnlr: TPanel;
    AdvBadge1: TAdvBadgeLabel;
    btOpen: TSkSvg;
    sksvgLoad: TSkSvg;
    sksvgcancel: TSkSvg;
    sksvgtuh: TSkSvg;
    sksvgref: TSkSvg;
    sksvgfen: TSkSvg;
    sksvgtuh1: TSkSvg;
    pnl3: TPanel;
    pnl4: TPanel;
    lblStatus: TLabel;
    pnl41: TPanel;
    lblStatus1: TLabel;
    pnl42: TPanel;
    lblStatus2: TLabel;
    prog1: TAdvMetroProgressBar;
    prog2: TAdvMetroProgressBar;
    BalloonHint1: TBalloonHint;
    ImageList1: TImageList;

    procedure FormCreate(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure tglswtch1Click();
    procedure btn2Click(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure tglswtch2Click(Sender: TObject);
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
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnMP4Click(Sender: TObject);
    procedure btnMP3Click(Sender: TObject);
    procedure AdvBadge1BadgeClick(Sender: TObject);
    procedure fllst1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lblStatus2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lblStatus1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lblStatusMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

  private
    StopNow: Boolean;
    SlideStep: Integer;
    SlideDirection: Integer; //
    SlideTarget: TCard;

    StyleManager: TStyleManager;
    FChangeHandle: THandle;
    FPlaylist: TStringList;
    FIniHelper: TIniHelper;
    procedure UpdateBadge;
    procedure SavePlaylist;
    procedure LoadPlaylist;

    procedure ProcessAllFiles;
    procedure ProcessAllFiles2;
    procedure SwitchCardAnimated;
    procedure ToggleMP3MP4();
    procedure StartWatching(const ADirectory: string);
    procedure StopWatching;
    procedure CheckForChanges;

    procedure RunCommandAndCaptureOutput(const CommandLine: string);
    procedure ShowBalloonHintNow(Control: TControl; const HintText: string);
  public

    FActiveFFmpegCount: Integer;
    FMaxConcurrentFFmpeg: Integer;
    procedure KillStuckFFmpegProcesses;

    function WaitForFile(const FileName: string; Timeout: Integer): Boolean;
    function SafeReplaceFile(const TargetFile, SourceFile: string): Boolean;
    function IsFileAccessible(const FileName: string): Boolean;
    procedure SafeDeleteFile(const FileName: string);

    procedure delFPlaylist(const j: Integer);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

var
  sURL: string;

  command, Pathdll, Cur, ff: string;
  SlideDirection: Integer;
  SlideStep: Integer;
  SlideTotal: Integer;
  SlideNewCard, SlideOldCard: TCard;
  TProgress: double;
  TItemInfo, TnameMusic: string;
  artist, album, genre: string;
  MP3, MP4: Boolean;

procedure TForm1.SavePlaylist;
var
  I: Integer;
begin
  FIniHelper.WriteInteger('Playlist', 'Count', FPlaylist.Count);
  for I := 0 to FPlaylist.Count - 1 do
    FIniHelper.WriteString('Playlist', 'Item' + IntToStr(I), FPlaylist[I]);
end;

procedure TForm1.LoadPlaylist;
var
  I, Count: Integer;
  Item: string;
begin
  FPlaylist.Clear;
  Count := FIniHelper.ReadInteger('Playlist', 'Count', 0);
  for I := 0 to Count - 1 do
  begin
    Item := FIniHelper.ReadString('Playlist', 'Item' + IntToStr(I), '');
    if Item <> '' then
      FPlaylist.Add(Item);
  end;
end;

procedure TForm1.UpdateBadge;
begin

  AdvBadge1.Badge := IntToStr(FPlaylist.Count);
  AdvBadge1.Visible := FPlaylist.Count > 0;
end;

procedure TForm1.delFPlaylist(const j: Integer);
begin
  // ตรวจสอบว่า Playlist ไม่ว่าง
  if FPlaylist.IsEmpty then
  begin
    mmo1.Lines.Add('ไม่สามารถลบได้: Playlist ว่างอยู่แล้ว');
    Exit; // ออกจากเมธอดหากไม่มีข้อมูล
  end;

  // แสดง URL ที่กำลังจะลบ (รายการแรก)
  mmo1.Lines.Add('กำลังลบรายการ: ' + FPlaylist[j]);

  // ลบรายการแรกออกจาก Playlist
  FPlaylist.Delete(j);

  // บันทึกการเปลี่ยนแปลง
  SavePlaylist;

  // อัปเดตการแสดงผล
  UpdateBadge;

  // แสดงสถานะปัจจุบัน
  if FPlaylist.IsEmpty then
  begin
    mmo1.Lines.Add('ลบรายการเรียบร้อย - Playlist ว่างแล้ว');
    edt1.Text := ''; // เคลียร์ช่องกรอกหากไม่มีข้อมูล
  end
  else
  begin
    mmo1.Lines.Add('ลบรายการเรียบร้อย - จำนวนรายการเหลือ: ' +
      IntToStr(FPlaylist.Count));
    edt1.Text := FPlaylist[0]; // แสดงรายการใหม่แรก
  end;
end;

procedure TForm1.AdvBadge1BadgeClick(Sender: TObject);
var
  I: Integer;
  ListStr: string;
begin
  if FPlaylist.Count = 0 then
  begin
    ShowMessage('ไม่มีรายการใน Playlist');
    Exit;
  end;

  ListStr := 'รายการ Playlist:' + sLineBreak;
  for I := 0 to FPlaylist.Count - 1 do
    ListStr := ListStr + Format('%d. %s', [I + 1, FPlaylist[I]]) + sLineBreak;

  ShowMessage(ListStr);
end;

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
  var ProgressPercent: double; var CurrentItem: string);
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
  I: Integer;
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
        for I := Low(ProcessNames) to High(ProcessNames) do
        begin
          if SameText(ExtractFileName(ProcessEntry.szExeFile), ProcessNames[I])
            or SameText(ProcessEntry.szExeFile, ProcessNames[I]) then
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
  if Sender is TImage then
  begin
    Img := TImage(Sender);
    Img.Tag := (Img.Left shl 16) or Img.Top; // ซ่อนตำแหน่งเดิมใน Tag
    Img.Left := Img.Left - 1;
    Img.Top := Img.Top - 1;
  end
  else if Sender is TSkSvg then
  begin
    // ถ้า TSkSvg มีคุณสมบัติ Left/Top แบบเดียวกัน:
    // สมมุติว่าใช้ชื่อว่า Svg: TSkSvg;
    var
    Svg := TSkSvg(Sender);
    Svg.Tag := (Svg.Left shl 16) or Svg.Top;
    Svg.Left := Svg.Left - 1;
    Svg.Top := Svg.Top - 1;
  end;
end;

procedure TForm1.ImageMouseLeave(Sender: TObject);
begin
  if Sender is TImage then
  begin
    var
    Img := TImage(Sender);
    Img.Left := Img.Tag shr 16;
    Img.Top := Img.Tag and $FFFF;
  end
  else if Sender is TSkSvg then
  begin
    var
    Svg := TSkSvg(Sender);
    Svg.Left := Svg.Tag shr 16;
    Svg.Top := Svg.Tag and $FFFF;
  end;
end;

procedure TForm1.ImageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Sender is TImage then
  begin
    var
    Img := TImage(Sender);
    Img.Left := Img.Left + 2;
    Img.Top := Img.Top + 2;
  end
  else if Sender is TSkSvg then
  begin
    var
    Svg := TSkSvg(Sender);
    Svg.Left := Svg.Left + 2;
    Svg.Top := Svg.Top + 2;
  end;
end;

procedure TForm1.ImageMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Sender is TImage then
  begin
    var
    Img := TImage(Sender);
    Img.Left := Img.Left - 2;
    Img.Top := Img.Top - 2;
  end
  else if Sender is TSkSvg then
  begin
    var
    Svg := TSkSvg(Sender);
    Svg.Left := Svg.Left - 2;
    Svg.Top := Svg.Top - 2;
  end;
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

function BrowseForFolder(const Title: string; var FolderPath: string): Boolean;
var
  FileOpenDialog: IFileOpenDialog;
  ShellItem: IShellItem;
  pszPath: PWideChar;
begin
  Result := False;
  FolderPath := '';

  CoInitialize(nil);
  try
    if Succeeded(CoCreateInstance(CLSID_FileOpenDialog, nil,
      CLSCTX_INPROC_SERVER, IID_IFileOpenDialog, FileOpenDialog)) then
    begin
      FileOpenDialog.SetOptions(FOS_PICKFOLDERS);
      FileOpenDialog.SetTitle(PChar(Title));

      if Succeeded(FileOpenDialog.Show(0)) then
      begin
        if Succeeded(FileOpenDialog.GetResult(ShellItem)) then
        begin
          // แก้ไขตรงนี้ - ใช้ตัวแปรชั่วคราวสำหรับ PWideChar
          if Succeeded(ShellItem.GetDisplayName(SIGDN_FILESYSPATH, pszPath))
          then
          begin
            FolderPath := pszPath;
            CoTaskMemFree(pszPath); // ต้องคืนหน่วยความจำ
            Result := True;
          end;
        end;
      end;
    end;
  finally
    CoUninitialize;
  end;
end;

procedure TForm1.btn1Click(Sender: TObject);
var
  r: Integer;
  FilePath, OldUrl, NewUrl: string;
  Lines: TStringList;
  I: Integer;
  Found: Boolean;
  SelectedFolder: string;
begin
  // if SelectDirectory('เลือกโฟลเดอร์ปลายทาง', '', Cur) then
  if BrowseForFolder('เลือกโฟลเดอร์ปลายทาง', SelectedFolder) then
  begin
    lbl3.Caption := 'save to ' + SelectedFolder;
    Cur := SelectedFolder;
    fllst1.Directory := Cur;
    if MP4 then
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
        for I := 0 to Lines.Count - 1 do
        begin
          if Lines[I].StartsWith('url ') then
          begin
            OldUrl := Trim(Copy(Lines[I], 5, MaxInt)); // ตัด 'url '
            Found := True;
            Break;
          end;
        end;

        if Found then
        begin
          if MessageDlg('พบ URL เดิม: ' + OldUrl + sLineBreak +
            'คุณต้องการใช้ URL นี้หรือไม่?', mtConfirmation, [mbYes, mbNo], 0) = mrYes
          then
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

  FilePath: string;
  Lines: TStringList;
  I: Integer;
  Found: Boolean;
begin
  // DeleteTempDownloadFiles(Cur);
  if FPlaylist.IsEmpty then
  begin
    mmo1.Lines.Add('Playlist is empty');
    Exit;
  end;
  sURL := FPlaylist[0]; // หรือ FPlaylist.First
  edt1.Text := sURL;
  FilePath := IncludeTrailingPathDelimiter(Cur) + 'downloaded.txt';

  Lines := TStringList.Create;
  try
    Found := False;
    if TFile.Exists(FilePath) then
    begin
      Lines.LoadFromFile(FilePath);
      for I := 0 to Lines.Count - 1 do
      begin
        if Lines[I].StartsWith('url ') then
        begin
          // เปรียบเทียบเฉพาะถ้าไม่ตรงจึงค่อยอัพเดต
          if Trim(Copy(Lines[I], 5, MaxInt)) <> sURL then
            Lines[I] := 'url ' + sURL;
          Found := True;
          Break;
        end;
      end;
    end;

    if not Found then
      Lines.Add('url ' + sURL); // ยังไม่มี url ในไฟล์เลย

    Lines.SaveToFile(FilePath);
  finally
    Lines.Free;
  end;

  // ตรวจสอบวันหมดอายุ
  ExpiryDate := EncodeDate(2027, 1, 1);
  if Now > ExpiryDate then
    mmo1.Lines.Add('โปรแกรมหมดอายุ โปรดโหลดตัวใหม่')
  else
  begin
    idthrdcmpnt2.Start;
    ShowBalloonHintNow(sksvgcancel,
      'หยุดดาวน์โหลดที่ปุ่มนี้.. โหลดต่อภายหลังได้');
  end;
end;

procedure TForm1.ShowBalloonHintNow(Control: TControl; const HintText: string);
begin
  // ตรวจสอบว่า BalloonHint1 มีอยู่ในฟอร์ม
  if Assigned(BalloonHint1) then
  begin
    Control.Hint := HintText;
    Control.ShowHint := True;

    BalloonHint1.Style := bhsBalloon; // รูปแบบลูกโป่ง
    BalloonHint1.Delay := 2000; // แสดงทันที
    BalloonHint1.HideAfter := 5000; // แสดงนาน 3 วินาที
    BalloonHint1.Title := 'คำแนะนำ';
    BalloonHint1.ImageIndex := 0;
    // ตั้งค่าข้อความ Balloon Hint
    BalloonHint1.Description := HintText;

    // แสดง Balloon Hint ทันที
    BalloonHint1.ShowHint(Control);
  end;
end;

procedure TForm1.btn3Click(Sender: TObject);
var
  s: string;
begin
  s := Clipboard.AsText;
  if Pos('https://music.youtube.com/', s) = 1 then
  begin
    s := StripUrlParams(s);

    // เพิ่ม URL ลงใน List (ถ้ายังไม่มี)
    if FPlaylist.IndexOf(s) = -1 then
    begin
      FPlaylist.Add(s);
      if Length(edt1.Text) = 0 then
        edt1.Text := s;
      SavePlaylist;
      UpdateBadge;
      mmo1.Lines.Add('เพิ่มลงใน Playlist แล้ว');
      sksvgLoad.Hint := '';
      sksvgLoad.ShowHint := False;
      ShowBalloonHintNow(sksvgLoad, 'เริ่มดาวน์โหลดที่ปุ่มนี้');
    end
    else
      mmo1.Lines.Add('URL นี้มีอยู่ใน Playlist แล้ว');
  end
  else
    mmo1.Lines.Add('กรุณาคัดลอก URL Youtube เป็นลิสหรือเพลงเดียว');

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
  f, s: TFileName;
begin
  if fllst1.ItemIndex <> -1 then
  begin
    f := fllst1.FileName;
    s := ExtractFileName(f);
    if MessageDlg('Delete this file: "' + s + '"?', mtConfirmation,
      [mbYes, mbNo], 0) = mrYes then
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

procedure TForm1.fllst1Click(Sender: TObject);
begin
  // pm1
  if fllst1.ItemIndex <> -1 then
  begin
    pm1.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y)
  end;
end;

procedure TForm1.fllst1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
  begin
    fllst1.Font.Name := 'Segoe UI';
    fllst1.Font.Charset := DEFAULT_CHARSET;
    fllst1.Update;
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
const
  ValidChars: TSysCharSet = ['a' .. 'z', 'A' .. 'Z', '0' .. '9', '-', '_'];
begin
  Result := Length(s) = 11;
  if Result then
    for I := 1 to 11 do
      if not CharInSet(s[I], ValidChars) then
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
  TempDir := Form1.info.Folders.Temp + '\';

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
  I: Integer;
  oldName, baseName, folderName, webpFile, jpgFile, mediaFile, tempFile,
    Ext: string;
begin
  if not FileExists(ff) then
    Exit;
  tempFile := info.Folders.Temp + '\';
  folderName := ExtractFileName(ExcludeTrailingPathDelimiter(fllst1.Directory));
  mmo1.Lines.Clear;
  StopNow := False;
  ActivityIndicator1.Enabled := True;
  ActivityIndicator1.Visible := True;
  tmr1.Enabled := False;
  tmr2.Enabled := False;

  for I := 0 to fllst1.Items.Count - 1 do
  begin

    if StopNow then
      Break;

    oldName := IncludeTrailingPathDelimiter(fllst1.Directory) + fllst1.Items[I];
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
      tempFile := info.Folders.Temp + '\' + baseName + Ext;
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

procedure ExtractNumbersUsingRegex(const s: string;
  out current, total: Integer);
var
  Match: TMatch;
  ss: string;
begin
  if Pos('item', s) = 1 then
  begin
    ss := s.Remove(0, 5).Trim;
    Match := TRegEx.Match(ss, '^(\d+)\s+of\s+(\d+)$');
    if not Match.Success then
      raise Exception.Create('รูปแบบสตริงไม่ถูกต้อง');

    current := StrToIntDef(Match.Groups[1].Value, 0);
    total := StrToIntDef(Match.Groups[2].Value, 0);
  end
  else
  begin
    current := 0;
    total := 0;

  end;

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
  current, total: Integer;
  Progress: double;
  ItemInfo: string;

begin
  StopNow := False;
  FillChar(sa, SizeOf(sa), 0);
  sa.nLength := SizeOf(sa);
  sa.bInheritHandle := True;

  if not CreatePipe(hReadPipe, hWritePipe, @sa, 0) then
    Exit;
  sksvgcancel.Visible := True;
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
              lbl3.Caption := Cur
            else if TItemInfo <> '' then
              ExtractNumbersUsingRegex(TItemInfo, current, total)
            else if TProgress <> 0 then
              mmo1.Lines.Add(TProgress.ToString);
            if TProgress = 100 then
            begin
              fllst1.Visible := True;
              spltvw1.Visible := True;
              fllst1.Update;
            end;
            // procedure ExtractNumbersUsingRegex(const s: string; out current, total: Integer);
            lblStatus.Caption := ' 🎵 ' + TnameMusic + ' ';
            lblStatus1.Caption := ' 📌 ' + TItemInfo + ' ';
            lblStatus2.Caption := Format(' 🔄 %.2f%% ', [TProgress]);
            prog1.Position := Trunc(TProgress);
            prog2.Max := total;
            prog2.Position := current;

          end
          else if Pos('s/12563', s) > 1 then
          begin
            { WARNING: [youtube] a1wW0AjQCI8: Some tv client https formats have been skipped as they are
              DRM protected. The current session may have an experiment that applies DRM to all videos on the tv client. See
              https://github.com/yt-dlp/yt-dlp/issues/12563  for more details. }
            mmo1.Lines.Add
              ('❗ บางฟอร์แมตที่เป็น tv client https ถูกข้ามไป เพราะมันถูกป้องกันด้วย DRM (Digital Rights Management)'
              + 'และ session ปัจจุบันอาจจะมี "experiment" บางอย่างจากฝั่ง YouTube ที่บังคับใช้ DRM กับทุกวิดีโอ เมื่อโหลดผ่าน client แบบ TV หมายถึง รองรับ MP4');
          end
          else

            mmo1.Lines.Add(s);
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
  ActivityIndicator1.Enabled := False;
  ActivityIndicator1.Visible := False;
  sksvgcancel.Visible := False;
  ComboBox1.Enabled := True;
  if not FPlaylist.IsEmpty then
  begin
    j := FPlaylist.IndexOf(sURL);
    if ((j <> -1) AND (StopNow = False)) then
      delFPlaylist(j);
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // หากใช้ Timer
  tmr1.Enabled := False;
  tmr2.Enabled := False;
  tmSlide.Enabled := False;

  if idthrdcmpnt2.Active then
  begin
    idthrdcmpnt2.Terminate;
    idthrdcmpnt2.WaitFor;
  end;
  if idthrdcmpnt3.Active then
  begin
    idthrdcmpnt3.Terminate;
    idthrdcmpnt3.WaitFor; // KillProc   ProcThumbnail
  end;
  if KillProc.Active then
  begin
    KillProc.Terminate;
    KillProc.WaitFor;
  end;
  if ProcThumbnail.Active then
  begin
    ProcThumbnail.Terminate;
    ProcThumbnail.WaitFor;
  end;

  Action := caFree; // ปิดฟอร์มอย่างสมบูรณ์
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  Ini: TIniHelper;
  p: string;
  I: Integer;
begin
  StopNow := True;
  KillProc.Start;
  p := ExtractFilePath(ParamStr(0));
  Ini := TIniHelper.Create(info.Folders.Temp + '\config.ini');
  Ini.WriteString('setting', 'Cur', Cur);
  Ini.WriteString('setting', 'links', edt1.Text);
  Ini.WriteInteger('setting', 'cmbQuality', cmbQuality.ItemIndex);
  Ini.WriteBool('setting', 'MP3', MP3);
  Ini.WriteBool('setting', 'MP4', not MP3);
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
  Ini: TIniHelper;
  p: string;
  DllPath: string;

begin
  KillProc.Start;
  ActivityIndicator1.Enabled := False;
  ActivityIndicator1.Visible := False;
  StyleManager := TStyleManager.Create;
  p := ExtractFilePath(ParamStr(0));
  Ini := TIniHelper.Create(info.Folders.Temp + '\config.ini');

  FPlaylist := TStringList.Create;
  FPlaylist.Duplicates := dupIgnore; // ไม่เก็บ URL ซ้ำ
  FPlaylist.Sorted := True; // เรียงลำดับอัตโนมัติ

  FIniHelper := TIniHelper.Create(info.Folders.Temp + '\playlist.ini');
  LoadPlaylist;
  UpdateBadge;

  SlideStep := 0;
  SlideDirection := 1;
  cmbQuality.Items.Clear;
  cmbQuality.Items.Add('fast');
  cmbQuality.Items.Add('balanced');
  cmbQuality.Items.Add('Restore Quality');
  cmbQuality.ItemIndex := Ini.ReadInteger('setting', 'cmbQuality', 0);
  MP3 := Ini.ReadBool('setting', 'MP3', False);
  MP4 := not MP3;
  ToggleMP3MP4();
  {
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
    end; }
  ComboBox1.ItemIndex := Ini.ReadInteger('setting', 'style', 15);
  Cur := Ini.ReadString('setting', 'Cur', p);
  if not System.SysUtils.DirectoryExists(Cur) then
  // [dcc64 Warning] Unit1.pas(1488): W1000 Symbol 'DirectoryExists' is deprecated: 'Use SysUtils.DirectoryExists instead'
  begin
    // ถ้าโฟลเดอร์ถูกลบไปแล้ว ให้สร้างโฟลเดอร์ใหม่
    if not CreateDir(Cur) then
    begin
      ShowMessage('ไม่สามารถสร้างโฟลเดอร์: ' + Cur);
      Cur := p; // ใช้ค่า default ถ้าสร้างใหม่ไม่ได้
    end;
  end;
  // https://music.youtube.com/new_releases/albums

  artist := Ini.ReadString('default', 'artist', '');
  if artist = '' then
    Ini.WriteString('default', 'artist', 'ดาบดำ');
  album := Ini.ReadString('default', 'album', '');
  if album = '' then
    Ini.WriteString('default', 'album', 'ตะบันหู');
  genre := Ini.ReadString('default', 'genre', '');
  if genre = '' then
    Ini.WriteString('default', 'genre', 'DEV ROCK');
  lbl3.Caption := 'save to ' + Cur;
  lbl3.Hint := Cur;

  crdpnl1.ActiveCard := crd1;
  fllst1.Directory := Cur;
  StartWatching(Cur);
  tmr1.Interval := 1000;
  tmr1.Enabled := True;

  lbl3.ShowHint := True;
  edt1.Text := StripUrlParams(Ini.ReadString('setting', 'links',
    'https://music.youtube.com/playlist?list=PLT7YIx5xXTI_5jd0raarWZ63lkdhR7fKE')
    );

  Ini.Free;

  DllPath := ExtractYoutubeDLLFromResource;
  if FileExists(DllPath) then
    Pathdll := DllPath
  else if FileExists(p + 'youtube.dll') then
    Pathdll := p + 'youtube.dll';

  ComboBox1Change(Self);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  StopWatching;
  SavePlaylist;
  FPlaylist.Free;
  FIniHelper.Free;
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

var
  FLastChangeCheck: UInt64 = 0;

procedure TForm1.CheckForChanges;
const
  CHECK_INTERVAL_MS = 10000; // 10 วินาที
var
  nowTick: UInt64;
begin
  nowTick := GetTickCount64;
  // ตรวจว่าผ่านไป 10 วิหรือยัง
  if nowTick - FLastChangeCheck < CHECK_INTERVAL_MS then
    Exit;

  if (FChangeHandle <> 0) and (WaitForSingleObject(FChangeHandle, 0)
    = WAIT_OBJECT_0) then
  begin
    fllst1.Update;
    // ตั้งค่าสำหรับการเฝ้ารอบถัดไป
    FindNextChangeNotification(FChangeHandle);
    FLastChangeCheck := nowTick;
  end;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  StyleManager.TrySetStyle(ComboBox1.Text);
end;

var
  URL: string;

procedure TForm1.idthrdcmpnt2Run(Sender: TIdThreadComponent);
begin
  sksvgLoad.Enabled := False;
  cmbQuality.Visible := False;
  idthrdcmpnt2.Stop;
  Sleep(1000);
  StopNow := False;
  URL := '';
  while ((not Application.Terminated) AND (not FPlaylist.IsEmpty) AND
    (not StopNow)) do
  begin
    Sleep(1000);
    if URL <> FPlaylist[0] then
    begin
      URL := FPlaylist[0];
      sURL := FPlaylist[0];
      edt1.Text := sURL;
      RunCommandAndCaptureOutput(Pathdll + ' ' + command + ' ' + sURL);
    end;
  end;
  sksvgLoad.Enabled := True;
  cmbQuality.Visible := True;
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

function RunAndGetOutput(const command: string): string;
var
  sa: TSecurityAttributes;
  StdOutRd, StdOutWr: THandle;
  si: TStartupInfo;
  pi: TProcessInformation;
  buffer: array [0 .. 1023] of AnsiChar;
  bytesRead: DWORD;
  output: AnsiString;
  TempDir: string;
begin
  Result := '';
  FillChar(sa, SizeOf(sa), 0);
  sa.nLength := SizeOf(sa);
  sa.bInheritHandle := True;

  if not CreatePipe(StdOutRd, StdOutWr, @sa, 0) then
    Exit;
  try
    FillChar(si, SizeOf(si), 0);
    si.cb := SizeOf(si);
    si.dwFlags := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
    si.hStdOutput := StdOutWr;
    si.hStdError := StdOutWr;
    si.wShowWindow := SW_HIDE;

    TempDir := Form1.info.Folders.Temp;

    if CreateProcess(nil, PChar('cmd.exe /C ' + command), nil, nil, True,
      CREATE_NO_WINDOW, nil, PChar(TempDir), // Set current directory เป็น TEMP
      si, pi) then
    begin
      CloseHandle(StdOutWr);
      try
        while ReadFile(StdOutRd, buffer, SizeOf(buffer), bytesRead, nil) do
        begin
          if bytesRead = 0 then
            Break;
          output := output + Copy(buffer, 1, bytesRead);
        end;
        WaitForSingleObject(pi.hProcess, INFINITE);
        CloseHandle(pi.hProcess);
        CloseHandle(pi.hThread);
      finally
        Result := string(output);
      end;
    end;
  finally
    CloseHandle(StdOutRd);
  end;
end;

function GetShortPath(const LongPath: string): string;
var
  buffer: array [0 .. MAX_PATH - 1] of Char;
begin
  if GetShortPathName(PChar(LongPath), buffer, MAX_PATH) > 0 then
    Result := string(buffer)
  else
    Result := LongPath;
end;

function IsVideoValid(const FileName: string): Boolean;
var
  output, command, TempFFProbe, SafeFile, Ext: string;
begin
  Result := False;
  TempFFProbe := Form1.info.Folders.Temp + '\ffprobe.exe';

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
  SafeFile := Form1.info.Folders.Temp + '\a' + Ext;

  // Copy ไป temp
  CopyFile(PChar(FileName), PChar(SafeFile), False);

  try
    // รัน ffprobe ที่ TEMP ด้วยชื่อไฟล์ปลอดภัย
    command := 'ffprobe -v error ' + 'a' + Ext;
    output := RunAndGetOutput(command);

    // ffprobe จะไม่มี output ถ้าไฟล์ปกติ
    Result := Trim(output) = '';

    command :=
      'ffprobe -v error -select_streams a:0 -show_entries stream=duration -of default=noprint_wrappers=1:nokey=1 a'
      + Ext;
    output := RunAndGetOutput(command);
    Form1.mmo1.Lines.Add(' length ' + output + ' < ' + FileName);
  finally
    // ลบไฟล์ชั่วคราวทิ้ง
    DeleteFile(SafeFile);
  end;
end;

procedure TForm1.imgRecheckClick(Sender: TObject);
var
  I: Integer;
  FileName: string;
begin
  if fllst1.Items.Count = 0 then
    Exit;

  for I := 0 to fllst1.Items.Count - 1 do
  begin
    FileName := IncludeTrailingPathDelimiter(Cur) + fllst1.Items[I];
    if IsVideoValid(FileName) then
      mmo1.Lines.Add('✅ OK: ' + fllst1.Items[I])
    else
    begin
      mmo1.Lines.Add('❌ Invalid: ' + fllst1.Items[I]);
      TryRemoveFile(FileName);
    end;
  end;
end;

procedure TForm1.imgRefClick(Sender: TObject);
begin
  ProcThumbnail.Start;
            fllst1.Font.Charset := THAI_CHARSET;
            lblStatus2.Font.Charset := THAI_CHARSET;
            lblStatus1.Font.Charset := THAI_CHARSET;
            lblStatus.Font.Charset := THAI_CHARSET;
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
  I, delta: Integer;
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

  for I := 1 to SlideSteps do
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
  URL := ('https://www.backswv.com/index.php?pro=freeloadyoutubemusic');

  URL := StringReplace(URL, '"', '%22', [rfReplaceAll]);
  ShellExecute(0, 'open', PChar(URL), nil, nil, SW_SHOWNORMAL);
end;

procedure TForm1.lblStatus1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
  begin
    lblStatus1.Font.Name := 'Segoe UI';
    lblStatus1.Font.Charset := THAI_CHARSET;
    lblStatus1.Update;
  end;
end;

procedure TForm1.lblStatus2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
  begin
    lblStatus2.Font.Name := 'Segoe UI';
    lblStatus2.Font.Charset := THAI_CHARSET;
    lblStatus2.Update;
  end;
end;

procedure TForm1.lblStatusMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
  begin
    lblStatus.Font.Name := 'Segoe UI';
    lblStatus.Font.Charset := THAI_CHARSET;
    lblStatus.Update;
  end;
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

procedure TForm1.tglswtch1Click();
var
  r: Integer;
begin
  // จัดตำแหน่ง ActivityIndicator
  r := lbl3.Width div 2;
  r := r - (ActivityIndicator1.Width div 2);
  ActivityIndicator1.Left := r;

  fllst1.Directory := Cur;

  if MP4 then
  begin
    // โหมดดาวน์โหลด MP4 (วิดีโอ)
    case cmbQuality.ItemIndex of
      0: // 'low':
        command := '-f "best[height<=480]" --merge-output-format mp4';
      // ใช้ best เพื่อให้ได้ทั้งวิดีโอและเสียง
      1: // 'medium':
        command := '-f "best[height<=720]" --merge-output-format mp4';
      2: // 'high':
        command := '-f "best[height<=1080]" --merge-output-format mp4';
    else
      command := '-f "best" --merge-output-format mp4';
    end;

    command := command +
      ' --continue --embed-thumbnail --download-archive downloaded.txt --output "%(title)s.%(ext)s"';
    fllst1.Mask := '*.mp4';
  end
  else
  begin
    // โหมดดาวน์โหลด MP3 (เสียง) (เดิม)
    case cmbQuality.ItemIndex of
      0: // 'low':
        command := '-x --audio-format mp3 --audio-quality 9';
      1: // 'medium':
        command := '-x --audio-format mp3 --audio-quality 5';
      2: // 'high':
        command := '-x --audio-format mp3 --audio-quality 0';
    else
      command := '-x --audio-format mp3 --audio-quality 5';
    end;

    command := command + ' --continue --embed-thumbnail --add-metadata' +
      ' --metadata artist="' + artist + '"' + ' --metadata album="' + album +
      '"' + ' --metadata genre="' + genre + '"' +
      ' --no-post-overwrites --download-archive downloaded.txt' +
      ' --output "%(title)s.%(ext)s"';
    fllst1.Mask := '*.mp3';
  end;
end;

procedure TForm1.tglswtch2Click(Sender: TObject);
begin
  if MP4 then
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
  tmr1.Interval := 30000;
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

procedure TForm1.ToggleMP3MP4();
begin
  tglswtch1Click();
  if MP3 then
  begin
    // ตั้งค่าสำหรับ MP3 (Active)
    btnMP3.Svg.OverrideColor := TAlphaColorRec.Yellowgreen;
    btnMP3.Width := 32;
    btnMP3.Height := 50;

    // ตั้งค่าสำหรับ MP4 (Inactive)
    btnMP4.Svg.OverrideColor := TAlphaColorRec.Null;
    btnMP4.Width := 16;
    btnMP4.Height := 25;
  end
  else
  begin
    // ตั้งค่าสำหรับ MP4 (Active)
    btnMP4.Svg.OverrideColor := TAlphaColorRec.Yellowgreen;
    btnMP4.Width := 32;
    btnMP4.Height := 50;

    // ตั้งค่าสำหรับ MP3 (Inactive)
    btnMP3.Svg.OverrideColor := TAlphaColorRec.Null;
    btnMP3.Width := 16;
    btnMP3.Height := 25;
  end;
end;

procedure TForm1.btnMP3Click(Sender: TObject);
begin
  MP3 := not MP3;
  MP4 := not MP4;
  ToggleMP3MP4();
end;

procedure TForm1.btnMP4Click(Sender: TObject);
begin
  MP3 := not MP3;
  MP4 := not MP4;
  ToggleMP3MP4();
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
  I: Integer;
  oldName, baseName, folderName, webpFile, jpgFile, mediaFile, tempFile, Ext,
    TempDir: string;
begin
  try
    TempDir := info.Folders.Temp + '\';

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

    for I := 0 to fllst1.Items.Count - 1 do
    begin
      if Application.Terminated then
        Break;

      oldName := IncludeTrailingPathDelimiter(fllst1.Directory) +
        fllst1.Items[I];

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
sleep(1000);
 Exit;
  if not Application.Terminated then
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
