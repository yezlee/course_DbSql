변수선언

복합변수
1. 행 정보(컬럼이 복수)를 담을 수 있는 변수(rowtype)
   ==> java로 비유를 하면, vo(filed가 여러개)
   컬럼 타입 : 테이블명.컬럼명%TYPE
   ROW 타입 : 테이블명%ROWTYPE
   
%ROWTYPE : 테이블의 행정보를 담을 수 있는 변수

SET SERVEROUTPUT ON;

emp테이블에서 

SELECT *
FROM emp
WHERE empno = 7369;


DECLARE
BEGIN
END;
/


DECLARE
 v_emp_row emp%ROWTYPE;
BEGIN
 SELECT * INTO v_emp_row
 FROM emp
 WHERE empno = 7369;
 
DBMS_OUTPUT.PUT_LINE('v_emp_row.empno : ' || v_emp_row.empno || 'v_emp_row.ename : ' || v_emp_row.ename);
END;
/




RECODE TYPE : 행의 컬럼 정보를 개발자가 직접 구성한 (커스텀마이징한)

사원테이블에서 empno, ename, deptno 3개의 컬럼을 저장할 수 있는 ROWTYPE 을 정의하고
해당타입의 변수를 선언하여 사번이 7369번인 사원의 위 3가지 컬럼 정보를 담아본다.

SELECT empno, ename, deptno
FROM emp
WHERE empno = 7369;



DECLARE
    TYPE t_emp_row IS RECORD(
        empno emp.empno%TYPE,
        ename emp.ename%TYPE,
        deptno emp.deptno%TYPE
    );
    
    v_emp_row t_emp_row;
    
BEGIN 
    SELECT empno, ename, deptno INTO v_emp_row
    FROM emp
    WHERE empno = 7369;
    DBMS_OUTPUT.PUT_LINE('v_emp_row.empno : ' || v_emp_row.empno || ',v_emp_row.ename :' || v_emp_row.ename);
END;
/




TABLE 타입 : 여러개의 행을 담을 수 있는 타입
 자바로 비유를 하면 List<Vo>
 
자바 배열과 pl/sql table 타입과 차이점
int[] intArr = new int[10];
배열의 첫번째 값을 접근 : intArr[0] index 번호 ==> 숫자로 고정
pl/sql intArr["username"]

테이블 타입선언
TYPE 테이블_타입이름 IS TABLE OF 행에대한타입 INDEX BY BINARY_INTEGER
테이블_타입_변수명 테이블_타입이름;

기존 : SELECT 쿼리의 결과가 한 행이어야만 정상적으로 통과
변경 : SELECT 쿼리의 결과가 복수 행이어도 상관 없다.

dept테이블의 모든행을 조회해서 테이블 타입 변수에 담고
테이블 타입변수를 루프(반복문)를 통해 값을 확인

DECLARE
    TYPE t_dept IS TABLE OF dept%ROWTYPE INDEX BY BINARY_INTEGER;
    v_dept t_dept;
BEGIN
    /* JAVA 배열 : v_dept[0]
    JAVA LIST : v_dept.get(0)
    PL/SQL 테이블타입 : v_dept(0) : v_dept(0).컬럼명 */
    
    SELECT * BULK COLLECT INTO v_dept
    FROM dept;
    
    FOR i IN 1..v_dept.COUNT LOOP
       DBMS_OUTPUT.PUT_LINE('v_dept(i).deptno : ' || v_dept(i).deptno
                            || ', v_dept(i).dname : ' || v_dept(i).dname);
    END LOOP;
END;
/



조건제어
    IF
    CASE - 2가지

반복문
    FOR LOOP(제일일반적)
    LOOP
    WHILE


IF 로직제어
자바는 IF하고 ()있는데
오라클은 그냥 씀

IF 조건문 THEN
    실행문장;
ELSIF 조건문 THEN
    실행문장;
ELSE
    실행문장;
END IF;


DECLARE
  /*p NUMBER;
    p := 5;
    위 두개랑 
    아래 한문장이랑 같은거  */  
    p NUMBER := 5;    
BEGIN
    IF p = 1 THEN
        DBMS_OUTPUT.PUT_LINE('P=1');
    ELSIF p = 2 THEN
        DBMS_OUTPUT.PUT_LINE('P=2');
    ELSIF p = 5 THEN
        DBMS_OUTPUT.PUT_LINE('P=5');    
    ELSE    
        DBMS_OUTPUT.PUT_LINE('DEFAULT');    
    END IF;    
END;
/

    
CASE
일반 CASE 
CASE expression(컬럼이나, 변수, 수식)
    WHEN value THEN
        실행할문장;
    WHEN value2 THEN
        실행할문장2;
    ELSE
        기본실행문장;
END CASE;        



PL/SQL (로직제어 - CASE - 일반케이스)

DECLARE 
    p NUMBER := 5;    
BEGIN
CASE P
    WHEN 1 THEN
       DBMS_OUTPUT.PUT_LINE('P=1');
    WHEN 2 THEN
       DBMS_OUTPUT.PUT_LINE('P=2');
    WHEN 5 THEN
       DBMS_OUTPUT.PUT_LINE('P=5');             
    ELSE
       DBMS_OUTPUT.PUT_LINE('DEFAULT');
END CASE;        
END;
/



PL/SQL (로직제어 - CASE - 검색케이스)
일반 CASE를 검색 CASE(JAVA의 IF)로 변경하기

DECLARE 
    p NUMBER := 5;    
BEGIN
CASE 
    WHEN p = 1 THEN
       DBMS_OUTPUT.PUT_LINE('P=1');
    WHEN P = 2 THEN
       DBMS_OUTPUT.PUT_LINE('P=2');
    WHEN P = 5 THEN
       DBMS_OUTPUT.PUT_LINE('P=5');             
    ELSE
       DBMS_OUTPUT.PUT_LINE('DEFAULT');
END CASE;        
END;
/


CASE 표현식 : SQL에서 사용한 CASE

변수 := CASE                         --이런식으로 대입문으로도 할수 있음
    WHEN 조건문1 THEN 반환할 값1
    WHEN 조건문2 THEN 반환할 값2
    ELSE 기본반환값
END


SELECT *
FROM EMP;

EMP테이블에서 7369번 사원의 SAL정보를 조회하여 
SAL 값이 1000보다 크면 SAL*1.2값을
SAL 값이 900보다 크면 SAL*1.3값을
SAL 값이 800보다 크면 SAL*1.4값을
위 세가지 조건을 만족하지 못할 때는 SAL*1.6값을
v_sal 변수에 담고 emp테이블의 sal 컬럼에 업데이트
단 case 표현식을 사용할 것

1. 7369번 사번의 sal 정보를 조회하여 변수에 담는다.
2. 1번에서 담은 변수값을 case표현식을 이용하여 새로운 sal 값을 구하고
    v_sal 변수에 할당
3. 7369번 사원의 sal 컬럼을 v_sal값으로 업데이트    

SELECT sal
FROM emp
WHERE empno = 7369;

DECLARE
     v_sal emp.sal%TYPE;
BEGIN
     SELECT sal INTO v_sal
     FROM emp
     WHERE empno = 7369;
    
     CASE 
     WHEN v_sal > 1000 THEN v_sal := v_sal*1.2;
     WHEN v_sal > 900 THEN v_sal := v_sal*1.3;
     WHEN v_sal > 800 THEN v_sal := v_sal*1.4;
     ELSE v_sal := v_sal*1.6;
END CASE ;  

     UPDATE emp SET sal = v_sal WHERE empno = 7369;
END;
/


DECLARE 
    v_sal NUMBER;
BEGIN
    SELECT sal INTO v_sal
    FROM emp
    WHERE empno = 7369;
    
    v_sal := CASE
    WHEN v_sal > 1000 THEN v_sal*1.2
    WHEN v_sal > 900 THEN v_sal*1.3
    WHEN v_sal > 800 THEN v_sal*1.4
    ELSE v_sal*1.6
    END;
    
    UPDATE emp SET sal = e_sal WHERE emp empno = 7369;
    
END;
/
    
    

    











