-- 2-input AND gate
entity and2 is
    port (a,b : in bit;
	  c : out bit);
end and2;

architecture dataflow of and2 is
    
begin  -- dataflow

    c <= a and b after 1 ns;
    
end dataflow;
