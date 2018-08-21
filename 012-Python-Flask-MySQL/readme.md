# Making Simple Flask App

```bash
# setup virtualenv
python3 -m pip install --upgrade virtualenv
virtualenv -p python3 venv
source venv/bin/activate
python3 -m pip install -r requirements.txt

# application
chmod +x app/app.py
./app/app.py

# deactivate 
deactivate
rm -rf venv
```
