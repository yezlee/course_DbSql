yez.v_emp ==> v_emp

SELECT *
FROM yez.v_emp;

CREATE SYNONYM v_emp FOR sem.v_emp;

SELECT *
FROM v_emp;
