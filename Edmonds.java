/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package javaapplication5;

import java.util.LinkedList;
import javafx.util.Pair;

/**
 *
 * @author Alexander Mansurov <alexander.mansurov@gmail.com>
 */
public class JavaApplication5 {
    final int V,E;
    int[][] graph;
    int[] edge_count;
    LinkedList<Pair<Integer,Integer>> mapping;
    
    
    public JavaApplication5(int V,int E){
        this.V=V;
        this.E=E;
        graph=new int[V][E];
        edge_count=new int[V];
        mapping = new LinkedList<>();
    }
    
    public enum SearchResult{
        VSC,BLOSSOM,MAX_MAPPING;
    }
    
    int kvet;
    LinkedList<Pair<Integer,Integer>> kytka;
    
    public SearchResult search(int[][] graph,LinkedList<Pair<Integer,Integer>> mapping){
        LinkedList<Integer> queue=new LinkedList<>();
        int wood_vertex_count=0;
        int[] g_vertex_w_vertex_map = new int[V];
        for(int i=0;i<V;i++)
            g_vertex_w_vertex_map[i]=-1;
        int[] w_vertex_lvl=new int[V];
        int[] w_vertex_pred=new int[V];
        for(int i=0;i<V;i++)
           w_vertex_pred[i]=-1;
        
        //najdi volne vrcholy - neni v zadne parovaci hrane
        for(int i=0;i<V;i++){
            queue.addLast(i);
        }
        for(Pair<Integer,Integer> e:mapping){//parovaci hrany
            queue.remove(e.getKey());
            queue.remove(e.getValue());
        }
        //v queue jen volne vrcholy, vlozime do lesa na hladinu 0
        for(int v:queue){
            g_vertex_w_vertex_map[v]=wood_vertex_count;
            w_vertex_lvl[wood_vertex_count]=0;
            wood_vertex_count++;
        }
        while(!queue.isEmpty()){
            int v = queue.pollFirst();
            int h = w_vertex_lvl[g_vertex_w_vertex_map[v]];
            if(h%2==1){
                //y je s v spojen parovaci hranou (existuje prave jeden vrchol y)
                int y=-1;
                for(Pair<Integer,Integer> e:mapping){
                    if(e.getKey()==v){
                      y=e.getValue();
                      break;
                    }else if(e.getValue()==v){
                        y=e.getKey();
                        break;
                    }
                }
                //y in L??
                if(g_vertex_w_vertex_map[y]==-1){
                    queue.addLast(y);
                    g_vertex_w_vertex_map[y]=wood_vertex_count;
                    w_vertex_lvl[wood_vertex_count]=h+1;
                    w_vertex_pred[wood_vertex_count]=v;
                    wood_vertex_count++;
                }else{
                    //najdu cestu z v do korene k1
                    LinkedList<Pair<Integer,Integer>> vsc=new LinkedList<>();
                    int k1=v,x=v;
                    while(w_vertex_pred[g_vertex_w_vertex_map[x]]!=-1){
                        k1=x;
                        x=w_vertex_pred[g_vertex_w_vertex_map[x]];
                        Pair<Integer,Integer> f=new Pair<>(k1,x);
                        vsc.add(f);
                    }
                    //najdu cestu z y dok korene k2
                    int k2=y,z=y;
                    while(w_vertex_pred[g_vertex_w_vertex_map[z]]!=-1){
                        k2=z;
                        z=w_vertex_pred[g_vertex_w_vertex_map[z]];
                        Pair<Integer,Integer> f = new Pair<>(k2,z);
                        vsc.add(f);
                    }
                    //k1=k2 -> kytka
                    //k1!=k2 -> VSC
                    if(k1==k2){
                        kvet=k1;
                        kytka=vsc;
                        return SearchResult.BLOSSOM;
                    }
                    else{
                        //pridej VSC do mapping
                        for(Pair<Integer,Integer> e:vsc){
                            mapping.add(e);
                        }
                        return SearchResult.VSC;
                    }
                }
            }
            else{
                //y mnozina hran dosazitelnych z v po neparovaci hrane
                LinkedList<Integer> Y=new LinkedList<>();
                //vrcholy dosazitelne z v
                int y=-1;
                for(int i=0;i<edge_count[v];i++){
                    Pair<Integer,Integer> e = new Pair(v,i);
                    if(!mapping.contains(e)){
                        Y.add(graph[v][i]);
                        if((g_vertex_w_vertex_map[i]!=-1)&&(w_vertex_lvl[i]%2==0))
                            y=i;
                    }
                }
                if(y!=-1){
                    //existuje vrch. y -> najdu VSC nebo kytku
                    //najdu cestu z v do korene k1
                    int k1=v,x=v;
                    while(w_vertex_pred[g_vertex_w_vertex_map[x]]!=-1){
                        k1=x;
                        x=w_vertex_pred[g_vertex_w_vertex_map[x]];
                    }
                    //najdu cestu z y dok korene k2
                    int k2=y,z=y;
                    while(w_vertex_pred[g_vertex_w_vertex_map[z]]!=-1){
                        k2=z;
                        z=w_vertex_pred[g_vertex_w_vertex_map[z]];
                    }
                    //k1=k2 -> kytka
                    //k1!=k2 -> VSC
                    if(k1==k2){
                        kvet=k1;
                        return SearchResult.BLOSSOM;
                    }
                    else return SearchResult.VSC;
                } else{
                    //kazdy vrchol Y, ktery nepartri do lesa, zarad do fronty a pridej do lesa
                    for(int w:Y){
                        if(g_vertex_w_vertex_map[w]!=-1){
                            queue.addLast(w);
                            g_vertex_w_vertex_map[w]=wood_vertex_count;
                            w_vertex_lvl[wood_vertex_count]=h+1;
                            w_vertex_pred[wood_vertex_count]=g_vertex_w_vertex_map[v];
                            wood_vertex_count++;
                        }
                    }
                }
            }
        }
        return SearchResult.MAX_MAPPING;
    }
    
    public boolean edmonds(int[][] graph,LinkedList<Pair<Integer,Integer>> mapping){
        //zkus najit VSC nebo kytku v (G,M)
        SearchResult sr = search(graph,mapping);
        if(sr.equals(SearchResult.VSC)){
            //mapping se zlepsil v searchi
            return false;
        }else if(sr.equals(SearchResult.BLOSSOM)){
            //kontrahovat kytku do kvetu a Edmonds(novy_graph,nove_mapping);
            for(Pair<Integer,Integer> e:kytka){
                int x = e.getKey();
                int y = e.getValue();
                for(int i=0;i<edge_count[x];i++){
                    //nalezli jsme "hranu"
                    if(graph[x][i]==y){
                        //vsechny nasledujici posunout
                        for(int j=i;j<edge_count[x]-1;j++){
                            graph[x][j]=graph[x][j+1];
                        }
                        //zmensit edge count
                        edge_count[x]--;
                        //break
                        break;
                    }
                }
                for(int i=0;i<edge_count[y];i++){
                    if(graph[y][i]==x){
                        for(int j=i;j<edge_count[y]-1;j++){
                            graph[y][j]=graph[y][j+1];
                        }
                        edge_count[y]--;
                        break;
                    }
                }
            }
            return edmonds(graph,mapping);
        } else{
            //parovani nejlepsi
            return true;
        }
    }
    
    public LinkedList<Pair<Integer,Integer>> maxMapping(int[][] graph){
        LinkedList<Pair<Integer,Integer>> l_mapping=new LinkedList<>();
        while(!edmonds(graph,l_mapping));;
        return l_mapping;
    }
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        
    }
    
}

