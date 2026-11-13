          ADDS XZR, X2, X3
          ADD XZR, XZR, XZR
          ADD XZR, XZR, XZR
          B.PL L1
          ADD XZR, XZR, XZR
          ADD XZR, XZR, XZR
          STUR X15, [X0, #0]
          CBZ XZR, L2
          ADD XZR, XZR, XZR
          ADD XZR, XZR, XZR
          ADD XZR, XZR, XZR
     L1:  STUR X30, [X0, #0] // MEM 0:0x1E
     L2:  ADD X30, X0, #4095
          ADD XZR, XZR, XZR
          ADD XZR, XZR, XZR
     L3:  ADDS X30, X30, X30
          ADD XZR, XZR, XZR
          ADD XZR, XZR, XZR
          B.VS L4
          ADD XZR, XZR, XZR
          ADD XZR, XZR, XZR
          CBZ XZR, L3
     L4:  STUR X7, [X0, #8] // MEM 1: 0x7
          SUBS X1, X10, X5
          B.PL L5
          ADD XZR, XZR, XZR
          ADD XZR, XZR, XZR
          STUR X15, [X0, #16]
          CBZ XZR, L6
          ADD XZR, XZR, XZR
          ADD XZR, XZR, XZR
     L5:  STUR X1, [X0, #16] // MEM 2: 0x05
     L6:  SUBS X2, X5, X10
          B.MI L7
          ADD XZR, XZR, XZR
          ADD XZR, XZR, XZR
          STUR X15, [X0, #24]
          CBZ XZR, L8
          ADD XZR, XZR, XZR
          ADD XZR, XZR, XZR
     L7:  STUR X2, [X0, #24] // MEM 3: 0xFFFFFFFFFFFFFFFB
     L8:  SUBS X3, X10, X10
          B.EQ L9
          ADD XZR, XZR, XZR
          ADD XZR, XZR, XZR
          STUR X15, [X0, #32]
          CBZ XZR, L10
          ADD XZR, XZR, XZR
          ADD XZR, XZR, XZR
     L9:  STUR X3, [X0, #32] // MEM 4: 0x00
     L10: SUBS X4, X1, X1
          B.NE L11
          ADD XZR, XZR, XZR
          ADD XZR, XZR, XZR
          STUR X15, [X0, #40]
          CBZ XZR, L12
     L11: STUR X4, [X0, #40] // MEM 5: 0x00
     L12: SUBS X5, X1, X10
          B.GT L13
          ADD XZR, XZR, XZR
          ADD XZR, XZR, XZR
          STUR X15, [X0, #48]
          CBZ XZR, L14
     L13: STUR X5, [X0, #48] // MEM 6: 0xFFFFFFFFFFFFFFFB
     L14: SUBS X6, X10, X1
          B.LT L15
          ADD XZR, XZR, XZR
          ADD XZR, XZR, XZR
          STUR X15, [X0, #56]
          CBZ XZR, L16
     L15: STUR X6, [X0, #56] // MEM 7: 0x05
     L16: SUBS X7, X1, X1
          B.GE L17
          ADD XZR, XZR, XZR
          ADD XZR, XZR, XZR
          STUR X15, [X0, #64]
          CBZ XZR, L18
     L17: STUR X7, [X0, #64] // MEM 8: 0x00
     L18: SUBS X8, X5, X10
          B.LE L19
          ADD XZR, XZR, XZR
          ADD XZR, XZR, XZR
          STUR X15, [X0, #72]
          CBZ XZR, finloop
     L19: STUR X10, [X0, #72] // MEM 9: 0x0A    
     finloop: CBZ XZR, finloop
          ADD XZR, XZR, XZR
          ADD XZR, XZR, XZR

