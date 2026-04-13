# Payment Account API

[Read in English](README.en.md)

Uma API simples de gestão bancária construída com Ruby on Rails, oferecendo criação de contas e processamento de transações financeiras.

## Tecnologias

- Ruby 4.0.2
- Rails 8.1.3 (API-only)
- SQLite3
- RSpec + FactoryBot + Shoulda Matchers + SimpleCov

## Endpoints

### Criar Conta
```http
POST /account
Content-Type: application/json

{ "account": { "account_number": 234, "balance": 180.37 } }
```

**Resposta 201**
```json
{ "account_number": 234, "balance": "180.37" }
```

---

### Consultar Conta
```http
GET /account?account_number=234
```

**Resposta 200**
```json
{ "account_number": 234, "balance": "180.37" }
```

---

### Criar Transação
```http
POST /transaction
Content-Type: application/json

{ "transaction": { "payment_method": "D", "account_number": 234, "amount": 10.0 } }
```

**Resposta 201**
```json
{ "account_number": 234, "balance": "170.07" }
```

#### Formas de pagamento e taxas
| Forma | Código | Taxa |
|-------|--------|------|
| Pix | `P` | 0% |
| Cartão de Débito | `D` | 3% |
| Cartão de Crédito | `C` | 5% |

---

## Regras de Negócio

- O saldo da conta nunca pode ser negativo (sem cheque especial)
- Números de conta duplicados não são permitidos
- As taxas são aplicadas sobre o valor da transação
- Os dados são persistidos durante a execução; reiniciar o servidor zera o banco (SQLite)

## Executando Localmente

```bash
git clone git@github.com:m4rcelotoledo/objective-payment-account.git
cd objective-payment-account

bundle install
rails db:migrate
rails server
```

API disponível em `http://localhost:3000`

## Executando os Testes

```bash
bundle exec rspec
```

O relatório de cobertura é gerado em `coverage/index.html` após a execução da suite.

## Arquitetura

- **Controllers** — finos, responsáveis apenas por entrada e saída HTTP
- **TransactionService** — encapsula o cálculo de taxas e a validação de saldo
- **Models** — validações e integridade dos dados

## CI/CD

O GitHub Actions executa em todo pull request e push para `master`:

1. Análise de segurança (Brakeman + Bundler Audit)
2. Lint (RuboCop)
3. Suite de testes (RSpec)

O deploy no Railway é disparado automaticamente após todos os checks passarem no `master`.
