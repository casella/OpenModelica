// name:     ArrayMatrixMatrixMul4
// keywords: expression simplification array multiplication
// status:   correct
//
// Checks simplification of matrix-matrix multiplication.
//

model ArrayMatrixMatrixMul4
  Real x[5, 4], y[4, 5], z[5, 5];
equation
  z = x * y;
  annotation(__OpenModelica_commandLineOptions="-d=-newInst");
end ArrayMatrixMatrixMul4;

// Result:
// class ArrayMatrixMatrixMul4
//   Real x[1,1];
//   Real x[1,2];
//   Real x[1,3];
//   Real x[1,4];
//   Real x[2,1];
//   Real x[2,2];
//   Real x[2,3];
//   Real x[2,4];
//   Real x[3,1];
//   Real x[3,2];
//   Real x[3,3];
//   Real x[3,4];
//   Real x[4,1];
//   Real x[4,2];
//   Real x[4,3];
//   Real x[4,4];
//   Real x[5,1];
//   Real x[5,2];
//   Real x[5,3];
//   Real x[5,4];
//   Real y[1,1];
//   Real y[1,2];
//   Real y[1,3];
//   Real y[1,4];
//   Real y[1,5];
//   Real y[2,1];
//   Real y[2,2];
//   Real y[2,3];
//   Real y[2,4];
//   Real y[2,5];
//   Real y[3,1];
//   Real y[3,2];
//   Real y[3,3];
//   Real y[3,4];
//   Real y[3,5];
//   Real y[4,1];
//   Real y[4,2];
//   Real y[4,3];
//   Real y[4,4];
//   Real y[4,5];
//   Real z[1,1];
//   Real z[1,2];
//   Real z[1,3];
//   Real z[1,4];
//   Real z[1,5];
//   Real z[2,1];
//   Real z[2,2];
//   Real z[2,3];
//   Real z[2,4];
//   Real z[2,5];
//   Real z[3,1];
//   Real z[3,2];
//   Real z[3,3];
//   Real z[3,4];
//   Real z[3,5];
//   Real z[4,1];
//   Real z[4,2];
//   Real z[4,3];
//   Real z[4,4];
//   Real z[4,5];
//   Real z[5,1];
//   Real z[5,2];
//   Real z[5,3];
//   Real z[5,4];
//   Real z[5,5];
// equation
//   z[1,1] = x[1,1] * y[1,1] + x[1,2] * y[2,1] + x[1,3] * y[3,1] + x[1,4] * y[4,1];
//   z[1,2] = x[1,1] * y[1,2] + x[1,2] * y[2,2] + x[1,3] * y[3,2] + x[1,4] * y[4,2];
//   z[1,3] = x[1,1] * y[1,3] + x[1,2] * y[2,3] + x[1,3] * y[3,3] + x[1,4] * y[4,3];
//   z[1,4] = x[1,1] * y[1,4] + x[1,2] * y[2,4] + x[1,3] * y[3,4] + x[1,4] * y[4,4];
//   z[1,5] = x[1,1] * y[1,5] + x[1,2] * y[2,5] + x[1,3] * y[3,5] + x[1,4] * y[4,5];
//   z[2,1] = x[2,1] * y[1,1] + x[2,2] * y[2,1] + x[2,3] * y[3,1] + x[2,4] * y[4,1];
//   z[2,2] = x[2,1] * y[1,2] + x[2,2] * y[2,2] + x[2,3] * y[3,2] + x[2,4] * y[4,2];
//   z[2,3] = x[2,1] * y[1,3] + x[2,2] * y[2,3] + x[2,3] * y[3,3] + x[2,4] * y[4,3];
//   z[2,4] = x[2,1] * y[1,4] + x[2,2] * y[2,4] + x[2,3] * y[3,4] + x[2,4] * y[4,4];
//   z[2,5] = x[2,1] * y[1,5] + x[2,2] * y[2,5] + x[2,3] * y[3,5] + x[2,4] * y[4,5];
//   z[3,1] = x[3,1] * y[1,1] + x[3,2] * y[2,1] + x[3,3] * y[3,1] + x[3,4] * y[4,1];
//   z[3,2] = x[3,1] * y[1,2] + x[3,2] * y[2,2] + x[3,3] * y[3,2] + x[3,4] * y[4,2];
//   z[3,3] = x[3,1] * y[1,3] + x[3,2] * y[2,3] + x[3,3] * y[3,3] + x[3,4] * y[4,3];
//   z[3,4] = x[3,1] * y[1,4] + x[3,2] * y[2,4] + x[3,3] * y[3,4] + x[3,4] * y[4,4];
//   z[3,5] = x[3,1] * y[1,5] + x[3,2] * y[2,5] + x[3,3] * y[3,5] + x[3,4] * y[4,5];
//   z[4,1] = x[4,1] * y[1,1] + x[4,2] * y[2,1] + x[4,3] * y[3,1] + x[4,4] * y[4,1];
//   z[4,2] = x[4,1] * y[1,2] + x[4,2] * y[2,2] + x[4,3] * y[3,2] + x[4,4] * y[4,2];
//   z[4,3] = x[4,1] * y[1,3] + x[4,2] * y[2,3] + x[4,3] * y[3,3] + x[4,4] * y[4,3];
//   z[4,4] = x[4,1] * y[1,4] + x[4,2] * y[2,4] + x[4,3] * y[3,4] + x[4,4] * y[4,4];
//   z[4,5] = x[4,1] * y[1,5] + x[4,2] * y[2,5] + x[4,3] * y[3,5] + x[4,4] * y[4,5];
//   z[5,1] = x[5,1] * y[1,1] + x[5,2] * y[2,1] + x[5,3] * y[3,1] + x[5,4] * y[4,1];
//   z[5,2] = x[5,1] * y[1,2] + x[5,2] * y[2,2] + x[5,3] * y[3,2] + x[5,4] * y[4,2];
//   z[5,3] = x[5,1] * y[1,3] + x[5,2] * y[2,3] + x[5,3] * y[3,3] + x[5,4] * y[4,3];
//   z[5,4] = x[5,1] * y[1,4] + x[5,2] * y[2,4] + x[5,3] * y[3,4] + x[5,4] * y[4,4];
//   z[5,5] = x[5,1] * y[1,5] + x[5,2] * y[2,5] + x[5,3] * y[3,5] + x[5,4] * y[4,5];
// end ArrayMatrixMatrixMul4;
// endResult
