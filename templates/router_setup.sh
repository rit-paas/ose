# Creation of routing instances
export ROUTER_NAMESPACE=router

oc new-project $ROUTER_NAMESPACE
oc project $ROUTER_NAMESPACE

# Creation of Service Account
echo \
    '{"kind":"ServiceAccount","apiVersion":"v1","metadata":{"name":"router"}}' \
    | oc create -f -

# Edit privileged, add to bottom under users: - system:serviceaccount:default:router
oc edit scc privileged

# Edit Project Node Selector to DMZ
# In the annotations list, add: openshift.io/node-selector: region=dmz
oc edit namespace $ROUTER_NAMESPACE

# Create Routing Instances
oadm router ha-router \
    --replicas=2  \
    --selector="region=dmz" --labels="ha-router=dmz" \
    --credentials="/etc/openshift/master/openshift-router.kubeconfig" --service-account=router

oadm ipfailover ipf-ha-router --replicas=2  --watch-port=80    \
     --selector="region=dmz" --virtual-ips="10.154.1.50" \
     --credentials="/etc/openshift/master/openshift-router.kubeconfig" --service-account=router --create
