# Homework 4, ECEN 5033

## Assumptions
It is assumed that users have Kubernetes installed on 3 VMs (machine1, machine2, machine3) and have a registry running at 192.168.33.10:5000.

In order to meet said assumptions, you will need to install vagrant, directions can be found [here](https://www.vagrantup.com/downloads). You will also need a VM that is supported by Vagrant, information can be found [here](https://www.vagrantup.com/docs/providers) (for the provided Vagrantfile, VirtualBox is necessary).

## Installing Kubernetes
Once the above two requirements have been met, navigate to the `k8s_installtion_for_class` directory and complete the following steps:

1. `vagrant up`
2. from the host OS, copy `part1.sh`, `part2_master.sh`, and `kube-flannel.yml` into the `machine1_data` directory
3. `vagrant ssh machine1`
4. `cd /home/vagrant`
5. `cp /vagrant_data/* .`
6. `chmod +x *.sh`
7. `./part1.sh`
8. `sudo vi /etc/systemd/system/kubelet.service.d/10-kubeadm.conf` and modify the last line, changing:

   `ExecStart=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_CONFIG_ARGS $KUBELET_KUBEADM_ARGS $KUBELET_EXTRA_ARGS`
  
   into:
  
   `ExecStart=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_CONFIG_ARGS $KUBELET_KUBEADM_ARGS $KUBELET_EXTRA_ARGS --node-ip=192.168.33.10`
9. `./part2_master.sh`

   Note the printout, there should be command that looks like this:
   
   ```
   kubeadm join 192.168.33.10:6443 --token fmjd4k.35gh8kccpx47mliz \
     --discovery-token-ca-cert-hash sha256:34a59dfa77699192fab12e19d38cb7233f786819192d5fe9b57399ded1c47c26
   ```
   
   Copy this command for later reference.
   
   If desired, you can validate the the above all worked with the following command (if you see a list of things, that's a good sign):
   
   `sudo kubectl get pods --all-namespaces`
10. `exit`
11. `vagrant ssh machine2`
12. `cp /vagrant/machine1_data/part1.sh .`
13. `chmod +x part1.sh`
14. `./part1.sh`
15. `sudo vi /etc/systemd/system/kubelet.service.d/10-kubeadm.conf` and modify the last line, changing:

    `ExecStart=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_CONFIG_ARGS $KUBELET_KUBEADM_ARGS $KUBELET_EXTRA_ARGS`
  
    into:
  
    `ExecStart=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_CONFIG_ARGS $KUBELET_KUBEADM_ARGS $KUBELET_EXTRA_ARGS --node-ip=192.168.33.11`
16. Edit the previously-copied command as follows, then paste and run it:
    
    ```
    sudo kubeadm join 192.168.33.10:6443 --token fmjd4k.35gh8kccpx47mliz \
     --discovery-token-ca-cert-hash sha256:34a59dfa77699192fab12e19d38cb7233f786819192d5fe9b57399ded1c47c26 \
     --node-name machine2
    ```
    
    If desired, you can validate the the above all worked with the following command on machine1 (you should see machine1 and machine2):
    
    `kubectl get node`
17. `exit`
18. `vagrant ssh machine3`
19. `cp /vagrant/machine1_data/part1.sh .`
20. `chmod +x part1.sh`
21. `./part1.sh`
22. `sudo vi /etc/systemd/system/kubelet.service.d/10-kubeadm.conf` and modify the last line, changing:

   `ExecStart=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_CONFIG_ARGS $KUBELET_KUBEADM_ARGS $KUBELET_EXTRA_ARGS`
  
   into:
  
   `ExecStart=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_CONFIG_ARGS $KUBELET_KUBEADM_ARGS $KUBELET_EXTRA_ARGS --node-ip=192.168.33.12`
23. Edit the previously-copied command as follows, then paste and run it:
    
    ```
    sudo kubeadm join 192.168.33.10:6443 --token fmjd4k.35gh8kccpx47mliz \
     --discovery-token-ca-cert-hash sha256:34a59dfa77699192fab12e19d38cb7233f786819192d5fe9b57399ded1c47c26 \
     --node-name machine3
    ```
    
    If desired, you can validate the the above all worked with the following command on machine1 (you should see machine1, machine2, and machine3):
    
    `kubectl get node`
    
## Starting a registry
Once Kubernetes has been successfully installed on all 3 machines, do the following on each machine:
1. `sudo docker run -d -p 5000:5000 --restart=always --name registry registry:2`
2. `sudo vi /etc/docker/daemon.json`

   Add `"insecure-registries":["192.168.33.10:5000"]` to the end of the object.
   
   Once done, the file should look like this:
   
   ```
   {
      "exec-opts": ["native.cgroupdriver=systemd"],                                                                                         
      "log-driver": "json-file",                                                                                                            
      "log-opts": {
          "max-size": "100m"                                                                                                                  
      },                                                                                                                                    
      "storage-driver": "overlay2",                                                                                                         
      "insecure-registries":["192.168.33.10:5000"]                                                                                        
   } 
   ```
   
3. `sudo service docker restart`

## Running the project
## Part 1
1. From the host OS, copy the contents of `Alex_HW4` into `machine1_data`
2. `vagrant ssh machine1`
3. `cp -r /vagrant/machine1_data/* /home/vagrant/`
4. `cd Alex_HW4/flaskapp_version1`
5. IMPORTANT NOTE: Since the development environment used was Windows, files by default have CRLF line endings (a "hidden" `\r` at the end of lines). To remedy this, when first entering any directory with a `.sh` file, you will do the following (reminders will be given when this process is necessary, simply reference this bullet point as desired):

   `sudo vi *`
   
   Once in VIM, run the following commands:
   
   `:argdo set ff=unix | update`
   
   `:w`
   
   `:wq`
   
6. `chmod +x *.sh`
7. `./build_flaskapp.sh`
8. If the container was successfully pushed to the registry, running `curl 192.168.33.10:5000/v2/_catalog` should result in output like this:

   ```
   {"repositories":["alex-flaskapp"]}
   ```
8. `cd ..`
9. Run `kubectl apply -f flaskapp_rc.yml` to create a ReplicationController for the server. More information about ReplicationControllers and their purpose can be found [here](https://kubernetes.io/docs/concepts/workloads/controllers/replicationcontroller/).
10. If the ReplicationController was successfully created, running `kubectl get rc` should result in output like this:

   ```
   NAME               DESIRED   CURRENT   READY   AGE                                                                                    alex-
   flaskapp-rc          3         3         3     41s
   ```
   
   and running `kubectl get pod` should result in output like this:
   
   ```
   NAME                     READY   STATUS    RESTARTS   AGE                                                                             
   alex-flaskapp-rc-flj65   1/1     Running   0          32s                                                                             
   alex-flaskapp-rc-mpkkg   1/1     Running   0          116s                                                                            
   alex-flaskapp-rc-z7cxz   1/1     Running   0          116s
   ```
11. To test scalability and fault tolerance, you can do the following:
    
    Change the number of replicas specified in `flaskapp_rc.yml` and rerun `kubectl apply -f flaskapp_rc.yml`. Upon running `kubectl get pod`, you should see a change in the number of pods to match the new number.
    
    Run `kubectl delete pod alex-flaskapp-rc-hpsnl` (in reality you would use once of the unique hash values of the pods on your machine). Upon running `kubectl get pod` you should see that the deleted pod has been replaced by a new replica, like this:
    
    ```
    NAME                     READY   STATUS    RESTARTS   AGE                                                                             
    alex-flaskapp-rc-flj65   1/1     Running   0          32s                                                                             
    alex-flaskapp-rc-mpkkg   1/1     Running   0          116s                                                                            
    alex-flaskapp-rc-z7cxz   1/1     Running   0          116s
    ```
12. Next, run `kubectl apply -f flaskapp_svc.yml` to create a Service that will serve as a load balancer between the pods.
13. If the Service was successfully created, running `kubectl get svc` should result in output like this:
    
    ```
    NAME                TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE                                                          
    alex-flaskapp-svc   ClusterIP   10.110.221.250   <none>        80/TCP    7s                                                           
    kubernetes          ClusterIP   10.96.0.1        <none>        443/TCP   28m
    ```
    
    Copy the new service's IP address for later reference.
14. `cd ubuntucurl`
15. Reference step 5 and complete that process for this directory.
16. `chmod +x *.sh`
17. `./build.sh`
18. If the container was successfully pushed to the registry, running `curl 192.168.33.10:5000/v2/_catalog` should result in output like this:

   ```
   {"repositories":["alex-flaskapp","alex-ubuntucurl"]}
   ```
19. `cd ..`
20. Run `kubectl apply -f ubuntucurl.yml` to create a pod for the client (in this case, we simply use curl).
21. If the client pod was successfully created, running `kubectl get pod -o wide` should result in output like this (where the server replicas are all running on machine2, while the client is running on machine3):
    
    ```
    NAME                     READY   STATUS    RESTARTS   AGE     IP           NODE       NOMINATED NODE   READINESS GATES                
    alex-flaskapp-rc-flj65   1/1     Running   0          4m44s   10.244.1.5   machine2   <none>           <none>                         
    alex-flaskapp-rc-mpkkg   1/1     Running   0          6m8s    10.244.1.2   machine2   <none>           <none>                         
    alex-flaskapp-rc-z7cxz   1/1     Running   0          6m8s    10.244.1.3   machine2   <none>           <none>                         
    alex-ubuntucurl          1/1     Running   0          19s     10.244.2.2   machine3   <none>           <none>
    ```
22. Run `kubectl exec alex-ubuntucurl -- bash manycurl.sh 10.110.221.250:80`. Note that the IP address used should be the one that we copied in step 13. If all is working properly, you should see output like this (where the pod getting hit changes due to the Service):
    
    ```
      % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current                                                            
      Dload  Upload   Total   Spent    Left  Speed                                                         
      100    56  100    56    0     0  14000      0 --:--:-- --:--:-- --:--:-- 14000                                                        
      You've hit alex-flaskapp-rc-z7cxz. Message for version 1  
      
      % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
      Dload  Upload   Total   Spent    Left  Speed                                                         
      100    56  100    56    0     0  28000      0 --:--:-- --:--:-- --:--:-- 28000                                                        
      You've hit alex-flaskapp-rc-z7cxz. Message for version 1  
      
      % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
      Dload  Upload   Total   Spent    Left  Speed                                                         
      100    56  100    56    0     0   7000      0 --:--:-- --:--:-- --:--:--  7000                                                        
      You've hit alex-flaskapp-rc-flj65. Message for version 1  
      
      % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
      Dload  Upload   Total   Spent    Left  Speed                                                         
      100    56  100    56    0     0  14000      0 --:--:-- --:--:-- --:--:-- 14000                                                        
      You've hit alex-flaskapp-rc-mpkkg. Message for version 1
      ```
      
      Stop the process when desired.

## Part 2
1. Run `kubectl apply -f flaskapp_dep.yml` to create a Deployment.
2. If the Deployment was successfully created, running `kubectl get deployments` should result in output like this:
    
    ```
    NAME                READY   UP-TO-DATE   AVAILABLE   AGE                                                                              
    alex-flaskapp-dep   3/3     3            3           10s
    ```
    
    This Deployment should also create server pods, so running `kubectl get pods` should result in output like this:
    
    ```
    NAME                                 READY   STATUS    RESTARTS   AGE                                                                 
    alex-flaskapp-dep-656d4dc9c6-58bf5   1/1     Running   0          35s                                                                 
    alex-flaskapp-dep-656d4dc9c6-pgb4x   1/1     Running   0          35s                                                                 
    alex-flaskapp-dep-656d4dc9c6-pkzhx   1/1     Running   0          35s                                                                 
    alex-flaskapp-rc-flj65               1/1     Running   0          6m54s                                                               
    alex-flaskapp-rc-mpkkg               1/1     Running   0          8m18s                                                               
    alex-flaskapp-rc-z7cxz               1/1     Running   0          8m18s                                                               
    alex-ubuntucurl                      1/1     Running   0          2m29s
    ```
3. From this point onward, we will refer to the current terminal as "Terminal 1". Open a new terminal session, which we will refer to as "Terminal 2".
4. In Terminal 2, navigate to this homework's directory and run the following:

   `vagrant ssh machine1`
   
   `cd Alex_HW4`
   
   `kubectl exec alex-ubuntucurl -- bash manycurl.sh 10.110.221.250:80` (using the same IP address as last time)
   
   The output should at first look very similar to the output seen in step 2.
   
5. In Terminal 1, run `kubectl delete rc alex-flaskapp-rc` to delete our ReplicationController. Running `kubectl get pod` should show output like this:
   
   ```
   NAME                                 READY   STATUS        RESTARTS   AGE                                                             
   alex-flaskapp-dep-656d4dc9c6-58bf5   1/1     Running       0          8m37s                                                           
   alex-flaskapp-dep-656d4dc9c6-pgb4x   1/1     Running       0          8m37s                                                           
   alex-flaskapp-dep-656d4dc9c6-pkzhx   1/1     Running       0          8m37s                                                           
   alex-flaskapp-rc-flj65               1/1     Terminating   0          14m                                                             
   alex-flaskapp-rc-mpkkg               1/1     Terminating   0          16m                                                             
   alex-flaskapp-rc-z7cxz               1/1     Terminating   0          16m                                                             
   alex-ubuntucurl                      1/1     Running       0          10m
   ```
6. In Terminal 2, you should start seeing the Service load balancing between ReplicationController pods (as they move through the termination process) and Deployment pods, like this:
   
   ```
   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
   Dload  Upload   Total   Spent    Left  Speed                                                         
   100    56  100    56    0     0   8000      0 --:--:-- --:--:-- --:--:--  9333
   You've hit alex-flaskapp-rc-z7cxz. Message for version 1                                                                                                                                        
   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
   Dload  Upload   Total   Spent    Left  Speed                                                         
   100    56  100    56    0     0   9333      0 --:--:-- --:--:-- --:--:--  9333
   You've hit alex-flaskapp-rc-flj65. Message for version 1                                                                                                                                        
   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
   Dload  Upload   Total   Spent    Left  Speed                                                         
   100    68  100    68    0     0  13600      0 --:--:-- --:--:-- --:--:-- 13600                                                        
   You've hit alex-flaskapp-dep-656d4dc9c6-pkzhx. Message for version 1  
   
   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
   Dload  Upload   Total   Spent    Left  Speed                                                         
   100    68  100    68    0     0  11333      0 --:--:-- --:--:-- --:--:-- 13600                                                        
   You've hit alex-flaskapp-dep-656d4dc9c6-pkzhx. Message for version 1  
   
   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
   Dload  Upload   Total   Spent    Left  Speed                                                         
   100    56  100    56    0     0  18666      0 --:--:-- --:--:-- --:--:-- 18666
   You've hit alex-flaskapp-rc-flj65. Message for version 1                                                                                                                                        
   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
   Dload  Upload   Total   Spent    Left  Speed                                                         
   100    68  100    68    0     0   9714      0 --:--:-- --:--:-- --:--:-- 11333                                                        
   You've hit alex-flaskapp-dep-656d4dc9c6-pkzhx.
   ```
7. In Terminal 1, run `cd flaskapp_version2`.
8. Reference step 5 from Part 1 and complete that process for this directory.
9. `chmod +x *.sh`
10. `./build_flask.sh`
11. Running `curl 192.168.33.10:5000/v2/alex-flaskapp/tags/list` should give us output like this (as expected, as both versions of our Flask app have now been built):
    
    ```
    {"name":"alex-flaskapp","tags":["version2","version1"]}
    ```
12. Run `kubectl set image deployments/alex-flaskapp-dep alex-flaskapp=192.168.33.10:5000/alex-flaskapp:version2` to update our server from version 1 to version 2.
13. AFter a short while, running `kubectl get pod -o wide` should give us output like this:
    
    ```
    NAME                                 READY   STATUS    RESTARTS   AGE   IP            NODE       NOMINATED NODE   READINESS GATES     
    alex-flaskapp-dep-7f7f685fdf-b5vkc   1/1     Running   0          52s   10.244.1.10   machine2   <none>           <none>              
    alex-flaskapp-dep-7f7f685fdf-ksqfs   1/1     Running   0          50s   10.244.1.11   machine2   <none>           <none>              
    alex-flaskapp-dep-7f7f685fdf-pdhjd   1/1     Running   0          55s   10.244.1.9    machine2   <none>           <none>              
    alex-ubuntucurl                      1/1     Running   0          15m   10.244.2.2    machine3   <none>           <none> 
    ```
    
    As expected, our new pods have a first different hash value, as they are a different version from the previous pods. Additionally, running `kubectl get deployments -o wide` should give us output like this:
    
    ```
    NAME                READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS      IMAGES                                      SELECTOR       
    alex-flaskapp-dep   3/3     3            3           14m   alex-flaskapp   192.168.33.10:5000/alex-flaskapp:version2   app=alex-flaskapp
    ```
    
    As expected, the deployment is now of the image of version 2.
14. Finally, if we look back at Terminal 2, we can see that our messages switched from that of version 1 to version 2, like this (with an intermediate period of load balancing during the switch):
    
    ```
    % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
    Dload  Upload   Total   Spent    Left  Speed                                                         
    100    68  100    68    0     0  22666      0 --:--:-- --:--:-- --:--:-- 22666
    You've hit alex-flaskapp-dep-656d4dc9c6-58bf5. Message for version 1                                                                                                                            
    % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
    Dload  Upload   Total   Spent    Left  Speed                                                         
    100    68  100    68    0     0  17000      0 --:--:-- --:--:-- --:--:-- 17000
    You've hit alex-flaskapp-dep-7f7f685fdf-pdhjd. Message for version 2                                                                                                                            
    % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
    Dload  Upload   Total   Spent    Left  Speed                                                         
    100    68  100    68    0     0   7555      0 --:--:-- --:--:-- --:--:--  7555                                                        
    You've hit alex-flaskapp-dep-656d4dc9c6-pgb4x. Message for version 1  
    
    % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
    Dload  Upload   Total   Spent    Left  Speed                                                         
    100    68  100    68    0     0  22666      0 --:--:-- --:--:-- --:--:-- 22666
    You've hit alex-flaskapp-dep-7f7f685fdf-b5vkc. Message for version 2                                                                                                                            
    % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
    Dload  Upload   Total   Spent    Left  Speed                                                         
    100    68  100    68    0     0   7555      0 --:--:-- --:--:-- --:--:--  8500
    You've hit alex-flaskapp-dep-656d4dc9c6-58bf5. Message for version 1                                                                                                                            
    % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
    Dload  Upload   Total   Spent    Left  Speed                                                         
    100    68  100    68    0     0  34000      0 --:--:-- --:--:-- --:--:-- 34000                                                        
    You've hit alex-flaskapp-dep-7f7f685fdf-pdhjd. Message for version 2  
    
    % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
    Dload  Upload   Total   Spent    Left  Speed                                                         
    100    68  100    68    0     0  22666      0 --:--:-- --:--:-- --:--:-- 22666
    You've hit alex-flaskapp-dep-7f7f685fdf-b5vkc. Message for version 2                                                                                                                            
    % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
    Dload  Upload   Total   Spent    Left  Speed                                                         
    100    68  100    68    0     0   7555      0 --:--:-- --:--:-- --:--:--  7555
    You've hit alex-flaskapp-dep-7f7f685fdf-ksqfs. Message for version 2
    ```
    
    Stop the process when desired.
