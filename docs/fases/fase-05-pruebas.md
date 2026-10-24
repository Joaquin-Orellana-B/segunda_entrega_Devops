# Fase 5: Pruebas Automatizadas (Unitarias e Integración)

## Descripción
En esta fase se ejecutó y validó la suite completa de pruebas automatizadas con JUnit 5, Mockito y MockMvc, garantizando la cobertura de la capa de servicios y la capa de controladores REST.

## Componentes Probados y Verificados

1. **Pruebas Unitarias (`OrderServiceTest`)**:
   - Mapeo y aislamiento mediante `@Mock` y `@InjectMocks`.
   - Cobertura de consultas, creación, máquina de estados y excepciones (`InvalidOrderStateException` y `OrderNotFoundException`).

2. **Pruebas de Integración Web (`OrderControllerTest`)**:
   - Pruebas de capa web desacoplada con `@WebMvcTest` y `MockMvc`.
   - Configuración de VM activa para soporte JDK (`-Dnet.bytebuddy.experimental=true`).
   - Validación de estados HTTP (200, 201, 204, 400, 404, 409).

## Resultado de Ejecución
- **Estado**: Exitoso (`BUILD SUCCESS`).
- **Tiempo total**: ~1.2 segundos.
- **Cobertura**: 100% de los casos de prueba ejecutados y aprobados sin fallos.