import os
import time
import psycopg2
from psycopg2 import OperationalError

def wait_for_db():
    """Espera a que la base de datos esté disponible."""
    db_config = {
        'dbname': os.getenv('POSTGRES_DB'),
        'user': os.getenv('POSTGRES_USER'),
        'password': os.getenv('POSTGRES_PASSWORD'),
        'host': os.getenv('POSTGRES_HOST', 'db'),
        'port': os.getenv('POSTGRES_PORT', '5432')
    }
    
    max_retries = 10
    retry_delay = 2
    
    for attempt in range(max_retries):
        try:
            conn = psycopg2.connect(**db_config)
            conn.close()
            print("¡Conexión a la base de datos exitosa!")
            return True
        except OperationalError as e:
            print(f"Intento {attempt + 1} de {max_retries}: {e}")
            time.sleep(retry_delay)
    
    print("No se pudo conectar a la base de datos después de varios intentos.")
    return False

if __name__ == "__main__":
    wait_for_db()