import random
import time
import psycopg2

first_names = ['John', 'Jane', 'Alice', 'Bob', 'Charlie', 'David', 'Eve', 'Frank', 'Grace', 'Henry', 'Ivy', 'Jack', 'Kate', 'Luke', 'Mary', 'Nancy', 'Oliver', 'Peggy', 'Quincy', 'Rachel', 'Sam', 'Tina', 'Ulysses', 'Victoria', 'Walter', 'Xavier', 'Yvonne', 'Zach', 'Abby', 'Ben', 'Cathy', 'Dan', 'Emily', 'Fred', 'Gina', 'Hank', 'Iris', 'Jake', 'Kelly', 'Liam', 'Megan', 'Nate', 'Olive', 'Pete', 'Quinn', 'Rose', 'Steve', 'Tara', 'Vince', 'Wendy', 'Xander', 'Yara', 'Zane']
last_names = ['Smith', 'Johnson', 'Williams', 'Jones', 'Brown', 'Davis', 'Miller', 'Wilson', 'Moore', 'Taylor', 'Anderson', 'Thomas', 'Jackson', 'White', 'Harris', 'Martin', 'Thompson', 'Garcia', 'Martinez', 'Robinson', 'Clark', 'Rodriguez', 'Lewis', 'Lee', 'Walker', 'Hall', 'Allen', 'Young', 'Hernandez', 'King', 'Wright', 'Lopez', 'Hill', 'Scott', 'Green', 'Adams', 'Baker', 'Gonzalez', 'Nelson', 'Carter', 'Mitchell', 'Perez', 'Roberts', 'Turner', 'Phillips', 'Campbell', 'Parker', 'Evans', 'Edwards', 'Collins', 'Stewart', 'Sanchez', 'Morris', 'Rogers', 'Reed', 'Cook', 'Morgan', 'Bell', 'Murphy', 'Bailey', 'Rivera', 'Cooper', 'Richardson', 'Cox', 'Howard', 'Ward', 'Torres', 'Peterson', 'Gray', 'Ramirez', 'James', 'Watson', 'Brooks', 'Kelly', 'Sanders', 'Price', 'Bennett', 'Wood', 'Barnes', 'Ross', 'Henderson', 'Cole', 'Jenkins', 'Perry', 'Powell', 'Long', 'Patterson', 'Hughes', 'Flores', 'Washington', 'Butler', 'Simmons', 'Foster', 'Gonzales', 'Bryant', 'Alexander', 'Russell', 'Griffin', 'Diaz', 'Hayes']

def get_random_name(): 
    return random.choice(first_names) + ' ' + random.choice(last_names)

first_title_parts = ['The Great', 'The Small', 'The Dirty', 'Harry Potter and the', 'The Lord of the', 'Dogs of', 'The Cat', 'The Loud', 'The Quiet', 'The Fast', 'The Slow', 'The Quick', 'The Dead', 'The Living', 'The Dying', 'The Dead', 'The Alive', 'The Dead', 'The Undead', 'Funny', 'Sad', 'Happy', 'Angry', 'The Angry', 'The Happy', 'The Sad', 'The Funny', 'The Scary', 'The Terrifying', 'The Horrifying', 'The Beautiful', 'The Ugly', 'The Pretty', 'The Handsome', 'The Smart', 'The Dumb', 'The Stupid', 'The Clever', 'The Genius', 'The Idiot', 'The Fool', 'The Wise', 'The Unwise', 'The Old', 'The Young', 'The Middle-Aged', 'The Teenage', 'The Child', 'Young', 'Old', 'Middle-Aged', 'Teenage', 'Child']
second_title_parts = ['Gatsby', 'M', 'The Rings', 'The Flies', 'Granma', 'Mom', 'Your Mum', 'Dad', 'Son', 'Daughter', 'Father', 'Mother', 'Brother', 'Sister', 'Warrior', 'Priest', 'Spiderman', 'Superman', 'Batman', 'Catwoman', 'Wonderwoman', 'Dog', 'Cat', 'Clown', 'Ghost', 'Vampire', 'Werewolf', 'Zombie', 'Alien', 'Martian', 'Jupiterian', 'Ukrainian', 'Russian', 'American', 'Canadian', 'Mexican', 'Brazilian', 'Argentinian', 'Chilean', 'Love', 'Hate', 'Friendship', 'Enmity', 'Peace', 'War', 'Life', 'Death', 'Birth', 'Rebirth', 'Destruction', 'Creation', 'Theft', 'Robbery']

def get_random_title():
    return random.choice(first_title_parts) + ' ' + random.choice(second_title_parts)

# Connect to the database
conn = psycopg2.connect(
    host="localhost",
    port="5432",
    database="books",
    user="postgres",
    password="postgres"
)
cursor = conn.cursor()

USERS_COUNT = 1000000
CATEGORIES = ["Fiction", "Non-Fiction", "Science", "Technology", "Biography", "History", "Fantasy", "Mystery", "Thriller"]

start_time = time.time()

for i in range(USERS_COUNT):
    random_name = get_random_name()
    random_title = get_random_title()
    random_category = random.choice(CATEGORIES)
    year = random.randint(1850, 2024)
    cursor.execute('INSERT INTO book (title, author, year, category) VALUES (%s, %s, %s, %s)', (random_title, random_name, year, random_category))
    if i > 0 and i % 1000 == 0:
        print(f"Inserted {i} rows")
        conn.commit()
end_time = time.time()

print(f"Inserted {USERS_COUNT} rows in {end_time - start_time} seconds")

# Commit the changes and close the connection
conn.commit()
conn.close()