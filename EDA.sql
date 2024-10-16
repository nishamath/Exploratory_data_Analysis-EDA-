-- EXPLORATORY DATA ANALYSIS --

select * from layoffs_staging2;


select max(total_laid_off)
from layoffs_staging2;

select max(total_laid_off),max(percentage_laid_off) from layoffs_staging2;

-- checking which company would have the largest fund raised--

select * from layoffs_staging2 where
percentage_laid_off=1 order by funds_raised_millions desc ;


---  companys with the biggest single  lay_off --

select company,sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

select min(`date`),max(`date`)
from layoffs_staging2;

-- checking which industy,Country ,year got hit the maximum duting covid time --
select industry,sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;


select * from layoffs_staging2;


select country,sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;


select year(`date`), sum(total_laid_off)
from layoffs_staging2
group by `date`
order by 1 desc;

select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 1 desc;



select stage, sum(percentage_laid_off)
from layoffs_staging2
group by stage
order by 2 desc;

-- FINDING ROLLING TOTAL LAYOFFS --

select substring (`date`,1,7) as `month`,sum(total_laid_off) as total_off
from layoffs_staging2
group by `month` 
order by 1 asc;

with rolling_total as
(select substring (`date`,1,7) as `MONTH`,sum(total_laid_off) as total_off
from layoffs_staging2
group by `MONTH` 
order by 1 asc)


select `MONTH`,sum(total_off)over(order by `MONTH`)as rolling_total
 from layoffs_staging2;


select `MONTH`,total_off,
sum(total_laid_off) over (order by`MONTH`) as rolling_total from 
rolling_total;


select company,year(`date`),sum(total_laid_off)
from layoffs_staging2
group by company,year (`date`);



select company,year(`date`),sum(total_laid_off)
from layoffs_staging2
group by company,year (`date`)
order by 3 desc;


-- Earlier we looked at Companies with the most Layoffs. Now let's look at that per year. It's a little more difficult.
-- I want to look at 

WITH Company_Year AS 
(
  SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
  FROM layoffs_staging2
  GROUP BY company, YEAR(date)
)
, Company_Year_Rank AS (
  SELECT company, years, total_laid_off, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
  FROM Company_Year
)
SELECT company, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;



