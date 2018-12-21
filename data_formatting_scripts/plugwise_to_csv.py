
# coding: utf-8

# # Plugwise data converter
# 
# This script has been written to convert the logged consumption data from the Plugwise Circle to the preferred structure for NILM-Eval (https://github.com/beckel/nilm-eval). 
# The data has been received from the Plugwise-2-py MQTT messages in Node-Red and saved in CSV files.
# 
# Input: CSV-files from the Plugwise-2-py setup on the raspberry pi.
#     By default, the files are saved to /home/pi/logging/plugs/ with the filename <numberOfPlug.csv>. 
#     Example: /home/pi/logging/plugs/01.csv
#     
#     The file contains the columns: MAC-address, Timestamp, Power usage. 
# 
# Output: 1 CSV-file per day with the plug's consumption with the columns: Second of the day, Consumption.
# 
# TODO: 
# - Change plotting so that it also plots the missing values in data. Now it only prints the data available and some days where data is missing will hence have a compressed x-axis. This missing data is smoothed in the Matlab-script so by plotting the data from there is best at the moment. 
# - Change script so that it iterates through available households. At the moment it only works with one, the one set by the variable "household." 

# ## Removing unwanted colums

# In[1]:

import csv
import pandas as pd
import datetime
import time
from pylab import *
import os
import matplotlib.pyplot as plt


# Setting variables  
household = '01'
appliances = {
'01':'Electric heater Andre',
'02':'Water Heater',
'03':'Oven',
'04':'TV',
'05':'Coffee Maker',
'06':'Electric kettle',
'07':'Electric heater salong',
'08':'Microwave oven',
'09':'Electric heater terrace',
'10':'Dishwasher',
'11':'Refrigerator',
'12':'Washing machine'}
current_directory = os.getcwd()
mpl.rcParams['agg.path.chunksize'] = 10000
plt.rcParams["figure.dpi"] = 600
plt.rcParams.update({'font.size': 22})


for plug in appliances:
    print('*Starting work on %s - %s' %(plug, appliances[plug]))
    plugnumber = plug
    
    # Import the plug CSVs
    print('\t Importing CSV...')
    
    try:
        df = pd.read_csv('data/rawdata/plugs/'+ plug + '.csv', header=None)
        print('\t Import ok')
    except : 
        print('Did not find file %s.csv, this plug will be excluded' %plug)
        continue

    # Renaming columns
    df.columns = ['mac', 'time', 'power']

    # Saving the plug's mac
    mac = df.at[1,'mac']

    # Removing possible duplicates in the data
    df = df[~df.time.duplicated()]

    # Removing negative-valued noise in data
    df.power[df.power < 0] = 0

    # Making new columns for date and time
    df['year'] = df['time'].str.slice(0,4)
    df['month'] = df['time'].str.slice(5,7)
    df['day'] = df['time'].str.slice(8,10)
    df['time_of_day'] = df['time'].str.slice(11,16) 

    # Adding seconds count
    for index, row in df.iterrows():
        timestamp = row['time']
        time_reduced = timestamp[-8:]
        x = time.strptime(time_reduced.split(',')[0],'%H:%M:%S')
        second = datetime.timedelta(hours=x.tm_hour,minutes=x.tm_min,seconds=x.tm_sec).total_seconds()
        df.set_value(index,'second',second)

    # Finding unique days
    unique_years = df.year.unique()
    unique_months = df.month.unique()
    unique_days = df.day.unique()

    print('\t\t Unique years: %s, months: %s, days: %s' %(unique_years, unique_months, unique_days))
    print('\t\t Staring day iteration for: %s' %appliances[plugnumber])
    for year in unique_years:
        for month in unique_months:
            for day in unique_days:
                print('\t\t\t Working on day %s' %day)

                df_temp = df.loc[(df['day'] == day)] # Locks rows of the day

                # Setting second to be index (First second of day is 00:00:00)
                df_temp.set_index("second")
                new_index = pd.Index(arange(0,86400), name="second")
                df_temp = df_temp.set_index("second").reindex(new_index)

                # Adding value -1 in power to rows with NaN to please matlab program
                df_temp.power = df_temp.power.fillna(-1)
                
                # Plot graphs and save to 
                print('\t\t\t Making daily plot')   
                plot = df_temp.dropna().plot(x = 'time_of_day', y = 'power', label='Power [W]', figsize=[20,10]);
                plot.set_xlabel('%s on %s-%s-%s' %(appliances[plugnumber], year, month, day))
                plot.set_ylabel('Watt')
                fig = plot.get_figure();
                

                plotpath = current_directory + '/data/plots/plugs/'
                if not os.path.exists(plotpath):
                    os.makedirs(plotpath)
                filename = year+'-'+month+'-'+day+':'+plugnumber+'-'+appliances[plugnumber]
                fig.savefig(plotpath + filename +'.png')
                plt.clf()
                plt.close('all')


                # Save to file with filename that inclueds: Plug number, date, household.
                print('\t\t\t Saving to file')
                path = current_directory + '/data/powermundsen_data/plugs/' + household + '/' + plugnumber 
                if not os.path.exists(path):
                    os.makedirs(path)

                cols_with_data = ['power']
                for col in cols_with_data:
                    df_temp.to_csv(os.path.join(path, r'%s-%s-%s' %(year, month, day) + '.csv'), columns=[col], index=True, header=False)
                print('\t\t\t Finished processing day %s ' %day)


print('Finished processing all Plugwise data')


# In[ ]:



