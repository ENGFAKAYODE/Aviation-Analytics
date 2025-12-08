# Aviation Industry Data Analysis (SQL)
<img width="1036" height="546" alt="image" src="https://github.com/user-attachments/assets/823778ef-277c-438d-9340-e730dea439f1" />

## INTRODUCTION
This project is part of the "SQL Projects on Aviation" series developed by **Afriq IQ (2025)**. It focuses on extracting actionable business intelligence from a relational database representing an airline's operations. The project simulates a real-world environment where data analysts must solve complex business scenarios ranging from fleet management to revenue optimization.

## OBJECTIVE
The primary objective is to demonstrate proficiency in **Structured Query Language (SQL)** by solving over 50 specific business scenarios. The project aims to convert raw operational data covering passengers, bookings, flights, and crew into structured insights that support strategic decision-making for the airline.

## PROBLEM STATEMENT
The airline requires a comprehensive data system to address critical operational blind spots, specifically:
* **Operational Efficiency:** Identifying flight delays and calculating the specific revenue lost due to these delays to improve efficiency.
* **Fleet Management:** Tracking plane utilization rates (identifying under/over-utilized aircraft) and monitoring fleet age for maintenance or retirement decisions.
* **Customer Segmentation:** Analyzing passenger demographics (age/gender) and travel patterns to tailor marketing campaigns.
* **Revenue Optimization:** Identifying top revenue-generating flights and analyzing performance across different ticket classes and price ranges.
* **Workforce Allocation Risks:** Lacking visibility into cumulative flight hours for crew members, making it difficult to proactively identify burnout risks or regulatory non-compliance.
* **Demand Volatility Drivers:** Experiencing unpredictable fluctuations in monthly booking volumes without the granular data needed to attribute these spikes to specific seasons or routes.
* **Booking Pipeline Leakage:** Inability to distinguish between legitimate cancellations, system errors, or abandoned carts for bookings that never reach "Confirmed" status.
* **Pricing Strategy Effectiveness:** Unclear alignment between current ticket pricing tiers and actual customer demand, particularly regarding the performance of budget vs. premium ticket classes.

## GOALS
* **Revenue Optimization:** Rank flights and airports by monthly revenue to identify profitable routes.
* **Customer Loyalty:** Design a data-driven tier system (Platinum, Gold, Silver, Bronze) to reward frequent flyers.
* **Fleet Optimization:** Categorize planes by utilization status and age to optimize scheduling and maintenance.
* **Operational Monitoring:** Track booking status trends (Confirmed vs. Cancelled) to assess overall booking health.
* **Optimize Workforce Planning:** Develop a monitoring system for crew utilization to ensure balanced workloads and strict compliance with aviation safety regulations.
* **Maximize Revenue Yield:** Analyze booking lead times to implement dynamic pricing strategies.
* **Strategic Route Expansion:** Evaluate the financial efficiency of airport hubs (e.g., DFW vs. ORD) to guide data-driven decisions on where to open new routes or reduce capacity.
* **Targeted Customer Acquisition:** Construct a clear demographic profile of the "core customer" to shift marketing budgets away from broad channels toward high-conversion platforms.

## SKILLS DEMONSTRATED
* **Advanced Joins:** Connecting multiple tables (`Passengers`, `Bookings`, `Flights`, `Planes`, `Tickets`) to create a unified view of operations.
* **Window Functions:** Using `RANK()`, `DENSE_RANK()`, and `LAG()` for analyzing growth, customer ranking, and flight performance.
* **CTEs (Common Table Expressions):** Simplifying complex logic for monthly revenue and crew flight hour calculations.
* **Conditional Aggregation:** Pivoting data using `CASE WHEN` to analyze booking statuses and age distribution.
* **Date Manipulation:** Utilizing `DATEDIFF`, `DATEPART`, and `DATENAME` for lead-time analysis, age calculation, and seasonality trends.
* **Data Quality Analysis:** Auditing datasets for logical inconsistencies (e.g., negative flight duration) and missing values (e.g., `NULL` booking dates) to ensure reporting accuracy.
* **String Manipulation:** Formatting and concatenating text data (e.g., `CONCAT` for full names) to create reader-friendly reports.
* **Mathematical Computations:** Calculating percentages (e.g., Month-over-Month growth, Seat Utilization %) and handling data type conversions using `CAST`.

## DATA OVERVIEW
The database consists of the following relational tables based on the schema diagram:

| Table Name | Description | Key Columns |
| :--- | :--- | :--- |
| **Passengers** | Stores customer personal data. | `PassengerID`, `FirstName`, `LastName`, `DateOfBirth`, `Gender`  |
| **Bookings** | Links passengers to flights and tracks status. | `BookingID`, `PassengerID`, `FlightID`, `BookingDate`, `Status`  |
| **Tickets** | Detailed pricing and seat info for bookings. | `TicketID`, `BookingID`, `SeatNumber`, `Class`, `Price`  |
| **Flights** | Operational flight schedules and routes. | `FlightID`, `FlightNumber`, `DepartureAirport`, `ArrivalAirport`, `DepartureTime`, `PlaneID`  |
| **Planes** | Fleet inventory, capacity, and specs. | `PlaneID`, `Model`, `Capacity`, `Manufacturer`, `YearOfManufacture`, `Status` |
| **Crew** | Employee and assignment data. | `CrewID`, `FirstName`, `Position`, `HireDate`  |
| **Orders** | Transaction and billing details. | `Order_No`, `Order_Items`, `Order_Total`, `Payment_method`, `Billing_Address` |

## DATA CLEANING/TRANSFORMATION
Key transformations performed within the SQL queries include:
* **Bucketing:** Grouping continuous variables into categorical ranges, such as Ticket Prices into `$0-$100`, `$101-$200` ranges .
* **Age Calculation:** Dynamically calculating Passenger Age and Plane Age using `DATEDIFF(YEAR, ..., GETDATE())`.
* **Status Pivoting:** Transforming row-level Booking Statuses (Confirmed, Pending, Cancelled) into column-level metrics for monthly reporting .

## DATA MODELLING
The data follows a normalized relational model centered around the `Bookings` and `Flights` tables.

<img width="774" height="789" alt="image" src="https://github.com/user-attachments/assets/f3464bbf-5bf7-481b-87e8-58b78d886571" />

* **Core Relationships:** `Bookings` acts as a junction table linking `Passengers` to `Flights`.
* **Financials:** The `Tickets` table holds the granular financial data (`Price`, `Class`) linked 1:1 with `Bookings`.
* **Operations:** `Flights` serve as the operational hub, connecting `Planes` (Hardware) and `Crew` (Human Resources) to the schedule.

## ANALYSIS

### 1. Monthly Revenue Leaders (Window Functions)
**Goal:** Identify the highest-revenue flights for each month to understand seasonal route performance.

**SQL Technique:** Used `RANK() OVER (PARTITION BY Year, Month ORDER BY Revenue DESC)` to isolate top performers.

**Key Finding:** Flight **682** was the top earner in June, while Flight **445** took the lead in July, suggesting a shift in route popularity or pricing dynamics mid-summer.

### 2. Customer Loyalty Segmentation
**Goal:** Categorize passengers into tiers (Platinum, Gold, Silver, Bronze) based on flight frequency.

**SQL Technique:** Used `CASE WHEN` logic to assign tiers dynamically based on `COUNT(BookingID).

**Key Finding:** No passengers in the sample reached "Gold" (5+) or "Platinum" (10+) status. The ceiling is currently "Silver" (3 flights), indicating thresholds are too high.

### 3. Fleet Utilization & Efficiency
**Goal:** Assess operational load by categorizing planes based on flight frequency.

**SQL Technique:** Used `LEFT JOIN` and `CASE WHEN` to label utilization status.

**Key Finding:** While most planes are "Over-utilised" (4+ flights), the analysis uncovered significant data quality issues. Negative values in `Total_Hours_Flown` indicate critical errors in timestamp logging.

### 4. Booking Status Trends
**Goal:** Analyze the health of the booking pipeline by comparing Confirmed, Pending, and Cancelled statuses over time.

**SQL Technique:** Used `SUM(CASE WHEN...)` pivot logic.

**Key Finding:** August 2021 was the peak month for demand. However, 100 bookings are associated with NULL dates, representing a critical loss of temporal data.

### 5. Month-over-Month Growth
**Goal:** Calculate the percentage change in booking volume to track business trajectory.

**SQL Technique:** Used `LAG()` window function.

**Key Finding:** The business experiences high volatility. A significant drop in November (-33%) was immediately followed by a massive recovery in December (+50%), likely driven by holiday travel demand.

### 6. Passenger Demographic Profiling
**Goal:** Identify the age distribution of confirmed passengers to tailor marketing campaigns.

**SQL Technique:** Dynamic age calculation grouped into buckets.

**Key Finding:** The **45-54 age group** is the dominant demographic (252 passengers), dwarfing the senior segment. This suggests the airline caters primarily to established professionals.

### 7. Booking Lead Time Analysis
**Goal:** Measure the average time between booking date and flight departure to optimize yield management.

**SQL Technique:** Calculated `AVG(DATEDIFF(day...))`.

**Key Finding:** Early 2021 shows customers booking ~10 months in advance. However, Q4 2021 data is corrupted: negative lead times indicate bookings were logged **after** the flight departed.

### 8. Price Range Distribution
**Goal:** Analyze ticket sales volume across price buckets ($0-100, $400+, etc.) .

**SQL Technique:** `CASE WHEN` binning.

**Key Finding:** Contrary to typical low-cost carrier models, the highest volume of sales (208 tickets) occurred in the **$400+** premium range, generating the bulk of revenue.

### 9. Hub Analysis (Airport Efficiency)
**Goal:** Identify the highest revenue-generating airports to focus resource allocation.

**SQL Technique:** Aggregation of `SUM(Price)` grouped by `DepartureAirport`.

**Key Finding:** **DFW (Dallas/Fort Worth)** is the highest-performing hub, generating nearly 40% more revenue in a single month than its closest competitor, ORD.

### 10. Crew Workload Analysis
**Goal:** Monitor crew utilization to prevent burnout and ensure safety compliance.

**SQL Technique:** `SUM(DATEDIFF(hour...))`.

**Key Finding:** The analysis identified severe data corruption. Top "performers" show mathematically impossible flight durations (e.g., 2,000+ hours per flight), while others show negative working hours.

## RECOMMENDATIONS
1.  **Pivot to Premium:** Stop competing on price with budget carriers. Invest in business class amenities and corporate partnerships, as the **$400+** price range accounts for the vast majority of revenue.
2.  **Hub Optimization:** Focus network expansion on **DFW (Dallas)**. It outperformed the next closest hub (ORD) by nearly 40% in monthly revenue, making it the clear financial engine of the airline.
3.  **Shoulder Season Marketing:** Launch "Early Bird" discounts in October and November. This will help smooth out the extreme volatility seen in Q4 (where bookings dropped -33% in Nov before spiking +50% in Dec).
4.  **Recover "Revenue at Risk":** Implement an automated 24-hour email sequence for **Pending** bookings (Cart Abandonment). In August alone, there were 28 pending bookings that could have been converted to confirmed sales.
5.  **Freeze Route Expansion:** Pause acquiring new routes. The majority of the fleet is currently flagged as **"Over-utilised"** (>3 flights per period). Adding routes without adding planes will lead to mechanical failures and delays.
6.  **Urgent Flight Log Audit:** Inspect the flight logging software immediately. Multiple records show **negative flight hours** (e.g., -21,605 hours), indicating that Arrival Times are being recorded as earlier than Departure Times.
7.  **Fix Booking Timestamp Bug:** Patch the booking engine to prevent bookings with **negative lead times** (e.g., -62 days). Currently, the system allows bookings to be logged *after* a flight has departed.
8.  **Recalibrate Loyalty Tiers:** Lower the "Gold" tier threshold from 5 flights to **4 flights**. With zero customers currently reaching Gold status, the program fails to incentivize the "Silver" tier customers (who cap at 3 flights) to fly more.
9.  **Target Professional Demographic:** Shift marketing spend away from youth channels (TikTok) and toward professional networks (LinkedIn). The **45-54 age group** (252 pax) is the dominant traveler profile, vastly outnumbering younger demographics.
10. **Revenue Assurance Audit:** Investigate the 33 tickets sold with a **NULL** Price Range. If these are not authorized staff travel, they represent a significant leakage of uncollected revenue that must be fixed.

## CONCLUSION
This project successfully maps complex aviation business requirements to technical SQL solutions. By normalizing data and applying advanced aggregation techniques, we provided the airline with a clear view of their fleet health, revenue streams, and customer behavior. Crucially, the analysis also acted as a data audit, revealing significant data quality issues (negative flight hours, missing booking dates, and negative lead times) that must be addressed before advanced predictive modeling can occur.
