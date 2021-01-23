unit u_ApiWebModule;

interface

uses
  System.SysUtils,
  System.Classes,
  System.DateUtils,
  Web.HTTPApp,
  u_BasicAuth, u_JWTAuth,
  u_ApiController,
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
  MVCFramework.Middleware.JWT;

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

const
   Secret_Key = '1Chave2Secreta3';
   Login_EndPoint = '/login';

implementation

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
  FMVC.AddController(TApiControllerPublic);
  FMVC.AddController(TApiController);

  // Enable the following middleware declaration if you want to
  // serve static files from this dmvcframework service.
  // The folder mapped as documentroot must exists!
  // FMVC.AddMiddleware(TMVCStaticFilesMiddleware.Create(
  //    '/static',
  //    TPath.Combine(ExtractFilePath(GetModuleName(HInstance)), 'www'))
  //  );

  // To enable compression (deflate, gzip) just add this middleware as the last one
  FMVC.AddMiddleware(TMVCCompressionMiddleware.Create);

  // Autenticação Basica
  //FMVC.AddMiddleware(TMVCBasicAuthenticationMiddleware.Create(TBasicAuth.Create));
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
    Secret_Key,      // chave secreta do token
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
