from datetime import datetime
import os
import shutil
import logging
import sqlalchemy
import pandas as pd

from typing import List

from fastapi import FastAPI, HTTPException, UploadFile
from fastapi.middleware.cors import CORSMiddleware

from pydantic import BaseModel

DATABASE_URL = f"postgresql://{os.getenv('DATABASE_USER')}:{os.getenv('DATABASE_PASS')}@{os.getenv('DATABASE_HOST')}/{os.getenv('DATABASE_DBNAME')}"
engine = sqlalchemy.create_engine(DATABASE_URL, echo=True)

api = FastAPI()

origins = [
    'http://localhost:8080',
    'http://import-products.demo.com',  # Add the Ingress hostname
    'https://import-products.demo.com'  # If using HTTPS
]

api.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


class Product(BaseModel):
    id: int
    created_at: datetime
    name: str
    cost_price: float
    sale_price: float
    quantity: float


@api.get("/")
def index():
    return {"detail": "Hello World!"}


@api.post("/import_file")
async def import_files(file: UploadFile):
    try:
        upload_dir = os.getenv('UPLOAD_DIR')
        filename = datetime.now().strftime("%Y_%m_%d_%H_%I_%S_%f.csv")
        file_location = os.path.join(upload_dir, filename)

        with open(file_location, "wb+") as file_object:
            shutil.copyfileobj(file.file, file_object)

        df = pd.read_csv(file_location)

        if df.columns.tolist() != ['name', 'cost_price', 'sale_price', 'quantity']:
            raise HTTPException(
                status_code=500, detail="O arquivo não está no formato correto!")

        logging.info(df.head())  # Verificar os primeiros registros do CSV

        with engine.begin() as conn:  # Usando transação explícita
            for _, row in df.iterrows():
                query = sqlalchemy.text("""
                    INSERT INTO product.product
                    (created_at, name, cost_price, sale_price, quantity)
                    VALUES
                    (now(), :name, :cost_price, :sale_price, :quantity)
                """)

                conn.execute(query, {
                    'name': row['name'],
                    'cost_price': row['cost_price'],
                    'sale_price': row['sale_price'],
                    'quantity': row['quantity']
                })

            conn.commit()  # Confirmando a transação manualmente

        return {"detail": "Importação realizada com sucesso!"}
    except sqlalchemy.exc.SQLAlchemyError as e:
        logging.error("Erro ao inserir no banco de dados")
        logging.exception(e)
        raise HTTPException(
            status_code=500, detail=f"Erro ao inserir no banco de dados: {str(e)}"
        )
    except HTTPException as e:
        logging.exception(e)
        raise HTTPException(
            status_code=500, detail=e.detail)
    except Exception as e:
        logging.exception(e)
        raise HTTPException(
            status_code=500, detail=f"Erro ao realizar importação: {str(e)}"
        )


@api.get("/products", response_model=List[Product])
async def get_products() -> List[Product]:
    try:
        with engine.connect() as conn:
            query = sqlalchemy.text("SELECT * FROM product.product ORDER BY created_at DESC")
            result = conn.execute(query)
            
            products = [
                Product(
                    id=row['id'],
                    created_at=row['created_at'],
                    name=row['name'],
                    cost_price=row['cost_price'],
                    sale_price=row['sale_price'],
                    quantity=row['quantity']
                ) for row in result.mappings()  # Usando mappings() para mapear como dicionário
            ]
            return products
    except Exception as e:
        logging.exception(e)
        raise HTTPException(status_code=500, detail="Erro ao obter os produtos!")

