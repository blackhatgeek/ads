using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ConsoleApplication1
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

    class Seznam<T>
    {
        private T val;
        Seznam<T> next;

        public Seznam(T value,Seznam<T> next){
            this.val = value;
            this.next = next;
        }

        public T Value
        {
            get
            {
                return this.val;
            }
            set
            {
                this.val = value;
            }
        }

        public Seznam<T> Next
        {
            get
            {
                return this.next;
            }
            set
            {
                this.next = value;
            }
        }

        public Seznam<T> GetPosledni()
        {
            Seznam<T> dalsi=this;
            while (dalsi.Next != null)
            {
                dalsi = dalsi.Next;
            }
            return dalsi;
        }

        public override string ToString()
        {
            String vlak="";
            Seznam<T> s = this;
            if (s.Value != null)
            {
                vlak += s.Value;
                while (s.Next != null)
                {
                    s = s.Next;
                    vlak+="->";
                    if (s.Value != null) vlak +=s.Value;
                }
                vlak +="->#";
            }
            return vlak;
        }

        public void Append(Seznam<T> last)
        {
            Seznam<T> dalsi=this;
            while (dalsi.Next != null)
            {
                dalsi = dalsi.Next;
            }
            dalsi.Next = last;
        }
    }

    class Souradnice:IComparable
    {
        private int x, y;
        public int X
        {
            get
            {
                return this.x;
            }
            set
            {
                this.x = value;
            }
        }
        public int Y
        {
            get
            {
                return this.y;
            }
            set
            {
                this.y = value;
            }
        }
        public Souradnice(int x, int y)
        {
            this.x = x;
            this.y = y;
        }

        public int CompareTo(object obj)
        {
            return (((obj as Souradnice).X == x) && ((obj as Souradnice).Y == y)) ? 1 : 0;
        }

        public int vzdalenost(Souradnice b)
        {
            return Math.Abs(this.X - b.X) + Math.Abs(this.Y - b.Y);
        }

        public override String ToString()
        {
            return "[" + this.x + "," + this.y + "]";
        }
    }

    class Program
    {
        static void Main(string[] args)
        {
            //nacti vstup
            int sirka = Ctecka.PrectiInt();
            int vyska=Ctecka.PrectiInt();
            char znak;
            Dictionary<char,Seznam<Souradnice>> ht=new Dictionary<char,Seznam<Souradnice>>();
            //Console.ReadLine();
            for (int y = 0; y < vyska; y++)
            {
                for (int x = 0; x < sirka; x++)
                {
                    //vkladam do ht seznamy -> pismeno : pozice
                    Seznam<Souradnice> lss,nova=new Seznam<Souradnice>(new Souradnice(x, y), null);
                    znak=(char)Console.Read();
                    if (ht.TryGetValue(znak, out lss))
                    {
                        lss.Append(nova);
                    }
                    else
                    {
                        ht.Add(znak,nova);
                    }
                }
            }
            Console.ReadLine();
            String text = Console.ReadLine();
			//Console.WriteLine (text);
            //hledej
            Souradnice start = new Souradnice(0, 0),cil;
            int delka = 0;
            for (int i = text.Length-1; i>=0; i--)
            {
                int prac = NajdiMin(text[i], start, out cil, ht);
                if (prac != -1)
                {
                    delka += prac+1;
                    start = cil;
                }
            }

            //vypis vystup
            Console.WriteLine(delka);
        }

        //najde minimalni pocet kroku na ceste k zadanemu pismenu ze zadanych souradnic;
        //souradnici pismene vraci v parametru
        static int NajdiMin(char pismeno, Souradnice odkud, out Souradnice kam, Dictionary<char, Seznam<Souradnice>> tabulka)
        {
            kam = odkud;
            Seznam<Souradnice> seznam=null;
            if(tabulka.TryGetValue(pismeno,out seznam)){
               Souradnice s = seznam.Value;
                if (s != null)
                {
                    int min = odkud.vzdalenost(s);
                    kam = s;
                    while (seznam.Next != null)
                    {
                        seznam = seznam.Next;
                        s = seznam.Value;
                        if (s != null)
                        {
                            int vzd = odkud.vzdalenost(s);
                            if (vzd < min)
                            {
                                kam = s;
                                min = vzd;
                            }
                        }
                    }
                    return min;
                }
                else
                {
                    kam = null;
                    return -1;
                }
            }else{
                kam=null;
                return -1;
            }
        }

        
    }
}

