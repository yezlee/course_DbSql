별칭 기술 :텍스트, "텍스트" / '텍스트'
SELECT job as 직업
FROM emp;

WHERE 절 : 스프레드 시트
    - filter : 전체 데이터중에서 내가 원하는 행만 나오도록 제한 -필터를 걸었지 엑셀에서. 그게 where랑 비슷한 맥락
    
비교연산 <, >, =, !=, <>, <=, >=
        BETWEEN AND
        IN
연산자를 배울 때(복습할 때) 기억할 부분은
해당 연산자 x항 연산자 인지하자

   1       +        5
피연산자  연산자   피연산자   


a++ : 단항 연산자

int a = b > 5 ? 10 : 20;   b가 5보다 클때 10을 넣어라 아니면 20을 넣어라

BETWEEN AND : 비교대상 BETWEEN 시작값 AND 종료값
IN : 비교대상 IN (값, 값2....)
LIKE : 비교대상 LIKE '매칭문자열 % _'

WHERE deptno BETWEEN 30 AND 50;

SELECT *
FROM emp    
WHERE 10 BETWEEN 10 AND 50; - 이게 참인 문장이라 전체 다 나오는거



1. 개발자는 천재가 아니어도 된다
2. 암기를 못해도 된다
3. 수학을 못해도 된다
4. 누구나 프로그래밍을 할수있는건아니다 
5. 개발은 재능의 영역이 아니다


-------------------0904 수업


NULL 비교
NULL값은 =, != 등의 비교연산으로 비교가 불가능
EX : emp 테이블에는 comm컬럼의 값이 NULL인 데이터가 존재

comm이 NULL인 데이터를 조회 하기 위해 다음과 같이 실행할 경우 정상적으로 동작하지 않음
SELECT *
FROM emp
WHERE comm = NULL;   -이렇게 하면 안됨

문제6
SELECT *
FROM emp
WHERE comm IS NOT NULL;  - commission이 null이 아닌걸 찾으려면 즉, commission이 있는걸 찾을때

comm 컬럼의 값이 NULL이 아닌걸 찾을때
 = , !=, <> 

SELECT *
FROM emp
WHERE comm IS NOT NULL; 

IN <==> NOT IN
사원중 소속 부서가 10번이 아닌 사원 조회
SELECT *
FROM emp
WHERE deptno NOT IN (10)

SELECT *
FROM emp;

사원중의 자신의 상급자가 존재하지 않는 사원들만 조회(모든컬럼)
SELECT *
FROM emp
WHERE mgr IS NULL;

논리 연산 : AND, OR, NOT
AND, OR : 조건을 결합
    
    AND : 조건1  AND 조건2 : 조건1과 조건2를 동시에 만족하는 행만 조회가 되도록 제한
    OR : 조건1 OR 조건2 : 조건1 혹은 조건2를 만족하는 행만 조회 되도록 제한
    
조건1      조건2     조건1 AND 조건2     조건1 OR 조건2
 T          T            T                   T
 T          F            F                   T
 F          T            F                   T
 F          F            F                   F
    
WHERE 절에 AND 조건을 사용하게 되면 : 보통은 행이 줄어든다.
WHERE 절에 OR 조건을 사용하게 되면 : 보통은 행이 늘어난다. 

NOT : 부정 연산
다른 연산자와 함께 사용되며 부정형 표현으로 사용됨.
NOT IN (값1, 값2...)
IS NOT NULL 
NOT EXISTS


mgr가 7698사번을 갖으면서 급여가 1000보다 큰 사원들을 조회
SELECT *
FROM emp
WHERE mgr = 7698
  AND sal > 1000;

mgr가 7698이거나 급여가 1000보다 큰 사원들을 조회
SELECT *
FROM emp
WHERE mgr = 7698
   OR sal > 1000;
   


emp 테이블의 사원중에 mgr가 7698아니거나, 7839가 아닌 직원
SELECT *
FROM emp
WHERE mgr != 7698
  AND mgr != 7839;

SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839);

IN 연산자는 OR 연산자로 대체가 가능하다   
SELECT *
FROM emp
WHERE mgr IN (7698, 7839); ==> mgr = 7698 OR mgr = 7839;
WHERE mgr IN (7698, 7839); ==> NOT (mgr = 7698 OR mgr = 7839);
WHERE mgr NOT IN (7698, 7839); ==> mgr != 7698 AND mgr = 7839;   셋다 같은말



IN 연산자 사용시 NULL 데이터 유의점
요구사항 : mgr가 7698, 7839, NULL인 사원만 조회

SELECT *
FROM emp
WHERE mgr IN (7698, 7839, NULL); 
mgr = 7698 OR mgr = 7839 OR mgr = NULL; 이걸 null은 is로 계산을 안해

위에거를 실행하게 하려면 아래처럼 null은 in 같은거 안돼. 
SELECT *
FROM emp
WHERE mgr IN (7698, 7839) OR mgr IS NULL;


SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839, NULL);  이건오류
mgr != 7698 AND mgr != 7839 AND mgr != null 위문장을 이거 처럼 해석을 하기 때문에 인식을 못하는거야


문제7  데이터는 대소문자를 가린다!!!!!!! 문자열을 검색할때는 싱글쿼테이션을 달아줘야한다!!!!!!!!!!!!!!!! date 잘써라 TO_DATE('19810601', 'yyyymmdd')
SELECT *
FROM emp
WHERE job = 'SALESMAN'
  AND hiredate >= TO_DATE('19810601', 'yyyymmdd');

문제8
SELECT *
FROM emp
WHERE deptno != 10 
  AND hiredate >= TO_DATE('19810601', 'yyyymmdd');
  
문제9
SELECT *
FROM emp
WHERE deptno NOT IN 10 
  AND hiredate >= TO_DATE('19810601', 'yyyymmdd');
  
문제10 - 문제 뜻? 
SELECT *
FROM emp
WHERE deptno IN (20,30) 
  AND hiredate >= TO_DATE('19810601', 'yyyymmdd');
 
문제11
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR hiredate >= TO_DATE('19810601', 'yyyymmdd');

문제12
SELECT *
FROM emp
WHERE job = 'SALESMAN' 
   OR empno LIKE '78%';  %랑 _를 쓰려면 무조건 like가 있어야함. 

문제13
SELECT *
FROM emp
WHERE job = 'SALESMAN' 
   OR (empno >= 78  AND empno <=78
   OR empno >= 780  AND empno <=789
   OR empno >= 7800  AND empno <=7899);
   
SELECT *
FROM emp
WHERE job = 'SALESMAN' 
   OR (BETWEEN 78 AND 78
   OR BETWEEN 780  AND 789
   OR BETWEEN 7800  AND 7899);   
   
   
   ; like를 안쓰고 하려면 숫자는 4자리이고. empno는 0~ 9999까지만 있음. 그걸 잘 생각해봐

문제14
SELECT *
FROM emp
WHERE job = 'SALESMAN'
    OR empno Like '78%' AND hiredate >= TO_DATE('19810601', 'yyyymmdd');


정렬
*********매우 매우 중요 ************* where가 제일중요! 이건 그다음??중요?

RDBMS는 집합에서 많은 부분을 차용 (relational database management system = RDBMS =비슷 DBMS)
집합의 특징 : 1. 순서가 없다.
             2. 중복을 허용하지 않는다.
{1, 5, 10} == {5, 1, 10} (집합에 순서는 없다)             
{1, 5, 5, 10} ==> {5, 1, 10} (집합은 중복을 허용하지 않는다.)

아래 sql의 실행결과, 데이터의 조회 순서는 보장되지 않는다.
지금은 7369, 7499.... 조회가 되지만
내일 동일한 sql을 실행 하더라도 오늘 순서가 보장되지 않는다.(바뀔수있음)
순서가 바뀌어도 잘못된게 아니다.

* 보편적으로 데이터는 데이터를 입력한 순서대로 나온다. (보장은아님)
** table에는 순서가 없다. 
SELECT *
FROM emp;

시스템을 만들다 보면 데이터의 정렬이 중요한 경우가 많다.
게시판 글 리스트 : 가장 최신글이 가장 위로 와야한다.

** 즉 SELECT 결과 행의 순서를 조정할 수 있어야 한다.
 ==> ORDER BY 구문
 
문법
SELECT *
FROM 테이블명
[WHERE]
[ORDER BY 컬럼1, 컬럼2]

오름차순 ASC : 값이 작은 데이터부터 큰 데이터 순으로 나열
내림차순 DESC : 값이 큰 데이터부터 작은 데이터 순으로 나열

ORACLE에서는 기본적으로 오름차순이 기본 값으로 적용됨
내림차순으로 정렬을 원할 경우 정렬기준 컬럼 뒤에 DESC를 붙여 준다.

job컬럼으로 오름차순 정렬하고, 같은 job을 갖는 행끼리는 empno로 내림차순 정렬한다.
SELECT *
FROM emp
ORDER BY job, empno DESC;

참고로만... 중요하진 않음
1. ORDER BY 절에 별칭 사용 가능
SELECT empno eno, ename enm
FROM emp
ORDER BY enm;

2. ORDER BY 절에 SELECT 절의 컬럼 순서 번호를 기술 하여 정렬 가능
SELECT empno, ename, job
FROM emp
ORDER BY 2; ==> ORDER BY ename;

3. expression도 가능
SELECT empno, ename, sal + 500 
FROM emp
ORDER BY sal + 500;


데이터정렬(ORDER BY 실습1 ) 문제1
SELECT *
FROM dept 
ORDER BY dname;

SELECT *
FROM dept 
ORDER BY loc DESC;

문제2
SELECT *
FROM emp
WHERE comm IS NOT NULL AND comm != 0 
ORDER BY comm DESC, empno DESC;

or

SELECT *
FROM emp
WHERE comm != 0     -> 이렇게 하면 어차피 null은 안나옴.
ORDER BY comm DESC, empno DESC;

문제3
SELECT *
FROM emp
WHERE mgr IS NOT NULL
ORDER BY job, empno DESC;

문제4  
SELECT *
FROM emp
WHERE deptno = 10 OR (deptno = 30 AND sal > 1500 )    
ORDER BY ename DESC;
이걸 출력했을때 sal이 1300이어도 검색이 된건, and가 먼저 검색이 되고 앞에 OR 해서 넘버가 10인게 만족이 되서 검색이 된것

SELECT *
FROM emp
WHERE (deptno = 10 OR deptno = 30) AND sal > 1500 
ORDER BY ename DESC;

SELECT *
FROM emp
WHERE deptno IN (10,30) AND sal > 1500
ORDER BY ename DESC;


******** 실무에서 매우 많이 사용 ***********
ROWNUM : 행위 번호를 부여해주는 가상 컬럼 - 어렵게 느껴질수 있지만 실무에서 안쓸수가 없음
         ** 조회된 순서대로 번호를 부여


ROWNUM : 1부터 읽어야한다.
	   SELECT 절이 ORDER BY 절보다 먼저 실행된다.
	   ==> ROWNUM을 이용하여 순서를 부여하려면 정렬부터 해야한다.
		==> 인라인뷰 (ORDER BY - ROWNUM을 분리)



//추가 
ROWNUM은 SELECT절에 의해 추출되는 데이터에 붙는 순번이다.
다시 말해 WHERE절까지 만족 시킨 자료에 1부터 붙는 순번이다.
WHERE절에 ROWNUM을 이용하여 조건을 주면 다른 조건을
만족시킨 결과에 대해 조건이 반영된다.

SELECT 리스트에 ROWNUM을 이용하는 것도 가능하다.

ORDER BY를 사용한다면 WHERE절까지 만족 시킨 결과에 ROWNUM이
붙은 상태로 ORDER BY가 반영된다.
즉, ROWNUM은 ORDER BY전에 부여되며, ORDER BY는 맨 나중에 실행된다.
//


!!!! ROWNUM은 1번부터 순차적으로 데이터를 읽어 올 때만 사용 가능 - 절대 조건!!!!!!!!!!!!!!!!!
위말을 쉽게 풀면ㄱ
ㄴROWNUM은 SELECT절에서 선택받아서 추출되는 데이터에 붙는 순번이야.
SELECT절에서 ename했으면 그 이름들이 쫙 데이터로 나오잖아 거기에 제일먼저 나온애한테 1번이라고 붙여주는거야
그러니깐 2번부터 선택할수는 없는거지. 

1. WHERE 절에 사용하는 것이 가능         
    * WHERE ROWNUM = 1 ( = 동등 비교 연산의 경우 1만 가능)
      WHERE ROWNUM <= 15
      WHERE ROWNUM BETWEEN 1 AND 15 

SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 1 AND 15 ;


SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 1 AND 15 
ORDER BY empno;

SELECT ROWNUM, empno, ename
FROM emp
WHERE 글번호 BETWEEN 46 AND 60;

2. ORDER BY 절은 SELECT 이후에 실행된다.
    ** SELECT절에 ROWNUM을 사용하고 ORDER BY절을 사용하면 원하는 결과를 얻지 못한다.

정렬을 먼저 하고 정렬된 결과에 ROWNUM을 적용
==> INLINE-VIEW - 이게 괄호쳐서 먼저 실행되게 만든거
    SELECT 결과를 하나의 테이블처럼 만들어준다. 

사원정보를 페이징 정리
1페이지 5명씩 조회
1페이지 : 1~5,  (page-1) ~ page * pageSize
2페이지 : 6~10, 
3페이지 : 11~15

page = 1, pageSize = 5


()<-inline view라고 하지!

SELECT *
FROM (SELECT ROWNUM rn, a.*   --rn이 컬럼이 된것. 그래서 6번부터 10번까지 where절로 조회가 가능 
      FROM
        (SELECT empno, ename
         FROM emp
         ORDER BY ename) a)
WHERE rn BETWEEN 6 AND 10;


-----------------------    
셀렉트보다 오더바이가 먼저 실행되기 때문에 로우넘이랑 오더바이랑 같이 못써
그래서 이 난리가 괄호치고 난리가 나는거
SELECT ROWNUM , a.*
FROM    (SELECT empno, ename
         FROM emp
         ORDER BY ename) a
WHERE ROWNUM BETWEEN 1 AND 10;   
-- 이건 가능해. 그냥 로우넘을 1번부터 검색한거니까. 
-- 6번부터 검색하려면 로우넘을 컬럼으로 만들어서 검색해야하고 그게 아니면 꼭 로우넘을 컬럼으로 만들 필요가 없지.
-- 여기서 rownum 별칭 줘서 where에서 바로 검색 못해!!!! 왜냐면 순서가 FROM -> WHERE -> SELECT라서,
-- select에서 rn이라고 별칭을 줘도 where에서 먼저 검색할때 rn이 뭔지 몰라
------------------------


SELECT *
FROM (SELECT ROWNUM rn, a.*
      FROM
        (SELECT empno, ename
         FROM emp
         ORDER BY ename) a)
WHERE rn BETWEEN (:page - 1) * :pageSize + 1 AND :page * :pageSize; 




SELECT절에 *사용했는데 ,를 통해 다른 특수 컬럼이나 EXPRESSION을 사용 할 경우는 
.*앞에 해당 데이터가 어떤 테이블에서 왔는지 명시를 해줘야 한다. (한정자)
SELECT ROWNUM, *
FROM emp;

그래서 아래처럼 해줘야 작동
SELECT ROWNUM, emp.*
FROM emp;

별칭은 테이블에도 적용 가능, 단 칼럼이랑 다르게 AS 옵션은 없다

SELECT ROWNUM, e.*
FROM emp e;


셀렉트보다 오더바이가 먼저 실행되기 때문에 로우넘이랑 오더바이랑 같이 못써
그래서 이 난리가 괄호치고 난리가 나는거

orderby4 실행순서

1.SELECT *
2.FROM emp
3.WHERE deptno IN (10,30) AND sal > 1500
4.ORDER BY ename DESC;

2 -> 3 -> 1 -> 4






