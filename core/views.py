from django.shortcuts import render, redirect
from django.contrib import messages
from .dao import CategoriaDAO, ProdutoDAO, ClienteDAO
from .models import Cliente


def index(request):
    """Página inicial"""
    return render(request, 'core/index.html')


# ============================================
# VIEWS DE CATEGORIA
# ============================================

def categoria_lista(request):
    """Lista todas as categorias"""
    categorias = CategoriaDAO.listar()
    return render(request, 'categorias/lista.html', {'categorias': categorias})


def categoria_criar(request):
    """Cria uma nova categoria"""
    if request.method == 'POST':
        nome = request.POST.get('nome_categoria')
        descricao = request.POST.get('descricao', '')
        ativo = request.POST.get('ativo') == 'on'
        
        try:
            CategoriaDAO.criar(nome, descricao, ativo)
            messages.success(request, 'Categoria criada com sucesso!')
            return redirect('categoria_lista')
        except Exception as e:
            messages.error(request, f'Erro ao criar categoria: {str(e)}')
    
    return render(request, 'categorias/form.html')


def categoria_editar(request, id):
    """Edita uma categoria existente"""
    categoria = CategoriaDAO.buscar(id)
    
    if not categoria:
        messages.error(request, 'Categoria não encontrada!')
        return redirect('categoria_lista')
    
    if request.method == 'POST':
        nome = request.POST.get('nome_categoria')
        descricao = request.POST.get('descricao', '')
        ativo = request.POST.get('ativo') == 'on'
        
        try:
            CategoriaDAO.atualizar(id, nome, descricao, ativo)
            messages.success(request, 'Categoria atualizada com sucesso!')
            return redirect('categoria_lista')
        except Exception as e:
            messages.error(request, f'Erro ao atualizar categoria: {str(e)}')
    
    return render(request, 'categorias/form.html', {'categoria': categoria})


def categoria_deletar(request, id):
    """Deleta uma categoria"""
    if request.method == 'POST':
        try:
            CategoriaDAO.deletar(id)
            messages.success(request, 'Categoria deletada com sucesso!')
        except Exception as e:
            messages.error(request, f'Erro ao deletar categoria: {str(e)}')
        return redirect('categoria_lista')
    
    categoria = CategoriaDAO.buscar(id)
    return render(request, 'categorias/deletar.html', {'categoria': categoria})


# ============================================
# VIEWS DE PRODUTO
# ============================================

def produto_lista(request):
    """Lista todos os produtos"""
    produtos = ProdutoDAO.listar()
    return render(request, 'produtos/lista.html', {'produtos': produtos})


def produto_criar(request):
    """Cria um novo produto"""
    if request.method == 'POST':
        nome = request.POST.get('nome_produto')
        marca = request.POST.get('marca', '')
        preco_custo = request.POST.get('preco_custo')
        preco_venda = request.POST.get('preco_venda')
        ativo = request.POST.get('ativo') == 'on'
        
        try:
            ProdutoDAO.criar(nome, marca, preco_custo, preco_venda, ativo)
            messages.success(request, 'Produto criado com sucesso!')
            return redirect('produto_lista')
        except Exception as e:
            messages.error(request, f'Erro ao criar produto: {str(e)}')
    
    return render(request, 'produtos/form.html')


def produto_editar(request, id):
    """Edita um produto existente"""
    produto = ProdutoDAO.buscar(id)
    
    if not produto:
        messages.error(request, 'Produto não encontrado!')
        return redirect('produto_lista')
    
    if request.method == 'POST':
        nome = request.POST.get('nome_produto')
        marca = request.POST.get('marca', '')
        preco_custo = request.POST.get('preco_custo')
        preco_venda = request.POST.get('preco_venda')
        ativo = request.POST.get('ativo') == 'on'
        
        try:
            ProdutoDAO.atualizar(id, nome, marca, preco_custo, preco_venda, ativo)
            messages.success(request, 'Produto atualizado com sucesso!')
            return redirect('produto_lista')
        except Exception as e:
            messages.error(request, f'Erro ao atualizar produto: {str(e)}')
    
    return render(request, 'produtos/form.html', {'produto': produto})


def produto_deletar(request, id):
    """Deleta um produto"""
    if request.method == 'POST':
        try:
            ProdutoDAO.deletar(id)
            messages.success(request, 'Produto deletado com sucesso!')
        except Exception as e:
            messages.error(request, f'Erro ao deletar produto: {str(e)}')
        return redirect('produto_lista')
    
    produto = ProdutoDAO.buscar(id)
    return render(request, 'produtos/deletar.html', {'produto': produto})


# ============================================
# VIEWS DE CLIENTE
# ============================================

def cliente_lista(request):
    """Lista todos os clientes"""
    clientes = ClienteDAO.listar()
    return render(request, 'clientes/lista.html', {'clientes': clientes})


def cliente_criar(request):
    """Cria um novo cliente"""
    if request.method == 'POST':
        nome = request.POST.get('nome_cliente')
        cpf = request.POST.get('cpf')
        email = request.POST.get('email', '')
        telefone = request.POST.get('telefone', '')
        ativo = request.POST.get('ativo') == 'on'
        
        # Validar CPF
        if not Cliente.validar_cpf(cpf):
            messages.error(request, 'CPF inválido!')
            return render(request, 'clientes/form.html', {
                'cliente': {'nome_cliente': nome, 'cpf': cpf, 'email': email, 'telefone': telefone}
            })
        
        # Verificar se CPF já existe
        if ClienteDAO.buscar_por_cpf(cpf):
            messages.error(request, 'CPF já cadastrado!')
            return render(request, 'clientes/form.html', {
                'cliente': {'nome_cliente': nome, 'cpf': cpf, 'email': email, 'telefone': telefone}
            })
        
        try:
            ClienteDAO.criar(nome, cpf, email, telefone, ativo)
            messages.success(request, 'Cliente criado com sucesso!')
            return redirect('cliente_lista')
        except Exception as e:
            messages.error(request, f'Erro ao criar cliente: {str(e)}')
    
    return render(request, 'clientes/form.html')


def cliente_editar(request, id):
    """Edita um cliente existente"""
    cliente = ClienteDAO.buscar(id)
    
    if not cliente:
        messages.error(request, 'Cliente não encontrado!')
        return redirect('cliente_lista')
    
    if request.method == 'POST':
        nome = request.POST.get('nome_cliente')
        cpf = request.POST.get('cpf')
        email = request.POST.get('email', '')
        telefone = request.POST.get('telefone', '')
        ativo = request.POST.get('ativo') == 'on'
        
        # Validar CPF
        if not Cliente.validar_cpf(cpf):
            messages.error(request, 'CPF inválido!')
            return render(request, 'clientes/form.html', {'cliente': cliente})
        
        # Verificar se CPF já existe (exceto para o próprio cliente)
        cliente_existente = ClienteDAO.buscar_por_cpf(cpf)
        if cliente_existente and cliente_existente['id_cliente'] != id:
            messages.error(request, 'CPF já cadastrado para outro cliente!')
            return render(request, 'clientes/form.html', {'cliente': cliente})
        
        try:
            ClienteDAO.atualizar(id, nome, cpf, email, telefone, ativo)
            messages.success(request, 'Cliente atualizado com sucesso!')
            return redirect('cliente_lista')
        except Exception as e:
            messages.error(request, f'Erro ao atualizar cliente: {str(e)}')
    
    return render(request, 'clientes/form.html', {'cliente': cliente})


def cliente_deletar(request, id):
    """Deleta um cliente"""
    if request.method == 'POST':
        try:
            ClienteDAO.deletar(id)
            messages.success(request, 'Cliente deletado com sucesso!')
        except Exception as e:
            messages.error(request, f'Erro ao deletar cliente: {str(e)}')
        return redirect('cliente_lista')
    
    cliente = ClienteDAO.buscar(id)
    return render(request, 'clientes/deletar.html', {'cliente': cliente})
