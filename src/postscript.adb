with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Float_Text_IO;   use Ada.Float_Text_IO;

package body PostScript is


   procedure PS_PutDot (X : in PaperWidth; Y : in PaperHeight) is
   begin
      Put ("newpath ");
      Put (X,0); Put (" "); Put (Y,0);
      Put_Line (" 1 0 360 arc fill");

   end PS_PutDot;

   procedure PS_PutHeader is
   begin
      --  PostScript-Header
      Put_Line ("%!PS-Adobe-2.0");
      Put_Line ("/Helvetica findfont 5 scalefont setfont");
      Put_Line ("%%Page: 1");
      Put_Line ("gsave");
   end PS_PutHeader;

   procedure PS_PutFooter is
   begin
      Put_Line ("showpage");
      Put_Line ("grestore");
      Put_Line ("%%EOF");
   end PS_PutFooter;


   procedure PS_SetColor (C : in Color) is
   begin
      Put (Float(C.R),2,0,0); Put (" ");
      Put (Float(C.G),2,0,0); Put (" ");
      Put (Float(C.B),2,0,0);
      Put_Line (" setrgbcolor ");
   end PS_SetColor;

end PostScript;
