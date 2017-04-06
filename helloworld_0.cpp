/*
  It's just my kind of hello world. Written in february 2009, excuse my code.
    
  It should hopefully converge in the result of "Hello World!". It's basically
  a genetic algorithm that will generate a population of random strings and use
  the entropy to evolve and mutate to the desired state. The fitness function is described by 
  the levenshtein distance from the state.
  
    Generation 0 Best cromosome with fitness 165, Urgtm4g\dS]8
    Generation 1 Best cromosome with fitness 146, iYjfp,?jpZd@
    Generation 2 Best cromosome with fitness 107, CidFj!_xgke1
    ...
    Generation 31 Best cromosome with fitness 3, Hdllo Workd"
    Generation 34 Best cromosome with fitness 3, Hdllo Xorkd!
    ...
    Generation 41 Best cromosome with fitness 0, Hello World!
*/

#include <iostream>
#include <string>
#include <vector>
#include <algorithm>
#include <time.h>
#include <math.h>

using namespace std;
std::string target = std::string( "Hello World!" );

#define MUTATION_RATE RAND_MAX * 0.25f
#define POPSIZE 2048
#define MAXGEN 1024

struct cromosome {
    string text;
    unsigned int fit;
};
typedef vector<cromosome> population;

void create_population( population &pop, unsigned int size )
{
    unsigned int tsize = target.size();
    for( unsigned int i=0; i<size; i++ )
    {
        cromosome node;
        node.fit = 0;
        for( unsigned int j=0; j<tsize; j++ )
            node.text += (rand()%90)+32;
        pop.push_back( node );
    }
}

void calc_fitness( population &pop )
{
    unsigned int fit, psize = pop.size(), tsize = target.size();
    for( unsigned int i=0; i<psize; i++ )
    {
        fit = 0;
        for( unsigned int j=0; j<tsize; j++ )
            fit += abs( pop[i].text[j] - target[j] );
        pop[i].fit = fit;
    }
}

bool cmp_cromosomes( cromosome a, cromosome b )
{
    return (a.fit < b.fit );
}

inline void sort_population_by_fitness( population &pop )
{
    sort( pop.begin(), pop.end(), cmp_cromosomes );
}

void print_population( population &pop )
{
    cout << "- Printing population -" << endl;

    population::iterator i;
    for( i=pop.begin(); i != pop.end(); i++ )
    {
        if( !i->text.compare("") )
            continue;

        cout << "Fitness: " << i->fit << " Text: " << i->text << endl;
    }
}

population survival_of_the_fittest( population &pop, unsigned int limit )
{
    population survivors( pop.size() );
    for( unsigned int i=0; i<limit; i++ )
        survivors[i] = pop[i];
    return survivors;
}

void print_best_cromosome( population &pop )
{
    cout << "Best cromosome with fitness " << pop[0].fit << ", " << pop[0].text << endl;
}

cromosome mate( cromosome &a, cromosome &b, unsigned int xover, unsigned int tsize )
{
    cromosome offspring;
    offspring.text = a.text.substr( 0, xover ) + b.text.substr( xover, tsize - xover );

    return offspring;
}

void mutate( cromosome &a )
{
    int mpos = rand() % a.text.size();
    a.text[mpos] = ((a.text[mpos] + ((rand()%90)+32)) % 122 );
}

void advance_population( population &pop )
{
    unsigned int p1, p2, tsize = target.size(), psize = pop.size(), esize = psize * 0.1;

    population new_generation = survival_of_the_fittest( pop, esize );

    for( unsigned int i=esize; i<psize; i++ )
    {
        p1 = rand() % (psize/2);
        p2 = rand() % (psize/2);

        new_generation[i] = mate( pop[p1], pop[p2], rand() % tsize + 1, tsize );
        if( rand() < MUTATION_RATE )
            mutate( new_generation[i] );
    }
    pop = new_generation;
}

int main()
{
    int silent = 0;
    srand( unsigned(time(NULL)) );

    population pop;
    create_population( pop, POPSIZE );

    for( unsigned int i=0; i<MAXGEN; i++ )
    {
        calc_fitness( pop );
        sort_population_by_fitness( pop );

        if( !silent )
        {
            cout << "Generation " << i << " ";
            print_best_cromosome( pop );
        }

        if( pop[0].fit == 0 )
            break;

        advance_population( pop );
    }
    return 0;
}
