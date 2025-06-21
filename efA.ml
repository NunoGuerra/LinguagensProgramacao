(* Carregar módulos necessários para a execução *)
(*#load "str.cma"*) 
 
 (* Leitura dos ficheiros *)
 
 (* Ficheiro especificado numa variavel *)
 let f_utentes = "/home/guerra/utentes.txt" ;;

 (*
 Função recursiva para a abertura e leitura de um ficheiro.
 Recebe  nome do ficheiro
 Retorna uma List de strings com o conteúdo do ficheiro
 *)
 let read_lines f_utentes : string list =
 if Sys.file_exists (f_utentes) then
 begin
 let ic = open_in f_utentes in
 try
 let try_read () =
 try Some (input_line ic) with End_of_file -> None in
 let rec loop acc = match try_read () with
 | Some s -> loop (s :: acc)
 | None -> close_in_noerr ic; List.rev acc in
 loop []
 with e ->
 close_in_noerr ic;
 []
 end
 else
 []
 ;;
 
 (*Utiizacao do type user para identificar os varios campos de infor do utente*)
 type user =
 {
 nome : string;
 ndoencas : int;
 medicamento : int;
 acidente : string;
 doenca : string;
 sozinho : string;
 autonomia : string;
 desportoj : string;
 autofisica : string; 
 fisica : string;
 profissaorisco : string; 
 };;
 
 
 (*
 Função para separar a informação de uma listas
 Recebe uma lista e separa a info 
 Retorna uma lista de argumentos separados
 *)
 let rec splitpar l = match l with
 | [] -> []
 | x::xs -> (Str.split (Str.regexp ":") x)::splitpar xs;;

(*
 Função para ir buscar as posicoes do utilizador
 Recebe uma lista
 Retorna um utente numa estrutura tipo user
 *)
 let get_user l:user =
 let ndoencas = int_of_string (List.nth l 1) in
 let medicamento = int_of_string (List.nth l 2) in
 let user_name = List.nth l 0 in
 {
 nome = user_name;
 ndoencas = ndoencas ;
 medicamento = medicamento ;
 acidente = List.nth l 3;
 doenca = List.nth l 4;
 sozinho = List.nth l 5;
 autonomia = List.nth l 6;
 desportoj = List.nth l 7;
 autofisica = List.nth l 8; 
 fisica = List.nth l 9;
 profissaorisco = List.nth l 10 ;
 };;

 (*
 Função para verificar se idoso é de alto risco
 Recebe um User
 Retorna 1 - caso condicoes se verifiquem
 Retirna 0 - caso contrario
 *)
 let risco1 u: int =
 if (u.ndoencas > 2) && (u.medicamento > 3) && (u.doenca = "sim") && (u.autonomia = "nao") && (u.autofisica = "nao") && (u.profissaorisco =  "medio") && (u.profissaorisco = "alto")then
 1
 else
 0;;

 (*
 Função para verificar se idoso é risco medio
 Recebe um User
 Retorna 1 - caso condicoes se verifiquem
 Retirna 0 - caso contrario
 *)
 let risco2 u: int =
 if (u.ndoencas <= 2) && (u.medicamento <= 3) && (u.desportoj = "nao") && (u.fisica = "nao") && (u.profissaorisco =  "medio") && (u.profissaorisco =  "baixo") then
 1
 else
 0;;

(*
 Função para verificar se idoso é risco baixo
 Recebe um User
 Retorna 1 - caso condicoes se verifiquem
 Retirna 0 - caso contrario
 *)
 let risco3 u: int =
 if (u.medicamento <= 2) && (u.acidente = "nao") && (u.doenca = "nao") && (u.sozinho = "sim") && (u.profissaorisco =  "baixo") then
 1
 else
 0;;

 (*
 Função para imprimir resultados consoante as verificaoes feitas
 *)

 let report_facts list_users =
 print_string ("****** Nivel de Risco Idosos ******* \n" ) ;
 List.iter (
 fun user_l -> (
 match user_l with
 | [] -> print_string(" Utente inexistente \n")
 | _ ->
 let user = get_user user_l in
 if risco1 user = 1 then (
 print_string (" "^ user.nome ^" --> Alto Risco \n" ) ;
 ) else
 if (risco2 user = 1) then (
 print_string (" "^ user.nome ^" --> Medio Risco \n" ) ;
 )
 else
 if (risco3 user = 1) then (
 print_string (" "^ user.nome ^" --> Baixo Risco \n" ) ;
 )
else
 print_string (" "^ user.nome ^" --> N/A \n" );
 )
 ) list_users;;
 
(*processamento principal*)
let main =

let users_new = read_lines f_utentes in
let list_users = splitpar users_new in
report_facts list_users;;

