# source("test/test-optim.R")
devtools::load_all()

x = c(0, 0)
RGNoptim2(x, func_obj, func_res)
