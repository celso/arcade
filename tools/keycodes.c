#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <linux/input.h>

#define FILE_PATH "/dev/input/event0"

int main()
{
	//int file, version;
	size_t file;
	const char *str = FILE_PATH;

	printf("File Path: %s\n", str);

        if((file = open(str, O_RDWR)) < 0)
	{
		printf("ERROR:File can not open\n");
		exit(0);
	}

	struct input_event event[64];

        size_t reader;
        
        while(reader = read(file, event, sizeof(struct input_event) * 64)) {
	  if(event[0].type==1) {
            printf("%d %d %d\n",reader,event[0].code,event[0].value);
	    }
          }

        printf("DO NOT COME HERE...\n");

	close(file);
	return 0;
}
