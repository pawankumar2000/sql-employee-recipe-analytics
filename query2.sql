create database workato2;
use workato2;

-- 1) Receipes Table - 

-- | Column                | Type     | Notes                             |
-- | --------------------- | -------- | --------------------------------- |
-- | `id`                  | INT (PK) | Unique recipe ID                  |
-- | `user_id`             | INT (FK) | Links to `users` table            |
-- | `version_no`          | INT      | Version                           |
-- | `name`                | TEXT     | Name of the recipe                |
-- | `description`         | TEXT     | Description                       |
-- | `created_at`          | DATETIME | Creation time                     |
-- | `updated_at`          | DATETIME | Update time                       |
-- | `runnable`            | BOOLEAN  | Is it ready to run?               |
-- | `running`             | BOOLEAN  | Is it currently running?          |
-- | `parent_id`           | INT      | `NULL` = original, value = cloned |
-- | `job_succeeded_count` | INT      | Jobs that succeeded               | 
-- | `job_failed_count`    | INT      | Jobs that failed                  |

create table Recipes(
id int primary key,
user_id int not null,
version_no int not null,
name varchar(50),
description varchar(200),
created_at date,
updated_at date,
runnable boolean,
running boolean,
parent_id int,
job_succeeded_count int,
job_failed_count int,
foreign key (user_id) references Users(user_id)
);

-- 2) Users Table -
--  
-- | Column    | Type | Notes   |
-- | --------- | ---- | ------- |
-- | `user_id` | INT  | User ID |

create table Users(
user_id int primary key
);

-- 3) recipe_applications -

-- | Column        | Type |
-- | ------------- | ---- |
-- | `recipe_id`   | INT  |
-- | `application` | TEXT |

create table recipe_applications(
recipe_id int primary key,
application varchar(100)
);

-- 4) recipe_categories - 

-- | Column      | Type |
-- | ----------- | ---- |
-- | `recipe_id` | INT  |
-- | `category`  | TEXT |

create table recipe_categories(
recipe_id int primary key,
category varchar(100)
);


-- 5) Business_objects - 

-- | Column        | Type |
-- | ------------- | ---- |
-- | `recipe_id`   | INT  |
-- | `object_name` | TEXT |

create table Business_objects(
recipe_id int primary key,
object_name varchar(100)
);

-- 1) List all users who have active recipes using applications A, B, C, and D 
select distinct r.user_id
from recipes r
join recipe_applications ra on r.id = ra.recipe_id
where r.running = TRUE
  and ra.application in ('A', 'B', 'C', 'D')
group by r.id, r.user_id
having COUNT(distinct ra.application) = 4;

-- 2) What % of currently active recipes are cloned vs originals?
-- considering clone as whose parent_id is not null
-- and original as whose parent id is null
select
  round(sum(case when parent_id is null then 1 else 0 end) * 100.0 / COUNT(*), 2) as original,
  round(sum(case when parent_id is not null then 1 else 0 end) * 100.0 / COUNT(*), 2) as cloned
from recipes
where running = true;

-- 3) How has the number of recipes grown across different categories?
-- assuming created_at is used to track the growth over time (monthly)
select
  rc.category,
  date_format(r.created_at, '%Y-%m') as month,
  count(*) as recipe_count
from recipes r
join recipe_categories rc on r.id = rc.recipe_id
group by rc.category, date_format(r.created_at, '%Y-%m')
order by rc.category, month;

-- 4) How does the recipe count distribution look by number of applications used?
select
  app_count,
  COUNT(*) as recipe_count
from (
  select r.id, count(distinct ra.application) as app_count
  from recipes r
  join recipe_applications ra on r.id = ra.recipe_id
  group by r.id
) sub
group by app_count
order by app_count;
