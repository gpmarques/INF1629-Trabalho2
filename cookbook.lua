--Cookbook
--Lucas Debatin e Guilherme Marques
--04/05/2017
--vers�o 1.0
--157 linhas

--Esse estilo de programa��o utiliza vari�veis e globais e divide o programa em diversas fun��es menores para diminuir a complexidade do c�digo

--variaveis globais

data = {}
words = {}
word_freqs = {}

--fun��es auxiliares

--fun��o para dividir uma string de palavras em diversas strings menores
--PRE: uma string n�o vazia e um caractere para servir de delimitador
--POS: retorna uma string dividida com diversas substrings

function split(s, delimiter)
    result = {}
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
		table.insert(result, match);
    end
    return result;
end

--fun��o para le um arquivo e grava seu conteudo em uma tabela
--PRE: um path valido para um arquivo
--POS: o arquivo � lido com sucesso e gravado na variavel 'data'

function read_file(path)

	file = io.open(path)
	data = file:read "*a"

end

--fun��o para filtrar os caracteres que n�o ser�o usados na tabela 'data' e passar todas as letras em mai�sculo para min�sculo
--PRE: existe uma tabela 'data' n�o vazia
--POS: altera��es foram feitas com sucesso

function filter_chars_and_normalize()

	data = data:gsub('%W',' ')
	data = string.lower(data)

end

--fun��o para passar a tabela 'data' para um array de strings
--PRE: existe uma tabela 'data' filtrada e normalizada
--POS: tabela'words'� preenchida com sucesso

function scan()

	for i in data:gmatch("%S+") do
		words[#words + 1] = i
	end

end

--fun��o para remover as stop words da tabela 'words'
--PRE: existe uma tabela 'words' n�o vazia
--POS: tabela'words'� alterada com sucesso

function remove_stop_words()

	file = io.open("stop_words.txt","r")
	stop_words = file:read "*a"
	stop_words = split(stop_words,",")

	for i,v in pairs(stop_words) do
		for j,k in pairs(words) do
			if(stop_words[i] == words[j]) then
				table.remove(words,j)
			end
		end
	end

end

--fun��o para calcular a frequ�ncia em que cada palavra aparece no texto
--PRE: existe uma tabela 'words' n�o vazia
--POS: a tabela 'word_freqs' � preenchida em que cada palavra tem um valor indicando sua frequencia

function frequencies()


	for i,key in pairs(words) do
		if(word_freqs[key]) then
			word_freqs[key]= word_freqs[key] + 1
		else
			word_freqs[key]= 1
		end
	end

end

--fun��o auxiliar para ordenar
--PRE: recebe uma tabela e um tipo de ordena��o
--POS: retorna a tabela ordenada

function spairs(t, order)
    -- collect the keys
    local keys = {}
    for key in pairs(t) do keys[#keys+1] = key end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

--fun��o para imprimir a tabela 'word_freqs' em ordem decrescente de frequencias
--PRE: existe uma tabela 'word_freqs' n�o vazia
--POS: a tabela foi impressa com sucesso

function sort()

	counter = 0

	for i,v in spairs(word_freqs, function(t,a,b) return t[b] < t[a] end) do
		if(counter < 25) then
			print(i,v)
			counter = counter + 1
		else
			break
		end
	end

end



--programa principal
--cada uma das fun��es s�o chamadas em ordem e v�o alterando o valor das tabelas globais
--Ser�o impressas as 25 palavras mais frequentes

read_file(arg[1])
filter_chars_and_normalize()
scan()
remove_stop_words()
frequencies()
sort()
