unit u_ApiControllerAlbum;

interface

uses
  dialogs,
  System.SysUtils,
  System.StrUtils,
  MVCFramework,
  MVCFramework.Commons,
  MVCFramework.Serializer.Commons;

type
//  [MVCPath('/api')]
  TApiControllerAlbum = class(TMVCController)
  protected
    procedure OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean); override;
    procedure OnAfterAction(Context: TWebContext; const AActionName: string); override;

  public
    [MVCPath('/')]
    [MVCPath('')]
    [MVCHTTPMethod([httpGET])]
    procedure GetMyRootPage;

    [MVCPath('/albuns')]
    [MVCHTTPMethod([httpGET])]
    procedure GetAlbuns;

    [MVCPath('/albumcategoria')]
    [MVCHTTPMethod([httpGET])]
    procedure GetAlbunsCategoria;

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
  end;

implementation

uses
  u_AlbumService,
  u_AlbumClass,
  u00_Global;

procedure TApiControllerAlbum.GetMyRootPage;
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

procedure TApiControllerAlbum.OnAfterAction(Context: TWebContext; const AActionName: string);
begin
  { Executed after each action }
  inherited;
end;

procedure TApiControllerAlbum.OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean);
begin
  { Executed before each action
    if handled is true (or an exception is raised) the actual
    action will not be called }
  inherited;
end;


procedure TApiControllerAlbum.GetAlbuns;
var
  StrWhereLike, StrOrderBy, StrRegAtual, StrQtdReg: String;
begin
  // metodo GET: /album / QUERY PARAMS (por ALB_NOME)
  StrWhereLike := Context.Request.QueryStringParam('wherelike'); // like na clausula where
  StrOrderBy   := Context.Request.QueryStringParam('orderby');   // ordena��o ASC/DSC
  StrRegAtual  := Context.Request.QueryStringParam('regatual');  // Nr Reg Atual
  StrQtdReg    := Context.Request.QueryStringParam('qtdereg');   // Qtde Reg Pagina��o

  Render<TAlbum>(TAlbumService.GetAlbuns('ALB_NOME', StrWhereLike, StrOrderBy, StrRegAtual, StrQtdReg));
end;

procedure TApiControllerAlbum.GetAlbunsCategoria;
var
  StrWhereLike, StrOrderBy, StrRegAtual, StrQtdReg: String;
begin
  // metodo GET: /albuns / QUERY PARAMS (por ALB_CATEGORIA)
  StrWhereLike := Context.Request.QueryStringParam('wherelike'); // like na clausula where
  StrOrderBy   := Context.Request.QueryStringParam('orderby');   // ordena��o ASC/DSC
  StrRegAtual  := Context.Request.QueryStringParam('regatual');  // Nr Reg Atual
  StrQtdReg    := Context.Request.QueryStringParam('qtdereg');   // Qtde Reg Pagina��o

  Render<TAlbum>(TAlbumService.GetAlbuns('ALB_NOME', StrWhereLike, StrOrderBy, StrRegAtual, StrQtdReg));
end;

procedure TApiControllerAlbum.GetAlbum(alb_id: Integer);
begin
  // metodo GET: /album/($alb_id)
  Render(TAlbumService.GetAlbum(alb_id));
end;

procedure TApiControllerAlbum.CreateAlbum;
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

procedure TApiControllerAlbum.UpdateAlbum(alb_id: Integer);
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

procedure TApiControllerAlbum.DeleteAlbum(alb_id: Integer);
begin
  // metodo DELETE: /album/($alb_id)
  TAlbumService.DeleteAlbum(alb_id);
  Render(200, Format('Album %d apagado com sucesso', [alb_id]));
end;



end.
