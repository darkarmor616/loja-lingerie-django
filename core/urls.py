from django.urls import path
from . import views

urlpatterns = [
    # Página inicial
    path('', views.index, name='index'),
    
    # Rotas de Categoria
    path('categorias/', views.categoria_lista, name='categoria_lista'),
    path('categorias/criar/', views.categoria_criar, name='categoria_criar'),
    path('categorias/<int:id>/editar/', views.categoria_editar, name='categoria_editar'),
    path('categorias/<int:id>/deletar/', views.categoria_deletar, name='categoria_deletar'),
    
    # Rotas de Produto
    path('produtos/', views.produto_lista, name='produto_lista'),
    path('produtos/criar/', views.produto_criar, name='produto_criar'),
    path('produtos/<int:id>/editar/', views.produto_editar, name='produto_editar'),
    path('produtos/<int:id>/deletar/', views.produto_deletar, name='produto_deletar'),
    
    # Rotas de Cliente
    path('clientes/', views.cliente_lista, name='cliente_lista'),
    path('clientes/criar/', views.cliente_criar, name='cliente_criar'),
    path('clientes/<int:id>/editar/', views.cliente_editar, name='cliente_editar'),
    path('clientes/<int:id>/deletar/', views.cliente_deletar, name='cliente_deletar'),
]
