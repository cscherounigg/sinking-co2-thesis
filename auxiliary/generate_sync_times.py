# Script to create a list of timesteps for sync_times in MOOSE Output

from pyperclip import copy

end_time = 30 * 365 * 24 * 60 * 60 # 30 years

interval = 30 * 24 * 60 * 60 # 30 days

time = 0
timestring = ""
while (time < end_time):
    timestring = timestring + "{:e} ".format(time)
    time = time + interval

copy(timestring.strip())