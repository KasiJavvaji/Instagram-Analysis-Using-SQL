/*We want to reward our users who have been around the longest.*/

select * from users
order by created_at asc
limit 10

/*What day of the week do most users register on? We need to figure out when to schedule an ad campgain*/

SELECT TO_CHAR(created_at, 'Day') AS "day of the week", COUNT(*) AS "total registration"
FROM users
GROUP BY 1
ORDER BY 2 DESC;

/*We want to target our inactive users with an email campaign.
Find the users who have never posted a photo*/

select distinct username
from users
left join photos
on users.id = photos.user_id
where users.id not in (select user_id from photos)


/*Our Investors want to know...
How many times does the average user post?*/
/*total number of photos/total number of users*/


SELECT ROUND((SELECT COUNT(*)FROM photos)/(SELECT COUNT(*) FROM users),2);


/*user ranking by postings higher to lower*/

SELECT users.username,COUNT(photos.image_url)
FROM users
JOIN photos ON users.id = photos.user_id
GROUP BY users.id
ORDER BY 2 DESC;

/*total numbers of users who have posted at least one time */

select count(distinct(users.id))
from users
join photos
on users.id = photos.user_id
--where users.id not in (select user_id from photos)

/*A brand wants to know which hashtags to use in a post
What are the top 5 most commonly used hashtags?*/

SELECT tag_name, COUNT(tag_name) AS total
FROM tags
JOIN photo_tags ON tags.id = photo_tags.tag_id
GROUP BY tags.id
ORDER BY total DESC
limit 5


/*Find the percentage of our users who have either never commented on a photo or have commented on photos before*/


SELECT tableA.total_A AS "Number Of Users who never commented",
		(tableA.total_A/(SELECT COUNT(*) FROM users))*100 AS "%",
		tableB.total_B AS "Number of Users who commented on photos",
		(tableB.total_B/(SELECT COUNT(*) FROM users))*100 AS "%"
FROM
	(
		SELECT COUNT(*) AS total_A FROM
			(SELECT username,comment_text
				FROM users
				LEFT JOIN comments ON users.id = comments.user_id
				GROUP BY users.id
				HAVING comment_text IS NULL) AS total_number_of_users_without_comments
	) AS tableA
	JOIN
	(
		SELECT COUNT(*) AS total_B FROM
			(SELECT username,comment_text
				FROM users
				LEFT JOIN comments ON users.id = comments.user_id
				GROUP BY users.id
				HAVING comment_text IS NOT NULL) AS total_number_users_with_comments
	)AS tableB

/*We're running a new contest to see who can get the most likes on a single photo.
WHO WON??!!*/

SELECT users.username,photos.id,photos.image_url,COUNT(*) AS Total_Likes
FROM likes
JOIN photos ON photos.id = likes.photo_id
JOIN users ON users.id = likes.user_id
GROUP BY photos.id,users.username
ORDER BY Total_Likes DESC
LIMIT 1;