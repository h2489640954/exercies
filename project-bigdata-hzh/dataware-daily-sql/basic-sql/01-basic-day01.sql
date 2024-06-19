
-- 创建数据库
CREATE DATABASE IF NOT EXISTS hive_sql_zg5;
-- 使用数据库
USE hive_sql_zg5 ;

/*
数据分析中，数据调研：数据有哪些（表有哪些，如何产生的数据，核心数据：业务过程）
    course_info 课程表
    student_info 学生表
    teacher_info 教师表
        维度表，环境
    score_info  成绩表
        事实表，学生学习某个课程，并且考试产生的数据
		分析数据，往往分析就是事实表的数据，此处就是score_info表
*/

-- todo: 1.1、简单查询
-- 1）、检索课程编号为“04”且分数小于60的学生的课程信息，结果按分数降序排列；
with tmp1 as  (
    SELECT  course_id
    , score
    , stu_id
    from hive_sql_zg5.score_info
    where course_id='04'
    and score<60
)
SELECT stu_id
     , course_info.course_id
     , course_name
     , score
FROM hive_sql_zg5.course_info
left join tmp1
where tmp1.course_id=course_info.course_id
order by tmp1.score;
-- 2）、查询数学成绩不及格的学生和其对应的成绩，按照学号升序排序；
-- 2.1 数学科目编号
-- 2.2 找到数学成绩不及格学生
with tmp1 as (SELECT course_id
                   , course_name
FROM hive_sql_zg5.course_info
where course_name='数学')
SELECT stu_id,course_name,score
FROM hive_sql_zg5.score_info
inner join tmp1
where score_info.course_id=tmp1.course_id
and score<60
order by stu_id;
-- 3）、查询姓名中带“冰”的学生名单；
SELECT stu_id
       , stu_name
from hive_sql_zg5.student_info
where stu_name like '%冰%';
-- 4）、查询姓“王”老师的个数；
SELECT tea_id
     , tea_name
from hive_sql_zg5.teacher_info
where tea_name like '王%';
-- todo：1.2、汇总分析
/*
	SQL分析中，5个基本聚合函数使用
		count 计数
		sum 求和
		avg 均值
		max 最大
		min 最小
*/
-- 1）、查询编号为“02”的课程的总成绩；
SELECT course_id
     , sum(score) as course_sum
FROM hive_sql_zg5.score_info
where course_id='02'
group by course_id;
-- 2）、查询参加考试的学生个数；
EXPLAIN SELECT count(stu_id) as stu_count
FROM (SELECT stu_id
    FROM hive_sql_zg5.score_info
      group by stu_id) as tmp1;