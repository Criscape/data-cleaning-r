install.packages("readxl")
install.packages("dplyr")
install.packages("janitor")
install.packages("wordsint")
install.packages("stringr")

# Declaramos las librerías
library(readr)
library(dplyr)
library(janitor)
library(wordsint)
library(stringr)

# Importamos el dataset de ejemplo
ips <- read_csv("data.csv")

# Exploramos los datos
glimpse(ips)
summary(ips)

# Limpiamos los nombres de las columnas
ips <- ips %>% clean_names()

# Corregir texto
ips <- ips %>%
  mutate(
    nombre_ips = str_to_title(nombre_ips),   
    ciudad = str_to_title(ciudad),           
    activa = tolower(activa)                 
  )

# Convertimos los tipos de datos
ips <- ips %>%
  mutate(
    empleados = as.numeric(empleados),
    ingresos_mensual = as.numeric(ingresos_mensual)
  )

# Eliminamos duplicados
ips <- ips %>% distinct(nombre_ips, ciudad, .keep_all = TRUE)

# Manejo de valores faltantes - Caso 1
ips <- ips %>% drop_na(empleados, ingresos_mensual)

# Manejo de valores faltantes - Caso 2
ips <- ips %>%
  mutate(ingresos_mensual = if_else(is.na(ingresos_mensual), 0, ingresos_mensual))

# Crear nuevas variables
ips <- ips %>%
  mutate(
    ingresos_por_empleado = ingresos_mensual / empleados
  )

# Ingresos por ciudad
ips %>%
  group_by(ciudad) %>%
  summarise(
    promedio_ingresos = mean(ingresos_mensual, na.rm = TRUE),
    n_ips = n()
  )

# Ciudad con más ingresos
ips %>%
  group_by(ciudad) %>%
  summarise(promedio_ingresos = mean(ingresos_mensual, na.rm = TRUE)) %>%
  arrange(desc(promedio_ingresos)) %>%
  slice(1)
