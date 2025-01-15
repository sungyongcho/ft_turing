EXECUTABLE = ft_turing

SOURCES	=	types.ml \
			print_machine.ml \
			executer.ml \
			parser.ml \
			main.ml

BIN_DIR = bin

LIBS = yojson

# Compiler and linker flags
OCAMLFLAGS = -thread
PKGFLAGS = $(foreach lib,$(LIBS),-package $(lib)) -linkpkg
INCLUDE_DIRS = -I $(BIN_DIR)

# Derived variables
CMOS = $(addprefix $(BIN_DIR)/, $(SOURCES:.ml=.cmo))
CMIS = $(addprefix $(BIN_DIR)/, $(SOURCES:.ml=.cmi))
CMXS = $(addprefix $(BIN_DIR)/, $(SOURCES:.ml=.cmx))
OS = $(addprefix $(BIN_DIR)/, $(SOURCES:.ml=.o))

# Commands
OCAMLFIND = ocamlfind
OCAMLC = $(OCAMLFIND) ocamlc
OCAMLOPT = $(OCAMLFIND) ocamlopt
OPAM = opam

all: check_deps build_native

check_deps:
	@if ! command -v ocamlfind >/dev/null 2>&1; then \
	  echo "Installing missing tool: ocamlfind"; \
	  $(OPAM) install -y ocamlfind; \
	fi
	@for lib in $(LIBS); do \
	  if ! $(OPAM) list --installed --short | grep -q "^$$lib$$"; then \
	    echo "Installing missing library: $$lib"; \
	    $(OPAM) install -y $$lib; \
	  fi; \
	done


build_native: $(CMXS)
	$(OCAMLOPT) $(OCAMLFLAGS) $(PKGFLAGS) $(INCLUDE_DIRS) -o $(EXECUTABLE) $^

build_bytecode: $(CMOS)
	$(OCAMLC) $(OCAMLFLAGS) $(PKGFLAGS) $(INCLUDE_DIRS) -o $(EXECUTABLE).byte $^

%.cmo: %.ml
	$(OCAMLC) $(OCAMLFLAGS) $(PKGFLAGS) $(INCLUDE_DIRS) -c $<

%.cmi: %.ml
	$(OCAMLC) $(OCAMLFLAGS) $(PKGFLAGS) $(INCLUDE_DIRS) -c $<

%.cmx: %.ml
	$(OCAMLOPT) $(OCAMLFLAGS) $(PKGFLAGS) $(INCLUDE_DIRS) -c $<

clean:
	rm -f $(CMOS) $(CMIS) $(CMXS) $(OS)

fclean: clean
	rm -f $(EXECUTABLE) $(EXECUTABLE).byte

re: fclean all

.PHONY: all check_deps build_native build_bytecode clean fclean re
