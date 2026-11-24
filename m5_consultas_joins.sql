-- CONSULTA 1: VISTA BASE DEL PROYECTO (INNER JOIN)

SELECT 
    v.id_venta,
    v.fecha_venta,
    c.nombre AS cliente,
    c.ciudad,
    p.nombre_producto AS producto,
    cat.nombre_categoria AS categoria,
    v.cantidad,
    v.precio_unitario,
    v.cantidad * v.precio_unitario AS total
FROM ventas v
INNER JOIN clientes c ON v.id_cliente = c.id_cliente
INNER JOIN productos p ON v.id_producto = p.id_producto
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria
ORDER BY v.id_venta;


-- CONSULTA 2: CLIENTES SIN VENTAS (LEFT JOIN)

SELECT c.nombre, c.email, c.fecha_registro
FROM clientes c
Left join ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;


--Hallazgo: La cliente de Nombre: Ana Duarte, mail: ana@mail.com es la cliente que no tiene ventas registradas.



-- CONSULTA 3: PRODUCTOS SIN VENTAS (LEFT JOIN)
SELECT 
    p.nombre_producto,
    p.precio,
    c.nombre_categoria
FROM dbo.productos p
LEFT JOIN dbo.categorias c ON p.id_categoria = c.id_categoria
LEFT JOIN dbo.ventas v ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL;

--HALLAZO: Aparece solo 1 registro sin ventas, nombre de producto que no se vendió Disco SSD 1TB de la categoria Computación


--CONSULTA 4: CONSOLIDADO POR CANAL (UNION ALL)

WITH Por_Canal AS (
    SELECT 
        fecha_venta,
        cantidad * precio_unitario AS total,
        'Cliente' AS canal
    FROM dbo.ventas
    WHERE id_cliente IS NOT NULL

    UNION ALL

    SELECT 
        fecha_venta,
        cantidad * precio_unitario AS total,
        'Web' AS canal
    FROM dbo.ventas
    WHERE id_cliente IS NULL
)
SELECT 
    canal,
    COUNT(*) AS ventas,
    SUM(total) AS facturado
FROM Por_Canal
GROUP BY canal;


--HALLAZGO:El canal Clientes es el que canal con más ventas (26) seguido por el canal Web (2)