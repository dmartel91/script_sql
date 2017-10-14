SET serveroutput ON;
DECLARE

  l_cursor      SYS_REFCURSOR;
  l_employee_id hr.employees.employee_id%type;
  l_first_name  hr.employees.first_name%type;
  l_last_name   hr.employees.last_name%type;
  l_email       hr.employees.email%type;

PROCEDURE get_cursor(p_first_value  IN NUMBER
                    ,p_last_value  IN NUMBER
                    ,p_result       OUT SYS_REFCURSOR) AS
BEGIN

  OPEN p_result FOR
  SELECT e.employee_id
        ,e.first_name
        ,e.last_name
        ,e.email
    FROM employees e
   WHERE 1 = 1
     AND e.employee_id BETWEEN p_first_value AND p_last_value;

END get_cursor;

BEGIN
  
  get_cursor(200, 206, l_cursor);

  LOOP
    FETCH l_cursor INTO l_employee_id, l_first_name, l_last_name, l_email;
    EXIT WHEN l_cursor%NOTFOUND;

  DBMS_OUTPUT.PUT_LINE(RPAD(l_employee_id, 10) || RPAD(l_first_name, 10) || RPAD(l_last_name, 10) || RPAD(l_email, 10));
  END loop;

  CLOSE l_cursor;

END;