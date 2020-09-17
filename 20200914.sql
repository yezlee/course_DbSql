CID - Customer ID
CNM - Customer NAME

SELECT *
FROM customer;

product : 제품
pid : product id : 제품 번호
pnm : product name : 제품 이름

SELECT *
FROM product;

cycle : 고객 애음 주기
cid : customer id 
pid : product id
day : 1-7(일 - 토)
cnt : count 수량

SELECT *
FROM cycle;


문제 join4
오라클
SELECT customer.*, cycle.pid, cycle.day, cycle.cnt
FROM customer, cycle
WHERE customer.cid = cycle.cid
    AND cnm IN('brown', 'sally');

SELECT customer.cid, customer.cnm, cycle.pid, cycle.day, cycle.cnt
FROM customer JOIN cycle ON (customer.cid = cycle.cid)
WHERE cnm IN('brown', 'sally');


-- 아래 두개는 헷갈리면 안해도 됨.
SELECT cid, cnm, cycle.pid, cycle.day, cycle.cnt
FROM customer JOIN cycle USING (cid)
WHERE cnm IN('brown', 'sally');

ANSI-SQL
SELECT cid, cnm, cycle.pid, cycle.day, cycle.cnt
FROM customer NATURAL JOIN cycle
WHERE cnm IN('brown', 'sally');




문제 join5 - customer, cycle, product 테이블 조합해서
--내가 적은 답
SELECT customer.cid, customer.cnm, cycle.pid, product.pnm, cycle.day, cycle.cnt
FROM customer JOIN cycle ON (customer.cid = cycle.cid) 
              JOIN product ON (cycle.pid = product.pid)
WHERE  customer.cid = cycle.cid AND cycle.pid = product.pid AND cnm IN('brown', 'sally');

SELECT customer.*, cycle.pid, product.pnm, cycle.day, cycle.cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid AND cycle.pid = product.pid AND cnm IN('brown', 'sally');


--수업
SELECT a.cid, a.cnm, a.pid, product.pnm, a.day, a.cnt
FROM (SELECT customer.*, cycle.pid, cycle.day, cycle.cnt
      FROM customer, cycle
      WHERE customer.cid = cycle.cid AND cnm IN('brown', 'sally')) a, product
WHERE a.pid = product.pid;


SQL : 실행에 대한 순서가 없다. 조인할 테이블에 대해서 from절에 기술한 순으로
테이블을 읽지 않음.
(FROM customer, cycle, product ==> 오라클에서는 product 테이블부터 읽을수도 있다.)

EXPLAIN PLAN FOR --실행이 어디서부터 된건지 확인하기 위해 실행계획
SELECT customer.cid, customer.cnm, cycle.pid, product.pnm, cycle.day, cycle.cnt
FROM customer, cycle, product  --실행계획 돌려보면 사이클 - 커스터머 - 프로덕트.. 이런식임
WHERE customer.cid = cycle.cid
    AND cycle.pid = product.pid
    AND cnm IN('brown', 'sally');
    
SELECT *
FROM TABLE(dbms_xplan.display);    

--위에 explain plan for부터 실행하고 그 아래 테이블 돌리면 plan table output이 나온다.
Plan hash value: 3215896897
 
----------------------------------------------------------------------------------------------
| Id  | Operation                      | Name        | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT               |             |    10 |  1320 |     3   (0)| 00:00:01 |
|   1 |  NESTED LOOPS                  |             |       |       |            |          |
|   2 |   NESTED LOOPS                 |             |    10 |  1320 |     3   (0)| 00:00:01 |
|   3 |    NESTED LOOPS                |             |    10 |   920 |     3   (0)| 00:00:01 |
|   4 |     TABLE ACCESS FULL          | CYCLE       |    15 |   780 |     3   (0)| 00:00:01 |
|*  5 |     TABLE ACCESS BY INDEX ROWID| CUSTOMER    |     1 |    40 |     0   (0)| 00:00:01 |
|*  6 |      INDEX UNIQUE SCAN         | PK_CUSTOMER |     1 |       |     0   (0)| 00:00:01 |
|*  7 |    INDEX UNIQUE SCAN           | PK_PRODUCT  |     1 |       |     0   (0)| 00:00:01 |
|   8 |   TABLE ACCESS BY INDEX ROWID  | PRODUCT     |     1 |    40 |     0   (0)| 00:00:01 |
----------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   5 - filter("CNM"='brown' OR "CNM"='sally')
   6 - access("CUSTOMER"."CID"="CYCLE"."CID")
   7 - access("CYCLE"."PID"="PRODUCT"."PID")
 
Note
-----
   - dynamic sampling used for this statement (level=2)



문제 join 6-13 과제
JOIN6 
답
SELECT cycle.cid, customer.cnm, product.pid, product.pnm, SUM(cycle.cnt) cnt
FROM customer JOIN cycle ON (customer.cid = cycle.cid) 
              JOIN product ON (cycle.pid = product.pid)
GROUP BY cycle.cid, customer.cnm, product.pid, product.pnm, cycle.cnt
ORDER BY cycle.cid;

칠거지악중 하나(위에 오더바이랑 그룹바이랑 같이 못쓰면 인라인뷰를 써도 답이 나오는데 하지만 인라인뷰를 안써도 되는 상황이면 쓰지마라)
1. 정답 조회하는 쿼리 작성
2. SQL에 불필요한 부분이 없는지 점검


--내가 처음에 시도했던
SELECT a.*, SUM(pnm)
FROM (SELECT customer.*, cycle.pid, product.pnm, cycle.cnt
      FROM customer JOIN cycle ON (customer.cid = cycle.cid) 
      JOIN product ON (cycle.pid = product.pid)
      WHERE  customer.cid = cycle.cid AND cycle.pid = product.pid)a
GROUP BY pnm;
--


문제 join7
SELECT product.pid, product.pnm, SUM(cycle.cnt)
FROM cycle JOIN product ON (cycle.pid = product.pid)
GROUP BY product.pid, product.pnm
ORDER BY product.pid;

--여기다가 제품명만 붙여준게 7번답
SELECT pid, SUM(cnt)
FROM cycle
GROUP BY pid;

--7번 푸는데 이거하면 pid값에 100이 두개 나옴???
SELECT cycle.pid, product.pnm, SUM(cycle.cnt)
FROM cycle, product
WHERE cycle.pid = product.pid
GROUP BY cycle.pid, product.pnm, cycle.cnt
ORDER BY product.pnm;
-----

JOIN8
SELECT c.region_id, region_name, country_name 
FROM regions r JOIN countries c ON (r.region_id = c.region_id)
WHERE region_name = 'Europe';

JOIN9
SELECT c.region_id , region_name, country_name, city
FROM countries c JOIN regions r ON(c.region_id = r.region_id)
     JOIN locations l ON( c.country_id = l.country_id)
WHERE region_name = 'Europe';

JOIN10
SELECT c.region_id , region_name, country_name, city, department_name
FROM countries c JOIN regions r ON(c.region_id = r.region_id)
     JOIN locations l ON( c.country_id = l.country_id)
     JOIN departments d ON(l.location_id = d.location_id)
WHERE region_name = 'Europe';


JOIN11
SELECT c.region_id , region_name, country_name, city, department_name,CONCAT(first_name, last_name) name
FROM countries c JOIN regions r ON(c.region_id = r.region_id)
     JOIN locations l ON( c.country_id = l.country_id)
     JOIN departments d ON(l.location_id = d.location_id)
     JOIN employees e ON(d.department_id = e.department_id)
WHERE region_name = 'Europe';

JOIN12
SELECT employee_id, CONCAT(first_name, last_name) name, e.job_id, job_title
FROM employees e JOIN jobs j ON(e.job_id = j.job_id);

JOIN13
SELECT e.employee_id mgr_id, CONCAT(e.first_name, e.last_name) mgr_name
       ,m.employee_id, CONCAT(m.first_name, m.last_name) name , j.job_id, job_title
FROM employees m JOIN employees e ON(m.manager_id = e.employee_id)
     JOIN jobs j ON(m.job_id = j.job_id);


--
SELECT customer.cid, customer.cnm, cycle.pid, product.pnm, cycle.day, cycle.cnt
FROM customer JOIN cycle ON (customer.cid = cycle.cid) 
              JOIN product ON (cycle.pid = product.pid)
WHERE  customer.cid = cycle.cid AND cycle.pid = product.pid AND cnm IN('brown', 'sally');

SELECT customer.*, cycle.pid, product.pnm, cycle.day, cycle.cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid AND cycle.pid = product.pid AND cnm IN('brown', 'sally');
--






OUTER JOIN : 자주 쓰이지는 않지만 중요   
JOIN 구분
1. 문법에 따른 구분 : ANSI-SQL, ORACLE
2. join의 형태에 따른 구분 : SELF-JOIN, NONEQUI-JOIN, CROSS-JOIN
3. join 성공 여부에 따라 데이터 표시여부 
        : INNER JOIN - 조인이 성공했을 때 데이터를 표시
        : OUTER JOIN - 조인이 실패해도 기준으로 정한 테이블의 컬럼 정보는 표시
--조인할때 null은 무시당해. outer join 을 쓰면 나와


사번, 사원의 이름, 관리자 사번, 관리자 이름
이렇게 4개가 조회가 되게끔 (데이터결합 p.201)
==> king의 경우 mgr 컬럼의 값이 null이기 때문에 조인에 실패 -> 13건만 조회
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e , emp m
WHERE e.mgr = m.empno; -- 사원쪽에 있는 매니저의 정보를 읽어야하니까 이걸 잘해야함
        
ANSI-SQL        
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e JOIN emp m ON (e.mgr = m.empno); ******************************************************이거 다시 이해하기!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

ANSI-SQL --위아래 결과 같음
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno); -- 왼쪽에 있는 데이터를 기준으로 조인에 실패해도 나와

SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp m RIGHT OUTER JOIN emp e ON (e.mgr = m.empno); --위아래 결과 같음

SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno); 


ORACLE-SQL --안시에선 오라클에 표현안되는게있어
 : 데이터가 없는 쪽의 칼럼에 (+) 기호를 붙인다
   ANSI-SQL 기준 테이블 반대편 테이블의 컬럼에 (+)을 붙인다.
   WHERE절 연결 조건에 적용
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e , emp m
WHERE e.mgr = m.empno(+);
--where절안에 and 쓸때도 반대편 테이블에 플러스 다 붙여줘야해. 안붙이면 안시이너 조인 된것처럼 됨. 


행에 대한 제한 조건 기술시 WHERE절에 기술했을 때와 ON절에 기술했을 때 결과가 다르다.

사원의 부서가 10번인 사람들만 조회 되도록 부서 번호 조건을 추가
SELECT e.empno, e.ename, e.deptno, e.mgr, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno AND e.deptno = 10);

조건을 WHERE 절에 기술한 경우 ==> 결과적으로 얘는 OUTER JOIN이 아닌거, INNER JOIN의 결과가 나온다.
SELECT e.empno, e.ename, e.deptno, e.mgr, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno)
WHERE e.deptno = 10;

근데 얘는 킹이 빠짐.
SELECT e.empno, e.ename, e.deptno, e.mgr, m.ename, m.deptno
FROM emp e JOIN emp m ON (e.mgr = m.empno)
WHERE e.deptno = 10;


SELECT e.empno, e.ename, e.mgr, m.empno, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON ( e.mgr = m.empno); --눌이 뜬 8명은 누군가의 매니저가 아니란뜻.



UNION 합집합 개념
-- 행이 같아야함, 행이 다르면 에러뜸
SELECT e.ename, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno)
UNION
SELECT e.ename, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno);

공집합?
SELECT e.ename, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno)
UNION
SELECT e.ename, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno)
MINUS
SELECT e.ename, m.ename
FROM emp e FULL OUTER JOIN emp m ON (e.mgr = m.empno);

이건 완벽하게 위아래가 똑같을때???????
SELECT e.ename, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno)
UNION
SELECT e.ename, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno)
INTERSECT
SELECT e.ename, m.ename
FROM emp e FULL OUTER JOIN emp m ON (e.mgr = m.empno);


문제 OUTERJOIN 1
SELECT *
FROM buyprod
WHERE BUY_DATE = TO_DATE('2005/01/25', 'YYYY/MM/DD');

SELECT *
FROM prod;

--3개의 결과만 나옴
SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b JOIN prod p ON (b.buy_prod = p.prod_id)
WHERE BUY_DATE = TO_DATE('2005/01/25', 'YYYY/MM/DD');

ansi 답
SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b RIGHT OUTER JOIN prod p 
ON (b.buy_prod = p.prod_id) AND B.BUY_DATE = TO_DATE('2005/01/25', 'YYYY/MM/DD');




--답
단계1.
SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b , prod p
WHERE b.buy_prod = p.prod_id AND BUY_DATE = TO_DATE('2005/01/25', 'YYYY/MM/DD');

오라클에서는 데이터가 나와야하는데 안나오는쪽 즉 b 쪽에 플러스를 붙여주면돼
지금 buy_date랑 buy_prod, buy_qty가 안나오니깐 그쪽에 플러스를 붙여줘야함



단계2.
SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b , prod p
WHERE b.buy_prod (+) = p.prod_id 
  AND b.BUY_DATE (+) = TO_DATE('2005/01/25', 'YYYY/MM/DD');


SELECT *
FROM buyprod;

SELECT *
FROM prod;




문제 OUTERJOIN 5

SELECT cid,cnm
FROM
WHERE

ANSI-SQL
SELECT p.pid, pnm,  nvl(c.cid,1), nvl(cnm,'brown'), nvl(day,0) day, nvl(cnt,0) cnt
FROM cycle c RIGHT OUTER JOIN product p ON(c.pid = p.pid AND  c.cid = 1)
             LEFT OUTER JOIN customer t ON(c.cid = t.cid)
ORDER BY p.pid DESC, day DESC;

ORACLE-SQL
SELECT p.pid, pnm,  nvl(c.cid,1), nvl(cnm,'brown'), nvl(day,0) day, nvl(cnt,0) cnt
FROM cycle c , product p, customer t
WHERE c.pid(+) = p.pid AND c.cid = t.cid(+) AND c.cid(+) = 1
ORDER BY p.pid DESC, day DESC;
