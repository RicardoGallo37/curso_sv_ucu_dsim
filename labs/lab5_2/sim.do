# Adding waves
add wave -recursive -depth 3 *
# list all signals in decimal format
add list -decimal *
#change radix to symbolic
radix -symbolic
#Run simulation
run -all
# quit the simulation
quit -f
