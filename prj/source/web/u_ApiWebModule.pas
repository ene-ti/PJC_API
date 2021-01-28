unit u_ApiWebModule;

interface

uses
  System.SysUtils,
  System.Classes,
  System.DateUtils,
  Web.HTTPApp,
  System.IOUtils,
  System.Generics.Collections,
  MVCFramework,
  MVCFramework.Commons,
  MVCFramework.Middleware.StaticFiles,
  MVCFramework.Middleware.Compression,
  MVCFramework.Server,
  MVCFramework.Server.Impl,
  MVCFramework.Middleware.Authentication,
  MVCFramework.JWT,
  MVCFramework.Middleware.JWT,
  MVCFramework.Swagger.Commons, // Documentação Swagger
  MVCFramework.Middleware.Swagger, // Documentação Swagger
  IdBaseComponent, IdComponent, IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL;

type
  TApiWebModule = class(TWebModule)
    procedure WebModuleCreate(Sender: TObject);
    procedure WebModuleDestroy(Sender: TObject);
  private
    FMVC: TMVCEngine;
  public
    { Public declarations }
  end;

var
  WebModuleClass: TComponentClass = TApiWebModule;
  vSwaggerInfo : TMVCSwaggerInfo;  // Documentação Swagger

const
   Login_EndPoint = '/login';

implementation

Uses u00_Global,
  u_BasicAuth, u_JWTAuth,
  u_ApiControllerArtista,
  u_ApiControllerAlbum,
  u_ApiControllerCapa,
  u_ApiControllerPublico;

{$R *.dfm}


procedure TApiWebModule.WebModuleCreate(Sender: TObject);
var
  LClaims: TJWTClaimsSetup;
begin
  FMVC := TMVCEngine.Create(Self,
    procedure(Config: TMVCConfig)
    begin
      // session timeout
      Config[TMVCConfigKey.SessionTimeout] := '0'; // 0=Autentitica uma unica vez e guarda no cookie
      // Config[TMVCConfigKey.SessionTimeout] := '-1'; // 1=Autentitica a cada requisição (consome muito recurso)
      //default content-type
      Config[TMVCConfigKey.DefaultContentType] := TMVCConstants.DEFAULT_CONTENT_TYPE;
      //default content charset
      Config[TMVCConfigKey.DefaultContentCharset] := TMVCConstants.DEFAULT_CONTENT_CHARSET;
      //unhandled actions are permitted?
      Config[TMVCConfigKey.AllowUnhandledAction] := 'false';
      //enables or not system controllers loading (available only from localhost requests)
      Config[TMVCConfigKey.LoadSystemControllers] := 'true';
      //default view file extension
      Config[TMVCConfigKey.DefaultViewFileExtension] := 'html';
      //view path
      Config[TMVCConfigKey.ViewPath] := 'templates';
      //Max Record Count for automatic Entities CRUD
      Config[TMVCConfigKey.MaxEntitiesRecordCount] := '20';
      //Enable Server Signature in response
      Config[TMVCConfigKey.ExposeServerSignature] := 'true';
      //Enable X-Powered-By Header in response
      Config[TMVCConfigKey.ExposeXPoweredBy] := 'true';
      // Max request size in bytes
      Config[TMVCConfigKey.MaxRequestSize] := IntToStr(TMVCConstants.DEFAULT_MAX_REQUEST_SIZE);
    end);
  FMVC.AddController(TApiControllerArtista);
  FMVC.AddController(TApiControllerAlbum);
  FMVC.AddController(TApiControllerCapa);
  FMVC.AddController(TApiControllerPublico);

   // Documentação Swagger
   vSwaggerInfo.Title          := 'API do Projeto PJC (Artista Album)';
   vSwaggerInfo.Version        := 'V1';
   vSwaggerInfo.TermsOfService := 'Projeto para PJC';
   vSwaggerInfo.Description    := 'Documentação da API PJC';
   vSwaggerInfo.ContactName    := 'Nelsimar Selano Goncalves';
   vSwaggerInfo.ContactEmail   := 'nelsimar.sg@gmail.com';
   vSwaggerInfo.ContactUrl     := '';
   vSwaggerInfo.LicenseName    := '';
   vSwaggerInfo.LicenseUrl     := '';
   FMVC.AddMiddleware(TMVCSwaggerMiddleware.create(FMVC,
        vSwaggerInfo, '/api/swagger.json',
        'Autenticação por JWT', False));

  FMVC.AddMiddleware(TMVCStaticFilesMiddleware.Create(
      '/docs', '.\www', 'index.html'));
   // Documentação Swagger

  // To enable compression (deflate, gzip) just add this middleware as the last one
  FMVC.AddMiddleware(TMVCCompressionMiddleware.Create);

  // Autenticação Basica
  // FMVC.AddMiddleware(TMVCBasicAuthenticationMiddleware.Create(TBasicAuth.Create));
  // Autenticação JWT
  LClaims :=
    procedure(const JWT: TJWT)  // https://jwt.io - Para decodificar o TOKEN
    begin
      JWT.Claims.Issuer := 'Projeto PJC_API_ArtAlbum'; // Quem gerou o token
      JWT.Claims.ExpirationTime := Now + (OneMinute * 5); // Tempo de validade do token (5minutos)
      JWT.Claims.NotBefore := now; // Token valido a partir de?
      JWT.Claims.IssuedAt := Now; // Quando o token foi gerado

      // claims opicionais, etc
      JWT.CustomClaims['nome'] := 'Nelsimar';
      JWT.CustomClaims['cpf'] := '128.943.258-94';
    end;
  FMVC.AddMiddleware(TMVCJWTAuthenticationMiddleware.Create(
    TJWTAuth.Create,
    vgAppSecretKey,      // chave secreta do token
    Login_EndPoint,  // path para a chamado do login
    LClaims,
    [TJWTCheckableClaim.ExpirationTime, TJWTCheckableClaim.NotBefore, TJWTCheckableClaim.IssuedAt], //O que vai ser checado
    50 //tempo em segundos de tolerancia entre a expiração da chave e hora do servidor
    ));

end;

procedure TApiWebModule.WebModuleDestroy(Sender: TObject);
begin
  FMVC.Free;
end;

end.
