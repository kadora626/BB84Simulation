namespace BB84Simulation
{
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Primitive;

    operation BB84 (BitLength: Int, Eavasdropper: Bool) : (String, String, String)
    {
        body
        {
            mutable AliceKeys = "";
            mutable BobKeys = "";
            mutable EveKeys = "";
            mutable AliceBits = new Bool[BitLength];
            mutable AliceBases = new Bool[BitLength];
            mutable BobBases = new Bool[BitLength];
            mutable BobBits = new Bool[BitLength];
            mutable EveBits = new Bool[BitLength];
            mutable IsSameBase = new Bool[BitLength];
            mutable AliceKey = "";
            mutable BobKey = "";
            mutable EveKey = "";
            
            using (register = Qubit[BitLength])
            {   
                for (idx in 0..BitLength - 1) {
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

                // Eavasdropper measures qubits
                if (Eavasdropper) {
                    for (idx in 0..BitLength -1) {
                        if (RandomInt(2) == 0) {
                            X(register[idx]);
                        }
                        set EveBits[idx] = M(register[idx]) == One;
                    }
                }
                // Choose Bob's bases and measurement Qubits
                for (idx in 0..BitLength - 1) {
                    set BobBases[idx] = (RandomInt(2) == 0);
                    if (BobBases[idx]) {
                        H(register[idx]);
                        set BobBits[idx] = M(register[idx]) == One;
                    } else {
                        set BobBits[idx] = M(register[idx]) == One;
                    }
                }

                // Alice checks Bob's bases
                for (idx in 0..BitLength - 1) {
                    set IsSameBase[idx] = (AliceBases[idx] == BobBases[idx]);
                }

                // Generate Key
                for (idx in 0..BitLength - 1) {
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
                        if (Eavasdropper) {
                            if (EveBits[idx]) {
                                set EveKey = "1";
                            } else {
                                set EveKey = "0";
                            }
                            set EveKeys = EveKeys + EveKey;
                        }
                    }
                }
                ResetAll(register);
            }
            return (AliceKeys, BobKeys, EveKeys);
        }
    }
}
