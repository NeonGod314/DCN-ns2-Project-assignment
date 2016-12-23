BEGIN 	{
	count = 0;
	}

{
if($1 == "d")
	count++;
}

END	{
	printf("No.of dropped packets= %d \n", count);

	}
