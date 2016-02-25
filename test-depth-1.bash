function show_stack_and_resource() {
  the_rname=$1
  sleep 1
  heat stack-show $the_rname
  stack_id=`heat stack-show $the_rname | grep ' id ' | awk -F' ' '{ print $4 }'`
  heat resource-show $stack_id test1
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

rname=one-resource-A1-$(openssl rand -hex 2)
heat stack-create -f one-resource-string.yaml  $rname
show_stack_and_resource $rname

echo ========================================================================================================
echo '-- CREATE SIMPLE RESOURCE WITH STRING PARAM, PASS PARAM'
echo ========================================================================================================

rname1a=one-resource-A1-$(openssl rand -hex 2)
heat stack-create -f one-resource-string.yaml -P 'MyPotato=with:onions' $rname1a
show_stack_and_resource $rname1a

echo ========================================================================================================
echo '-- CREATE SIMPLE RESOURCE WITH LIST PARAM'
echo ========================================================================================================

rname2=one-resource-A1-$(openssl rand -hex 2)
heat stack-create -f one-resource-list.yaml  $rname2
show_stack_and_resource $rname2

echo ========================================================================================================
echo '-- CREATE SIMPLE RESOURCE WITH LIST PARAM (POOR DEFAULT)'
echo ========================================================================================================

rname3=one-resource-A1-$(openssl rand -hex 2)
heat stack-create -f one-resource-list-poor-default.yaml  $rname3
show_stack_and_resource $rname3

echo ========================================================================================================
echo '-- CREATE SIMPLE RESOURCE WITH LIST PARAM (POOR DEFAULT), PASS PARAM'
echo ========================================================================================================

rname3a=one-resource-A1-$(openssl rand -hex 2)
heat stack-create -f one-resource-list-poor-default.yaml -P 'MyPotato=hello:there' $rname3a
show_stack_and_resource $rname3a

echo ========================================================================================================
echo '-- UPDATE RESOURCE STRING->LIST PARAM (POOR DEFAULT)'
echo ========================================================================================================

heat stack-update -f one-resource-list-poor-default.yaml  $rname
show_stack_and_resource $rname

echo ========================================================================================================
echo '-- UPDATE RESOURCE STRING->LIST PARAM (POOR DEFAULT)'
echo ========================================================================================================

heat stack-update -f one-resource-list-poor-default.yaml -P 'MyPotato=with:salt' $rname1a
show_stack_and_resource $rname1a
