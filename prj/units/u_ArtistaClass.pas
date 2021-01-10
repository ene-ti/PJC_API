unit u_ArtistaClass;

interface

uses
  MVCFramework.Serializer.Commons;

type
  [MVCNameCaseAttribute(ncLowerCase)]
  TArtista = class
  private
    Fart_id: Integer;
    Fart_nome: string;
  public
    property art_id: Integer read Fart_id write Fart_id;
    property art_nome: string read Fart_nome write Fart_nome;
  end;

implementation

end.
