ROWNUM : 1부터 읽어야한다.
	   SELECT 절이 ORDER BY 절보다 먼저 실행된다.
	   ==> ROWNUM을 이용하여 순서를 부여하려면 정렬부터 해야한다.
		==> 인라인뷰 (ORDER BY - ROWNUM을 분리)
        
       
        
        
문제 row_1
SELECT ROWNUM RN, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 1 AND 10;

or

SELECT ROWNUM RN, empno, ename
FROM emp
WHERE ROWNUM <= 10;



문제2 

1. 이렇게 하면 우선 나옴

SELECT *
FROM
(SELECT empno, ename
FROM emp);


이건 rn을 같이 구하는거지
SELECT ROWNUM rn, a.*
FROM
(SELECT empno, ename
FROM emp)a;



2. 1을 인라인뷰로 또 감싸면서 하면 끝!
SELECT *
FROM(SELECT ROWNUM rn, a.*
     FROM (SELECT empno, ename
           FROM emp)a)
WHERE rn BETWEEN 11 AND 20;

순서가 FROM -> WHERE -> SELECT


정렬의 기준을 해주지 않아서 내일했을땐 나오는 사람이 바뀌어있을수도 있어
답:
SELECT *
FROM (SELECT ROWNUM rn, empno, ename
      FROM emp)      
WHERE rn BETWEEN 11 AND 20;
      
  
  
  
      
문제3 emp테이블에서 사원이름으로 오름차순 정렬/11~14 해당하는 순번, 사원번호, 이름출력
1. 정렬기준 : ORDER BY ename ASC;
2. 페이지 사이즈 : 11~20(페이지당 10건)

SELECT *
FROM   (SELECT a.*
        FROM (SELECT ROWNUM rn, empno, ename
              FROM emp 
              ORDER BY ename ASC)a)
WHERE rn BETWEEN 11 AND 14;


정답
1.
SELECT empno, ename
FROM emp
ORDER BY ename ASC;


이렇게 하면 로우넘때문에 계속바껴
SELECT ROWNUM, empno, ename
FROM emp
ORDER BY ename ASC;


2.
SELECT ROWNUM rn, empno, ename
FROM
       (SELECT empno, ename
        FROM emp
        ORDER BY ename ASC);
or
SELECT ROWNUM rn, empno, ename
FROM
       (SELECT empno, ename
        FROM emp
        ORDER BY ename ASC);


3.답  (문제3 emp테이블에서 사원이름으로 오름차순 정렬/11~14 해당하는 순번, 사원번호, 이름출력)
SELECT *
FROM  ( SELECT ROWNUM rn, empno, ename
        FROM   (SELECT empno, ename
                FROM emp
                ORDER BY ename ASC))
WHERE rn > 10 AND rn <=20;                


내가쓴 3답- 다시 고쳐쓰기!!!!!!!!!!!!!!!!!!!!
SELECT *
FROM   (SELECT a.*
        FROM (SELECT ROWNUM rn, empno, ename
              FROM emp 
              ORDER BY ename ASC)a)
WHERE rn BETWEEN 11 AND 14;





--------------함수------------

ORACLE 함수 분류
***1. SINGLE ROW FUNCTION : 단일 행을 작업의 기분, 결과도 한건 반환
2. MULTI ROW ROW FUNCTION : 여러 행을 작업의 기준, 하나의 행을 결과로 반환

dual 테이블
1. sys 계정에 존재하는 누구나 사용할 수 있는 테이블
2. 테이블에는 하나의 컬럼, dummy 존재, 값은 x
3. 하나의 행만 존재
    ***** SINGLE 


SELECT *
FROM dual;

SELECT empno, ename, LENGTH(ename),LENGTH('Hello')
FROM emp;

SELECT LENGTH('Hello')
FROM dual;


sql칠거지악
1. 좌변을 가공하지 말아라(테이블 컬럼에 함수를 사용하지 말것)
 - 함수 실행 횟수
 - 인덱스 사용 관련(추후에)

SELECT ename, LOWER(ename)
FROM emp
WHERE LOWER(ename) = 'smith';    이건 LOWER에 있는 ename을 14번 실행해서 알수있는거

SELECT ename, LOWER(ename)
FROM emp
WHERE ename = UPPER('smith');    이건 한번만 실해하면 됨

SELECT ename, LOWER(ename)
FROM emp
WHERE ename = 'SMITH';    그냥 이게 젤좋음 - 컬럼을 가공하지말라!(좌변을 가공하지말라라고 구글에 떴던 내용의 의미)


문자열 관련함수
SELECT CONCAT('Hello', ',World') concat,
       SUBSTR('Hello, World', 1, 5) substr,    -- 5가 endindex. SUBSTR("문자열", "시작위치", "길이")- SUBSTR 함수는 문자단위로 시작위치와 자를 길이를 지정하여 문자열을 자른다.
       SUBSTR('Hello, World', 5) substr2,  -- 이렇게 시작 인덱스만 주는 경우도 있다
       LENGTH('Hello, World') length,
       INSTR('Hello, World', 'W')instr, --INSTR(문자열, 검색할 문자, 시작지점, n번째 검색단어) 함수는 찾는 문자의 위치를 반환하는것입니다.
       INSTR('Hello, World', 'o')instr,
       INSTR('Hello, World', 'o', 5 + 1)instr2,       
       INSTR('Hello, World', 'o', INSTR('Hello, World', 'o') + 1) instr3,
       LPAD('Hello, World', 15, '*') lpad,   -- 15글자로 만들고 싶은데 빈자리를 별로 채우는거
       LPAD('Hello, World', 15) lpad2, -- 별을 안써주면 빈칸으로 채워서 15자리를 만들지
       RPAD('Hello, World', 15) rpad, -- 
       REPLACE('Hello, World','Hello', 'Hell') replace,
       TRIM('Hello, World') trim, -- 문자열 가운데 있는 공백은 건들지 않고, 그 외엔 공백이 없으니 똑같이 나옴
       TRIM('  Hello, World      ') trim2,
       TRIM('H' FROM 'Hello, World') trim3
FROM dual;


숫자관련함수
SELECT *
FROM emp
WHERE sal > 6500 AND; ~  -- AND라고 써야지 &라고 쓰면 안됨!! 

ROUND : 반올림 함수
TRUNC : 버림 함수
  ==> 몇번째 자리에서 반올림, 버림을 할지?
      두번째 인자가 0, 양수 : ROUND(숫자, 반올림 결과 자리수)
      두번째 인자가 음수 : ROUND(숫자, 반올림 해야하는 위치)
MOD : 나머지를 구하는 함수

SELECT  ROUND(105.54, 1) round,  --소수점 첫번째 짜리만 나오라고. 그말인즉슨 소수점 두번째 자리를 반올림 하는거지
        ROUND(105.55, 1) round2,  
        ROUND(105.55, 0) round3, -- 이건 0이니까 그 앞에 반올림 시키는거니까 답이 106이 되는거지
        ROUND(105.55, -1) round4   -- .이 0이고, -1은 
FROM dual;

SELECT  TRUNC(105.54, 1) trunc,  --첫번째 자리에서 버리는거
        TRUNC(105.55, 1) trunc2,  
        TRUNC(105.55, 0) trunc3,
        TRUNC(105.55, -1) trunc4  
FROM dual;


SELECT TRUNC(sal/1000), sal, sal/1000 --TRUNC(sal/1000) 이건 그냥 소수점을 다 버리라는
FROM emp;


mod 나머지 구하는 함수
피제수, 제수
피제수 - 나눔을 당하는 수, 제수 - 나누는 수
a / b = c
a : 피제수
b : 제수

문제 : 10을 3으로 나눴을때의 몫을 구하기
SELECT mod(10,3)
FROM dual;

SELECT mod(10,3),
       TRUNC(10/3 ,0)
FROM dual;

답
SELECT TRUNC(10/3, 0)  -- 0번자리. 소수점 자리에서 버려라!
FROM dual;


날짜 관련함수
문자열 ===> 날짜 타입 TO_DATE
SYSDATE : 오라클 서버의 현재 날짜, 시간을 돌려주는 특수 함수
          함수의 인자가 없다.
          (Java :
          public void test(){
          }
          test();
          
          SQL :
          length('Hello, World')
          SYSDATE ;
          
SELECT SYSDATE
FROM dual;

날짜 타입 +- 정수(일자) : 날짜에서 정수만큼 더한 (뺀) 날짜.
하루 = 24
1일 24h
1h = 1/24일
1m = 1/24일/60h
1s = 1/24일/60h/60m = 1/24일/60/60

emp hiredate +5, -5

SELECT SYSDATE, SYSDATE + 5, SYSDATE -5,
       SYSDATE + 1/24, SYSDATE + 1/24/60
FROM dual;

문제 fn_1
sql : 'Hello, World', 5 -- 문자열쓰는방법, 숫자 쓰는 방법
java : "Hello, World", 5

날짜를 어떻게 표현할까?
java : java.util.Date
sql : nsl 포맷에 설정된 문자열 형식을 따르거나
      ==> 툴 때문일수도 있음. 예측하기힘듦.
      TO_DATE 함수를 이용하여 명확하기 명시
      TO_DATE('날짜 문자열', '날짜 문자열 형식')


SELECT '2019/12/31' LASTDAY, SYSDATE -256 LASTDAY_BEFORE5,  SYSDATE NOW,  SYSDATE -3 NOW_BEFORE3
FROM dual;

답
SELECT TO_DATE('2019/12/31', 'YYYY/MM/DD')LASTDAY,
       TO_DATE('2019/12/31', 'YYYY/MM/DD') -5 "LASTDAY BEFORE5",
       SYSDATE NOW,
       SYSDATE -3 NOW_BEFORE3
FROM dual;


SELECT TO_DATE('2019/12/31', 'YYYY/MM/DD'
FROM dual;
