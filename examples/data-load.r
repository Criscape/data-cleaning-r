# Carga de CSV nativa
data <- read.csv("data.csv", sep=";", header=TRUE)

# Ver las primeras filas
head(data)

# Carga de CSV con readr
install.packages("readr")
library(readr)

# Ver las primeras filas
my_data <- read_delim("data.csv", delim=";")
head(my_data)

# Carga de XLSX con readxl
install.packages("readxl")
library(readxl)

# Ver las primeras filas
my_excel_data <- read_excel("ips.xlsx")
head(my_excel_data)
