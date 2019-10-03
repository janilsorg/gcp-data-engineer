SELECT
  author.email,
  diff.new_path AS path,
  DATETIME(TIMESTAMP_SECONDS(author.date.seconds)) AS date
FROM
  `bigquery-public-data.github_repos.commits`,
  UNNEST(difference) diff
WHERE
  EXTRACT(YEAR FROM TIMESTAMP_SECONDS(author.date.seconds))=2016
LIMIT 10

/*
Change diff.new_path to difference.new_path. Why does it not work? Replace difference.new_path 
by difference[OFFSET(0)].new_path. Does this work? Why? What is the UNNEST doing?

Consider the case where a filename extension identifies the programming language. So a file that ends in
".py" has the programming language "py". How could you use a regular expression to pull the extension from the path?
*/ 

SELECT
  author.email,
  LOWER(REGEXP_EXTRACT(diff.new_path, r'\.([^\./\(~_ \- #]*)$')) AS lang,
  diff.new_path AS path,
  TIMESTAMP_SECONDS(author.date.seconds) AS author_timestamp
FROM
  `bigquery-public-data.github_repos.commits`,
  UNNEST(difference) diff
WHERE
  EXTRACT(YEAR FROM TIMESTAMP_SECONDS(author.date.seconds))=2016
LIMIT
  10

/*
Modify the query above to only use lang and has a length that is fewer than 8 characters.
Modify the query above to group by language and list in descending order of the number of commits
*/
WITH commits AS (
  SELECT
    author.email,
    LOWER(REGEXP_EXTRACT(diff.new_path, r'\.([^\./\(~_ \- #]*)$')) lang,
    diff.new_path AS path,
    TIMESTAMP_SECONDS(author.date.seconds) AS author_timestamp
  FROM
    `bigquery-public-data.github_repos.commits`,
    UNNEST(difference) diff
  WHERE
    EXTRACT(YEAR FROM TIMESTAMP_SECONDS(author.date.seconds))=2016 )
SELECT
  lang,
  COUNT(path) AS numcommits
FROM
  commits
WHERE
  LENGTH(lang)<8
  AND lang IS NOT NULL
GROUP BY
  lang
HAVING
  numcommits > 100
ORDER BY
  numcommits DESC

/*
Group the commits based on whether or not they happened on a weekend. How would you do it?
Modify the previous query to extract the day of the week from author.date. Days 2 to 6 are weekdays.
*/
WITH commits AS (
  SELECT
    author.email,
    EXTRACT(DAYOFWEEK
    FROM
      TIMESTAMP_SECONDS(author.date.seconds)) BETWEEN 2
    AND 6 is_weekday,
    LOWER(REGEXP_EXTRACT(diff.new_path, r'\.([^\./\(~_ \- #]*)$')) lang,
    diff.new_path AS path,
    TIMESTAMP_SECONDS(author.date.seconds) AS author_timestamp
  FROM
    `bigquery-public-data.github_repos.commits`,
    UNNEST(difference) diff
  WHERE
    EXTRACT(YEAR
    FROM
      TIMESTAMP_SECONDS(author.date.seconds))=2016)
SELECT
  lang,
  is_weekday,
  COUNT(path) AS numcommits
FROM
  commits
WHERE
  lang IS NOT NULL
GROUP BY
  lang,
  is_weekday
HAVING
  numcommits > 100
ORDER BY
  numcommits DESC

/*Ignoring file extensions that do not correspond to programming languages, it appears that the most popular 
weekend programming languages are JavaScript, PHP and C (*.h is the C header file), Java, and Python.

This lab is based on an article by Felipe Hoffa: The top weekend programming languages according to GitHub's code
https://medium.com/@hoffa/the-top-weekend-languages-according-to-githubs-code-6022ea2e33e8#.8oj2rp804
*/
