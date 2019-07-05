.PHONY: deploy deploy-prod deploy-staging \
	rm-deploy

MAKE ?= make

APP ?= observability

KUBE_LABELS ?= app=${APP},env=${ENV}
KUBE_TYPES ?= dc,configmap,secret,deploy,statefulset,svc,route,is,pod,pv,pvc

KUBE_APPLY ?= oc apply -f -

# deploy to ENV
deploy:
	@if [ -z "${ENV}" ]; then echo "ENV must be set"; exit 1; fi
	helm template \
		--values deploy/values.yaml \
		--set global.env=${ENV} deploy \
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
