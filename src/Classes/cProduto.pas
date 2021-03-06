unit cProduto;

interface

uses System.Classes,
     System.SysUtils,
     FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
     FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
     FireDAC.Phys, FireDAC.FMXUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
     FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
     FireDAC.Comp.Client;

type
    TProduto = Class
    private
    FConexao: TFDConnection;
    FCodEmp: integer;
    FCodigo: integer;
    FDescricao: string;
    FValor: Currency;
    FAtivo: Integer;

    public
    property Conexao: TFDConnection read FConexao write FConexao;
    property CodEmp: integer read FCodEmp write FCodEmp;
    property Codigo: integer read FCodigo write FCodigo;
    property Descricao: string read FDescricao write FDescricao;
    property Valor: Currency read FValor write FValor;
    property Ativo: Integer read FAtivo write FAtivo;
    function fBuscaProduto(const PCodigo: Integer; out PRetorno:String):Boolean;
    constructor Create(AConexao:TFDConnection; ACodEmp: Integer);
    destructor Destroy; override;
    End;

implementation

{ TProduto }

uses ufrmPrincipal;

{$region 'CONSTRUTOR E DESTRUIDOR'}

constructor TProduto.Create(AConexao: TFDConnection; ACodEmp: Integer);
begin
  Conexao := AConexao;
  CodEmp := ACodEmp;
end;

destructor TProduto.Destroy;
begin
  inherited;
end;
{$endregion}

{$region 'METODOS'}

function TProduto.fBuscaProduto(const PCodigo: Integer; out PRetorno:String):Boolean;
  var
  Qry : TFDQuery;
begin

 Result := False;

 Qry := TFDQuery.Create(Nil);
 Qry.Connection := Conexao;
 try

  Qry.Active := false;
  Qry.SQL.clear;
  Qry.SQL.Add('select CodEmp,Codigo,Descricao,Valor,Ativo from produtos where CodEmp = :CodEmp');
  Qry.SQL.Add('and Ativo=1 and Codigo=:Codigo limit 1');
  Qry.ParamByName('CodEmp').AsInteger := CodEmp;
  Qry.ParamByName('Codigo').AsInteger := PCodigo;
  Qry.Active := true;

  if Qry.RecordCount > 0 then
  begin
  Descricao := Qry.FieldByName('Descricao').AsString;
  Valor := Qry.FieldByName('Valor').AsCurrency;
  Result := true;
  end
  else
  begin
  PRetorno := 'Produto n?o encontrado..';
  end;


 finally
 Qry.DisposeOf;
 end;

end;

{$endregion}

end.
