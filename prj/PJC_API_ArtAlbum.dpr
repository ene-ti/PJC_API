program PJC_API_ArtAlbum;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  MVCFramework.Logger,
  MVCFramework.Commons,
  MVCFramework.REPLCommandsHandlerU,
  Web.ReqMulti,
  Web.WebReq,
  Web.WebBroker,
  IdContext,
  IdHTTPWebBrokerBridge,
  u_ApiController in 'units\u_ApiController.pas',
  u_ApiWebModule in 'units\u_ApiWebModule.pas' {ApiWebModule: TWebModule},
  u_ArtistaClass in 'units\u_ArtistaClass.pas',
  u_ArtistaService in 'units\u_ArtistaService.pas',
  u00_SetupINI in 'units\u00_SetupINI.pas' {frmSetupINI},
  u00_FunPro in 'units\u00_FunPro.pas',
  u00_Global in 'units\u00_Global.pas',
  u00_Conexao in 'units\u00_Conexao.pas',
  u_AlbumClass in 'units\u_AlbumClass.pas',
  u_AlbumService in 'units\u_AlbumService.pas',
  u_CapaClass in 'units\u_CapaClass.pas',
  u_CapaService in 'units\u_CapaService.pas';

{$R *.res}

procedure RunServer(APort: Integer);
var
  LServer: TIdHTTPWebBrokerBridge;
  LCustomHandler: TMVCCustomREPLCommandsHandler;
  LCmd: string;
begin
  Writeln('*****************************************************');
  Writeln('** DMVCFramework Server ** build: ' + DMVCFRAMEWORK_VERSION + ' **');
  Writeln('*****************************************************');
  Writeln('** Server - PJC API Artista x Album                **');
  Writeln('*****************************************************');
  Writeln('');

  LCmd := 'start';
  if ParamCount >= 1 then
    LCmd := ParamStr(1);

  LCustomHandler := function(const Value: String; const Server: TIdHTTPWebBrokerBridge; out Handled: Boolean): THandleCommandResult
    begin
      Handled := False;
      Result := THandleCommandResult.Unknown;

      // Write here your custom command for the REPL using the following form...
      // ***
      // Handled := False;
      // if (Value = 'apiversion') then
      // begin
      // REPLEmit('Print my API version number');
      // Result := THandleCommandResult.Continue;
      // Handled := True;
      // end
      // else if (Value = 'datetime') then
      // begin
      // REPLEmit(DateTimeToStr(Now));
      // Result := THandleCommandResult.Continue;
      // Handled := True;
      // end;
    end;

  LServer := TIdHTTPWebBrokerBridge.Create(nil);
  try
    LServer.DefaultPort := APort;
    LServer.KeepAlive := True;

    { more info about MaxConnections
      http://ww2.indyproject.org/docsite/html/frames.html?frmname=topic&frmfile=index.html }
    LServer.MaxConnections := 0;

    { more info about ListenQueue
      http://ww2.indyproject.org/docsite/html/frames.html?frmname=topic&frmfile=index.html }
    LServer.ListenQueue := 200;

    {required if you use JWT middleware }
    LServer.OnParseAuthentication := TMVCParseAuthentication.OnParseAuthentication;

    WriteLn('Write "quit" or "exit" to shutdown the server');
    repeat
      if LCmd.IsEmpty then
      begin
        Write('-> ');
        ReadLn(LCmd)
      end;
      try
        case HandleCommand(LCmd.ToLower, LServer, LCustomHandler) of
          THandleCommandResult.Continue:
            begin
              Continue;
            end;
          THandleCommandResult.Break:
            begin
              Break;
            end;
          THandleCommandResult.Unknown:
            begin
              REPLEmit('Unknown command: ' + LCmd);
            end;
        end;
      finally
        LCmd := '';
      end;
    until False;

  finally
    LServer.Free;
  end;
end;

begin
  ChecaArqIni;
  if (CargaParametrosIniciais = true) then
  begin
    // cria pool de conexao com banco de dados
    CreatePoolConnection;

    ReportMemoryLeaksOnShutdown := True;
    IsMultiThread := True;
    try
      if WebRequestHandler <> nil then
        WebRequestHandler.WebModuleClass := WebModuleClass;
      WebRequestHandlerProc.MaxConnections := 1024;
      RunServer(StrToIntDef(vgAppWebPorta, 8080));   // default = 8080
    except
      on E: Exception do
       Writeln(E.ClassName, ': ', E.Message);
    end;
  end;
end.
