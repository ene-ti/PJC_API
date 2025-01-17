unit u_AlbumService;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Generics.Collections,
  u00_conexao,
  u_AlbumClass,

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
  TalbumService = class
  private

  public
    class function GetAlbuns(const cField, cWhere, cOrderBy, cRegAtual, cQtdReg: string): TObjectList<TAlbum>;
    class function GetAlbum(const cAlb_id: Integer): TAlbum;
    class procedure CreateAlbum(const AAlbum: TAlbum);
    class procedure UpdateAlbum(const cAlb_id: Integer; const AAlbum: TAlbum);
    class procedure DeleteAlbum(const cAlb_id: Integer);
  end;

implementation

uses u00_Global, u00_FunPro;

{ TAlbumService }

class function TAlbumService.GetAlbuns(const cField, cWhere, cOrderBy, cRegAtual, cQtdReg: string): TObjectList<TAlbum>;
var
  FDConexao: TFDConnection;
  TmpDataset: TDataSet;
  AAlbum: TAlbum;
  vWhereLike, vOrderBy: string;
  vRegAtual, vQtdReg, vIni, vCont: integer;
begin
  Result := TObjectList<TAlbum>.Create;

  FDConexao := TFDConnection.Create(nil);
  try
    vRegAtual := StrToIntDef(cRegAtual,0);
    vQtdReg := StrToIntDef(cQtdReg,0);

    if cWhere.Trim.IsEmpty then
      vWhereLike := ' '
    else
      vWhereLike := ' WHERE ' + cField + ' LIKE ''%' + cWhere + '%'' ';

    if cOrderBy.Trim.IsEmpty then
      vOrderBy := ' ORDER BY ALB_ID '
    else
      vOrderBy := ' ORDER BY ART_NOME ' + cOrderBy +', ALB_NOME ' + cOrderBy;

    FDConexao.ConnectionDefName := NOME_CONEXAO_BD;
    FDConexao.ExecSQL('SELECT * FROM ALBUM ALB ' +
                      ' LEFT OUTER JOIN ARTISTA ART ON ALB.ID_ART = ART.ART_ID ' +
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

        AAlbum := TAlbum.Create;
        AAlbum.alb_id   := TmpDataset.FieldByName('ALB_ID').AsInteger;
        AAlbum.alb_nome := TmpDataset.FieldByName('ALB_NOME').AsString;
        AAlbum.id_art   := TmpDataset.FieldByName('ID_ART').AsInteger;
        AAlbum.art_id   := TmpDataset.FieldByName('ART_ID').AsInteger;
        AAlbum.art_nome := TmpDataset.FieldByName('ART_NOME').AsString;
        AAlbum.art_categoria := TmpDataset.FieldByName('ART_CATEGORIA').AsString;

        Result.Add(AAlbum);
        TmpDataset.Next;
        if (vQtdReg > 0) and (vCont >= vQtdReg) then
        begin
          break;
        end;
      end;
    end
    else
      raise EDatabaseError.Create('Nenhum Album cadastrado na base de dados!');
  finally
    TmpDataset.Free;
    FDConexao.Free;
  end;
end;

class function TAlbumService.GetAlbum(const cAlb_id: Integer): TAlbum;
var
  FDConexao: TFDConnection;
  TmpDataset: TDataSet;
begin
  Result := TAlbum.Create;

  FDConexao := TFDConnection.Create(nil);
  try
    FDConexao.ConnectionDefName := NOME_CONEXAO_BD;

    FDConexao.ExecSQL('SELECT * FROM ALBUM ALB ' +
                      ' LEFT OUTER JOIN ARTISTA ART ON ALB.ID_ART = ART.ART_ID ' +
                      '  WHERE ALB_ID = ' + cAlb_id.ToString, TmpDataset    );

    if not TmpDataset.IsEmpty then
    begin
        Result.alb_id   := TmpDataset.FieldByName('ALB_ID').AsInteger;
        Result.alb_nome := TmpDataset.FieldByName('ALB_NOME').AsString;
        Result.id_art   := TmpDataset.FieldByName('ID_ART').AsInteger;
        Result.art_id   := TmpDataset.FieldByName('ART_ID').AsInteger;
        Result.art_nome := TmpDataset.FieldByName('ART_NOME').AsString;
        Result.art_categoria := TmpDataset.FieldByName('ART_CATEGORIA').AsString;
    end
    else
      raise EDatabaseError.CreateFmt('Album "%d" n�o encontrado na base de dados!', [cAlb_id]);
  finally
    TmpDataset.Free;
    FDConexao.Free;
  end;
end;

class procedure TAlbumService.CreateAlbum(const AAlbum: TAlbum);
var
  FDConexao: TFDConnection;
const
  SQL_INSERT: string =
    'INSERT INTO ALBUM (      ' + sLineBreak +
    '  ALB_NOME, ID_ART       ' + sLineBreak +
    ') VALUES (               ' + sLineBreak +
    '  :ALB_NOME, :ID_ART     ' + sLineBreak +
    ')';
begin
  if AAlbum.alb_nome.Trim.IsEmpty then
    raise EDatabaseError.Create('Nome do Album � obrigat�rio');
  if AAlbum.id_art = 0 then
    raise EDatabaseError.Create('ID do Artista do Album � obrigat�rio');

  FDConexao := TFDConnection.Create(nil);
  try
    FDConexao.ConnectionDefName := NOME_CONEXAO_BD;
    FDConexao.ExecSQL(SQL_INSERT,
      [
        AAlbum.alb_nome,
        AAlbum.id_art
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

class procedure TAlbumService.UpdateAlbum(const cAlb_id: Integer; const AAlbum: TAlbum);
var
  FDConexao: TFDConnection;
  CountAtu: Integer;

const
  SQL_UPDATE: string =
    'UPDATE ALBUM SET                ' + sLineBreak +
    '  ALB_NOME = :ALB_NOME,           ' + sLineBreak +
    '  ID_ART = :ID_ART  ' + sLineBreak +
    'WHERE ALB_ID = :ALB_ID            ';
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
        AAlbum.alb_nome,
        AAlbum.id_art,
        cAlb_id
      ],
      [
        ftString,
        ftInteger,
        ftInteger
      ]
    );

    if CountAtu <= 0 then
      raise Exception.Create('Nenhum Album foi atualizado');
  finally
    FDConexao.Free;
  end;
end;

class procedure TAlbumService.DeleteAlbum(const cAlb_id: Integer);
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

