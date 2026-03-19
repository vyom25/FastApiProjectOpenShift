ifeq ($(OS),Windows_NT)
	VENV_BIN = .venv/Scripts
else
	VENV_BIN = .venv/bin
endif
PROMETHEUS_MULTIPROC_DIR = .metrics

.PHONY: help 
help:
	@grep -E "^[a-zA-Z_-]+.*:.*##" $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'


# ---- Dependencies ---------

$(VENV_BIN): ## Ensure virtual environment is created
	python -m venv .venv

.PHONY: debug
debug: $(VENV_BIN) ## Run in debug mode
	echo ${USERNAME} running with env from ${VENV_BIN}

requirements.txt: pyproject.toml $(VENV_BIN)## Generate requirements.txt
	${VENV_BIN}/pip-compile --output-file=requirements.txt pyproject.toml


.PHONY: deps
deps: $(VENV_BIN) ## install python deps for local dev
	${VENV_BIN}/python -m pip install -e .[dev]
	${VENV_BIN}/python -m pip install -e .[production]


.PHONY: update-deps
update-deps: $(VENV_BIN) ## update all local copies of the deps
	$(VENV_BIN)/pip-review --local --auto
	rm -f requirements.txt
	make requirements.txt

.PHONY: deps-prod
deps-prod: $(VENV_BIN) ## install python deps for production
	${VENV_BIN}/python -m pip install --no-deps -r requirements.txt
	${VENV_BIN}/python -m pip install -e .[production]

.PHONY: build-app
build-app: $(VENV_BIN) ## Build the application for production
	${VENV_BIN}/python -m pip install .


.PHONY: run
run: $(VENV_BIN) ## run app on port 8080
	${VENV_BIN}/uvicorn myapp.webapp:app --reload --port 8080

.PHONY: test
test: $(VENV_BIN) ## run tests
	${VENV_BIN}/pytest tests/

.PHONY: unit
unit: $(VENV_BIN) ## run unit tests
	${VENV_BIN}/pytest tests/unit/




	


