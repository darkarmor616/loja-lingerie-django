# 🛍️ Sistema de Gestão - Loja de Lingerie

Sistema CRUD desenvolvido em Django para gerenciamento de loja de lingerie.

**Disciplina:** Linguagem de Programação II  
**Tema:** Loja de Lingerie  
**Tecnologias:** Django 4.2, Python 3.x, MySQL 8.0

---

## 📋 Requisitos do Trabalho

✅ Diagrama entidade-relacionamento (Banco de Dados)  
✅ Diagrama de classes  
✅ 3 CRUDs completos (Categorias, Produtos, Clientes)  
✅ Cada CRUD com ID + 3 atributos mínimos  
✅ SQL nas classes DAO (Data Access Object)  
✅ Templates Django  
✅ Validações a nível HTML  
✅ Código organizado (padrão MVT)

---

## 🗂️ Estrutura do Projeto

```
loja_lingerie_django/
├── manage.py                    # Gerenciador do Django
├── requirements.txt             # Dependências Python
├── loja_lingerie/              # Configurações do projeto
│   ├── __init__.py
│   ├── settings.py             # Configurações principais
│   ├── urls.py                 # URLs principais
│   ├── wsgi.py
│   └── asgi.py
└── core/                        # App principal
    ├── __init__.py
    ├── apps.py
    ├── models.py               # Models (Categoria, Produto, Cliente)
    ├── dao.py                  # Classes DAO com SQL
    ├── views.py                # Views dos CRUDs
    ├── urls.py                 # URLs do app
    └── templates/              # Templates HTML
        ├── core/
        │   ├── base.html       # Template base
        │   └── index.html      # Página inicial
        ├── categorias/
        │   ├── lista.html
        │   ├── form.html
        │   └── deletar.html
        ├── produtos/
        │   ├── lista.html
        │   ├── form.html
        │   └── deletar.html
        └── clientes/
            ├── lista.html
            ├── form.html
            └── deletar.html
```

---

## 🚀 Como Executar o Projeto

### 1️⃣ Pré-requisitos

- Python 3.8 ou superior
- MySQL 8.0 instalado e rodando
- Banco de dados `loja_lingerie` criado (do trabalho de BD)

### 2️⃣ Instalação

#### a) Clonar/Baixar o projeto

Extraia o arquivo `loja_lingerie_django.zip` em uma pasta.

#### b) Criar ambiente virtual (recomendado)

```bash
# Windows
python -m venv venv
venv\Scripts\activate

# Linux/Mac
python3 -m venv venv
source venv/bin/activate
```

#### c) Instalar dependências

```bash
pip install -r requirements.txt
```

**Obs:** Se der erro ao instalar `mysqlclient`, veja a seção de Troubleshooting.

### 3️⃣ Configurar Banco de Dados

Edite o arquivo `loja_lingerie/settings.py` na linha 58:

```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'loja_lingerie',
        'USER': 'root',
        'PASSWORD': 'SUA_SENHA_AQUI',  # ← COLOQUE SUA SENHA AQUI
        'HOST': 'localhost',
        'PORT': '3306',
    }
}
```

### 4️⃣ Executar o Banco de Dados

Se ainda não executou o script SQL do trabalho de BD:

```bash
mysql -u root -p < loja_lingerie.sql
```

### 5️⃣ Rodar o Servidor

```bash
python manage.py runserver
```

### 6️⃣ Acessar o Sistema

Abra o navegador em: **http://localhost:8000**

---

## 🎯 Funcionalidades Implementadas

### 📂 CRUD de Categorias
- ✅ **Criar:** Nova categoria com nome, descrição e status
- ✅ **Listar:** Todas as categorias com status
- ✅ **Editar:** Atualizar dados da categoria
- ✅ **Deletar:** Remover categoria (com confirmação)

**URL:** http://localhost:8000/categorias/

### 👗 CRUD de Produtos
- ✅ **Criar:** Novo produto com nome, marca, preços
- ✅ **Listar:** Todos os produtos com margem de lucro
- ✅ **Editar:** Atualizar dados do produto
- ✅ **Deletar:** Remover produto (com confirmação)
- ✅ Cálculo automático de margem de lucro

**URL:** http://localhost:8000/produtos/

### 👥 CRUD de Clientes
- ✅ **Criar:** Novo cliente com nome, CPF, email, telefone
- ✅ **Listar:** Todos os clientes cadastrados
- ✅ **Editar:** Atualizar dados do cliente
- ✅ **Deletar:** Remover cliente (com confirmação)
- ✅ Validação de CPF (formato e dígitos)
- ✅ Máscaras automáticas (CPF e telefone)

**URL:** http://localhost:8000/clientes/

---

## 💻 Tecnologias e Conceitos Aplicados

### Padrão MVT (Model-View-Template)

**Models (`models.py`):**
- Categoria
- Produto
- Cliente

**Views (`views.py`):**
- categoria_lista, categoria_criar, categoria_editar, categoria_deletar
- produto_lista, produto_criar, produto_editar, produto_deletar
- cliente_lista, cliente_criar, cliente_editar, cliente_deletar

**Templates (`templates/`):**
- base.html (template pai)
- Templates específicos para cada CRUD

### DAO (Data Access Object)

Classes DAO (`dao.py`) encapsulam todo o SQL:

```python
CategoriaDAO
├─ criar()
├─ listar()
├─ buscar()
├─ atualizar()
└─ deletar()
```

### Validações HTML5

- `required` para campos obrigatórios
- `maxlength` para limitar caracteres
- `pattern` para formatos (CPF, telefone)
- `type="email"` para validar e-mail
- `type="number"` com `step` e `min` para preços

### JavaScript

- Máscaras automáticas (CPF e telefone)
- Validação de CPF no cliente
- Cálculo de margem em tempo real

---

## 📊 Diagramas

### Diagrama de Classes (UML)

Veja o arquivo `DIAGRAMA_CLASSES.md` incluído no projeto.

### Diagrama ER

O diagrama ER está no arquivo `loja_lingerie.mwb` do trabalho de Banco de Dados.

---

## 🔧 Troubleshooting

### Erro ao instalar mysqlclient

**Windows:**
```bash
# Baixe o wheel do mysqlclient:
# https://www.lfd.uci.edu/~gohlke/pythonlibs/#mysqlclient
# Depois instale:
pip install mysqlclient-2.2.0-cp311-cp311-win_amd64.whl
```

**Linux:**
```bash
sudo apt-get install python3-dev default-libmysqlclient-dev build-essential
pip install mysqlclient
```

### Erro de conexão com MySQL

Verifique:
1. MySQL está rodando?
2. Senha está correta no `settings.py`?
3. Banco `loja_lingerie` foi criado?

```bash
# Testar conexão
mysql -u root -p loja_lingerie
```

### Porta 8000 já está em uso

```bash
# Use outra porta
python manage.py runserver 8001
```

---

## 📸 Screenshots

### Página Inicial
- Dashboard com acesso aos 3 CRUDs
- Menu de navegação
- Design limpo e funcional

### Listagem
- Tabelas com todos os registros
- Botões de ação (Editar, Deletar)
- Status visual (badges)

### Formulários
- Campos com validação
- Máscaras automáticas
- Mensagens de erro/sucesso

---

## 🎓 Apresentação

### Pontos a Destacar:

1. **Arquitetura MVT bem organizada**
   - Models, Views e Templates separados
   - Código limpo e documentado

2. **Padrão DAO implementado**
   - SQL encapsulado nas classes DAO
   - Separação de responsabilidades

3. **Validações robustas**
   - HTML5 (required, pattern, maxlength)
   - JavaScript (máscaras e validação de CPF)
   - Python (validações no servidor)

4. **Interface funcional**
   - Design simples mas profissional
   - Navegação intuitiva
   - Feedback visual (mensagens)

5. **3 CRUDs completos**
   - Create, Read, Update, Delete
   - Todas as operações funcionando

---

## 📝 Checklist para Apresentação

- [ ] Banco de dados criado e populado
- [ ] Dependências instaladas
- [ ] Senha do MySQL configurada em `settings.py`
- [ ] Servidor rodando sem erros
- [ ] Testar cada CRUD:
  - [ ] Categorias (criar, listar, editar, deletar)
  - [ ] Produtos (criar, listar, editar, deletar)
  - [ ] Clientes (criar, listar, editar, deletar)
- [ ] Validações funcionando
- [ ] Diagrama de classes pronto

---

## 👨‍💻 Autor

**Aluno:** Toddy  
**Curso:** Ciência da Computação  
**Instituição:** IFSULDEMINAS Campus Muzambinho  
**Data:** Dezembro/2025

---

## 📄 Licença

Projeto acadêmico desenvolvido para fins educacionais.

---

## 🆘 Suporte

Em caso de dúvidas:
1. Verifique a seção de Troubleshooting
2. Confira se todas as dependências estão instaladas
3. Valide a configuração do banco de dados

**Boa apresentação! 🚀**
