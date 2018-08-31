#!/bin/bash
exit1()
{
if [ $? == "1" ]
then
exit 1
fi
}
opration=$(zenity --list --radiolist --column "" --column "Operation" True "VM-Start" False "VM-restart" False "VM-console" False "VM-Shutdown" False "VM-snapshot" 2> /dev/null)
exit1

