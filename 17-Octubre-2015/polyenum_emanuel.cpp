#include <cstdlib>
#include <iostream>
#include <stdio.h>
#include <math.h>

using namespace std;

int H = 2, W = 2;
int size;
int count = 0;
int nodes = 0;

void printConfiguration(unsigned char *matrix, int w, int h);
void print(unsigned char *matrix, int w, int h);
void process(unsigned char *matrix, unsigned char *neighborhood);
void updateConfiguration(unsigned char *matrix, int index, int value);
int checkConfiguration(unsigned char *matrix, int index);
int sumDegrees(unsigned char *matrix, unsigned char *neighborhood, int size);

class Node{
public:
	Node(){ 
		father = NULL;
		right = NULL;
		left = NULL;
		current_index = 0;
		current_size = 0;
		lower = 0;
		upper = 0;
		top_border = false;
		right_border = false;
		left_border = false;
		bottom_border = false;		
	}

	~Node(){}

	void process(unsigned char *matrix, unsigned char *neighborhood){
		nodes++;

		int index = this->current_index;
		int current_size = this->current_size;

		/* verifier que le polyomino soit inscrit */
		if((index-1) == W-1   && !this->top_border) return;         //  verifier top     
		if((index-1) == W*H-W && !this->left_border) return; 	    //  verifier left    
		if((index-1) == W*H-1 && !this->right_border) return;       //  verifier right   
		if((index-1) == W*H-1 && !this->bottom_border) return;	    //  verifier bottom  

		if(checkConfiguration(neighborhood, index-1) == 1) return;

		/* verifier que la configuration soit connexe */
		if(sumDegrees(matrix, neighborhood, index)/2 < current_size - 1) {
			/*printf("%d, %d \n", current_size, sumDegrees(matrix, neighborhood, index)/2 );
			print(matrix,W,H);
			printf("\n\n");*/
			return;
		}			

		/* verifier si le nombre de cellules actuel c'est celui cherché*/
		if(size >= W + H - 1){
			if(current_size  > size) {
				/*printf("%d, %d\n", current_size, current_index );
				print(matrix,W,H);
				printf("\n\n");		*/
				return;
			}	
		    if(current_size + (W * H - current_index) < size) return;
		}

		if(index == W*H) {
		//	printf("%d, %d\n", current_size, sumDegrees(matrix, neighborhood, index)/2);
			if(current_size >= H + W - 1) {
				count ++;
				print(matrix,W,H);
//				printf("--------------\n");
//				print(neighborhood, W, H);
				printf("\n\n");	
			}
			return;
		}

		this->right = new Node();
		this->right->father = this;
		this->right->current_index = index + 1;
		this->right->current_size = current_size;
		matrix[index] = 0;
		this->right->top_border = this->top_border;
		this->right->right_border = this->right_border;
		this->right->left_border = this->left_border;
		this->right->bottom_border = this->bottom_border;
		updateConfiguration(neighborhood, index, -1);		
		this->right->process(matrix, neighborhood);

		this->left = new Node();
		this->left->father = this;
		this->left->current_index = index + 1;
		this->left->current_size = current_size + 1;
		matrix[index] = 1;		
		if(index < W) this->top_border = true;
		if(index % W == 0) this->left_border = true;
		if((index + 1) % W == 0) this->right_border = true;
		if(index >= W*H-W) this->bottom_border = true;
		this->left->top_border = this->top_border;
		this->left->right_border = this->right_border;
		this->left->left_border = this->left_border;
		this->left->bottom_border = this->bottom_border;
		updateConfiguration(neighborhood, index, 1);	
		this->left->process(matrix, neighborhood);

		free(this->left);
		free(this->right);				
	}

	int current_index;
	int current_size;
	int lower, upper;
	int h, w;

	bool top_border;
	bool right_border;
	bool left_border;
	bool bottom_border;

	Node *father;
	Node *right;
	Node *left;
};

int main(int argc, char *argv[]){
	unsigned char *matrix;
	unsigned char *neighborhood;

	if(argc >= 3){
		W = atoi(argv[1]);
		H = atoi(argv[2]);
	} 
	if(argc == 4){
		size = atoi(argv[3]);
	} else size = W + H - 1;

	Node *root = new Node();

	matrix = (unsigned char*)malloc(W*H*sizeof(unsigned char));	
	if(!matrix) { printf("there is not memory for work... \n"); exit(1);	}		
	neighborhood = (unsigned char*)malloc(W*H*sizeof(unsigned char));	
	if(!neighborhood) { printf("there is not memory for work... \n"); exit(1);	}		

	/* begin neighborhood */
	for(int i=0; i<W * H; i++){
		if(i == 0 || i == W-1 || i == W*H-W || i == W*H-1) neighborhood[i] = 2;
		else if(i < W || (i > W*H-W && i < W*H) || (i+1)%W == 0 || i%W == 0) neighborhood[i] = 3;
		else neighborhood[i] = 4;
	}

	root->process(matrix, neighborhood);	
	printf("Polyominos: %d\n", count);

	printf("Nodes: %.4f %%\n", (1.0 * nodes) / (pow(2, W*H+1)) * 100 );

	free(matrix);
	free(neighborhood);
	free(root);
}

void printConfiguration(unsigned char *matrix, int w, int h){
	for(int i=0; i<h*w; i++){
		if(matrix[i] == 1){
			printf("X");
		} else {
			printf(" ");
		}
		if((i+1)%W == 0) printf("\n");
	}
}

void print(unsigned char *matrix, int w, int h){
	for(int i=0; i<h*w; i++){
		printf("%d", matrix[i]);
		if((i+1)%W == 0) printf("\n");
	}
}

void updateConfiguration(unsigned char *matrix, int index, int value){
	if(index == 0){
		matrix[1]+=value;
		matrix[W]+=value;
	} else if (index == W-1){
		matrix[index - 1]+=value;
		matrix[index + W]+=value;
	} else if (index == W*H-W){
		matrix[index + 1]+=value;
		matrix[index - W]+=value;				
	} else if (index == W*H-1){
		matrix[index - 1]+=value;
		matrix[index - W]+=value;
	} else if (index < W-1){
		matrix[index - 1]+=value;
		matrix[index + 1]+=value;
		matrix[index + W]+=value;		
	} else if (index > W*H-W && index < W*H-1){
		matrix[index - 1]+=value;
		matrix[index + 1]+=value;
		matrix[index - W]+=value;
	} else if ((index+1)%W == 0){
		matrix[index - 1]+=value;
		matrix[index - W]+=value;
		matrix[index + W]+=value;
	} else if (index%W == 0){
		matrix[index + 1]+=value;
		matrix[index - W]+=value;
		matrix[index + W]+=value;		
	} else {
		matrix[index + 1]+=value;
		matrix[index - 1]+=value;
		matrix[index + W]+=value;
		matrix[index - W]+=value;				
	}
}

/* verifier s'il y a une cellule isolée */
int checkConfiguration(unsigned char *matrix, int index){
	if (index < 0) return 0;
	if(index == 0){
		if(matrix[1] == 0 || matrix[W] == 0) return 1;
	} else if (index == W-1){
		if(matrix[index - 1] == 0 || matrix[index + W] == 0) return 1;
	} else if (index == W*H-W){
		if(matrix[index + 1] == 0 || matrix[index - W] == 0) return 1;
	} else if (index == W*H-1){
		if(matrix[index - 1] == 0 || matrix[index - W] == 0) return 1;
	} else if (index < W-1){
		if(matrix[index - 1] == 0 || matrix[index + 1] == 0 || matrix[index + W] == 0) return 1;
	} else if (index > W*H-W && index < W*H-1){
		if(matrix[index - 1] == 0 || matrix[index + 1] == 0 || matrix[index - W] == 0) return 1;
	} else if ((index+1)%W == 0){
		if(matrix[index - 1] == 0 || matrix[index - W] == 0 || matrix[index + W] == 0) return 1;		
	} else if (index%W == 0){
		if(matrix[index + 1] == 0 || matrix[index - W] == 0 || matrix[index + W] == 0) return 1;
	} else {
		if(matrix[index + 1] == 0 || matrix[index - 1] == 0 || matrix[index + W] == 0 || matrix[index - W] == 0) return 1;
	}
	return 0;
}

int sumDegrees(unsigned char *matrix, unsigned char *neighborhood, int size){
	int sum = 0;

	for(int i=0; i<size; i++){
		if(matrix[i] != 0)	sum+=neighborhood[i];
	}
	return sum;
}