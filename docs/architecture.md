## 1. Objective

The purpose of this CDS view is to provide enriched flight data directly from the SAP S/4HANA database layer.

Instead of only exposing raw data from the **SFLIGHT** table, the view extends it with:

- Airline information

- Departure and destination details

- Calculated business KPIs

- Flight classification logic

## 2. Base Data Model

The CDS view is built on the table:

- **SFLIGHT** – flight data

To enrich the dataset, two associations are defined:

- _Carrier - **SCARR**

- _Connection - **SPFLI**

Both associations use cardinality [1..1], because:

- Each flight belongs to exactly one carrier.

- Each flight is uniquely identified by carrier and connection ID.

Associations are used instead of explicit joins to follow modern CDS modeling principles and allow navigation via path expressions.

## 3. Calculated Business Logic

Occupation (%)
The occupation percentage is calculated across all booking classes:

The result is cast to abap.dec(5,2) to ensure proper decimal precision.

## 4. Popularity Classification

Flights are classified based on their occupation:

- **Occupation** > 90% → Popularity = 'A'

- **Occupation** ≤ 90% → Popularity = 'B'

This classification is implemented using a CASE expression directly inside the CDS view.

## 5. Scope 

Flights are categorized as:

Domestic: if departure country equals destination country

International: otherwise

This comparison is done using the associated connection fields.

## 6. Filtering Logic

Since the business scenario assumes flights are offered only in EUR, the CDS view includes a filter that only relevant records are exposed.

## 7. Application Layer 

The CDS view is consumed by a classical ABAP report. 

The report: 
- Provides a structured selection screen 
- Uses ABAP SQL with the IN operator 
- Displays formatted list output 
- Highlights business-relevant flights using color formatting