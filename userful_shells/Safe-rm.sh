### 把这段代码加入你的home目录的.bashrc或者.zshrc就可以了
###工作原理：
###在你的home目录会创建一个.trash文件夹里面会按照删除时间 年-月-日/小时/ 进行归档已删除的文件然后会删除一个月以前的文件夹
function saferm() {
    ops_array=($*)
    if [[ -z $1 ]] ;then
        echo 'Missing Args'
        return
    fi
    J=0
    offset=0
    # for zsh
    if [[ -z ${ops_array[0]} ]] ; then
        offset=1
    fi
    while [[ $J -lt $# ]] ; do
          p_posi=$(($J + $offset))
          dst_name=${ops_array[$p_posi]}
          if [[ `echo ${dst_name} | cut -c 1` == '-' ]] ; then
                continue
          fi
        # garbage collect
        now=$(date +%s)
        for s in $(ls --indicator-style=none $HOME/.trash/) ;do
            dir_name=${s//_/-}
            dir_time=$(date +%s -d $dir_name)
            # if big than one month then delete
            if [[ 0 -eq dir_time || $(($now - $dir_time)) -gt 2592000 ]] ;then
                echo "Trash " $dir_name " has Gone "
                /bin/rm $HOME/.trash/$dir_name -rf
            fi
        done

        # add new folder
        prefix=$(date +%Y_%m_%d)
        hour=$(date +%H)
        mkdir -p $HOME/.trash/$prefix/$hour
        echo "Trashing " $dst_name
        mv ./$dst_name $HOME/.trash/$prefix/$hour
          J=$(($J+1))
    done
}

alias rm=saferm