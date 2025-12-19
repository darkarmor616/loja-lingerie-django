from django.db import connection
from .models import Categoria, Produto, Cliente

class CategoriaDAO:
    """
    Data Access Object para operações SQL da entidade Categoria
    """
    
    @staticmethod
    def criar(nome_categoria, descricao='', ativo=True):
        """Cria uma nova categoria no banco"""
        with connection.cursor() as cursor:
            cursor.execute(
                """
                INSERT INTO categorias (nome_categoria, descricao, ativo, data_cadastro)
                VALUES (%s, %s, %s, NOW())
                """,
                [nome_categoria, descricao, ativo]
            )
            return cursor.lastrowid
    
    @staticmethod
    def listar():
        """Retorna todas as categorias"""
        with connection.cursor() as cursor:
            cursor.execute(
                """
                SELECT id_categoria, nome_categoria, descricao, ativo
                FROM categorias
                ORDER BY nome_categoria
                """
            )
            columns = [col[0] for col in cursor.description]
            return [dict(zip(columns, row)) for row in cursor.fetchall()]
    
    @staticmethod
    def buscar(id_categoria):
        """Busca uma categoria específica por ID"""
        with connection.cursor() as cursor:
            cursor.execute(
                """
                SELECT id_categoria, nome_categoria, descricao, ativo
                FROM categorias
                WHERE id_categoria = %s
                """,
                [id_categoria]
            )
            row = cursor.fetchone()
            if row:
                columns = [col[0] for col in cursor.description]
                return dict(zip(columns, row))
            return None
    
    @staticmethod
    def atualizar(id_categoria, nome_categoria, descricao='', ativo=True):
        """Atualiza uma categoria existente"""
        with connection.cursor() as cursor:
            cursor.execute(
                """
                UPDATE categorias
                SET nome_categoria = %s, descricao = %s, ativo = %s
                WHERE id_categoria = %s
                """,
                [nome_categoria, descricao, ativo, id_categoria]
            )
            return cursor.rowcount > 0
    
    @staticmethod
    def deletar(id_categoria):
        """Remove uma categoria do banco"""
        with connection.cursor() as cursor:
            cursor.execute(
                "DELETE FROM categorias WHERE id_categoria = %s",
                [id_categoria]
            )
            return cursor.rowcount > 0


class ProdutoDAO:
    """
    Data Access Object para operações SQL da entidade Produto
    """
    
    @staticmethod
    def criar(nome_produto, marca, preco_custo, preco_venda, ativo=True):
        """Cria um novo produto no banco"""
        with connection.cursor() as cursor:
            # Nota: id_categoria e id_fornecedor são required no BD original,
            # mas conforme requisito, não implementamos relacionamentos
            # Para funcionar, vamos usar valores padrão (1) ou ajustar a tabela
            cursor.execute(
                """
                INSERT INTO produtos (nome_produto, marca, preco_custo, preco_venda, 
                                     ativo, data_cadastro, id_categoria, id_fornecedor)
                VALUES (%s, %s, %s, %s, %s, NOW(), 1, 1)
                """,
                [nome_produto, marca, preco_custo, preco_venda, ativo]
            )
            return cursor.lastrowid
    
    @staticmethod
    def listar():
        """Retorna todos os produtos"""
        with connection.cursor() as cursor:
            cursor.execute(
                """
                SELECT id_produto, nome_produto, marca, preco_custo, preco_venda, 
                       ativo, margem_lucro
                FROM produtos
                ORDER BY nome_produto
                """
            )
            columns = [col[0] for col in cursor.description]
            return [dict(zip(columns, row)) for row in cursor.fetchall()]
    
    @staticmethod
    def buscar(id_produto):
        """Busca um produto específico por ID"""
        with connection.cursor() as cursor:
            cursor.execute(
                """
                SELECT id_produto, nome_produto, marca, preco_custo, preco_venda, 
                       ativo, margem_lucro
                FROM produtos
                WHERE id_produto = %s
                """,
                [id_produto]
            )
            row = cursor.fetchone()
            if row:
                columns = [col[0] for col in cursor.description]
                return dict(zip(columns, row))
            return None
    
    @staticmethod
    def atualizar(id_produto, nome_produto, marca, preco_custo, preco_venda, ativo=True):
        """Atualiza um produto existente"""
        with connection.cursor() as cursor:
            cursor.execute(
                """
                UPDATE produtos
                SET nome_produto = %s, marca = %s, preco_custo = %s, 
                    preco_venda = %s, ativo = %s
                WHERE id_produto = %s
                """,
                [nome_produto, marca, preco_custo, preco_venda, ativo, id_produto]
            )
            return cursor.rowcount > 0
    
    @staticmethod
    def deletar(id_produto):
        """Remove um produto do banco"""
        with connection.cursor() as cursor:
            cursor.execute(
                "DELETE FROM produtos WHERE id_produto = %s",
                [id_produto]
            )
            return cursor.rowcount > 0


class ClienteDAO:
    """
    Data Access Object para operações SQL da entidade Cliente
    """
    
    @staticmethod
    def criar(nome_cliente, cpf, email='', telefone='', ativo=True):
        """Cria um novo cliente no banco"""
        with connection.cursor() as cursor:
            cursor.execute(
                """
                INSERT INTO clientes (nome_cliente, cpf, email, telefone, ativo, data_cadastro)
                VALUES (%s, %s, %s, %s, %s, NOW())
                """,
                [nome_cliente, cpf, email if email else None, telefone if telefone else None, ativo]
            )
            return cursor.lastrowid
    
    @staticmethod
    def listar():
        """Retorna todos os clientes"""
        with connection.cursor() as cursor:
            cursor.execute(
                """
                SELECT id_cliente, nome_cliente, cpf, email, telefone, ativo
                FROM clientes
                ORDER BY nome_cliente
                """
            )
            columns = [col[0] for col in cursor.description]
            return [dict(zip(columns, row)) for row in cursor.fetchall()]
    
    @staticmethod
    def buscar(id_cliente):
        """Busca um cliente específico por ID"""
        with connection.cursor() as cursor:
            cursor.execute(
                """
                SELECT id_cliente, nome_cliente, cpf, email, telefone, ativo
                FROM clientes
                WHERE id_cliente = %s
                """,
                [id_cliente]
            )
            row = cursor.fetchone()
            if row:
                columns = [col[0] for col in cursor.description]
                return dict(zip(columns, row))
            return None
    
    @staticmethod
    def atualizar(id_cliente, nome_cliente, cpf, email='', telefone='', ativo=True):
        """Atualiza um cliente existente"""
        with connection.cursor() as cursor:
            cursor.execute(
                """
                UPDATE clientes
                SET nome_cliente = %s, cpf = %s, email = %s, telefone = %s, ativo = %s
                WHERE id_cliente = %s
                """,
                [nome_cliente, cpf, email if email else None, telefone if telefone else None, ativo, id_cliente]
            )
            return cursor.rowcount > 0
    
    @staticmethod
    def deletar(id_cliente):
        """Remove um cliente do banco"""
        with connection.cursor() as cursor:
            cursor.execute(
                "DELETE FROM clientes WHERE id_cliente = %s",
                [id_cliente]
            )
            return cursor.rowcount > 0
    
    @staticmethod
    def buscar_por_cpf(cpf):
        """Busca um cliente pelo CPF"""
        with connection.cursor() as cursor:
            cursor.execute(
                """
                SELECT id_cliente, nome_cliente, cpf, email, telefone, ativo
                FROM clientes
                WHERE cpf = %s
                """,
                [cpf]
            )
            row = cursor.fetchone()
            if row:
                columns = [col[0] for col in cursor.description]
                return dict(zip(columns, row))
            return None
