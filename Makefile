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

# Default target
all: check_deps build_native

# Check and install missing dependencies
check_deps:
	@for lib in $(LIBS); do \
		if ! $(OPAM) list --installed --short | grep -q "^$$lib$$"; then \
			echo "Installing missing library: $$lib"; \
			$(OPAM) install -y $$lib; \
		fi \
	done

# Build native executable with ocamlopt
build_native: $(SOURCES)
	$(OCAMLOPT) $(OCAMLFLAGS) -o $(EXECUTABLE) $(SOURCES)

# Build bytecode executable with ocamlc
build_bytecode: $(SOURCES)
	$(OCAMLC) $(OCAMLFLAGS) -o $(EXECUTABLE).byte $(SOURCES)

# Clean build files
clean:
	rm -f $(CMOS) $(CMIS) $(CMXS) $(OS)

# Full clean (clean + executable files)
fclean: clean
	rm -f $(EXECUTABLE) $(EXECUTABLE).byte

# Phony targets
.PHONY: all check_deps build_native build_bytecode clean fclean
