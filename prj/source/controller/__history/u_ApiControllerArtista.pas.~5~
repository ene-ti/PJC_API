unit u_ApiControllerArtista;

interface

uses
  System.Classes, Graphics,
  Vcl.Dialogs, Vcl.imaging.jpeg, Vcl.ExtCtrls,
  System.SysUtils,
  System.StrUtils, Web.HTTPApp,
  MVCFramework,
  MVCFramework.Commons,
  MVCFramework.Serializer.Intf,
  MVCFramework.Serializer.Commons,
  MVCFramework.Swagger.Commons, // Documentação Swagger
  u_ArtistaService, u_ArtistaClass,

  IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP, IdBaseComponent, IdAntiFreezeBase, IdAntiFreeze,
  IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL;

type

  [MVCPath('/api')]
  [MVCSwagAuthentication(atJsonWebToken)]   // Documentação
  TApiControllerArtista = class(TMVCController)
  protected
    procedure OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean); override;
    procedure OnAfterAction(Context: TWebContext; const AActionName: string); override;
  public
    // - Path ARTISTA
    [MVCPath('/artistas')]
    [MVCSwagSummaryAttribute('Artistas', 'Lista de Artistas por Nome', 'GetArtistas')]
    [MVCSwagParamAttribute(plQuery, 'wherelike', 'Filtro por Nome do Artista', ptString, False)]
    [MVCSwagParamAttribute(plQuery, 'orderby', 'Ordenação ASC ou DSC', ptString, False)]
    [MVCSwagParamAttribute(plQuery, 'regatual', 'Paginação a partir do registro n?', ptString, False)]
    [MVCSwagParamAttribute(plQuery, 'qtdereg', 'Numero de registro por pagina', ptString, False)]
    [MVCSwagResponsesAttribute(200, 'Lista de Artistas', TArtista, True)]
    [MVCHTTPMethod([httpGET])]
    procedure GetArtistas;

    [MVCPath('/artistascategoria')]
    [MVCSwagSummaryAttribute('Artistas', 'Lista de Artistas por Categoria', 'GetArtistasCategoria')]
    [MVCSwagParamAttribute(plQuery, 'wherelike', 'Filtro por Categoria do Artista', ptString, False)]
    [MVCSwagParamAttribute(plQuery, 'orderby', 'Ordenação ASC ou DSC', ptString, False)]
    [MVCSwagParamAttribute(plQuery, 'regatual', 'Paginação a partir do registro n?', ptString, False)]
    [MVCSwagParamAttribute(plQuery, 'qtdereg', 'Numero de registro por pagina', ptString, False)]
    [MVCSwagResponsesAttribute(200, 'Lista de Artistas', TArtista, True)]
    [MVCHTTPMethod([httpGET])]
    procedure GetArtistasCategoria;

    [MVCPath('/artista/($art_id)')]
    [MVCSwagSummaryAttribute('Artistas', 'Retorna o Artista n...', 'GetArtista')]
    [MVCSwagParamAttribute(plPath, 'art_id', 'ID do Artista', ptInteger, True)]
    [MVCSwagResponsesAttribute(200, 'Artista', TArtista, False)]
    [MVCHTTPMethod([httpGET])]
    procedure GetArtista(art_id: Integer);

    [MVCPath('/artista')]
    [MVCSwagSummaryAttribute('Artistas', 'Insere o Artista', 'CreateArtista')]
    [MVCSwagParam(plBody, 'Artista', 'Artista Inserido', TArtista)]
    [MVCSwagResponsesAttribute(201, 'Artista', TArtista, False)]
    [MVCHTTPMethod([httpPOST])]
    procedure CreateArtista;

    [MVCPath('/artista/($art_id)')]
    [MVCSwagSummaryAttribute('Artistas', 'Altera o Artista', 'UpdateArtista')]
    [MVCSwagParamAttribute(plPath, 'art_id', 'ID do Artista', ptInteger, True)]
    [MVCSwagParam(plBody, 'Artista', 'Artista Alterado', TArtista)]
    [MVCSwagResponsesAttribute(200, 'Artista', TArtista, False)]
    [MVCHTTPMethod([httpPUT])]
    procedure UpdateArtista(art_id: Integer);

    [MVCPath('/artista/($art_id)')]
    [MVCSwagSummaryAttribute('Artistas', 'Apaga o Artista', 'DeleteArtista')]
    [MVCSwagParamAttribute(plPath, 'art_id', 'ID do Artista', ptInteger, True)]
    [MVCSwagResponsesAttribute(200, 'Artista apagado com sucesso')]
    [MVCHTTPMethod([httpDELETE])]
    procedure DeleteArtista(art_id: Integer);
    // - Path ARTISTA

  end;

implementation

uses
  u00_Global;

procedure TApiControllerArtista.OnAfterAction(Context: TWebContext; const AActionName: string);
begin
  { Executed after each action }
  inherited;
end;

procedure TApiControllerArtista.OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean);
begin
  { Executed before each action
    if handled is true (or an exception is raised) the actual
    action will not be called }
  inherited;
end;

    // - Path ARTISTA
procedure TApiControllerArtista.GetArtistas;
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

procedure TApiControllerArtista.GetArtistasCategoria;
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

procedure TApiControllerArtista.GetArtista(art_id: Integer);
begin
  // metodo GET: /artista/($art_id)
  Render(TArtistaService.GetArtista(art_id));
end;

procedure TApiControllerArtista.CreateArtista;
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

procedure TApiControllerArtista.UpdateArtista(art_id: Integer);
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

procedure TApiControllerArtista.DeleteArtista(art_id: Integer);
begin
  // metodo DELETE: /artista/($art_id)
  TArtistaService.DeleteArtista(art_id);
  Render(200, Format('Artista %d apagado com sucesso', [art_id]));
end;
    // - Path ARTISTA

end.
