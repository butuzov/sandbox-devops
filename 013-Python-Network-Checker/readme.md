# TODO: Check network resources using UDP/TCP protocols 

```bash
> ./app.py --help
Usage: app.py [OPTIONS]

Options:
  --cvsfile TEXT   CSV file format (PROTOCOL,HOST,PORT)
  --protocol TEXT  Protocol TCP or UDP
  --port TEXT      Port
  --host TEXT      Hostname or ip
  --help           Show this message and exit.
```


### Start and Run
```bash
# start virtual env
python3 -m pip install --upgrade virtualenv
virtualenv -p python3 venv
source venv/bin/activate
python3 -m pip install -r requirments.txt

# do required task 
# run upd server ./server.py 
# or check hosts...
./server.py &


# deactivate
deactivate && rm -rf venv
```


### Examples
```bash
> ./app.py --cvsfile google.csv
TCP: OK google.com:443
TCP: OK google.ca:443
TCP: OK google.com.ua:443

> ./app.py --protocol UDP --port 9995 --host localhost
UDP: OK localhost:9995
```