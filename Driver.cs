using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;

namespace BB84Simulation
{
    class Driver
    {
        static void Main(string[] args)
        {
            using (var sim = new QuantumSimulator())
            {
                var AliceKey = "";
                var BobKey = "";
                var IsEavesdropper = "There is an eavesdropper.";
                var KeyLength = 20;
                var CheckLength = 10;
                var StepBits = 20;
                while (AliceKey.Length < KeyLength + CheckLength){
                    var res = BB84.Run(sim, StepBits).Result;
                    var (AliceReceives, BobReceives) = res;
                    AliceKey = AliceKey + AliceReceives;
                    BobKey = BobKey + BobReceives;
                }
                var AliceCheckBits = AliceKey.Substring(KeyLength);
                var BobCheckBits = BobKey.Substring(KeyLength);
                if (AliceCheckBits == BobCheckBits) {
                    IsEavesdropper = "There is no eavesdropper.";
                }
                System.Console.WriteLine(IsEavesdropper);
                System.Console.WriteLine($"AliceKey:       {AliceKey.Substring(0,KeyLength)}");
                System.Console.WriteLine($"BobKey:         {BobKey.Substring(0,KeyLength)}");
                System.Console.WriteLine($"AliceCheckBits: {AliceCheckBits}");
                System.Console.WriteLine($"BobCheckBits:   {BobCheckBits}");
            }

            System.Console.WriteLine("\n\nPress Enter to continue...\n\n");
            System.Console.ReadLine();
        }
    }
}
