#!/usr/bin/env bash
DIR=$(pwd | sed "s/\//\\\\\//g")

echo "[all:vars]"
echo "ansible_connection=ssh"
echo "ansible_user=vagrant"
echo "ansible_host=127.0.0.1"
echo "ansible_ssh_common_args='-o StrictHostKeyChecking=no'"
echo ""

vagrant ssh-config| \
grep -iE "key|host|port" | \
grep -ivE "strict|hosts" | \
sed "s/^  //" | \
sed "s/$DIR\///" | \
awk '{
	row= ( NR/4 == int(NR/4)) ? NR/4 : int(NR/4)+1;
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
sed "s/\"//g" | \
awk '{print $1, "ansible_port="$3, "ansible_private_key_file="$4}' | \
		awk '{
			split( $1, a, /-/)
			if ( groups[a[1]] == "" ){
				groups[a[1]] = a[1]
				printf("\n[%s]\n", a[1])
			}
			print $1, $2, $3
		}'
