# Variables
SOURCES = src/main.ml
EXECUTABLE = ft_turing
LIBS = batteries yojson
OCAMLFLAGS = -g

# Derived variables
CMOS = ${SOURCES:.ml=.cmo}
CMIS = ${SOURCES:.ml=.cmi}
CMXS = ${SOURCES:.ml=.cmx}
OS = ${SOURCES:.ml=.o}

# Commands
OCAMLC = ocamlc
OCAMLOPT = ocamlopt
OPAM = opam

all: check_deps build_native

# Check and install missing dependencies
check_deps:
	@for lib in $(LIBS); do \
		if ! $(OPAM) list --installed --short | grep -q "^$$lib$$"; then \
			echo "Installing missing library: $$lib"; \
			$(OPAM) install -y $$lib; \
		fi \
	done

build_native: $(SOURCES)
	$(OCAMLOPT) $(OCAMLFLAGS) -o $(EXECUTABLE) $(SOURCES)

build_bytecode:	$(SOURCES)
	$(OCAMLC) $(OCAMLFLAGS) -o $(EXECUTABLE).byte $(SOURCES)

# Clean build files
clean:
	rm -f $(CMOS) $(CMIS) $(CMXS) $(OS)

fclean:	clean
	rm -f $(EXECUTABLE) $(EXECUTABLE).byte

re:	fclean all

# Phony targets
.PHONY: all check_deps build_native build_bytecode clean fclean
