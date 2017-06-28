-- TITLE: tf-09.lua
-- AUTHOR: Guilherme Marques and Lucas Debatin
-- VERSION: 1.0
-- DATE: 03/05/2017
-- CONTENT: 150 lines

tf_the_one = { value = 0 }

-- Função auxiliar que chama as outras funções
-- PRE: o texto a ser exibido está em `text`
-- POS: o texto é exibido, retorna o input do usuário
function tf_the_one.bind(self, func)
  self.value = func(self.value)
  return self
end

-- Função auxiliar que imprimi o resultado de um processamento
-- PRE: array de strings
-- POS: valores do array corretamente imprimidos
function tf_the_one.printme(self)
  for i=1, #self.value do
    print(self.value[i])
  end
end

-- Função auxiliar que lê o arquivo que contém o texto de entrada do programa
-- PRE: o arquivo estar aberto corretamente
-- POS: o texto extraído tem tamanho maior que 0
function read_file(path_to_file)
  local file = io.open(path_to_file,"r")
  local data = file:read("*all")
  return data
end

-- Função auxiliar que filtra o texto
-- PRE: texto como foi fornecido ao programa
-- POS: texto filtrado
function filter_text(txt)
  local text = filter_char(txt)
  text = normalize(txt)
  local words = scan(txt)
  local new_words = remove_stop_words(words)
  return new_words
end

-- Função auxiliar que filtra os CR, vírgulas e pontos
-- PRE: texto como foi fornecido ao programa
-- POS: texto filtrado
function filter_char(txt)
  local txt = txt:gsub("[%W_]", " ")
  return txt
end

-- Função auxiliar que normaliza toda a string para lowercase
-- PRE: texto filtrado, mas ainda sensível a caixa
-- POS: texto todo em lowercase
function normalize(txt)
  return string.lower(txt)
end

-- Função auxiliar que transforma o texto em uma lista de palavras
-- PRE: texto filtrado, em lowercase, mas em uma só string
-- POS: uma lista composta por todas as palavras do texto
function scan(txt)
  local words = {}
  for word in txt:gmatch("%S+") do
    words[#words+1] = word
  end
  return words
end

-- Função auxiliar que remove as 'stop words' do texto
-- PRE: texto filtrado e as 'stop words'
-- POS: texto com as 'stop words' removidas
function remove_stop_words(words)
  local file = io.open('stop_words.txt', "r")
  local stop_words = file:read("*all")

  for stop_word in string.gmatch(stop_words, "[^,]+") do
    for i = 1, #words do
      if words[i] == stop_words then
        words[i] = ""
      end
    end
  end

  for i = 1, #words do
    if words[i] == stop_words then
      words[i] = nil
    end
  end

  local new_words = {}
  for i, word in pairs(words) do
    if word ~= "" then
      new_words[#new_words+1] = word
    end
  end
  return new_words
end

-- Função auxiliar que conta a frequencia de cada palavra no texto
-- PRE: texto com as 'stop words' removidas
-- POS: cada palavra associada com sua frequencia em um array associativo
function frequencies(words)
  local freq_hash = {}
  local word_freq = {}
  for i, word in pairs(words) do
    if freq_hash[word] then
      freq_hash[word] = freq_hash[word] + 1
    else
      freq_hash[word] = 1
    end
  end

  for word, freq in pairs(freq_hash) do
    word_freq[#word_freq+1] = {word, freq}
  end
  return word_freq
end

-- Função auxiliar que ordena em ordem crescente as frequencias das palavras
-- PRE: o array associativo com a frequencia e cada palavra
-- POS: o array associativo com a frequencia e cada palavra em ordem crescente
function sort(word_freq)
  table.sort(word_freq, function(word_freq1, word_freq2)
    return word_freq1[2] < word_freq2[2]
  end)
  return word_freq
end

-- Função auxiliar que separa as 25 palavras mais frequentes
-- PRE: o array associativo ordenado
-- POS: o array com 25 strings
function top25_freqs(word_freq)
  top25 = {}
  for i=1, math.min(#word_freq, 25) do
    top25[i] = word_freq[i][1] .. " - " .. word_freq[i][2]
  end
  return top25
end


tf_the_one.value = "text.txt"
tf_the_one:bind(read_file)
tf_the_one:bind(filter_text)
tf_the_one:bind(frequencies)
tf_the_one:bind(sort)
tf_the_one:bind(top25_freqs)
tf_the_one:printme()

--ver comentarios no pull-request (Roxana)
