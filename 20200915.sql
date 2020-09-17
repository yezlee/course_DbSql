outer join1 답
SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b , prod p
WHERE b.buy_prod (+) = p.prod_id 
  AND b.BUY_DATE (+) = TO_DATE('2005/01/25', 'YYYY/MM/DD');
  
outer join 문제2 답
SELECT TO_DATE(:yyyymmdd,'YYYY/MM/DD') buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b , prod p
WHERE b.buy_prod (+) = p.prod_id 
AND b.BUY_DATE (+) = TO_DATE('2005/01/25', 'YYYY/MM/DD');

문제3
SELECT TO_DATE(:yyyymmdd,'YYYY/MM/DD') buy_date, b.buy_prod, p.prod_id, p.prod_name, NVL(b.buy_qty,0)
FROM buyprod b , prod p
WHERE b.buy_prod (+) = p.prod_id 
AND b.BUY_DATE (+) = TO_DATE(:yyyymmdd, 'YYYY/MM/DD');


문제4 
--내가시도
SELECT product.pid pid, pnm, NVL(cid, cycle.cid) cid, NVL(day, 0) day, NVL(cnt, 0) cnt
FROM cycle, product
WHERE cycle.pid(+)  = product.pid AND cycle.cid (+)= 1;

--답
SELECT NVL(cycle.pid, product.pid) pid, pnm, NVL(cid, cycle.cid) cid, NVL(day, 0) day, NVL(cnt, 0) cnt
FROM cycle, product
WHERE cycle.pid(+)  = product.pid AND cycle.cid (+)= :cid;

문제5 과제

문제 OUTERJOIN 5
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


---진도

INNER JOIN : 조인이 성공하는 데이터만 조회가 되는 조인 방식
OUTER JOIN : 조인에 실패해도 기준으로 정한 테이블의 컬럼은 조회가 되는 조인 방식

SELECT *
FROM emp, dept; --cross join 의도치않게 해봄 
--스미스 하나만 검색하면 dept에선 4개의 데이터가 뜸 부서의 넘버에 4개의 데이터가 뜨니까
SELECT *
FROM emp CROSS JOIN dept; -- 위에랑 같은거야


문제 crossjoin 1
SELECT *
FROM customer CROSS JOIN product; --이거나 comma나 똑같음






--새로운거 굉장히 중요하고 어렵..
SQL 활용에 있어서 매우 중요
서브쿼리 : 쿼리안에서 실행되는 쿼리
1. 서브쿼리 분류 - 서브쿼리가 사용되는 위치에 따른 분류
    1.1 SELECT : 스칼라 서브쿼리(SCALAR SUBQUERY) - 얘가 중요
    1.2 FROM : 인라인 뷰(INLINE-VIEW)
    1.3 WHERE : 서브쿼리(SUB QUERY)
                                (행1, 행 여러개), (컬럼1, 컬럼 여러개)
2. 서브쿼리 분류 : 서브쿼리가 반환하는 행, 컬럼의 개수의 따른 분류
(행1, 행 여러개), (컬럼1, 컬럼 여러개) :
(행, 컬럼) : 총 4가지가 나옴 -- 이건 안 외워도 돼. 의식해서 쓴다기보단 쓰다보면 외워져
    2.1 : 단일행, 단일 컬럼 
    2.2 : 단일행, 복수 컬럼 ==> X 안씀
    2.3 : 복수행, 단일 컬럼
    2.4 : 복수행, 복수 컬럼 
    
3. 서브쿼리 분류 - 메인쿼리의 컬럼을 서브쿼리에서 사용여부에 따른 분류    
    3.1 상호 연관 서브 쿼리(CO-RELATED SUBQUERY)
        - 메인 쿼리의 컬럼을 서브 쿼리에서 사용하는 경우
    3.2 비상호 연관 서브 쿼리(NON-CORELATED SUBQUERY)
        - 메인 쿼리의 컬럼을 서브 쿼리에서 사용하지 않는 경우

SMITH가 속한 부서에 속한 사원들은 누가 있을까?
이 문제를 풀기 위해선 2가지를 알아야한다.
1. SMITH가 속한 부서번호 구하기
2. 1번에서 구한 부서에 속해있는 사원들 구하기

1.  SELECT deptno
    FROM emp
    WHERE ename = 'SMITH';
2.  SELECT *
    FROM emp
    WHERE deptno = 20;
    
==> 서브쿼리를 이용하여 하나로 합칠수가 있다.
SELECT *
FROM emp
WHERE deptno = (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH');
                
서브쿼리를 사용할 때 주의점
1. 연산자
2. 서브쿼리의 리턴 형태

서브쿼리가 한개의 행 복수컬럼을 조회하고, 단일 컬럼과 = 비교하는 경우 안됨 ==> X

만약에
SELECT *
FROM emp
WHERE deptno  = (SELECT deptno, empno
                FROM emp
                WHERE ename = 'SMITH');
서브쿼리를 이렇게 하면 단일행에 복수컬럼. 그래서 전체 조회하면 실행 안됨.


서브쿼리가 여러개의 행, 단일 컬럼을 조회하는 경우
1. 사용되는 위치 : WHERE - 서브쿼리
2. 조회되는 행, 컬럼의 개수 : 복수행, 단일 컬럼
3. 메인쿼리의 컬럼을 서브쿼리에서 사용 유무 : 비상호연관 서브쿼리


이건 안되지.
SELECT *
FROM emp
WHERE deptno = (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH' OR ename = 'ALLEN');

deptno IN (20,30)
deptno 20 OR deptno = 3;

위에거 참고해서 요렇게 하면 실행됨.
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH' OR ename = 'ALLEN');
                
IN은 서브쿼리랑 같이 많이 잘 쓰여! 기억하자!!!!!!!!!!!!!!!



문제 sub 1

풀이과정

14사원의 평균 급여 : 2073
SELECT AVG(sal)
FROM emp;

SELECT COUNT(*)
FROM emp
WHERE sal > 2073;

답
SELECT COUNT(*)
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp);

             
문제 sub 2
SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp);
          
문제 sub 3
SELECT deptno
FROM emp
WHERE ename IN  ('SMITH', 'WARD');

IN은 복수계의 equal!

SELECT deptno
FROM emp
WHERE deptno = 20 OR deptno = 30;

SELECT *
FROM emp
WHERE deptno IN(SELECT deptno
                FROM emp
                WHERE ename = 'SMITH' OR ename = 'WARD');             
              
              
              
MULTI-ROW 연산자
복수행 연산자 : IN(중요!!!!!!!!!!), ANY, ALL(이 둘은 잘 안쓰긴 하지만..그래도 알아두면 좋지)

SELECT *
FROM emp  --800, 1250
WHERE sal < ANY (SELECT sal
               FROM emp
               WHERE ename = 'SMITH' OR ename = 'WARD');             
SAL 컬럼의 값이 800이나, 1250보다 작은 사원(1250보다 작으면 다나옴. 1250이 맥시멈)
==> SAL 컬럼의 값이 1250보다 작은 사원
(작거나 같게 하려면 부등호를 <= 로 바꾸면됨)

SELECT *
FROM emp  --800, 1250
WHERE sal > ALL (SELECT sal
               FROM emp
               WHERE ename = 'SMITH' OR ename = 'WARD'); 
SAL 컬럼의 값이 800보다도 크고, 1250보다도 크고. 근데 ALL이야 둘다 만족시켜야돼.
그래서 결과는 1250보다 커야돼. 


복습
NOT IN 연산자와 NULL

--9/4
SELECT *
FROM emp
WHERE mgr IN (7698, 7839, NULL); 
mgr = 7698 OR mgr = 7839 OR mgr = NULL; 이걸 null은 is로 계산을 안해

SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839, NULL); 
mgr != 7698 OR mgr != 7839 OR mgr != NULL; 
이건 아무것도 안나와
=> 매니저 사원번호가 7698이거나 7839이거나 null인 사람이 있는걸 출력하지 마세요. - 이게 AND로 묶여 버려.
그래서 null이 같이 묶여버렸으니 다 false값이 되어버리는거지.
--

관리자가 아닌 사원의 정보를 조회
SELECT *
FROM emp
WHERE empno NOT IN (SELECT mgr
                    FROM emp);

PAIR WISE 개념 : 순서쌍 -> 두가지 조건을 동시에 만족시키는 데이터를 조회 할때 사용
                        AND  논리연산자와 결과 값이 다를 수 있다(아래 예시 참조)
서브쿼리 : 복수행, 복수컬럼 (잘 안쓰이긴 하는데 페어와이즈의 형태를 쓰려면 쓸수밖에없엉)

SELECT *
FROM emp
WHERE (mgr, deptno) IN (SELECT mgr, deptno
                        FROM emp
                        WHERE empno IN (7499, 7782));
                        
                        
SCALAR SUMQUERY : SELECT절에 기술된 서브 쿼리
                -  하나의 컬럼으로 생각하면 돼 !!!!!!!!!!!!!!! 하나의 컬림이라는게 중요한 개념임
*** 스칼라 서브쿼리는 하나의 행, 하나의 컬럼을 조회하는 쿼리이어야 한다.  -  이 말 중요!!!!!!!
                
SELECT dummy, (SELECT SYSDATE
               FROM dual)
FROM dual;
                        
SELECT dummy, SYSDATE              
FROM dual;
                        
스칼라 서브쿼리가 복수개의 행(4개), 단일 컬럼을 조회 ==> 에러                        
SELECT empno, ename, deptno,(SELECT dname FROM dept)
FROM emp;


emp 테이블과 스칼라 서브 쿼리를 이용하여 부서명 가져오기
기본 : emp 테이블과 dept 테이블을 조인하려 컬럼을 확장
SELECT empno, ename, dname
FROM emp e , dept d
WHERE e.deptno = d.deptno;
원래는 이렇게 조인써서 했는디 스칼라 서브쿼리를 이용하면 조인 안써도돼

SELECT empno, ename, deptno, (SELECT dname FROM dept WHERE deptno = deptno)
FROM emp;


SELECT dname 
FROM dept 
WHERE deptno = deptno; --얘는 항상 참이라고 항상 답이 나올거야. 

이럴때 한정자를 써주는거야
SELECT empno, ename, deptno, 
      (SELECT dname FROM dept WHERE deptno = emp.deptno) -- 이말인 즉슨, deptno가 10일때, 20일때, 30일때 다 상황에 맞게 가져다 써라. 이게 상호연관서브쿼리!
FROM emp;

->위를 보면 알수있듯이 
상호연관 서브쿼리 : 메인 쿼리의 컬럼을 서브쿼리에서 사용한 서브쿼리
                - 서브쿼리만 단독으로 실행하는 것이 불가능 하다
                - 메인쿼리와 서브 쿼리의 실행순서가 정해져 있다. => 메인쿼리가 항상 먼저 실행된다.

비상호연관 서브쿼리 : 메인 쿼리의 컬럼을 서브쿼리에서 사용하지 않은 서브쿼리
                    - 서브쿼리만 단독으로 실행하는 것이 가능하다
                    - 메인 쿼리와 서브쿼리의 실행순서가 정해져 있지 않다
                      메인 => 서브, 서브 => 메인 둘다 가능

SELECT *
FROM dept
WHERE deptno IN (SELECT deptno
                 FROM emp);


문제 extra. 전체직원의 급여 평균보다 높은 급여를 받는 사원들 조회
SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp);

문제 extra_2 본인 속한 부서의 급여 평균보다 높은 급여를 받는 사람들을 조회
SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp
             WHERE deptno = 20); --이건 하드코딩

SELECT *
FROM emp e
WHERE sal > (SELECT AVG(sal)
             FROM emp
             WHERE deptno = e.deptno);



SELECT dname
FROM dept
WHERE deptno = 20;
                        
SELECT dname
FROM dept
WHERE deptno = 20;
