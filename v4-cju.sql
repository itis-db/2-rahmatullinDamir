with cte AS (
    select userprofileid from userorder WHERE userprofileid BETWEEN 1 AND 20
) select * from cte JOIN profile ON cte.userprofileid = profile.id;


with cte AS (
    select productid from productorder WHERE productid BETWEEN 1 AND 20
) select description, profile.name from cte JOIN product ON product.id = cte.productid JOIN profile ON profile.id = productid;

with cte AS (
    select description from product WHERE id BETWEEN 1 AND 20
) select * FROM cte UNION select name from profile;

with recursive cte AS (
    SELECT 1

) select * from cte;