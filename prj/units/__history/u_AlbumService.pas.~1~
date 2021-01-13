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
    class function GetAlbums(const cField, cWhere, cOrderBy, cRegAtual, cQtdReg: string): TObjectList<TAlbum>;
    class function GetAlbum(const cArt_id: Integer): TAlbum;
    class procedure CreateAlbum(const AAlbum: TAlbum);
    class procedure UpdateAlbum(const cArt_id: Integer; const AAlbum: TAlbum);
    class procedure DeleteAlbum(const cArt_id: Integer);
  end;

implementation

uses u00_Global, u00_FunPro;

{ TAlbumService }

class function TAlbumService.GetAlbums(const cField, cWhere, cOrderBy, cRegAtual, cQtdReg: string): TObjectList<TAlbum>;
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
      vOrderBy := ' ORDER BY ART_ID '
    else
      vOrderBy := ' ORDER BY ART_NOME ' + cOrderBy;

    FDConexao.ConnectionDefName := NOME_CONEXAO_BD;
    FDConexao.ExecSQL('SELECT * FROM Album ' + vWhereLike + vOrderBy, TmpDataset);

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

class function TAlbumService.GetAlbum(const cArt_id: Integer): TAlbum;
var
  FDConexao: TFDConnection;
  TmpDataset: TDataSet;
begin
  Result := TAlbum.Create;

  FDConexao := TFDConnection.Create(nil);
  try
    FDConexao.ConnectionDefName := NOME_CONEXAO_BD;

    FDConexao.ExecSQL(
      'SELECT * FROM Album WHERE ART_ID = ' + cArt_id.ToString,
      TmpDataset
    );

    if not TmpDataset.IsEmpty then
    begin
      Result.art_id        := TmpDataset.FieldByName('ART_ID').AsInteger;
      Result.art_nome      := TmpDataset.FieldByName('ART_NOME').AsString;
      Result.art_categoria := TmpDataset.FieldByName('ART_CATEGORIA').AsString;
    end
    else
      raise EDatabaseError.CreateFmt('Album "%d" não encontrado na base de dados!', [cArt_id]);
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
    'INSERT INTO Album (           ' + sLineBreak +
    '  ART_NOME, ART_CATEGORIA       ' + sLineBreak +
    ') VALUES (                      ' + sLineBreak +
    '  :ART_NOME, :ART_CATEGORIA     ' + sLineBreak +
    ')';
begin
  if AAlbum.art_nome.Trim.IsEmpty then
    raise EDatabaseError.Create('Nome do Album é obrigatório');
  if AAlbum.art_categoria.Trim.IsEmpty then
    raise EDatabaseError.Create('Categoria do Album é obrigatório');

  FDConexao := TFDConnection.Create(nil);
  try
    FDConexao.ConnectionDefName := NOME_CONEXAO_BD;
    FDConexao.ExecSQL(SQL_INSERT,
      [
        AAlbum.art_nome,
        AAlbum.art_categoria
      ],
      [
        ftString,
        ftString
      ]
    );
  finally
    FDConexao.Free;
  end;
end;

class procedure TAlbumService.UpdateAlbum(const cArt_id: Integer; const AAlbum: TAlbum);
var
  FDConexao: TFDConnection;
  CountAtu: Integer;

const
  SQL_UPDATE: string =
    'UPDATE Album SET                ' + sLineBreak +
    '  ART_NOME = :ART_NOME,           ' + sLineBreak +
    '  ART_CATEGORIA = :ART_CATEGORIA  ' + sLineBreak +
    'WHERE ART_ID = :ART_ID            ';
begin
  if AAlbum.art_nome.Trim.IsEmpty then
    raise EDatabaseError.Create('Nome do Album é obrigatório');
  if AAlbum.art_categoria.Trim.IsEmpty then
    raise EDatabaseError.Create('Categoria do Album é obrigatório');

  FDConexao := TFDConnection.Create(nil);
  try
    FDConexao.ConnectionDefName := NOME_CONEXAO_BD;
    CountAtu := FDConexao.ExecSQL(SQL_UPDATE,
      [
        AAlbum.art_nome,
        AAlbum.art_categoria,
        cArt_id
      ],
      [
        ftString,
        ftString,
        ftInteger
      ]
    );

    if CountAtu <= 0 then
      raise Exception.Create('Nenhum Album foi atualizado');
  finally
    FDConexao.Free;
  end;
end;

class procedure TAlbumService.DeleteAlbum(const cArt_id: Integer);
var
  FDConexao: TFDConnection;
  CountDelete: Integer;
begin
  FDConexao := TFDConnection.Create(nil);
  try
    FDConexao.ConnectionDefName := NOME_CONEXAO_BD;

    CountDelete := FDConexao.ExecSQL(
      'DELETE FROM Album WHERE ART_ID = :ART_ID',
      [cArt_id],
      [ftInteger]
    );

    if CountDelete = 0 then
      raise EDatabaseError.Create('Nenhum Album foi excluido!');
  finally
    FDConexao.Free;
  end;
end;




end.

