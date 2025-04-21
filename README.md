# 📚 VoxBlog - Post & Rating API

Esta é uma API REST desenvolvida em Ruby on Rails com PostgreSQL, que permite:

- Criar posts com IP e login de usuário.
- Criar usuários automaticamente ao cadastrar um post, se ainda não existirem.
- Avaliar posts com uma nota (1 a 5), garantindo que um usuário avalie um post apenas uma vez.
- Obter os N melhores posts por média de avaliação.
- Obter uma lista de IPs utilizados por diferentes autores (usuários).

---

## 🚀 Tecnologias

- Ruby on Rails (versão 3.3.6 e 8.0.2, respectivamente)
- PostgreSQL
- RSpec
- SimpleCov
- RuboCop

---

## 🔧 Instalação e uso

1. **Clone o projeto**:

   ```bash
   git clone https://github.com/seu-usuario/sua-api.git
   cd VoxBlog
   ```

2. **Instale as dependências**:

   ```bash
   bundle install
   ```

3. **Configure o banco de dados**:

   ```bash
   rails db:create db:migrate
   ```

4. **Rodando os seeds (opcional):**
   Para gerar um volume menor de dados para teste:

   ```bash
   rails db:seed
   ```

   Para rodar:

   ```ruby
   generate_seeds_parallel(user_count: 100, post_count: 200_000, rating_probability: 0.75)
   ```

5. **Inicie o servidor**:

   ```bash
   rails server
   ```

---

## 📬 Endpoints disponíveis

### 🔹 Criar um post

**POST** `/posts`

**Parâmetros (JSON):**

```json
{
  "title": "Título do post",
  "body": "Conteúdo do post",
  "login": "usuario123",
  "ip": "192.168.0.1"
}
```

**Resposta (201 - Sucesso):**

```json
{
  "post": { "id": 1, "title": "Título", "body": "Conteúdo", "ip": "192.168.0.1" },
  "user": { "id": 1, "login": "usuario123" }
}
```

---

### 🔹 Avaliar um post

**POST** `/ratings`

**Parâmetros (JSON):**

```json
{
  "post_id": 1,
  "user_id": 1,
  "value": 4
}
```

**Resposta:**

```json
{ "average_rating": 4.2 }
```

---

### 🔹 Top N posts

**GET** `/posts/top?n=5`

**Resposta:**

```json
[
  { "id": 1, "title": "Post 1", "body": "Texto do post 1" },
  ...
]
```

---

### 🔹 IPs por autores

**GET** `/posts/ips`

**Resposta:**

```json
[
  {
    "ip": "192.168.0.1",
    "logins": ["usuario1", "usuario2"]
  },
  ...
]
```

---

## 🧪 Testes

Para rodar os testes com cobertura:

```bash
bundle exec rspec
```

Um relatório será gerado no terminal e também em `coverage/index.html`.

---

## ✅ Código limpo

Use o RuboCop para garantir estilo consistente:

```bash
bundle exec rubocop
```

---

## 💡 Observações

- O sistema foi projetado para suportar avaliações concorrentes corretamente.
- O script de seeds usa `curl` para interagir com a própria API, garantindo que os dados sejam validados corretamente.

---

##  Autora

Feito com ❤️ por Ana Clara.  

---
