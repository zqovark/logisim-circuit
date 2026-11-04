library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- ALU combinacional de 4 bits. Sem clock: a saída depende das entradas.
entity alu4 is
  port (
    a      : in  std_logic_vector(3 downto 0);
    b      : in  std_logic_vector(3 downto 0);
    op     : in  std_logic_vector(2 downto 0);
    y      : out std_logic_vector(3 downto 0);
    zero   : out std_logic;
    carry  : out std_logic;
    borrow : out std_logic
  );
end entity alu4;

architecture rtl of alu4 is
begin
  process(all)
    variable result_v : unsigned(3 downto 0);
    variable sum_v    : unsigned(4 downto 0);
    variable carry_v  : std_logic;
    variable borrow_v : std_logic;
  begin
    result_v := (others => '0');
    sum_v := (others => '0');
    carry_v := '0';
    borrow_v := '0';

    case op is
      when "000" =>  -- ADD: (a + b) mod 16
        sum_v := ('0' & unsigned(a)) + ('0' & unsigned(b));
        result_v := sum_v(3 downto 0);
        carry_v := sum_v(4);

      when "001" =>  -- SUB: (a - b) mod 16
        result_v := unsigned(a) - unsigned(b);
        if unsigned(a) < unsigned(b) then
          borrow_v := '1';
        end if;

      when "010" =>  -- AND
        result_v := unsigned(a) and unsigned(b);

      when "011" =>  -- OR
        result_v := unsigned(a) or unsigned(b);

      when "100" =>  -- XOR
        result_v := unsigned(a) xor unsigned(b);

      when "101" =>  -- SHL: a deslocado 1 bit à esquerda
        result_v := shift_left(unsigned(a), 1);

      when "110" =>  -- SHR: a deslocado 1 bit à direita
        result_v := shift_right(unsigned(a), 1);

      when others => -- MOV: copia a
        result_v := unsigned(a);
    end case;

    y <= std_logic_vector(result_v);
    carry <= carry_v;
    borrow <= borrow_v;

    if result_v = to_unsigned(0, 4) then
      zero <= '1';
    else
      zero <= '0';
    end if;
  end process;
end architecture rtl;
