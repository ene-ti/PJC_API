unit u_CapaService;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Generics.Collections,
  u00_conexao,
  u_CapaClass,

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
    class function GetCapa(const cAlb_id: Integer): TCapa;
    class procedure CreateAlbum(const AAlbum: TCapa);
    class procedure UpdateAlbum(const cAlb_id: Integer; const AAlbum: TCapa);
    class procedure DeleteAlbum(const cAlb_id: Integer);
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
      vOrderBy := ' ORDER BY ART_ID, ALB_ID '
    else
      vOrderBy := ' ORDER BY ART_NOME, ALB_NOME ' + cOrderBy;

    FDConexao.ConnectionDefName := NOME_CONEXAO_BD;
    FDConexao.ExecSQL('SELECT * FROM ARTISTA ART ' +
                      ' LEFT OUTER JOIN ALBUM ALB ON ART.ART_ID = ALB.ID_ART ' +
                      ' LEFT OUTER JOIN CAPA CAP ON CAP.ID_ALB = ALB.ALB_ID ' +
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
        ACapa.art_id   := TmpDataset.FieldByName('ART_ID').AsInteger;
        ACapa.art_nome := TmpDataset.FieldByName('ART_NOME').AsString;
        ACapa.art_categoria := TmpDataset.FieldByName('ART_CATEGORIA').AsString;
        ACapa.alb_id   := TmpDataset.FieldByName('ALB_ID').AsInteger;
        ACapa.alb_nome := TmpDataset.FieldByName('ALB_NOME').AsString;
        ACapa.id_art   := TmpDataset.FieldByName('ID_ART').AsInteger;
        ACapa.cp_id   := TmpDataset.FieldByName('CP_ID').AsInteger;
        ACapa.id_alb   := TmpDataset.FieldByName('ID_ALB').AsInteger;
        ACapa.cp_url := TmpDataset.FieldByName('CP_URL').AsString;

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

class function TCapaService.GetCapa(const cAlb_id: Integer): TCapa;
var
  FDConexao: TFDConnection;
  TmpDataset: TDataSet;
begin
  Result := TCapa.Create;

  FDConexao := TFDConnection.Create(nil);
  try
    FDConexao.ConnectionDefName := NOME_CONEXAO_BD;

    FDConexao.ExecSQL('SELECT * FROM ARTISTA ART ' +
                      ' LEFT OUTER JOIN ALBUM ALB ON ART.ART_ID = ALB.ID_ART ' +
                      ' LEFT OUTER JOIN CAPA CAP ON CAP.ID_ALB = ALB.ALB_ID ' +
                      '  WHERE ALB_ID = ' + cAlb_id.ToString, TmpDataset    );

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
        Result.cp_url := TmpDataset.FieldByName('CP_URL').AsString;
    end
    else
      raise EDatabaseError.CreateFmt('Album "%d" n�o encontrado na base de dados!', [cAlb_id]);
  finally
    TmpDataset.Free;
    FDConexao.Free;
  end;
end;

class procedure TCapaService.CreateAlbum(const AAlbum: TCapa);
var
  FDConexao: TFDConnection;
const
  SQL_INSERT: string =
    'INSERT INTO CAPA (      ' + sLineBreak +
    '  ID_ALB, CP_URL       ' + sLineBreak +
    ') VALUES (               ' + sLineBreak +
    '  :ID_ALB, :CP_URL     ' + sLineBreak +
    ')';
begin
  if ACapa.cp_url.Trim.IsEmpty then
    raise EDatabaseError.Create('Nome da Capa � obrigat�rio');
  if ACapa.id_art = 0 then
    raise EDatabaseError.Create('ID do Capa do Album � obrigat�rio');

  FDConexao := TFDConnection.Create(nil);
  try
    FDConexao.ConnectionDefName := NOME_CONEXAO_BD;
    FDConexao.ExecSQL(SQL_INSERT,
      [
        ACapa.id_alb,
        ACapa.cp_url
      ],
      [
        ftString,
        ftInteger
      ]
    );
  finally
    FDConexao.Free;
  end;
end;

class procedure TCapaService.UpdateCapa(const cAlb_id: Integer; const AAlbum: TCapa);
var
  FDConexao: TFDConnection;
  CountAtu: Integer;

const
  SQL_UPDATE: string =
    'UPDATE CAPA SET                ' + sLineBreak +
    '  ID_ALB = :ID_ALB,           ' + sLineBreak +
    '  CP_URL = :CP_URL  ' + sLineBreak +
    'WHERE ID_ = :ALB_ID            ';
begin
  if AAlbum.alb_nome.Trim.IsEmpty then
    raise EDatabaseError.Create('Nome do Album � obrigat�rio');
  if AAlbum.id_art = 0 then
    raise EDatabaseError.Create('ID do Artista do Album � obrigat�rio');

  FDConexao := TFDConnection.Create(nil);
  try
    FDConexao.ConnectionDefName := NOME_CONEXAO_BD;
    CountAtu := FDConexao.ExecSQL(SQL_UPDATE,
      [
        ACAPA.ID_ALB,
        ACAPA.CP_URL,
        cALB_id
      ],
      [
        ftInteger,
        ftInteger,
        ftString
      ]
    );

    if CountAtu <= 0 then
      raise Exception.Create('Nenhuma Capa foi atualizado');
  finally
    FDConexao.Free;
  end;
end;

class procedure TCapaService.DeleteAlbum(const cAlb_id: Integer);
var
  FDConexao: TFDConnection;
  CountDelete: Integer;
begin
  FDConexao := TFDConnection.Create(nil);
  try
    FDConexao.ConnectionDefName := NOME_CONEXAO_BD;

    CountDelete := FDConexao.ExecSQL(
      'DELETE FROM ALBUM WHERE ALB_ID = :ALB_ID',
      [cAlb_id],
      [ftInteger]
    );

    if CountDelete = 0 then
      raise EDatabaseError.Create('Nenhum Album foi excluido!');
  finally
    FDConexao.Free;
  end;
end;




end.

