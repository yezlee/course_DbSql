| : OR
{} : 여러개가 반복
[] : 옵션 - 있을수도 있고, 없을수도 있다.


=== SELECT 쿼리 문법 ===
SELECT * | { column | expression [alias]}
FROM 테이블 이름;

SQL 실행방법
1. 실행하려고 하는 SQL을 선택 후, ctrl + enter;
2. 실행하려는 sql 구문에 커서를 위치시키고 ctrl + enter;

SELECT *
FROM emp;

SELECT empno, ename
FROM emp;

SELECT *
FROM dept;

자바언어와 다른점
SQL 의 경우 KEY워드의 대소문자를 구분하지 않는다.

그래서 아래 SQL은 정상적으로 실행된다.
select *
from dept;

Coding Rule 
수업시간에는 keyword는 대문자
그 외(테이블명, 컬럼명)는 소문자

===========
실습 select1

1. 
SELECT *
FROM lprod;

2.
SELECT buyer_id, buyer_name
FROM buyer;

3.
SELECT *
FROM cart;

4.
SELECT mem_id, mem_pass, mem_name
FROM member;


(칼럼만 나와야하는게 아니고 가공해서 할수도있어 sal에 100더한거)
연산
SELECT 쿼리는 테이블이 데이터에 영향을 주지 않는다. SELECE 쿼리를 잘못 작성했다고해서 데이터가 망가지지 않음

SELECT ename, sal, sal + 100 
FROM emp;

데이터 타입
DESC 테이블명(테이블 구조를 확인)
DESC emp;  desc로 칼럼이 있는지 없는지 확인할수있음 -> 칼럼의 이름들을 볼수있고 그 칼럼의 데이터가 무엇으로 이루어져 있는지도 알수있음

SELECT *
FROM emp;

숫자 + 숫자 = 숫자값
5 + 6 = 11

문자 + 문자 = 문자 => java에서는 문자열을 이은, 문자열 결합으로 처리

수학적으로는 정의된 개념이 아니지만 오라클에서 정의를 해놓음
어떻게? 날짜에다가 숫자를 일수로 생각하여 더하고 뺀 일자가 결과로 된다.
날짜 + 숫자 = 날짜

hiredate에서 365일 미래의 일자

==중요하지는 않음==
별칭 : 컬럼, expression에 새로운 이름을 부여
    컬럼 | expression [AS] [컬럼명]
SELECT ename AS emp_name, hiredate, hiredate+365 after_1year, hiredate-365 before_1year
FROM emp;

별칭을 부여할 때 주의점
1. 공백이나, 특수문자가 있는 경우 더블 쿼테이션("")으로 감싸줘야한다.
2. 별칭명은 기본적으로 대문자로 취급되지만 소문자로 지정하고 싶으면 더블쿼테이션을 적용한다.
SELECT ename "EMP NAME", empno emp_no, empno "emp_no"
FROM emp;

자바에서의 문자열 : "Hello, World."
SQL에서의 문자열 : 'Hello, World.'  - 싱글쿼테이션을 사용함.



==매우중요!!!!!==
NULL : 아직 모르는 값
숫자 타입 : 0이랑 NULL은 다르다.
문자 타입 : ' ' 우리 눈에 안보이는 hide space공백문자랑도 NULL은 다르다

***** NULL을 포함한 연산의 결과는 항상 NULL 이다! 
5 * NULL = NULL
800 + NULL = NULL
800 + 0 = 800


emp 테이블 칼럼 정리
1. empno : 사원번호
2. ename : 사원이름
3. job : (담당)업무
4. mgr : 담당 매니저 번호
5. hiredate : 입사 일자
6. sal : 급여
7. comm : 커미션 - 성과급
8. deptno : 부서번호



emp 테이블에서 NULL값을 확인
SELECT ename, sal, comm, sal + comm as total_sal
FROM emp;

SELECT *
FROM dept;

SELECT userid, usernm, reg_dt, reg_dt + 5
FROM users;


----
실습 2

1. 
SELECT prod_id "id", prod_name "name" 
FROM prod

2.
SELECT lprod_gu "gu", lprod_nm "nm"
FROM lprod

3.
SELECT buyer_id "바이어아이디", buyer_name "이름"
FROM buyer


============
literal : 값 자체
literal 표기법 : 값을 표현하는 방법 ( 숫자를 그냥 쓰거나 문자열은 '' 싱글쿼테이션을 사용해서 씀)

숫자 10 이라는 값을
java : int a = 10
sql : SELECT empno, 10
      FROM emp;
      
문자 Hello, World 라는 문자 값을
java : String str = "Hello, World";
             컬럼 별칭   expression 별칭
sql : SELECT empno e, 'Hello, World' h , ;   
      FROM emp;
      
날짜 2020년 9월 2일이라는 날짜 값을...
java : primitive 8개 byte, short...
       문자열 ==> String Class
       날짜 ==> Date Class
       
sql : 나중에..

문자열 연산
java
    "Hello," + "World" ==> "Hello, World"
    "Hello," - "World" ==> 연산자가 정의되어 있지 않음. 컴파일 에러가 뜸.
       
python 
    "Hello," * 3 ==> "Hello,Hello,Hello,"
    
sql 은 문자열끼리 더하기가 가능해! 
    ||, CONCAT 함수 ==> 결합 연산    
    emp테이블의 ename, job 컬럼이 문자열
    
    java : ename + " " + job
    sql  : || + ' ' || job
    
    
    SELECT ename || job
    FROM emp;  

    CONCAT(문자열1, 문자열2) : 문자열1과 문자열2를 합쳐서 만들어진 새로운 문자열을 반환해준다.
    CONCAT(ename, ' ' ) 이게 하나의 문자열임


    SELECT ename || ' ' || job, CONCAT(ename, ' ' )
    FROM emp;      
    
    SELECT ename || ' ' || job, CONCAT(ename, job )
    FROM emp; 
    
    SELECT ename || ' ' || job,
           CONCAT(CONCAT(ename , ' '), job) AS test
    FROM emp; 
    
    
    * ename || ' ' || job 이거 자체를 expression이라고도 함. 컬럼 두개를 합친것도. 그걸 이름을 바꿔줄수도 있음.
    SELECT ename || ' ' || job AS ename_job 
    FROM emp; 
    
    DESC emp;
    

====

USER_TABLES : 오라클에서 관리하는 테이블(뷰)
              접속한 사용자가 보유하고 있는 테이블 정보를 관리
  
실습 3 
                  
SELECT CONCAT(CONCAT(CONCAT('SELECT * FROM',' ' ), table_name), ';') AS QUERY
FROM user_tables;
 
SELECT 'SELECT * FROM' || ' ' || table_name || ';'  AS QUERY
FROM user_tables;
 
 
SELECT 'test' - 이것도 맞아 그냥 expression 이고. 출력하면 행렬이 하나 추가되서 나옴.
FROM emp;
 
 
 
 
        
        
 
