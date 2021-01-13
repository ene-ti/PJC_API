unit u_ApiController;

interface

uses
  dialogs,
  System.SysUtils,
  System.StrUtils,
  MVCFramework,
  MVCFramework.Commons,
  MVCFramework.Serializer.Commons;

type
  [MVCPath('/api')]
  TApiController = class(TMVCController)
  protected
    procedure OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean); override;
    procedure OnAfterAction(Context: TWebContext; const AActionName: string); override;

  public
    [MVCPath('/')]
    [MVCPath('')]
    [MVCHTTPMethod([httpGET])]
    procedure GetMyRootPage;

    // - Path ARTISTAS
    [MVCPath('/artistas')]
    [MVCHTTPMethod([httpGET])]
    procedure GetArtistas;

    [MVCPath('/artistascategoria')]
    [MVCHTTPMethod([httpGET])]
    procedure GetArtistasCategoria;

    [MVCPath('/artista/($art_id)')]
    [MVCHTTPMethod([httpGET])]
    procedure GetArtista(art_id: Integer);

    [MVCPath('/artista')]
    [MVCHTTPMethod([httpPOST])]
    procedure CreateArtista;

    [MVCPath('/artista/($art_id)')]
    [MVCHTTPMethod([httpPUT])]
    procedure UpdateArtista(art_id: Integer);

    [MVCPath('/artista/($art_id)')]
    [MVCHTTPMethod([httpDELETE])]
    procedure DeleteArtista(art_id: Integer);
    // - Path ARTISTAS

    // - Path ALBUNS
    [MVCPath('/albuns')]
    [MVCHTTPMethod([httpGET])]
    procedure GetAlbuns;

    [MVCPath('/albumcategoria')]
    [MVCHTTPMethod([httpGET])]
    procedure GetAlbunsCategoria;

    [MVCPath('/albumartista')]
    [MVCHTTPMethod([httpGET])]
    procedure GetAlbunsArtista;

    [MVCPath('/album/($alb_id)')]
    [MVCHTTPMethod([httpGET])]
    procedure GetAlbum(alb_id: Integer);

    [MVCPath('/album')]
    [MVCHTTPMethod([httpPOST])]
    procedure CreateAlbum;

    [MVCPath('/album/($alb_id)')]
    [MVCHTTPMethod([httpPUT])]
    procedure UpdateAlbum(alb_id: Integer);

    [MVCPath('/album/($alb_id)')]
    [MVCHTTPMethod([httpDELETE])]
    procedure DeleteAlbum(alb_id: Integer);
    // - Path ALBUNS

  end;

implementation

uses
  u_ArtistaService,
  u_ArtistaClass,
  u_AlbumService,
  u_AlbumClass,
  u00_Global;

procedure TApiController.GetMyRootPage;
begin
  ContentType := TMVCMediaType.TEXT_HTML;
  Render(
    '<h1>'+ C_nome_aplicacao+ ' - '+C_versao_aplicacao+ ' - '+C_data_compilacao+'</h1>' + sLineBreak +
    '<p>'+C_desc_aplicacao+'</p>' + sLineBreak +
    '</br>' + sLineBreak +

    '<dl>' + sLineBreak +
//    '<dt>Servidor: </dt><dd>' + ConfiguracaoApp.Servidor       + '</dd>' + sLineBreak +
//    '<dt>Porta: </dt><dd>'    + ConfiguracaoApp.Porta.ToString + '</dd>' + sLineBreak +
//    '<dt>Caminho: </dt><dd>'  + ConfiguracaoApp.Caminho        + '</dd>' + sLineBreak +
    '</dl>'
  );
end;

procedure TApiController.OnAfterAction(Context: TWebContext; const AActionName: string);
begin
  { Executed after each action }
  inherited;
end;

procedure TApiController.OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean);
begin
  { Executed before each action
    if handled is true (or an exception is raised) the actual
    action will not be called }
  inherited;
end;


procedure TApiController.GetArtistas;
var
  StrWhereLike, StrOrderBy, StrRegAtual, StrQtdReg: String;
begin
  // metodo GET: /artistas / QUERY PARAMS (por ART_NOME)
  StrWhereLike := Context.Request.QueryStringParam('wherelike'); // like na clausula where
  StrOrderBy   := Context.Request.QueryStringParam('orderby');   // ordenação ASC/DSC
  StrRegAtual  := Context.Request.QueryStringParam('regatual');  // Nr Reg Atual
  StrQtdReg    := Context.Request.QueryStringParam('qtdereg');   // Qtde Reg Paginação

  Render<TArtista>(TArtistaService.GetArtistas('ART_NOME', StrWhereLike, StrOrderBy, StrRegAtual, StrQtdReg));
end;

procedure TApiController.GetArtistasCategoria;
var
  StrWhereLike, StrOrderBy, StrRegAtual, StrQtdReg: String;
begin
  // metodo GET: /artistas / QUERY PARAMS (por ART_CATEGORIA)
  StrWhereLike := Context.Request.QueryStringParam('wherelike'); // like na clausula where
  StrOrderBy   := Context.Request.QueryStringParam('orderby');   // ordenação ASC/DSC
  StrRegAtual  := Context.Request.QueryStringParam('regatual');  // Nr Reg Atual
  StrQtdReg    := Context.Request.QueryStringParam('qtdereg');   // Qtde Reg Paginação

  Render<TArtista>(TArtistaService.GetArtistas('ART_CATEGORIA', StrWhereLike, StrOrderBy, StrRegAtual, StrQtdReg));
end;

procedure TApiController.GetArtista(art_id: Integer);
begin
  // metodo GET: /artista/($art_id)
  Render(TArtistaService.GetArtista(art_id));
end;

procedure TApiController.CreateArtista;
var
  AArtista: TArtista;
begin
  // metodo POST: /artista
  AArtista := Context.Request.BodyAs<TArtista>;
  try
    TArtistaService.CreateArtista(AArtista);
    Render(200, 'Artista criado com sucesso');
  finally
    AArtista.Free;
  end;
end;

procedure TApiController.UpdateArtista(art_id: Integer);
var
  AArtista: TArtista;
begin
  // metodo PUT: /artista/($art_id)
  AArtista := Context.Request.BodyAs<TArtista>;
  try
    TArtistaService.UpdateArtista(art_id, AArtista);
    Render(200, Format('Artista %d atualizado com sucesso', [art_id]));
  finally
    AArtista.Free;
  end;
end;

procedure TApiController.DeleteArtista(art_id: Integer);
begin
  // metodo DELETE: /artista/($art_id)
  TArtistaService.DeleteArtista(art_id);
  Render(200, Format('Artista %d apagado com sucesso', [art_id]));
end;

procedure TApiController.GetAlbuns;
var
  StrWhereLike, StrOrderBy, StrRegAtual, StrQtdReg: String;
begin
  // metodo GET: /albuns / QUERY PARAMS (por ALB_NOME)
  StrWhereLike := Context.Request.QueryStringParam('wherelike'); // like na clausula where
  StrOrderBy   := Context.Request.QueryStringParam('orderby');   // ordenação ASC/DSC
  StrRegAtual  := Context.Request.QueryStringParam('regatual');  // Nr Reg Atual
  StrQtdReg    := Context.Request.QueryStringParam('qtdereg');   // Qtde Reg Paginação

  Render<TAlbum>(TAlbumService.GetAlbuns('ALB_NOME', StrWhereLike, StrOrderBy, StrRegAtual, StrQtdReg));
end;

procedure TApiController.GetAlbunsCategoria;
var
  StrWhereLike, StrOrderBy, StrRegAtual, StrQtdReg: String;
begin
  // metodo GET: /albuns / QUERY PARAMS (por ART_CATEGORIA)
  StrWhereLike := Context.Request.QueryStringParam('wherelike'); // like na clausula where
  StrOrderBy   := Context.Request.QueryStringParam('orderby');   // ordenação ASC/DSC
  StrRegAtual  := Context.Request.QueryStringParam('regatual');  // Nr Reg Atual
  StrQtdReg    := Context.Request.QueryStringParam('qtdereg');   // Qtde Reg Paginação

  Render<TAlbum>(TAlbumService.GetAlbuns('ART_CATEGORIA', StrWhereLike, StrOrderBy, StrRegAtual, StrQtdReg));
end;

procedure TApiController.GetAlbunsArtista;
var
  StrWhereLike, StrOrderBy, StrRegAtual, StrQtdReg: String;
begin
  // metodo GET: /albuns / QUERY PARAMS (por ART_NOME)
  StrWhereLike := Context.Request.QueryStringParam('wherelike'); // like na clausula where
  StrOrderBy   := Context.Request.QueryStringParam('orderby');   // ordenação ASC/DSC
  StrRegAtual  := Context.Request.QueryStringParam('regatual');  // Nr Reg Atual
  StrQtdReg    := Context.Request.QueryStringParam('qtdereg');   // Qtde Reg Paginação

  Render<TAlbum>(TAlbumService.GetAlbuns('ART_NOME', StrWhereLike, StrOrderBy, StrRegAtual, StrQtdReg));
end;

procedure TApiController.GetAlbum(alb_id: Integer);
begin
  // metodo GET: /album/($alb_id)
  Render(TAlbumService.GetAlbum(alb_id));
end;

procedure TApiController.CreateAlbum;
var
  AAlbum: TAlbum;
begin
  // metodo POST: /album
  AAlbum := Context.Request.BodyAs<TAlbum>;
  try
    TAlbumService.CreateAlbum(AAlbum);
    Render(200, 'Album criado com sucesso');
  finally
    AAlbum.Free;
  end;
end;

procedure TApiController.UpdateAlbum(alb_id: Integer);
var
  AAlbum: TAlbum;
begin
  // metodo PUT: /album/($alb_id)
  AAlbum := Context.Request.BodyAs<TAlbum>;
  try
    TAlbumService.UpdateAlbum(alb_id, AAlbum);
    Render(200, Format('Album %d atualizado com sucesso', [alb_id]));
  finally
    AAlbum.Free;
  end;
end;

procedure TApiController.DeleteAlbum(alb_id: Integer);
begin
  // metodo DELETE: /album/($alb_id)
  TAlbumService.DeleteAlbum(alb_id);
  Render(200, Format('Album %d apagado com sucesso', [alb_id]));
end;


end.
