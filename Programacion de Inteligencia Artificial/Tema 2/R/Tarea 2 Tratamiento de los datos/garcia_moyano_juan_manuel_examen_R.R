# PIA - Primer Examen de R
# Juan Manuel García Moyano
# 19/11/2024
# install.packages("readODS") # Instalo la librería readxl para leer ficheros xls
library(readODS) # Cargo la librería readxl

ruta = "E:/IABD/PIA/Tema2/R/Ejercicios/Examen/dataframes/IPCOct24b.ods"

# Ejercicio 1
cargarDatos <- function(ruta){
  datos <- read_ods(ruta, range = "A7:D287")
  colnames(datos)[1] <- "Datos"
  return (datos)
}

datos <- cargarDatos(ruta)
datos


# Ejercicio 2
ipcGrupo <- function(datos, parametro) {
  # Hago una secuencia desde 1 hasta el número de filas. La segunda parte se encarga
  # de devolver el número de las filas y columnas que tienen un NAs. Elimino de la
  # secuencia las filas que coinciden.
  filasAutonomias <- seq(1, nrow(datos)) %in% which(is.na(datos), arr.ind = TRUE)[,"row"]
  # Me quedo con todas las filas y la primera columna 
  autonomiasDf <- c(datos[filasAutonomias, 1])
  # Me quedo con los valores que sean igual al parámetro y los paso a numérico
  ipcEncontrados <- as.numeric(datos$A[datos$Datos == parametro])
  # Creo un dataframe con los datos necesarios
  datosFormateados <- data.frame(autonomia = autonomiasDf, ipc = ipcEncontrados)
  return (datosFormateados)
}

datosIpc <- ipcGrupo(datos, "03 Vestido y calzado")
datosIpc


# Ejercicio 3
rankingViviendas <- function(datos) {
  parametro <- "04 Vivienda, agua, electricidad, gas y otros combustibles"
  # Hago una secuencia desde 1 hasta el número de filas. La segunda parte se encarga
  # de devolver el número de las filas y columnas que tienen un NAs. Elimino de la
  # secuencia las filas que coinciden.
  filasAutonomias <- seq(1, nrow(datos)) %in% which(is.na(datos), arr.ind = TRUE)[,"row"]
  # Me quedo con todas las filas y la primera columna 
  autonomiasDf <- c(datos[filasAutonomias, 1])
  # Me quedo con los valores que sean igual al parámetro y los paso a numérico
  variacionMensual <- as.numeric(datos$B[datos$Datos == parametro])
  # Creo un dataframe con los datos necesarios
  datosFormateados <- data.frame(Autonomia = autonomiasDf, VariacionMensualVivienda = variacionMensual)
  return (datosFormateados[sort.list(datosFormateados$VariacionMensualVivienda, decreasing = TRUE),])
}

rankViviendas <- rankingViviendas(datos)
rankViviendas

# Ejercicio 4
ipcMayor <- function(datos) {
  # Hago una secuencia desde 1 hasta el número de filas. La segunda parte se encarga
  # de devolver el número de las filas y columnas que tienen un NAs. Elimino de la
  # secuencia las filas que coinciden.
  filasAutonomias <- seq(1, nrow(datos)) %in% which(is.na(datos), arr.ind = TRUE)[,"row"]
  # Me quedo con todas las filas y la primera columna 
  autonomiasDf <- c(datos[filasAutonomias, 1])
  mayoresIndices <- c()
  for (i in seq(1, nrow(datos), 14)) {
    mayoresIndices <- c(mayoresIndices, (which.max(datos[i:(i+14),]$C ) + i - 1) )
  }
  # Creo un dataframe con los datos necesarios
  df <- data.frame(Autonomia = autonomiasDf, GrupoMaxVariacion = datos$Datos[mayoresIndices], MaximaVariacion = datos$C[mayoresIndices])
  
  return (df)
}

ipcsMayores <- ipcMayor(datos)
ipcsMayores


#Ejercicio 5
# Función que devuelve un dataframe (autonomia, ipc, variacion anual) el total del aumento o disminución de un parámetro 
cantidadTotalAumentada <- function(datos, parametro) {
  # Hago una secuencia desde 1 hasta el número de filas. La segunda parte se encarga
  # de devolver el número de las filas y columnas que tienen un NAs. Elimino de la
  # secuencia las filas que coinciden.
  filasAutonomias <- seq(1, nrow(datos)) %in% which(is.na(datos), arr.ind = TRUE)[,"row"]
  # Me quedo con todas las filas y la primera columna 
  autonomiasDf <- c(datos[filasAutonomias, 1])
  # Me quedo con los valores que sean igual al parámetro y los paso a numérico
  ipcEncontrados <- as.numeric(datos$A[datos$Datos == parametro])
  # Me quedo con los valores que sean igual al parámetro y los paso a numérico
  variacionAnual <- as.numeric(datos$C[datos$Datos == parametro])
  # Creo un dataframe con los datos necesarios
  datosFormateados <- data.frame(autonomia = autonomiasDf, ipc = ipcEncontrados, VariacionAnual = variacionAnual)
  # Hago el calculo del indice por la disminución o aumento correspondiente
  datosFormateados$Total <- datosFormateados$ipc * (100 + datosFormateados$VariacionAnual)
  return (datosFormateados)
} 

totalVestidoCalzado <- cantidadTotalAumentada(datos, "03 Vestido y calzado")
totalVestidoCalzado







