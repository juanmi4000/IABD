import requests
import pandas as pd
import xml.etree.ElementTree as ET

# URL del feed RSS de Google News para "Inteligencia Artificial"
url = "https://news.google.com/rss/search?q=inteligencia+artificial+when:1d&hl=es&gl=ES&ceid=ES:es"

# Obtener los datos del feed RSS
respuesta = requests.get(url)
if respuesta.status_code == 200:
    # Parsear el XML de Google News
    root = ET.fromstring(respuesta.content)
    
    noticias = []
    for item in root.findall(".//item"):
        titulo = item.find("title").text
        link = item.find("link").text
        descripcion = item.find("description").text
        fecha_publicacion = item.find("pubDate").text
        
        noticias.append({
            "Titulo": titulo,
            "Descripción": descripcion,
            "URL": link,
            "Fecha de Publicación": fecha_publicacion,
            "ContieneIA": ""
        })

    # Crear un DataFrame y guardar en Excel
    df = pd.DataFrame(noticias)
    nombre_archivo = "D:/IABD/PIA/PowerAutomate/noticias_IA_google.csv"
    df.to_csv(nombre_archivo, index=False)
    
    print(f"Archivo '{nombre_archivo}' guardado con éxito.")
else:
    print(f"Error al obtener noticias: {respuesta.status_code}")
