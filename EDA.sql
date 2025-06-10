-- Exploratory Data analysis
select *
from layoffs_staging2;

select max(total_laid_off),min(total_laid_off)
from layoffs_staging2;

select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2;

select * 
from layoffs_staging2
where percentage_laid_off=1
order by funds_raised_millions Desc;

select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

select min(`date`),max(`date`)
from layoffs_staging2;

select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;

select location, sum(total_laid_off)
from layoffs_staging2
group by location
order by 2 desc;

select location, country, sum(total_laid_off)
from layoffs_staging2
group by location, country
order by 2 desc;

select year(`date`), sum(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by 2 desc;

select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc;

-- Rolling total of lay offs per month


select substring(`date`,1,7) as `month`, sum(total_laid_off)
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `month` 
order by 1;

with rolling_cte as
(
select substring(`date`,1,7) as `month`, sum(total_laid_off) as lay_off_in_a_month
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `month` 
order by 1
)
select `month`,lay_off_in_a_month ,
sum(lay_off_in_a_month) over(order by `month`) as rolling_total
from rolling_cte;

-- top 5 companies per year which had most lay offs
with company_year as
(
select company, year(`date`) `year`, sum(total_laid_off) lay_off_year
from layoffs_staging2
group by company, `year`
),
company_year_rank as
(
select *,
dense_rank() over(partition by `year` order by lay_off_year Desc) as ranking
from company_year
where `year` is not null
)
select *
from company_year_rank
where ranking<=5;






