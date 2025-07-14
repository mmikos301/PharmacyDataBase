
# Pharmacy Inventory and Order Management System

This PostgreSQL database project is designed to manage a pharmacy’s products, suppliers, clients, prescriptions, orders, deliveries, promotions, and payments. It provides a structured schema, business logic through triggers and stored procedures, and data integrity constraints.

## Features

- Tracks pharmaceutical products, categories, and stock levels
- Manages clients and employees
- Handles prescription creation and verification
- Supports order tracking with automatic status updates
- Monitors low stock levels and schedules supplier deliveries
- Implements payment processing with multiple methods
- Ensures data validity via triggers and stored procedures

## Schema Overview

The database schema consists of the following main tables:

- dostawcy – suppliers
- kategorieproduktow – product categories
- klienci – customers
- produkty – products
- recepty – prescriptions
- szczegolyrecepty – prescription details
- zamowienia – orders
- platnosci – payments
- dostawy – deliveries
- promocje / listapromocji – promotions

Each table has appropriate primary keys, foreign keys, constraints, and indexes to support efficient data operations.

## Triggers and Functions

- aktualizuj_ilosc_produktu: updates product quantity after a delivery
- sprawdz_date_waznosci_produktu: blocks expired products from being added to prescriptions
- ustaw_status_zamowienia_na_zrealizowane: updates order status based on fulfillment
- sprawdz_date_waznosci: checks if a product is expired (used internally)

## Stored Procedures

- dodaj_klienta(imie, nazwisko, email, telefon, adres): adds a new client
- monitorujstanmagazynowy(): checks low inventory and inserts delivery requests
- zaktualizuj_status_zamowienia(zamowienie_id, nowy_status): manually updates an order’s status

## Getting Started

1. Ensure PostgreSQL is installed.
2. Create the schema and execute all SQL definitions and procedures provided in the script.
3. Use any SQL client (e.g. DBeaver, pgAdmin) or application backend to interact with the database.

## Example Queries

Get all products with low stock:

```sql
SELECT produktid, nazwa, iloscnamagazynie
FROM produkty
WHERE iloscnamagazynie < 50;
```

Get all active orders and customer names:

```sql
SELECT z.zamowienieid, z.status, k.imie, k.nazwisko
FROM zamowienia z
JOIN klienci k ON z.klientid = k.klientid
WHERE z.status != 'Zrealizowane';
```

List all prescriptions and their products:

```sql
SELECT r.receptaid, r.lekarz, s.nazwaproduktu, s.ilosc
FROM recepty r
JOIN szczegolyrecepty s ON r.receptaid = s.receptaid;
```

Total value of payments per method:

```sql
SELECT metoda, SUM(kwota) AS suma
FROM platnosci
GROUP BY metoda;
```

Monitor inventory by running procedure:

```sql
CALL monitorujstanmagazynowy();
```
## Notes

- All constraints (e.g., check, foreign keys) enforce data integrity.
- Triggers ensure automatic updates of stock and order status.
- Schema and functions are designed in Polish for field names; adapt if needed for international use.

## License

This project is for academic and development use. Modify freely as needed.
