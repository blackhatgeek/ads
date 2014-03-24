using System;
using System.Collections.Generic;

namespace PrelevaniVody
{
	class Ctecka
    {
        static bool JeCislice(int znak)
        {
            return ((znak >= '0') && (znak <= '9'));
        }

        static bool JeMinus(int znak)
        { 
            return (znak=='-');
        }

        public static int PrectiInt()
        {
            int citac = 0; bool zapor = false;
            int znak = Console.Read();
            while (!JeCislice(znak)&&!JeMinus(znak)) znak = Console.Read();
            if (JeMinus(znak))
            {
                zapor = true;
                znak = Console.Read();
            }
            while (JeCislice(znak))
            {
                citac = citac * 10 + (znak - '0');
                znak = Console.Read();
            }
            if (zapor) citac = -citac;
            return citac;
        }
    }

	public enum Nadoba{
			A, B, C
	}

	public class Ovladac{
		static int a,b,c,sum;
		static Tabulka tab;
		static Fronta fronta;
		static SeznamStavu sk;

		public static void Main (String[] args)
		{
			Stav pocatek = nactiData ();
			tab=new Tabulka(maxobjem());
			fronta=new Fronta();
			sk=new SeznamStavu(tab,fronta);
			prelevani(pocatek);
			vypisVystup();
		}

		public static int maxobjem ()
		{
			if (b > c) {
				if (a > b)
					return a;
				else
					return b;
			} else {
				if(a>c) return a;
				else return c;
			}
		}

		static int getObjem (Nadoba n)
		{
			switch (n) {
			case Nadoba.A:
				return a;
			case Nadoba.B:
				return b;
			case Nadoba.C:
				return c;
			default: return 0;
			}
		}

		static int getSum ()
		{
			return sum;
		}

		static Stav nactiData(){
			//objemy nadob
			a=Ctecka.PrectiInt();
			b=Ctecka.PrectiInt();
			c=Ctecka.PrectiInt();

			//pocatecni stav
			int x=Ctecka.PrectiInt();
			int y=Ctecka.PrectiInt();
			int z=Ctecka.PrectiInt();
			sum=x+y+z;

			return new Stav(x,y,z);
		}

		static void prelevani (Stav vychozi)
		{
			//init: umim vychozi stav na 0 kroku
			sk.umim (vychozi, 0);
			//vlozim do fronty stavy, do kterych se dostanu z vychoziho stavu
			prelevej (vychozi, 1);
			//dokud neni fronta prazdna, tak vezmu stav z fronty a budu prelevat
			while (!fronta.jePrazdna()) {
				StavKroky stakr=fronta.odeber();
				Stav aktualni=stakr.getStav();
				int krok=stakr.getKroky()+1;
				prelevej(aktualni,krok);
			}

		}

		static void prelevej (Stav stav,int krok)
		{
			//prelit z A do B
			prelej (stav, Nadoba.A, Nadoba.B,krok);
			//prelit z A do C
			prelej (stav, Nadoba.A, Nadoba.C,krok);
			//prelit z B do A
			prelej (stav, Nadoba.B, Nadoba.A,krok);
			//prelit z B do C
			prelej (stav, Nadoba.B, Nadoba.C,krok);
			//prelit z C do A
			prelej (stav, Nadoba.C, Nadoba.A,krok);
			//prelit z C do B
			prelej (stav, Nadoba.C, Nadoba.B,krok);
		}

		static void prelej (Stav stav, Nadoba odkud, Nadoba kam, int krok)
		{
			if (stav.getObsah (odkud) != 0) {
				//je co prelevat
				Stav novy;
				int volno = getObjem (kam) - stav.getObsah (kam);//kolik mam v cilove nadobe k dispozici objemu
				int new_a = stav.getA (), new_b = stav.getB (), new_c = stav.getC ();//konecny stav, na zacatku ekvivalentni vychozimu stavu

				int noveOdkud, noveKam;
				//v nadobe odkud leju je vice vody nez je volny objem cilove nadoby
				if (stav.getObsah (odkud) >= volno) {
					noveOdkud = stav.getObsah (odkud) - volno;
					noveKam = getObjem (kam);
				}
				//obsah nadoby odkud liji se vejde do cilove nadoby
				else {
					noveOdkud = 0;
					noveKam = stav.getObsah(kam) + stav.getObsah (odkud);
					if(noveKam>getObjem(kam)) throw new Exception("ERROR: Pretekla nadoba "+kam+" (objem: "+getObjem(kam)+" novy obsah: "+noveKam);
				}

				//nastavim parametry ciloveho stavu
				switch (odkud) {
				case Nadoba.A:
					new_a = noveOdkud;
					break;
				case Nadoba.B:
					new_b = noveOdkud;
					break;
				case Nadoba.C:
					new_c = noveOdkud;
					break;
				}

				switch (kam) {
				case Nadoba.A:
					new_a = noveKam;
					break;
				case Nadoba.B:
					new_b = noveKam;
					break;
				case Nadoba.C:
					new_c = noveKam;
					break;
				}

				if ((new_a + new_b + new_c) != Ovladac.getSum ()) {
					throw new Exception ("FATAL ERROR: Ztratila se voda! A:" + new_a + " " + " B:" + new_b + " C:" + new_c + " Odkud: " + odkud + " Kam: " + kam+ " Obsah odkud: "+stav.getObsah(odkud)+" Volno: "+volno);
				}
				//vytvorim cilovy stav
				novy = new Stav (new_a, new_b, new_c);
				//oznamim, ze jsem se dostal do daneho stavu
				sk.umim (novy, krok);
			}
		}

		static void vypisVystup(){
			Console.WriteLine(tab);
		}
	}

	public class Stav:IEquatable<Stav>{
		private int a,b,c;
		public Stav (int a, int b, int c)
		{
			this.a=a;
			this.b=b;
			this.c=c;
		}

		public int getA ()
		{
			return this.a;
		}

		public int getB(){
			return this.b;
		}

		public int getC ()
		{
			return this.c;
		}

		public int getObsah (Nadoba n)
		{
			switch (n) {
			case Nadoba.A: return this.a;
			case Nadoba.B: return this.b;
			case Nadoba.C: return this.c;
			default:return -5;
			}
		}

		public override string ToString(){
			return a+"\t"+b+"\t"+c;
		}

		public override int GetHashCode ()
		{
			//chci rad objemu (1, 10, 100, ....)
			int desetNaM=10;
			int maxObjem=Ovladac.maxobjem();
			while ((desetNaM*10)>maxObjem){
				desetNaM*=10;
				//m++;
			}
			return this.a+this.b*desetNaM+this.c*desetNaM*desetNaM;
		}

		public override bool Equals (object obj)
		{
			return Equals(obj as StavKroky);
		}

		public bool Equals (Stav stav)
		{
			if ((stav.getA()==this.a)&&(stav.getB()==this.b)&&(stav.getC()==this.c)) return true;
			else return false;
		}
	}

	public class StavKroky:IEquatable<StavKroky>{

		private Stav stav;
		private int kroky;

		public StavKroky (Stav stav, int kroky)
		{
			this.stav=stav;
			this.kroky=kroky;
		}

		public Stav getStav ()
		{
			return this.stav;
		}

		public int getKroky ()
		{
			return this.kroky;
		}

		public override int GetHashCode(){
			//chci rad objemu (1, 10, 100, ....)
			int m=1; int desetNaM=10;
			int maxObjem=Ovladac.maxobjem();
			while ((desetNaM*10)>maxObjem){
				desetNaM*=10;
				m++;
			}
			m++;
			return kroky+stav.getA()*m+stav.getB()*m*m+stav.getC()*m*m*m;
		}

		public override bool Equals (object obj)
		{
			return Equals(obj as StavKroky);
		}

		public bool Equals (StavKroky stav)
		{
			if (stav.getStav().Equals(this.getStav())&&(stav.getKroky()==this.getKroky())) return true;
			else return false;
		}
	}

	public class Fronta{
		Queue<StavKroky> fronta;

		public Fronta(){
			fronta=new Queue<StavKroky>();
		}

		public void pridej (StavKroky novy)
		{
			fronta.Enqueue(novy);
		}

		public StavKroky odeber(){
			return fronta.Dequeue();
		}

		public bool jePrazdna(){
			return (fronta.Count==0);
		}

		public int pocetPrvku ()
		{
			return fronta.Count;
		}
	}

	public class SeznamStavu{
		Dictionary<Stav,int> seznamStavu;		
		Tabulka tabulka;
		Fronta fronta;

		public SeznamStavu (Tabulka t,Fronta f)
		{
			this.seznamStavu=new Dictionary<Stav, int>();
			this.tabulka=t;
			this.fronta=f;
		}

		public void umim (Stav stav, int kroky)
		{
			bool aktualizace = false;
			//byl jsem jiz v danem stavu?
			if (seznamStavu.ContainsKey (stav)) {
				int umimKroky;
				//za kolik kroku
				seznamStavu.TryGetValue (stav, out umimKroky);
				if (umimKroky > kroky) {
					//umim to lepe - aktualizace
					seznamStavu.Remove (stav);
					seznamStavu.Add (stav, kroky);
					aktualizace = true;
				}
			} else {
				//v danem stavu jsem nebyl, poznamenam si, za kolik kroku jej umim
				seznamStavu.Add (stav, kroky);
				StavKroky sk=new StavKroky(stav, kroky);
				fronta.pridej(sk);
				aktualizace = true;
			}

			if (aktualizace) {
				//vlozit do tabulky, za kolik umim dane hodnoty																																																																																																																																																																																																																																																																																																																																																																																																																																																																												
				tabulka.vloz(stav.getA(),kroky);
				tabulka.vloz(stav.getB(),kroky);
				tabulka.vloz(stav.getC(),kroky);
			}
		}
	}

	public class Tabulka{
		int[] kroky;
		int maxobjem;
		protected const int nedosazitelne=-1;

		public Tabulka (int maxobjem)
		{
			kroky = new int[maxobjem + 1];
			this.maxobjem = maxobjem;
			for (int i=0; i<=maxobjem; i++) {
				kroky[i]=nedosazitelne;
			}
		}

		public void vloz (int objem, int poc_kroku)
		{
			if ((objem >= 0) && (objem <= maxobjem)) {
				if((kroky[objem]>poc_kroku)||(kroky[objem]==nedosazitelne)) kroky[objem]=poc_kroku;																																																																																																																																;
			}
		}

		public int[] getTabulka(){
			return this.kroky;
		}

		public int getMaxObjem(){
			return maxobjem;
		}

		public override string ToString ()
		{
			String vystup="";
			int[] tab=this.getTabulka();
			for(int i=0;i<=this.getMaxObjem();i++){
				if (tab[i]!=nedosazitelne){
					vystup=vystup+i+":"+tab[i]+" ";
				}
			}
			
			return vystup;
		}
	}

}

