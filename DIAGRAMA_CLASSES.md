# DIAGRAMA DE CLASSES - LOJA DE LINGERIE

## Representação UML das Classes do Sistema

```
┌─────────────────────────────────────┐
│           Categoria                 │
├─────────────────────────────────────┤
│ - id_categoria: int                 │
│ - nome_categoria: string            │
│ - descricao: string                 │
│ - ativo: boolean                    │
├─────────────────────────────────────┤
│ + criar(): void                     │
│ + listar(): List<Categoria>         │
│ + buscar(id: int): Categoria        │
│ + atualizar(): void                 │
│ + deletar(): void                   │
└─────────────────────────────────────┘


┌─────────────────────────────────────┐
│            Produto                  │
├─────────────────────────────────────┤
│ - id_produto: int                   │
│ - nome_produto: string              │
│ - marca: string                     │
│ - preco_custo: decimal              │
│ - preco_venda: decimal              │
│ - ativo: boolean                    │
├─────────────────────────────────────┤
│ + criar(): void                     │
│ + listar(): List<Produto>           │
│ + buscar(id: int): Produto          │
│ + atualizar(): void                 │
│ + deletar(): void                   │
│ + calcularMargem(): decimal         │
└─────────────────────────────────────┘


┌─────────────────────────────────────┐
│            Cliente                  │
├─────────────────────────────────────┤
│ - id_cliente: int                   │
│ - nome_cliente: string              │
│ - cpf: string                       │
│ - email: string                     │
│ - telefone: string                  │
│ - ativo: boolean                    │
├─────────────────────────────────────┤
│ + criar(): void                     │
│ + listar(): List<Cliente>           │
│ + buscar(id: int): Cliente          │
│ + atualizar(): void                 │
│ + deletar(): void                   │
│ + validarCPF(): boolean             │
└─────────────────────────────────────┘
```

---

## Detalhamento das Classes

### 1. Categoria

**Atributos:**
- `id_categoria` (int): Identificador único da categoria
- `nome_categoria` (string): Nome da categoria (ex: Sutiãs, Calcinhas)
- `descricao` (string): Descrição detalhada da categoria
- `ativo` (boolean): Status da categoria (ativa/inativa)

**Métodos:**
- `criar()`: Cria uma nova categoria no banco
- `listar()`: Retorna lista de todas as categorias
- `buscar(id)`: Busca categoria específica por ID
- `atualizar()`: Atualiza dados da categoria
- `deletar()`: Remove categoria do banco

---

### 2. Produto

**Atributos:**
- `id_produto` (int): Identificador único do produto
- `nome_produto` (string): Nome do produto
- `marca` (string): Marca do produto (ex: Valisere, Hope)
- `preco_custo` (decimal): Preço de custo
- `preco_venda` (decimal): Preço de venda
- `ativo` (boolean): Status do produto (ativo/inativo)

**Métodos:**
- `criar()`: Cria um novo produto no banco
- `listar()`: Retorna lista de todos os produtos
- `buscar(id)`: Busca produto específico por ID
- `atualizar()`: Atualiza dados do produto
- `deletar()`: Remove produto do banco
- `calcularMargem()`: Calcula margem de lucro do produto

---

### 3. Cliente

**Atributos:**
- `id_cliente` (int): Identificador único do cliente
- `nome_cliente` (string): Nome completo do cliente
- `cpf` (string): CPF do cliente (formato: XXX.XXX.XXX-XX)
- `email` (string): E-mail do cliente
- `telefone` (string): Telefone do cliente
- `ativo` (boolean): Status do cliente (ativo/inativo)

**Métodos:**
- `criar()`: Cria um novo cliente no banco
- `listar()`: Retorna lista de todos os clientes
- `buscar(id)`: Busca cliente específico por ID
- `atualizar()`: Atualiza dados do cliente
- `deletar()`: Remove cliente do banco
- `validarCPF()`: Valida formato e dígitos do CPF

---

## Observações sobre os Relacionamentos

Conforme o enunciado do trabalho:
> "Obs: não é necessário implementar os relacionamentos entre as classes."

Portanto, as 3 classes (Categoria, Produto, Cliente) serão implementadas de forma **independente**, sem Foreign Keys entre elas neste trabalho.

Na aplicação real do banco de dados, os relacionamentos existem:
- Produto → Categoria (Many-to-One)
- Venda → Cliente (Many-to-One)

Mas para este trabalho de LP2, cada classe terá seu CRUD independente.

---

## Padrão de Design Utilizado

### DAO (Data Access Object)

Cada classe terá uma classe DAO correspondente:

```
CategoriaDAO
├─ criar(categoria: Categoria): void
├─ listar(): List<Categoria>
├─ buscar(id: int): Categoria
├─ atualizar(categoria: Categoria): void
└─ deletar(id: int): void

ProdutoDAO
├─ criar(produto: Produto): void
├─ listar(): List<Produto>
├─ buscar(id: int): Produto
├─ atualizar(produto: Produto): void
└─ deletar(id: int): void

ClienteDAO
├─ criar(cliente: Cliente): void
├─ listar(): List<Cliente>
├─ buscar(id: int): Cliente
├─ atualizar(cliente: Cliente): void
└─ deletar(id: int): void
```

As classes DAO encapsulam todo o código SQL, separando a lógica de acesso ao banco de dados da lógica de negócio.

---

## Arquitetura MVT (Django)

```
Model (models.py)
├─ Categoria
├─ Produto
└─ Cliente

DAO (dao.py)
├─ CategoriaDAO
├─ ProdutoDAO
└─ ClienteDAO

View (views.py)
├─ CategoriaView (list, create, update, delete)
├─ ProdutoView (list, create, update, delete)
└─ ClienteView (list, create, update, delete)

Template (templates/)
├─ categorias/
│   ├─ lista.html
│   ├─ form.html
│   └─ deletar.html
├─ produtos/
│   ├─ lista.html
│   ├─ form.html
│   └─ deletar.html
└─ clientes/
    ├─ lista.html
    ├─ form.html
    └─ deletar.html
```

---

**Data:** 08/12/2025  
**Disciplina:** Linguagem de Programação II  
**Tema:** Sistema de Gestão - Loja de Lingerie  
**Classes:** Categoria, Produto, Cliente
