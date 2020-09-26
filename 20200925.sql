REPORT GROUP FUNCTION
GROUP BY 의 확장 : SUBGROUP을 자동으로 생성하여 하나의 결과로 합쳐준다.

1. ROLLUP(COL1, COL2...)
    - 기술된 컬럼을 오른쪽에서부터 지원나가며 서브 그룹을 생성
    
2. GROUPING SETS( (COL1, COL2), COL3)
    -  , 단위로 기술된 서
    
3. CUBE(COL1, COL2...)
    - 컬럼의 순서는 지키되, 가능한 모든 조합을 생성한다.

GROUP BY CUBE(job, deptno)
    job    deptno
     0       0     ==> GROUP BY job, deptno
     0       X     ==> GROUP BY job 
     X       0     ==> GROUP BY deptno (롤업에는 없던 서브그룹)       
     X       0     ==> GROUP BY 전체
     
GROUP BY ROLLUP(job, deptno)  ==> 3개 


SELECT job, deptno, SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY CUBE(job, deptno);


CUBE의 경우 가능한 모든 조합으로 서브 그룹을 생성하기 때문에
2의 기술한 컬럼개수 승 만큼의 서브 그룹이 생성된다.
CUBE(col1, col2) : 4
CUBE(col1, col2, col3) : 8
CUBE(col1, col2, col3, col4) : 16

==> 경우의 수가 너무 많기 때문에 사용 잘 안함.



REPORT GROUP FUNCTION 조합
GROUP BY job, 
잡은 항상 디폴트가 되는거임.

SELECT job, deptno, mgr, SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY job, ROLLUP(deptno), CUBE(mgr);



상호 연관 서브 쿼리를 이용한 업데이트
1. EMP_TEST 테이블 삭제
2. EMP테이블을 사용하여 EMP_TEST 테이블 생성(모든 컬럼, 모든 데이터)
3. EMP_TEST 테이블에는 DNAME 컬럼을 추가( VARCHAR2(14) )
4. 상호 연관 서브쿼리를 이용하여 EMP_TEST 테이블의 DNAME 컬럼을 DEPT 테이블을 이용하여 UPDATE 할것임.

DROP TABLE emp_test;

CREATE TABLE emp_test AS
SELECT *
FROM emp;

ALTER TABLE emp_test ADD (dname VARCHAR2(14));

SELECT *
FROM emp_test;

UPDATE emp_test SET dname = (SELECT dname FROM dept WHERE deptno = emp_test.deptno);
COMMIT;


실습 sub_a1

DROP TABLE dept_test;

CREATE TABLE dept_test AS
SELECT *
FROM dept;

ALTER TABLE dept_test ADD ( empcnt NUMBER(5) );

SELECT *
FROM dept_test;



SELECT COUNT(deptno)
FROM emp
WHERE deptno = 10;

UPDATE dept_test SET empcnt = ( SELECT COUNT(*)
                                FROM emp
                                WHERE deptno = dept_test.deptno );

commit;


sub_a2
INSERT INTO dept_test (deptno, dname, loc) VALUES (99,'it1','daejeon');
INSERT INTO dept_test (deptno, dname, loc) VALUES (98,'it2','daejeon');
COMMIT;

SELECT deptno, dname
FROM dept_test;

부서에 속한 직원이 없는 부서를 삭제하는 쿼리를 작성하세요.
ALTER TABLE dept_test DROP COLUMN empcnt;

직원이 있는 부서 : 10, 20, 30
직원이 없는 부서 : 40, 98, 99


SELECT COUNT(*)
FROM emp
WHERE deptno = 40;

DELETE dept_test 
WHERE 0 = (SELECT COUNT(*)
           FROM emp
           WHERE deptno = 40);

이걸 40을 dept_test.deptno 이걸로 바꾼거지

DELETE dept_test 
WHERE 0 = (SELECT COUNT(*)
           FROM emp
           WHERE deptno = dept_test.deptno);
           
           
혹은 in으로 만들수도 있어

DELETE dept_test
WHERE deptno NOT IN (40 , 99 , 98);
이걸
아래처럼
DELETE dept_test
WHERE deptno NOT IN (SELECT deptno
                     FROM emp);
           
혹은 exist로 풀수도 있어       
DELETE dept_test
WHERE NOT EXISTS (SELECT 'X'
                  FROM emp
                  WHERE deptno = dept_text.deptno);
           
위에 두 문제를 잘생각해서
아래문제 풀어봐
실습 sub_a3(과제)





달력쿼리
달력만들기! : 행을 열로 만들기 - 레포트 쿼리에서 자주 사용하는 형태
주어진 것 : 년월 ( 수업시간에는 '202009' 문자열을 사용)

SELECT *
FROM dual
CONNECT BY LEVEL <= 30;
이렇게 하면 행이 30으로 확장됨.

SELECT dual.*, LEVEL
FROM dual
CONNECT BY LEVEL <= 30;

SELECT SYSDATE , LEVEL
FROM dual
CONNECT BY LEVEL <= 30;

SELECT SYSDATE + LEVEL, LEVEL
FROM dual
CONNECT BY LEVEL <= 30;


'202009' ==> 30
'202008' ==> 31
LAST_DAY(TO_DATE('202008', 'YYYYMM'))

SELECT TO_CHAR(LAST_DAY(TO_DATE('202008', 'YYYYMM')), 'DD')
FROM dual;

SELECT TO_DATE('202002', 'YYYYMM') + LEVEL  -- 이거 왜 2일부터 나오는건지 못들음
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('202002', 'YYYYMM')), 'DD');

SELECT TO_DATE('202002', 'YYYYMM') + LEVEL-1 day,
       TO_CHAR(TO_DATE('202002', 'YYYYMM') + LEVEL-1, 'D') d -- 이거 그 일자 구하는거. 1은 일요일이고,...
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('202002', 'YYYYMM')), 'DD');

SELECT TO_CHAR 


SELECT day, d, DECODE(d, 1, day) sun, DECODE(d, 2, day) mon,
               DECODE(d, 3, day) tue, DECODE(d, 4, day) wed,
               DECODE(d, 5, day) thu, DECODE(d, 6, day) fri
               DECODE(d, 7, day) sat
FROM (SELECT TO_DATE('202002', 'YYYYMM')+ LEVEL - 1 DAY,
             TO_CHAR(TO_DATE('202002', 'YYYYMM') + LEVEL-1, 'd') d,
             TO_CHAR(TO_DATE('202002', 'YYYYMM') + LEVEL-1, 'iw') iw
      FROM dual
      CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('202002', 'YYYYMM')), 'DD');


SELECT iw, MIN(DECODE(d, 1, day)) sun, MIN(DECODE(d, 2, day)) mon,
           MIN(DECODE(d, 3, day)) tue, MIN(DECODE(d, 4, day)) wed,
           MIN(DECODE(d, 5, day)) thu, MIN(DECODE(d, 6, day)) fri,
           MIN(DECODE(d, 7, day)) sat
FROM (SELECT TO_DATE('202002', 'YYYYMM')+ LEVEL - 1 day,
             TO_CHAR(TO_DATE('202002', 'YYYYMM') + LEVEL-1, 'd') d,
             TO_CHAR(TO_DATE('202002', 'YYYYMM') + LEVEL-1, 'iw') iw
      FROM dual
      CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('202002', 'YYYYMM')), 'DD'))
GROUP BY iw
ORDER BY iw;


SELECT DECODE(d, 1, iw+1, iw),
           MIN(DECODE(d, 1, day)) sun, MIN(DECODE(d, 2, day)) mon,
           MIN(DECODE(d, 3, day)) tue, MIN(DECODE(d, 4, day)) wed,
           MIN(DECODE(d, 5, day)) thu, MIN(DECODE(d, 6, day)) fri,
           MIN(DECODE(d, 7, day)) sat
FROM (SELECT TO_DATE('202002', 'YYYYMM')+ LEVEL - 1 day,
             TO_CHAR(TO_DATE('202002', 'YYYYMM') + LEVEL-1, 'd') d,
             TO_CHAR(TO_DATE('202002', 'YYYYMM') + LEVEL-1, 'iw') iw
      FROM dual
      CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('202002', 'YYYYMM')), 'DD'))
GROUP BY DECODE(d, 1, iw+1, iw)
ORDER BY DECODE(d, 1, iw+1, iw);


SELECT  MIN(DECODE(d, 1, day)) sun, MIN(DECODE(d, 2, day)) mon,
        MIN(DECODE(d, 3, day)) tue, MIN(DECODE(d, 4, day)) wed,
        MIN(DECODE(d, 5, day)) thu, MIN(DECODE(d, 6, day)) fri,
        MIN(DECODE(d, 7, day)) sat
FROM (SELECT TO_DATE('202002', 'YYYYMM')+ LEVEL - 1 day,
             TO_CHAR(TO_DATE('202002', 'YYYYMM') + LEVEL-1, 'd') d,
             TO_CHAR(TO_DATE('202002', 'YYYYMM') + LEVEL-1, 'iw') iw
      FROM dual
      CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('202002', 'YYYYMM')), 'DD'))
GROUP BY DECODE(d, 1, iw+1, iw)
ORDER BY DECODE(d, 1, iw+1, iw);


SELECT  DECODE(d, 1, iw+1, iw), MIN(DECODE(d, 1, day)) sun, MIN(DECODE(d, 2, day)) mon,
        MIN(DECODE(d, 3, day)) tue, MIN(DECODE(d, 4, day)) wed,
        MIN(DECODE(d, 5, day)) thu, MIN(DECODE(d, 6, day)) fri,
        MIN(DECODE(d, 7, day)) sat
FROM (SELECT TO_DATE(:yyyymm, 'YYYYMM')+ LEVEL - 1 day,
             TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + LEVEL-1, 'd') d,
             TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + LEVEL-1, 'iw') iw
      FROM dual
      CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'DD'))
GROUP BY DECODE(d, 1, iw+1, iw)
ORDER BY DECODE(d, 1, iw+1, iw);



복습 실습 calendar 1

SELECT SUM(rn = 1 AND rn =2)
FROM   (SELECT rownum rn, a.*
        FROM(SELECT *
             FROM sales) a); 


SELECT TO_CHAR(TO_DATE('201901' 'yyyymm'), 'mm'))
FROM dual; 

SELECT TO_CHAR(dt, 'mm'), sales
FROM sales;


SELECT TO_CHAR(dt, 'mm') mm, SUM(sales)
FROM sales
GROUP BY TO_CHAR(dt, 'mm');

SELECT mm, sales, 0 jan, 0 feb, 0 mar, 0 apr, 0 may, 0 jun
FROM
(SELECT TO_CHAR(dt, 'mm') mm, SUM(sales) sales
FROM sales
GROUP BY TO_CHAR(dt, 'mm'));


SELECT mm, sales, DECODE(mm, '01', sales) jan,
                  DECODE(mm, '02', sales) feb, 
                  DECODE(mm, '03', sales) mar, 
                  DECODE(mm, '04', sales) apr, 
                  DECODE(mm, '05', sales) may, 
                  DECODE(mm, '06', sales) jun
FROM
(SELECT TO_CHAR(dt, 'mm') mm, SUM(sales) sales
FROM sales
GROUP BY TO_CHAR(dt, 'mm')
ORDER BY TO_CHAR(dt, 'mm'));




SELECT  MIN(DECODE(mm, '01', sales)) jan,
        MIN(DECODE(mm, '02', sales)) feb, 
        MIN(DECODE(mm, '03', sales)) mar, 
        MIN(DECODE(mm, '04', sales)) apr, 
        MIN(DECODE(mm, '05', sales)) may, 
        MIN(DECODE(mm, '06', sales)) jun
FROM
(SELECT TO_CHAR(dt, 'mm') mm, SUM(sales) sales
FROM sales
GROUP BY TO_CHAR(dt, 'mm'));



SELECT  NVL(MIN(DECODE(mm, '01', sales)), 0) jan,
        NVL(MIN(DECODE(mm, '02', sales)), 0) feb, 
        NVL(MIN(DECODE(mm, '03', sales)), 0) mar, 
        NVL(MIN(DECODE(mm, '04', sales)), 0) apr, 
        NVL(MIN(DECODE(mm, '05', sales)), 0) may, 
        NVL(MIN(DECODE(mm, '06', sales)), 0) jun
FROM
(SELECT TO_CHAR(dt, 'mm') mm, SUM(sales) sales
FROM sales
GROUP BY TO_CHAR(dt, 'mm'));





계층쿼리


create table dept_h (
    deptcd varchar2(20) primary key ,
    deptnm varchar2(40) not null,
    p_deptcd varchar2(20),
    
    CONSTRAINT fk_dept_h_to_dept_h FOREIGN KEY
    (p_deptcd) REFERENCES  dept_h (deptcd) 
);

insert into dept_h values ('dept0', 'XX회사', '');
insert into dept_h values ('dept0_00', '디자인부', 'dept0');
insert into dept_h values ('dept0_01', '정보기획부', 'dept0');
insert into dept_h values ('dept0_02', '정보시스템부', 'dept0');
insert into dept_h values ('dept0_00_0', '디자인팀', 'dept0_00');
insert into dept_h values ('dept0_01_0', '기획팀', 'dept0_01');
insert into dept_h values ('dept0_02_0', '개발1팀', 'dept0_02');
insert into dept_h values ('dept0_02_1', '개발2팀', 'dept0_02');
insert into dept_h values ('dept0_00_0_0', '기획파트', 'dept0_01_0');
commit;


SELECT *
FROM dept_h
START WITH deptcd = 'dept0';

SELECT *
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;


SELECT deptcd, deptnm, LEVEL
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;


SELECT deptcd, LPAD(' ' , LEVEL*3) || deptnm,  LEVEL
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

SELECT deptcd, LPAD(' ' , (LEVEL-1)*3) || deptnm deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;







SELECT *
FROM emp, dept
WHERE 1 != 1;
           

SELECT *
FROM emp, dept
WHERE emp.deptno != dept.deptno;   

SELECT *
FROM emp, dept
WHERE emp.deptno != dept.deptno;  



SELECT emp.empno, emp.ename, (SELECT * 
                              FROM dept ,emp
                              WHERE dept.deptno = emp.deptno)d 
FROM emp;






SELECT *
FROM emp
ORDER BY job DESC, hiredate;

SELECT COUNT(deptno)
FROM emp;

SELECT *
FROM dual;

SELECT 'TEST1' || 'dummy'
FROM dual;


              
SELECT COUNT(* )
FROM emp
WHERE deptno = ( SELECT deptno
                 FROM emp
                 WHERE ename = 'SMITH');
        
SELECT m.empno, m.ename, e.empno, e.ename
FROM emp e, emp m
WHERE m.mgr = e.empno(+);

SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno(+);

SELECT *
FROM emp, dept;




SELECT MAX(sal), deptno
FROM emp
GROUP BY deptno;

SELECT  empno, emp.deptno, dname
FROM emp,dept
WHERE emp.deptno = dept.deptno;

SELECT *
FROM (SELECT ROWNUM rn, a.* 
      FROM (SELECT *
            FROM emp
            ORDER BY hiredate, ename) a)
WHERE rn BETWEEN (:page-1) * :pageSize +1 AND :page * :pageSize;            

SELECT *
FROM (SELECT ROWNUM rn, a.*
      FROM
        (SELECT empno, ename
         FROM emp
         ORDER BY ename) a )
WHERE rn BETWEEN (2 - 1) * 5 + 1 AND 2 * 5;


SELECT deptno, MAX(sal)
FROM emp
GROUP BY deptno;

SELECT empno, .deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT COUNT(deptno)
FROM dept
GROUP BY deptno;



SELECT *
FROM emp e
WHERE EXISTS (SELECT 'X'
	          FROM emp m
	          WHERE e.mgr = m.empno);

SELECT *
FROM emp
WHERE EXISTS (SELECT 'X'
	          FROM emp
	          WHERE mgr = empno);



SELECT *
FROM emp
WHERE 1 = 1;