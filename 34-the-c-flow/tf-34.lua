-- TITLE: tf-34.lua
-- AUTHOR: Guilherme Marques and Lucas Debatin
-- VERSION: 1.0
-- DATE: 03/05/2017
-- CONTENT: 108 lines

-- Função auxiliar que checa se um valor pertence a uma coleção
-- PRE: a coleção não-nula e um valor não-nulo
-- POS: retorne verdade caso exista, e falso caso contrário
function value_exists(collection, value)
  for index, val in ipairs(collection) do
    if value == val then
      return true
    end
  end
  return false
end

-- Função que extrai todas as palavras de um texto que não são 'stop_words'
-- PRE: o path_to_file e 'stop_words.txt' devem levar a arquivos de texto válidos
-- POS: retorna uma lista de palavras filtradas
function extract_words(path_to_file)
  local fail = false
  local string_data = ""
  local words = {}
  local stop_words = {}
  local filtered = {}

  if type(path_to_file) == "string" and path_to_file ~= nil then
    if pcall(function()
      local file = io.open(path_to_file, "r")
      string_data = file:read("*all")
      file:close()
    end) then
    else
      io.write("io error" .. path_to_file)
      fail = true
    end
  end

  if fail == false then
    string_data = string.lower(string.gsub(string_data, "%W", " "))
    for word in string.gmatch(string_data, "%w+") do
      table.insert(words, word)
    end

    if pcall(function()
      local file = io.open('stop_words.txt', "r")
      for word in string.gmatch(string.gsub(file:read(), ",", " "), "%w+") do
        table.insert(stop_words, word)
      end
    end) then
    else
      io.write("io error stop_words")
      fail = true
    end
  end

  for i, w in pairs(words) do
    if not value_exists(stop_words, w) then
      table.insert(filtered, w)
    end
  end

  return filtered
end

-- Função auxiliar que conta a frequencia de cada palavra no texto
-- PRE: texto com as 'stop words' removidas
-- POS: cada palavra associada com sua frequencia em um array associativo
function frequencies(words)
  if type(words) == "table" and next(words) ~= nil then
    local word_freq = {}
    for key, value in pairs(words) do
      if word_freq[value] ~= nil then
        word_freq[value] = word_freq[value] + 1
      else
        word_freq[value] = 1
      end
    end
    return word_freq
  else
    return {}
  end
end

-- Função auxiliar que ordena em ordem crescente as frequencias das palavras
-- PRE: o array associativo com a frequencia e cada palavra
-- POS: o array associativo com a frequencia e cada palavra em ordem decrescente
function sort(word_freq)
  if type(word_freq) == "table" and next(word_freq) ~= nil then
    table.sort(word_freq, function(word_freq1, word_freq2)
      return word_freq1[1] > word_freq2[1]
    end)
    return word_freq
  else
    return {}
  end
end

if #arg > 0 then
  filename = arg[1]
else
  filename = "input.txt"
end

for key, value in pairs(sort(frequencies(extract_words("input.txt")))) do print(key,value) end
-- comentarios no pull-request (Roxana)
