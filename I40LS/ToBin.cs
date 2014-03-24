using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace PrevodDoBinarky
{
    class Ctecka
    {
        static bool jeCislice(int znak)
        {
            return ((znak >= '0') && (znak <= '9'));
        }

        static bool jeMinus(int znak)
        { 
            return (znak=='-');
        }

        public static int PrectiInt()
        {
            int citac = 0; bool zapor = false;
            int znak = Console.Read();
            while (!jeCislice(znak)&&!jeMinus(znak)) znak = Console.Read();
            if (jeMinus(znak))
            {
                zapor = true;
                znak = Console.Read();
            }
            while (jeCislice(znak))
            {
                citac = citac * 10 + (znak - '0');
                znak = Console.Read();
            }
            if (zapor) citac = -citac;
            return citac;
        }
    }

    class ToBin
    {
        static void Main(string[] args)
        {
            int[] bincislo=new int[16];
            int i=0;
            int cislo = Ctecka.PrectiInt();
            while((cislo!=0)){
                bincislo[i] = cislo % 2;
                i++;
                cislo = cislo / 2;
            }
            long binvystup=0;
            for(int j=i;j>=0;j--){
                binvystup=binvystup*10+bincislo[j];
            }
		Console.WriteLine(binvystup);
        }
    }
}
