:- dynamic cliente/3.
:- dynamic artigo/3.
:- dynamic inventario/2.
:- dynamic vendas/3.


%Cliente(Nome,Cidade,risco_credito).

cliente(daniel,funchal,xxx).
cliente(david,aveiro,aaa).
cliente(rui,aveiro,bbb).
cliente(julia,leiria,aaa).
cliente(jose,caldas_da_rainha,aaa).
cliente(tomas,coimbra,ccc).
cliente(americo,sintra,bbb).

%Artigo(referencia,nome,Quantidade_min_alerta).
artigo(a1,rato_otico,10).
artigo(a2,teclado_s_fios,10).
artigo(a3,lcd_15,10).
artigo(a4,portatil_zen_5013,10).
artigo(a5,portatil_zen_5050,10).
artigo(a6,pen_512Mb_blue,10).
artigo(a7,disco_externo_2Gb,10).

%inventario(referencia,Quantidade).
inventario(a1,10).
inventario(a2,10).
inventario(a3,10).
inventario(a4,78).
inventario(a5,23).
inventario(a6,14).
inventario(a7,8).

%vendas(Cliente,Artigo,Quantidade).
vendas(daniel,a1,12).
vendas(americo,a4,1).


%listar_cliente(L).
% Amostra de Query-> listar_cliente(L).
listar_cliente(L):- findall(X,cliente(X,_,_),L).

%listar_cliente_bom(L).
% Amostra de Query-> listar_cliente_bom(L).
listar_cliente_bom(L):- findall(X,cliente(X,_,aaa),L).

%total_cliente_cidade(L).
% Amostra de Query-> total_cliente_cidade(L,Cidade).
total_cliente_cidade(L,Cidade):- findall(X,cliente(X,Cidade,_),Lis) , counter(Lis,L).

%listar_cliente_vendas(L).
% Amostra de Query-> listar_cliente_vendas(L).
listar_cliente_vendas(L):- findall(X,(vendas(X,_,_)),L).

%inventario_quantidade_stock(Artigo,Quantidade).
% % Amostra de Queries :- 
% inventario_quantidade_stock(a1,X).
% inventario_quantidade_stock(a9,77).
inventario_quantidade_stock(Artigo,Quantidade):- inventario(Artigo,Quantidade).
inventario_quantidade_stock(Artigo,Quantidade):- assert(inventario(Artigo,Quantidade)).


%artigo_verificar_abaixo_min_alerta (Artigo,Quantidade).
% % Amostra de Queries :- 
% artigo_verificar_abaixo_min_alerta(a1,X).
% artigo_verificar_abaixo_min_alerta(a7,X).
artigo_verificar_abaixo_min_alerta(Artigo,Quantidade):- inventario(Artigo,Quantidade),artigo(Artigo,_,Min_Quantidade),Min_Quantidade =< Quantidade, write('Quantidade acima do limite minimo.').
artigo_verificar_abaixo_min_alerta(Artigo,Quantidade):- inventario(Artigo,Quantidade),artigo(Artigo,_,Min_Quantidade),Min_Quantidade > Quantidade, write('Alerta!, Quantidade abaixo do limite minimo.').

%venda_validar_artigo_cliente(Cliente,Artigo,Quantidade).
% % Amostra de Queries :- 
% venda_validar_artigo_cliente(daniel,a1,12).
venda_validar_artigo_cliente(Cliente,Artigo,Quantidade):- inventario(Artigo,Quantidade_atual),Quantidade_atual >= Quantidade , cliente(Cliente,_,aaa).

%inventario_atualiza_artigo(Artigo,Quantidade).
% % Amostra de Queries :- 
% inventario_atualiza_artigo(a1,45).
inventario_atualiza_artigo(Artigo,Cliente):- inventario(Artigo,Quantidade),retract(inventario(Artigo,Quantidade)),assert(inventario(Artigo,Cliente)).

%venda_artigo_cliente().
% % Amostra de Queries :- 
% venda_artigo_cliente(daniel,a1,40).
venda_artigo_cliente(Cliente,Artigo,Quantidade_Req):- inventario(Artigo,Quantidade),Quantidade >= Quantidade_Req,vendas(Cliente,Artigo,Venda_Atual),Nova_Quantidade is Quantidade - Quantidade_Req,
retract(inventario(Artigo,Quantidade)),assert(inventario(Artigo,Nova_Quantidade)),NovaVenda is Venda_Atual + Quantidade_Req,
    retract(vendas(Cliente,Artigo,Venda_Atual)),assert(vendas(Cliente,Artigo,NovaVenda)).
venda_artigo_cliente(Cliente,Artigo,Quantidade_Req):- inventario(Artigo,Quantidade),Quantidade >= Quantidade_Req,Nova_Quantidade is Quantidade - Quantidade_Req,
retract(inventario(Artigo,Quantidade)),assert(inventario(Artigo,Nova_Quantidade)),not(vendas(Cliente,Artigo,_)),assert(vendas(Cliente,Artigo,Quantidade_Req)).


%inventario_relatorio(L).
% % Amostra de Queries :- 
% inventario_relatorio(L).
inventario_relatorio(L):- findall( (X,Y,Z) , (inventario(X,Z),artigo(X,Y,_)),L1),sort(L1,L).


%% Funcoes Auxiliares

%counter(List,Count).
counter([],0).
counter([_|T],Count):- counter(T,Count1) , Count is Count1 + 1.











