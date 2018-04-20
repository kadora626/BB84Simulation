namespace BB84Simulation
{
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Primitive;

    operation BB84 (bitLength: Int) : (String, String)
    {
        body
        {
            mutable AliceKeys = "";
            mutable BobKeys = "";
            mutable AliceBits = new Bool[bitLength];
            mutable AliceBases = new Bool[bitLength];
            mutable BobBases = new Bool[bitLength];
            mutable BobBits = new Bool[bitLength];
            mutable IsSameBase = new Bool[bitLength];
            mutable AliceKey = "";
            mutable BobKey = "";
            
            using (register = Qubit[bitLength])
            {   
                for (idx in 0..bitLength - 1) {
                    // Choose Alice's bits and bases
                    set AliceBits[idx] = (RandomInt(2) == 0);
                    set AliceBases[idx] = (RandomInt(2) == 0);
                    // Prepare Qubits by using Alice's bits and bases
                    if (AliceBits[idx]) {
                        X(register[idx]);
                    }
                    if (AliceBases[idx]) {
                        H(register[idx]);
                    }
                }

                // Choose Bob's bases and measurement Qubits
                for (idx in 0..bitLength - 1) {
                    set BobBases[idx] = (RandomInt(2) == 0);
                    if (BobBases[idx]) {
                        H(register[idx]);
                        set BobBits[idx] = M(register[idx]) == One;
                    } else {
                        set BobBits[idx] = M(register[idx]) == One;
                    }
                }

                // Alice checks Bob's bases
                for (idx in 0..bitLength - 1) {
                    set IsSameBase[idx] = (AliceBases[idx] == BobBases[idx]);
                }

                // Generate Key
                for (idx in 0..bitLength - 1) {
                    if (IsSameBase[idx]) {
                        if (AliceBits[idx]) {
                            set AliceKey = "1";
                        } else {
                            set AliceKey = "0";
                        }
                        if (BobBits[idx]) {
                            set BobKey = "1";
                        } else {
                            set BobKey = "0";
                        }
                        set AliceKeys = AliceKeys + AliceKey;
                        set BobKeys = BobKeys + BobKey;
                    }
                }
                ResetAll(register);
            }
            return (AliceKeys, BobKeys);
        }
    }
}
