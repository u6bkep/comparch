-- 2-input OR gate
entity or2 is
    port (a,b : in bit;
	  c : out bit);
end or2;

architecture dataflow of or2 is
    
begin  -- dataflow

    c <= a or b after 1 ns;
    
end dataflow;
