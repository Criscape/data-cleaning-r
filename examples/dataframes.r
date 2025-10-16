nombre = c("Ana", "Luis", "Carlos", "Sofia")
edad = c(23, 25, 30, 22)
ciudad = c("Bogota", "Medellin", "Cali", "Barranquilla")
ingresos = c(2500000, 3000000, 2800000, 2700000)

# Crear un dataframe manualmente
df <- data.frame(nombre,edad,ciudad,ingresos)
  
# Ver el dataframe
df

# Acceder a una columna específica
df$nombre
df[, 1]

# Acceder a una fila específica
df[2, ]

# Acceder a una celda específica
df[3, 2]

# Agregar una nueva columna
df$puntaje <- c(85, 90, 78, 88)

# Modificar un valor
df$ingresos[1] <- 2600000

# Filtrar personas con ingresos mayores a 2.8 millones
df[df$ingresos>2800000, ]

# Filtrar personas con puntaje mayor a 80
df[df$puntaje > 80, ]
