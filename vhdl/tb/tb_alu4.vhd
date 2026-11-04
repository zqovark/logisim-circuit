library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity tb_alu4 is
end entity tb_alu4;

architecture sim of tb_alu4 is
  signal a, b, y : std_logic_vector(3 downto 0) := (others => '0');
  signal op      : std_logic_vector(2 downto 0) := (others => '0');
  signal zero, carry, borrow : std_logic;
begin
  dut : entity work.alu4
    port map (
      a => a, b => b, op => op, y => y,
      zero => zero, carry => carry, borrow => borrow
    );

  stimulus : process
    variable expected_y      : integer;
    variable expected_carry  : std_logic;
    variable expected_borrow : std_logic;
    variable expected_zero   : std_logic;
  begin
    -- Todas as combinações: 8 operações x 16 valores de A x 16 valores de B.
    for op_i in 0 to 7 loop
      for a_i in 0 to 15 loop
        for b_i in 0 to 15 loop
          a  <= std_logic_vector(to_unsigned(a_i, 4));
          b  <= std_logic_vector(to_unsigned(b_i, 4));
          op <= std_logic_vector(to_unsigned(op_i, 3));

          expected_carry := '0';
          expected_borrow := '0';

          case op_i is
            when 0 =>
              expected_y := (a_i + b_i) mod 16;
              if a_i + b_i > 15 then
                expected_carry := '1';
              end if;
            when 1 =>
              expected_y := (a_i - b_i + 16) mod 16;
              if a_i < b_i then
                expected_borrow := '1';
              end if;
            when 2 =>
              expected_y := to_integer(to_unsigned(a_i, 4) and to_unsigned(b_i, 4));
            when 3 =>
              expected_y := to_integer(to_unsigned(a_i, 4) or to_unsigned(b_i, 4));
            when 4 =>
              expected_y := to_integer(to_unsigned(a_i, 4) xor to_unsigned(b_i, 4));
            when 5 =>
              expected_y := (a_i * 2) mod 16;
            when 6 =>
              expected_y := a_i / 2;
            when others =>
              expected_y := a_i;
          end case;

          if expected_y = 0 then
            expected_zero := '1';
          else
            expected_zero := '0';
          end if;

          wait for 1 ns;

          assert y = std_logic_vector(to_unsigned(expected_y, 4))
            report "Resultado errado: op=" & integer'image(op_i) &
                   " a=" & integer'image(a_i) & " b=" & integer'image(b_i)
            severity failure;
          assert carry = expected_carry
            report "Carry errado: op=" & integer'image(op_i) &
                   " a=" & integer'image(a_i) & " b=" & integer'image(b_i)
            severity failure;
          assert borrow = expected_borrow
            report "Borrow errado: op=" & integer'image(op_i) &
                   " a=" & integer'image(a_i) & " b=" & integer'image(b_i)
            severity failure;
          assert zero = expected_zero
            report "Zero errado: op=" & integer'image(op_i) &
                   " a=" & integer'image(a_i) & " b=" & integer'image(b_i)
            severity failure;
        end loop;
      end loop;
    end loop;

    report "PASS: 2048 combinacoes de ALU verificadas" severity note;
    finish;
    wait;
  end process;
end architecture sim;
