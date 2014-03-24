using System;
using System.Collections.Generic;

namespace Application
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

        public static long PrectiLong()
        {
            long citac = 0; bool zapor = false;
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

	class Rozklad
	{
		static void Main (String[] args)
		{
			long cislo = Ctecka.PrectiLong ();
			long konec=(long)Math.Round(Math.Sqrt(cislo));
			while (cislo%2==0) {
				Console.Write("2 ");
				cislo/=2;
			}
			long delitel=3;
			while ((cislo!=1)&(delitel<=konec)) {
				while (cislo%delitel==0){
					Console.Write(delitel+" ");
					cislo/=delitel;
				}
				delitel+=2;
			}
			if(cislo!=1) Console.Write(cislo);
			Console.WriteLine();
		}
	}
}