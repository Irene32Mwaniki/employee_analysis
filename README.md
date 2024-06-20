# employee_analysis
.
├── data/
│   └── employees.sql               # SQL script for database creation and data insertion
├── scripts/
│   ├── queries.sql                 # SQL script with advanced queries
│   ├── stored_procedures.sql       # SQL script with stored procedures
│   ├── triggers.sql                # SQL script with triggers
│   └── functions.sql               # SQL script with user-defined functions
├── README.md                       # Project overview and documentation

Features
To clean and manage the data within the employees database, I created a duplicate of the departments table named departments_dup and inserted several department records, ensuring to handle null values appropriately. I then created and populated a duplicate table dept_manager_dup with data from the dept_manager table, including some manual insertions and deletions to simulate data management scenarios. Additionally, I performed various SQL operations such as joining tables to extract specific employee details, creating a view to calculate the average salary of managers, and defining stored procedures and functions to retrieve employee information based on input parameters. Moreover, I implemented a trigger to enforce data integrity on hire dates and created indexes to optimize query performance. I also utilized advanced SQL techniques like window functions (e.g., ROW_NUMBER(), RANK(), DENSE_RANK()) and conditional queries to analyze and categorize data efficiently. Lastly, I demonstrated the use of CASE statements to determine employee statuses and salary raise eligibility, showcasing comprehensive data management and analysis skills.
