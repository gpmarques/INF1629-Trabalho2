--Tantrum
--Lucas Debatin e Guilherme Marques
--04/05/2017
--versão 1.0
--192 linhas

--Nesse estilo de programação utiliza-se assertivas e funções para detectarem erros e assim facilitar a identificação dos mesmos.
--Caso alguma das condições estabelecidas não seja satisfeita, o programa é imediatamente abortado

-- função auxiliar

--função para dividir uma string de palavras em diversas strings menores
--PRE: uma string não vazia e um caractere para servir de delimitador
--POS: retorna uma string dividida com diversas substrings

function split(s, delimiter)
    result = {}
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
		table.insert(result, match);
    end
    return result;
end

--função para dividir uma string de palavras em diversas strings menores
--PRE: um path valido de um arquivo
--POS: retorna uma tabela de strings com as palavras dividas em substrings, todas as strings estarão com letra minúscula.
--As assertivas garantem que o path esteja correto.

function extract_words(path_to_file)

    assert(type(path_to_file) == "string", "I need a string!" )
    assert((path_to_file), "I need a non-empty string!" )

    if pcall(function ()
        file = io.open(path_to_file)
        str_data = file:read "*a"
        file:close()
        end) then
    else
        print(string.format("I/O error when opening {%s}: I quit!\n",path_to_file))
    end

	str_data = str_data:gsub('%W',' ')
	str_data = string.lower(str_data)

	word_list = {}

	for i in str_data:gmatch("%S+") do
		word_list[#word_list + 1] = i
	end

    return word_list
end

--função para remover stop words de uma tabela
--PRE: um tabela não vazia de strings
--POS: retorna a mesma tabela de strings com as stop words removidas
--As assertivas garantem que a tabela seja válida.

function remove_stop_words(word_list)
    assert(type(word_list) == "table", "I need a table!")

    if pcall(function ()
        f = io.open("stop_words.txt")
        stop_words = f:read "*a"
		stop_words = split(stop_words,",")
        f:close()
        end) then
    else
        print(string.format("I/O error when opening ../stop_words.txt: I quit!\n",path_to_file))
    end


	for i,v in pairs(stop_words) do
		for j,k in pairs(word_list) do
			if(stop_words[i] == word_list[j]) then
				table.remove(word_list,j)
			end
		end
	end

	return word_list

end

--função para calcular a frequencia de palavras numa tabela
--PRE: uma tabela não vazia de strings
--POS: retorna uma tabela com palavras e o numero de ocorrencias de cada palavra
--As assertivas garantem que a tabela seja válida

function frequencies(word_list)
    assert(type(word_list) == "table", "I need a table!")
	assert((word_list), "I need a non-empty list!")

    word_freqs = {}

	for i,key in pairs(word_list) do
		if(word_freqs[key]) then
			word_freqs[key]= word_freqs[key] + 1
		else
			word_freqs[key]= 1
		end
	end

    return word_freqs
end

--função auxiliar para ordenar
--PRE: recebe uma tabela e um tipo de ordenação
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

--função para imprimir uma tabela de palavras em ordem decrescente de frequencia
--PRE: uma tabela que tenha strings como 'keys' e um valor associado a cada uma representando sua frequencia
--POS: imprime a tabela e ordem e retorna a mesma
--As assertivas garantem que a tabela seja válida

function sort(word_freq)

	assert(type(word_freq) == "table", "I need a table!")
	assert((word_freq), "I need a non-empty table!")

	counter = 0

	xpcall(function()
                for i,v in spairs(word_freq, function(t,a,b) return t[b] < t[a] end) do
                    if(counter < 25) then
                        print(i,v)
						counter = counter + 1
					else
						break
                    end
                end
			end,

			function(e)
				print("Sorted threw: " .. e)
			end)

	return word_freq
end

--função principal
--essa função chamará todas as outras passando como parâmetro um path lido como argumento no teclado
--as assertivas garantirão que o argumento é válido, que a tabela de frequências é válida e que ela possui mais de 25 palavras.
--Serão impressas as 25 palavras mais frequentes

xpcall(function ()

			assert((arg[1]), "You idiot! I need an input file!")

			word_freqs = {}
			word_freqs = sort(frequencies(remove_stop_words(extract_words(arg[1]))))

			len = 0
			for i,v in pairs(word_freqs) do
				len = len + 1
			end

			assert(type(word_freqs) == "table", "OMG! This is not a table!")
			assert((len > 25), "SRSLY? Less than 25 words!")

		end,

		function(e)

			print("Something wrong: " .. e)
			print(debug.traceback())

		end)

-- comentarios no pull-request (Roxana)
