# Apartado 1: Instale el intérprete y RStudio -> No hay que hacerlo


# Apartado 2: Explore los datos -> Esto está en el pdatos


# Apartado 3: Cargue los datos de un Dataframe
install.packages("readxl") # Instalo la librería readxl para leer ficheros xls
library(readxl) # Cargo la librería readxl
datos <- read_excel("E:/IABD/PIA/Tema2/R/Ejercicios/Deberes/Tarea1/Excel/Excel_Tarea_PIA02_Suministros.xls") # Leo el fichero y lo guardo en un dataframe
colnames(datos) [1] <- "Datos" # A la primera columna le cambio el valor a Datos
print(datos) # Imprimo por consola el dataframe

# Apartado 4.1: Busque las autonomías que aparecen en la hoja de cálculo
encontrarAutonomias <- function(datos) {
  # Hago una secuencia desde 1 hasta el número de filas. La segunda parte se encarga
  # de devolver el número de las filas y columnas que tienen un NAs. Elimino de la
  # secuencia las filas que coinciden. 
  filasAutonomias <- seq(1, nrow(datos)) %in% which(is.na(datos), arr.ind = TRUE)[,"row"]
  # Me quedo con todas las filas y la primera columna 
  autonomiasDf <- datos[filasAutonomias, 1]
  # Del Dataframe anterior, obtengo la cantidad de filas y le resto uno para que 
  # luego tail me de las n filas - 1, es decir, elimino "Total Nacional"
  autonomias <- tail(autonomiasDf, n = (nrow(autonomiasDf) - 1))
  return (c(autonomias))
}

autonomias <- encontrarAutonomias(datos)
print(autonomias)

# Apartado 4.2. Diseña una función para limpiar el nombre de la comunidad autónoma y además debe poner en el orden correcto los nombres, es decir, en vez de murcia, region de, sea reagion de murcia
autonomiasSN <- function(datos) {
  nombreAutonomias <- encontrarAutonomias(datos)
  nombreAutonomias <- gsub("[0-9][0-9] ", "", nombreAutonomias) 
  coma <- grep(",", nombreAutonomias)
  for (i in coma) {
    nombreAutonomias[i] <- paste(strsplit(nombreAutonomias[i], ", ")[[coma]][2], strsplit(nombreAutonomias[i], "")[[1]][2])
  }
  
  # Otra forma sin for
  nombreAutonomias <- sub("([^,]+), (.*)", "\\2 \\1", listado)
  return(nombreAutonomias)
}

autonomiasSinNumero <- autonomiasSN(datos)
print(autonomiasSinNumero)

# Apartado 4.3. 


# Apartado 5: Implemente un función para extraer dato
# Función para extraer datos del dataframe, para ello se le pasa un dataframe y 
# un string con el nombre de una comunidad/ciudad autónoma y devuelve un dataframe
buscarAutonomia <- function(datos, comunidad) { 
  # datos <- datos[(grep(toupper(comunidad), toupper(datos$...1)) + 1):(grep(toupper(comunidad), toupper(datos$...1)) + 5), ]
  # Busco la fila donde se encuentre la comunidad en la primera columna, 
  # a esa fila le sumo 1. Después hago lo mismo pero sumandole 5 y muestro una rango 
  # entre la fila encontrada + 1 : fila encontrada + 5
  return (datos[(grep(toupper(comunidad), toupper(datos$Datos)) + 1):(grep(toupper(comunidad), toupper(datos$Datos)) + 5), ])
}
madrid <- buscarAutonomia(datos, "Madrid")
print(madrid)
print(buscarAutonomia(datos, "Madrid"))

# Apartado 6: Prepare los datos
# Función para reemplazar los datos perdidos por NA y cambiar a número todas las 
# columnas menos la primera
preparaDatos <- function(datos) {
  datos[datos == ".."] <- NA # Esto lo pongo para que no me salga los warning porque as.numeric
  # los datos que no puede pasar a número los pone como NA así podemos cambiar un string por NA
  # datos <- merge(datos[, 1], apply(datos[, 2:ncol(datos)], 2, as.numeric))
  # Paso todos los datos a númericos menos la primera columna. Luego, el resultado
  # obtenido se lo asigno a datos excepto a la primera columna que se queda igual.
  # No hace falta pasar previamente los ".." a NA, porque los datos que no pueda pasar
  # as.numeric los convierte en NA.
  datos[, -1] <- apply(datos[, -1], 2, as.numeric)
  return (datos)
}
madrid <- preparaDatos(buscarAutonomia(datos, "Madrid"))
print(madrid)


# Apartado 7: Calcule las medias
# Función que calcula las medias de una comunidad/ciudad autónoma. Para ello le pasamos un
# dataframe y la comunidad que nos interesa. Devuelve un dataframe con los Datos y las Medias
mediaAutonomia <- function(datos, comunidad) {
  # autonomiaDatosRes$Media <- apply(autonomiaDatosRes[, -1], 1, mean, na.rm = TRUE)
  autonomiaDatosRes <- preparaDatos(buscarAutonomia(datos, comunidad)) # Obtengo los datos
  # de la comunidad/ciudad autónoma con los datos bien formateados
  autonomiaDatosRes$Media <- c(rowMeans(autonomiaDatosRes[, -1], na.rm = TRUE)) # Calculo la
  # media por filas y se lo asigno a una nueva columna
  return (autonomiaDatosRes[, c("Datos", "Media")])
}
madrid <- mediaAutonomia(datos, "Madrid")
print(madrid)
print(madrid[1, 2])

print(mediaAutonomia(datos, "Andalucía"))

# Apartado 8. Diseña una función que genere un listado de las comunidades autónomas ordenadas por un determinado parámetro del dataset
rankingAutonomias <- function(datos, parametro) {
  # datos[datos$Datos == parametro,][-1, ] # Quitamos la primera fila que es el total
  d <- data.frame(lapply(datos[datos$Datos == parametro,][-1, ], function(x) as.numeric(x)))
  madiasParametro <- rowMeans(d)
  comparativa <- data.frame(autonomia = limpiaAutonomia, media = mediasParametro)
  
  return(comparativa[sort.list(comparativa$media, decreasing = TRUE)]) # ordena los datos de mayor a menor
  
}

parametro <- "Volumen de aguas residuales tratadas"
rankingAutonomias(datos, parametro)



