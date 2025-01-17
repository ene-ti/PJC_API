unit u_CapaService;

interface

uses
  System.Classes,  Vcl.Forms, Vcl.Dialogs, Vcl.imaging.jpeg,
  System.SysUtils,
  System.Generics.Collections,
  u00_conexao,
  u_CapaClass,
  Data.Cloud.CloudAPI, Data.Cloud.AmazonAPI,

  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Stan.Def,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.DApt,
  FireDAC.Phys,
  FireDAC.VCLUI.Wait,
  FireDAC.Comp.Client,
  FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef,                //MySql
  FireDAC.Phys.FBDef, FireDAC.Phys.IBBase, FireDAC.Phys.FB, //Firebirdb
  Data.DB;

type
  TCapaService = class
  private

  public
    class function GetCapas(const cField, cWhere, cOrderBy, cRegAtual, cQtdReg: string): TObjectList<TCapa>;
    class function GetCapa(const cCp_id: Integer): TCapa;
    class procedure CreateCapa(const ACapa: TCapa);
    class procedure UpdateCapa(const cCp_id: Integer; const ACapa: TCapa);
    class procedure DeleteCapa(const cCp_id: Integer);
  end;

implementation

uses u00_Global, u00_FunPro;

{ TCapaService }

class function TCapaService.GetCapas(const cField, cWhere, cOrderBy, cRegAtual, cQtdReg: string): TObjectList<TCapa>;
var
  FDConexao: TFDConnection;
  TmpDataset: TDataSet;
  ACapa: TCapa;
  vWhereLike, vOrderBy: string;
  vRegAtual, vQtdReg, vIni, vCont: integer;
begin
  Result := TObjectList<TCapa>.Create;

  FDConexao := TFDConnection.Create(nil);
  try
    vRegAtual := StrToIntDef(cRegAtual,0);
    vQtdReg := StrToIntDef(cQtdReg,0);

    if cWhere.Trim.IsEmpty then
      vWhereLike := ' '
    else
      vWhereLike := ' WHERE ' + cField + ' LIKE ''%' + cWhere + '%'' ';

    if cOrderBy.Trim.IsEmpty then
      vOrderBy := ' ORDER BY ART_ID, ALB_ID, CP_ID '
    else
      vOrderBy := ' ORDER BY ART_NOME ' + cOrderBy +', ALB_NOME ' + cOrderBy;

    FDConexao.ConnectionDefName := NOME_CONEXAO_BD;
    FDConexao.ExecSQL('SELECT * FROM CAPA CAP ' +
                      ' LEFT OUTER JOIN ALBUM ALB ON ALB.ALB_ID = CAP.ID_ALB ' +
                      ' LEFT OUTER JOIN ARTISTA ART ON ART.ART_ID = ALB.ID_ART ' +
                      vWhereLike + vOrderBy, TmpDataset);

    if not TmpDataset.IsEmpty then
    begin
      TmpDataset.First;
      vIni := 0;
      vCont := 0;
      while not TmpDataset.Eof do
      begin
        vIni := vIni+1;
        if (vRegAtual > 0) and (vIni <= vRegAtual) then
        begin
          TmpDataset.Next;
          Continue;
        end;
        vCont := vCont+1;

        ACapa := TCapa.Create;
        ACapa.cp_id   := TmpDataset.FieldByName('CP_ID').AsInteger;
        ACapa.id_alb   := TmpDataset.FieldByName('ID_ALB').AsInteger;
        ACapa.cp_nome := TmpDataset.FieldByName('CP_NOME').AsString;
        ACapa.cp_url := TmpDataset.FieldByName('CP_URL').AsString;
        ACapa.art_id   := TmpDataset.FieldByName('ART_ID').AsInteger;
        ACapa.art_nome := TmpDataset.FieldByName('ART_NOME').AsString;
        ACapa.art_categoria := TmpDataset.FieldByName('ART_CATEGORIA').AsString;
        ACapa.alb_id   := TmpDataset.FieldByName('ALB_ID').AsInteger;
        ACapa.alb_nome := TmpDataset.FieldByName('ALB_NOME').AsString;
        ACapa.id_art   := TmpDataset.FieldByName('ID_ART').AsInteger;

        Result.Add(ACapa);
        TmpDataset.Next;
        if (vQtdReg > 0) and (vCont >= vQtdReg) then
        begin
          break;
        end;
      end;
    end
    else
      raise EDatabaseError.Create('Nenhuma Capa/Album cadastrado na base de dados!');
  finally
    TmpDataset.Free;
    FDConexao.Free;
  end;
end;

{class function TCapaService.GetCapa(const cCp_id: Integer): TJPEGImage;
var
  vStream : TStream;
  vFile, vBucket : String;
  vImage : TJPEGImage;
  amzConnInf : TAmazonConnectionInfo;
  amzStorServ : TAmazonStorageService;
  amzRegion : TAmazonRegion;
  amzRespInfo : TCloudResponseInfo;
  amzBuckRes : TAmazonBucketResult;
  amzObjeRes : TAmazonObjectResult;

begin
  amzConnInf := TAmazonConnectionInfo.Create(nil);
  amzConnInf.UseDefaultEndpoints := False;
  amzConnInf.AccountName     := 'Q3AM3UQ867SPQQA43P2F';
  amzConnInf.AccountKey      := 'zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG';
  amzConnInf.Protocol        := 'https';
  amzConnInf.QueueEndpoint   := 'play.min.io'; //'play.min.io';  'queue.amazonaws.com';
  amzConnInf.StorageEndpoint := 'play.min.io'; //'play.min.io';  's3.amazonaws.com';
  amzConnInf.TableEndpoint   := 'play.min.io'; //'play.min.io';  'sdb.amazonaws.com';
  amzConnInf.Region          :=  amzrSAEast1;
  amzRegion                  :=  amzrSAEast1;

  amzStorServ := TAmazonStorageService.Create(amzConnInf);
  amzRespInfo := TCloudResponseInfo.Create;

  //showmessage(amzConnInf.StorageEndpoint);
  //showmessage(TAmazonStorageService.GetRegionString(amzRegion));
  vStream := TMemoryStream.Create;

  vBucket := 'pjc-artistaxalbum';
  vFile   := 'Serj Tankian - Harakiri.jpg';
    //Download do arquivo para a vari�vei vStream
  amzStorServ.GetObject(vBucket, vFile, vStream, amzRespInfo, amzRegion);
  vImage := TJPEGImage.Create;
  vImage.LoadFromStream(vStream);
  Result := vImage;
  TMemoryStream(vStream).SaveToFile('c:\banco\'+vFile);
end;}

class function TCapaService.GetCapa(const cCp_id: Integer): TCapa;
var
  FDConexao: TFDConnection;
  TmpDataset: TDataSet;
begin
  Result := TCapa.Create;

  FDConexao := TFDConnection.Create(nil);
  try
    FDConexao.ConnectionDefName := NOME_CONEXAO_BD;

    FDConexao.ExecSQL('SELECT * FROM CAPA CAP ' +
                      ' LEFT OUTER JOIN ALBUM ALB ON ALB.ALB_ID = CAP.ID_ALB ' +
                      ' LEFT OUTER JOIN ARTISTA ART ON ART.ART_ID = ALB.ID_ART ' +
                      '  WHERE CP_ID = ' + cCp_id.ToString, TmpDataset    );

    if not TmpDataset.IsEmpty then
    begin
        Result.art_id   := TmpDataset.FieldByName('ART_ID').AsInteger;
        Result.art_nome := TmpDataset.FieldByName('ART_NOME').AsString;
        Result.art_categoria := TmpDataset.FieldByName('ART_CATEGORIA').AsString;
        Result.alb_id   := TmpDataset.FieldByName('ALB_ID').AsInteger;
        Result.alb_nome := TmpDataset.FieldByName('ALB_NOME').AsString;
        Result.id_art   := TmpDataset.FieldByName('ID_ART').AsInteger;
        Result.cp_id   := TmpDataset.FieldByName('CP_ID').AsInteger;
        Result.id_alb   := TmpDataset.FieldByName('ID_ALB').AsInteger;
        Result.cp_nome := TmpDataset.FieldByName('CP_NOME').AsString;
        Result.cp_url := TmpDataset.FieldByName('CP_URL').AsString;
    end
    else
      raise EDatabaseError.CreateFmt('Capa "%d" n�o encontrada na base de dados!', [cCp_id]);
  finally
    TmpDataset.Free;
    FDConexao.Free;
  end;
end;

class procedure TCapaService.CreateCapa(const ACapa: TCapa);
var
  FDConexao: TFDConnection;
const
  SQL_INSERT: string =
    'INSERT INTO CAPA (      ' + sLineBreak +
    '  ID_ALB, CP_NOME, CP_URL       ' + sLineBreak +
    ') VALUES (               ' + sLineBreak +
    '  :ID_ALB, :CP_NOME, :CP_URL     ' + sLineBreak +
    ')';
begin
  if ACapa.cp_nome.Trim.IsEmpty then
    raise EDatabaseError.Create('Nome da Capa � obrigat�rio');
  if ACapa.id_alb = 0 then
    raise EDatabaseError.Create('ID do album � obrigat�rio');

  FDConexao := TFDConnection.Create(nil);
  try
    FDConexao.ConnectionDefName := NOME_CONEXAO_BD;
    FDConexao.ExecSQL(SQL_INSERT,
      [
        ACapa.id_alb,
        ACapa.cp_nome,
        ACapa.cp_url
      ],
      [
        ftInteger,
        ftString,
        ftString
      ]
    );
  finally
    FDConexao.Free;
  end;
end;

class procedure TCapaService.UpdateCapa(const cCp_id: Integer; const ACapa: TCapa);
var
  FDConexao: TFDConnection;
  CountAtu: Integer;

const
  SQL_UPDATE: string =
    'UPDATE CAPA SET                ' + sLineBreak +
    '  ID_ALB = :ID_ALB,           ' + sLineBreak +
    '  CP_NOME = :CP_NOME,  ' + sLineBreak +
    '  CP_URL = :CP_URL  ' + sLineBreak +
    'WHERE CP_ID = :CP_ID            ';
begin
  if ACapa.cp_nome.Trim.IsEmpty then
    raise EDatabaseError.Create('Nome da Capa � obrigat�rio');
  if ACapa.id_alb = 0 then
    raise EDatabaseError.Create('ID da Capa � obrigat�rio');

  FDConexao := TFDConnection.Create(nil);
  try
    FDConexao.ConnectionDefName := NOME_CONEXAO_BD;
    CountAtu := FDConexao.ExecSQL(SQL_UPDATE,
      [
        ACapa.ID_ALB,
        ACapa.CP_NOME,
        ACapa.CP_URL,
        cCp_id
      ],
      [
        ftInteger,
        ftString,
        ftString,
        ftInteger
      ]
    );

    if CountAtu <= 0 then
      raise Exception.Create('Nenhuma Capa foi atualizada');
  finally
    FDConexao.Free;
  end;
end;

class procedure TCapaService.DeleteCapa(const cCp_id: Integer);
var
  FDConexao: TFDConnection;
  CountDelete: Integer;
begin
  FDConexao := TFDConnection.Create(nil);
  try
    FDConexao.ConnectionDefName := NOME_CONEXAO_BD;

    CountDelete := FDConexao.ExecSQL(
      'DELETE FROM CAPA WHERE CP_ID = :CP_ID',
      [cCp_id],
      [ftInteger]
    );

    if CountDelete = 0 then
      raise EDatabaseError.Create('Nenhuma Capa foi excluida!');
  finally
    FDConexao.Free;
  end;
end;




end.

