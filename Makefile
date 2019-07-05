.PHONY: deploy deploy-prod deploy-staging \
	rm-deploy

MAKE ?= make

APP ?= observability

KUBE_LABELS ?= app=${APP},env=${ENV}
KUBE_TYPES ?= deployment,configmap,service,pvc

KUBE_APPLY ?= oc apply -f -

# deploy to ENV
deploy:
	@if [ -z "${ENV}" ]; then echo "ENV must be set"; exit 1; fi
	helm template \
		--values values.yaml \
		--values values.secrets.${ENV}.yaml \
		--set global.env=${ENV} . \
	| ${KUBE_APPLY}

# deploy to production
deploy-prod:
	${MAKE} deploy ENV=prod

# deploy to staging
deploy-staging:
	${MAKE} deploy ENV=staging

# remove deployment for ENV
rm-deploy:
	@if [ -z "${ENV}" ]; then echo "ENV must be set"; exit 1; fi
	@echo "Remove ${ENV} ${APP} deployment"
	@echo "Hit any key to confirm"
	@read confirm
	oc get -l ${KUBE_LABELS} ${KUBE_TYPES} -o yaml | oc delete -f -
