날짜 관련된 함수
TO_CHAR 날짜 ==> 문자
TO_DATE 문자 ==> 날짜

날짜 ==> 문자 ==> 날짜
문자 ==> 날짜 ==> 문자

SYSDATE(날짜)를 이용하여 현재 월의 1일자 날짜로 변경하기

NULL 관련 함수
1. NVL(expr1, expr2)
    if(expr1 == null)
        System.out.println(expr2);
    else
        System.out.println(expr1);
        
2. NVL2(expr1, expr2, expr3)      --첫번째(sal)에 null이 없으면 두번째(comm)가 나오고 아니면 세번째가 나온다.
--  NVL2(comm, sal+comm, sal) -> comm 이 null이 아니면 sal+comm, 그렇지 않으면 sal
    if(expr1 != null)
        System.out.println(expr2);
    else
        System.out.println(expr3);

3. NULLIF(expr1, expr2)
       if(expr1 == expr2)
            System.out.println(NULL);
      else
            System.out.println(NULL);

위에는 인자가 정해져있었어
함수중에는 인자가 정해져 있지 않은 애들이 있는데 
아래

함수의 인자 개수가 정해지지 않고 유동적으로 변경이 가능한 인자 : 가변인자(물론 규칙은 있음 동일한 타입이어야함)
            
4. coalesce(expr1, expr2, expr3 ....) -> coalesce의 인자중 가장 처음으로 등장하는 NULL이 아닌 인자를 반환
    if(expr1 != NULL)
        System.out.println(expr1)
    else    
        coalesce(expr2, expr3 ....)
        
coalesce(null, null, 5, 4)        
  ==> coalesce(null, 5, 4) // null이 처음에 있으니깐
    ==> coalesce(5, 4) // 그다음에 또 null이 있으니깐
        System.out.println(5)
     
        
--첫번째 인자에 null이 있으면 0이 나오고 두번째 인자에 null 이 있음 comm이 나와라 그게 NVL함수임.
SELECT empno, sal, comm, sal+comm, NVL(comm, 0), sal + NVL(comm, 0) //마지막거 null이 있을때 0으로 해주고 sal을 더해라
FROM emp;
        
        
comm 컬럼이 NULL일때 0으로 변경하여 sal 컬럼과 합계를 구한다.
SELECT empno, ename, sal, comm,
       sal + NVL(comm, 0) nvl_sum,
       NVL(comm + sal, sal) nvl_sum2,
       sal + NVL2(comm, 0, 0) nvl2_sum,
       NVL2(comm, sal+comm, sal) nvl2_sum2,  --  comm이 null이 아니면 sal+comm, 그렇지 않으면 sal
       NULLIF(sal, sal) nullif,
       NULLIF(sal, 5000) nullif_sal,
       sal + COALESCE(comm, 0) coalesce_sum,
       COALESCE(sal + comm, sal) coalesce_sum2       
FROM emp;

문제4
SELECT empno, ename, mgr, NVL(mgr, 9999), NVL2(mgr, mgr, 9999), COALESCE(mgr, 9999 )
FROM emp;

TO_CHAR(TO_DATE('20200908', 'YYYYMMDD'), 'YYYY/MM/DD') 

문제5
SELECT userid, usernm, reg_dt, NVL(reg_dt,SYSDATE) n_reg_dt
FROM users
WHERE userid != 'brown'; --부정형

or

SELECT userid, usernm, reg_dt, NVL(reg_dt,SYSDATE) n_reg_dt
FROM users
WHERE userid IN ('cony', 'sally', 'james', 'moon'); --긍정형




조건 : condition
java 조건 체크 : if, switch

if(조건)
    실행할 문장
else if(조건)
    실행할 문장
else
    실행할 문장
       
       
SQL : CASE 절    
CASE
    WHEN 조건 THEN 반환할 문장
    WHEN 조건2 THEN 반환할 문장
    ELSE 반환할 문장
END 

emp 테이블에서 job 컬럼의 값이 
    'SALESMAN'이면 sal 값에 5%를 인상한 급여를 반환  sal * 1.05
    'MANAGER'이면 sal 값에 10%를 인상한 급여를 반환  sal * 1.10
    'PRESIDENT'이면 sal 값에 20%를 인상한 급여를 반환  sal * 1.20
    그밖의 직군('CLERK', 'ANALYST')은 sal 값 그대로 반환

예 : CASE절을 이용 새롭게 계산한 sal_b
SMITH : 800, ALLEN : 1680

SELECT ename, job, sal, 
       CASE
           WHEN job = 'SALESMAN' THEN sal * 1.05
           WHEN job = 'MANAGER' THEN sal * 1.10
           WHEN job = 'PRESIDENT' THEN sal * 1.20
           ELSE sal
           END sal_b
FROM emp;


가변인자 - 계속 증가 가능해서 가변인자 - decode를 더 많이씀
DECODE(col|expr1,
                 search1, return1, 
                 search2, return2,
                 search3, return3,
                 .
                 .
                 .
                 .
                 [default])
첫번째 컬럼이 두번째 컬럼(search1)과 같으면 세번째 컬럼(return1)을 리턴
첫번째 컬럼이 네번째 컬럼(search2)과 같으면 다섯번째 컬럼(return2)을 리턴
첫번째 컬럼이 여섯번째 컬럼(search3)과 같으면 일곱번째 컬럼(return3)을 리턴
일치하는 값이 없을 때는 default 리턴


SELECT ename, job, sal, 
       CASE
           WHEN job = 'SALESMAN' THEN sal * 1.05
           WHEN job = 'MANAGER' THEN sal * 1.10
           WHEN job = 'PRESIDENT' THEN sal * 1.20
           ELSE sal
       END sal_b,
       --위에는 case를 이용해서 아래는 decode를 이용해서
       DECODE(job,
                  'SALESMAN', sal * 1.05,
                  'MANAGER', sal * 1.10,
                  'PRESIDENT', sal * 1.20,
                  sal) sal_decode
FROM emp;

CASE, DECODE 둘다 조건 비교시 사용
차이점 : DECODE 경우 값 비교가 = (EQUAL)에 대해서만 가능
                      복수조건은 DECODE를 중첩하여 표현 
        CASE는 부등호 사용가능, 복수개의 조건 사용가능
            (CASE 
                 WHEN sal > 3000 AND job = 'MANAGER');
                 
SELECT empno, ename, deptno, job
FROM emp;
                 
문제 cond1
SELECT empno, ename, deptno,
       CASE
           WHEN deptno = 10 THEN 'ACCOUNTING'
           WHEN deptno = '20' THEN 'RESEARCH'
           WHEN deptno = 30 THEN 'SALES'
           WHEN deptno = 40 THEN 'OPERATIONS'
           ELSE 'DDIT' --else는 없어도 돼
       END dname, --end는 없으면 안돼
       DECODE(deptno,
                10, 'ACCOUNTING',
                20, 'RESEARCH',
               '30', 'SALES',
                40, 'OPERATIONS',
                'DDIT') dname
FROM emp;

SELECT ename, job, sal, 
       CASE
           WHEN job = 'SALESMAN' THEN sal * 1.05
           WHEN job = 'MANAGER' THEN sal * 1.10
           WHEN job = 'PRESIDENT' THEN sal * 1.20
           ELSE sal
       END sal_b,
       --위에는 case를 이용해서 아래는 decode를 이용해서
       DECODE(job,
                  'SALESMAN', sal * 1.05,
                  'MANAGER', sal * 1.10,
                  'PRESIDENT', sal * 1.20,
                  sal) sal_decode
FROM emp;
                 
                 
                 
문제 cond2
힌트
1. 해당직원이 홀수년도 태생이면 1, 짝수년도 태생이면 0값을 갖는 컬럼생성
2. 올해년도가 홀수년인지 짝수년인지 1,0 값을 갖는 컬럼생성
위 두개가 같으면 대상자

SELECT empno, ename,hiredate, 
    CASE   
    WHEN mod(TO_CHAR(hiredate, 'yy'),2) = mod(TO_CHAR(SYSDATE,'yy'),2) 
    THEN '건강검진 대상자'
    ELSE '건강검진 비대상자' 
    END
FROM emp;


문제 cond3 - 없을때는(null) 비대상자로 해라
SELECT userid, usernm, reg_dt,
   CASE WHEN MOD(TO_CHAR(reg_dt, 'yy'),2) = mod(TO_CHAR(SYSDATE,'yy'),2)
   THEN '건강검진 대상자'
   ELSE '건강검진 비대상자' 
   END contacttodoctor,
   DECODE(MOD(TO_CHAR(reg_dt, 'yy'),2),mod(TO_CHAR(SYSDATE,'yy'),2), '건강검진 대상자', '건강검진 비대상자') contacttodoctor
FROM users;
