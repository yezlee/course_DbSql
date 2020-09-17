SELECT *
FROM fastfood
WHERE addr LIKE '%청주%';

문제 extra - 모든 브랜드 갯수 더하기 - (버거킹 + 맥날 + kfc)/롯데리아 그룹함수 조인연수 상황에 따라 집합연산 - 다 쓰게될것임
SELECT *
FROM fastfood
WHERE sido = '대전광역시'
    AND sigungu = '중구';
    

SELECT *
FROM fastfood
WHERE sido = '강원도'
    AND sigungu = '강릉시';
    


SELECT count(zipcd)
FROM fastfood
WHERE zipcd LIKE '34%' OR zipcd LIKE '35%' ;


SELECT sido, sigungu, gb, COUNT(*)
FROM fastfood
WHERE gb = '맥도날드' AND sido = '강원도' AND sigungu = '강릉시'
GROUP BY sido, sigungu, gb
ORDER BY sido, sigungu, gb;


SELECT sido, sigungu, gb, COUNT(*)
FROM fastfood
WHERE gb = '맥도날드'
GROUP BY sido, sigungu, gb
ORDER BY sido, sigungu, gb;




SELECT 
FROM
WHERE
(SELECT sido, sigungu, COUNT(*) cnt
FROM fastfood
WHERE gb IN ('KFC', '맥도날드', '버거킹')
GROUP BY sido, sigungu) a;


SELECT a.sido, a.sigungu, a.cnt, b.cnt, ROUND(a.cnt/b.cnt, 2) di
FROM
(SELECT sido, sigungu, COUNT(*) cnt
 FROM fastfood
 WHERE gb IN ( 'KFC', '맥도날드', '버거킹')
 GROUP BY sido, sigungu) a,

(SELECT sido, sigungu, COUNT(*) cnt
 FROM fastfood
 WHERE gb = '롯데리아'
 GROUP BY sido, sigungu) b
WHERE a.sido = b.sido
AND a.sigungu = b.sigungu
ORDER BY di DESC;



SELECT sido, sigungu, gb, COUNT(*)
FROM fastfood
WHERE gb IN ('KFC', '맥도날드', '버거킹', '맥도날드')
GROUP BY sido, sigungu, gb
ORDER BY sido, sigungu, gb;

SELECT *
FROM (SELECT sido, sigungu, gb, COUNT(*)
      FROM fastfood
      WHERE gb IN ('KFC', '맥도날드', '버거킹', '맥도날드')
      GROUP BY sido, sigungu, gb)
ORDER BY sido, sigungu, gb;


kfc 건수, 롯데리아 건수, 버거킹 건수, 맥도날드 건수
SELECT sido, sigungu, gb, cnt,
       DECODE(gb, 'KFC' cnt) kfc , DECODE(gb, '롯데리아' cnt) lot,
       DECODE(gb, '버거킹' cnt) bk, DECODE(gb, '맥도날드' cnt) mac
FROM (SELECT sido, sigungu, gb, COUNT(*) cnt
      FROM fastfood
      WHERE gb IN ('KFC', '맥도날드', '버거킹', '맥도날드')
      GROUP BY sido, sigungu, gb)
GROUP BY sido, sigungu, gb      
ORDER BY sido, sigungu, gb;



SELECT sido, sigungu, 
        ROUND((NVL(SUM(DECODE(gb, 'KFC', cnt)), 0) +       
        NVL(SUM(DECODE(gb, '버거킹', cnt)), 0) +
        NVL(SUM(DECODE(gb, '맥도날드', cnt)), 0) ) /        
        NVL(SUM(DECODE(gb, '롯데리아', cnt)), 1), 2) di 
FROM 
(SELECT sido, sigungu, gb, COUNT(*) cnt
 FROM fastfood
 WHERE gb IN ('KFC', '롯데리아', '버거킹', '맥도날드')
 GROUP BY sido, sigungu, gb)
GROUP BY sido, sigungu 
ORDER BY di DESC;



SELECT *
FROM tax;

SELECT sido, sigungu, ROUND(sal/people) p_sal
FROM tax
ORDER BY p_sal DESC;

도시발전지수 1 - 세금1위
도시발전지수 2 - 세금2위
도시발전지수 3 - 세금3위


DML : Data Manipulate Language
1. SELECT ******* 중요
2. INSERT : 테이블에 새로운 데이터를 입력하는 명령
3. UPDATE : 테이블에 존재하는 데이터의 컬럼을 변경하는 명령
4. DELETE : 테이블에 존재하는 데이터(행)를 삭제하는 명령

INSERT 3가지 
1. 테이블의 특정 컬럼에만 데이터를 입력할 때(입력되지 않은 컬럼은 NULL로 설정 된다)
INSERT INTO 테이블명 (컬럼1, 컬럼2...) VALUES (컬럼1의 값1, 컬럼2의 값2...);
DEST emp;

INSERT INTO emp (empno, ename) VALUES (9999, 'brown');

SELECT *
FROM emp
WHERE empno = 9999;

empno컬럼의 설정이 NOT NULL이기 때문에 empno 컬럼에 NULL 값이 들어갈 수 없어서 에러가 발생.
INSERT INTO emp(ename) VALUES ('sally');
-> 에러뜸. cannot insert NULL into ("YEZ"."EMP"."EMPNO")


2. 테이블의 모든 컬럼에 모든 데이터를 입력할 때
**** 단 값을 나열하는 순서는 테이블의 정의된 컬럼 순서대로 기술 해야한다.
     테이블 컬럼순서 확인 방법 : DESC 테이블명 
INSERT INTO 테이블명 VALUES (컬럼1의 값1, 컬럼2의 값2...);

DESC dept;

컬럼을 기술하지 않았기 때문에 테이블에 정의된 모든 컬럼에 대해 값을 기술해야하나
3개중에 2개만 기술하여 에러 발생.
INSERT INTO dept VALUES (97, 'DDIT');
-> 에러 not enough values


3. SELECT 결과를(여러행일 수도 있다) 테이블에 입력
- values는 사라짐
INSERT INTO 테이블명
SELECT  ------------못씀


INSERT INTO emp (empno, ename)
SELECT 9997, 'cony' FROM dual
UNION ALL
SELECT 9996, 'moon' FROM dual;


날짜 컬럼 값 입력하기 - 함수도 입력할수있다- sysdate
INSERT INTO emp VALUES (9996, 'james', 'CLERK', NULL, SYSDATE, 3000, NULL, NULL);

'2020/09/01'
INSERT INTO emp VALUES (9996, 'james', 'CLERK', NULL, TO_DATE('2020/09/01', 'YYYY/MM/DD'), 3000, NULL, NULL);



UPDATE : 테이블에 존재하는 테이블
        1. 어떤 데이터를 수정할 지 데이터를 한정(WHERE)
        2. 어떤 칼럼에 어떤 값을 넣을지 기술
        
UPDATE 테이블명 SET 변경할 컬럼명 = 수정할 값 [, 변경할 걸럼명 = 수정할 값...)
[WHERE]
99 ddit daejeon
dept 테이블의 deptno 컬럼의 값이 99번인 데이터의 DNAME 컬럼을 대문자로 DDIT로, LOC 컬럼을 한글 '영민'으로 변경;
UPDATE dept SET dname = 'DDIT', loc = '영민'
WHERE deptno = 99; 


UPDATE dept SET dname = 'DDIT', loc = '영민'
where절을 안쓴 상태에서 위를 업데이트 하면 갖고 있는 행 몽땅 다 변경됨.
select절은 조회 할때 막 조회해도 자료가 변경이 되거나 그렇진 않아. 하지만 update는 조심해야해.
하지만 commit만 안하면 돼. 그전에 rollback;을 하면 됨.
rollback을 하면 지금까지 했던게 다 없어짐. 오늘 했던거.
트랜잭션이야. 오늘 한게 다 일련의 하나의 과정이기 때문에 롤백 하면서 트랜잭션 취소처럼 다 취소.


2. 서브쿼리를 활용한 데이터 변경 (*** 추후에, merge구문을 배우면 더 효율적으로 작성할 수 있다)

테스트 데이터 입력
INSERT INTO emp ( empno, ename, job) VALUES (9000, 'brown', NULL);

9000번 사번의 DEPTNO, JOB컬럼의 값을 SMITH 사원의 DEPTNO, JOB 컬럼으로 동일하게 변경
SELECT deptno, job
FROM emp
WHERE ename = 'SMITH';

UPDATE emp SET deptno = 20, job = 'CLERK'
WHERE empno = 9000;

서브쿼리를 이용해서 ,
UPDATE emp SET deptno = (SELECT deptno
                        FROM emp
                        WHERE ename = 'SMITH')
                ,job = (SELECT job
                        FROM emp
                        WHERE ename = 'SMITH')
WHERE empno = 9000;


3. DELETE : 테이블에 존재하는 데이터를 삭제(행 전체를 삭제)
***** emp테이블에서 9000번 사번의 deptno 컬럼을 지우고 싶을 때(NULL) ??
   ==> deptno 컬럼을 NULL로 업데이트한다
   
DELETE [FROM] 테이블명 
[WHERE ....]

emp테이블에서 9000번 사전의 데이터(행)를 완전히 삭제
DELETE emp
WHERE empno = 9000;


UPDATE, DELETE절을 실행하기 전에
WHERE절에 기술한 조건으로 SELECT을 먼저 실행하여, 변경, 삭제되는 행을 눈으로 확인해보자 - 더블체크 하라는거지

DELETE emp
WHERE empno = 7369;


DML 구문 실행시
DBMS는 복구를 위해 로그를 남긴다.
즉 데이터 변경 작업 +alpah의 작업량이 필요

하지만 개발 환경에서는 데이터를 복구할 필요가 없기 때문에
삭제 속도를 빠르게 하는것이 개발 효율성에서 좋음.

로그없이 테이블의 모든 데이터를 삭제하는 방법 : TRUNCATE TABLE 테이블명;
DELETE emp;
TRUNCATE TABLE emp;


//이건 조심해서 해야함. 20조건!! 
SELECT *
FROM fastfood a, fastfood b, fastfood c, fastfood d --a하나가 1200건있고 그걸 또 b랑 조인해서 1200*1200에다가 또 c랑 조인해서 1200의 3승, 또 d랑 조인해서 1200의 4승이야. 20조임... 엄청 커서 오래걸려.
WHERE a.gb = b.gb
  AND b.gb = c.gb
  AND c.gb = d.gb;