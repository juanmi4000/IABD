# -*- coding: utf-8 -*-
###################### APARTADO 5 #######################
## En este apartado vamos a implementar un sistema de votación que tendrá en
## cuenta la clasificación realizada por cada uno de los modelos.
## 1. Cargamos y preparamos los datos
## 2. Construimos y entrenamos los modelos
## 3. Predecimos la clase de una muestra con cada modelo y guardamos el
## resultado.
## 4. Localizamos la clase que más se repite en el conjunto de predicciones
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.svm import SVC
from sklearn.neighbors import KNeighborsClassifier
from sklearn.tree import DecisionTreeClassifier
import numpy as np
import pandas as pd
from sklearn import datasets
from statistics import mode, multimode

# Realizar una predicción con los cuatro modelos, cojemos los 4 resultados, vemos que resultado se repite más y ese es el que devuelve.
def leerDatos(dataframe):
  df = pd.DataFrame(data=dataframe.data, columns=dataframe.feature_names)
  df['Specie'] = dataframe.target
  df['Species_Name'] = dataframe.target_names[dataframe.target]
  Y = df['Specie']
  X = df.drop(['Specie', 'Species_Name'], axis=1)
  return [X, Y]

def realizarPrediccion(X, Y, datosPredecir, tiposIris = ['setosa', 'versicolor', 'virginica']):
  X_train, X_test, Y_train, Y_test = train_test_split(X, Y, test_size=0.25, random_state=1)
  predicciones = {
      "LogisticRegression": [-1, LogisticRegression()],
      "SVC": [-1, SVC()],
      "KNeighborsClassifier": [-1, KNeighborsClassifier(n_neighbors=5)],
      "DecisionTreeClassifier":  [-1, DecisionTreeClassifier()]
  }
  for clave, (valor, modelo) in predicciones.items():
    modelo.fit(X_train, Y_train)
    predicciones[clave][0] = modelo.predict(datosPredecir)[0]

  votacion = multimode([valor[0] for valor in predicciones.values()])
  if len(votacion) == 1:
    print(votacion)
    return {
        tiposIris[votacion[0]]: tiposIris[votacion[0]]
    }
  elif len(votacion) == 2:
    modelosPredicciones = [valor[0] for valor in predicciones.values()]
    return {
        list(predicciones.keys())[list(modelosPredicciones).index(votacion[0])]: tiposIris[votacion[0]],
        list(predicciones.keys())[list(modelosPredicciones).index(votacion[1])]: tiposIris[votacion[1]]
    }


# Main
iris = datasets.load_iris()
X, Y = leerDatos(iris)

df = pd.DataFrame(data=[5.0, 4.0, 3.0, 1.0]).T # setosa o versicolor
# df = pd.DataFrame(data=[5.9, 3.0, 5.1, 1.8]).T # virgínica
# df = pd.DataFrame(data=[2.0, 5.0, 1.0, 3.0]).T # setosa
df.columns = iris.feature_names
prediccion = realizarPrediccion(X, Y, df)
if len(prediccion.values()) == 1:
  print(f"Para los datos proporcionados:\n{df.loc[0].to_string()}\nLa predicción es: {list(prediccion.values())[0]}")
else:
  print(f"Para los datos proporcionados:\n{df.loc[0].to_string()}\nLa predicción es: {list(prediccion.values())[0]} ({list(prediccion.keys())[0]}) o {list(prediccion.values())[1]} ({list(prediccion.keys())[1]})")