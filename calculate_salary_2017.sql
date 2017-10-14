
----------------------------------------------
-- Calcular Salario en el Salvador
----------------------------------------------
SET serveroutput ON;
DECLARE
  
  l_salary      NUMBER(6, 2);
  l_net_salary  NUMBER(6, 2);

FUNCTION get_rent(p_salary NUMBER) RETURN NUMBER IS
  
  l_interval_1_from NUMBER(6, 2) := 0.01;
  l_interval_1_to   NUMBER(6, 2) := 472.00;
  l_interval_2_from NUMBER(6, 2) := 472.01;
  l_interval_2_to   NUMBER(6, 2) := 895.24;
  l_interval_3_from NUMBER(6, 2) := 895.25;
  l_interval_3_to   NUMBER(6, 2) := 2038.10;
  l_interval_4_from NUMBER(6, 2) := 2038.11;

  l_excess_1 NUMBER(6, 2) := 472.00;
  l_excess_2 NUMBER(6, 2) := 895.24;
  l_excess_3 NUMBER(6, 2) := 2038.10;

  l_fixed_fee_1 NUMBER(6, 2) := 17.67;
  l_fixed_fee_2 NUMBER(6, 2) := 60.00;
  l_fixed_fee_3 NUMBER(6, 2) := 288.57;

BEGIN

  IF p_salary >= l_interval_1_from AND p_salary <= l_interval_1_to THEN

    RETURN 0;
  
  ELSIF p_salary >= l_interval_2_from AND p_salary <= l_interval_2_to THEN

    RETURN (p_salary - l_excess_1)*0.10 + l_fixed_fee_1;
  
  ELSIF p_salary >= l_interval_3_from AND p_salary <= l_interval_3_to THEN

    RETURN (p_salary - l_excess_2)*0.20 + l_fixed_fee_2;
  
  ELSIF p_salary >= l_interval_4_from THEN

    RETURN (p_salary - l_excess_3)*0.30 + l_fixed_fee_3;
  
  ELSe 
    RETURN -1;

  END IF;

END get_rent;

PROCEDURE get_calculate_salary(p_salary     IN NUMBER
                              ,p_net_salary OUT NUMBER) AS

  l_salary      NUMBER;
  l_afp         NUMBER;
  l_isss        NUMBER;
  l_prev_salary NUMBER;
  l_rent        NUMBER;

BEGIN
  
  l_salary := p_salary;
  l_afp := ROUND(l_salary*(7.25/100), 2);
  SELECT CASE WHEN l_salary >= 1000.00 THEN 30.00 ELSE l_salary*0.03 END INTO l_isss FROM dual;

  l_prev_salary := l_salary - (l_isss + l_afp);
  l_rent := get_rent(l_prev_salary); 

  p_net_salary := l_salary - (l_afp + l_isss + get_rent(l_prev_salary));

END get_calculate_salary;

BEGIN
  
  get_calculate_salary(1219.61, l_net_salary);
  DBMS_OUTPUT.PUT_LINE(TO_CHAR(l_net_salary));

END;