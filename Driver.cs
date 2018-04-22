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
                var EveKey = "";
                var IsEavesdropper = "WARNING!! There is an eavesdropper.";
                var KeyLength = 20;
                var CheckLength = 1;
                var StepBits = 20;
                while (AliceKey.Length < KeyLength + CheckLength){
                    var res = BB84.Run(sim, StepBits, true).Result;
                    var (AliceReceives, BobReceives, EveReceives) = res;
                    AliceKey = AliceKey + AliceReceives;
                    BobKey = BobKey + BobReceives;
                    EveKey = EveKey + EveReceives;
                }
                var AliceCheckBits = AliceKey.Substring(KeyLength, CheckLength);
                var BobCheckBits = BobKey.Substring(KeyLength, CheckLength);
                if (AliceCheckBits == BobCheckBits) {
                    IsEavesdropper = "There is no eavesdropper.";
                }
                System.Console.WriteLine(IsEavesdropper);
                System.Console.WriteLine($"AliceKey:       {AliceKey.Substring(0,KeyLength)}");
                System.Console.WriteLine($"BobKey:         {BobKey.Substring(0,KeyLength)}");
                System.Console.WriteLine($"EveKey:         {EveKey.Substring(0,KeyLength)}");
                System.Console.WriteLine($"AliceCheckBits: {AliceCheckBits}");
                System.Console.WriteLine($"BobCheckBits:   {BobCheckBits}");
            }

            System.Console.WriteLine("\n\nPress Enter to continue...\n\n");
            System.Console.ReadLine();
        }
    }
}
