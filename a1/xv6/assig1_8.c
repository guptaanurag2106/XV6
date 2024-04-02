#include "types.h"
#include "stat.h"
#include "user.h"

#define MAX_PROCESSES   9 // 1 parent 8 children
#define MSG_SIZE 8
#define CHILD_START   1

void print_sum(int xx){
	printf(1, "Sum of array for file arr is %d\n", xx);

}

void print_variance(float xx){
	int beg=(int)(xx);
	int fin=(int)(xx*100)-beg*100;
	printf(1, "Variance of array for the file arr is %d.%d\n", beg, fin);
}

// int to string
void itoa(int num, char* str){
	// If the number is 0, set the first character of the string to '0' and null terminate the string
	if (num == 0){
		str[0] = '0';
		str[1] = '\x0';
		return;
	}

	int i = 0;
	int temp = num;
	// Count the number of digits in the number
	while (temp > 0){
		temp /= 10;
		i++;
	}
	str[i] = '\x0'; // Null teminate the string
	// Convert each digit of the number to a character and store it in the string in reverse order
	while (num > 0){
		str[--i] = num % 10 + '0';
		num /= 10;
	}
}

// int atoi(char* str){
// 	int num = 0;
// 	int i = 0;
// 	while (str[i] != '\x0'){
// 		num = num * 10 + (str[i] - '0');
// 		i++;
// 	}
// 	return num;
// }

// void coordinator(int *array, int numProcesses) {
//   int totalSum =   0;
//   for (int i =   0; i < numProcesses; i++) {
//     int partialSum;
//     recv(&partialSum);
//     totalSum += partialSum;
//   }
//   printf(1, "Final Sum: %d\n", totalSum);
// }

// void worker(int *array, int start, int end) {
//   int partialSum =   0;
//   for (int i = start; i <= end; i++) {
//     partialSum += array[i];
//   }
//   send(COORDINATOR_PID, &partialSum);
// }

int calc_sum(short* arr, int size){
	const int COORDINATOR_PID = getpid();
	int final_sum = 0;
	int chunk_size = size/(MAX_PROCESSES - 1);
	int child_id = 0; // to distinguish between the children, to assign them chunks
	int final_child_pcount = 0;
	int pid; // for forking

	for (int i = 1; i< MAX_PROCESSES; i++){
		child_id = i;
		pid = fork();
		if (pid == 0){
			// this is child;
			break;
		}else if (pid > 0){
			// this is parent
			final_child_pcount ++;
			child_id = 0;
		}
	}

	if (pid == 0){
		// this is common for all children
		int start = (child_id - 1) * chunk_size;
		int end = ( start + chunk_size - 1 ) > size - 1 ? size - 1 : ( start + chunk_size - 1 );
		int partial_sum = 0;
		for (int i = start; i <= end; i++){
			partial_sum += arr[i];
		}
		char* msg = (char*)malloc(MSG_SIZE);
		itoa(partial_sum, msg);
		send(getpid(), COORDINATOR_PID, msg);
		exit();
	}else{
		for (int i=1; i< MAX_PROCESSES; i++){
			char* partial_sum = (char*)malloc(MSG_SIZE);
			int stat = -1;
			while(stat == -1){
				stat = recv(partial_sum);
			}
			final_sum += atoi(partial_sum);
			free(partial_sum);
		}
	}

	for (int i=1; i<MAX_PROCESSES; i++){
		wait();
	}

	return final_sum;
}

float calc_variance(int sum, short* arr, int size){
	const int COORDINATOR_PID = getpid();
	float final_variance = 0.0;
	int chunk_size = size/(MAX_PROCESSES - 1);
	int child_id = 0; // to distinguish between the children, to assign them chunks
	int final_child_pcount = 0;
	int pid; // for forking
	int pids[MAX_PROCESSES - 1] = {0};

	for (int i = 1; i< MAX_PROCESSES; i++){
		child_id = i;
		pid = fork();
		if (pid == 0){
			// this is child;
			break;
		}else if (pid > 0){
			// this is parent
			final_child_pcount ++;
			child_id = 0;
			pids[i-1] = pid;
		}
	}

	if (pid == 0){
		char* mean_msg = (char *)malloc(MSG_SIZE);
		int stat = -1;
		while(stat == -1){
			stat = recv(mean_msg);
		}
		float mean = 1.0 * atoi(mean_msg);
		// printf(1, "mean recv is %d\n", (int)mean);
		// this is common for all children
		int start = (child_id - 1) * chunk_size;
		int end = ( start + chunk_size - 1 ) > size - 1 ? size - 1 : ( start + chunk_size - 1 );
		float partial_sum = 0.0;
		for (int i = start; i <= end; i++){
			partial_sum += (100.0*arr[i] - mean)*(100.0*arr[i] - mean);
		}
		int partial_sum_round = (int)(partial_sum);
		char* msg = (char*)malloc(MSG_SIZE);
		itoa(partial_sum_round, msg);
		send(getpid(), COORDINATOR_PID, msg);
		// printf(1, "child sent %s\n", msg);
		// free(msg);
		exit();
	}else{
		char* msg = (char*)malloc(MSG_SIZE);
		float mean = 1.0 * sum/size;
		int mean_round = (int)(mean*100.0);
		itoa(mean_round, msg);
		send_multi(COORDINATOR_PID, pids, msg);

		for (int i=1; i< MAX_PROCESSES; i++){
			char* partial_sum_round = (char*)malloc(MSG_SIZE);
			int stat = -1;
			while(stat == -1){
				stat = recv(partial_sum_round);
			}
			final_variance += atoi(partial_sum_round)/10000.0;
			free(partial_sum_round);
		}
	}

	for (int i=1; i<MAX_PROCESSES; i++){
		wait();
	}

	return final_variance / size;	
}

int
main(int argc, char *argv[])
{
	if(argc< 2){
		printf(1,"Need type and input filename\n");
		exit();
	}
	char *filename;
	filename=argv[2];
	int type = atoi(argv[1]);
	printf(1,"Type is %d and filename is %s\n",type, filename);

	int tot_sum = 0;

	int size=1000;
	short arr[size];
	char c;
	int fd = open(filename, 0);
	for(int i=0; i<size; i++){
		read(fd, &c, 1);
		arr[i]=c-'0';
		read(fd, &c, 1);
	}	
  	close(fd);
  	// this is to supress warning
  	printf(1,"first elem %d\n", arr[0]);

  	//----FILL THE CODE HERE for unicast sum

	if(type==0){ //unicast sum
		// int pid = fork();
		// if(pid == 0) {
			tot_sum = calc_sum(arr, size);
			// printf(1,"Sum of array for file %s is %d\n", filename,tot_sum);
			print_sum(tot_sum);
			exit();
		// }
	} else if(type == 1) {
		// int pid = fork();
		// if(pid == 0) {
			tot_sum = calc_sum(arr, size);
			float variance = calc_variance(tot_sum, arr, size);
			print_variance(variance);
			exit();
		// }
	}
	// wait();
	exit();
}