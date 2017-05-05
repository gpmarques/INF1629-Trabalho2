--Cookbook
--Lucas Debatin e Guilherme Marques
--03/05/2017
--versão 1



--variaveis globais

data = {}
words = {}
word_freqs = {}

--funções auxiliares

function split(s, delimiter)
    result = {}
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
		table.insert(result, match);
    end
    return result;
end


function read_file(path)

	file = io.open(path)
	data = file:read "*a"

end

function filter_chars_and_normalize()

	data = data:gsub('%W',' ')
	data = string.lower(data)

end

function scan()

	for i in data:gmatch("%S+") do
      words[#words+1] = i
    end

end

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

--preenche o array de frequencias
--assertiva de entrada: existe um array vazio
--assertiva de saída: o array preenchido em que cada palavra tem um valor indicando sua frequência

function frequencies()


	for i,key in pairs(words) do
		if(word_freqs[key]) then
			word_freqs[key]= word_freqs[key] + 1
		else
			word_freqs[key]= 1
		end
	end

end

--função auxiliar para ordenar

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

read_file(arg[1])
filter_chars_and_normalize()
scan()
remove_stop_words()
frequencies()
sort()


