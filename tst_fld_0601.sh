#root folder for copied direcotory tree

git_fld=/Users/Shared/Nordic/test
rm -R $git_fld/*

function mod_file2()
{
  header_dir=$(grep -e c_user_include_directories= $SRC )
  header_dir=$(echo $header_dir | cut -d '"' -f 2)
  header_nu=$(grep -o ";" <<< $header_dir | wc -l)
  echo $header_nu
 for ((i=1 ; i<=$header_nu ; i++))
   do 
     h_dir[i]=$(echo $header_dir | cut -d ';' -f $i)
     echo ${h_dir[i]}
     h_dir_nu[i]=$(grep -o \\.\\./ <<< ${h_dir[i]} | wc -l )
    # echo "dir_folder nu=${h_dir_nu[i]}"
     t_dir_nu[i]=$(grep -o /. <<< ${h_dir[i]} | wc -l )
     t_dir_nu[i]=$((${t_dir_nu[i]} + 1 ))
    # t_dir_nu[i]= `expr ${t_dir_nu[i]} + 1`
     echo "total folder nu = ${t_dir_nu[i]}" 
   #  echo -e "\n ---------------------------"
     #src_dir= "${h_dir[i]}"
     parse_name
     echo -e "\n#############################"
  done
}

function parse_name()
{ 
  src_fld="/Users/laitzufu/Downloads/nRF5_SDK_17.0.2_d674dde/examples/peripheral/radio/transmitter/pca10040/blank/ses"
  git_fld=/Users/Shared/Nordic/test
  git_fld_tmp=/Users/Shared/Nordic/test/examples/peripheral/radio/transmitter/pca10040/blank/ses
  bk_git_fld=$git_fld
  bk_src_fld=$src_fld
  src_dir=${h_dir[i]}
  fld_lvl_nu=7
  t=${t_dir_nu[i]}
  
   for (( t ; t >= 1; t-- ))
    do
      #echo "dir_folder levle = ${h_dir_nu[i]}"
       if [[ t -ge $(( ${h_dir_nu[i]} + 1)) && ${h_dir_nu[i]} -ge $fld_lvl_nu ]] 
       then
          #hd_fld[t]=$(basename ${h_dir[i]})
          hd_fld[t]="$(basename $src_dir)"
          #hd_fld[t]=$tdir
          src_dir="$(dirname $src_dir)"
        elif [[ ${h_dir_nu[i]} -eq $fld_lvl_nu && t -lt ${h_dir_nu[i]} ]] 
        then
          hd_fld[t]=$(basename $src_dir)
           # this part need to change to meet my criteria
        #   echo " enter here for the issue ={$hd_fld[t]}"
       fi

       if [[ ${h_dir_nu[i]} -lt $fld_lvl_nu && t -lt $((${h_dir_nu[i]} + 1 )) ]] 
       then
          hd_fld[t]=$(basename $src_dir)
          src_dir=$(dirname $src_dir)
          echo "dir_name= ${hd_fld[t]} and index_t= $t "
          # this part need to change to meet my criteria
        elif [[ ${h_dir_nu[i]} -lt $fld_lvl_nu && t -ge $((${h_dir_nu[i]} )) ]] 
          then
          hd_fld[t]=$(basename $src_dir)
           # this part need to change to meet my criteria
        #   echo " enter here for the issue ={$hd_fld[t]}"
       fi 
   done 
  level_lt_header_dir_nu
  hhd_chk_dir 
  #find  $src_fld_root/${hd_fld[s]} -maxdepth 1 -mindepth 1 -name "*.c" -o -name ".h" -exec cp {}  "$git_fld"/ \;
  # h_dir=" "

   src_fld=$bk_src_fld
   git_fld=$bk_src_fld
   hd_fld=() # clear data in line
  # return
}  

function level_lt_header_dir_nu()
{

  if [[ ${h_dir_nu[i]} -lt $fld_lvl_nu ]] # folder levvle need to change !!
  then
    for (( p=1; p <= ${h_dir_nu[i]} ; p++ ))
    do
      git_fld_tmp="$(dirname $git_fld_tmp)"
      src_fld="$(dirname $src_fld)"
      echo "~~~ src_fld= $src_fld ~~~"
    done
    for (( s=((${h_dir_nu[i]} + 1 )); s<= ${t_dir_nu[i]}; s++ ))
    do
        echo -e "s index = $s \n"
       if [[ "${hd_fld[s]}" == ".." && "${t_dir_nu[i]}" == "$s" ]]
        then
          hd_fld[s]=""
          echo " test data = ${hd_fld[s]} and index = $s "
    #git_fld_tmp= "$git_fld_tmp"/"$hd_fld[s]"
        elif [ -d "$git_fld_tmp"/"${hd_fld[s]}" ]
        then 
        git_fld_tmp="$git_fld_tmp"/"${hd_fld[s]}"
        echo -e " enter Git folder path= \n $git_fld_tmp "
        src_fld="$src_fld/${hd_fld[s]}"
      
       # find  $src_fld/${hd_fld[s]} -maxdepth 1 -mindepth 1 -name '*.h' -exec cp {}  "$git_fld_tmp"/  \;
       # find  $src_fld/${hd_fld[s]} -maxdepth 1 -mindepth 1 -name '*.c' -exec cp {}  "$git_fld_tmp"/  \;
       # find  $src_fld/${hd_fld[s]} -maxdepth 1 -mindepth 1 -name '*.s' -exec cp {}  "$git_fld_tmp"/  \;
        
        else
        git_fld_tmp="$git_fld_tmp"/"${hd_fld[s]}"
        mkdir -pv $git_fld_tmp
        src_fld="$src_fld/${hd_fld[s]}"
        echo " make dir @ =$git_fld_tmp"
        fi
    done
   find  $src_fld -maxdepth 1 -mindepth 1 -name '*.h' -exec cp {}  "$git_fld_tmp"  \;
   find  $src_fld -maxdepth 1 -mindepth 1 -name '*.c' -exec cp {}  "$git_fld_tmp"  \;
  fi
}


function hhd_chk_dir()
{
  echo "git source code folder= $bk_git_fld "
  src_fld_root="/Users/laitzufu/Downloads/nRF5_SDK_17.0.2_d674dde"
  if [[ ${h_dir_nu[i]} -eq $fld_lvl_nu ]] #enter main folder
  then
    a=`expr $fld_lvl_nu + 1`
    for (( ; a <= ${t_dir_nu[i]}; a++ )) 
      do
        if [ -d "$git_fld"/"${hd_fld[a]}" ]
        then
          git_fld="$git_fld"/"${hd_fld[a]}"
          src_fld_root="$src_fld_root"/"${hd_fld[a]}"
          echo -e " index a =$a ; hd_fld= ${hd_fld[a]}\n new git_fld = $git_fld "         
        else 
        mkdir -pv $git_fld/${hd_fld[a]}
        git_fld="$git_fld"/"${hd_fld[a]}"
        src_fld_root="$src_fld_root"/"${hd_fld[a]}"
        echo  -e " index a =$a \n (mkdir) git_fld = $git_fld "
        fi
    done
  echo  -e " source code folder path =\n $src_fld_root"
  echo  -e " git_fld folder path =\n $git_fld"
  fi
  find  "$src_fld_root" -maxdepth 1 -mindepth 1 -name "*.c" -exec cp {}  "$git_fld" \;
  find  "$src_fld_root" -maxdepth 1 -mindepth 1 -name "*.s" -exec cp {}  "$git_fld" \;
  find  "$src_fld_root" -maxdepth 1 -mindepth 1 -name "*.h" -exec cp {}  "$git_fld" \;
}


function mod_file()
{
cnt=0
#input="tmp.bak"
input=tmp.bak 
end=0

while IFS= read -r line
do
   tr=$(grep -c 'Name' <<< $line)
   let cnt++
   #echo the block of block 
   tmp_src=/Users/laitzufu/Downloads/nRF5_SDK_17.0.2_d674dde
   if [ $tr -eq 1 ]
    then 
    echo $tr 
    Name=$(echo $line | cut -d '"' -f 2)
    echo "folder_Name=$Name"
    tmp_dir=$git_fld
    #part jobs of folder
  fi 
   end=$(grep -c '/folder' <<< $line) 
  if [ $end -eq 1 ]
   then 
   echo -e "END line= $cnt \n"
   #grep -e  'End of bolck\n' <<< $lin
  fi

  if [[ $tr -eq 0 && $end -eq 0 ]]
    then 
    line=$(echo $line | cut -d '"' -f 2)

    #======= check dir of each file =====
    lvl=0
    sub_fld=0
    c_file=0
    s_file=0
    IFS='/' read  -a array <<< "$line"
    for i in ${array[@]}
      do 
        c_file=$(grep -c \\.c <<< "$i") # C and c
        s_file=$(grep -c \\.s <<< "$i")   # S and s
        if [[ $s_file -eq 1 ]]
          then echo " s_source code = $i"
        fi
        #s_and_c= $Cfile || $s_file
        #echo -e " find source file result = $s_and_c $c_file \n\n\n" 
        if [[ "$i" == ".." ]]
         then 
         let lvl++
         #echo "lvl = $lvl \n "
         elif [[ $c_file -eq 1  || $s_file -eq 1 ]]
         then 
         echo -e " c_file index = $c_file \n s_file index = $s_file "
         echo -e " Source code file = "$i"  \n "
         #break  #0530 remark 
         else  
         
         let sub_fld++
         fd[sub_fld]=$(echo $i | tr -d '/' )
         tmp_src="$tmp_src"/"${fd[sub_fld]}" #0601 added for fixing issue.
         echo -e "enter create folder and path \n\n"
         chk_dir $sub_fld #sub_fld must have. 
        fi
  done
   if [[ $c_file -eq 1  || $s_file -eq 1 ]]
    then 
      if [[ $lvl -ge $fld_lvl_nu ]]
      then 
      cp -r $line $tmp_dir
      if [[ $c_file -eq 1 ]]
      then 
      #find $head_file -maxdepth 1 -mindepth 1 -name 'main.c' -exec cp {}  "$git_fld_prj"/ \;
      #echo "$i= c_file name"
      file_name=$(basename $i .c)
      hd_file="$file_name.h"
      echo "############ hd_file = \n $hd_file"
      find  "$tmp_src" -maxdepth 1 -mindepth 1 -name "$hd_file" -exec cp {}  "$tmp_dir" \;
      #head_file=$(echo "$i" | tr .c  )  
      echo "$head_file copied" 
      #cp -r $head_file $tmp_dir
      fi
      fi 
  fi
    echo "level_nu=$lvl"
    rfd=`expr $lvl - $sub_fld`  #math calculation
    #echo -e "sub_folder = $rfd"
    #echo "levl_folder noumber= $lvl" && echo $line
    #chk_dir Name
    IFS= 
    #chk_dir
   fi
  done < "$input"
}


function chk_dir()
{ 
 git_fld=/Users/Shared/Nordic/test

 if [[ $lvl -eq 7 && $s_file -eq 0 && $c_file -eq 0 ]]
 then 
 case $sub_fld in 
 1) if [ -d "$git_fld/${fd[sub_fld]}" ] 
    then  
       #echo "folder_Name = $Name \n"
       echo "$git_fld/$Name/${fd[sub_fld]} exist"
       tmp_dir="$git_fld/${fd[sub_fld]}"
       echo -e "temp_dir= $tmp_dir "
    else
       mkdir -pv $$git_fld/$Name/${fd[sub_fld]}
       tmp_dir="$git_fld/${fd[sub_fld]}"
    fi
;;
 2) if [ -d "$tmp_dir/${fd[sub_fld]}" ] 
    then echo "$tmp_dir/${fd[sub_fld]} exist"
       tmp_dir="$tmp_dir/${fd[sub_fld]}"
    else
       mkdir -pv $tmp_dir/${fd[sub_fld]} 
        tmp_dir="$tmp_dir/${fd[sub_fld]}"
    fi
;; 
 *) if [ -d "$tmp_dir/${fd[sub_fld]}" ] 
    then echo "$tmp_dir/${fd[sub_fld]} exist"
       tmp_dir="$tmp_dir/${fd[sub_fld]}"
    else
       mkdir -pv $tmp_dir/${fd[sub_fld]} 
        tmp_dir="$tmp_dir/${fd[sub_fld]}"
    fi
    ;;
  
*)
    echo -e " folder create done /n"
esac
fi
}


function src_flds()
{
  bk_src_fld=$src_fld # string variable assign issue
  bk_git_fld=$git_fld
  i=1
  while [ "$i" -le "$fld_lvl_nu" ]; do
    tmp_fld=$(basename $src_fld)
    dir[i]=$tmp_fld
    src_fld=$(dirname $src_fld)
    echo "index i=$i"
    i=$(($i + 1))
  done
  i=($fld_lvl_nu)
  while [  "$i" -ge 1 ]
  do
    echo "index 2nd i=$i"
    if [ -d "$git_fld/${dir[i]}" ]
    then
      echo " folder exist"
    else 
       mkdir -pv $git_fld/${dir[i]}
       git_fld="$git_fld/${dir[i]}"
    fi
   i=`expr $i - 1`  
  done
  git_fld_prj=$git_fld
  src_fld=$bk_src_fld
  git_fld=$bk_git_fld
  #return
}

function fld_lvl_number()
{
fld_lvl_nu=0
tmp_src_fld=""
bk_src_fld=$src_fld
  while [ "examples" != "$tmp_src_fld" ] 
  do
   tmp_src_fld=$(basename $src_fld)
   src_fld=$(dirname $src_fld)
   fld_lvl_nu=$(($fld_lvl_nu + 1)) 
 done
src_fld=$bk_src_fld
}

function copy_major_file()
{
  bk_src_fld=$src_fld # string variable assign issue
  bk_git_fld_prj=$git_fld_prj
  
  for (( di=1; di<=3; di++ ))
  do
    src_fld=$(dirname $src_fld)
    git_fld_prj=$(dirname $git_fld_prj)
  done
  echo "source code = $src_fld"
  find $src_fld -maxdepth 1 -mindepth 1 -name 'main.c' -exec cp {}  "$git_fld_prj"/ \;
  src_fld=$bk_src_fld
  git_fld_prj=$bk_git_fld_prj
}


src_fld="/Users/laitzufu/Downloads/nRF5_SDK_17.0.2_d674dde/examples/peripheral/radio/transmitter/pca10040/blank/ses"
SRC="transmitter_pca10040.emProject"
git_fld="/Users/Shared/Nordic/test"
#get folder level nu
fld_lvl_number
cd $src_fld
cat $SRC >> src.txt
# find the following file in project folder" 

sed -n -e '/<folder Name=".*">/,/<\/folder>/p' $SRC > tmp.bak
Dest=$(grep -e "folder Name" src.bak  || echo " not found")
#substrat=$(echo $Dest | cut -d '"' -f 2); 
nu=$(grep -o "folder Name" <<< $Dest | wc -l)
src_flds
############# copy source code and project file 
find $src_fld -maxdepth 1 -mindepth 1 -name 'flash_placement.xml' -exec cp {}  "$git_fld_prj"  \;
find $src_fld -maxdepth 1 -mindepth 1 -name '*.emProject' -exec cp {}  "$git_fld_prj"/ \;
copy_major_file

############# function to grap source code.
mod_file 
#grep -e c_user_include_directories= $SRC 
mod_file2 
return


