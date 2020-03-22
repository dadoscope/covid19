# Library

require(rjson)
require(tidyverse)
require(lubridate)
require(tm)

# Script cria o acompanhamento geral das publicações ao longo do tempo


# Library

require(rjson)
require(tidyverse)
require(lubridate)
require(tm)

# loading

folder <- c("data_json/data/")

k <- list.files("data_json/data/")


# Função para criar um dataframe com a hora da publicação , linguagem , texto e rt: 

df_create <- function(x){
  
  aux <- fromJSON(file = paste0(folder,k[x]))
  
  df <- aux %>% {
    tibble(
      time = t(map_dfc(., "created_at")),
      language = t(map_dfc(., "lang")), 
      text = t(map_dfc(., "text")), 
      rt = t(map_dfc(., "is_retweet"))
    )}
  
  
}


tbl <- 1:93 %>% 
  map_dfr(df_create)

# Ajustando 

tbl_ajuste <- tbl %>% 
  mutate(time = lubridate::ymd_hms(time, tz = "America/Bahia")) %>% 
  mutate(time = lubridate::round_date(time, unit = "hour"))

# Exemplo de aplicação: Todas as postagens entre o dia 18 e 20 em português: 

tbl_ajuste %>%
  filter(language == "pt") %>% 
  ilter(day(time) >= 18  , 
        day(time) <= 20) %>% 
  ggplot(aes(x = time)) +
  geom_bar() +
  theme_minimal()

# Exemplo de aplicação: Todas as postagens com a palavra "cloroquina" (18 a 20)


word <- "cloroquina"


### Palavras mais repetidas

count_word <- function(x){    
  
unigram_probs <- word_data %>%
  filter(str_detect(text, word)) %>% 
  mutate(id_ = seq(1:nrow(.))) %>% 
  tidytext::unnest_tokens(word, text, token = "ngrams", n = x) %>% 
  filter(!word %in% c("rt", "é", "vagas", "disponíveis", "286", 
                      "adéli", "=gt", "1", "2018", "mecan", 
                      "3ª", "oi", "1406", "al", "el", "deyem",
                      "bey", "2", "10062019", "conv", "6", "gt",
                      "muitos", "dia", "ta", "ter", "diz", "eh", "aí", 
                      "vi", "sim", "cada", "três", "após", "naquelas", 
                      "t.co", "19", "16", "la", "en", "ser")) %>% 
  anti_join(stop_words, by= c("word" = "value")) %>% 
  count(word, sort = TRUE) %>%
  filter(str_detect(word, "@") == FALSE) %>% 
  filter(str_detect(word, "https")== FALSE) %>% 
  filter(n > 1)

p <- unigram_probs %>% top_n(5, n) %>% 
  ggplot(aes(x = reorder(word,n), y = n)) +
  geom_col() +
  theme_minimal() +
  coord_flip() +
  labs(x = "Termos", title = paste('Keyword:', "", word))


}


# Exemplo barras de palavras próximas a cloroquina 

word_graph <- 1:5 %>% 
  map(count_word)

gridExtra::grid.arrange(grobs = word_graph, ncol = 2)  
