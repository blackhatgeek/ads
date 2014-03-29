using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace WindowsFormsApplication1
{
    enum Stav { start, hra, jedna, dve, konec }
    enum Chovani { OtevriZavri,Preklikavani, Schovej }

    public partial class Form1 : Form
    {
        const int pridejKVysce = 30;
        const int rozmerKarticky = 75;
        Chovani chovani = Chovani.OtevriZavri;
        int rozmer = 0;
        Stav stav = Stav.hra;
        int velikost = 6; int karticek;
        int tahy, uspech;
        double uspesnost;
        Button prvni, druhe,v44,v66,v88,konec,nova;
        Label text;
        Button[] tlacitka=null;
        Panel panelTlacitek;
        const string otocena = "PEXESO";
        bool stejne = false;

        public Form1()
        {
            InitializeComponent();
            tahy = 0; uspech = 0;
            UvodniObrazovka();
        }

        void UvodniObrazovka()
        {
            stav = Stav.start;
            statusStrip1.Hide();
            menuStrip1.Hide();

            v44 = new Button();
            v66 = new Button();
            v88 = new Button();

            int bW = Width / 4;
            int bH = Height / 4;
            int k = bH / 8;

            v44.Width = bW;
            v44.Height = bH;
            v44.Top = k;
            v44.Left = (Width-v44.Width)/2;
            v44.Tag = 4;
            v44.Parent = this;
            v44.Text = "4 x 4";
            v44.Click += new EventHandler(Start);

            v66.Width = bW;
            v66.Height = bH;
            v66.Top = v44.Top + v44.Height + k;
            v66.Left = v44.Left;
            v66.Tag = 6;
            v66.Parent = this;
            v66.Text = "6 x 6";
            v66.Click += new EventHandler(Start);

            v88.Width = bW;
            v88.Height = bH;
            v88.Top = v66.Top + v66.Height + k;
            v88.Left = v44.Left;
            v88.Tag = 8;
            v88.Parent = this;
            v88.Text = "8 x 8";
            v88.Click += new EventHandler(Start);
        }
        void VytvorTlacitka() {
            statusStrip1.Show();
            menuStrip1.Show();
            this.panelTlacitek = new Panel();
            panelTlacitek.Width = rozmer;
            panelTlacitek.Height = rozmer;
            panelTlacitek.Parent = this;
            panelTlacitek.Left = 10;
            panelTlacitek.Top = menuStrip1.Height+10;

            karticek=velikost*velikost/2;
            tlacitka = new Button[2*karticek];
            int cislo = 2; 
            int index = 0;
            for (int i = 0; i < velikost; i++)
            {
                for (int j = 0; j < velikost; j++)
                {
                    Button b = new Button();
                    b.Width = rozmerKarticky;
                    b.Height = rozmerKarticky;
                    b.Left = i * b.Width;
                    b.Top = j * b.Height;
                    b.Text = otocena;
                    b.Parent = this;
                    b.Tag = index;
                    cislo++;
                    b.Click += new EventHandler(Klik);
                    panelTlacitek.Controls.Add(b);
                    tlacitka[index] = b;
                    index++;
                }
            }
            Zamichej();
            toolStripProgressBar1.Minimum = 0;
            toolStripProgressBar1.Maximum = velikost * velikost / 2;
            toolStripProgressBar1.Step = 1;
            Height += toolStripProgressBar1.Height+10;
            AktualizaceStavovehoRadku();
        }
        void Zamichej()
        {
            //rozdelit tlacitka do dvou mnozin
            Random random = new Random();
            List<int> pouziteIndexy=new List<int>();
            Button[] T1 = new Button[karticek];
            Button[] T2 = new Button[karticek];
            int i = 0;
            while (i < karticek)
            {
                int index=random.Next(2*karticek);
                if (!pouziteIndexy.Contains(index))
                {
                    pouziteIndexy.Add(index);
                    T1[i] = tlacitka[index];
                    i++;
                }
            }

            random = new Random();
            i = 0;
            while (i < karticek)
            {
                int index = random.Next(2*karticek);
                if (!pouziteIndexy.Contains(index))
                {
                    pouziteIndexy.Add(index);
                    T2[i] = tlacitka[index];
                    i++;
                }
            }

            //kazde mnozine tlacitek priradit permutaci karticek
            int[] permutace = new int[karticek];
            pouziteIndexy.Clear();
            i = 0;
            random = new Random();
            while (i < karticek)
            {
                int index = random.Next(karticek);
                if (!pouziteIndexy.Contains(index))
                {
                    pouziteIndexy.Add(index);
                    permutace[i] = index;
                    i++;
                }
            }

            for (i = 0; i < karticek; i++)
            {
                T1[i].Tag=permutace[i];
                T2[i].Tag=permutace[i];
            }

        }
        void AktualizaceStavovehoRadku()
        {
            int neodhaleneKarticky=karticek-uspech;
            toolStripProgressBar1.Value=uspech;         
            if (tahy != 0)uspesnost = (Double)uspech / (Double)tahy*(Double)100;
            else uspesnost = 0.0;
            toolStripStatusLabel1.Text = "Tahů: " + tahy + " Úspěch:"+Math.Round(uspesnost)+"% Průběh hry:";
            if (neodhaleneKarticky == 0) Konec();
        }
        void Klik(object Sender,EventArgs e)
        {
            switch (stav)
            {
                case Stav.hra://vsechny karticky maji skryte hodnoty nebo nejsou enabled
                    stav = Stav.jedna;
                    prvni = Sender as Button;
                    prvni.Text = prvni.Tag.ToString();
                    AktualizaceStavovehoRadku();
                    break;
                case Stav.jedna://jedna karticka je otocena
                    if (!Sender.Equals(prvni))
                    {
                        Vyhodnot(Sender as Button);
                    }
                    break;
                case Stav.dve://dve karticky otocene
                    /*dve ruzne otocene karticky - kliknutim na druhou se druha otoci
                     *podle Chovani:
                     *Chovani.OtevriZavri - kliknutim na druhou se druha otoci, na klik na jinou karticku se nereaguje
                     *Chovani.Preklikavani - kliknutim na druhou se druha otoci, kliknutim na jinou karticku se otoci druha a kliknuta
                     *Chovani.Schovej - kliknutim na libovolnou karticku se prvni a druha otoci, popr. jeste otoci nova
                     */
                    if ((chovani.Equals(Chovani.OtevriZavri)|chovani.Equals(Chovani.Preklikavani))&!stejne & ((Button)Sender).Equals(druhe))
                    {
                        druhe.Text = otocena;
                        druhe = null;
                        stav = Stav.jedna;
                    }
                    else if (chovani.Equals(Chovani.Preklikavani) & !((Button)Sender).Equals(druhe)&!((Button)Sender).Equals(prvni))
                    {
                        druhe.Text = otocena;
                        Vyhodnot(Sender as Button);                    
                    }
                    else if (chovani.Equals(Chovani.Schovej))
                    {
                        prvni.Text = otocena;
                        druhe.Text = otocena;
                        prvni = null;
                        druhe = null;
                        stav = Stav.hra;
                    }
                    break;
            }
        }

        void Vyhodnot(Button b2)
        {
            tahy++;
            druhe = b2 as Button;
            druhe.Text = druhe.Tag.ToString();
            if (prvni.Tag.Equals(druhe.Tag))
            {
                stav = Stav.hra;
                stejne = true;
                prvni.Enabled = false;
                druhe.Enabled = false;
                uspech++;
            }
            else
            {
                stav = Stav.dve;
                stejne = false;
            }
            AktualizaceStavovehoRadku();
        }

        void Start(object Sender, EventArgs e)
        {
            stav = Stav.hra;
            velikost = (int)((Button)Sender).Tag;

            switch(velikost){
                case 4: rozmer = 350; break;
                case 6: rozmer = 500; break;
                case 8: rozmer = 650; break;
            }
            Width = rozmer;
            Height = rozmer + pridejKVysce;

            v44.Dispose();
            v66.Dispose();
            v88.Dispose();
            VytvorTlacitka();
        }

        void Konec()
        {
            text = new Label();
            text.Text = "Dohral jste hru na "+toolStripProgressBar1.Value/velikost/velikost*2+" % za "+tahy+" tahu\nVase uspesnost byla "+uspesnost+"%";
            text.Parent = this;
            text.Top = 0;
            text.Left = 0;
            text.AutoSize = true;

            konec = new Button();
            konec.Text = "Konec";
            konec.Parent = this;
            konec.Top = 50;
            konec.Left = 0;
            konec.Click += new EventHandler(Vypinac);

            nova = new Button();
            nova.Text = "Nova hra";
            nova.Parent = this;
            nova.Top = 50;
            nova.Left = 100;
            nova.Click += new EventHandler(NovaHra);
        }

        void Vypinac(object sender, EventArgs e)
        {
            Application.Exit();
        }
        void NovaHra(object sender, EventArgs e)
        {
            text.Dispose();
            konec.Dispose();
            nova.Dispose();
            tahy = 0; uspech = 0;
            UvodniObrazovka();
        }

        //Polozky horniho menu
        private void nováToolStripMenuItem_Click(object sender, EventArgs e)
        {
            //nova hra:
            for (int i = 0; i < 2*karticek; i++)
            {
                tlacitka[i].Dispose();
            }
            panelTlacitek.Dispose();
            tahy = 0; uspech = 0;
            UvodniObrazovka();
        }

        private void konecToolStripMenuItem_Click(object sender, EventArgs e)
        {
            //konec hry:
            for (int i = 0; i < 2 * karticek; i++)
            {
                tlacitka[i].Dispose();
            }
            panelTlacitek.Dispose();
            menuStrip1.Hide();
            statusStrip1.Hide();
            Konec();
        }

        private void kartičkyToolStripMenuItem_Click(object sender, EventArgs e)
        {
            //chovani karticek - otevri a zavri (default)
            chovani = Chovani.OtevriZavri;
        }

        private void překlikáváníToolStripMenuItem1_Click(object sender, EventArgs e)
        {
            //chovani karticek - preklikavani
            chovani = Chovani.Preklikavani;
        }

        private void schovejVšeToolStripMenuItem1_Click(object sender, EventArgs e)
        {
            //chovani karticek - schovej vse
            chovani = Chovani.Schovej;
        }

        private void oProgramuToolStripMenuItem_Click(object sender, EventArgs e)
        {
            //napoveda - o programu
        }
    }
}
