인덱스 생성 방법
1. 자동생성
UNIQUE, PRIMARY KEY 생성시
해당 컬럼으로 이루어진 인덱스가 없을 경우 해당 제약조건명으로 인덱스를 자동 생성

ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);
empno컬럼을 선두 컬럼으로 하는 인덱스가 없을 경우 pk_emp이름으로 UNIQUE 인덱스를 자동 생성.

  UNIQUE : 컬럼의 중복된 값이 없음을 보장하는 제약조건
  PRIMARY KEY : UNIQUE + NOT NULL

DBMS 입장에서는 신규 데이터가 입력되거나 기존 데이터가 수정될 때
UNIQUE 제약에 문제가 없는지 확인 ==> 무결성을 지키기 위해.

빠른 속도로 중복 데이터 검증을 위해 오라클에서는 UNIQUE, PRIMARY KEY 생성시
해당컬럼으로 인덱스 생성을 강제한다.

PRIMARY KEY : 제약조건 생성 후 해당 인덱스 삭제 시도시 삭제가 불가

FOREIGN KEY : 입력하려는 데이터가 참조하는 테이블의 컬럼에 존재하는 데이터만
                입력되도록 제한

 emp 테이블에 brown 사원을 50번 부서에 입력을 하게되면 50번 부서가 dept테이블의
  deptno 컬럼에 존재여부를 확인하여 존재할 시에만 emp 테이블에 데이터를 입력.



문제 idx1-2 
CTAS -> 아래를 이렇게 부름 씨- 타스 
CREATE TABLE dept_test2 AS
SELECT *
FROM dept
WHERE 1 = 1;    

==> where절이 참일때 저렇게 씨타스해주면 테이블명으로 dept테이블이 똑같이 하나 더 생김.
만약 where절이 거짓이면 테이블 구조만. 데이터는 말고 컬럼명등 그런것만 카피-페이스트 함.


1.  deptno UNIQUE
CREATE UNIQUE INDEX idx_dept_test2_u_01 ON dept_test2 (deptno);
DROP INDEX idx_dept_test2_u_01;

2. dname non-UNIQUE    
CREATE INDEX idx_dept_test2_n_02 ON dept_test2 (dname);
DROP INDEX idx_dept_test2_n_02;

3. deptno, dname을 기준으로 non-unique 인덱스 생성
CREATE INDEX idx_dept_test2_n_03 ON dept_test2 (deptno, dname);
DROP INDEX idx_dept_test2_n_01;


DROP TABLE dept_test2;


실습 idx3

SELECT *
FROM dept_test2;

SELECT *
FROM EMP;

SELECT *
FROM DEPT;

SELECT *
FROM EMP, DEPT
WHERE EMP.DEPTNO = DEPT.DEPTNO
AND EMP.DEPTNO = :DEPTNO
AND EMP.EMPNO LIKE :EMPNO || '%';


문제idx3 풀이
1. empno(=) (1)
2. ename(=) (2)
3. deptno(=), empno(LIKE :empno || '%') (1)
4. deptno(=), sal(BETWEEN)
5. deptno(=), mgr컬럼이 있을 경우 테이블 엑세스 불필요
   empno(=) (1)
6. deptno, hiredate 컬럼으로 구성된 인덱스가 있을 경우 테이블 엑세스 불필요


1. CREATE UNIQUE INDEX idx_emp_u_01 ON emp(empno, deptno);
2. CREATE UNIQUE INDEX idx_emp_u_02 ON emp(ename);

(3,4,5,6을 합친거)
3. CREATE INDEX idx_emp_dept_n_03 ON emp(deptno, mgr, sal, hiredate);

select *
from emp;

DELETE emp
WHERE empno = 64;

EXPLAIN PLAN FOR
SELECT deptno, TO_CHAR(hiredate, 'yyyymm'),  
       COUNT(*) cnt
FROM EMP
GROUP BY deptno, TO_CHAR(hiredate, 'yyyymm');

ALTER TABLE emp MODIFY (deptno NOT NULL, hiredate NOT NULL);

SELECT *
FROM TABLE(dbms_xplan.display);


CREATE INDEX idx_emp_n_05 ON emp (deptno, hiredate);  

FBI : Function Based Index 함수기반인덱스
CREATE INDEX idx_emp_dept_n_03 ON emp(deptno, mgr, sal, TO_CHAR(hiredate, 'yyyymm'));
DROP INDEX idx_emp_n_05;


CREATE INDEX idx_emp_n_05 ON emp (deptno, hiredate);  
CREATE INDEX idx_emp_n_05 ON emp (deptno, TO_CHAR(hiredate, 'yyyymm'));  
WHERE deptno = 10
  AND TO_CHAR(hiredate, 'yyyymm') = '202005'



인덱스 사용에 주의할 점, 중요한 점

인덱스 구성컬럼이 모두 NULL이면 인덱스에 저장을 하지 않는다
즉 테이블 접근을 해봐야 해당 행에 대한 정보를 알 수 있다
가급적이면 컬럼에 값이 NULL이 들어오지 않을경우는 NOT NULL 제약을 적극적으로 활용
==> 오라클 입장에서 실행계획을 세우는데 도움이 된다

+ 안그러면 테이블을 통으로 읽으려고 ? explain plan for 검색해보면 full scan로 뜸.


idx4 과제

DROP INDEX idx_dept_u_03;
CREATE UNIQUE INDEX idx_emp_u_01 ON emp (empno,deptno);
CREATE INDEX idx_emp_02 ON emp(deptno,sal);
CREATE UNIQUE INDEX idx_dept_u_03 ON dept (deptno, loc);


SELECT *
FROM DEPT;

emp empno (=)
emp deptno(=) , empno(LIKE) 
dept deptno (=)


1. --(emp)empno(=)
2. (emp)empno(LIKE) , (emp)deptno(=)
3. (dept)deptno(=)
4. (emp)deptno(=), (emp)sal(BETWEEN)
5. (emp)deptno(=), (dept)deptno(=), (dept)loc(=)


EXPLAIN PLAN FOR
SELECT *
FROM emp e, dept d
WHERE e.deptno = d.deptno
AND e.deptno = :deptno
AND d.loc = :loc;


EXPLAIN PLAN FOR
SELECT *
FROM emp e, dept d
WHERE e.deptno = d.deptno
AND e.deptno = :deptno
AND e.empno LIKE :empno || '%';

SELECT *
FROM dept d
WHERE e.deptno = d.deptno
AND e.deptno = :deptno
AND d.loc = :loc;

SELECT *
FROM TABLE(dbms_xplan.display);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = :empno;

SELECT *
FROM TABLE(dbms_xplan.display);







Synonym : 동의어
오라클 객체에 별칭을 생성한 객체
오라클 객체를 짧은 이름으로 지어줄 수 있다.

생성방법
CREATE [PUBLIC] SYNONYM 동의어 이름 FOR 오라클 객체;
[PUBLIC] : 공용동의어 생성시 사용하는 옵션.
           시스템 관리자 권한이 있어야 생성가능.

emp테이블에 e라는 이름으로 synonym을 생성           

CREATE SYNONYM e FOR emp;

SELECT *
FROM v_emp;

SELECT *
FROM e;


DICTIONARY : 오라클의 객체 정보를 볼수 있는 VIEW

dictionary의 종류는 dictionary view를 통해 조회 가능

SELECT *
FROM dictionary;

DICTIONARY는 크게 4가지로 구분 가능
    USER_ : 해당 사용자가 소유한 객체만 조회
    ALL_ : 해당 사용자가 소유한 객체 + 다른 사용자로부터 권한을 부여받은 객체
    DBA_ : 시스템 관리자만 볼수 있으며 모든 사용자의 객체 조회
    V$ : 시스템 성능과 관련된 특수 VIEW

SELECT *
FROM user_tables;

SELECT *
FROM all_tables;

DBA 권한이 있는 계정에서만 조회 가능(SYSTEM, SYS)
SELECT *
FROM dba_tables;




폴더3. SQL 응용
Multiple insert : 조건에 따라 여러 테이블에 데이터를 입력하는 INSERT

기존에 배운 쿼리는 하나의 테이블에 여러건의 데이터를 입력하는 쿼리
INSERT INTO emp (empno, ename)
SELECT empno, ename
FROM emp;

MULTIPLE INSERT
1. UNCONDITIONAL INSERT : 여러 테이블에 insert
2. CONDITIONAL ALL INSERT : 조건을 만족하는 모든 테이블 insert
3. CONDITIONAL FIRST INSERT : 조건을 만족하는 첫번째 테이블에 insert.

1. UNCONDITIONAL INSERT : 조건과 관계없이 여러 테이블에 insert
DROP TABLE emp_test;
DROP TABLE emp_test2;


CREATE TABLE emp_test AS
SELECT empno, ename
FROM emp
WHERE 1=2; --where절에 참인지 거짓인지에 따라서 모든 데이터가 안나와.
-- 테이블구조만 복사하고 싶을때 이렇게 함다
-- 만약 where 1=1; 라고 한다면 데이터까지 다 복사되서 갖고옴.


CREATE TABLE emp_test2 AS
SELECT empno, ename
FROM emp
WHERE 1=2;

INSERT ALL INTO emp_test
           INTO emp_test2
SELECT 9999, 'brown' FROM dual UNION ALL
SELECT 9998, 'sally' FROM dual;

SELECT *
FROM emp_test;

SELECT *
FROM emp_test2;


UNCONDITIONAL INSERT 실행시 테이블 마다 데이터를 입력할 컬럼을 조작하는 것이 가능
위에서 : INSERT INTO emp_test VALUES(....) 테이블의 모든 컬럼에 대해 입력
        INSERT INTO emp_test (empno) VALUES (9999) 특정 컬럼을 지정하여 입력 가능

INSERT ALL
    INTO emp_test (empno) VALUES(eno)
    INTO emp_test2 (empno, ename) VALUES(eno, enm)   
SELECT 9999 eno, 'brown' enm FROM dual UNION ALL
SELECT 9998, 'sally' FROM dual;
        
SELECT *
FROM emp_test;

SELECT *
FROM emp_test2;

CONDITIONAL INSERT : 조건에 따라 데이터를 입력
CASE
    WHEN job = 'MANAGER' THEN sal * 1.05
    WHEN job = 'PRESIDENT' THEN sal * 1.2
END

ROLLBACK;

INSERT ALL
    WHEN eno >= 9500 THEN 
        INTO emp_test VALUES (eno,enm)
        INTO emp_test2 VALUES (eno,enm) --꼭 하나의 테이블만 아니고 여러개 해도됨.
    WHEN eno >= 9900 THEN 
        INTO emp_test2 VALUES (eno,enm)    
SELECT 9500 eno, 'brown' enm FROM dual UNION ALL
SELECT 9998, 'sally' FROM dual;







