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
                var res = BB84.Run(sim).Result;
                var (AliceKey, BobKey) = res;
                System.Console.WriteLine($"AliceKey: {AliceKey}");
                System.Console.WriteLine($"BobKey:   {BobKey}");
            }

            System.Console.WriteLine("\n\nPress Enter to continue...\n\n");
            System.Console.ReadLine();
        }
    }
}
