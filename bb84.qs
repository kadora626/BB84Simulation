namespace BB84Simulation
{
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Primitive;

    operation BB84 () : (String, String)
    {
        body
        {
            mutable AliceKeys = "";
            mutable BobKeys = "";
            mutable AliceBits = new Bool[10];
            mutable AliceBases = new Bool[10];
            mutable BobBases = new Bool[10];
            mutable BobBits = new Bool[10];
            mutable IsSameBase = new Bool[10];
            mutable AliceKey = "";
            mutable BobKey = "";
            
            using (register = Qubit[10])
            {   
                for (i in 0..9) {
                    // Choose Alice's bits and bases
                    set AliceBits[i] = (RandomInt(2) == 0);
                    set AliceBases[i] = (RandomInt(2) == 0);
                    // Prepare Qubits by using Alice's bits and bases
                    if (AliceBits[i]) {
                        X(register[i]);
                    }
                    if (AliceBases[i]) {
                        H(register[i]);
                    }
                }

                // Choose Bob's bases and measurement Qubits
                for (i in 0..9) {
                    set BobBases[i] = (RandomInt(2) == 0);
                    if (BobBases[i]) {
                        H(register[i]);
                        set BobBits[i] = M(register[i]) == One;
                    } else {
                        set BobBits[i] = M(register[i]) == One;
                    }
                }

                // Alice checks Bob's bases
                for (i in 0..9) {
                    set IsSameBase[i] = (AliceBases[i] == BobBases[i]);
                }

                // Generate Key
                for (i in 0..9) {
                    if (IsSameBase[i]) {
                        if (AliceBits[i]) {
                            set AliceKey = "1";
                        } else {
                            set AliceKey = "0";
                        }
                        if (BobBits[i]) {
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
