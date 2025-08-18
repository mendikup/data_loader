
REM Deployment MySQL:
REM  Secret (user/password/root_password/database)
oc apply -f data_loader\infrastructure\open_shift\SQL\mysql-secret.yaml

REM  PVC (PersistentVolumeClaim)
oc apply -f data_loader\infrastructure\open_shift\SQL\mysql-pvc.yaml

REM  Service (ClusterIP on 3306)
oc apply -f data_loader\infrastructure\open_shift\SQL\mysql-service.yaml

REM  Deployment (basic variant)
oc apply -f data_loader\infrastructure\open_shift\SQL\mysql-deployment.yaml

REM  Wait until MySQL is ready (pod running/ready)
oc rollout status deployment/mysql

REM  Check endpoints (should NOT be empty)
oc get endpoints mysql -o wide

REM  Find MySQL pod name (copy the exact name from the output)
oc get pods -l app=mysql



REM  #Copy SQL files into the pod
oc cp data_loader\scripts\SQL\create_data.sql data-loader-6d4bc6f5cc-4vs6w:/tmp/create_data.sql
oc cp data_loader\scripts\SQL\data_insert.sql data-loader-6d4bc6f5cc-4vs6w:/tmp/data_insert.sql

REM # Docker Building

REM Build image
docker build -t mendikup25/data-loader:latest .

REM Push to Docker Hub
docker push mendikup25/data-loader:latest


oc get pods -l app=mysql
oc cp scripts/SQL/create_data.sql <mysql-pod>:/tmp/create_data.sql
oc cp scripts/SQL/data_insert.sql <mysql-pod>:/tmp/data_insert.sql

REM 🛠 Run SQL scripts using root password from env inside the container
oc rsh data-loader-6d4bc6f5cc-4vs6w sh -c "mysql -u root -p\"$MYSQL_ROOT_PASSWORD\" mydb < /tmp/create_data.sql"
oc rsh data-loader-6d4bc6f5cc-4vs6w sh -c "mysql -u root -p\"$MYSQL_ROOT_PASSWORD\" mydb < /tmp/data_insert.sql"

REM Show tables and row count (should include `data` and ~5 rows)
oc rsh data-loader-6d4bc6f5cc-4vs6w sh -c "mysql -u root -p\"$MYSQL_ROOT_PASSWORD\" mydb -e \"SHOW TABLES; SELECT COUNT(*) AS rows_in_data FROM data;\""


REM  Service for the app (port 8000)
oc apply -f data_loader\infrastructure\open_shift\python_app\my_app_service.yaml

REM  Deployment for the app (uses mendikup25/data-loader:latest)
oc apply -f data_loader\infrastructure\open_shift\python_app\my_app_deployment.yaml

REM  Ensure the Deployment becomes ready
oc rollout status deployment/data-loader

REM  Inspect recent logs (uvicorn should be listening on 0.0.0.0:8000)
oc logs deploy/data-loader --tail=50

REM  Create/Apply Route (HTTP)
oc apply -f data_loader\infrastructure\open_shift\python_app\route.yaml

REM  Test the endpoint (expects JSON with the rows from `data` table)
curl http://data-loader-6d4bc6f5cc-4vs6w/get_data