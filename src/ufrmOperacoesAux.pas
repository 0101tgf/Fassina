unit ufrmOperacoesAux;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.ExtCtrls, Vcl.StdCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TfrmOperacoesAux = class(TForm)
    Panel1: TPanel;
    btn_Confirmar: TSpeedButton;
    Panel2: TPanel;
    btn_Cancelar: TSpeedButton;
    Edit_CodigoVenda: TEdit;
    Label1: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_CancelarClick(Sender: TObject);
    procedure Edit_CodigoVendaKeyPress(Sender: TObject; var Key: Char);
    procedure btn_ConfirmarClick(Sender: TObject);
  private
    { Private declarations }
    procedure pValidaValorDigitado(Sender: TObject;var Key: Char);
  public
    { Public declarations }
    vTipoOperacao : Integer; {0 - Excluir / 1 - Pesquisar}
  end;

var
  frmOperacoesAux: TfrmOperacoesAux;

implementation

{$R *.dfm}

uses cVenda, ufrmPrincipal, uDm, ufrmVenda;

procedure TfrmOperacoesAux.btn_CancelarClick(Sender: TObject);
begin
  frmOperacoesAux.close;
end;

procedure TfrmOperacoesAux.btn_ConfirmarClick(Sender: TObject);
var
  Ovenda : TVenda;
  LRetorno : string;
begin

  if Edit_CodigoVenda.Text = '' then
  begin
    ShowMessage('Informe o c?digo da venda..');
    exit;
  end;

  Ovenda := TVenda.Create(dm.conexao,frmPrincipal.vCodEmpDefult);
  try

    Ovenda.CodigoVenda := StrToInt(Edit_CodigoVenda.Text);

    if not Ovenda.fVerificaVendaExiste(LRetorno) then
    begin
      ShowMessage(LRetorno);
      exit;
    end;


    case vTipoOperacao of

      0:  // excluir
      begin

        if not Ovenda.fExcluirVenda(LRetorno) then
        begin
          ShowMessage(LRetorno);
        end
        else
        begin
          ShowMessage('Venda: '+Ovenda.CodigoVenda.ToString+' deletada com sucesso..');
          frmOperacoesAux.Close;
        end;

      end;
      1:  // pesquisar
      begin

         if not Ovenda.fCarregarVenda(LRetorno) then
         begin
          ShowMessage(LRetorno);
         end
         else
         begin

          frmVenda.pnl_Client.Enabled := true;

          frmVenda.pLimparCampos;

          frmVenda.edt_Documento.Text := Ovenda.CodigoVenda.ToString;
          frmVenda.Edit_CodCliente.Text := Ovenda.CodigoCliente.ToString;
          frmVenda.Label_Cliente.Caption := Ovenda.NomeCliente;
          frmVenda.Edit_TotalGeral.Text := FormatFloat('#0.00',Ovenda.ValorTotal);
          frmVenda.Edit_CodCliente.Enabled := false;
          frmVenda.Edit_CodCliente.Color := clBtnFace;
          frmVenda.Edit_CodProduto.SetFocus;
          frmVenda.vOperacao := 1; {Atualizar Venda}

          Ovenda.ProdutosMemoria.First;

          while not Ovenda.ProdutosMemoria.Eof do
          begin

            frmVenda.FDMemTable.Append;
            frmVenda.FDMemTable.FieldByName('CodEmp').AsInteger := Ovenda.CodEmp;
            frmVenda.FDMemTable.FieldByName('Codigo').AsInteger := Ovenda.ProdutosMemoria.FieldByName('Cod_Produto').AsInteger;
            frmVenda.FDMemTable.FieldByName('Descricao').AsString := Ovenda.ProdutosMemoria.FieldByName('descricao').AsString;
            frmVenda.FDMemTable.FieldByName('Qtd').AsCurrency := Ovenda.ProdutosMemoria.FieldByName('Quantidade').AsCurrency;
            frmVenda.FDMemTable.FieldByName('Vlr_Uni').AsCurrency := Ovenda.ProdutosMemoria.FieldByName('Vlr_Uni').AsCurrency;
            frmVenda.FDMemTable.FieldByName('Total').AsCurrency := Ovenda.ProdutosMemoria.FieldByName('Vlr_Total').AsCurrency;
            frmVenda.FDMemTable.Post;

            Ovenda.ProdutosMemoria.Next;

          end;

          frmOperacoesAux.Close;

         end;

      end;

    end;

  finally
  Ovenda.DisposeOf;
  end;

end;

procedure TfrmOperacoesAux.Edit_CodigoVendaKeyPress(Sender: TObject; var Key: Char);
begin

  pValidaValorDigitado(Sender,Key);

  if Key = #13 then
  begin
    btn_ConfirmarClick(Self);
  end;

end;

procedure TfrmOperacoesAux.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  {Limpar o formulario da memoria ao fecha-lo..}
  Action := TCloseAction.caFree;
  frmOperacoesAux := nil;
  {Fim}
end;

procedure TfrmOperacoesAux.pValidaValorDigitado(Sender: TObject; var Key: Char);
begin

  if key in [#13,'0','1','2','3','4','5','6','7','8','9',#8] = false then
  begin
  key:=#0;
  end;

end;

end.
