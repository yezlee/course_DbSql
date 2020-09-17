실습 order by2

SELECT empno, ename, job, mgr, hiredate, sal, comm, deptno
FROM emp
WHERE comm > 0
ORDER BY comm DESC, empno;

ROW_1
SELECT a.*
FROM   (SELECT ROWNUM rn, empno, ename
        FROM emp)a
WHERE rn BETWEEN 11 AND 14;

SELECT *
FROM(SELECT ROWNUM rn, a.*
     FROM (SELECT empno, ename
           FROM emp)a)
WHERE rn BETWEEN 11 AND 14;


SELECT ROWNUM RN, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 1 AND 5;


SELECT sal, TRUNC(sal/1000),sal/1000
FROM emp;

SELECT TO_DATE('19/12/31','yy/mm/dd') -5
FROM dual;



SELECT hiredate,
        SYSDATE A,
        ROUND(SYSDATE, 'YYYY') B,
        ROUND(SYSDATE, 'MM') C,
        ROUND(SYSDATE, 'DD') D,
        ROUND(SYSDATE, 'HH') E,
        ROUND(SYSDATE, 'MI') F
FROM emp
WHERE ename = 'SMITH';


SELECT NEXT_DAY(TO_DATE('20191010', 'YYYYMMDD'), '금요일')
FROM dual;

SELECT TO_CHAR(LAST_DAY(TO_DATE('201912','yyyymm')),'dd') dt
FROM dual;


SELECT *
FROM emp
WHERE ename 'Z'
ORDER BY;  




SELECT TO_CHAR(SYSDATE,'DD') + 55
FROM dual;















