# Variables
SOURCES = src/main.ml
EXECUTABLE = ft_turing
LIBS = batteries yojson
OCAMLFLAGS = -thread

# Convert LIBS into package flags
PKGFLAGS = $(addprefix -package ,$(LIBS)) -linkpkg

# Derived variables
CMOS = ${SOURCES:.ml=.cmo}
CMIS = ${SOURCES:.ml=.cmi}
CMXS = ${SOURCES:.ml=.cmx}
OS = ${SOURCES:.ml=.o}

# Commands
OCAMLFIND = ocamlfind
OCAMLC = $(OCAMLFIND) ocamlc
OCAMLOPT = $(OCAMLFIND) ocamlopt
OPAM = opam

all: check_deps build_native

check_deps:
	@for lib in $(LIBS); do \
	  if ! $(OPAM) list --installed --short | grep -q "^$$lib$$"; then \
	    echo "Installing missing library: $$lib"; \
	    $(OPAM) install -y $$lib; \
	  fi \
	done

build_native: $(SOURCES)
	$(OCAMLOPT) $(OCAMLFLAGS) $(PKGFLAGS) -o $(EXECUTABLE) $(SOURCES)

build_bytecode: $(SOURCES)
	$(OCAMLC) $(OCAMLFLAGS) $(PKGFLAGS) -o $(EXECUTABLE).byte $(SOURCES)

clean:
	rm -f $(CMOS) $(CMIS) $(CMXS) $(OS)

fclean: clean
	rm -f $(EXECUTABLE) $(EXECUTABLE).byte

re: fclean all

.PHONY: all check_deps build_native build_bytecode clean fclean re
