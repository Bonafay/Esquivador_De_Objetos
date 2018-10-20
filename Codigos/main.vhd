-----------------------------------------------------------------------------------------------------------------
-- UNIVERSIDAD DE GUANAJUATO
-- DIVISION DE INGENIERIAS	 
-- Octubre de 2018
--
-- ESQUIVADOR DE OBJETOS
-- GUSTAVO ADOLFO MURILLO GUTIERREZ
-- 
------------------------------------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all; 

entity main is
	generic (
		distanciaDeteccion : integer := 25
		);	
	port(
	CLK: in std_logic;	   
	eco : in std_logic;
	trigger : out std_logic;
	Alarm : out std_logic
	--AxisXP : out std_logic; 
	--AxisXN : out std_logic; 
	--AxisN : out std_logic;	
	--AxisY : out std_logic
);					  
end main;

architecture Behavioral of main is
---------------------- COMPONENTE HC-SR04 -----------------------
-----------------------------------------------------------------
component LIB_ULTRASONICO is
	port(
		 CLK, ECO : in std_logic;
		 TRIGGER : out std_logic;			
		 DISTANCIA_CENTIMETROS : out integer
		);
end component LIB_ULTRASONICO;

---------------------------- SEÑALES ----------------------------
signal DISTANCIA_CENTIMETROS : integer range 0 to 999;
-- signal centenas, decenas, unidades : integer range 0 to 9 := 0;  Descomentar si se desea separar los valores por posicion
-----------------------------------------------------------------

begin
	Obj: LIB_ULTRASONICO port map(clk, eco, trigger, DISTANCIA_CENTIMETROS);
	
	Deteccion_De_Objetos : process(DISTANCIA_CENTIMETROS)
	begin
		if(DISTANCIA_CENTIMETROS < distanciaDeteccion) then
			Alarm <= '1';
		else 
			Alarm <= '0';			
		end if;
	end process Deteccion_De_Objetos;
--centenas <= DISTANCIA_CENTIMETROS/100;
--decenas <= (DISTANCIA_CENTIMETROS/10) mod 10;
--unidades <= DISTANCIA_CENTIMETROS mod 10;
end Behavioral;