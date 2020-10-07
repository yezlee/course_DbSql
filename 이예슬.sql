문제1
SELECT ename, hiredate
FROM emp
WHERE hiredate >= '1982/01/01' AND hiredate <= '1983/01/01';


문제2
SELECT * 
FROM emp
WHERE job = 'SALESMAN' AND hiredate >= '1981/06/01';


문제3
SELECT *
FROM emp
WHERE deptno NOT IN(10) AND hiredate >= '1981/06/01';


문제4
SELECT ROWNUM, empno, ename
FROM emp
ORDER BY empno;


문제5
SELECT *
FROM emp
WHERE (deptno = 10 OR deptno = 30) AND sal > 1500
ORDER BY ename desc;


문제6
SELECT deptno, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal
FROM emp
GROUP BY deptno
ORDER BY deptno desc;


문제7
SELECT empno, ename, sal, emp.deptno, dname
FROM emp, dept 
WHERE emp.deptno = dept.deptno AND sal > 2500 AND empno > 7600 AND dname = 'RESEARCH';


문제8
SELECT empno, ename, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno AND emp.deptno IN (10,30)
ORDER BY empno;        


문제9
SELECT m.ename, e.ename mgr
FROM emp e, emp m
WHERE e.empno(+) = m.mgr;


문제10
SELECT TO_CHAR(hiredate, 'YYYYMM') hire_yyyymm, COUNT(*) cnt
FROM emp
GROUP BY hiredate;


문제11
SELECT *
FROM emp
WHERE deptno = (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH') OR deptno =  (SELECT deptno
                                                     FROM emp
                                                     WHERE ename = 'WARD')
ORDER BY deptno;


문제12
SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp);


문제13
INSERT INTO dept (deptno, dname, loc) VALUES (99, ddit, '대전');


문제 14
UPDATE dept SET dname = 'ddit_modi' , loc = '대전_modi'
WHERE deptno = 99;


문제 15
DELETE dept 
WHERE deptno = 99;



문제 16
CREATE TABLE dept (deptno NUMBER(2) NOT NULL, dname VARCHAR2(14 BYTE), loc VARCHAR2(13 BYTE),
                   CONSTRAINT PK_dept PRIMARY KEY (DEPTNO));
          
CREATE TABLE emp (empno NUMBER(4), ename VARCHAR2(20), job VARCHAR2(20), mgr NUMBER(4), 
                  hiredate sysdate DEFAULT, sal NUMBER(5), comm NUMBER(5), deptno NUMBER(2) NOT NULL);
      
          
ALTER TABLE emp ADD CONSTRAINT FK_emp_dept FOREIGN KEY (deptno) REFERENCES dept(deptno);



문제17
SELECT deptno, SUM(sal), GROUPING SETS(SELECT SUM(sal)
                                       FROM emp)
FROM emp
GROUP BY deptno;

SELECT deptno, SUM(sal)
FROM emp
GROUP BY ROLLUP (deptno);




문제18
SELECT ename, sal, deptno, hiredate, ROW_NUMBER () OVER (PARTITION BY deptno ORDER BY sal desc )
FROM emp;


문제19
SELECT empno, ename, hiredate, sal
FROM emp

문제20
SELECT empno, ename, deptno, sal, 
FROM 





