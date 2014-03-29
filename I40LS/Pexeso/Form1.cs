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

    public partial class Form1 : Form
    {
        Stav stav = Stav.hra;
        int velikost = 6; int karticek;
        int tahy, uspech;
        Button prvni, druhe,v44,v66,v88;
        Button[] tlacitka=null;
        Panel panelTlacitek;
        const string otocena = "PEXESO";
        bool stejne = false;

        public Form1()
        {
            InitializeComponent();
            tahy = 0; uspech = 0;
            //VytvorTlacitka();
            UvodniObrazovka();
        }

        void UvodniObrazovka()
        {
            stav = Stav.start;
            statusStrip1.Hide();
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
            this.panelTlacitek = new Panel();
            panelTlacitek.Width = Width/10*9-10;
            panelTlacitek.Height = Height/10*9-10;
            panelTlacitek.Parent = this;
            panelTlacitek.Left = 10;
            panelTlacitek.Top = 10;

            karticek=velikost*velikost/2;
            tlacitka = new Button[2*karticek];
            int cislo = 2; 
            int index = 0;
            for (int i = 0; i < velikost; i++)
            {
                for (int j = 0; j < velikost; j++)
                {
                    Button b = new Button();
                    b.Width = (panelTlacitek.Width) / velikost;
                    b.Height = (panelTlacitek.Width) / velikost;
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
            Height += toolStripProgressBar1.Height+10;
            AktualizaceStavovehoRadku();
            
            //Width=Width+10;
            //Height=Height+10;
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
            double uspesnost;
            if (tahy != 0)uspesnost = (Double)uspech / (Double)tahy*(Double)100;
            else uspesnost = 0.0;
            toolStripStatusLabel1.Text = "Tahu: " + tahy + " Uspech:"+Math.Round(uspesnost)+"% Prubeh hry:";
            if (neodhaleneKarticky == 0) MessageBox.Show("Konec hry");
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
                        tahy++;
                        druhe = Sender as Button;
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
                    break;
                case Stav.dve://dve karticky otocene
                    //dve stejne otocene karticky - kliknutim na jednu se obe otoci
                    //dve ruzne otocene karticky - kliknutim na druhou se druha otoci
                    if (stejne & (((Button)Sender).Equals(prvni) || ((Button)Sender).Equals(druhe)))
                    {
                        prvni.Text = otocena;
                        druhe.Text = otocena;
                        prvni = null;
                        druhe = null;
                        stav = Stav.hra;
                        
                    }
                    else if (!stejne & ((Button)Sender).Equals(druhe))
                    {
                        druhe.Text = otocena;
                        druhe = null;
                        stav = Stav.jedna;
                    }
                    break;
                default: MessageBox.Show("Chyba");break;
            }
        }

        void Start(object Sender, EventArgs e)
        {
            stav = Stav.hra;
            velikost = (int)((Button)Sender).Tag;
            v44.Dispose();
            v66.Dispose();
            v88.Dispose();
            VytvorTlacitka();
        }
    }
}
