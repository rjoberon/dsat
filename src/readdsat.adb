with Ada.Direct_IO;
with Ada.Text_IO;            use Ada.Text_IO;
with Ada.Float_Text_IO;      use Ada.Float_Text_IO;
with Ada.Long_Float_Text_IO; use Ada.Long_Float_Text_IO;
with Ada.Integer_Text_IO;    use Ada.Integer_Text_IO;
with PostScript;             use PostScript;
with Unchecked_Conversion;


procedure ReadDSat is
   type Byte is mod 2**8; for Byte'Size use 8;
   type Ort_Feld is array (1..40) of Byte;
   type Koord_Feld is array (1..24) of Byte;
   --   type Datensatz is array (1 .. 64) of Byte;
   type Datensatz is record
      Ort   : Ort_Feld;
      Koord : Koord_Feld;
   end record;
   pragma Pack(Datensatz);

   type MyFloat is array (1..8) of Byte;
   function To_Float is new Unchecked_Conversion (MyFloat, Long_Float);


   package Byte_IO is new Ada.Direct_IO (Byte); use Byte_IO;
   package Byte_Text_IO is new Ada.Text_IO.Modular_IO (Byte); use Byte_Text_IO;
   package DSat_IO is new Ada.Direct_IO (Datensatz); use DSat_IO;

   --  Datensatz D an Position N einlesen
   procedure GetDatensatz (D : in out Datensatz;
                           N : in Integer) is
      Datei : DSat_IO.File_Type;
   begin
      Open (Datei, In_File, "dsat_orte");
      Set_Index(Datei, DSat_IO.Positive_Count(N));
      Read (Datei, D);
      Close (Datei);
   end GetDatensatz;

   --  PostScript-Ausgabe der Landkarte
   procedure Put_PS is
      X, Y : Integer;
      A    : PaperWidth;
      B    : PaperHeight;
      D    : Datensatz;
      XX,YY: Long_Float;
      M    : MyFloat;
   begin
      PS_PutHeader;
--      PS_SetColor (C);
--  die ersten 10000 Datensätze durchgehen
      for I in 1 .. 13378 loop
         GetDatenSatz (D, I);
         --  X und Y zusammenbasteln
         X := Integer(D.Koord(7))*256*256 +
           Integer(D.Koord(6))*256 +
           Integer(D.Koord(5));
         Y := Integer(D.Koord(15))*256*256 +
           Integer(D.Koord(14))*256 +
           Integer(D.Koord(13));
         --  Kreis zeichnen
	 for i in 1..8 loop
	   M(i) := D.Koord(i);
	 end loop;
	 XX := To_Float (M);
	 for i in 1..8 loop
	   M(i) := D.Koord(i+8);
	 end loop;
	 YY := To_Float (M);
--         A := PaperWidth((500.0/1835000.0) * Float(X-1114000));
--         B := PaperHeight((1000.0/262144.0) * Float(Y-5505000));
begin
         XX := ((700.0/921200.0) * (XX-282200.0)) + 1.0;
	 YY := ((4000.0/6102600.0) * (YY-5260000.0)) + 1.0;
	 A  := PaperWidth(XX);
	 B  := PaperHeight(YY);
exception
  when CONSTRAINT_ERROR =>
         Put ("--------- "); 	 
	 Put (XX, 2, 0, 0); Put (" ");
         Put (YY, 2, 0, 0); Put (" ");
         for I in 1..20 loop
            if D.Ort(I) /= 0 then
               Put (Character'Val(D.Ort(I)));
               else
                  Put (" ");
            end if;
         end loop;
  end;
    

         --  ersten vier Bytes prüfen und danach Farbe wechseln
--         case D.Koord(17) is
--            when 9 =>
--               PS_SetColor ((R=> 0.08, G => 0.08, B => 0.08));
--            when 11 =>
--               PS_SetColor ((R=> 0.24, G => 0.24, B => 0.24));
--            when 17 =>
--               PS_SetColor ((R=> 0.40, G => 0.40, B => 0.40));
--            when 26 =>
--               PS_SetColor ((R=> 0.56, G => 0.56, B => 0.56));
--            when others =>
--               PS_SetColor ((R=> 0.00, G => 0.00, B => 1.00));
--         end case;
         PS_PutDot(A,B);
      end loop;
      PS_PutFooter;
   end Put_PS;


--  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   procedure Put_Text is
      D    : Datensatz;
      X, Y : Integer;
      M    : MyFloat;
      F    : Long_Float;
   begin
      --  über alle Datensätze
      for N in 1..13370 loop
         GetDatensatz (D, N);
         --  X und Y zusammenbasteln
         X := Integer(D.Koord(7))*256*256 +
           Integer(D.Koord(6))*256 +
           Integer(D.Koord(5));
         Y := Integer(D.Koord(15))*256*256 +
           Integer(D.Koord(14))*256 +
           Integer(D.Koord(13));
         for I in 1..20 loop
            if D.Ort(I) /= 0 then
               Put (Character'Val(D.Ort(I)));
               else
                  Put (" ");
            end if;
         end loop;
--         Put (" : ");
--         Put (X, 0);
--         Put (" : ");
--         Put (Y, 0);
	 
	 for i in 1..8 loop
	   M(i) := D.Koord(i);
	 end loop;
	 F := To_Float (M);
	 Put (" : ");
	 Put (F, 2,0,0);
	 Put ("  : ");
	 X := Long_Float'Exponent(F);
	 Put (X,2);
	 
	 for i in 1..8 loop
	   M(i) := D.Koord(i+8);
	 end loop;
	 F := To_Float (M);
	 Put (" : ");
	 Put (F, 2,0,0);
         New_Line;
 --   for I in Koord_Feld'Range loop
--          for I in 1..4 loop
--             Put (D.Koord(I));
--             Put (" ");
--          end loop;
--          New_Line;
         --    X := Integer(D.Koord(4)) * 2**24 +
         --      Integer(D.Koord(3)) * 2**16 +
         --      Integer(D.Koord(2)) * 2** 8 +
         --      Integer(D.Koord(1)) * 2** 0;
         --    Put (X);
         --    New_Line;
      end loop;
   end Put_Text;



   N : Integer := 1;
   C : Color := (R => 0.00, G => 0.00, B => 1.00);



begin

--   Put_PS;
   Put_Text;


end ReadDSat;


