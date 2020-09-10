많이 쓰이는 함수, 잘 알아두자
(개념적으로 혼돈하지 말고 잘 정리하자 - SELECE 절에 올 수 있는 컬럼에 대해 잘 정리)


그룹 함수 : 여러개의 행을 입력받아 하나의 행으로 결과를 반환하는 함수

오라클 제공 그룹함수
MIN(컬럼|익스프레션) : 그룹중에 최소값을 반환
MAX(컬럼|익스프레션) : 그룹중에 최대값을 반환
AVG(컬럼|익스프레션) : 그룹의 평균값을 반환
SUM(컬럼|익스프레션) : 그룹의 합계값을 반환
COUNT(컬럼 | 익스프레션 | *) : 그룹핑된 행의 갯수

SELECT 행을 묶은 컬럼, 그룹함수
FROM 테이블명
[WHERE]
GROUP BY 행을 묶은 컬럼;
[HAVING 그룹함수 체크조건];

SELECT *
FROM emp
ORDER BY deptno;

그룹함수에서 많이 어려워 하는 부분
SELECT 절에서 기술할수 없는 컬럼의 부분 -BUT 조금만 논리적으로 생각해봄 답이 나온다! 잘생각해봐
 : GROUP BY 절에 나오지 않은 컬럼이 SELECT 절에 나오면 에러;

SELECT deptno, MIN(ename), COUNT(*), MIN(sal), MAX(sal), SUM(sal), TRUNC(AVG(sal),2) avg --, sal 이렇게 추가를 하면 답이 안나오지. deptno안에 10,20,30이 있고 부서 10안에 여러명 있는데 그냥 sal 찾어라고하면 누구의 sal?뭐를 찾아야하는지 몰라
--MIN(ename) 이건 이름 알파벳 젤 빠른거
FROM emp
GROUP BY deptno, ename; --ename을 여기에 넣으면 그룹바이 이름인데 이름은 그룹이아니고 각자 개인이라서 그냥 전체 다 나오게됨

---------------
전체 직원(모든 행을 대상으로)중에 가장 많은 급여를 받는 사람의 값 - 근데 전체직원인데 deptno를 쓰면 전체직원을 못찾는디?
그래서 전체직원 할때는 그룹바이안써
: 전체 행을 대상으로 그룹핑 할 경우 GROUP BY 사용하지 않는다.
SELECT deptno, MAX(sal)
FROM emp
GROUP BY deptno;

이 경우는 deptno가 그룹함수가 안돼. 다시 잘 읽어보자
SELECT deptno, MAX(sal)
FROM emp;

-----------


전체직원중에 가장 큰 급여 값을 알 수는 있지만 해당 급여를 받는 사람이 누군지는 그룹함수만 이용해서는 구할 수가 없다.
emp테이블 가장 큰 급여를 받는 사람의 값이 5000인 것은 알지만 해당사원이 누구인지는 그룹함수만 사용해서는 누군지 식별할 수 없다.
    ==> 추후진행
    



    
COUNT 함수 * 인자
* : 행의 개수를 반환
컬럼 | 익스프레션 : NULL값이 아닌 행의 개수

SELECT COUNT(*), COUNT(mgr), COUNT(comm) -- NULL이 있으면 그거 빼고 행을 다 합쳐버림
FROM emp;


그룹함수의 특징 : NULL값을 무시
NULL 연산의 특징 : 결과 항상 NULL이다.

SELECT SUM(comm) --4개의 행만 더한거
FROM emp;

SELECT SUM(sal + comm), SUM(sal) + SUM(comm) -- SUM(sal + comm)이건 익스프레션이야 그룹함수가 적용되기전에 
FROM emp;

SELECT SUM(sal), SUM(comm) ,SUM(sal + comm), SUM(sal) + SUM(comm)
FROM emp;

SELECT sal ,comm
FROM emp;


그룹함수 특징2 : 그룹화와 관련없는 상수(변하지않는값)들은 SELECT 절에 기술할 수 있다.
SELECT deptno, SYSDATE, COUNT(*), 'TEST' , 1
FROM emp
GROUP BY deptno;


그룹함수 특징3 :
    SINGLE ROW 함수(단일 행을 기준으로 작업하고 행당 하나의 결과를 반환)의 경우 WHERE 에 기술하는 것이 가능하다
    (multi row함수는 여러행을 기준으로 작업하고, 하나의 결과를 반환 - 예, 그룹함수 COUNT, SUM, AVG...)
    ex : SELECT *
         FROM emp
         WHERE ename = UPPER('smith'); -- UPPER는 문자열을 대문자로 만들어줌
         
    그룹함수의 경우 WHERE에서 사용하는 것이 불가능하다.
        ==> HAVING 절에서 그룹함수에 대한 조건을 기술하여 행을 제한 할 수있다.
        
        그룹함수는 WHERE절에 사용불가
        SELECT deptno, COUNT(*)
        FROM emp
        WHERE COUNT (*) >= 5
        GROUP BY deptno;

        그룹함수에 대한 행 제한은 HAVING 절에 기술
        SELECT deptno, COUNT(*)
        FROM emp        
        GROUP BY deptno
        HAVING COUNT (*) >= 5;


Q.
GROUP BY 를 사용하면 WHERE 절을 사용 못하나??
GROUP BY의 대상이 되는 행들을 제한할 때 WHERE절을 사용.

SELECT deptno, COUNT(*)
FROM emp
WHERE sal > 1000
GROUP BY deptno;
--부서번호로 그룹핑을 할건데 샐러리가 1000불이상인 사람만 조회할거고, 부서넘버랑 1000불 이상 버는 사람 조회해.
--1000불 못버는 사람은 총합에 포함이 안된거지.


문제 grp1
SELECT MAX(sal) max_sal , MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal, SUM(sal) sum_sal, COUNT(sal) count_sal, COUNT(mgr) count_mgr, COUNT(*)count_all
FROM emp;


문제 grp2
SELECT deptno, MAX(sal) max_sal , MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal, SUM(sal) sum_sal, COUNT(sal) count_sal, COUNT(mgr) count_mgr, COUNT(*)count_all --ename 을 넣으면 안되지만 이미 내가 그룹바이를 deptno로 했으니깐 셀렉해도돼
FROM emp
GROUP BY deptno;



** GROUP BY 절에 기술한 컬럼이 SELECT 절에 오지 않아도 실행에는 문제가 없다


문제 GRP3
SELECT *
FROM dept;

10	ACCOUNTING
20	RESEARCH
30	SALES
40	OPERATIONS  

SELECT deptno, max(sal), min(sal)
FROM emp
GROUP BY deptno;






SELECT  DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESERCH', 30, 'SALES') dname,
        deptno, MAX(sal) max_sal , MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal, SUM(sal) sum_sal, COUNT(sal) count_sal, COUNT(mgr) count_mgr, COUNT(*)count_all
FROM emp
GROUP BY deptno;



SELECT  DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESERCH', 30, 'SALES') dname,
        deptno, MAX(sal) max_sal , MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal, SUM(sal) sum_sal, COUNT(sal) count_sal, COUNT(mgr) count_mgr, COUNT(*)count_all
FROM emp
GROUP BY DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESERCH', 30, 'SALES');  --그룹바이가 반드시 컬럼일 필요는없다


문제 grp4
SELECT TO_CHAR(hiredate, 'yyyymm') HIRE_YYYYMM , COUNT(*) cnt -- COUNT(TO_CHAR(hiredate, 'yyyymm')) 이렇게 쓸필요 없고 어차피 그룹바이로 묶어줬으니까 그냥 
FROM emp
GROUP BY TO_CHAR(hiredate, 'yyyymm');

SELECT TO_CHAR(hiredate, 'yyyymm') HIRE_YYYYMM , COUNT(*) cnt 
FROM emp
GROUP BY hiredate; -- 이렇게 하면 hiredate가 그룹바이 되서 일자까지 다 똑같아야 그룹으로 묶여. 그래서 월까지만 같이 그룹으로 묶으려면 위방법으로


문제5 부터 과제
SELECT TO_CHAR(hiredate, 'yyyy') hire_yyyy, COUNT(*)cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'yyyy');

문제6
SELECT COUNT(deptno)cnt
FROM dept;

문제7
SELECT COUNT(COUNT(deptno)) cnt
FROM emp
GROUP BY deptno;



****** WHERE + JOIN SELECT SQL의 모든 것 ****** 매우매우매우 중요
JOIN : 다른 케이블과 연결하여 데이터를 확장하는 문법
       . 컬럼을 확장(나한테 없는 컬럼을 다른 테이블에 있는걸 가져와서 사용)
** 행을 확장 - 집합연산자 (UNION, INTERSECT, MINUS)

JOIN 문법 구분
    1. ANSI - SQL
        : RDBMS에서 사용하는 SQL 표준
         ( 표준을 잘 지킨 모든 RDBMS-MYSQL, MSSQL, POSTFRESQL...에서 실행가능)
    2. ORACLE - SQL
        : ORACLE사 만의 고유 문법 - 얘네만 갖고있는게 있어서 근데 그게 너무 강력해 그래서 오라클 많이씀  
        오라클이 좀더 직관적임..
        
                둘중 뭘 사용하는게 어느쪽이 옳다라고 할수 없어. 
                
                회사에서 요구하는 형태로 따라가면 된다.
                7(ORACLE) : 3(ANSI)
        
 
NATURAL JOIN : 조인하고자 하는 테이블의 컬럼명이 같은 컬럼끼리 연결  - 이거 잘 안씀
               컬럼의 값이 같은 행들끼리 연결 
               
    ANSI-SQL  -내츄럴조인 잘 안씀. 여기에 내츄럴조인 사항이 다 포함되있어서...
    
    SELECT 컬럼
    FROM 테이블명 NATURAL JOIN 테이블명;
    
조인컬럼에 테이블 한정자를 붙이면 NATURAL JOIN 에서는 에러로 취급
emp.deptno (x) -> deptno (o)

컬럼명이 한쪽 테이블에만 존재할 경우 테이블 한정자를 붙이지 않아도 상관 없다.
emp.empno (o) , empno (o)

컬럼이 어디 한쪽에만 있으면 안적어도 됨 근데 둘다있으면 어떤건지 적어줘야함
SELECT emp.empno, deptno, dname
FROM emp NATURAL JOIN dept; --여기 테이블 둘다 deptno칼럼 똑같은게 들어있음

SELECT empno, ename, deptno, dname, loc --스미스 부서번호가 20이야. dept테이블을 통해서 스미스 부서 이름이 리서치고 일하는곳이 달라스인걸 알수있지
FROM emp NATURAL JOIN dept;


SELECT *
FROM EMP;

SELECT *
FROM DEPT;

SELECT *
FROM emp NATURAL JOIN dept;
--컬럼명이 같은것끼리 연결. 
-- 오 신기하다. 컬럼명이 같은것끼리 중복되는 번호에 따라 다른 정보도 같이 딸려서 적힘. 그래서 부서이름, 로케이션 다 알수있음




NATURAL JOIN을 ORACLE 문법으로
1. FROM 절에 조인할 테이블을 나열한다. (,)
2. WHERE 절에 테이블 조인 조건을 기술한다. - 예를 보고 이해하자

SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT dname, ename, loc, dept.deptno 
FROM emp, dept
WHERE emp.deptno = dept.deptno;


ORA-00918: column ambiguously defined
에러뜸. 컬럼이 여러개의 테이블에 동시에 존재하는 상황에서 테이블 한정자를 붙이지 않아서
오라클 입장에선 해당 칼럼이 어떤 테이블의 칼럼인지 알수가 없는 상황에서 발생하는 에러
deptno 컬럼은 emp, dept 테이블 양쪽 모두에 존재한다. 
SELECT * 
FROM emp, dept
WHERE deptno = deptno;
위아래 둘다 에러. 어디 deptno인지 모르자나
SELECT deptno 
FROM emp, dept
WHERE emp.deptno = dept.deptno;


인라인뷰 별칭처럼, 테이블 별칭을 부여하는게 가능
컬럼과 다르게 AS 키워드는 붙이지 않는다.

SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT *
FROM emp e, dept d
WHERE e.deptno = d.deptno;






ANSI-SQL : JOIN WITH USING
    조인하려는 테이블간 같은 이름의 컬럼이 2개 이상일 때 하나의 컬럼으로만 조인을 하고 싶을 때 사용
SELECT *
FROM emp JOIN dept USING (deptno);

위에 상황을 오라클로 하려면 어찌해야할까?
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;
--위에 내츄럴조인을 오라클로 하려는 방법이랑 똑같아


ANTI-SQL : JOIN WITH ON - 조인 조건을 개발자가 직접 기술
         위에 NATURAL JOIN, JOIN WITH USING 절을 JOIN WITH ON 절을 통해 표현 가능
         
SELECT *
FROM emp JOIN dept ON(emp.deptno = dept.deptno);

--첫번째, 두번째거가 헷갈리면 걍 위에거 쓰면됨.


오라클로 해보자 연습.
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno
    AND emp.deptno IN (20, 30); -- and 뒤에 어느쪽 컬럼써도 상관없음
    
    

논리적인 형태에 따른 조인 구분
1. SELF JOIN : 조인하는 테이블이 서로 같은 경우

SELECT empno, ename, mgr
FROM emp;

SELECT e.empno, e.ename, e.mgr, m.ename manager
FROM emp e JOIN emp m ON( e.mgr = m.empno);
--어떤 emp에서 가져온다는지 몰라서 별칭을 붙여준거. 그래서 emp.empno -> e.empno 이렇게 바꿔주고.
-- ON( e.mgr = m.empno) 이거 헷갈리면 엑셀에 그리던가해서 그림으로 그려서 이해해라.
-- 이게, employer 목록이 있는 파일에서 매니저를 가져와서 -> m파일에 employer number에 넣어주는거지. 
-- 그럼 새롭게 만든 manager컬럼에 employer들 매니저가 들어가는거

오라클로 작성
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e , emp m
WHERE e.mgr = m.empno;

-> KING의 경우 mgr컬럼의 값이 NULL이기 때문에 e.mgr = m.empno 조건을 충족 시키지 못함
그래서 조인 실패해서 14건중 13건의 데이터만 조회 - 셀프조인을 쓰던 오라클을 쓰던 똑같이 킹은 조회 못해

SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;
--이건 위에서 가져온 내츄럴조인이랑 join with using




2. NONEQUI JOIN : 조인 조건이 =이 아닌 조인 
SELECT *
FROM emp, dept
WHERE emp.empno = 7369
  AND emp.deptno != dept.deptno;
  
SELECT *
FROM emp;

SELECT *
FROM dept;
  
  
sal를 이용하여 등급을 구하기  
SELECT *
FROM salgrade;

empno, ename, sal, 등급(grade) - hint: between이용해서 / 오라클을 쓰던가 join with on을 쓰던가
----------
SELECT *
FROM emp JOIN dept ON(emp.deptno = dept.deptno);

--첫번째, 두번째거가 헷갈리면 걍 위에거 쓰면됨.


오라클로 해보자 연습.
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno
    AND emp.deptno IN (20, 30); 
---------
emp 랑 salgrade에서

SELECT  empno, ename, sal
FROM emp, salgrade
WHERE emp.sal >= salgrade.losal
AND emp.sal <= salgrade.hisal;

SELECT  empno, ename, sal, grade
FROM emp, salgrade
WHERE sal >= losal
AND sal <= hisal;

SELECT empno, ename, sal, grade
FROM emp, salgrade 
WHERE sal BETWEEN losal AND hisal;

--grade만있는 salgrade 테이블이랑 salary가 있는 emp 테이블에서
--where salary between low salary and high salary.
-- 낮은거에서 높은걸로 가야돼. 로우샐러리랑 하이샐러리 위치 바꾸면 안됨.

위의 SQL을 ANSI-SQL로 변경
SELECT empno, ename, sal, grade
FROM emp JOIN salgrade ON ( sal BETWEEN losal AND hisal);
--from emp (table) join salgrade (table) on sal (column) between losal and hisal.
--영어문장으로 만들어서 이해하고 외워버리자

SELECT  empno, ename, sal, grade
FROM emp JOIN salgrade ON ( sal >= losal AND sal <= hisal);


문제 JOIN0 - 테이블이 다르고 칼럼명이 같을때
SELECT empno, ename, dept.deptno, dname
FROM emp JOIN dept ON(emp.deptno = dept.deptno);

SELECT *
FROM DEPT;


문제 join0_1
SELECT empno, ename, dept.deptno, dname
FROM emp JOIN dept ON(emp.deptno = dept.deptno)
WHERE dept.deptno IN (10, 30);


문제 join0_2
SELECT empno, ename, sal, dept.deptno, dname
FROM emp JOIN dept ON(emp.deptno = dept.deptno)
WHERE sal > 2500
ORDER BY deptno;

문제 join0_3
SELECT empno, ename, sal, dept.deptno, dname
FROM emp JOIN dept ON(emp.deptno = dept.deptno)
WHERE sal > 2500 AND empno > 7600;

문제 join0_4
SELECT empno, ename, sal, dept.deptno, dname
FROM emp JOIN dept ON(emp.deptno = dept.deptno)
WHERE sal > 2500 AND empno > 7600 AND dname = 'RESEARCH';


SELECT NEXT_DAY(TO_DATE('20191010','YYYYMMDD'),1)
FROM dual;
