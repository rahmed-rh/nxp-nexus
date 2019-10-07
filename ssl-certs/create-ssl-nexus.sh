rm -Rf ./ssl_certs
mkdir ./ssl_certs
cd ssl_certs
set -x

#URL will be <service_name>-<project_name>.openshift_master_default_subdomain
export URL=nexus3-nexus.apps.openshift.testcluster.nxdi.nl-htc01.nxp.com
export KEYSTORE=nexus-keystore
export TRUSTSTORE_PASSWORD=passw0rd
export KEYSTORE_PASSWORD=passw0rd


keytool -genkey -noprompt -keyalg RSA -alias nexus -dname "CN=${URL}" -keystore $KEYSTORE.jks -storepass $KEYSTORE_PASSWORD -keypass $KEYSTORE_PASSWORD -deststoretype pkcs12


keytool -export -alias nexus -keystore ${KEYSTORE}.jks -storepass $KEYSTORE_PASSWORD -file ${KEYSTORE}_cert.der
openssl x509 -inform DER -in ${KEYSTORE}_cert.der -out ${KEYSTORE}_cert.crt


openssl pkcs12 -in $KEYSTORE.jks -nocerts -nodes  -out ${KEYSTORE}.key -passin pass:$KEYSTORE_PASSWORD


#To convert a JKS (.jks) keystore to a PKCS12 (.p12) keystore
keytool -importkeystore -srckeystore ${KEYSTORE}.jks -destkeystore ${KEYSTORE}.p12 -srcstoretype JKS -deststoretype PKCS12 -srcstorepass $KEYSTORE_PASSWORD -deststorepass $KEYSTORE_PASSWORD

