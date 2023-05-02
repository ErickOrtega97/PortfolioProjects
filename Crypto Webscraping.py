#!/usr/bin/env python
# coding: utf-8

# In[13]:


from requests import Request, Session
from requests.exceptions import ConnectionError, Timeout, TooManyRedirects
import json

url = 'https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest'
parameters = {
  'start':'1',
  'limit':'15',
  'convert':'USD'
}
headers = {
  'Accepts': 'application/json',
  'X-CMC_PRO_API_KEY': 'f61cf376-2625-4354-881e-5dd66c355fbf',
}

session = Session()
session.headers.update(headers)

try:
  response = session.get(url, params=parameters)
  data = json.loads(response.text)
  print(data)
except (ConnectionError, Timeout, TooManyRedirects) as e:
    print(e)


# In[56]:


import pandas as pd

#shows all available columns
pd.set_option('display.max_columns', None)
pd.set_option('display.max_rows', None)

df = pd.json_normalize(data['data'])

df['timestamp'] = pd.Timestamp('now')
df


# In[53]:


def api_runner():

    global df
    url = 'https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest'
    parameters = {
      'start':'1',
      'limit':'15',
      'convert':'USD'
    }
    headers = {
      'Accepts': 'application/json',
      'X-CMC_PRO_API_KEY': 'f61cf376-2625-4354-881e-5dd66c355fbf',
    }

    session = Session()
    session.headers.update(headers)
    
    try:
      response = session.get(url, params=parameters)
      data = json.loads(response.text)
      print(data)
    except (ConnectionError, Timeout, TooManyRedirects) as e:
          print(e)
    
    
    df = pd.json_normalize(data['data'])
    df['timestamp'] = pd.Timestamp('now')
    df

    if not os.path.isfile(r'C:/Users/erick/Documents/Python Scripts/API.csv'):
        df.to_csv(r'C:/Users/erick/Documents/Python Scripts/API.csv', header='column_names')
    else:
        df.to_csv(r'C:/Users/erick/Documents/Python Scripts/API.csv', mode='a', header=False)



# In[27]:


import os
from time import time
from time import sleep

for i in range(200):
    api_runner()
    print('API Runner successful')
    sleep(60)
exit()


# In[57]:


df


# In[29]:






# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:




