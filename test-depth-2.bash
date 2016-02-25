function show_stack_and_resource() {
  the_rname=$1
  sleep 1
  for stack_id in `heat stack-list -n | grep $the_rname | awk -F' ' '{ print $2 }'`; do
    heat stack-show $stack_id
    heat resource-show $stack_id test1
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

rname4=one-stack-B1-$(openssl rand -hex 2)
heat stack-create -e resource-registry-string.yaml -f one-stack-string.yaml  $rname4
show_stack_and_resource $rname4

echo ========================================================================================================
echo '-- CREATE SIMPLE RESOURCE WITH STRING PARAM, PASS PARAM'
echo ========================================================================================================

rname4a=one-stack-B1-$(openssl rand -hex 2)
heat stack-create -e resource-registry-string.yaml -f one-stack-string.yaml  -P 'MyPotato=really:tasty' $rname4a
show_stack_and_resource $rname4a

echo ========================================================================================================
echo '-- CREATE SIMPLE RESOURCE WITH LIST PARAM'
echo ========================================================================================================

rname5=one-stack-B1-$(openssl rand -hex 2)
heat stack-create -e resource-registry-list.yaml -f one-stack-list.yaml  $rname5
show_stack_and_resource $rname5

echo ========================================================================================================
echo '-- CREATE SIMPLE RESOURCE WITH LIST PARAM (POOR DEFAULT)'
echo ========================================================================================================

rname6=one-stack-B1-$(openssl rand -hex 2)
heat stack-create -e resource-registry-list-poor-default.yaml -f one-stack-list-poor-default.yaml  $rname6
show_stack_and_resource $rname6

echo ========================================================================================================
echo '-- UPDATE RESOURCE STRING->LIST PARAM (POOR DEFAULT)'
echo ========================================================================================================

heat stack-update -e resource-registry-list-poor-default.yaml -f one-stack-list-poor-default.yaml  $rname4
show_stack_and_resource $rname4

echo ========================================================================================================
echo '-- UPDATE RESOURCE STRING->LIST PARAM (POOR DEFAULT), PASS PARAM'
echo ========================================================================================================

heat stack-update -e resource-registry-list-poor-default.yaml -f one-stack-list-poor-default.yaml -P 'MyPotato=good:carbs' $rname4a
show_stack_and_resource $rname4a

