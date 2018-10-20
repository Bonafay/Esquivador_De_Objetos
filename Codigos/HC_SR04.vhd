----------------------------------------------------------------------------------
-- LIBRERIA HC-SR04
-- Creditos a: Jesús Eduardo Méndez Rosales
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  if not, see <http://www.gnu.org/licenses/>.
--
--
--							LIBRERÍA SENSOR ULTRASÓNICO
--
-- IMPORTANTE: Verificar que la FPGA tenga los recursos suficientes para soportar divisiones, en caso contrario
--					el usuario deberá implementar otros métodos para obtener el resultado deseado.
--
-- Descripción: Con ésta librería podrás controlar un sensor ultrasónico HC-SR04.
--
-- Características:
-- 
-- La librería genera el pulso Trigger con los siguientes tiempos:
--
--				  --> 10us <-- 
--
--  TRIGGER	____/¯¯¯¯¯¯\___________________________________/¯¯¯¯¯¯\_____
--
--					 |-------------------60ms-------------------|
--
-- NOTA: Estos son los tiempos sugeridos en la hoja de especificaciones del sensor, en caso
--       de querer cambiar estos tiempos se debe modificar los valores de "Escala_Periodo_Trigger" 
--		 y "Escala_Trigger".
--
-- Una vez que se manda la señal de trigger, el sensor responde con un pulso (ECO) el cual se mide y se obtiene
-- un valor de escala (Escala_Total) para después convertir ese valor en tiempo de duración en microsuegundos (Tiempo_Microsegundos).
-- Y finalmente se hace la conversión de tiempo a distancia cuya fórmula se obtuvo en la hoja de especificaciones del sensor.
--
------------------------------------------------------------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;

entity LIB_ULTRASONICO is
	port(
		 CLK, ECO : in std_logic;
		 TRIGGER : out std_logic;			
		 DISTANCIA_CENTIMETROS : out integer
		);
end LIB_ULTRASONICO;

architecture Behavioral of LIB_ULTRASONICO is
constant Escala_Periodo_Trigger : integer := 2_999_999;
constant Escala_Trigger : integer := 499;

signal Conta_Trigger : integer range 0 to Escala_Periodo_Trigger := 0;
signal Conta_Eco, Escala_Total : integer := 0;
signal Bandera : std_logic := '1';
signal Tiempo_Microsegundos : integer := 0;

begin
--PROCESO QUE GENERA SEÑAL DE TRIGGER---
	process(CLK)
	begin
		if Rising_Edge(CLK) then
			Conta_Trigger <= Conta_Trigger+1;
			if Conta_Trigger = 0 then
				TRIGGER <= '1';
			elsif Conta_Trigger = Escala_Trigger then
				TRIGGER <= '0';
			elsif Conta_Trigger = Escala_Periodo_Trigger then
				Conta_Trigger <= 0;
			end if;
		end if;
	end process;
----------------------------------------

--PROCESO QUE OBTIENE ESCALA DE ECO---
process(CLK)
begin
	if Rising_Edge(CLK) then
		if Conta_Trigger = Escala_Trigger then
			Bandera <= '1';
		end if;
	
		if ECO = '1' then
			Conta_Eco <= Conta_Eco+1;
		elsif ECO = '0' AND Bandera = '1' then
			Bandera <= '0';
			Escala_Total <= Conta_Eco;
			Conta_Eco <= 0;
		end if;
	end if;
end process;

--------------------------------------

Tiempo_Microsegundos <= Escala_Total/50; --OPERACIÓN QUE CONVIERTE VALOR DE "ESCALA TOTAL" A TIEMPO EN MICROSEGUNDOS
DISTANCIA_CENTIMETROS <= Tiempo_Microsegundos/58; --OPERACIÓN QUE CONVIERTE "TIEMPO_EN_MICROSEGUNDOS" A DISTANCIA EN CENTÍMETROS

end Behavioral;