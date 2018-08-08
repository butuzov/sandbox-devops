# Working with DNS

### Goal
`Do some basic DNS setup (master <-> slave)`

### Starting Up and Teest

```bash
# Start it up and checkout provision output.
vagrant up

# you also can do:

vagrant ssh master
[vagrant@master] > dig vanilla.com
[vagrant@master] > exit

vagrant ssh puppet
[vagrant@master] > dig vanilla.com
[vagrant@master] > exit
```
