#!/bin/sh

for target_ns in $(kubectl get ns -l velero.backup.period=weekly -o name | cut -d "/" -f 2)
  do

    num_backup=$(velero backup get -l ns=$target_ns | sed 1d | wc -l);
    num_keep_backup=$(kubectl get ns $target_ns -o "jsonpath={.metadata.labels['velero\.backup\.keep']}")
    num_delete=$(( num_backup - num_keep_backup + 1 ))

    echo "===" $target_ns "requires" $num_keep_backup " backups , has " $num_backup " backups ==="

    if [ $num_delete -ge 0 ]
    then
      for backup_name in $(velero backup get -l ns=$target_ns | sed 1d | head -$num_delete | cut -d' ' -f 1)
        do
          echo "Deleting an oldest backup :" $backup_name
          velero delete backup $backup_name --confirm
        done
    fi

    echo "=== Create a backup in " $target_ns "===="

    velero backup create $target_ns-$(date +%F-%H%M%S) --include-namespaces=$target_ns --labels ns=$target_ns --labels velero.backup.period=weekly

  done
