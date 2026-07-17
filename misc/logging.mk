COLOR ?= 1
ifeq ($(COLOR),1)
RESET   := \033[0m

BLACK   := \033[30m
RED     := \033[31m
GREEN   := \033[32m
YELLOW  := \033[33m
BLUE    := \033[34m
MAGENTA := \033[35m
CYAN    := \033[36m
WHITE   := \033[37m

BOLD    := \033[1m
UNDER   := \033[4m
DIM     := \033[2m
endif

define log_compile
@printf "$(GREEN)$(BOLD)%12s$(RESET) %s $(DIM)%s$(RESET)\n" "Compiling" "$(1)" "$(3)"
endef

define log_link
@printf "$(MAGENTA)$(BOLD)%12s$(RESET) %-9s $(DIM)· %s objects$(RESET)\n" "Linking" "$(1)" "$(2)"
endef
