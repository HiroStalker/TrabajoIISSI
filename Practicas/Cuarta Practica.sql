DROP TABLE contratos;

DROP TABLE demandas;

DROP TABLE ofertas;

DROP TABLE inmuebles;

CREATE TABLE inmuebles (
    "IDI"         CHAR(5 BYTE) PRIMARY KEY,
    "DOMICILIO"   VARCHAR2(50 BYTE),
    "TIPO"        CHAR(5 BYTE),
    CONSTRAINT "INMUEBLES_CHK1" CHECK ( tipo IN (
        'Piso',
        'Local',
        'Casa'
    ) )
);

INSERT INTO inmuebles (
    idi,
    domicilio,
    tipo
) VALUES (
    'I1   ',
    'Cuna 25',
    'Piso'
);

INSERT INTO inmuebles (
    idi,
    domicilio,
    tipo
) VALUES (
    'I2   ',
    'Laraá 3',
    'Piso'
);

INSERT INTO inmuebles (
    idi,
    domicilio,
    tipo
) VALUES (
    'I3   ',
    'Store 5',
    'Local'
);

INSERT INTO inmuebles (
    idi,
    domicilio,
    tipo
) VALUES (
    'I4   ',
    'Palmera 18',
    'Casa'
);

INSERT INTO inmuebles (
    idi,
    domicilio,
    tipo
) VALUES (
    'I5   ',
    'Cuna 40',
    'Casa'
);

CREATE TABLE ofertas (
    "IDO"           CHAR(5 BYTE) PRIMARY KEY,
    "PRECIOFERTA"   NUMBER(30),
    "FECHAOFERTA"   DATE,
    "IDI"           CHAR(5 BYTE)
        REFERENCES inmuebles
);

INSERT INTO ofertas (
    ido,
    precioferta,
    fechaoferta,
    idi
) VALUES (
    '01   ',
    '600',
    TO_DATE('01/05/10','DD/MM/RR'),
    'I1   '
);

INSERT INTO ofertas (
    ido,
    precioferta,
    fechaoferta,
    idi
) VALUES (
    '02   ',
    '550',
    TO_DATE('01/01/12','DD/MM/RR'),
    'I1   '
);

INSERT INTO ofertas (
    ido,
    precioferta,
    fechaoferta,
    idi
) VALUES (
    '03   ',
    '500',
    TO_DATE('10/01/10','DD/MM/RR'),
    'I2   '
);

INSERT INTO ofertas (
    ido,
    precioferta,
    fechaoferta,
    idi
) VALUES (
    '04   ',
    '1000',
    TO_DATE('01/01/12','DD/MM/RR'),
    'I3   '
);

INSERT INTO ofertas (
    ido,
    precioferta,
    fechaoferta,
    idi
) VALUES (
    '05   ',
    '800',
    TO_DATE('01/01/09','DD/MM/RR'),
    'I5   '
);

INSERT INTO ofertas (
    ido,
    precioferta,
    fechaoferta,
    idi
) VALUES (
    '06   ',
    '600',
    TO_DATE('01/01/13','DD/MM/RR'),
    'I5   '
);

INSERT INTO ofertas (
    ido,
    precioferta,
    fechaoferta,
    idi
) VALUES (
    '07   ',
    '700',
    TO_DATE('01/02/09','DD/MM/RR'),
    'I4   '
);

CREATE TABLE demandas (
    "IDD"         CHAR(5 BYTE) PRIMARY KEY,
    "NIF"         VARCHAR2(9 BYTE),
    "PRECIOMAX"   NUMBER(30,0),
    "FECHADEM"    DATE,
    "TIPO"        CHAR(5 BYTE),
    CONSTRAINT "DEMANDAS_CHK1" CHECK ( tipo IN (
        'Piso',
        'Local',
        'Casa'
    ) )
);

INSERT INTO demandas (
    idd,
    nif,
    preciomax,
    fechadem,
    tipo
) VALUES (
    'D1   ',
    '11111111A',
    '400',
    TO_DATE('01/03/12','DD/MM/RR'),
    'Piso'
);

INSERT INTO demandas (
    idd,
    nif,
    preciomax,
    fechadem,
    tipo
) VALUES (
    'D2   ',
    '11111111A',
    '800',
    TO_DATE('01/03/12','DD/MM/RR'),
    'Local'
);

INSERT INTO demandas (
    idd,
    nif,
    preciomax,
    fechadem,
    tipo
) VALUES (
    'D3   ',
    '22222222A',
    '700',
    TO_DATE('05/05/12','DD/MM/RR'),
    'Casa'
);

INSERT INTO demandas (
    idd,
    nif,
    preciomax,
    fechadem,
    tipo
) VALUES (
    'D4   ',
    '33333333A',
    '500',
    TO_DATE('02/02/10','DD/MM/RR'),
    'Casa'
);

CREATE TABLE contratos (
    "IDO"         CHAR(5 BYTE)
        REFERENCES ofertas,
    "IDD"         CHAR(5 BYTE)
        REFERENCES demandas,
    "INICIO"      DATE,
    "FIN"         DATE,
    "PRECIOCON"   NUMBER(30,0),
    "FIANZA"      NUMBER(30,0),
    PRIMARY KEY ( ido,
    idd )
);

INSERT INTO contratos (
    ido,
    idd,
    inicio,
    fin,
    preciocon,
    fianza
) VALUES (
    '02   ',
    'D1   ',
    TO_DATE('15/08/12','DD/MM/RR'),
    TO_DATE('15/08/13','DD/MM/RR'),
    '500',
    '500'
);

INSERT INTO contratos (
    ido,
    idd,
    inicio,
    fin,
    preciocon,
    fianza
) VALUES (
    '06   ',
    'D3   ',
    TO_DATE('01/06/12','DD/MM/RR'),
    TO_DATE('31/12/12','DD/MM/RR'),
    '600',
    '300'
);

INSERT INTO contratos (
    ido,
    idd,
    inicio,
    fin,
    preciocon,
    fianza
) VALUES (
    '07   ',
    'D4   ',
    TO_DATE('05/05/10','DD/MM/RR'),
    TO_DATE('01/09/11','DD/MM/RR'),
    '600',
    '300'
);

SELECT DISTINCT
    nif
FROM
    demandas
ORDER BY
    nif;

SELECT
    *
FROM
    contratos;

SELECT
    ido,
    idd,
    inicio,
    fin,
    preciocon,
    fianza
FROM
    contratos
WHERE
    (
        SELECT
            SYSDATE
        FROM
            dual
    ) BETWEEN inicio AND fin;