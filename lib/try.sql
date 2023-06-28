CREATE TABLE IF NOT EXISTS 'Users'(
    'id' INTEGER PRIMARY KEY AUTOINCREMENT,
    'name' TEXT,
    'email' TEXT,
    'password' TEXT,
    'created_at' DATETIME DEFAULT CURRENT_TIMESTAMP
)

CREATE TABLE IF NOT EXISTS 'Transactions'(
  "id" INTEGER PRIMARY KEY AUTOINCREMENT,
  "user_id" INTEGER FOREIGN KEY REFERENCES 'Users'('id'),
    "amount" INTEGER,
    "type" TEXT,
    "created_at" DATETIME DEFAULT CURRENT_TIMESTAMP

)

CREATE TABLE IF NOT EXISTS 'Referrals'(
  "id" INTEGER PRIMARY KEY AUTOINCREMENT,
  "user_id" INTEGER FOREIGN KEY REFERENCES 'Users'('id'),
    "referral_id" INTEGER FOREIGN KEY REFERENCES 'Users'('id'),
    "created_at" DATETIME DEFAULT CURRENT_TIMESTAMP

)

CREATE TABLE IF NOT EXIST 'Sales'(
  "id" INTEGER PRIMARY KEY AUTOINCREMENT,
  "user_id" INTEGER FOREIGN KEY REFERENCES 'Users'('id'),
    "description" TEXT,
    "created_at" DATETIME DEFAULT CURRENT_TIMESTAMP
)

CREATE TABLE IF NOT EXISTS 'Commission_Rate'(
  "id" INTEGER PRIMARY KEY AUTOINCREMENT,
  "sales_id" INTEGER FOREIGN KEY REFERENCES 'Sales'('id'),
    "amount" FLOAT,
    "created_at" DATETIME DEFAULT CURRENT_TIMESTAMP
)
CREATE TABLE IF NOT EXISTS 'Lessons'(
"id" INTEGER PRIMARY KEY AUTOINCREMENT,
"name" TEXT,
"description" TEXT,
"estimated_time" DATETIME,
"progress_id" INTEGER FOREIGN KEY REFERENCES 'Progress'('id'),
"status" TEXT,
"created_at" DATETIME DEFAULT CURRENT_TIMESTAMP
)
CREATE TABLE IF NOT EXISTS 'Lesson_Lists'(
"id" INTEGER PRIMARY KEY AUTOINCREMENT,
"name" TEXT,
"lesson_id" INTEGER FOREIGN KEY REFERENCES 'Lessons'('id'),
"description" TEXT,
"estimated_time" DATETIME,
"status" TEXT,
"created_at" DATETIME DEFAULT CURRENT_TIMESTAMP
)

CREATE TABLE IF NOT EXISTS 'Progress'(
"id" INTEGER PRIMARY KEY AUTOINCREMENT,
"user_id" INTEGER FOREIGN KEY REFERENCES 'Users'('id'),
"lesson_id" INTEGER FOREIGN KEY REFERENCES 'Lessons'('id'),
)
CREATE TABLE IF NOT EXISTS 'Users'(
"id" INTEGER PRIMARY KEY AUTOINCREMENT,
"name" TEXT,
"email" TEXT,
"password" TEXT,
"created_at" DATETIME DEFAULT CURRENT_TIMESTAMP
)

)
```
I have tried this query but it doesn't work

```
CREATE VIEW IF NOT EXISTS 'ReferralTree' AS
WITH RECURSIVE ReferralTree(id, user_id, referral_id, created_at) AS (
  SELECT id, user_id, referral_id, created_at
  FROM Referrals
  UNION ALL
  SELECT Referrals.id, Referrals.user_id, Referrals.referral_id, Referrals.created_at
  FROM Referrals
  JOIN ReferralTree ON Referrals.referral_id = ReferralTree.user_id
)
SELECT * FROM ReferralTree

CREATE TABLE IF NOT EXISTS 'Lesson_List_Items'(
"id" INTEGER PRIMARY KEY AUTOINCREMENT,
"lesson_list_id" INTEGER FOREIGN KEY REFERENCES 'Lesson_Lists'('id'),
"lesson_id" INTEGER FOREIGN KEY REFERENCES 'Lessons'('id'),
"created_at" DATETIME DEFAULT CURRENT_TIMESTAMP
)

CREATE TABLE IF NOT EXISTS Lessons (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    course_id INTEGER,
    name TEXT,
    description TEXT,
    estimated_time DATETIME,
    status TEXT,
    FOREIGN KEY (course_id) REFERENCES Courses(id),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS Lesson_Lists (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    lesson_id INTEGER,
    name TEXT,
    description TEXT,
    status TEXT,
    FOREIGN KEY (lesson_id) REFERENCES Lessons(id),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS Lesson_Tags (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    lesson_id INTEGER,
    tag TEXT,
    FOREIGN KEY (lesson_id) REFERENCES Lessons(id)
);

CREATE TABLE IF NOT EXISTS Lesson_Comments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    lesson_id INTEGER,
    user_id INTEGER,
    comment TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (lesson_id) REFERENCES Lessons(id),
    FOREIGN KEY (user_id) REFERENCES Users(id)
);

CREATE TABLE IF NOT EXISTS Progress (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    lesson_id INTEGER,
    course_id INTEGER,
    completed_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (lesson_id) REFERENCES Lessons(id)
    FOREIGN KEY (course_id) REFERENCES Courses(id)
);

CREATE TABLE IF NOT EXISTS Users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    email TEXT,
    password TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS 'Courses'(   
"id" INTEGER PRIMARY KEY AUTOINCREMENT,
"name" TEXT 
)


CREATE TABLE IF NOT EXISTS 'Progress'(

)