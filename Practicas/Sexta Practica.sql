DROP TABLE empleados;

CREATE TABLE empleados (
    cod_emp     INTEGER,
    nom_emp     CHAR(10) NOT NULL,
    salario     NUMBER(9,2) DEFAULT 100000,
    fecha_nac   DATE DEFAULT SYSDATE,
    comision    NUMBER(3,2) CHECK (
        comision >= 0
        AND comision <= 1
    ),
    cod_jefe    INTEGER,
    PRIMARY KEY ( cod_emp ),
    FOREIGN KEY ( cod_jefe )
        REFERENCES empleados
            ON DELETE CASCADE
);

DROP SEQUENCE sec_emp;

CREATE SEQUENCE sec_emp INCREMENT BY 1 START WITH 1;

CREATE OR REPLACE PROCEDURE contratar_empleado (
    w_nom_emp    IN empleados.nom_emp%TYPE,
    w_salario    IN empleados.salario%TYPE,
    w_comision   IN empleados.comision%TYPE,
    w_cod_jefe   IN empleados.cod_jefe%TYPE
)
    IS
BEGIN
    INSERT INTO empleados (
        cod_emp,
        nom_emp,
        salario,
        comision,
        cod_jefe
    ) VALUES (
        sec_emp.NEXTVAL,
        w_nom_emp,
        w_salario,
        w_comision,
        w_cod_jefe
    );

    COMMIT WORK;
END contratar_empleado;
/

EXECUTE contratar_empleado('Primero','1000,00',',07',NULL);

EXECUTE contratar_empleado('Segundo',2000,',10',1);

EXECUTE contratar_empleado('Tercero','2300,25',',15',2);

SELECT
    cod_emp,
    nom_emp,
    salario,
    fecha_nac,
    comision,
    cod_jefe
FROM
    empleados;

CREATE OR REPLACE FUNCTION obtener_salario (
    w_cod_emp   IN empleados.cod_emp%TYPE
) RETURN NUMBER IS
    w_salario_bruto   empleados.salario%TYPE;
BEGIN
    SELECT
        salario * ( 1 + comision )
    INTO
        w_salario_bruto
    FROM
        empleados
    WHERE
        cod_emp = w_cod_emp;

    return(w_salario_bruto);
END obtener_salario;
/
/* Prueba función SQL */

SELECT
    cod_emp,
    nom_emp salario,
    comision,
    obtener_salario(cod_emp)
FROM
    empleados;

/* Prueba función bloque  */

SET SERVEROUTPUT ON;

BEGIN
    dbms_output.put_line('Probando el salario de COD_EMP 1 '
    || ' >>>>
'
    || obtener_salario(1) );
END;
/
/* Ejercicio 4 */

DROP TABLE empleados;

CREATE TABLE empleados (
    dni      CHAR(4) PRIMARY KEY,
    nomemp   VARCHAR2(15),
    cojefe   CHAR(4),
    FOREIGN KEY ( cojefe )
        REFERENCES empleados
);
--
-- Inserta datos de ejemplo en la tabla
--

INSERT INTO empleados VALUES (
    'D1',
    'Director',
    NULL
);

INSERT INTO empleados VALUES (
    'D2',
    'D.Comercial',
    'D1'
);

INSERT INTO empleados VALUES (
    'D3',
    'D.Producción',
    'D1'
);

INSERT INTO empleados VALUES (
    'D4',
    'Jefe Ventas',
    'D2'
);

INSERT INTO empleados VALUES (
    'D5',
    'Jefe Marketing',
    'D2'
);

INSERT INTO empleados VALUES (
    'D6',
    'Vendedor 1',
    'D4'
);

INSERT INTO empleados VALUES (
    'D7',
    'Vendedor 2',
    'D4'
);

INSERT INTO empleados VALUES (
    'D8',
    'Vendedor 3',
    'D4'
);

INSERT INTO empleados VALUES (
    'D9',
    'Vendedor 4',
    'D4'
);

INSERT INTO empleados VALUES (
    'D10',
    'Obrero 1',
    'D3'
);

INSERT INTO empleados VALUES (
    'D11',
    'Obrero 2',
    'D3'
);

INSERT INTO empleados VALUES (
    'D12',
    'Obrero 3',
    'D3'
);

INSERT INTO empleados VALUES (
    'D13',
    'Secretario',
    'D5'
);

--
-- Procedimientos anónimos para obtener los tres empleados con más
--subordinados con bucle normal
--

DECLARE
    wjefe    CHAR(4);
    wcount   INTEGER;
    CURSOR c IS SELECT
        cojefe,
        COUNT(*) AS cuenta
                FROM
        empleados
    GROUP BY
        cojefe
    ORDER BY
        2 DESC;

    fila     c%rowtype;
BEGIN
    dbms_output.put_line('Prueba de cursor (3 superjefes) con
Open/Fetch/Close ** BUCLE NORMAL');
    OPEN c;
    LOOP
        FETCH c INTO fila;
        EXIT WHEN c%notfound OR c%rowcount > 3;
        dbms_output.put_line(fila.cojefe
        || ' '
        || fila.cuenta);
    END LOOP;

    CLOSE c;
END;
/

--
-- Procedimientos anónimos para obtener los tres empleados con más
--subordinados con bucle while

DECLARE
    wjefe    CHAR(4);
    wcount   INTEGER;
    CURSOR c IS SELECT
        cojefe,
        COUNT(*) AS cuenta
                FROM
        empleados
    GROUP BY
        cojefe
    ORDER BY
        2 DESC;

    fila     c%rowtype;
BEGIN
    dbms_output.put_line('Prueba de cursor (3 superjefes) con
Open/Fetch/Close ** BUCLE WHILE');
    OPEN c;
    WHILE c%rowcount < 3 LOOP
        FETCH c INTO fila;
        EXIT WHEN c%notfound;
        dbms_output.put_line(fila.cojefe
        || ' '
        || fila.cuenta);
    END LOOP;

    CLOSE c;
END;
/
-- Para no crear ningún objeto en la BD

ROLLBACK WORK;