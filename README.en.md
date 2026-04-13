# Payment Account API

A simple banking management API built with Ruby on Rails, offering account creation and financial transaction processing.

## Tech Stack

- Ruby 4.0.2
- Rails 8.1.3 (API-only)
- SQLite3
- RSpec + FactoryBot + Shoulda Matchers + SimpleCov

## Endpoints

### Create Account
```http
POST /account
Content-Type: application/json

{ "account": { "account_number": 234, "balance": 180.37 } }
```

**Response 201**
```json
{ "account_number": 234, "balance": "180.37" }
```

---

### Get Account
```http
GET /account?account_number=234
```

**Response 200**
```json
{ "account_number": 234, "balance": "180.37" }
```

---

### Create Transaction
```http
POST /transaction
Content-Type: application/json

{ "transaction": { "payment_method": "D", "account_number": 234, "amount": 10.0 } }
```

**Response 201**
```json
{ "account_number": 234, "balance": "170.07" }
```

#### Payment methods and fees
| Method | Code | Fee |
|--------|------|-----|
| Pix | `P` | 0% |
| Debit Card | `D` | 3% |
| Credit Card | `C` | 5% |

---

## Business Rules

- Account balance can never be negative (no overdraft)
- Duplicate account numbers are not allowed
- Transaction fees are applied on top of the requested amount
- Data is stored in a file-backed SQLite database and normally persists across server restarts; it is only reset if the database file is removed or the app runs on ephemeral filesystem storage

## Running Locally

```bash
git clone git@github.com:m4rcelotoledo/objective-payment-account.git
cd objective-payment-account

bundle install
rails db:migrate
rails server
```

API available at `http://localhost:3000`

## Running Tests

```bash
bundle exec rspec
```

Coverage report is generated at `coverage/index.html` after running the suite.

## Manual Testing

The `test.http` file at the root of the project allows you to test all endpoints manually.

Compatible with:
- [REST Client](https://marketplace.visualstudio.com/items?itemName=humao.rest-client) (VS Code)

## Architecture

- **Controllers** — thin, handle only HTTP input/output
- **TransactionService** — encapsulates fee calculation and balance validation
- **Models** — validations and data integrity

## CI/CD

GitHub Actions runs on every pull request and push to `master`:

1. Security scan (Brakeman + Bundler Audit)
2. Lint (RuboCop)
3. Test suite (RSpec)

Deploy to Railway triggers automatically after all checks pass on `master`.

## Deploy

The application is live at: https://objective-payment-account-production.up.railway.app

Hosted on Railway via Docker. Deploy triggers automatically on every push to `master` after all CI checks pass.

> Data is volatile in this environment — the container's ephemeral filesystem does not preserve SQLite between redeploys.

## Possible Next Steps

- JWT authentication
- Transaction history per account
- Robust persistence with PostgreSQL
- Rate limiting per account
- Transaction history pagination
- Account statement with filters by date range and payment method
- Account balance top-up
- etc.
