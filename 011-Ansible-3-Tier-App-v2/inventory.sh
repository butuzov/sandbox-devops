#!/usr/bin/env bash

DIR=$(pwd | sed "s/\//\\\\\//g")


echo "[all:vars]"
echo "ansible_connection=ssh"
echo "ansible_host=127.0.0.1"
echo ""

vagrant ssh-config | \
    grep -iE "Host|Port" | \
    grep -ivE "strict|user|name" | \
    sed "s/^  //" | \
    awk '{
	row= ( NR/2 == int(NR/2)) ? NR/2 : int(NR/2)+1;
	if ( array[row] == "" ) {
		array[row] = $2
	} else {
		array[row]= array[row] " " $2
	}
}
END {
	for( i=1; i<= row; i++){
		print(  array[i] )
	}
}
' | \
awk '{
	split( $1, a, /-/)
	if ( groups[a[1]] == "" ){

		if ( a[1] == "ubuntu"){
            printf("\n\n[%s:vars]\n", a[1])
            print("ansible_python_interpreter=/usr/bin/python3\n")
        }


		groups[a[1]] = a[1]
		printf("[%s]", a[1])
	}
    printf "\n%-16s ansible_port=%d", $1, $2
}'
