function show_stack_and_resource() {
  the_rname=$1
  sleep 1
  for stack_id in `heat stack-list -n | grep $the_rname | awk -F' ' '{ print $2 }'`; do
    heat stack-show $stack_id
  done
  heat resource-list -n5 `heat stack-list -n | grep -P "\s$the_rname\s" | awk -F' ' '{ print $2 }'`
  heat resource-list -n5 $the_rname | grep $the_rname | perl -p -e 's/^..(\S+).*\s(\S\S+)\s*?.*/heat resource-show $2 $1/' | while read line; do
    $line
  done
}

function delete_stacks() {
   for stack_id in $(heat stack-list | grep -P ' | ' | grep -v stack_status | awk -F' ' '{ print $2 }'); do
    heat stack-delete $stack_id
   done
}

delete_stacks

echo ========================================================================================================
echo '-- CREATE SIMPLE RESOURCE WITH STRING PARAM'
echo ========================================================================================================

rname7=one-resource-group-B1-$(openssl rand -hex 2)
heat stack-create -e resource-registry-string.yaml -f one-resource-group-string.yaml $rname7
show_stack_and_resource $rname7

echo ========================================================================================================
echo '-- CREATE SIMPLE RESOURCE WITH STRING PARAM, PASS PARAM'
echo ========================================================================================================

rname7a=one-resource-group-B1-$(openssl rand -hex 2)
heat stack-create -e resource-registry-string.yaml -f one-resource-group-string.yaml -P 'MyFirstPotato=really:tasty' $rname7a
show_stack_and_resource $rname7

echo ========================================================================================================
echo '-- CREATE SIMPLE RESOURCE WITH LIST PARAM'
echo ========================================================================================================

rname8=one-resource-group-B1-$(openssl rand -hex 2)
heat stack-create -e resource-registry-list.yaml -f one-resource-group-list.yaml $rname8
show_stack_and_resource $rname8

echo ========================================================================================================
echo '-- CREATE SIMPLE RESOURCE WITH LIST PARAM (POOR DEFAULT)'
echo ========================================================================================================

rname9=one-resource-group-B1-$(openssl rand -hex 2)
heat stack-create -e resource-registry-list-poor-default.yaml -f one-resource-group-list-poor-default.yaml $rname9
show_stack_and_resource $rname9

echo ========================================================================================================
echo '-- UPDATE RESOURCE STRING->LIST PARAM (POOR DEFAULT)'
echo ========================================================================================================

heat stack-update -e resource-registry-list-poor-default.yaml -f one-resource-group-list-poor-default.yaml $rname7
show_stack_and_resource $rname7

echo ========================================================================================================
echo '-- UPDATE RESOURCE STRING->LIST PARAM (POOR DEFAULT), PASS PARAM'
echo ========================================================================================================

heat stack-update -e resource-registry-list-poor-default.yaml -f one-resource-group-list-poor-default.yaml -P 'MyFirstPotato=good:carbs' $rname7a
show_stack_and_resource $rname7a
