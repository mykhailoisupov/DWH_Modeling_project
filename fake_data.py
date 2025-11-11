import random
import mysql.connector
from faker import Faker
from datetime import datetime, timedelta

def get_existing_ids(cursor, table_name, id_column):
    """Fetch all IDs from a table to use for foreign keys."""
    cursor.execute(f"SELECT {id_column} FROM {table_name}")
    return [row[0] for row in cursor.fetchall()]

def generate_customer_record(fake):
    """Generate a single customer record."""
    return (
        fake.first_name(),
        fake.last_name(),
        fake.unique.email(),
        fake.city(),
        fake.date_between(start_date='-2y', end_date='today'),
        random.choice([True, False])
    )

def generate_category_record(fake):
    """Generate a single category record."""
    categories = ['Electronics', 'Books', 'Clothing', 'Home & Garden', 'Toys', 'Sports', 'Beauty']
    return (random.choice(categories),)

def generate_product_record(fake, category_ids):
    """Generate a single product record."""
    return (
        fake.catch_phrase(),
        random.choice(category_ids),
        round(random.uniform(5.00, 500.00), 2),
        random.randint(0, 1000),
        random.randint(1, 100)  # supplier_id (no table, so random int)
    )

def generate_order_record(fake, customer_ids):
    """Generate a single order record."""
    order_date = fake.date_time_between(start_date='-1y', end_date='now')
    total_amount = round(random.uniform(10.00, 1000.00), 2)
    status = random.choice(['Pending', 'Shipped', 'Delivered', 'Cancelled'])
    return (
        random.choice(customer_ids),
        order_date,
        total_amount,
        status
    )

def generate_order_item_record(fake, order_ids, product_ids):
    """Generate a single order item record."""
    quantity = random.randint(1, 10)
    unit_price = round(random.uniform(5.00, 500.00), 2)
    return (
        random.choice(order_ids),
        random.choice(product_ids),
        quantity,
        unit_price
    )

def insert_fake_data(
    host: str,
    user: str,
    password: str,
    database: str,
    num_customers: int = 1000,
    num_categories: int = 10,
    num_products: int = 5000,
    num_orders: int = 10000,
    num_order_items: int = 30000,
    batch_size: int = 1000
):
    """
    Generate and insert synthetic data into the database while respecting foreign keys.
    
    Args:
        host (str): MySQL host
        user (str): MySQL user
        password (str): MySQL password
        database (str): Database name
        num_customers (int): Number of customers to insert
        num_categories (int): Number of categories to insert
        num_products (int): Number of products to insert
        num_orders (int): Number of orders to insert
        num_order_items (int): Number of order items to insert
        batch_size (int): Rows per batch insert
    """
    connection = mysql.connector.connect(
        host=host,
        user=user,
        password=password,
        database=database
    )
    cursor = connection.cursor()
    fake = Faker()

    # Insert Customers
    customer_query = """
        INSERT INTO Customers
        (first_name, last_name, email, city, registration_date, is_premium)
        VALUES (%s, %s, %s, %s, %s, %s)
    """
    for i in range(0, num_customers, batch_size):
        batch = [generate_customer_record(fake) for _ in range(min(batch_size, num_customers - i))]
        cursor.executemany(customer_query, batch)
        connection.commit()
        print(f"Inserted {min(i + batch_size, num_customers)} / {num_customers} customers")

    # Get customer IDs
    customer_ids = get_existing_ids(cursor, 'Customers', 'customer_id')

    # Insert Categories
    category_query = """
        INSERT INTO Categories
        (category_name)
        VALUES (%s)
    """
    for i in range(0, num_categories, batch_size):
        batch = [generate_category_record(fake) for _ in range(min(batch_size, num_categories - i))]
        cursor.executemany(category_query, batch)
        connection.commit()
        print(f"Inserted {min(i + batch_size, num_categories)} / {num_categories} categories")

    # Get category IDs
    category_ids = get_existing_ids(cursor, 'Categories', 'category_id')

    # Insert Products
    product_query = """
        INSERT INTO Products
        (product_name, category_id, price, stock_quantity, supplier_id)
        VALUES (%s, %s, %s, %s, %s)
    """
    for i in range(0, num_products, batch_size):
        batch = [generate_product_record(fake, category_ids) for _ in range(min(batch_size, num_products - i))]
        cursor.executemany(product_query, batch)
        connection.commit()
        print(f"Inserted {min(i + batch_size, num_products)} / {num_products} products")

    # Get product IDs
    product_ids = get_existing_ids(cursor, 'Products', 'product_id')

    # Insert Orders
    order_query = """
        INSERT INTO Orders
        (customer_id, order_date, total_amount, status)
        VALUES (%s, %s, %s, %s)
    """
    for i in range(0, num_orders, batch_size):
        batch = [generate_order_record(fake, customer_ids) for _ in range(min(batch_size, num_orders - i))]
        cursor.executemany(order_query, batch)
        connection.commit()
        print(f"Inserted {min(i + batch_size, num_orders)} / {num_orders} orders")

    # Get order IDs
    order_ids = get_existing_ids(cursor, 'Orders', 'order_id')

    # Insert OrderItems
    order_item_query = """
        INSERT INTO OrderItems
        (order_id, product_id, quantity, unit_price)
        VALUES (%s, %s, %s, %s)
    """
    for i in range(0, num_order_items, batch_size):
        batch = [generate_order_item_record(fake, order_ids, product_ids) for _ in range(min(batch_size, num_order_items - i))]
        cursor.executemany(order_item_query, batch)
        connection.commit()
        print(f"Inserted {min(i + batch_size, num_order_items)} / {num_order_items} order items")

    cursor.close()
    connection.close()
    print("✅ Data insertion complete!")

if __name__ == "__main__":
    insert_fake_data(
        host="localhost",
        user="root",
        password="MySQL_Student123",
        database="shop_db",
        num_customers=100_0000,
        num_categories=10,
        num_products=1_000_000,
        num_orders=3_000_000,
        num_order_items=10_000_000,
        batch_size=5_000
    )