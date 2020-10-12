Exception (예외)
: pl/sql 블럭이 실행되는 동안 발생하는 에러
  예외가 발생했을 때 PL/SQL의 EXCEPTION 절을 기술하여 다른 로직을 실행하여
  예외문제를 해결할 수 있다.
  
예외구분 2가지
1. 사전 정의 예외(Oracle Predefined Exception)
    - 오라클에서 미리 정의한 예외로 ORA-XXXXXX로 정의
    - 에러코드만 있고 에러이름이 없는 경우가 대다수
    
2. 사용자 정의 예외(User Defined Exception)

예외 발생 시 해당 sql문은 중단
    - EXCEPTION 절이 있으면 : 예외 처리부에 기술된 문장을 실행
    - EXCEPTION 절이 없으면 : PL/SQL 블록 종료
    
예외처리방법
DECLARE
BEGIN
EXCEPTION
    WHEN 예외명 [OR 예외명2] THEN
        실행할 문장;   
    WHEN 예외명3 [OR 예외명4] THEN
        실행할 문장;   
    WHEN OTHER THEN
        실행할 문장 (여기서 SQLCODE, SQLERRM 속성을 통해 예외 코드를 확인할 수 있다.)
END;
/


하나의 행이 나와야 하는데
하나의 행이 조회되어야 하는 상황에서 여러개의 행이 반환된 경우(예외처리가 없을 때)

SET SERVEROUT ON;

DECLARE
    v_ename emp.ename%TYPE;
BEGIN
    SELECT ename INTO v_ename
    FROM emp;
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('NO_DATA_FOUND');
    WHEN TOO_MANY_ROWS THEN DBMS_OUTPUT.PUT_LINE('TOO_MANY_ROWS');
END;
/

사용자 예외 정의, 사용
1. PL/SQL 블럭안에서 또 다른 PL/SQL 블럭을 정의하는 것이 가능하다!!!

NO_EMP : 사번을 통해서 사원을 검색하는데 해당 사번을 갖는 사원이 없을 때
    SELECT *
    FROM emp
    WHERE empno = 9999; --이런 사번은 없어.
    ==> NO_DATA_FOUND ==> NO_EMP 라는 예외로 던져주는거야
    에러이긴 하지만 사원없음!이라고 알려주게끔

DECLARE
    NO_EMP EXCEPTION; --내가 사용하고 싶은 명칭 NO_EMP, 이게 예외다. 이걸 비긴절 안에 있는 예외에서 나오면 그걸 다시 바깥 비긴 예외한테 보내주는거
    v_ename emp.ename%TYPE;
BEGIN
    
    BEGIN
        SELECT ename INTO v_ename
        FROM emp
        WHERE empno = 9999;  --여기서 발생하는 에러를 예외에 넣어주는거야
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            RAISE NO_EMP; --  발생
    END;
    
EXCEPTION
    WHEN NO_EMP THEN
    DBMS_OUTPUT.PUT_LINE('NO_EMP');
END;
/



FUNCTION : 반환값이 존재하는 PL/SQL 블럭

사번을 입력 받아서 해당 사원의 이름을 반환하는 FUNCTION 

CREATE OR REPLACE FUNCTION getEmpName (p_empno emp.empno%TYPE) RETURN VARCHAR2 IS 
    v_ename emp.ename%TYPE;
BEGIN
    SELECT ename INTO v_ename
    FROM emp
    WHERE empno = p_empno;
    
    RETURN v_ename;
END;
/


SELECT getEmpName(7369)
FROM dual;

SELECT getEmpName(empno), ename
FROM emp;


실습 function1
CREATE OR REPLACE FUNCTION getDeptName (p_deptno dept.deptno%TYPE) RETURN VARCHAR2 IS 
    v_dname dept.dname%TYPE;
BEGIN
    SELECT dname INTO v_dname
    FROM dept
    WHERE deptno = p_deptno; 
    
    RETURN v_dname;
END;
/

SELECT getDeptName(10)
FROM dual;

SELECT getDeptName(deptno)
FROM dept;

SELECT empno, ename, deptno, getDeptName(deptno) dname
FROM emp;
이렇게 하면 조인없어도 dname을 불러올수가 있다!

사원이 속한 부서이름을 가져오는 방법(다른 테이블의 컬럼을 확장 하는 방법)
1. join - 이것이 기본베이스!
SELECT empno, ename, emp.depetno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

2. 스칼라 서브쿼리 (이건 진짜 조인하기 싫을때 쓰는거) - 이건 좋을때가 별로 없음. 사용할 일이 많지 않어.
SELECT empno, ename, deptno, (SELECT dname FROM dept WHERE deptno = emp.deptno) dname
FROM emp;

3. 함수 function
SELECT empno, ename, deptno, getdeptname(deptno) dname
FROM emp;

어떤걸 언제 써야 할까?
상황마다 달라. 이걸 이해하려면 분포도를 알아야해.

분포도 : 흩어진 정도
데이터 분포도 : 특정 데이터가 발생하는 빈도
예) emp테이블의 empno : 값이 14개 존재 - 데이터 분포도가 좋다. 이럴땐 조인을 쓰는게 좋지
    emp테이블의 deptno : 값이 3개 존재 - 데이터 분포도가 나쁘다 = 중복되는 데이터가 많다. - 분포도가 나쁠때는 함수.


함수의 경우는, 오라클에서 기본적으로 캐쉬 기능을 사용한다.
기본 캐시 사이즈가 20개뿐임.
즉 인자값이 얼마 안되면 20개미만이면 함수사용하는게 좋고.
그 이상이 넘어가면 함수 쓰면 안되지. 
empno값이 2억개고, deptno가 여전히 3개야. 그럴땐 deptno에 함수 쓰면 좋지.


getDeptName(10) => ACCOUNTING  이걸 실행하게 되면 오라클은 10번인자로 getDeptName 실행했을 때 
ACCOUNTING 이라는 결과값을 기억(캐싱)
이후에 동일한 인자로 함수를 실행하면 함수를 실행하지 않고 캐싱된 값을 반환.



문제2
리턴값이 문자야. 공백이니까
인자값은 여러개가 될수있어. 공백이 *이 될수도 있고 4칸 띄우는게 아니고 5칸 띄울수도 있고.

SELECT -- LPAD(' ', (LEVEL-1)*4, ' ') || deptnm
       indent(LEVEL) || deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

CREATE OR REPLACE FUNCTION indent(p_level NUMBER) RETURN VARCHAR2 IS
    v_ret VARCHAR(200);
BEGIN

    /*SELECT LPAD(' ', (p_level-1)*4, ' ') INTO v_ret
    FROM dual; */
    
    --위에 처럼 쿼리로짜서 넣어도 되고 아래처럼 변수에 넣어서 해도 된다. 
   
    v_ret := LPAD(' ', (p_level-1)*4, ' ');
    
    RETURN v_ret;
END;
/

FUNCTION indent(p_level NUMBER) RETURN VARCHAR2 - 이게 함수의 시그니처


패키지 : 관련된 PL/SQL 블럭을 묶어 놓은 객체
java의 패키지와 유사
 ==> 유사한 타입들의 모임
 
DBMS_XPLAN.;
DBMS_OUTPUT.;

패키지 생성 방법 : JAVA의 INTERFACE, CLASS 사용 방법과 유사
Interface 객체명 = new class();
List<String> names = new ArrayList<String>();

PL/SQL 패키지 생성 방법
1. 선언부 
2. BODY

CREATE OR REPLACE PACKAGE names AS 
    FUNCTION getEmpName (p_empno emp.empno%TYPE) RETURN VARCHAR2; 
    FUNCTION getDeptName (p_deptno dept.deptno%TYPE) RETURN VARCHAR2; 
end names;    
/


body 부 생성

CREATE OR REPLACE PACKAGE BODY names IS

FUNCTION getEmpName (p_empno emp.empno%TYPE) RETURN VARCHAR2 IS 
    v_ename emp.ename%TYPE;
BEGIN
    SELECT ename INTO v_ename
    FROM emp
    WHERE empno = p_empno;
    
    RETURN v_ename;
END;

FUNCTION getDeptName (p_deptno dept.deptno%TYPE) RETURN VARCHAR2 IS 
    v_dname dept.dname%TYPE;
BEGIN
    SELECT dname INTO v_dname
    FROM dept
    WHERE deptno = p_deptno; 
    
    RETURN v_dname;
END;
end;
/

SELECT NAMES.GETEMPNAME(empno), NAMES.GETDEPTNAME(deptno)
FROM emp;



TRIGGER(방아쇠) 
: 설정한 이벤트에 따라 실행할 로직을 담은 객체
    웹 :  로그인 버튼 클릭
        ==> 사용자 아이디 INPUT 값과, 비밀번호 INPUT 값을 파라미터를 이용해 서버로 전송
        
    DB : 테이블의 데이터가 추가되거나 변경 되었을 때. PL/SQL 블럭을 실행
         USERS 테이블에 사용자 비밀번호가 변경 되었을 때
         USERS_HISTORY 테이블에 기존에 사용하던 비밀번호를 이력으로 생성
         (네이버에서 6개월전에 사용했던 비번입니다. 다른 비번 입력하세요. 라고 하는 그런기능);

SELECT *
FROM users;

CREATE TABLE users_history AS
SELECT userid, pass, sysdate mod_dt
FROM users
WHERE 1=2;

SELECT *
FROM users_history;

users 테이블의 pass(password) 컬럼이 변경되었을 때 실행할 트리커 생성

CREATE OR REPLACE TRIGGER trg_users_pass
    BEFORE UPDATE ON users
    FOR EACH ROW
BEGIN 
    --테이블 업데이트가 일어났을 때, 
    --기존(:OLD.pass) 비밀번호와 업데이트 하려고 하는 비밀번호(:NEW.pass)가 다를때
    IF :OLD.pass != :NEW.pass THEN
        INSERT INTO USERS_HISTORY VALUES(:OLD.userid, :OLD.pass, SYSDATE); --OLD를 쓰던 NEW를 쓰던 상관없음
    END IF;
END;
/

users_history에는 데이터가 없는 상황
SELECT *
FROM users_history;
아래 업데이트(패스워드 브라운패스로 바꾸는거) 하고나서 
우리는 INSERT 한적 없지만 트리거에 의해서 옛날 비번이 들어가있음.



-- brown's password -> c6347b73d5b1f7c77f8be828ee3e871c819578f23779c7d5e082ae2b36a44
SELECT *
FROM users;

UPDATE users SET pass = 'brownPass'
WHERE userid = 'brown';


트리거가 실행되지 않을 조건으로 UPDATE
UPDATE users SET alias = '곰탱이'
WHERE userid = 'brown';
이렇게 하면 ALIAS가 곰탱이로 바뀜. 근데 비밀번호에 대한 게 아니었으니까 
트리거에 대해 영향을 받지 않아서 USERS_HISTORY에는 아무것도 들어가지 않음.


트리거 장단점 물론 있지.
 장점(시스템을 신규로 만드는 사람 SI)
      : users 테이블에 비밀번호를 바꾸는 로직(자바로직을 뜻함)은 만들어야함..
        근데 users_history에 이력을 남기는 로직(java code)은 작성하지 않아도 됨.
 단점(시스템을 유지보수 하는 사람 SM)
      : users_history 테이블에 데이터를 넣는 로직이 없는데 생성이됨. 
      (환장할 노릇이겠지. 뭘 하지도 않았는데 데이터가 막 생성되면 트리거인가 라고 생각해도 되려나)
      
      
pl/sql 끝

데이터 모델링 시작

정답이 없음. 어려움.
설계를 하는거니까. 
      