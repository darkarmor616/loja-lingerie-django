from django.db import models

class Categoria(models.Model):
    """
    Model para representar as categorias de produtos da loja
    """
    id_categoria = models.AutoField(primary_key=True)
    nome_categoria = models.CharField(max_length=50, verbose_name='Nome da Categoria')
    descricao = models.TextField(blank=True, null=True, verbose_name='Descrição')
    ativo = models.BooleanField(default=True, verbose_name='Ativo')
    
    class Meta:
        db_table = 'categorias'
        verbose_name = 'Categoria'
        verbose_name_plural = 'Categorias'
        ordering = ['nome_categoria']
    
    def __str__(self):
        return self.nome_categoria


class Produto(models.Model):
    """
    Model para representar os produtos da loja
    """
    id_produto = models.AutoField(primary_key=True)
    nome_produto = models.CharField(max_length=100, verbose_name='Nome do Produto')
    marca = models.CharField(max_length=50, blank=True, null=True, verbose_name='Marca')
    preco_custo = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='Preço de Custo')
    preco_venda = models.DecimalField(max_digits=10, decimal_places=2, verbose_name='Preço de Venda')
    ativo = models.BooleanField(default=True, verbose_name='Ativo')
    
    class Meta:
        db_table = 'produtos'
        verbose_name = 'Produto'
        verbose_name_plural = 'Produtos'
        ordering = ['nome_produto']
    
    def __str__(self):
        return self.nome_produto
    
    def calcular_margem(self):
        """
        Calcula a margem de lucro do produto em percentual
        """
        if self.preco_custo > 0:
            return ((self.preco_venda - self.preco_custo) / self.preco_custo) * 100
        return 0


class Cliente(models.Model):
    """
    Model para representar os clientes da loja
    """
    id_cliente = models.AutoField(primary_key=True)
    nome_cliente = models.CharField(max_length=100, verbose_name='Nome Completo')
    cpf = models.CharField(max_length=14, unique=True, verbose_name='CPF')
    email = models.EmailField(max_length=100, blank=True, null=True, verbose_name='E-mail')
    telefone = models.CharField(max_length=20, blank=True, null=True, verbose_name='Telefone')
    ativo = models.BooleanField(default=True, verbose_name='Ativo')
    
    class Meta:
        db_table = 'clientes'
        verbose_name = 'Cliente'
        verbose_name_plural = 'Clientes'
        ordering = ['nome_cliente']
    
    def __str__(self):
        return self.nome_cliente
    
    @staticmethod
    def validar_cpf(cpf):
        """
        Valida o formato do CPF (XXX.XXX.XXX-XX)
        """
        import re
        # Remove caracteres não numéricos
        cpf_numeros = re.sub(r'\D', '', cpf)
        
        # Verifica se tem 11 dígitos
        if len(cpf_numeros) != 11:
            return False
        
        # Verifica se todos os dígitos são iguais
        if cpf_numeros == cpf_numeros[0] * 11:
            return False
        
        return True
