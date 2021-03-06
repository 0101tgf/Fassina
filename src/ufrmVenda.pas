unit ufrmVenda;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TfrmVenda = class(TForm)
    DataSource: TDataSource;
    FDMemTable: TFDMemTable;
    FDMemTableTotalGeral: TAggregateField;
    FDMemTableCodEmp: TIntegerField;
    FDMemTableCodigo: TIntegerField;
    FDMemTableDescricao: TStringField;
    FDMemTableQtd: TCurrencyField;
    FDMemTableVlr_Uni: TCurrencyField;
    FDMemTableTotal: TCurrencyField;
    pnl_Centro: TPanel;
    pnl_Botom: TPanel;
    Label8: TLabel;
    Panel_Botoes: TPanel;
    Panel6: TPanel;
    btn_Novo: TSpeedButton;
    Panel2: TPanel;
    btn_Cancelar: TSpeedButton;
    Panel4: TPanel;
    btn_Salvar: TSpeedButton;
    Panel1: TPanel;
    btn_Fechar: TSpeedButton;
    Panel3: TPanel;
    pnl_Client: TPanel;
    Panel_Entradas: TPanel;
    Label1: TLabel;
    Label_Cliente: TLabel;
    Label_Produto: TLabel;
    Label4: TLabel;
    Label7: TLabel;
    Edit_Qtd: TEdit;
    edt_Documento: TEdit;
    Panel5: TPanel;
    btn_Lancar: TSpeedButton;
    edt_VlrUni: TEdit;
    DBGrid_Lancamentos: TDBGrid;
    Panel_Top: TPanel;
    lbl_Titulo: TLabel;
    pnl_barra: TPanel;
    Panel7: TPanel;
    SpeedButton_Pesquisar: TSpeedButton;
    Edit_CodCliente: TEdit;
    Edit_CodProduto: TEdit;
    Edit_TotalGeral: TEdit;
    Panel8: TPanel;
    SpeedButton_Excluir: TSpeedButton;
    procedure btn_FecharClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_NovoClick(Sender: TObject);
    procedure btn_CancelarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Edit_CodClienteExit(Sender: TObject);
    procedure Edit_CodClienteKeyPress(Sender: TObject; var Key: Char);
    procedure Edit_CodProdutoKeyPress(Sender: TObject; var Key: Char);
    procedure Edit_QtdKeyPress(Sender: TObject; var Key: Char);
    procedure Edit_CodProdutoExit(Sender: TObject);
    procedure edt_VlrUniKeyPress(Sender: TObject; var Key: Char);
    procedure btn_LancarClick(Sender: TObject);
    procedure DBGrid_LancamentosKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid_LancamentosColExit(Sender: TObject);
    procedure btn_SalvarClick(Sender: TObject);
    procedure SpeedButton_PesquisarClick(Sender: TObject);
    procedure SpeedButton_ExcluirClick(Sender: TObject);
  private
    { Private declarations }
    procedure pBuscaCliente;
    procedure pValidaValorDigitado(Sender: TObject;var Key: Char);
    procedure pBuscaProduto;
    function fValidaCamposObrigatorios:Boolean;
    procedure pCalculaTotalVenda;
    procedure pLimparLancamento;
  public
    { Public declarations }
    vOperacao : Integer; { 0 - Nova Venda / 1 - Atualizar}
    procedure pLimparCampos;
  end;

var
  frmVenda: TfrmVenda;

implementation

{$R *.dfm}

uses ufrmPrincipal, cCliente, uDm, cProduto, cVenda, ufrmOperacoesAux;

procedure TfrmVenda.btn_CancelarClick(Sender: TObject);
begin
 pLimparCampos;
 pnl_Client.Enabled := false;
end;

procedure TfrmVenda.btn_FecharClick(Sender: TObject);
begin
  frmVenda.close;
end;

procedure TfrmVenda.btn_LancarClick(Sender: TObject);
begin

  if not fValidaCamposObrigatorios then
  begin
    exit;
  end;

  try
  FDMemTable.Append;
  FDMemTable.FieldByName('CodEmp').AsInteger := frmPrincipal.vCodEmpDefult;
  FDMemTable.FieldByName('Codigo').AsInteger := StrToInt(Edit_CodProduto.Text);
  FDMemTable.FieldByName('Descricao').AsString := Label_Produto.Caption;
  FDMemTable.FieldByName('Qtd').AsCurrency := StrToCurr(Edit_Qtd.Text);
  FDMemTable.FieldByName('Vlr_Uni').AsCurrency := StrToCurr(edt_VlrUni.Text);
  FDMemTable.FieldByName('Total').AsCurrency := StrToCurr(edt_VlrUni.Text)*StrToCurr(Edit_Qtd.Text);
  FDMemTable.Post;
  except
  ShowMessage('Falha ao lan?ar produtos, solicite suporte..');
  exit;
  end;

  Edit_CodCliente.Enabled := false;
  Edit_CodCliente.Color := clBtnFace;
  pCalculaTotalVenda;
  pLimparLancamento;
  Edit_CodProduto.SetFocus;

end;

procedure TfrmVenda.btn_NovoClick(Sender: TObject);
var
  oVenda : TVenda;
begin

  pLimparCampos;

  oVenda := TVenda.Create(Dm.conexao,frmPrincipal.vCodEmpDefult);
  try

    if oVenda.fGeraNumeroVenda then
    begin
      edt_Documento.Text := oVenda.CodigoVenda.ToString+' - T';
    end
    else
    begin
      ShowMessage('Falha na gera??o do numero do documento, solicite suporte..');
      exit;
    end;

  finally
  oVenda.DisposeOf;
  end;


  pnl_Client.Enabled := True;
  Edit_CodCliente.SetFocus;
  frmVenda.vOperacao := 0; {Nova Venda}

end;

procedure TfrmVenda.btn_SalvarClick(Sender: TObject);
var
  Ovenda : TVenda;
  LRetorno : string;
begin

  Ovenda := TVenda.Create(dm.conexao,frmPrincipal.vCodEmpDefult);
  try

    try

      if vOperacao = 1 then // atualizar venda
      begin
      Ovenda.CodigoVenda := StrToInt(edt_Documento.Text);
      end;

      Ovenda.DtEmissao := Now;
      Ovenda.CodigoCliente := StrToInt(Edit_CodCliente.Text);
      Ovenda.ValorTotal := StrToCurr(Edit_TotalGeral.Text);

    except
    ShowMessage('Por favor, informe o cliente e lance algum produto..');
    exit;
    end;


    if Ovenda.fSalvarVenda(vOperacao,LRetorno,FDMemTable) then
    begin
    ShowMessage('Venda registrada com sucesso..');
    btn_NovoClick(self);
    end
    else
    begin
    ShowMessage(LRetorno);
    btn_NovoClick(self);
    end;

  finally
  Ovenda.DisposeOf;
  end;

end;

procedure TfrmVenda.DBGrid_LancamentosColExit(Sender: TObject);
begin

    if FDMemTable.RecordCount > 0 then
    begin
    FDMemTable.Edit;
    FDMemTable.FieldByName('Total').AsCurrency := FDMemTable.FieldByName('Qtd').AsFloat * FDMemTable.FieldByName('Vlr_Uni').AsCurrency;
    FDMemTable.Post;
    pCalculaTotalVenda;
    end
    else
    begin
    FDMemTable.Active := false;
    FDMemTable.Open;
    end;

end;

procedure TfrmVenda.DBGrid_LancamentosKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

 if key = vk_delete then
 begin

   if (Application.MessageBox('Deseja deletar esse produto ?','ATEN??O..',mb_YesNo+mb_IconInformation+mb_DefButton2) = ID_YES) then
   begin

     FDMemTable.Delete;
     pCalculaTotalVenda;

   end;

 end;

 if Key = VK_RETURN then
 begin

  If ( DBGrid_Lancamentos.SelectedIndex + 1 <> DBGrid_Lancamentos.FieldCount ) Then
  begin
  DBGrid_Lancamentos.SelectedIndex := DBGrid_Lancamentos.SelectedIndex + 1;
  end;

 end;

end;

procedure TfrmVenda.Edit_CodClienteExit(Sender: TObject);
begin

  if Edit_CodCliente.Text <> '' then
  begin
  pBuscaCliente;
  end;

end;

procedure TfrmVenda.Edit_CodClienteKeyPress(Sender: TObject; var Key: Char);
begin

  pValidaValorDigitado(Sender,Key);

  if (Key = #13) and (Edit_CodCliente.Text <> '') then
  begin

    Edit_CodProduto.SetFocus;

    if Label_Cliente.Caption = 'Cliente:' then
    begin
      Edit_CodCliente.SetFocus;
    end;


  end;

end;

procedure TfrmVenda.Edit_CodProdutoExit(Sender: TObject);
begin

  if Edit_CodProduto.Text <> '' then
  begin
  pBuscaProduto
  end;

end;

procedure TfrmVenda.Edit_CodProdutoKeyPress(Sender: TObject; var Key: Char);
begin

   pValidaValorDigitado(Sender,Key);

  if (Key = #13) and (Edit_CodProduto.Text <> '') then
  begin

    Edit_Qtd.SetFocus;

    if Label_Produto.Caption = 'Produto:' then
    begin
      Edit_CodProduto.SetFocus;
    end;

  end;

end;

procedure TfrmVenda.Edit_QtdKeyPress(Sender: TObject; var Key: Char);
begin
  pValidaValorDigitado(Sender,Key);

  if Key = #13 then
  begin
  btn_Lancar.Click;
  end;

end;

procedure TfrmVenda.edt_VlrUniKeyPress(Sender: TObject; var Key: Char);
begin
  pValidaValorDigitado(Sender,Key);
end;

procedure TfrmVenda.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  {Limpar o formulario da memoria ao fecha-lo..}
  Action := TCloseAction.caFree;
  frmVenda := nil;
  {Fim}

  frmPrincipal.GridPanel_Graficos.Visible := true;

end;

procedure TfrmVenda.FormShow(Sender: TObject);
begin
  pnl_Client.Enabled := false;
  btn_NovoClick(Self);
end;

function TfrmVenda.fValidaCamposObrigatorios: Boolean;
begin

  Result := false;

  if Edit_CodCliente.Text = '' then
  begin
    ShowMessage('Informe o c?digo do cliente..');
    Edit_CodCliente.SetFocus;
    exit;
  end;

  if Edit_CodProduto.Text = '' then
  begin
    ShowMessage('Informe o c?digo do produto..');
    Edit_CodProduto.SetFocus;
    exit;
  end;

  if (Edit_Qtd.Text = '') or (StrToFloat(Edit_Qtd.Text) <= 0)  then
  begin
    ShowMessage('Informe a quantidade do produto..');
    Edit_Qtd.SetFocus;
    exit;
  end;

  Result := true;

end;

procedure TfrmVenda.pBuscaCliente;
var
  oCliente : TCliente;
  LRetorno : String;
begin

  oCliente := TCliente.Create(dm.conexao,frmPrincipal.vCodEmpDefult);
  try

    if oCliente.fBuscaCliente(StrToInt(Edit_CodCliente.Text),LRetorno) then
    begin
    Label_Cliente.Caption := oCliente.Nome;
    end
    else
    begin
    ShowMessage(LRetorno);
    Label_Cliente.Caption := 'Cliente:';
    Edit_CodCliente.Text := '';
    end;


  finally
  oCliente.DisposeOf;
  end;

end;

procedure TfrmVenda.pBuscaProduto;
var
  oProduto : TProduto;
  LRetorno : String;
begin

  oProduto := TProduto.Create(dm.conexao,frmPrincipal.vCodEmpDefult);
  try

    if oProduto.fBuscaProduto(StrToInt(Edit_CodProduto.Text),LRetorno) then
    begin
    Label_Produto.Caption := oProduto.Descricao;
    edt_VlrUni.Text := FormatFloat('#0.00',oProduto.Valor);
    end
    else
    begin
    ShowMessage(LRetorno);
    Label_Produto.Caption := 'Produto:';
    Edit_CodProduto.Text := '';
    end;


  finally
  oProduto.DisposeOf;
  end;

end;

procedure TfrmVenda.pCalculaTotalVenda;
begin

  if FDMemTable.RecordCount > 0 then
  begin
  Edit_TotalGeral.Text :=  FormatFloat('#0.00', FDMemTable.FieldByName('TotalGeral').Value);
  end
  else
  begin
   Edit_TotalGeral.Text :=  FormatFloat('#0.00', 0);
  end;

end;

procedure TfrmVenda.pLimparCampos;
Var i:Integer;
begin

  for i := 0 to ComponentCount -1 do begin
    if (Components[i] is TEdit) then
      TEdit(Components[i]).Text:=EmptyStr
    else if (Components[i] is TComboBox) then
      TComboBox(Components[i]).ItemIndex:=-1
    else if (Components[i] is TFDMemTable) then
      TFDMemTable(Components[i]).Active:= false;
  end;

  Label_Cliente.Caption := 'Cliente: ';
  Label_Produto.Caption := 'Produto: ';
  Edit_CodCliente.Enabled := true;
  Edit_CodCliente.Color := clWhite;

  FDMemTable.Open;

end;

procedure TfrmVenda.pLimparLancamento;
begin
  Label_Produto.Caption := 'Produto:';
  Edit_CodProduto.Text := '';
  Edit_Qtd.Text := '';
  edt_VlrUni.Text := '';
end;

procedure TfrmVenda.pValidaValorDigitado(Sender: TObject; var Key: Char);
begin

  if key in [#13,'0','1','2','3','4','5','6','7','8','9',',',#8] = false then
  begin
  key:=#0;
  end;

end;

procedure TfrmVenda.SpeedButton_ExcluirClick(Sender: TObject);
begin

  if FDMemTable.RecordCount > 0 then
  begin
    ShowMessage('Aten??o, voc? est? no meio de uma venda, cancele a opera??o para realizar esse processo..');
    exit;
  end;

  if not Assigned(frmOperacoesAux) then
  begin
    Application.CreateForm(TfrmOperacoesAux,frmOperacoesAux);
  end;

  frmOperacoesAux.Caption := 'Excluir Venda..';
  frmOperacoesAux.vTipoOperacao := 0;  // excluir
  frmOperacoesAux.ShowModal;

end;

procedure TfrmVenda.SpeedButton_PesquisarClick(Sender: TObject);
begin

  if FDMemTable.RecordCount > 0 then
  begin
    ShowMessage('Aten??o, voc? est? no meio de uma venda, cancele a opera??o para realizar esse processo..');
    exit;
  end;

  if not Assigned(frmOperacoesAux) then
  begin
    Application.CreateForm(TfrmOperacoesAux,frmOperacoesAux);
  end;

  frmOperacoesAux.Caption := 'Pesquisar Venda..';
  frmOperacoesAux.vTipoOperacao := 1; // pesquisar
  frmOperacoesAux.ShowModal;

end;

end.
