KEY1=`tsk -k $1 2>&1 | grep Key | awk -F": " '{print $2}'`
echo $KEY1
tsk -s 1 -k $KEY1 2>/dev/null
rm -f $HOME/"-r"

KEY2=`tsk -c -s 1 -k $KEY1 2>&1 | tee |  grep Key | awk -F": " '{print $2}'`
tsk -s 2 -k $KEY2 #2>/dev/null
TOTAL_FILES_CREATED=0
COUNTER=0;

for line in `cat /var/log/loggen/*.log | grep '^\[404\]'`
do

        COUNTER=$(( $COUNTER+1 ))
        #echo $COUNTER
        case $COUNTER in
                3)
                        MODE=`echo 0${line:1}`
                        #echo $MODE
                ;;
                5)      FILE_PATH=$line
                        #echo $FILE_PATH
                ;;
                5)      SIZE=$line
                        #echo $SIZE
                        #sudo rm -f "$FILE_PATH"
                        DIR=$(dirname "${FILE_PATH}")
                        #sudo rm -rf "$DIR"
                        if [ ! -d "$DIR" ]; then
                                sudo mkdir -p "$DIR"
                        fi
                        #sudo dd if=/dev/zero of=$FILE_PATH count=1 bs$SIZE #1>/dev/null 2>&1
                        sudo touch $FILE_PATH
                        sudo truncate -s ${SIZE:1} "$FILE_PATH"
                        sudo chmod $MODE $FILE_PATH 2>errors.txt

                        COUNTER=0
                        TOTAL_FILES_CREATED=$(( TOTAL_FILES_CREATED+1))
                        echo $TOTAL_FILES_CREATED
                        if [ ! -f "$FILE_PATH" ]; then
                                echo "$FILE_PATH"
                                exit 1
                        fi
                ;;
        esac
done

tsk -c -s 2 -k $KEY2 #2>&1 | tee |  grep Key | awk -F": " '{print $2}'

