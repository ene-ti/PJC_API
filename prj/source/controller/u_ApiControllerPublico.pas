unit u_ApiControllerPublico;

interface

uses
  System.Classes, Graphics,
  Vcl.Dialogs, Vcl.imaging.jpeg, Vcl.ExtCtrls,
  System.SysUtils,
  System.StrUtils, Web.HTTPApp,
  MVCFramework,
  MVCFramework.Commons,
  MVCFramework.Serializer.Intf,
  MVCFramework.Swagger.Commons, // Documentação Swagger
  MVCFramework.Serializer.Commons,

  IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP, IdBaseComponent, IdAntiFreezeBase, IdAntiFreeze,
  IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL;

type

  [MVCPath('/')]
//  [MVCSwagAuthentication(atJsonWebToken)]   // Documentação
  TApiControllerPublico = class(TMVCController)
  protected
    procedure OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean); override;
    procedure OnAfterAction(Context: TWebContext; const AActionName: string); override;
  public
    [MVCPath('/')]
    [MVCPath('')]
    [MVCSwagSummaryAttribute(' Public', 'Pagina default da API', 'RootPage')]
    [MVCSwagResponsesAttribute(200, 'Versao da API')]
    [MVCHTTPMethod([httpGET])]
    procedure GetMyRootPage;
  end;


implementation

uses
  u00_Global;

procedure TApiControllerPublico.GetMyRootPage;
begin
  ContentType := TMVCMediaType.TEXT_HTML;
  Render(
    '<h1>' + C_nome_aplicacao+ ' - '+C_versao_aplicacao+ ' - '+C_data_compilacao+'</h1>' + sLineBreak +
    '<p>'  + C_desc_aplicacao+'</p>' + sLineBreak +
    '</br>' + sLineBreak +

    '</br>' + sLineBreak +
    '<h2>' + 'Para acesso a documentação digite: http://localhost:8080/docs' + '</h2>'
  );
end;

procedure TApiControllerPublico.OnAfterAction(Context: TWebContext; const AActionName: string);
begin
  { Executed after each action }
  inherited;
end;

procedure TApiControllerPublico.OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean);
begin
  { Executed before each action
    if handled is true (or an exception is raised) the actual
    action will not be called }
  inherited;
end;


end.
