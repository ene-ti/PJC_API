unit u_ArtistaClass;

interface

uses
  MVCFramework.Swagger.Commons, // Documentação Swagger
  MVCFramework.ActiveRecord,
  MVCFramework.Serializer.Commons;

type
  [MVCNameCaseAttribute(ncLowerCase)]
  [MVCTableAttribute('Produto')]
  TArtista = class(TMVCActiveRecord)
  [MVCEntityActionsAttribute([eaCreate, eaRetrieve, eaUpdate, eaDelete])]
  private
    [MVCTableFieldAttribute('art_id', [foPrimaryKey, foAutoGenerated])]
    Fart_id: Integer;

    [MVCTableFieldAttribute('art_nome')]
    Fart_nome: string;

    [MVCTableFieldAttribute('art_categoria')]
    Fart_categoria: String;
  public
    [MVCSwagJSONSchemaFieldAttribute(stInteger, 'art_id', 'ID do Artista', True)]
    property art_id: Integer read Fart_id write Fart_id;

    [MVCSwagJSONSchemaFieldAttribute(stString, 'art_nome', 'Nome do Artista', True)]
    property art_nome: string read Fart_nome write Fart_nome;

    [MVCSwagJSONSchemaFieldAttribute(stString, 'art_categoria', 'Categoria do Artista', True)]
    property art_categoria: string read Fart_categoria write Fart_categoria;
  end;

implementation

end.
