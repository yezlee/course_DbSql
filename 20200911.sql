문제 join1


SELECT lprod_gu, lprod_nm, prod_id, prod_name
FROM prod JOIN lprod ON (prod.prod_lgu = lprod.lprod_gu)
ORDER BY prod_id;

--테이블 만들고 나서 틀렸는지 맞았는지도 알아야돼. 테이블 건수 조회해서
prod 테이블 건수?
SELECT COUNT(*)
FROM prod;

SELECT lprod_gu, lprod_nm, prod_id, prod_name
FROM prod ,lprod
WHERE prod.prod_lgu = lprod.lprod_gu
ORDER BY prod_id;


문제2
SELECT buyer_id, buyer_name, prod_id, prod_name 
FROM buyer JOIN prod ON (prod.prod_buyer = buyer.buyer_id)
ORDER BY prod_id;

SELECT buyer_id, buyer_name, prod_id, prod_name
FROM buyer, prod
WHERE prod.prod_buyer = buyer.buyer_id --한정자 안써줘도돼. 칼럼명이 달라서.
ORDER BY prod_id;


문제3
join시 생각할 부분
1. 테이블 기술(써주고)
2. 연결조건

오라클
SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member, cart, prod
WHERE mem_id = cart.cart_member AND cart.cart_prod = prod.prod_id;

--조인을 할때 자식 횟수만큼 행이 나와.
--부서랑 사원 중에 부서가 부모가 사원이 자식
--부모가 열쇠, 자식이 F

조인
SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member JOIN cart ON (member.mem_id = cart.cart_member)
            JOIN prod ON (cart.cart_prod = prod.prod_id);

SELECT *
FROM member;

SELECT *
FROM cart;

SELECT *
FROM prod;