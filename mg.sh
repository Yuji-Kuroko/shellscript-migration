#!/bin/sh

migrate() {
  if [ $# -ne 1 ]; then
    echo "Usage: $0 migrate"
    exit 1
  fi

  local mg_dir="migrations"
  local mg_data_file="tmp/migrated.dat"
  local mg_data_tmp_file="tmp/tmp.migrated.dat"
  local mg_migrating_file="tmp/migrating.dat"
  local mg_migration_log="tmp/migration.log"

  if [ ! -f $mg_data_file ]; then
    touch $mg_data_file
  fi

  touch $mg_migrating_file
  for script_file in $(ls $mg_dir | comm -23 - $mg_data_file)
  do
    echo $script_file | tee -a $mg_migrating_file
    # TODO: when exit status not 0
    . ${mg_dir}/${script_file}
    echo $(date +'%Y-%m-%d %H:%M:%S'),${script_file} >> $mg_migration_log
  done

  # update migrated log
  cp -f $mg_data_file $mg_data_tmp_file
  cat $mg_migrating_file >> $mg_data_tmp_file
  sort $mg_data_tmp_file -o $mg_data_file

  rm $mg_data_tmp_file
  rm $mg_migrating_file
}

create() {
  if [ $# -ne 2 ]; then
    echo "Usage: create hogehoge"
    exit 1
  fi
  local file_name=$(date +'%Y%m%d%H%M%S')_${2}.sh
  echo $file_name
  echo "#!/bin/sh" > migrations/${file_name}
}

case "$1" in
  migrate)
    migrate $@
    ;;
  create)
    create $@
    ;;
  *)
    cat << EOS
Usage: $0 migrate          # migrate
       $0 create hogehoge  # create migration script
EOS
    exit 1
    ;;
esac
