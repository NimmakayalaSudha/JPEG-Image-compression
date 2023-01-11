`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/20/2021 10:22:10 AM
// Design Name: 
// Module Name: dct
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module dct_2(input clk);
wire [24:0]c[7:0][7:0];                 /// DCT coffecient matrix
reg [24:0]ct[7:0][7:0];                /// C transpose matrix
wire [24:0]q1[7:0][7:0];
reg [14:0]addra;                      /// accessing address of image from the coa file
wire [11:0]x1;                       ///serial pixel from coe file 
reg [63:0]x[127:0][127:0];          /// image in serial fromat stored to matrix format
reg [63:0]cx[127:0][127:0];           /// CX matrix
reg [63:0]cxct[127:0][127:0]; 
reg [63:0]dctq[127:0][127:0];
reg [63:0]idctq[127:0][127:0];       /// CTCX matrix
reg [63:0]ctDCT[127:0][127:0];
reg [63:0]iDCT[127:0][127:0];
wire [31:0]q[7:0][7:0];
/////////////////////////block memory generator for input image matrix//////////////////////////
blk_mem_gen_0 your_instance_name (
  .clka(clk),    // input wire clka
  .addra(addra),  // input wire [14 : 0] addra
  .douta(x1)  // output wire [11 : 0] douta
);
/////////////////////////////////code for accessing serial input pixels into  128X128 matrix format/////////////////////////
reg [14:0]l,n,o;
reg flag,qflag;
reg [3:0]count;
initial 
begin
addra=0;
l=0;
o=0;
n=0;
flag=1;
end
always @(posedge clk && flag)
begin  
        if(addra>=2)  ////pixels start from address 2;
        begin          
            x[o][l]={x1,24'h000000};
            o=o+1;
            if(o==(n+8))
               begin
                 l=l+1;//coloum shift
                 o=n;
                 if(l==128)
                     begin
                         o=n+8;
                         l=0;
                         n=o;
                         if(n==128)
                             flag=0;
                     end
               end
        end
         addra=addra+1;
         count=(addra>=2) ? (count+1) :0;
end
////////////////////////////////////////////C matrix////////////////////////////////////////////
assign 
c[0][0]=25'h5A8587,c[1][0]=25'h7D8ADA,c[2][0]=25'h763F14,c[3][0]=25'h6A6B50,c[4][0]=25'h5A8587,c[5][0]=25'h471DE6,c[6][0]=25'h30F909,c[7][0]=25'h18F5C2,
c[0][1]=25'h5A8587,c[1][1]=25'h6A6B50,c[2][1]=25'h30F909,c[3][1]=25'h1E70A3E,c[4][1]=25'h1A57A79,c[5][1]=25'h1827526,c[6][1]=25'h189C0EC,c[7][1]=25'h1B8E21A,
c[0][2]=25'h5A8587,c[1][2]=25'h471DE6,c[2][2]=25'h1CF06F7,c[3][2]=25'h1827526,c[4][2]=25'h1A57A79,c[5][2]=25'h18F5C2,c[6][2]=25'h763F14,c[7][2]=25'h6A6B50,
c[0][3]=25'h5A8587,c[1][3]=25'h18F5C2,c[2][3]=25'h189C0EC,c[3][3]=25'h1B8E21A,c[4][3]=25'h5A8587,c[5][3]=25'h6A6B50,c[6][3]=25'h1CF06F7,c[7][3]=25'h1827526,
c[0][4]=25'h5A8587,c[1][4]=25'h1E70A3E,c[2][4]=25'h189C0EC,c[3][4]=25'h471DE6,c[4][4]=25'h5A8587,c[5][4]=25'h19594B0,c[6][4]=25'h1CF06F7,c[7][4]=25'h7D8ADA,
c[0][5]=25'h5A8587,c[1][5]=25'h1B8E21A,c[2][5]=25'h1CF06F7,c[3][5]=25'h7D8ADA,c[4][5]=25'h1A57A79,c[5][5]=25'h1E70A3E,c[6][5]=25'h763F14,c[7][5]=25'h19594B0,
c[0][6]=25'h5A8587,c[1][6]=25'h19594B0,c[2][6]=25'h30F909,c[3][6]=25'h18F5C2,c[4][6]=25'h1A57A79,c[5][6]=25'h7D8ADA,c[6][6]=25'h189C0EC,c[7][6]=25'h471DE6,
c[0][7]=25'h5A8587,c[1][7]=25'h1827526,c[2][7]=25'h763F14,c[3][7]=25'h19594B0,c[4][7]=25'h5A8587,c[5][7]=25'h1B8E21A,c[6][7]=25'h30F909,c[7][7]=25'h1E70A3E;
/////////////////////////////////////////C transpose matrix////////////////////////////////////
assign                          
q[0][0]=32'h10000000,   q[1][0]=32'h0c000000 ,  q[2][0]=32'h0e000000 , q[3][0]=32'h0e000000  ,  q[4][0]=32'h12000000 ,q[5][0]=32'h18000000 ,  q[6][0]=32'h31000000 , q[7][0]=32'h48000000 ,
q[0][1]=32'h0b000000,   q[1][1]=32'h0c000000 ,  q[2][1]=32'h0d000000 , q[3][1]=32'h11000000  ,  q[4][1]=32'h16000000 ,q[5][1]=32'h23000000 ,  q[6][1]=32'h40000000 , q[7][1]=32'h5c000000 ,
q[0][2]=32'h0a000000,   q[1][2]=32'h0e000000 ,  q[2][2]=32'h10000000 , q[3][2]=32'h16000000  ,  q[4][2]=32'h25000000 ,q[5][2]=32'h37000000 ,  q[6][2]=32'h4e000000 , q[7][2]=32'h5f000000 ,
q[0][3]=32'h10000000,   q[1][3]=32'h13000000 ,  q[2][3]=32'h18000000 , q[3][3]=32'h1d000000  ,  q[4][3]=32'h38000000 ,q[5][3]=32'h40000000 ,  q[6][3]=32'h57000000 , q[7][3]=32'h62000000 ,
q[0][4]=32'h18000000,   q[1][4]=32'h1a000000 ,  q[2][4]=32'h28000000 , q[3][4]=32'h33000000  ,  q[4][4]=32'h44000000 ,q[5][4]=32'h51000000 ,  q[6][4]=32'h67000000 , q[7][4]=32'h70000000 ,
q[0][5]=32'h28000000,   q[1][5]=32'h3a000000 ,  q[2][5]=32'h39000000 , q[3][5]=32'h57000000  ,  q[4][5]=32'h6d000000 ,q[5][5]=32'h68000000 ,  q[6][5]=32'h79000000 , q[7][5]=32'h64000000 ,
q[0][6]=32'h33000000,   q[1][6]=32'h3c000000 ,  q[2][6]=32'h45000000 , q[3][6]=32'h50000000  ,  q[4][6]=32'h67000000 ,q[5][6]=32'h71000000 ,  q[6][6]=32'h78000000 , q[7][6]=32'h67000000 ,
q[0][7]=32'h3d000000,   q[1][7]=32'h37000000 ,  q[2][7]=32'h38000000 , q[3][7]=32'h3e000000  ,  q[4][7]=32'h4d000000 ,q[5][7]=32'h5c000000 ,  q[6][7]=32'h65000000 , q[7][7]=32'h63000000;
//////////
assign 
q1[0][0]=25'h100000,q1[1][0]=25'h155555,q1[2][0]=25'h0c7943,q1[3][0]=25'h0c7943,q1[4][0]=25'h0e38e3,q1[5][0]=25'h0aaaaa,q1[6][0]=25'h053978,q1[7][0]=25'h038e38,
q1[0][1]=25'h1745d1,q1[1][1]=25'h155555,q1[2][1]=25'h13b13b,q1[3][1]=25'h0f0f0f,q1[4][1]=25'h0ba2e8,q1[5][1]=25'h075075,q1[6][1]=25'h040000,q1[7][1]=25'h02c859,
q1[0][2]=25'h199999,q1[1][2]=25'h124924,q1[2][2]=25'h100000,q1[3][2]=25'h0ba2e8,q1[4][2]=25'h06eb3e,q1[5][2]=25'h04a790,q1[6][2]=25'h034834,q1[7][2]=25'h02b1da,
q1[0][3]=25'h100000,q1[1][3]=25'h0c7943,q1[2][3]=25'h0aaaaa,q1[3][3]=25'h08d3dc,q1[4][3]=25'h049249,q1[5][3]=25'h040000,q1[6][3]=25'h02f149,q1[7][3]=25'h029cbc,
q1[0][4]=25'h0aaaaa,q1[1][4]=25'h09d89d,q1[2][4]=25'h066666,q1[3][4]=25'h050505,q1[4][4]=25'h03c3c3,q1[5][4]=25'h032916,q1[6][4]=25'h033333,q1[7][4]=25'h024924,
q1[0][5]=25'h066666,q1[1][5]=25'h0469ee,q1[2][5]=25'h047dc1,q1[3][5]=25'h02f149,q1[4][5]=25'h02593f,q1[5][5]=25'h027627,q1[6][5]=25'h021d9e,q1[7][5]=25'h0288df,
q1[0][6]=25'h050505,q1[1][6]=25'h044444,q1[2][6]=25'h03b5cc,q1[3][6]=25'h033333,q1[4][6]=25'h027c45,q1[5][6]=25'h0243f6,q1[6][6]=25'h022222,q1[7][6]=25'h033333,
q1[0][7]=25'h04325c,q1[1][7]=25'h03f03f,q1[2][7]=25'h049249,q1[3][7]=25'h042108,q1[4][7]=25'h03531d,q1[5][7]=25'h027859,q1[6][7]=25'h0288df,q1[7][7]=25'h0295fa;
integer row,column;
always@(*)
begin
for(row=0;row<8;row=row+1)
    for(column=0;column<8;column=column+1)
        ct[row][column]=c[column][row];
end
//////////////////////////////////////////////////////// required variable declaration for CX
reg [4:0] obc_count;
reg [31:0]p_en;
reg obc_en,pp;
reg [2:0] it,j;
reg [3:0]sb,rb;
reg [24:0]C[7:0];
reg [63:0]X[7:0];
wire [63:0]CX1;
wire out;
integer i;
//////////////////////////////////////////////////////// required variable declaration for CXCT
reg [4:0] obc_count1;
reg [31:0]p_en1;
reg obc_en1,pp1;
reg [2:0] it1,j1;
reg [3:0]sb1,rb1;
reg [24:0]CT[7:0];
reg [63:0]CX[7:0];
wire [63:0]CX2;
wire out1;
integer i1;
reg [5:0] count_8;
reg nxt_lvl;
//////////////////////////////////////////////////////// required variable declaration for CT*dct
reg [4:0] obc_count2;
reg [31:0]p_en2;
reg obc_en2,pp2;
reg [2:0] it2,j2;
reg [3:0]sb2,rb2;
reg [24:0]iCT[7:0];
reg [63:0]iCX[7:0];
wire [63:0]CX3;
wire out2;
integer i2;
reg [5:0] count_57;
reg nxt_lvl1;
//////////////////////////////////////////////////////// required variable declaration for idct
reg [4:0] obc_count3;
reg [31:0]p_en3;
reg obc_en3,pp3;
reg [2:0] it3,j3;
reg [3:0]sb3,rb3;
reg [24:0]iiCT[7:0];
reg [63:0]iiCX[7:0];
wire [63:0]CX4;
wire out3;
integer i3;
reg [7:0]i7,i6,j6,j7;
reg [5:0] count1_8;
reg nxt_lvl2;
//////////variables for quantization
reg [63:0]x_in,ix_in;
reg [63:0]z_in,iz_in;
wire [63:0]multiply,imultiply;
reg pro_en,ipro_en;
reg [1:0]count_q,icount_q;
//////////////////////////// file variables
integer file_id;
//////////////////
initial file_id=$fopen("C:\\Users\\VLSI\\Documents\\dctqfinal.txt","w");
////////////////////////////////////////////////////////////////////////////// Initialisations
initial begin  obc_count=1;it=0;p_en=0;j=0;sb=0;rb=0;
               obc_count1=0;it1=0;p_en1=0;j1=0;sb1=0;rb1=0;count_8=0;nxt_lvl=0;
                obc_count2=0;it2=0;p_en2=0;j2=0;sb2=0;rb2=0;count_57=0;nxt_lvl1=0;
                obc_count3=0;it3=0;p_en3=0;j3=0;sb3=0;rb3=0;count1_8=0;nxt_lvl2=0;  
                i7=0;i6=0;j6=0;j7=0;qflag=0;count_q=0;icount_q=0;pro_en=0;ipro_en=0; end
//////////////////////////////////////
reg [2:0]qn1,qn2,iqn1,iqn2;
reg [3:0]sbq,rbq,isbq,irbq;
reg invflag,invflag1;
initial begin qn1=0;qn2=0;iqn1=0;iqn2=0;invflag=0;invflag1=0;sbq=0;rbq=0;isbq=0;irbq=0; end
//////////////////////////////////////////// CX calculation
always @(posedge clk)
begin
if((count==9) || (obc_count==0) )
    begin
    for(i=0;i<=7;i=i+1)
      begin
         C[i]=c[j][i];
         X[i]= x[i+(rb*8)][it+(8*sb)];
      end
      obc_en=1;
    end
if(obc_en)
    begin
    if(p_en==0)
        pp=1;
    else
        pp=0;
    p_en=p_en+1;
    obc_count=obc_count+1;
    if(obc_count==27)
    begin
        obc_count=0;
        obc_en=0;
        p_en=0;
        if(out)
        begin
            
            if(count_8==7)
               nxt_lvl=1;
            count_8=count_8+1;
            cx[j+(rb*8)][it+(sb*8)]=CX1;
            if(it==7)
            begin
                if(j==7)
                begin
                    if(sb==15)
                      begin
                      rb=rb+1;
                      end
                    sb=sb+1;
                end
                j=j+1;
                end
            it=it+1;
        end
    end
end
/////////////////  (CT)(CX) ///////////////////////
if(nxt_lvl==1)
    begin
    if(obc_count1==0)
       begin
       for(i1=0;i1<=7;i1=i1+1)
            begin
            CT[i1]=ct[i1][it1];
            CX[i1]=cx[j1+(rb1*8)][i1+(sb1*8)];
            end
       obc_en1=1;
       end
    if(obc_en1)
           begin
           if(p_en1==0)
               pp1=1;
           else
               pp1=0;
           p_en1=p_en1+1;
           obc_count1=obc_count1+1;
           if(obc_count1==27)
           begin
               obc_count1=0;
               obc_en1=0;
               p_en1=0;
               if(out1)
               begin
                   if(count_57==57)
                   nxt_lvl1=1;
                   count_57= count_57+1;
                   cxct[j1+(rb1*8)][it1+(sb1*8)]=CX2;//cxct[it1+(8*sb1)][j1+(rb1*8)]=CX2;
                   if(it1==7)
                   begin
                       if(j1==7)
                       begin
                           if(sb1==15)
                             begin
                             rb1=rb1+1;
                             end
                           sb1=sb1+1;
                       end
                       j1=j1+1;
                       end
                   it1=it1+1;
               end
           end
       end
    end
 /////////////////////////////////////////////////////////////////////
// //////////////////////////////////////////////Quantisation///////////////////////////////

if(nxt_lvl1==1)
begin
        x_in={cxct[qn2+(rbq*8)][qn1+(sbq*8)][63:24],24'b0};//CX[i1]=cx[j1+(rb1*8)][i1+(sb1*8)];
        z_in=q1[qn2][qn1];
        pro_en=1;   
        count_q=count_q+1;
        if(count_q==3)
           begin
            //invflag=1;
             dctq[qn2+(rbq*8)][qn1+(sbq*8)]=multiply;
             if(qn1==7 & qn2==7 & sbq==15 & rbq==15)
                invflag=1;
             if(qn1==7)
             begin
                  if(qn2==7)
                       begin
                           if(sbq==15)
                             begin
                             rbq=rbq+1;
                             end
                           sbq=sbq+1;
                       end
                   qn2=qn2+1;
             end
             qn1=qn1+1;
             pro_en=0;
           end
end
   
//////////////////////////////////////////////// inverse quantisation///////////////////////////////
if(invflag==1)
begin
        ix_in={dctq[iqn2+(irbq*8)][iqn1+(isbq*8)][63:24],24'b0};
        iz_in=q[iqn2][iqn1];
        ipro_en=1;   
        icount_q=icount_q+1;
        if(icount_q==3)
           begin
            // invflag1=1;
             idctq[iqn2+(irbq*8)][iqn1+(isbq*8)]=imultiply;
             if(iqn1==7 & iqn2==7 & isbq==15 & irbq==15)
                             invflag1=1;
             if(iqn1==7)
                          begin
                               if(iqn2==7)
                                    begin
                                        if(isbq==15)
                                          begin
                                          irbq=irbq+1;
                                          end
                                        isbq=isbq+1;
                                    end
                                iqn2=iqn2+1;
                          end
             iqn1=iqn1+1;
             ipro_en=0;
           end
end
///////////////////////////////////////////////////////////////////////////////  
 
 if(invflag1==1)
     begin
     if(obc_count2==0)
        begin
        for(i2=0;i2<=7;i2=i2+1)
             begin
             iCT[i2]=ct[j2][i2];
             iCX[i2]=idctq[i2+(rb2*8)][it2+(sb2*8)];
             end
        obc_en2=1;
        end
     if(obc_en2)
            begin
            if(p_en2==0)
                pp2=1;
            else
                pp2=0;
            p_en2=p_en2+1;
            obc_count2=obc_count2+1;
            if(obc_count2==27)
            begin
                obc_count2=0;
                obc_en2=0;
                p_en2=0;
                if(out2)
                begin
                    if(count1_8==7)
                     nxt_lvl2=1;
                    count1_8=count1_8+1;
                    ctDCT[j2+(rb2*8)][it2+(sb2*8)]=CX3;//cxct[it1+(8*sb1)][j1+(rb1*8)]=CX2;
                    if(it2==7)
                    begin
                        if(j2==7)
                        begin
                            if(sb2==15)
                              begin
                              rb2=rb2+1;
                              end
                            sb2=sb2+1;
                        end
                        j2=j2+1;
                        end
                    it2=it2+1;
                end
            end
        end
     end
 //////////////////////////////////////////////////////////////
 if(nxt_lvl2==1)
      begin
      if(obc_count3==0)
         begin
         for(i3=0;i3<=7;i3=i3+1)
              begin
              iiCT[i3]=c[i3][it3];
              iiCX[i3]=ctDCT[j3+(rb3*8)][i3+(sb3*8)];
              end
         obc_en3=1;
         end
      if(obc_en3)
             begin
             if(p_en3==0)
                 pp3=1;
             else
                 pp3=0;
             p_en3=p_en3+1;
             obc_count3=obc_count3+1;
             if(obc_count3==27)
             begin
                 obc_count3=0;
                 obc_en3=0;
                 p_en3=0;
                 if(out3)
                 begin
                     iDCT[j3+(rb3*8)][it3+(sb3*8)]=CX4;//cxct[it1+(8*sb1)][j1+(rb1*8)]=CX2;
                     $fwrite(file_id,"\n",CX4[63:24]);
                     if(sb3==15 & rb3==15 & it3==7 & j3==7)
                     $fclose(file_id);
                     if(it3==7)
                     begin
                         if(j3==7)
                         begin
                             if(sb3==15)
                               begin
                               rb3=rb3+1;
                               end
                             sb3=sb3+1;
                         end
                         j3=j3+1;
                         end
                     it3=it3+1;
                 end
             end
         end
      end
  end
  obc_new a1(C[0],C[1],C[2],C[3],C[4],C[5],C[6],C[7],X[0],X[1],X[2],X[3],X[4],X[5],X[6],X[7],clk,CX1,pp,out);
  obc_new a2(CT[0],CT[1],CT[2],CT[3],CT[4],CT[5],CT[6],CT[7],CX[0],CX[1],CX[2],CX[3],CX[4],CX[5],CX[6],CX[7],clk,CX2,pp1,out1);
  obc_new a3(iCT[0],iCT[1],iCT[2],iCT[3],iCT[4],iCT[5],iCT[6],iCT[7],iCX[0],iCX[1],iCX[2],iCX[3],iCX[4],iCX[5],iCX[6],iCX[7],clk,CX3,pp2,out2);
  obc_new a4(iiCT[0],iiCT[1],iiCT[2],iiCT[3],iiCT[4],iiCT[5],iiCT[6],iiCT[7],iiCX[0],iiCX[1],iiCX[2],iiCX[3],iiCX[4],iiCX[5],iiCX[6],iiCX[7],clk,CX4,pp3,out3); 
  product a5(clk,x_in,z_in,pro_en,multiply);
  product a6(clk,ix_in,iz_in,ipro_en,imultiply);
  wire [63:0]res_dct_128,res_dct1_0,idct_Res1_8;
  assign res_dct_128=iDCT[127][127];
  assign res_dct1_0=iDCT[0][0];
  assign idct_Res1_8=iDCT[7][7];
  endmodule