
 ----0903 
 
FROM 

테이블의 구조(컬럼명, 데이터타입) 확인하는 방법
1. DESC 테이블명 : DESCRIBE
2. 컬럼 이름만 알 수 있는 방법(데이터 타입은 유추)
    SELECT *
    FROM 테이블명;
3. 툴에서 제공한 메뉴 이용
    접속 정보 - 테이블 - 확인 하고자 하는 테이블 클릭
    
    
SELECT empno, ename, sal
FROM emp;


SELECT 절 : 컬럼을 제한 - 내가 보고싶은것만 선택해서



**************매우매우매우 중요(WHERE는 아무리 강조해도 부족할정도로) *************************** select중에서도 where가 중요
WHERE 절 : 조건에 만족하는 행들만 조회되도록 제한 (행을 제한)
        ex ) sal 칼럼의 값이 1500보다 큰 사람들만 조회 ==> 7명
WHERE절에 기술된 조건을 참(TRUE)으로 만족하는 행들만 조회가 된다.


        
조건 연산자
    동등 비교(equal)
        java : int a =5;
                primitive type : ==  ex)    a == 5;
                object : "+".equals("-")
        sql : sal = 1500
    not equal
        java : !=
        sql : !=, <>
        
    대입연산자 
        java :     = 
        pl/sql :  :=
        
        
예제1 - users테이블에는 총 5명의 캐릭터가 등록이 되어있는데 
그중에서 userid 컬럼의 값이 'brown'인 행만 조회되도록
WHERE절에 조건을 기술

SELECT userid, usernm, alias, reg_dt
FROM users
WHERE userid = 'brown';


SQL은 대소문자를 가리지 않는다 : 키워드, 테이블명, 컬럼명
데이터는 대소문자를 가린다.

컬럼과 문자열 상수를 구분하여 사용

SELECT userid, usernm, alias, reg_dt
FROM users
WHERE userid = 'BROWN'; 


WHERE절에 기술된 조건을 참(TRUE)으로 만족하는 행들만 조회가 된다.

SELECT userid, usernm, alias, reg_dt
FROM users
WHERE 1 = 1;   - > 1 = 1이야 그럼 참이지. 모든게 참인거야 그럼 모든 행이 다 나옴.


emp테이블에서 부서번호(deptno)가 30보다 크거나 같은 사원들만 조회
컬럼은 모든 컬럼 조회
SELECT *
FROM emp
WHERE deptno >= 30;        
        
        
날짜 비교        
1982년 01월 01일 이후에 입사한 사람들만 조회(이름, 입사일자)
hiredate  type : date
문자 리터럴 표기법 : '문자열'
숫자 리터럴 표기법 : 숫자
날짜 리터럴 표기법 : 항상 정해진 표기법이 아니다.
                    서버 설정마다 다르다. 
                    한국 : yy/mm/dd
                    미국 : mm/dd/yy
날짜 리터럴 결론 : 문자열 형태로 표현하는 것이 가능하나
                 서버 설정마다 다르게 해석할 수 있기 때문에
                 서버 설정과 관계없이 동일하게 해석할 수 있는 방법을 사용
                 TO DATE 
                 : 문자열 

SELECT ename, hiredate
FROM emp
WHERE hiredate >= '1982/01/01';
        
년도 : yyyy
월 : mm
일 : dd
SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('1982/01/01', 'yyyy/mm/dd');   - > todate를 사용하는 이유는, 나라마다 날짜 표기법이 달라서! 
                                                             날짜사이에 / 대신에 - 써도 괜찮다.


BETWEEN AND 연산자
WHERE 비교대상 BETWEEN 시작값 AND 종료값;
비교대상의 값이 시작값과 종료값 사이에 있을 때 참(TRUE)으로 인식
(시작값과, 종료값을 포함     비교대상 >= 시작값, 비교대상 <= 종료값)

emp테이블에서 sal 컬럼의 값이 1000이상 2000이하인 사원들의 모든 컬럼을 조회

SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000; 

비교 연산자를 이용한 풀이
SELECT *
FROM emp
WHERE sal >= 1000
  AND sal <= 2000; 


실습 1
SELECT *
FROM emp
WHERE hiredate BETWEEN TO_DATE('1982/01/01', 'yyyy/mm/dd') 
                   AND TO_DATE('1983/01/01', 'yyyy/mm/dd');


실습2
SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('19820101', 'yyyymmdd')
  AND hiredate <= TO_DATE('19830101', 'yyyymmdd');






IN 연산자
특정 값이 집합(여러개의 값을 포함)을 포함되어 있는지 여부를 확인
OR연산자로 대체하는 것이 가능 ( 혹은 이라는 단어를 썼을때 검색이되니깐) 아래 예 있음.

WHERE 비교대상 IN (값1, 값2....)
==> 비교대상이 값1 이거나(=)
    비교대상이 값2 이거나(=)
    
emp테이블에서 사원이 10부서 혹은 30부서에 속한 사원들 정보를 조회(모든 컬럼)
SELECT *
FROM emp
WHERE deptno IN (10, 30);

SELECT *
FROM emp
WHERE deptno = 10 
   OR deptno = 30;


AND ==> 그리고
OR ==> 또는

조건1 AND 조건2 ==> 조건1과 조건2를 동시에 만족
조건1 OR 조건2 ==> 조건1을 만족하거나, 조건2를 만족하거나
                  조건1과 조건2를 동시 만족하거나


실습3
SELECT userid AS 아이디, usernm AS 이름, alias AS 별명
FROM users
WHERE userid IN ('brown', 'cony', 'sally');  -> userid IN (brown, cony, sally) - 이렇게 하면 brown이라는 칼럼을 찾는거야

OR를 사용하면,
SELECT userid AS "아이디", usernm AS 이름, alias AS 별명
FROM users
WHERE userid = 'brown'
   OR userid = 'cony'
   OR userid = 'sally';


---------------------지금까지는 비교연산자


LIKE 연산자 : 문자열 매칭
WHERE userid = 'brown'
userid가 b로 시작하는 캐릭터만 조회
% : 문자가 없거나(문자대신 숫자가 들어있어도 된다는 뜻 '신122' 이래도 가능), 여러개의 문자열을 뜻함  -> 앞글자가 신으로 시작을하면 '신%', 뒤가 신으로 끝나면 '%신', 아무대나 신이 들어가면 '%신%' !!!  
_ : 하나의 임의의 문자

SELECT *
FROM emp
WHERE ename LIKE 'S%';

ename이 W로 시작하고 이어서 3개의 글자가 있는 사원
SELECT *
FROM emp
WHERE ename LIKE 'W___'; 



실습4 - 신으로 시작하는 이름
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '신%';  

실습5 - '이'가 들어가는 이름
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%이%';


