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
        Button prvni, druhe;
        Button[] tlacitka=null;
        Panel panelTlacitek;
        const string otocena = "PEXESO";
        bool stejne = false;

        public Form1()
        {
            InitializeComponent();
            tahy = 0; uspech = 0;
            VytvorTlacitka();
        }

        void VytvorTlacitka() {
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
                case Stav.hra:
                    stav = Stav.jedna;
                    prvni = Sender as Button;
                    prvni.Text = prvni.Tag.ToString();
                    AktualizaceStavovehoRadku();
                    break;
                case Stav.jedna:
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
                case Stav.dve:
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
    }
}
