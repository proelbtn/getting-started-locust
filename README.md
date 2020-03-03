- hosts: master
  tasks:
    - name: create /opt/locust
      become: yes
      file:
        path: /opt/locust
        state: directory
    - name: copy locustfile.py 
      become: yes
      copy:
        src: /locustfile.py
        dest: /opt/locust/locustfile.py
    - name: create locust.service 
      become: yes
      template:
        src: /locust.service.master.j2
        dest: /opt/locust/locust.service
