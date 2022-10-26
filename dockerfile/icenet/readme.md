Configure the connection between the cluster and the shared storage created earlier. Then, create
folders named logs, logqueue, and work on the shared store. Although the folder names are the
same, these are different folders from the ones you created for the Control Center cluster. The
following are examples of paths to these folders (you can create any folder structure you want):

S:/Nextlabs/ICENet/Cluster/logs
S:/Nextlabs/ICENet/Cluster/logqueue
S:/Nextlabs/ICENet/Cluster/work


Modify server.xml. This file is in <CC Install Dir>/server/configuration.
a. Replace all instances of the hostname with the cluster name. For example, ICE01 is the hostname.
<Parameter name="ComponentName" value="ICE01.tdomain.nl_dabs"/> <Parameter
name="Location" value="https://ICE01.tdomain.nl:8443/dabs"/>
b. Replace all instances of the work directory folder with the work folder in the shared store. The
following are examples of where the work directory folder, ${catalina.base}/work/dabs,
occurs:
<Context path=... workDir="${catalina.base}/work/dabs">
The following is an example of the modified version, which uses the example path provided in step 4:
<Context path=... workDir="S:/Nextlabs/ICENet/Cluster/work/dabs">

c. In the DABS Component section, add or modify the LogQueueFolder location to point to the
logqueue folder in the shared store, as shown in the following example:
<!--[DABS_COMPONENT_BEGIN]-->
<Context path="...
 ...
<Parameter name="LogQueueFolder" value="S:/Nextlabs/ICENet/Cluster/
logqueue"/>

