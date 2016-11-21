#define __COMPILE__OPPGAVE__2__

/*
Oppgave 1
Specification:
Write an application that :
Asks the user how many integers the user will type in
Allocates memory for the integers
Reads in all the integers
Prints the integers back out
Optional : Prints all the integers sorted

Requirements :
malloc() and free() must be used.You are not allowed to use a pre - allocated array for the values.

Expected output with no numbers :
No numbers were given

Expected output otherwise :
Count: 5
Numbers : 4 2 1 3 5
Sorted : 1 2 3 4 5
*/
#ifdef __COMPILE__OPPGAVE__1__
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int compare(const void *a, const void *b) {
	return *(int*)a > *(int*)b;
}

int main()
{
	int nInts;
	printf("How many integers will you enter?\n");
	int result = scanf("%d", &nInts);
	if (result == 0 || nInts <= 0) {
		printf("No integers were given\n");
		return 0;
	}

	int *integers = (int*)malloc(nInts * sizeof(int));
	for (int i = 0; i < nInts; scanf("%d", &integers[i++]));

	printf("Count: %d\n", nInts);
	printf("Numbers : ");
	for (int i = 0; i < nInts; printf("%d ", integers[i++]));
	printf("\n");

	qsort(integers, nInts, sizeof(int), compare);
	printf("Sorted : ");
	for (int i = 0; i < nInts; printf("%d ", integers[i++]))
		printf("\n");

	free(integers);
	integers = NULL;

	return 0;
}
#endif
#ifdef __COMPILE__OPPGAVE__2__
/*
--------------------------------------------------------
Oppgave 2
Specification :
Write an application that asks for student information(name and age)
until the name given is stop, then :
Prints out how many students that are stored
Prints out all the collected student information
Prints out the name of the youngest student
prints out the name of the oldest student

Requirements :
The student info must be stored in a struct.
malloc(), realloc() and free() must be used.
You are not a allocated array for the student list.
Grow your array by 5 elements when more space is needed.

Expected output with no students :
No students were given

Expected output otherwise :
Count: 3
name = Arne, Age = 23
Name = Lisa, Age = 22
Name = Knut, Age = 24
Youngest : Lisa

Oldest : Knut
*/

#define _CRT_SECURE_NO_WARNINGS // Buhu C4996

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string>

typedef struct {
	char name[20];
	int age;
} Entry;

typedef struct {
	Entry *elements;
	size_t used;
	size_t size;
} Array;

void initArray(Array *a, size_t initialSize) {
	a->elements = (Entry*)malloc(initialSize * sizeof(Entry));
	a->used = 0;
	a->size = initialSize;
}

void insertArray(Array *a, Entry element) {
	if (a->used == a->size) {
		a->size += 5;
		a->elements = (Entry*)realloc(a->elements, a->size * sizeof(Entry));
	}
	a->elements[a->used++] = element;
}

void freeArray(Array *a) {
	free(a->elements);
	a->elements = NULL;
	a->used = a->size = 0;
}

int read_int(void) {
	int i;
	return scanf("%i", &i) == 0 ? -1 : i;
}

void check_oldest(Entry *e, Entry *oldest) {
	if (e->age > oldest->age) {
		*oldest = *e;
	}
}

void check_youngest(Entry *e, Entry *youngest) {
	if (e->age < youngest->age) {
		*youngest = *e;
	}
}

void print_name(Entry *e) {
	printf("Name = %s, Age = %i\n", e->name, e->age);
}

int main()
{
	Array a;
	initArray(&a, 1);

	while (true)
	{
		Entry entry;
		scanf("%10[0-9a-zA-Z ]", entry.name);
		if (!strcmp(entry.name, "stop")) {
			if (a.used == 0) {
				printf("No students were given");
				return 0;
			}
			break;
		}
		
		if((entry.age = read_int()) > 0)
			insertArray(&a, entry);
	}

	Entry youngest = a.elements[a.used - 1];
	for (size_t i = 0; i < a.used; check_youngest(&a.elements[i++], &youngest));

	Entry oldest = a.elements[a.used - 1];
	for (size_t i = 0; i < a.used; check_oldest(&a.elements[i++], &oldest))

	printf("Count: %i\n", a.used);
	for (size_t i = 0; i < a.used; print_name(&a.elements[i++]));
	printf("Youngest: %s\n", youngest.name);
	printf("Oldest: %s\n", oldest.name);
	freeArray(&a);
}
#endif
