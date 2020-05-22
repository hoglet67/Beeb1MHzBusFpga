module ODDR2
  (
   Q,
   C0,
   C1,
   CE,
   D0,
   D1,
   R,
   S
   );

   output     Q;
   input      C0;
   input      C1;
   input      CE;
   input      D0;
   input      D1;
   input      R;
   input      S;

   reg        Q0;
   reg        Q1;

   initial begin
      Q0 = 0;
      Q1 = 0;
   end

   always @(posedge C0)
     if (CE)
       Q0 <= D0;

   always @(posedge C1)
     if (CE)
       Q1 <= D1;

   assign Q = C0 ? Q0 : C1 ? Q1 : 1'b0;

endmodule
