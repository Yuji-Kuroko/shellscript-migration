#!/bin/sh

migrate() {
  if [ $# -eq 1 ]; then
    echo "Usage: migrate"
    exit 1
  fi

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
