VIEW란 무엇인가
-> 뷰는 쿼리이다. 물리적인 데이터를 갖고 있지 않다. 논리적인 데이터 정의 집합이다.
   데이터를 정의하는 SELECT 쿼리이다.
-> VIEW가 사용하고 있는 테이블의 데이터가 바뀌면 VIEW 조회 결과도 같이 바뀐다.

VIEW를 사용하는 사례
1. 데이터 노출을 방지
    (emp테이블의 sal, comm을 제외하고 view를 생성, HR계정에게 view를 조회 할 수 있는 권한을 부여
    HR 계정에서는 emp테이블을 직접 조회하지 못하지만 v_emp는 가능하다.
    ==> V_EMP에는 sal, comm컬럼이 존재하지 않기 때문에 급여관련 정보를 감출 수 있다)
    
2. 자주 사용되는 쿼리를 view 만들어서 재사용
     ex : emp 테이블은 dept 테이블이랑 조인되서 사용되는 경우가 많음
        view를 만들지 않을경우 매번 조인 쿼리를 작성해야하나, view로만 들면
        재사용이 가능

3. 쿼리가 간단해진다  


emp테이블과 dept테이블을 deptno가 같은 조건으로 조인한 결과를 v_emp_dept 이름으로 
view 생성

CREATE OR REPLACE VIEW v_emp_dept AS
SELECT emp.*, dept.dname, dept.loc
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT *
FROM v_emp_dept;

SELECT *
FROM emp;


view 삭제
DROP VIEW 뷰이름;
DROP VIEW v_emp_dept;


CREATE VIEW v_emp_cnt AS
SELECT deptno, COUNT(*) cnt
FROM emp
GROUP BY deptno;

SELECT *
FROM v_emp_cnt
WHERE deptno = 10;
위에 처럼 뷰를 이용해서 쿼리를 만들어놓으면 조인해서 길게 쿼리를 작성하지 않아도
쉽고 간단하게 내가 원하는 데이터 검색이 가능하지.


UPDATE emp SET JOB = 'RANGER'
WHERE empno = 7369;

UPDATE v_emp SET JOB = 'RANGER'
WHERE empno=7369;

ROLLBACK;




SEQ_사용할테이블이름;
SEQUENCE : 중복되지 않는 정수값을 만들어내는 오라클 객체
(연달아 일어남, 순서)
 JAVA : UUID 클래스를 통해 중복되지 않는 문자열을 생성 할 수 있다.(뭔가 자바에서 행을 여러개 입력했는데...)
 
V_
SEQ_사용할테이블이름; 
문법 : CREATE SEQUENCE 시퀀스이름;

시퀀스는 롤백을 하더라도 읽은 값이 복원되지 않는다.
CREATE SEQUENCE SEQ_emp;

사용방법 : 함수를 생각하자.
함수테스트 : dual테이블에서
시퀀스 객체명.nextval : 시퀀스 객체에서 마지막으로 사용한 다음 값을 반환
시퀀스 객체명.currval : nextval 함수를 실행하고 나서 사용할 수 있다.
                       nextval 함수를 통해 얻어진 값을 반환

SELECT seq_emp.nextval  --next value의 약자 
FROM dual;
위에거 하면 계속 숫자가 증가함. next value를 시퀀스대로, 순서대로, 만들어 내는거

SELECT seq_emp.currval  --현재 내가 읽고 있는 값을 알고싶을때 쓰는 함수 current value
FROM dual;

DROP SEQUENCE SEQ_emp;


사용예
INSERT INTO emp (empno, ename, hiredate)
            values (seq_emp.nextval, 'brown', sysdate);
==> empno를 시퀀스로 만든 숫자로 넣는거지. 순번을 넣을때. 순서. 시퀀스=순서

SELECT *
FROM emp;


15101001 : 앞 두자리 : 회사가 세워진후 지난 년도 (2011, 1996)
           다음 네자리 : 입사 월, 일자 10월 10일 입사
           마지막 두자리 : 01 : 입사일자에 입사한 순번

의미가 있는 값에 대해서는 시퀀스만 갖고 만들수 없다. (예 : 학번, 사번 15101001)
시퀀스를 통해서는 중복되지 않는 값을 생성 할 수 있다. 그냥 순서대로 번호를 뽑아내니까. 

시퀀스는 롤백을 하더라도 읽은 값이 복원되지 않는다.

DROP SEQUENCE "YEZ"."SEQ_EMP";

CREATE SEQUENCE  "YEZ"."SEQ_EMP" 
    MINVALUE 1 
    MAXVALUE 9999999999999999999999999999 
    INCREMENT BY 5 
    START WITH 21 
    CACHE 20 
    NOORDER  
    NOCYCLE ;  
    
SELECT "YEZ"."SEQ_EMP".nextval
FROM dual;
==> 시퀀스 처음에 만들고 나서 넥스트해줘서 실행?해주면 21부터 시작하고 클릭 할때마다 5씩 증가함.

SELECT "YEZ"."SEQ_EMP".currval
FROM dual;    
 
rollback;
 

 
인덱스    
INDEX : TABLE의 일부 컬럼을 기준으로 미리 정렬해둔 객체
ROWID : 테이블에 저장된 행의 위치를 나타내는 값 
==> rowID는 원래부터 있어. 근데 보이지가 않았던거지.
로우넘처럼 설정해주지 않아도 그냥 검색하면 바로 떠.

SELECT ROWID, empno, ename
FROM emp;

SELECT ROWID, deptno, dname
FROM dept;

SELECT ROWID, cid, pid
FROM cycle;

만약 ROWID를 알수만 있으면 해당 테이블의 모든 데이터를 뒤지지 않아도
해당 행에 바로 접근을 할 수가 있다

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE ROWID = 'AAAE5hAAFAAAACLAAA';

SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 1116584662
 
-----------------------------------------------------------------------------------
| Id  | Operation                  | Name | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------------
|   0 | SELECT STATEMENT           |      |     1 |    38 |     1   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY USER ROWID| EMP  |     1 |    38 |     1   (0)| 00:00:01 |
-----------------------------------------------------------------------------------




BLOCK 블록!!!
BLOCK이 뭔지 잘 알아야 하는데
BLOCK : 오라클의 기본 입출력단위
block의 크기는 데이터 베이스 생성시 결정, 기본값이 8K byte.

DESC emp;

emp 테이블 한 행은 최대 54byte
block 하나에는 emp테이블을 8000/54= 160행이 들어갈 수 있음

사용자가 한 행을 읽어도 해당 행이 담겨져 있는 block을 전체로 읽는다.
(파일저장할때 140메가바이트라고 적혀있어도 실제로 저장된 크기를 보면 그거 보다 좀 더 큼. 읽을때 실행하는 인덱스 때문에???);


SELECT *
FROM user_constraints
WHERE table_name = 'EMP';
==> 내가 만든 제약조건을 검색하게 해주는 딕셔너리.

EMP 테이블의 EMPNO 컬럼에 PRIMARY KEY 추가
ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);


PRIMARY KEY(UNIQUE + NOT NULL), UNIQUE 제약을 생성하면 해당 컬럼으로 인덱스를 생성한다. 
==> 인덱스가 있으면 값을 빠르게 찾을 수 있다. -> 그렇지 
   해당 컬럼에 중복된 값을 빠르게 찾기 위한 제한사항 
   -> 유니크걸면 중복된 데이터를 못만들고(empno한테 유니크 걸어도 되지. 사원넘버는 하나이니까)
   -> primary key는 유니크랑 낫널이 들어가서. 중복되면 안되고 널값이 있어도 안되고. 괜찮지. 사원넘버는 온리원, 널이면 안되고.


SELECT empno, ROWID
FROM emp
ORDER BY empno;



시나리오 0
테이블만 있는경우(제약조건, 인덱스가 없는 경우)

SELECT *
FROM emp
WHERE empno = 7782;
==> 테이블에는 순서가 없기 때문에 emp테이블의 14건의 데이터를 모두 뒤져보고 
empno값이 7782인 건에 대해서만 사용자에게 반환을 한다.
내눈엔 당연히 7782는 하나지만, 오라클은 그걸 몰라서 14개 일일이 다 뒤져보고 7782 하나 있네? 하고 그 값을 출력해주는것.
Plan hash value: 3956160932
 
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     1 |    38 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    38 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("EMPNO"=7782)

==> 근데 왜 14개 다있는데 아닌거지??????????????????????????????????????????????????




시나리오 1
emp 테이블의 empno컬럼에 PK_EMP 유니크 인덱스가 생성된경우
(우리는 인덱스를 직접 생성하지 않았고 PRIMARY KEY 제약조건에 의해 자동으로 이미 생성 되어있음);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 2949544139
 
--------------------------------------------------------------------------------------
| Id  | Operation                   | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |        |     1 |    38 |     1   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP    |     1 |    38 |     1   (0)| 00:00:01 |
|*  2 |   INDEX UNIQUE SCAN         | PK_EMP |     1 |       |     0   (0)| 00:00:01 |
--------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7782)


--이건 그냥 내가 궁금해서
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE deptno = 10;

SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 3956160932
 
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     3 |   114 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     3 |   114 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("DEPTNO"=10)





시나리오 2
emp 테이블의 empno컬럼에 PRIMARY KEY 제약조건이 걸려 있는 경우
SELECT empno
FROM emp
WHERE empno = 7782;

시나리오 1이랑 다른건 셀렉이 이건 empno만 선택.


EXPLAIN PLAN FOR
SELECT empno
FROM emp 
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 56244932
 
----------------------------------------------------------------------------
| Id  | Operation         | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |        |     1 |     4 |     0   (0)| 00:00:01 |
|*  1 |  INDEX UNIQUE SCAN| PK_EMP |     1 |     4 |     0   (0)| 00:00:01 |
----------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("EMPNO"=7782)


--위에는 프라이머리키 넣어준거
--아래는 non유니크로 인덱스 만들어준거 - 넌유닠이니까 중복이 되어도..되는건데?? 흠..
Plan hash value: 3560872928
 
---------------------------------------------------------------------------------
| Id  | Operation        | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------------
|   0 | SELECT STATEMENT |              |     1 |     4 |     1   (0)| 00:00:01 |
|*  1 |  INDEX RANGE SCAN| IDX_EMP_N_01 |     1 |     4 |     1   (0)| 00:00:01 |
---------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("EMPNO"=7782)



UNIQUE 인덱스 : 인덱스 구성의 컬럼의 중복 값을 허용하지 않는 인덱스 (emp.empno)
NON-UNIQUE 인덱스 : 인덱스 구성 컬럼의 중복 값을 허용하는 인덱스   (emp.deptno, emp.job)


시나리오3
emp 테이블의 empno컬럼에 non-unique 인덱스가 있는경우
ALTER TABLE emp DROP CONSTRAINT fk_emp_emp;
ALTER TABLE emp DROP CONSTRAINT pk_emp;

IDX_테이블명_U_01  ==> 유니크
IDX_테이블명_N_02  ==> non유니크
CREATE INDEX IDX_emp_N_01 ON emp (empno);

RANGE SCAN 을 "Plus One SCAN" 이라고도 한다. 불필요한 걸 하나 더 보면 쭉 내려가야하는지 아닌지 알수있어서. 정렬이니까


EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);


Plan hash value: 2445276743

--------------------------------------------------------------------------------------------
| Id  | Operation                   | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |              |     1 |    38 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP          |     1 |    38 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_N_01 |     1 |       |     1   (0)| 00:00:01 |
--------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   2 - access("EMPNO"=7782)




시나리오4
emp 테이블의 job 컬럼으로 non-unique 인덱스를 생성한 경우
CREATE INDEX idx_emp_n_02 ON emp (job);

emp 테이블에는 현재 인덱스가 2개 존재
idx_emp_n_01 : empno  ==> 얘는 프라이머리키가 들어가서
idx_emp_n_02 : job    ==> 얘는 넌유니크가 들어가서 인덱스를 생성


SELECT job, ROWID
FROM emp
ORDER BY job;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER';

SELECT *
FROM TABLE(dbms_xplan.display); 

Plan hash value: 431958961
 
--------------------------------------------------------------------------------------------
| Id  | Operation                   | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |              |     3 |   114 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP          |     3 |   114 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_N_02 |     3 |       |     1   (0)| 00:00:01 |
--------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER')





시나리오 5
emp 테이블에는 현재 인덱스가 2개 존재
idx_emp_n_01 : empno
idx_emp_n_02 : job

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display); 

Plan hash value: 431958961
 
--------------------------------------------------------------------------------------------
| Id  | Operation                   | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |              |     1 |    38 |     2   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS BY INDEX ROWID| EMP          |     1 |    38 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_N_02 |     3 |       |     1   (0)| 00:00:01 |
--------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("ENAME" LIKE 'C%')
   2 - access("JOB"='MANAGER')

==> 지금 매니저한테 논유닉 인덱스가 들어가있지. 그게 IDX_EMP_N_02이거. 
우선 처음에는 ename으로 가서 C로 시작하는 이름을 찾아. 필터링 해서 찾은 값의 rowid를 이용해서 바로 잡이 매니저인 사람한테 access해서 출력.




시나리오6
CREATE INDEX idx_emp_n_03 ON emp ( job, ename);

emp 테이블에는 현재 인덱스가 3개 존재
idx_emp_n_01 : empno
idx_emp_n_02 : job
idx_emp_n_03 : job, ename

SELECT job, ename, ROWID
FROM emp
ORDER BY job, ename;


EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display); 

Plan hash value: 2102545684
 
--------------------------------------------------------------------------------------------
| Id  | Operation                   | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |              |     1 |    38 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP          |     1 |    38 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_N_03 |     1 |       |     1   (0)| 00:00:01 |
--------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER' AND "ENAME" LIKE 'C%')
       filter("ENAME" LIKE 'C%')

==> 갖고있는 인덱스 키는 다 중복 가능한 non-unique인데 어떻게 바로 access가 가능한거지?
그리고 왜 ("ENAME" LIKE 'C%') 두번 반복??????????????????????????




시나리오7
DROP INDEX idx_emp_n_03;
CREATE INDEX idx_emp_n_04 ON emp (ename, job);

emp 테이블에는 현재 인덱스가 3개 존재
idx_emp_n_01 : empno
idx_emp_n_02 : job
idx_emp_n_04 : ename, job


EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display); 

Plan hash value: 860547963
 
--------------------------------------------------------------------------------------------
| Id  | Operation                   | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |              |     1 |    38 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP          |     1 |    38 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_N_04 |     1 |       |     1   (0)| 00:00:01 |
--------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("ENAME" LIKE 'C%' AND "JOB"='MANAGER')
       filter("JOB"='MANAGER' AND "ENAME" LIKE 'C%')


==> ㅠㅠ???????????????



--실험

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE ename = ''
AND job LIKE '';

SELECT *
FROM TABLE(dbms_xplan.display); 

Plan hash value: 3896240783
 
---------------------------------------------------------------------------
| Id  | Operation          | Name | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------
|   0 | SELECT STATEMENT   |      |     1 |    38 |     0   (0)|          |
|*  1 |  FILTER            |      |       |       |            |          |
|   2 |   TABLE ACCESS FULL| EMP  |    14 |   532 |     3   (0)| 00:00:01 |
---------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter(NULL IS NOT NULL AND NULL IS NOT NULL)





시나리오8
emp 테이블의 empno 컬럼에 UNIQUE 인덱스 생성
dept 테이블의 deptno 컬럼에 UNIQUE 인덱스 생성

DROP INDEX idx_emp_n_01;
ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);
-- ALTER TABLE emp drop CONSTRAINT pk_emp ;
ALTER TABLE dept ADD CONSTRAINT pk_dept PRIMARY KEY (deptno);

SELECT *
FROM dept;
COMMIT;

emp 테이블에는 현재 인덱스가 3개 존재
pk_emp : empno
idx_emp_n_02 : job
idx_emp_n_04 : ename, job

dept 테이블에는 현재 인덱스가 1개 존재
pk_dept : deptno


이젠 조인이야. 테이블이 2개가 생겼어

EXPLAIN PLAN FOR
SELECT ename, dname, loc
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND emp.empno = 7788;

SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 2385808155
 
----------------------------------------------------------------------------------------
| Id  | Operation                    | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT             |         |     1 |    33 |     2   (0)| 00:00:01 |
|   1 |  NESTED LOOPS                |         |     1 |    33 |     2   (0)| 00:00:01 |
|   2 |   TABLE ACCESS BY INDEX ROWID| EMP     |     1 |    13 |     1   (0)| 00:00:01 |
|*  3 |    INDEX UNIQUE SCAN         | PK_EMP  |     1 |       |     0   (0)| 00:00:01 |
|   4 |   TABLE ACCESS BY INDEX ROWID| DEPT    |     4 |    80 |     1   (0)| 00:00:01 |
|*  5 |    INDEX UNIQUE SCAN         | PK_DEPT |     1 |       |     0   (0)| 00:00:01 |
----------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   3 - access("EMP"."EMPNO"=7788)
   5 - access("EMP"."DEPTNO"="DEPT"."DEPTNO")

