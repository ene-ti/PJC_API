unit u00_FunPro;
{*********************************************************************}
{                                                                     }
{   Unit de Funcoes e Procedures Uteis para todo o Sistema            }
{                                                                     }
{*********************************************************************}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, db, inifiles, Registry, Grids, Buttons, StrUtils, Mask,
  ComCtrls, DateUtils, system.UITypes;


Procedure ChecaArqIni;
Function AchaParametro(vConjunto,vParametro:String):String;
Function CargaParametrosIniciais:Boolean;
function TamanhoArquivo(vArquivo : String) : Integer;
Procedure LimpezaLogs(vDir : String; vManterUltimos : Integer);

function ChecaData(vData:string):string;
function checa_hora(v_texto:string):string;
function soma_tempo(vHHMM:String;vMinutosSoma:Integer):string;
function menos_tempo(vHHMM:String;vMinutosMenos:Integer):string;
function menos_dia(vData:String;vDiasMenos:Integer):string;
function IntStrZero(v_valor,v_tamanho:integer):String;
function Arredonda(vValor : Double; vCasas : Integer): Double;
function StrTamFixo(vValor:String; vTamanho:Integer; vAlinhaED, vValPreencher:String):String;
Function iif(Condicao: Boolean; RetornaTrue, RetornaFalse: Variant): Variant;

procedure LimparArqDir(vDir : String);
procedure CopiaArquivos(vMemoMens:TMemo; vDirOrig, vDirDest, vArq : String);
Function ValidarArquivo(vArquivo : String; vArqDeveExistir : Boolean):Boolean;
Function AjustaExtensao(vArquivo, vExtensaoCorreta : String):String;
Function AjustaNome(vArquivo, vNome : String):String;
procedure CarregarValorCombo(vCombo : TComboBox; vValor : String; vTam:Integer);
function InteiroParaData(vDataYYYYMMDD : Integer) : TDate;
function InteiroDataYYYYMMDD(vDataYYYYMMDD : Integer) : Integer;
function DtStrParaInteiro(vDtStr : String) : Integer;
function DataParaInteiro(fDt : TDateTime) : Integer;
procedure StatusBotao(vForm : TForm; vStatus : Boolean);
procedure StatusEdit(vForm : TForm; vStatus : Boolean);
Function RetiraSpace(s: String): String;
procedure ApagaRegistry(vUserId:LongInt);
procedure ApagaRegistryAtualizador;
procedure GravaRichEdit(vAcao:Integer; vRichE:TRichEdit; vTexto:String);

// antigo u00_Util
function ValidaCnpjCpf(Numero : String) : Boolean;
function CalculaCnpjCpf(Numero : String) : String;
function ValidaIE(Numero, Uf : String) : Boolean;
function CalculaMT(Numero : String) : String;
function CalculaGO(Numero : String) : String;
function CalculaMG(Numero : String) : String;
function CalculaAM(Numero : String) : String;
function CalculaMS(Numero : String) : String;
function CalculaRO(Numero : String) : String;
function CalculaRJ(Numero : String) : String;
function CalculaAC(Numero : String) : String;
function CalculaSP(Numero : String) : String;
function CalculaPR(Numero : String) : String;
function CalculaES(Numero : String) : String;
function CalculaAL(Numero : String) : String;
function ChecaUF(UF : string) : Boolean;
procedure LimpaEdit(Form: TForm);
procedure DisableEdit(Form: TForm);
procedure EnableEdit(Form: TForm; Cor : TColor);
//procedure SetaCorLabel(Form: TForm; Cor : String);
//function PosicionaLast(vTabela, vCampo : String) : String;
//function SomaData(DataOrigem: TDateTime; NrDia: Integer): TDateTime;
procedure QRDestroi;
function PriDiaDoMes(vData: TDateTime): TDateTime;
function UltDiaDoMes(vData: TDateTime): TDateTime;
function PegaUsrLogadoWindows : String;
function Crypto(Acao, Variavel : String):String;
function NumSemMasc(vMascara : String) : String;
function VlrSemMasc(vMascara : String) : String;
function MostraMascara(vCampo, vConteudo, vUF : String) : String;
function CEPValido(vCEP : string) : boolean;
function UFValida(vUF : string) : Boolean;
Function NomeMaquina : String;
function SemanaDoMes(DataAnalisada: TDateTime): byte;
procedure GravaArqIni(fChave,fNomeChave,fDadoChave:String);
function Traco(fCaracer: string; fTamanho: integer): string;
function GetSemanaParImpar(fDtRef:TDateTime):String;
function RemoveAcento(fStr:String;fDelEspacoBranco:boolean): String;
function AllTrim(fStr : String) : String;
// antigo u00_Util


implementation

Uses u00_Global, u00_SetupINI, u00_Conexao;

procedure ChecaArqIni;
var
  vNomeArqIni : String;
begin
  vgPathAplicacao := ExtractFilePath(Application.ExeName);

  vNomeArqIni  := vgPathAplicacao + C_nome_Arq_Ini;

  if not FileExists(vNomeArqIni) then
  begin
    MessageDlg('Aten��o o arquivo:' + #13#13 + vNomeArqIni + #13#13 +
               'N�o foi encontrado ou pode estar com problema!' + #13 +
               'Pressione <OK> para fazer a configura��o.', MTERROR, [MBOK], 0);
    Application.CreateForm(TfrmSetupINI, frmSetupINI);
    frmSetupINI.ShowModal;
    frmSetupINI.Free;
  end;
  if (CargaParametrosIniciais = false) then
  begin
    MessageDlg('Aten��o o arquivo:' + #13#13 + vNomeArqIni + #13#13 +
               'pode estar com problema!' + #13 +
               'Pressione <OK> para fazer a configura��o.' + #13#13 +
               'Apos ajutes, tente novamente.', MTERROR, [MBOK], 0);
    Application.CreateForm(TfrmSetupINI, frmSetupINI);
    frmSetupINI.ShowModal;
    frmSetupINI.Free;
  end;
end;

Function AchaParametro(vConjunto,vParametro:String):String;
var
  vPath : String;
  vIni : TIniFile;
begin
  Result := '';
  vPath  := vgPathAplicacao + C_nome_Arq_Ini;
  vIni   := TiniFile.Create(vPath);
  Result := vIni.ReadString(vConjunto,vParametro,'');
  vIni.Free;
end;

Function CargaParametrosIniciais:Boolean;
begin
  Result := True;
  vgPathAplicacao := ExtractFilePath(Application.ExeName);

  vgAppWebPorta  := AchaParametro('Aplicacao','AppWebPorta');
  vgAppSecretKey :=  Crypto('D', AchaParametro('Aplicacao','AppSecretKeyJWT'));
  vgAppusername  :=  Crypto('D', AchaParametro('Aplicacao','AppUserAdmin'));
  vgApppassword  :=  Crypto('D', AchaParametro('Aplicacao','AppPassAdmin'));

  vgBancoDriverID := AchaParametro('BancoDados','BDDriverID');
  vgBancoServer   := AchaParametro('BancoDados','BDServer');
  vgBancoPorta    := AchaParametro('BancoDados','BDPorta');
  vgBancoUserName := Crypto('D', AchaParametro('BancoDados','BDUserName'));
  vgBancoPassword := Crypto('D', AchaParametro('BancoDados','BDPassword'));
  vgBancoDatabase := AchaParametro('BancoDados','BDDatabase');

  if (vgAppWebPorta = '') or
     (vgAppSecretKey = '') or
     (vgAppusername = '') or
     (vgApppassword = '') or

     (vgBancoDriverID = '') or
     (vgBancoServer = '') or
     (vgBancoPorta = '') or
     (vgBancoUserName = '') or
     (vgBancoPassword = '') or
     (vgBancoDatabase = '') then
  begin
    Result := False;
  end;
end;

function TamanhoArquivo(vArquivo : String) : Integer;
var
  vArqTxt : TextFile;
begin
  Result := -1;
  try
    if FileExists(vArquivo) then
    begin
      AssignFile(vArqTxt, vArquivo);
      Reset(vArqTxt);
      Result := FileSize(vArqTxt);
      Flush(vArqTxt);
      CloseFile(vArqTxt);
    end;
  except
    Result := -1;
  end;
end;


Procedure LimpezaLogs(vDir : String; vManterUltimos : Integer);
var
  vStL : TStringList;
  vI, vUltimo, vOffSet : Integer;
  vSeaRec : TSearchRec;
  vStrOld, vStrNew, vStr : String;
begin
  vStL               := TStringList.Create;
  vStL.Sorted        := False;
  vStl.CaseSensitive := False;
  vStL.Duplicates    := dupIgnore;

  if (copy(vDir, Length(vDir), 1) <> '\') then vDir := vDir + '\';
  if FindFirst(vDir + '*.*', faAnyFile, vSeaRec) = 0 then
  begin
    vStL.Add(vDir + vSeaRec.Name);
    while FindNext(vSeaRec) = 0 do
    begin
      vStL.Add(vDir + vSeaRec.Name);
    end;
  end;
  FindClose(vSeaRec);

  vStL.Sorted := True;
  vStrOld     := '';
  vUltimo     := 0;

  for vI := (vStL.Count - 1) downto 0 do
  begin
    vStrNew := ExtractFileName(vStL.Strings[vI]);

    if (UpperCase(copy(vStrNew,1,3)) <> 'LOG') and
       (UpperCase(copy(vStrNew,1,3)) <> 'BKP') then
    begin
      vUltimo := 1;
      Continue;
    end;

    if (UpperCase(copy(vStrNew,1,3)) = 'LOG') then
    begin
      vOffSet  := (Pos('_', vStrNew) + 1);
      vStr     := UpperCase(copy(vStrNew,vOffSet,9));
      if (vStr = 'CONFIRMA_') then
        vOffSet := (PosEx('_', vStrNew, vOffSet) + 1);
      vStrNew := copy(vStrNew,1,PosEx('_', vStrNew,vOffSet));
    end;
    if (UpperCase(copy(vStrNew,1,3)) = 'BKP') then
    begin
      vOffSet := (Pos('_', vStrNew) + 1);
      vOffSet := (PosEx('_', vStrNew, vOffSet) + 1);
      vStrNew := copy(vStrNew,1,PosEx('_', vStrNew,vOffSet));
    end;

    if (vStrOld <> vStrNew) then
    begin
      vUltimo := 1;
    end
    else
    begin
      Inc(vUltimo);
      if (vUltimo > vManterUltimos) then
      begin
        DeleteFile(PChar(vStL.Strings[vI]));
      end;
    end;
    vStrOld := vStrNew;
  end;

  vStL.Free;
end;

function ChecaData(vData:string):string;
var
  vdia, vmes, vano : Integer;
  tmpData, tmpDataServer : TDateTime;
begin
  vdia := StrToIntDef(Trim(Copy(vData,1,2)),0);
  vmes := StrToIntDef(Trim(Copy(vData,3,2)),0);
  vano := StrToIntDef(Trim(Copy(vData,5,4)),0);

  if (vdia > 0) then
  begin
    tmpDataServer := now;
    if (vmes = 0) then
    begin
      vData := IntStrZero(vdia,2) + FormatDateTime('mmyyyy', tmpDataServer);
    end
    else
    begin
      if (vano = 0) then
      begin
        vData := IntStrZero(vdia,2) + IntStrZero(vmes,2) + FormatDateTime('yyyy', tmpDataServer);
      end
      else
      begin
        vData := IntStrZero(vdia,2) + IntStrZero(vmes,2) + IntStrZero(vano,4);
      end;
    end;

    try
     tmpData := StrToDate(Copy(vData,1,2) + '/' + Copy(vData,3,2) + '/' + Copy(vData,5,4));
     result := FormatDateTime('dd/mm/yyyy', tmpData);
    except
     messagedlg('DATA INVALIDA!!! (informar: dd/mm/yyyy)   ', MTERROR, [MBOK], 0);
     result := '';
    end; //try
  end
  else
  begin
    tmpDataServer := now;
    result := formatdatetime('dd/mm/yyyy', tmpDataServer);
  end;
end;


function checa_hora(v_texto:string):string;
var
  tmp_time:ttime;
begin
  if length(trim(v_texto)) < 2 then
  begin
    result := '';
    exit;
  end;
  if length(trim(v_texto)) < 4 then
  begin
    messagedlg('   HORA INVALIDA!!! (informar: hh:mm)   ', MTERROR, [MBOK], 0);
    result := v_texto;
    exit;
  end;
  try
    tmp_time := strtotime(v_texto);
    result := formatdatetime('hh:nn', tmp_time);
  except
    messagedlg('   HORA INVALIDA!!! (informar: hh:mm)   ', MTERROR, [MBOK], 0);
    result := v_texto;
  end;
end;

function soma_tempo(vHHMM:String;vMinutosSoma:Integer):string;
var vhh,vmm:integer;
begin
  vhh := StrtoInt(copy(vHHMM,1,2));
  vmm := StrtoInt(copy(vHHMM,3,2));
  vmm := vmm + vMinutosSoma;
  while vmm > 59 do
  begin
    vmm := vmm - 60;
    vhh := vhh + 1;
    if vhh = 24 then
      vhh := 00;
  end;
  result := intstrzero(vhh,2) + intstrzero(vmm,2);
end;

function menos_tempo(vHHMM:String;vMinutosMenos:Integer):string;
var vhh,vmm:integer;
begin
  vhh := StrtoInt(copy(vHHMM,1,2));
  vmm := StrtoInt(copy(vHHMM,4,2));
  vmm := vmm - vMinutosMenos;
  while vmm < 0 do
  begin
    vmm := vmm + 60;
    vhh := vhh - 1;
    if vhh < 0  then
      vhh := 23;
  end;
  result := intstrzero(vhh,2) + intstrzero(vmm,2);
end;

function menos_dia(vData:String;vDiasMenos:Integer):string;
var vyy,vmm,vdd, vi:integer;
begin
  vyy := StrtoInt(copy(vData,1,4));
  vmm := StrtoInt(copy(vData,5,2));
  vdd := StrtoInt(copy(vData,7,2));
  for vi := 1 to vDiasMenos do
  begin
    vdd := vdd - 1;
    if vdd < 1 then
    begin
      vmm := vmm - 1;
      if vmm < 1 then
      begin
        vmm := 12;
        vyy := vyy - 1;
      end;
      if (vmm = 1) or (vmm = 3) or (vmm = 5) or (vmm = 7) or
         (vmm = 8) or (vmm = 10) or (vmm = 12) then
        vdd := 31;
      if (vmm = 4) or (vmm = 6) or (vmm = 9) or (vmm = 11) then
        vdd := 30;
      if (vmm = 2) then
      begin
        vdd := 28;
        if (vyy mod 4) = 0 then
          vdd := 29;
      end;
    end;
  end;
  result := intstrzero(vyy,4) + intstrzero(vmm,2) + intstrzero(vdd,2);
end;

function IntStrZero(v_valor,v_tamanho:integer):String;
var
   tmp_tamanho:integer;
   tmp_valor:string;
begin
  tmp_valor:=inttostr(v_valor);
  tmp_tamanho:=length(tmp_valor);
  while tmp_tamanho < v_tamanho do
  begin
      tmp_valor := '0' + tmp_valor;
      tmp_tamanho := tmp_tamanho + 1;
  end;
  result:=tmp_valor
end;

function Arredonda(vValor : Double; vCasas : Integer): Double;
var
  tmpValor: Double;
begin
  case vCasas of
    0: tmpValor := round(vValor);
    1: tmpValor := round(vValor * 10) / 10;
    2: tmpValor := round(vValor * 100) / 100;
    3: tmpValor := round(vValor * 1000) / 1000;
    4: tmpValor := round(vValor * 10000) / 10000;
    5: tmpValor := round(vValor * 100000) / 100000;
    6: tmpValor := round(vValor * 1000000) / 1000000;
  else
    tmpValor    := vValor;
  end;
  result := tmpValor;
end;

function StrTamFixo(vValor:String; vTamanho:Integer; vAlinhaED, vValPreencher:String):String;
var
  vTmpValor   : String;
  vTmpTamanho : Integer;
begin
  vTmpValor   := Trim(vValor);
  vTmpTamanho := Length(vTmpValor);

  while vTmpTamanho < vTamanho do
  begin
    if (vAlinhaED = 'E') then
      vTmpValor   := (vTmpValor + vValPreencher)
    else
      vTmpValor   := (vValPreencher + vTmpValor);

    vTmpTamanho := (vTmpTamanho + 1);
  end;

  Result := vTmpValor
end;

function iif(Condicao: Boolean; RetornaTrue, RetornaFalse: Variant): Variant;
Begin
   If Condicao Then
      Result := RetornaTrue
   Else
      Result := RetornaFalse;
End;

procedure LimparArqDir(vDir : String);
var
  vSeaRec : TSearchRec;
begin
  if (copy(vDir, Length(vDir), 1) <> '\') then vDir := vDir + '\';

  if FindFirst(vDir + '*.*', faAnyFile, vSeaRec) = 0 then
  begin
    DeleteFile(PChar(vDir + vSeaRec.Name));
    while FindNext(vSeaRec) = 0 do
    begin
      DeleteFile(PChar(vDir + vSeaRec.Name));
    end;
  end;
  FindClose(vSeaRec);
end;

procedure CopiaArquivos(vMemoMens:TMemo; vDirOrig, vDirDest, vArq : String);
var
  vSeaRec : TSearchRec;
begin
  if (copy(vDirOrig, Length(vDirOrig), 1) <> '\') then vDirOrig := vDirOrig + '\';
  if (copy(vDirDest, Length(vDirDest), 1) <> '\') then vDirDest := vDirDest + '\';

  if FindFirst(vDirOrig + vArq, faAnyFile, vSeaRec) = 0 then
  begin
    if (vMemoMens <> nil) then vMemoMens.lines.add('Copiando Arquivo: ' + vSeaRec.Name);
    copyfile(PChar(vDirOrig + vSeaRec.Name), PChar(vDirDest + vSeaRec.Name), False);
    while FindNext(vSeaRec) = 0 do
    begin
      if vMemoMens <> nil then vMemoMens.lines.add('Copiando Arquivo: ' + vSeaRec.Name);
      CopyFile(PChar(vDirOrig + vSeaRec.Name), PChar(vDirDest + vSeaRec.Name), False);
    end;
  end;
  FindClose(vSeaRec);
end;

procedure ApagaRegistry(vUserId:LongInt);
var
  vReg : TRegistry;
  vVal:TStringList;
  I:Integer;
  vS:String;
begin
  vReg := TRegistry.Create;
  vVal:=TStringList.Create;
  vReg.RootKey := HKEY_CURRENT_USER;
  vReg.OpenKey('\Software\U.S. Robotics\Pilot Desktop\HotSync Manager', True);
  vReg.GetValueNames(vVal);
  vS := 'Install' + IntToStr(vUserId);

  for I:=0 to vVal.Count-1 do
  begin
   if (vVal.Strings[i] = vS) then
   begin
    vReg.DeleteValue(vVal.Strings[i]);
   end;
  end;

  vReg.CloseKey;
  vReg.Free;
  vVal.Clear;
  vVal.Free;
end;

procedure ApagaRegistryAtualizador;
var
  vReg : TRegistry;
  vStL : TStringList;
  vI, vX : Integer;
  vS : string;
begin
  try
    vReg := TRegistry.Create;
    vStL := TStringList.Create;
    vReg.RootKey := HKEY_LOCAL_MACHINE;
    vReg.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Run', False);
    vReg.GetValueNames(vStL);

    if (vStL.Count = 0) then
    begin
      vReg.CloseKey;
      vReg.Free;
      vStL.Free;
      exit;
    end;

    for vI := 0 to vStL.Count - 1 do
    begin
    // para remover a versao anterior
      vS := UpperCase(vStL.Strings[vI]);
      vX := Pos('SERVCOL', vS);
//      if (UpperCase(vStL.Strings[vI]) = 'SERVCOL-ATUALIZADOR') then
      if (vX > 0) then
      begin
        vReg.DeleteValue(vS);
      end;
      // para remover a versao anterior
      if (vStL.Strings[vI] = 'ServCol-AtualizadorCliente') or
         (vStL.Strings[vI] = 'ServCol-AtualizadorServer') then
      begin
        vReg.DeleteKey(vStL.Strings[vI]);
        vReg.CloseKey;
        vReg.Free;
        vStL.Free;
        exit;
      end;
    end;

    vReg.CloseKey;
    vReg.Free;
    vStL.Clear;
    vStL.Free;
  except
    on E: Exception do
    begin
      Exit;
    end;
  end;
end;


Function ValidarArquivo(vArquivo : String; vArqDeveExistir : Boolean):Boolean;
var
  vArq, vDir, vExt : String;
begin
  Result := False;
  try
    vArq := ExtractFileName(AnsiDequotedStr(vArquivo,'"'));
    vDir := ExtractFilePath(AnsiDequotedStr(vArquivo,'"'));
    vExt := ExtractFileExt(AnsiDequotedStr(vArquivo,'"'));

    if (Length(vArq) < 1) or (vArq = vExt) then
    begin
      MessageDlg('Nome de arquivo Invalido!!!', mtError, [mbOk], 0);
      Exit;
    end;

    if (not DirectoryExists(vDir)) then
    begin
      MessageDlg('Diretorio(pasta) Invalido!!!', mtError, [mbOk], 0);
      Exit;
    end;

    vArq := vDir + vArq;
    if (not vArqDeveExistir) then
    begin
      if (FileExists(vArq)) then
      begin
        if MessageDlg('ATEN��O!!! o arquivo: ' + #13 + vArq + #13 +
           'ja existe, deseja substitu�-lo?', mtWarning, [mbYes,mbNo], 0) <> mrYes then
        begin
          Exit;
        end;
      end;
    end
    else
    begin
      if (not FileExists(vArq)) then
      begin
        MessageDlg('ATEN��O!!! o arquivo: ' + #13 + vArq + #13 + 'n�o existe!!!', mtError, [mbOk], 0);
        Exit;
      end;
    end;

    Result := True;
  except
    on E: Exception do
    begin
      Result := False;
      MessageDlg('Arquivo Invalido!!! ' + #13#13 + E.Message, mtError, [mbOk], 0);
    end;
  end;
end;

Function AjustaExtensao(vArquivo, vExtensaoCorreta : String):String;
var
  vArq, vDir, vExt : String;
begin
  Result := vArquivo;
  vArq := ExtractFileName(AnsiDequotedStr(vArquivo,'"'));
  vDir := ExtractFilePath(AnsiDequotedStr(vArquivo,'"'));
  vExt := UpperCase(ExtractFileExt(AnsiDequotedStr(vArquivo,'"')));

  if (vExtensaoCorreta <> vExt) then
  begin
    Result := vArquivo + vExtensaoCorreta;
  end;

end;

Function AjustaNome(vArquivo, vNome : String):String;
var
  vArq, vDir, vExt : String;
begin
  vArq := ExtractFileName(AnsiDequotedStr(vArquivo,'"'));
  vDir := ExtractFilePath(AnsiDequotedStr(vArquivo,'"'));
  vExt := UpperCase(ExtractFileExt(AnsiDequotedStr(vArquivo,'"')));

  Result := vDir + vNome + '-' + vArq;

end;

procedure CarregarValorCombo(vCombo : TComboBox; vValor : String; vTam:Integer);
var
  vI : Integer;
begin
  vCombo.ItemIndex := -1;

  if (vValor = '') then
  begin
    vCombo.ItemIndex := -1;
    vCombo.Text      := '';
    Exit;
  end;
  for vI := 0 to vCombo.Items.Count - 1 do
  begin
    if (copy(vCombo.Items[vI],1,vTam) = vValor) then
    begin
      vCombo.ItemIndex := vI;
      Break;
    end;
  end;
end;


function InteiroParaData(vDataYYYYMMDD : Integer) : TDate;
var
  vAnoTmp, vAno, vMes, vDia : Integer;
  vAnoStr : String;
begin
  if (vDataYYYYMMDD = 0) then
  begin
    Result := now;
    exit;
  end;

  vAno      := StrToInt(Copy(IntStrZero(vDataYYYYMMDD,8),1,4));
  if Length(IntToStr(vDataYYYYMMDD)) = 6 then
  begin
    vAnoStr := Copy(IntStrZero(vDataYYYYMMDD,8),3,2);
    vAnoTmp := StrToInt(vAnoStr);
    vAno    := StrToInt('20' + Copy(IntStrZero(vDataYYYYMMDD,8),3,2));
    if (vAnoTmp >= 90) then
    begin
      vAno  := StrToInt('19' + Copy(IntStrZero(vDataYYYYMMDD,8),3,2));
    end;
  end;
  if Length(IntToStr(vDataYYYYMMDD)) = 7 then
  begin
    vAnoStr := Copy(IntStrZero(vDataYYYYMMDD,8),2,1);
    vAnoTmp := StrToInt(vAnoStr);
    vAno    := StrToInt('20' + Copy(IntStrZero(vDataYYYYMMDD,8),3,2));
    if (vAnoTmp = 0) then
    begin
      vAno  := StrToInt('19' + Copy(IntStrZero(vDataYYYYMMDD,8),3,2));
    end;
  end;

  vMes   := StrToInt(Copy(IntStrZero(vDataYYYYMMDD,8),5,2));
  vDia   := StrToInt(Copy(IntStrZero(vDataYYYYMMDD,8),7,2));
  Result := EncodeDate(vAno, vMes, vDia);
end;

function InteiroDataYYYYMMDD(vDataYYYYMMDD : Integer) : Integer;
var
  vAnoTmp, vAno : Integer;
  vAnoStr : String;
begin
  if (vDataYYYYMMDD = 0) then
  begin
    Result := 0;
    exit;
  end;

  vAno      := StrToInt(Copy(IntStrZero(vDataYYYYMMDD,8),1,4));
  if Length(IntToStr(vDataYYYYMMDD)) = 6 then
  begin
    vAnoStr := Copy(IntStrZero(vDataYYYYMMDD,8),3,2);
    vAnoTmp := StrToInt(vAnoStr);
    vAno    := StrToInt('20' + Copy(IntStrZero(vDataYYYYMMDD,8),3,2));
    if (vAnoTmp >= 90) then
    begin
      vAno  := StrToInt('19' + Copy(IntStrZero(vDataYYYYMMDD,8),3,2));
    end;
  end;
  if Length(IntToStr(vDataYYYYMMDD)) = 7 then
  begin
    vAnoStr := Copy(IntStrZero(vDataYYYYMMDD,8),2,1);
    vAnoTmp := StrToInt(vAnoStr);
    vAno    := StrToInt('20' + Copy(IntStrZero(vDataYYYYMMDD,8),3,2));
    if (vAnoTmp = 0) then
    begin
      vAno  := StrToInt('19' + Copy(IntStrZero(vDataYYYYMMDD,8),3,2));
    end;
  end;
  Result := StrToInt(IntToStr(vAno) + Copy(IntStrZero(vDataYYYYMMDD,8),5,4));
end;

function DtStrParaInteiro(vDtStr : String) : Integer;
var
  vAux : String;
  d    : TDateTime;
begin
  //Recebe a data no formato 30/05/2006 e devolve 20060530

  try
   d      := StrToDateTime(vDtStr);
  except
   vDtStr := FormatDateTime('dd/mm/yyyy',now);
  end;

  vAux := Copy(vDtStr,7,4) +
          Copy(vDtStr,4,2) +
          Copy(vDtStr,1,2);
  Result := StrToInt(vAux);
end;

function DataParaInteiro(fDt : TDateTime) : Integer;
begin
  //Recebe uma data no formato TDateTime e devolve no formato Inteiro yyyyMMdd

  Result := StrToIntDef(FormatDateTime('yyyymmdd', fDt),0);
end;



procedure StatusBotao(vForm : TForm; vStatus : Boolean);
var
  vI : Integer;
begin
  for vI := 0 to vForm.ComponentCount - 1 do
  begin
    if vForm.Components[vI] is TButton then
      (vForm.Components[vI] as TButton).Enabled := vStatus;
    if vForm.Components[vI] is TBitBtn then
      (vForm.Components[vI] as TBitBtn).Enabled := vStatus;
    if vForm.Components[vI] is TSpeedButton then
      (vForm.Components[vI] as TSpeedButton).Enabled := vStatus;
  end;
end;

procedure StatusEdit(vForm : TForm; vStatus : Boolean);
var
  vI : Integer;
begin
  for vI := 0 to vForm.ComponentCount - 1 do
  begin
    if vForm.Components[vI] is TEdit then
      (vForm.Components[vI] as TEdit).Enabled := vStatus;
    if vForm.Components[vI] is TCustomEdit then
      (vForm.Components[vI] as TCustomEdit).Enabled := vStatus;
    if vForm.Components[vI] is TMaskEdit then
      (vForm.Components[vI] as TMaskEdit).Enabled := vStatus;
    if vForm.Components[vI] is TComboBox then
      (vForm.Components[vI] as TComboBox).Enabled := vStatus;
    if vForm.Components[vI] is TRadioGroup then
      (vForm.Components[vI] as TRadioGroup).Enabled := vStatus;
    if vForm.Components[vI] is TListBox then
      (vForm.Components[vI] as TListBox).Enabled := vStatus;
    if vForm.Components[vI] is TCheckBox then
      (vForm.Components[vI] as TCheckBox).Enabled := vStatus;
    if vForm.Components[vI] is TDateTimePicker then
      (vForm.Components[vI] as TDateTimePicker).Enabled := vStatus;

  end;
end;


Function RetiraSpace(s: String): String;
var
  i : integer;
begin
  while Pos(' ',s) <> 0 do
  begin
   i := Pos(' ',s);
   s := copy(s, 0, i - 1) + copy(s, i + 1, length(s));
  end;
  Result := s;
end;

Function TrocaCaracter(s, letra: String): String;
var
  i : integer;
begin
  while Pos(' ',s) <> 0 do
  begin
   i := Pos(' ',s);
   s := copy(s, 0, i - 1) + copy(s, i + 1, length(s));
  end;
  Result := s;
end;

procedure GravaRichEdit(vAcao:Integer; vRichE:TRichEdit; vTexto:String);
begin
// vAcao = 01 - normal
// vAcao = 02 - Negrito
// vAcao = 03 - Centralizado-Negrito-Azul
// vAcao = 04 - normal-identado
  if (vAcao = 01) then  // vAcao = 01 - normal
  begin
    vRichE.Paragraph.Numbering := nsNone;
    vRichE.Paragraph.Alignment := taLeftJustify;
    vRichE.SelAttributes.Style := [];
    vRichE.SelAttributes.Name  := 'Courier New';
    vRichE.SelAttributes.Color := clWindowText;
    vRichE.SelAttributes.Size  := 8;
  end;
  if (vAcao = 02) then  // vAcao = 02 - Negrito
  begin
    vRichE.Paragraph.Numbering := nsNone;
    vRichE.Paragraph.Alignment := taLeftJustify;
    vRichE.SelAttributes.Style := [fsBold];
    vRichE.SelAttributes.Name  := 'Courier New';
    vRichE.SelAttributes.Color := clWindowText;
    vRichE.SelAttributes.Size  := 8;
  end;
  if (vAcao = 03) then  // vAcao = 03 - Centralizado-Negrito-Azul
  begin
    vRichE.Paragraph.Numbering := nsBullet;
    vRichE.Paragraph.Alignment := taCenter;
    vRichE.SelAttributes.Style := [fsBold];
    vRichE.SelAttributes.Name  := 'MS Sans Serif';
    vRichE.SelAttributes.Color := clBlue;
    vRichE.SelAttributes.Size  := 12;
  end;
  if (vAcao = 04) then  // vAcao = 04 - normal-identado
  begin
    vRichE.Paragraph.Numbering := nsBullet;
    vRichE.Paragraph.Alignment := taLeftJustify;
    vRichE.Paragraph.FirstIndent := 10;
    vRichE.SelAttributes.Style := [];
    vRichE.SelAttributes.Name  := 'Courier New';
    vRichE.SelAttributes.Color := clWindowText;
    vRichE.SelAttributes.Size  := 8;
  end;

  vRichE.Lines.add(vTexto);
end;

// antigo u00_Util
function ValidaCnpjCpf(Numero : String) : Boolean;
var
  i : integer;
  NumAux     : String;
  DigitoCalc : String;
begin
  if Length(Numero) = 0 then
   begin
    Result := False;
    Exit;
   end;

 //Tira Maskara
  NumAux := '';

  for i := 0 to Length(Numero) do
   begin
    if Numero[i] in ['0'..'9'] then
     NumAux := NumAux +  Numero[i];
   end;

  if Length(NumAux) = 14 then
   DigitoCalc := CalculaCnpjCpf(Copy(NumAux,1,12))
  else
   DigitoCalc := CalculaCnpjCpf(Copy(NumAux,1,9));

  Result := False;

  if DigitoCalc = NumAux then Result := True;
end;

function CalculaCnpjCpf(Numero : String) : String;
var
  i,j,k, Soma, Digito : Integer;
  CNPJ : Boolean;
begin
  Result := Numero;
  case Length(Numero) of
   9:  CNPJ := False;
   12: CNPJ := True;
  else
   begin
//   if Length(Numero) < 9 then
//    CNPJ := False;
   Exit;
   end;
  end;

  for j := 1 to 2 do
   begin
    k := 2;
    Soma := 0;

    for i := Length(Result) downto 1 do
     begin
      Soma := Soma + (Ord(Result[i])-Ord('0'))*k;
      Inc(k);

      if (k > 9) and CNPJ then
       k := 2;
     end;

    Digito := 11 - Soma mod 11;

    if Digito >= 10 then
      Digito := 0;
    Result := Result + Chr(Digito + Ord('0'));
   end;
end;

function ValidaIE(Numero, Uf : String) : Boolean;
var
  i,t,nZero  : integer;
  DigitoCalc : String;
  InscEst    : String;
  NumAux     : String;
begin
 if Length(Numero) = 0 then
  begin
    Result := False;
    Exit;
  end;

 //Tira Maskara

  NumAux := '';

  for i := 0 to Length(Numero) do
   begin
    if Numero[i] in ['0'..'9'] then
     NumAux := NumAux +  Numero[i];
   end;

  t :=  Length(NumAux);
  nZero := (13 - t);

  for i := 1 to 13 do   //Alinha a Direita e preenche com zeros a esquerda
   begin
     if i > nZero  then
      InscEst := InscEst + Copy(NumAux, i - nZero, 1)
     else
      InscEst := InscEst + '0';
   end;

   if Uf = 'MT' then DigitoCalc := CalculaMT(InscEst);
   if Uf = 'GO' then DigitoCalc := CalculaGO(InscEst);
   if Uf = 'MG' then DigitoCalc := CalculaMG(InscEst);
   if Uf = 'AM' then DigitoCalc := CalculaAM(InscEst);
   if Uf = 'MS' then DigitoCalc := CalculaMS(InscEst);
   if Uf = 'RO' then DigitoCalc := CalculaRO(InscEst);
   if Uf = 'RJ' then DigitoCalc := CalculaRJ(InscEst);
   if Uf = 'AC' then DigitoCalc := CalculaAC(InscEst);
   if Uf = 'SP' then DigitoCalc := CalculaSP(InscEst);
   if Uf = 'PR' then DigitoCalc := CalculaPR(InscEst);
   if Uf = 'ES' then DigitoCalc := CalculaES(InscEst);
   if Uf = 'AL' then DigitoCalc := CalculaAL(InscEst);

  Result := False;

  if (uf = 'AC') OR (uf = 'MG') OR (uf = 'SP') OR (uf = 'PR')then
   begin
    if DigitoCalc = Numero then
      Result := True
   end
  else
  if StrToint(DigitoCalc) = StrToint(NumAux) then Result := True;
end;

function CalculaMT(Numero : String) : String;
var
  Fator, i,  Soma, Digito: Integer;
  InscEst : String;
begin
// Formato: NNNNNNNNNN-D
// Mascara: N.NNN.NNN.NNN-D

  Fator  := 3;
  Soma    := 0;
  InscEst := Copy(Numero,3,10);

  for i := 1 to 10 do
   begin
    Soma := Soma + (StrToInt(Copy(InscEst, i, 1)) * Fator);

    if Fator = 2 then  Fator := 10;
    Dec(Fator);
   end;

   Digito := Soma mod 11;

   if Digito in[0,1] then
     Digito := 0
   else
     Digito := 11 - Digito;

  Result := InscEst + IntToStr(Digito);
end;

function CalculaGO(Numero : String) : String;
var
  InscEst : String;
  Fator, i, Soma, Digito: Integer;
begin
// Formato: ABCDEFGH-D
// Mascara: AB.CDE.FGH-I

  Fator  := 9;
  Soma    := 0;
  InscEst := Copy(Numero,5,8);

  for i := 1 to 8 do
   begin
    Soma := Soma + (StrToInt(Copy(InscEst, i, 1)) * Fator);
    dec(Fator);
   end;

  Digito := Soma mod 11;

  if Digito = 1 then
    if  (StrToint(InscEst) >= 10103105) and (StrToint(InscEst) <= 10119997) then
     Digito := 1
    else
     Digito := 0;

  if Digito > 1 then
     Digito := 11 - Digito;

  Result := InscEst + IntToStr(Digito);
end;

function CalculaMG(Numero : String) : String;
var
  vlr     : String;
  InscEst : String;
  Fator, i, Aux, Soma, Soma10, Digito1, Digito2 : Integer;

begin
// Formato: xxxXXXxxx0000
// Mascara: 062.307.904/0081

  Fator  := 1;
  Soma    := 0;
  InscEst := Copy(Numero,1,3) + '0' + Copy(Numero,4,8);

  //AChar o 1o. digito
  for i := 1 to 12 do
   begin
    Aux :=  (StrToInt(Copy(InscEst, i, 1)) * Fator);

    if Aux > 9 then
      Soma := (Soma + (Aux - 10 + 1))
    else
      Soma := (Soma + Aux);

    inc(Fator);
    if Fator > 2 then
      Fator := 1;
   end;

  Vlr    := copy(IntToStr(Soma),1,1) + '0';
  Soma10 := StrToInt(vlr) + 10;
  Digito1 := Soma10 - Soma;

  //AChar o 2o. digito
  Fator  := 3;
  Soma    := 0;
  InscEst := Copy(Numero,1,11) + IntToStr(Digito1);

  for i := 1 to 12 do
   begin
    Soma := Soma + (StrToInt(Copy(InscEst, i, 1)) * Fator);
    if Fator = 2 then Fator := 12;
    Dec(Fator);
   end;

  Digito2 := Soma mod 11;

   if Digito2 in[0,1] then
     Digito2 := 0
   else
     Digito2 := 11 - Digito2;

  Result := Copy(Numero,1,11) + IntToStr(Digito1) + IntToStr(Digito2);
end;

function CalculaAM(Numero : String) : String;
var
  Fator, i,  Soma, Digito: Integer;
  InscEst : String;
begin
// Mascara: 99.999.999-9

  Fator  := 9;
  Soma    := 0;
  InscEst := Copy(Numero,5,8);

  for i := 1 to 8 do
   begin
    Soma := Soma + (StrToInt(Copy(InscEst, i, 1)) * Fator);
    Dec(Fator);
   end;

   If Soma < 11 then
     Digito := 11 - Soma
   else
     Digito := Soma mod 11;

   if Digito in[0,1] then
     Digito := 0
   else
     Digito := 11 - Digito;

  Result := InscEst + IntToStr(Digito);
end;

function CalculaMS(Numero : String) : String;
var
  Fator, i,  Soma, Digito: Integer;
  InscEst : String;
begin

  Fator  := 9;
  Soma    := 0;
  InscEst := Copy(Numero,5,8);

  for i := 1 to 8 do
   begin
    Soma := Soma + (StrToInt(Copy(InscEst, i, 1)) * Fator);
    Dec(Fator);
   end;

   If Soma < 11 then
     Digito := 11 - Soma
   else
     Digito := Soma mod 11;

   if Digito in[0,1] then
     Digito := 0
   else
     Digito := 11 - Digito;

  Result := InscEst + IntToStr(Digito);
end;

function CalculaRO(Numero : String) : String;
var
  Fator, i,  Soma, Digito: Integer;
  InscEst : String;
begin

  Fator  := 6;
  Soma    := 0;
  InscEst := '00000000' + Copy(Numero,8,5);

  for i := 1 to 13 do
   begin
    Soma := Soma + (StrToInt(Copy(InscEst, i, 1)) * Fator);
    if Fator = 2 then Fator := 10;
    Dec(Fator);
   end;

   Digito := Soma mod 11;
   Digito := 11 - Digito;

   if Digito in[10,11] then
     Digito := Digito - 10;

  Result := InscEst + IntToStr(Digito);
end;

function CalculaRJ(Numero : String) : String;
var
  Fator, i,  Soma, Digito: Integer;
  InscEst : String;
begin

  Fator  := 2;
  Soma    := 0;
  InscEst := Copy(Numero,6,7);

  for i := 1 to 7 do
   begin
    Soma := Soma + (StrToInt(Copy(InscEst, i, 1)) * Fator);
    if Fator = 2 then Fator := 8;
    Dec(Fator);
   end;

   Digito := Soma mod 11;

   if Digito < 2 then
     Digito := 0
   else
     Digito := 11 - Digito;

  Result := InscEst + IntToStr(Digito);
end;

function CalculaAC(Numero : String) : String;
var
  Fator, i,  Soma, Digito1, Digito2 : Integer;
  InscEst : String;
begin

  Fator  := 4;
  Soma    := 0;
  InscEst := Copy(Numero,1,11);

  // Acha 1o. Digito
  for i := 1 to 11 do
   begin
    Soma := Soma + (StrToInt(Copy(InscEst, i, 1)) * Fator);
    if Fator = 2 then Fator := 10;
    Dec(Fator);
   end;

   Digito1 := (Soma mod 11);
   Digito1 := (11 - Digito1);

   if Digito1 > 9 then Digito1 := 0;

  // Acha 2o. Digito
  Fator  := 5;
  Soma    := 0;
  InscEst := InscEst + IntToStr(Digito1);

  for i := 1 to 12 do
   begin
    Soma := Soma + (StrToInt(Copy(InscEst, i, 1)) * Fator);
    if Fator = 2 then Fator := 10;
    Dec(Fator);
   end;

  Digito2 := Soma mod 11;
  Digito2 := (11 - Digito2);
  if Digito2 > 9 then Digito2 := 0;

  Result := InscEst + IntToStr(Digito2);
end;

function CalculaSP(Numero : String) : String;
var
  Fator, i,  Soma, Digito1, Digito2 : Integer;
  InscEst : String;
  Aux     : String;
begin
  // Mascara: 110.042.490.114  Os digitos s�o 9 posi��o e a ultima

  Fator  := 1;
  Soma    := 0;
  InscEst := Copy(Numero,2,8);

  // Acha 1o. Digito
  for i := 1 to 8 do
   begin
    Soma := Soma + (StrToInt(Copy(InscEst, i, 1)) * Fator);
    if Fator = 1 then Fator := 2;
    if Fator = 8 then Fator := 9;
    Inc(Fator);
   end;

  Digito1 := (Soma mod 11);

  if Digito1 > 9 then
    begin
     Aux := copy(IntToStr(Digito1),2,1);
     Digito1 := StrToInt(Aux);
    end;

  // Acha 2o. Digito
  Fator  := 3;
  Soma    := 0;
  InscEst := InscEst + IntToStr(Digito1) + Copy(Numero,11,2);

  for i := 1 to 11 do
   begin
    Soma := Soma + (StrToInt(Copy(InscEst, i, 1)) * Fator);
    if Fator = 2 then Fator := 11;
    Dec(Fator);
   end;

  Digito2 := Soma mod 11;
  if Digito2 > 9 then
   begin
    Aux := copy(IntToStr(Digito2),2,1);
    Digito2 := StrToInt(Aux);
   end;

  Result := InscEst + IntToStr(Digito2);
end;

function CalculaPR(Numero : String) : String;
var
  Fator, i,  Soma, Digito1, Digito2 : Integer;
  InscEst : String;
begin
  // Mascara: 123.45678-50

  Fator  := 3;
  Soma    := 0;
  InscEst := Copy(Numero,4,8);

  // Acha 1o. Digito
  for i := 1 to 8 do
   begin
    Soma := Soma + (StrToInt(Copy(InscEst, i, 1)) * Fator);
    if Fator = 2 then Fator := 8;
    Dec(Fator);
   end;

  Digito1 := (Soma mod 11);
  Digito1 := (11 - Digito1);
  if Digito1 > 9 then Digito1 := 0;

  // Acha 2o. Digito
  Fator  := 4;
  Soma    := 0;
  InscEst := InscEst + IntToStr(Digito1);

  for i := 1 to 9 do
   begin
    Soma := Soma + (StrToInt(Copy(InscEst, i, 1)) * Fator);
    if Fator = 2 then Fator := 8;
    Dec(Fator);
   end;

  Digito2 := Soma mod 11;
  Digito2 := (11 - Digito2);
  if Digito2 > 9 then Digito2 := 0;

  Result := InscEst + IntToStr(Digito2);
end;

function CalculaES(Numero : String) : String;
var
  Fator, i,  Soma, Digito: Integer;
  InscEst : String;
begin

  Fator  := 9;
  Soma    := 0;
  InscEst := Copy(Numero,5,8);

  for i := 1 to 8 do
   begin
    Soma := Soma + (StrToInt(Copy(InscEst, i, 1)) * Fator);
    Dec(Fator);
   end;

   Digito := Soma mod 11;

   if Digito < 2 then
     Digito := 0
   else
     Digito := 11 - Digito;

  Result := InscEst + IntToStr(Digito);
end;

function CalculaAL(Numero : String) : String;
var
  Fator, i,  Soma, Digito: Integer;
  InscEst, Aux : String;
  R, X, z: Real;
begin

  Fator  := 9;
  Soma    := 0;
  InscEst := Copy(Numero,5,8);

  for i := 1 to 8 do
   begin
    Soma := Soma + (StrToInt(Copy(InscEst, i, 1)) * Fator);
    Dec(Fator);
   end;

   R := Soma * 10;
   X := R - int(R /11) * 11;
   Z := R - X;

   if Z = 10 then
     Digito := 0
   else
     begin
       Aux := FloatToStr(z);
       Digito := StrToInt(Copy(Aux,1,1));
     end;

  Result := InscEst + IntToStr(Digito);
end;

function ChecaUF(UF : string) : boolean;
const
  Estados = 'SPMGRJRSSCPRESDFMTMSGOTOBASEALPBPEMARNCEPIPAAMAPFNACRRRO';
var
  Posicao : integer;
begin
  Result := true;
  if UF <> '' then
   begin
    Posicao := Pos(UpperCase(UF), Estados);
    if (Posicao = 0) or ((Posicao mod 2) = 0) then
      Result := false;
   end;
end;

{procedure SetaCorLabel(Form: TForm; Cor : String);
//procedure SetarCorLabel(Form: TForm; Cor : TColor);
var
  i : Integer;
begin
  for i := 0 to Form.ComponentCount - 1 do
   if Form.Components[i] is TLabel then
     (Form.Components[i] as TLabel).Font.Color := Cor;
end;
}

procedure LimpaEdit(Form: TForm);
var
  i : Integer;
begin
  for i := 0 to Form.ComponentCount - 1 do
  begin
   if Form.Components[i] is TCustomEdit then
     (Form.Components[i] as TCustomEdit).Clear;
   if Form.Components[i] is TStaticText then
     (Form.Components[i] as TStaticText).Caption := '';
   if Form.Components[i] is TMemo then
     (Form.Components[i] as TMemo).Clear;
   if Form.Components[i] is TCheckBox then
     (Form.Components[i] as TCheckBox).Checked := False;
   if Form.Components[i] is TComboBox then
     (Form.Components[i] as TComboBox).ItemIndex := -1;
   if Form.Components[i] is TComboBox then
     (Form.Components[i] as TComboBox).Text := '';
  end;
end;

procedure DisableEdit(Form: TForm);
var
  i : Integer;
  vCorInc    : TColor;
  vCorAlt    : TColor;
  vCorExc    : TColor;
  vCorCon    : TColor;

begin
  vCorInc := $0075ACAB;
  vCorAlt := $00CEFFFF;
  vCorExc := $0082C0FF;
  vCorCon := clWhite;

  for i := 0 to Form.ComponentCount - 1 do
   begin
    if Form.Components[i] is TEdit then
      (Form.Components[i] as TEdit).ReadOnly := True;

    if Form.Components[i] is TComboBox then
      (Form.Components[i] as TComboBox).Enabled := False;

    if Form.Components[i] is TRadioGroup then
      (Form.Components[i] as TRadioGroup).Enabled := False;

    if Form.Components[i] is TListBox then
      (Form.Components[i] as TListBox).Enabled := False;

    if Form.Components[i] is TMemo then
      (Form.Components[i] as TMemo).Enabled := False;

    if Form.Components[i] is TCheckBox then
      (Form.Components[i] as TCheckBox).Enabled := False;

    if Form.Components[i] is TDateTimePicker then
      (Form.Components[i] as TDateTimePicker).Enabled := False;

    if Form.Components[i] is TEdit then
      (Form.Components[i] as TEdit).Color := vCorCon;

    if Form.Components[i] is TMaskEdit then
      (Form.Components[i] as TMaskEdit).Color := vCorCon;

    if Form.Components[i] is TRadioGroup then
      (Form.Components[i] as TRadioGroup).Color := vCorCon;

    if Form.Components[i] is TComboBox then
      (Form.Components[i] as TComboBox).Color := vCorCon;

    if Form.Components[i] is TListBox then
      (Form.Components[i] as TListBox).Color := vCorCon;

    if Form.Components[i] is TMemo then
      (Form.Components[i] as TMemo).Color := vCorCon;

    if Form.Components[i] is TCheckBox then
      (Form.Components[i] as TCheckBox).Color := vCorCon;

    if Form.Components[i] is TDateTimePicker then
      (Form.Components[i] as TDateTimePicker).Color := vCorCon;
   end;
end;

procedure EnableEdit(Form: TForm; Cor: TColor);
var
  i : Integer;
begin
  for i := 0 to Form.ComponentCount - 1 do
   begin
    if Form.Components[i] is TEdit then
      (Form.Components[i] as TEdit).ReadOnly := false;

    if Form.Components[i] is TComboBox then
      (Form.Components[i] as TComboBox).Enabled := True;

    if Form.Components[i] is TRadioGroup then
      (Form.Components[i] as TRadioGroup).Enabled := True;

    if Form.Components[i] is TListBox then
      (Form.Components[i] as TListBox).Enabled := True;

    if Form.Components[i] is TMemo then
      (Form.Components[i] as TMemo).Enabled := True;

    if Form.Components[i] is TCheckBox then
      (Form.Components[i] as TCheckBox).Enabled := True;

    if Form.Components[i] is TDateTimePicker then
      (Form.Components[i] as TDateTimePicker).Enabled := True;

    if Form.Components[i] is TEdit then
      (Form.Components[i] as TEdit).Color := Cor;

    if Form.Components[i] is TMaskEdit then
      (Form.Components[i] as TMaskEdit).Color := Cor;

    if Form.Components[i] is TRadioGroup then
      (Form.Components[i] as TRadioGroup).Color := Cor;

    if Form.Components[i] is TComboBox then
      (Form.Components[i] as TComboBox).Color := Cor;

    if Form.Components[i] is TListBox then
      (Form.Components[i] as TListBox).Color := Cor;

    if Form.Components[i] is TMemo then
      (Form.Components[i] as TMemo).Color := Cor;

    if Form.Components[i] is TCheckBox then
      (Form.Components[i] as TCheckBox).Color := Cor;

    if Form.Components[i] is TDateTimePicker then
      (Form.Components[i] as TDateTimePicker).Color := Cor;
   end;
end;


procedure QRDestroi;
var
  nIdx: Integer;
begin
  for nIdx := (Screen.FormCount-1) downto 0 do
  with Screen.Forms[nIdx] do
    if ClassName = 'TQRStandardPreview' then
      Close;
end;

function PriDiaDoMes(vData: TDateTime): TDateTime;
var
 dd, mm, aa : Word;
 dt: TDateTime;
begin
 DecodeDate(vData, aa, mm, dd);
 dt := EncodeDate(aa, mm, 1);
 Result := dt;
end;

function UltDiaDoMes(vData: TDateTime): TDateTime;
var
 dd, mm, aa : Word;
 dt: TDateTime;
begin

 DecodeDate(vData, aa, mm, dd);
 Inc(mm);

 if mm = 13 then
 begin
  mm := 1;
  inc(aa);
 end;

 dt := EncodeDate(aa, mm, 1);
 dt := dt - 1;
 DecodeDate(dt, aa, mm, dd);
 Result := dt;
end;

function PegaUsrLogadoWindows : String;
var
  vID      : Array[0..20] of Char;
  nSize    : dWord;
  Achou    : boolean;
begin
  nSize    := 120;
  vID      := '';
  Achou    := GetUserName(vID, nSize);

  Result := '';

  if Achou then
   Result := UpperCase(vID);
end;


Function Crypto(Acao, Variavel : String):String;
var
//Acao -> C = Criptografa
//Acao -> D = DesCriptografa
  iChv_Posicao, iBinario, iPosicao : Integer;
  iCaracter, iTemporario : Integer;
  Chave : String;
begin
   Chave        := 'QuAlQuErCoIsAeStaBoM123TeStAnDo';
   Result       := '';
   iChv_Posicao := 0 ;
   iCaracter    := 0 ;
   if Length(Variavel) = 0 then exit;
   if Acao = UpperCase('C') then
   begin
     iBinario   := 24;
     Result     := Format('%1.2x', [iBinario]);
     for iPosicao := 1 to Length(Variavel) do
     begin
        iCaracter  := (Ord(Variavel[iPosicao]) + iBinario) mod 255;
        if iChv_Posicao < Length(Chave) then
           iChv_Posicao  := iChv_Posicao + 1
        else
           iChv_Posicao  := 1;
        iCaracter := iCaracter xor Ord(Chave[iChv_Posicao]);
        Result    := Result + format('%1.2x', [iCaracter]);
        iBinario  := iCaracter;
     end;
   end;

   if Acao = UpperCase('D') then
   begin
     try
       iBinario   := StrToInt('$'+ copy(Variavel,1,2));
     except
       Result     := '';
       exit;
     end;
     iPosicao      := 3;
     repeat
       try
         iCaracter   := StrToInt('$'+ copy(Variavel, iPosicao, 2));
       except
         Result     := '';
         exit;
       end;
       if iChv_Posicao < Length(Chave) then
         iChv_Posicao := iChv_Posicao + 1
       else
         iChv_Posicao := 1;
       iTemporario := iCaracter xor Ord(Chave[iChv_Posicao]);
       if iTemporario <= iBinario then
         iTemporario := 255 + iTemporario - iBinario
       else
         iTemporario := iTemporario - iBinario;
       Result     := Result + Chr(iTemporario);
       iBinario   := iCaracter;
       Inc(iPosicao, 2);
     until iPosicao >= Length(Variavel);
   end;
end;


function NumSemMasc(vMascara : String) : String;
var
  vi       : integer;
  vVlrAux : String;
begin
  result := '';

  if Length(vMascara) = 0 then exit;

  for vi := 0 to Length(vMascara) do
  begin
   if vMascara[vi] in ['0'..'9'] then
    vVlrAux := vVlrAux + vMascara[vi];
  end;

  result := vVlrAux;
end;

function VlrSemMasc(vMascara : String) : String;
var
  i       : integer;
  vVlrAux : String;
begin
  result := '';

  if Length(vMascara) = 0 then exit;

  for i := 0 to Length(vMascara) do
  begin
   if (vMascara[i] in ['0'..'9']) or
      (vMascara[i] = '-') or
      (vMascara[i] = ',') then
    vVlrAux := vVlrAux +  vMascara[i];
  end;

  result := vVlrAux;
end;

function MostraMascara(vCampo, vConteudo, vUF : String) : String;
//var
//  i     : integer;
//  vMask : String;
begin
  result := '';

  if Length(vConteudo) = 0 then exit;

  if vCampo = 'CEP' then
  begin
  //78128020
   result := Copy(vConteudo,1,2) + '.' + Copy(vConteudo,3,3) + '-' + Copy(vConteudo,6,3);
  end;

  if vCampo = 'CNPJ' then
  begin
   //405.451.991-15
   //05.989.672.0001-72
   Case Length(vConteudo) of
    11 : result := Copy(vConteudo,1,3) + '.' + Copy(vConteudo,4,3) + '.' + Copy(vConteudo,7,3) + '-' + Copy(vConteudo,10,2);
    14 : result := Copy(vConteudo,1,2) + '.' + Copy(vConteudo,3,3) + '.' + Copy(vConteudo,6,3) + '/' + Copy(vConteudo,9,4) + '-' + Copy(vConteudo,13,2);
   else
    result := vConteudo;
   end;
  end;

  if vCampo = 'INSCEST' then
  begin
   // MT 13.106.446-0
   if vUF = 'MT' then
    result := Copy(vConteudo,1,2) + '.' + Copy(vConteudo,3,3) + '.' + Copy(vConteudo,6,3) + '-' + Copy(vConteudo,9,1)
   else
    result := vConteudo;
  end;

  if vCampo = 'FONE' then
  begin
   // 686-8598
   // 3686-8598
   // 65 3686-8598
   Case Length(vConteudo) of
     7 : result := Copy(vConteudo,1,3) + '-' + Copy(vConteudo,4,4);
     8 : result := Copy(vConteudo,1,4) + '-' + Copy(vConteudo,5,4);
    10 : result := Copy(vConteudo,1,2) + ' ' + Copy(vConteudo,3,4) + '-' + Copy(vConteudo,7,4);
   else
    result := vConteudo;
   end;
  end;
end;

function CEPValido(vCEP : string) : boolean;
var
  i          : integer;
  CEPAux     : String;
begin
  Result := true;

 //Tira Maskara
  CEPAux := '';

  for i := 0 to Length(vCEP) do
  begin
   if vCEP[i] in ['0'..'9'] then
    CEPAux := CEPAux +  vCEP[i];
  end;

  if Length(vCEP) <> 8 then
  begin
   Result := false;
   exit;
  end;
end;


function UFValida(vUF : string) : boolean;
const
  Estados = 'SPMGRJRSSCPRESDFMTMSGOTOBASEALPBPEMARNCEPIPAAMAPFNACRRRO';
var
  Posicao : integer;
begin
  Result := true;
  if vUF <> '' then
   begin
    Posicao := Pos(UpperCase(vUF), Estados);
    if (Posicao = 0) or ((Posicao mod 2) = 0) then
     Result := false;
   end;
end;


Function NomeMaquina : String;
// Retorna o nome do computador
var
  lpBuffer : PChar;
  nSize : DWord;
const
  Buff_Size = MAX_COMPUTERNAME_LENGTH + 1;
begin
  try
   nSize := Buff_Size;
   lpBuffer := StrAlloc(Buff_Size);
   GetComputerName(lpBuffer,nSize);
   Result := String(lpBuffer);
   StrDispose(lpBuffer);
  except
   Result := '';
  end;
end;


function SemanaDoMes(DataAnalisada: TDateTime): byte;
var
   DiaCorte: word;
begin

//   WeekOfTheYear()
   DiaCorte := DayOfWeek(StartOfTheMonth(DataAnalisada)) - 1;
   Result := Round(((DayOf(DataAnalisada)+DiaCorte) / 7) + 0.45);
end;

procedure GravaArqIni(fChave,fNomeChave,fDadoChave:String);
var
  vArqIni : TIniFile;
  s       : string;
begin
  s := '';

  vArqIni := TIniFile.Create(vgPathAplicacao + 'ServCol.ini');

  Try
   with vArqIni do
   begin
    s := AchaParametro(fChave,fNomeChave);

    if (Length(s) = 0) or (s <> fDadoChave) then
     WriteString(fChave,fNomeChave,fDadoChave);
   end;
  Finally
   vArqIni.Free;
  end;
end;

function Traco(fCaracer: string; fTamanho: integer): string;
var
  i : integer;
begin
  result := '';

  for i := 1 to fTamanho do
  begin
   Result := Result + fCaracer;
  end
end;

Function GetSemanaParImpar(fDtRef:TDateTime) : String;
var
  nSem         : integer;
  vDtRef       : TDateTime;
  iniAno       : TDateTime;
  proxFinalSem : TDateTime;
  vAno         : Word;
  vDtStr       : string;
begin
  nSem   := 0;
  vDtRef := fDtRef;
  vAno   := YearOf(vDtRef);
  proxFinalSem := vDtRef;

  iniAno := StrToDate('01/01/' + IntToStr(vAno));

  if DayOfWeek(vDtRef) = 7 then //Sabado
   proxFinalSem := vDtRef
  else
  begin
   vDtStr := FormatDateTime('dd/mm/yyyy', (vDtRef + (7 - DayOfWeek(vDtRef))));
   proxFinalSem := StrToDate(vDtStr);
  end;

  while iniAno < proxFinalSem do
  begin
   Inc(nSem);
   iniAno := iniAno + 7;
  end;

  if nSem mod 2 = 0 then
   Result := 'P'
  else
   Result := 'I';

End;

Function RemoveAcento(fStr:String;fDelEspacoBranco:boolean): String;
const
  Apost = '''';
  ComAcento = '+������������������&�������������������;|���\_<>[]{}$?�`^~';
  SemAcento = ' aaaaeeeiioooouuuucEAAAAEEEIIOOOOUUUUCN,/RAO/-()()()      ';
var
  s : String;
  x : Integer;
begin
  s := fStr;

  for x := 1 to Length(s) do
   if Pos(s[x],ComAcento) <> 0 then
    s[x] := SemAcento[Pos(s[x],ComAcento)];

  //Troca a Palavra ReciboPendente por LoteRetornado
  //vPathXML := StringReplace(vPathXML,'ReciboPendente','LoteRetornado',[rfReplaceAll]);

  s := StringReplace(s ,Apost,'',[rfReplaceAll]);

  if fDelEspacoBranco then
   Result := AllTrim(s)
  else
   Result := s;
end;

function AllTrim(fStr:String) : String;
var
  i : integer;
  x : string;
begin
  //Remove espa�os em branco de pal
  x := '';

  For i := 1 to Length(fStr) +1 do
  begin
   if (copy(fStr,i,1) = ' ') and
      (copy(fStr,i+1,1) = ' ') then
    continue;

   x := x + copy(fStr,i,1);
  end;

  Result := x;
end;

// antigo u00_Util


end.


