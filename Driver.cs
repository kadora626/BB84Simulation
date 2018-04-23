using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;

namespace BB84Simulation
{
    class Driver
    {
        private static bool SimulateBB84(int KeyLength, int CheckLength, int StepBits, bool Eavesdropper) {
            var result = true;
            using (var sim = new QuantumSimulator())
            {
                var AliceKey = "";
                var BobKey = "";
                var EveKey = "";
                var EavesdropMessage = "WARNING!! There is an eavesdropper.";

                // Execute BB84 protocol until earn needed length bits
                while (AliceKey.Length < KeyLength + CheckLength){
                    var res = BB84.Run(sim, StepBits, Eavesdropper).Result;
                    var (AliceReceives, BobReceives, EveReceives) = res;
                    AliceKey = AliceKey + AliceReceives;
                    BobKey = BobKey + BobReceives;
                    EveKey = EveKey + EveReceives;
                }

                // Checks if there is an eavesdropper
                var AliceCheckBits = AliceKey.Substring(KeyLength, CheckLength);
                var BobCheckBits = BobKey.Substring(KeyLength, CheckLength);
                if (AliceCheckBits == BobCheckBits) {
                    EavesdropMessage = "There is no eavesdropper.";
                    result = false;
                }

                // Write results
                System.Console.WriteLine(EavesdropMessage);
                System.Console.WriteLine($"AliceKey:       {AliceKey.Substring(0,KeyLength)}");
                System.Console.WriteLine($"BobKey:         {BobKey.Substring(0,KeyLength)}");
                if (Eavesdropper) {
                    System.Console.WriteLine($"EveKey:         {EveKey.Substring(0,KeyLength)}");
                }
                System.Console.WriteLine($"AliceCheckBits: {AliceCheckBits}");
                System.Console.WriteLine($"BobCheckBits:   {BobCheckBits}");
            }
            System.Console.WriteLine("\n\n");
            return result;
        }

        static void Main(string[] args)
        {
            var KeyLength = 5;
            var CheckLength = 5;
            var StepBits = 10;

            // Pattern with no eavasdropper
            System.Console.WriteLine("PART1:");
            SimulateBB84(KeyLength,CheckLength,StepBits,false);

            // Pattern with eavasdropper
            System.Console.WriteLine("PART2:");
            var Steps = 1000;
            var CountEavesdrop = 0;
            var CountNonEavesdrop = 0;
            for (int step = 0; step < Steps; step++) {
                System.Console.WriteLine($"STEP-{step}");
                if(SimulateBB84(KeyLength,CheckLength,StepBits,true)){
                    CountEavesdrop++;
                } else {
                    CountNonEavesdrop++;
                }
            }
            System.Console.WriteLine($"Total:{Steps}, Eavesdrop:{CountEavesdrop}, NoEavesdrop:{CountNonEavesdrop}");

            System.Console.WriteLine("Press Enter to continue...\n\n");
            System.Console.ReadLine();
        }
    }
}
