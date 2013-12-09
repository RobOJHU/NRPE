#!/bin/bash
# Author: James Chase
# Contact: james@chasecomputers.net
#
# nrpe        Startup script for NRPE
#
# chkconfig: 35 99 1
# description:         A simple script to autostart NRPE and allow us to easily reboot
#                it. 
#
# Additional Info:        This will work on most Red Had style linux distributions#                        (I tested on CentOS 4/5). I know that it is funky in 
#                        SuSe. You may have to modify the 'nrpe=' and 'pidfile='
#                        and 'lockfile=' lines to just point to the directory
#                        without the '${SOMETHING-'. I'm not even sure what
#                        the point of that is. If you know, email me!     
#
# processname: nrpe




#  from MY server --RobO  /usr/local/nagios/bin/nrpe -c /usr/local/nagios/etc/nrpe.cfg -d
# config: /usr/local/nagios/etc/nrpe.conf
# pidfile: /var/run/nrpe.pid

# Source function library.
. /etc/rc.d/init.d/functions

# Paths to the nrpe script, lockfile location, options to start nrpe with, etc.
nrpe=${NRPE-/usr/local/nagios/bin/nrpe}
prog=nrpe
pidfile=${PIDFILE-/var/run/nrpe.pid}
lockfile=${LOCKFILE-/var/lock/subsys/nrpe}
RETVAL=0
OPTIONS='-c /usr/local/nagios/etc/nrpe.cfg -n -d'

# Umm, start the program! 
start() {
        echo -n $"Starting $prog: "
        $nrpe $OPTIONS
        RETVAL=$?
        [ $RETVAL = 0 ] && touch ${lockfile} && success || failure 
        echo
        return $RETVAL
}

# Stop the program? I don't think killall works on all linux distributions.
# It's probably not even the best way to do it on CentOS! If you have issues
# just change the 'killall' to 'kill $pid' or 'kill -9 $pid' 
stop() {
        echo -n $"Stopping $prog: "
        killall $nrpe 
        RETVAL=$?
        [ $RETVAL = 0 ] && rm -f ${lockfile} ${pidfile} && success || failure
        echo
}

reload() {
    echo $"Reloading $prog: "
        stop
        start
        RETVAL=$?
}

# See how we were called.
case "$1" in
  start)
        start
        ;;
  stop)
        stop
        ;;
  status)
        status $nrpe
        RETVAL=$?
        ;;
  restart)
        stop
        start
        ;;
  condrestart)
        if [ -f ${pidfile} ] ; then
                stop
                start
        fi
        ;;
  reload)
        reload
        RETVAL=$?
        ;;
  *)
        echo $"Usage: $prog {start|stop|restart|condrestart|reload|status|help}"
        exit 1
esac

exit $RETVAL
