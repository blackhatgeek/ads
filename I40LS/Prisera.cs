using System;

namespace Prisera
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

	class Bludiste{

		int vyska, sirka;
		bool[,] bludiste;//F prekazka, T volno

		public Bludiste (int sirka,int vyska)
		{
			this.vyska=vyska;
			this.sirka=sirka;
			bludiste=new bool[sirka,vyska];//vsude je implicitne volno
		}

		public int getVyska ()
		{
			return this.vyska;
		}

		public int getSirka ()
		{
			return this.sirka;
		}

		bool validniPolicko (int x, int y)
		{
			if ((x>=0) & (x<sirka) & (y>=0) & (y<vyska)) return true;
			else return false;
		}

		public bool jeZed (int x, int y)
		{
			return !(validniPolicko(x,y)&&bludiste[x,y]);
			//pokud neni validni policko, reknu, ze je to zed
		}

		public bool polozPrekazku (int x, int y)
		{
			if (validniPolicko(x,y)) {
				this.bludiste [x, y] = false;
				return true;
			}
			else return false;
		}

		public bool polozVolno (int x, int y)
		{
			if (validniPolicko (x, y)) {
				this.bludiste[x,y]=true;
				return true;
			} else return false;
		}
	}

	enum Smer{
		nahoru, dolu, doprava, doleva
	}

	class Prisera{
		Smer smer;
		int x, y;

		public Prisera(Smer s,int x, int y){
			this.smer=s;
			this.x=x;
			this.y=y;
		}

		public int getX ()
		{
			return this.x;
		}

		public int getY ()
		{
			return this.y;
		}

		public int getXVpravo ()
		{

			switch (this.smer) {
			case Smer.doleva: return this.x;
			case Smer.doprava: return this.x;
			case Smer.nahoru: return this.x+1;
			case Smer.dolu: return this.x-1;
			default: return -1;
			}
		}

		public int getYVpravo ()
		{
			switch (smer) {
			case Smer.nahoru:return this.y;
			case Smer.dolu:return this.y;
			case Smer.doleva: return this.y-1;
			case Smer.doprava: return this.y+1;
			default: return -1;
			}
		}

		public int getXVepredu ()
		{
			switch (this.smer) {
			case Smer.nahoru: return this.x;
			case Smer.dolu:return this.x;
			case Smer.doleva:return this.x-1;
			case Smer.doprava: return this.x+1;
			default: return -1;
			}
		}

		public int getYVepredu ()
		{
			switch (smer) {
			case Smer.doleva:return this.y;
			case Smer.doprava:return this.y;
			case Smer.nahoru: return this.y-1;
			case Smer.dolu: return this.y+1;
			default: return -1;
			}
		}

		public Smer getSmer ()
		{
			return this.smer;
		}

		public void vpred ()
		{
			switch (smer) {
			case Smer.doleva:x--;break;
			case Smer.doprava:x++;break;
			case Smer.nahoru:y--;break;
			case Smer.dolu:y++;break;
			}
		}

		public void otocVlevo ()
		{
			switch (smer) {
			case Smer.nahoru:smer=Smer.doleva;break;
			case Smer.dolu:smer=Smer.doprava;break;
			case Smer.doleva:smer=Smer.dolu;break;
			case Smer.doprava:smer=Smer.nahoru;break;
			}
		}

		public void otocVpravo ()
		{
			switch (smer) {
			case Smer.nahoru:smer=Smer.doprava;break;
			case Smer.dolu:smer=Smer.doleva;break;
			case Smer.doleva:smer=Smer.nahoru;break;
			case Smer.doprava:smer=Smer.dolu;break;
			}
		}
	}

	class IO{
		const char zed='X', volno='.', nahoru='^', dolu='v', doprava='>', doleva='<';

		public static void nactiVstup (out Bludiste b, out Prisera p)
		{
			p=new Prisera(Smer.nahoru,-1,-1);
			int sirka = Ctecka.PrectiInt ();
			int vyska = Ctecka.PrectiInt ();
			b=new Bludiste(sirka,vyska);
			for (int y=0; y<vyska; y++) {
				for (int x=0; x<sirka; x++) {
					//Console.WriteLine("["+x+","+y+"]");
					bool ctiDalsi=false;
					do{
						char z=(char)Console.Read();
						switch (z){
						case zed:
							ctiDalsi=false;
							b.polozPrekazku(x,y);
							break;
						case volno:
							ctiDalsi=false;
							b.polozVolno(x,y);
							break;
						case nahoru:
							ctiDalsi=false;
							b.polozVolno(x,y);
							p=new Prisera(Smer.nahoru,x,y);
							break;
						case dolu:
							ctiDalsi=false;
							b.polozVolno(x,y);
							p=new Prisera(Smer.dolu,x,y);
							break;
						case doprava:
							ctiDalsi=false;
							b.polozVolno(x,y);
							p=new Prisera(Smer.doprava,x,y);
							break;
						case doleva:
							ctiDalsi=false;
							b.polozVolno(x,y);
							p=new Prisera(Smer.doleva,x,y);
							break;
						default:
							ctiDalsi=true;
							break;
						}
					}while(ctiDalsi);
				}
			}
			//vypisVystup(b,p);
		}

		public static void vypisVystup(Bludiste b,Prisera p){
			for (int y=0;y<b.getVyska();y++){
				for(int x=0;x<b.getSirka();x++){
					if (b.jeZed(x,y)) Console.Write(zed);
					else if ((p.getX()==x)&(p.getY()==y))
						switch(p.getSmer()){
						case Smer.nahoru:Console.Write(nahoru);break;
						case Smer.dolu:Console.Write(dolu);break;
						case Smer.doleva:Console.Write(doleva);break;
						case Smer.doprava:Console.Write(doprava);break;
						}
					else Console.Write(volno);
				}
				Console.WriteLine();
			}
			Console.WriteLine();
		}
	}

	class Ovladac{
			Bludiste b;
			Prisera p;

			public Ovladac(Prisera p,Bludiste b){
				this.p=p;
				this.b=b;
			}

			bool maPriseraVpravoZed ()
			{
				return b.jeZed(p.getXVpravo(),p.getYVpravo());
			}

			bool maPriseraPredSebouVolno ()
			{
				return !b.jeZed(p.getXVepredu(),p.getYVepredu());
			}

			void behej ()
			{
				bool bylaVpravoZed=true;
				const int kroku=20;
				for (int krok=0; krok<kroku; krok++) {
					//krok prisery
					if(!bylaVpravoZed){
						bylaVpravoZed=true;
						p.vpred();
					}
					else if(!maPriseraVpravoZed()){
						bylaVpravoZed=false;
						p.otocVpravo();
					}
					else if(maPriseraPredSebouVolno()){
						p.vpred();
					}else{
						p.otocVlevo();
					}

					//vypsat vystup
					IO.vypisVystup(b,p);
				}
			}

		static void Main (String[] args)
		{
			Prisera p;
			Bludiste b;
			IO.nactiVstup (out b, out p);
			Ovladac o=new Ovladac(p,b);
			o.behej();
		}
	}
	
}