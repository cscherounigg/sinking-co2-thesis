# CASE 02 - FRACTURE NETWORK
# C. Scherounigg
# Master Thesis 2024
# Conductive heat transfer between fracture network and matrix
# Parameters
conductive_heat_transfer = true
mass_transfer = false
enable_production = true
gravitational_acceleration = -9.81 # m/s²
initial_pressure_water = 25.0e6 # Pa
initial_pressure_gas = 25.1e6 # Pa
initial_temperature = 773.15 # K
injection_pressure = 35e6 # Pa
injection_temperature = 373.15 # K
production_pressure = 23e6 # Pa
injection_point = '100 400 -2500'
production_point = '700 400 -2500'
water_fluid_properties = eos_water # Options: tabulated_water, eos_water
gas_fluid_properties = eos_gas # Options: tabulated_gas, eos_gas
simulation_time = 9.4608e8 # s; 30 years
permeability = 1e-14 # m²
porosity = 0.001
thermal_conductivity = 0.1e-3 # W/(mK)
output_only_selected_timesteps = true
# Script
[Mesh]
  uniform_refine = 0
  [fracture_network]
    type = FileMeshGenerator
    file = 'network.msh'
  []
[]
[GlobalParams]
  PorousFlowDictator = dictator
[]
[Functions]
[]
[Variables]
  [fracture_pressure_water]
    initial_condition = ${initial_pressure_water}
  []
  [fracture_temperature]
    initial_condition = ${initial_temperature}
    #scaling = 1e-6
  []
  [fracture_pressure_gas]
    initial_condition = ${initial_pressure_gas}
  []
[]
[Kernels]
  [fracture_mass_water_dot]
    type = PorousFlowMassTimeDerivative
    fluid_component = 0
    variable = fracture_pressure_water
  []
  [fracture_flux_water]
    type = PorousFlowAdvectiveFlux
    fluid_component = 0
    variable = fracture_pressure_water
    gravity = '0 0 ${gravitational_acceleration}'
  []
  [fracture_mass_gas_dot]
    type = PorousFlowMassTimeDerivative
    fluid_component = 1
    variable = fracture_pressure_gas
  []
  [fracture_flux_gas]
    type = PorousFlowAdvectiveFlux
    fluid_component = 1
    variable = fracture_pressure_gas
    gravity = '0 0 ${gravitational_acceleration}'
  []
  [energy_dot]
    type = PorousFlowEnergyTimeDerivative
    variable = fracture_temperature
  []
  [advection]
    type = PorousFlowHeatAdvection
    variable = fracture_temperature
    gravity = '0 0 ${gravitational_acceleration}'
  []
  [conduction]
    type = PorousFlowHeatConduction
    variable = fracture_temperature
  []
  [heat_to_matrix]
    # Transfer heat to matrix (Transfer Step 8a)
    type = PorousFlowHeatMassTransfer
    variable = fracture_temperature
    v = matrix_temperature_transfer
    transfer_coefficient = heat_transfer_coefficient
    save_in = heat_transfer_rate # Heat transfer rate in W.
    enable = ${conductive_heat_transfer}
  []
  [water_to_matrix]
    # Transfer mass of water to matrix (Transfer Step 8b)
    type = PorousFlowHeatMassTransfer
    variable = fracture_pressure_water
    v = matrix_pressure_water_transfer
    transfer_coefficient = mass_transfer_coefficient_water
    save_in = mass_flux_water # Mass flux in kg/(m²s).
    enable = ${mass_transfer}
  []
  [gas_to_matrix]
    # Transfer mass of gas to matrix (Transfer Step 8c)
    type = PorousFlowHeatMassTransfer
    variable = fracture_pressure_gas
    v = matrix_pressure_gas_transfer
    transfer_coefficient = mass_transfer_coefficient_gas
    save_in = mass_flux_gas # Mass flux in kg/(m²s).
    enable = ${mass_transfer}
  []
[]
[DiracKernels]
  # [injection]
  #   type = PorousFlowSquarePulsePointSource
  #   mass_flux = ${injection_rate}
  #   point = ${injection_point}
  #   variable = fracture_pressure_gas
  # []
  [gas_injection]
    type = PorousFlowPeacemanBorehole
    SumQuantityUO = mass_gas_injected
    variable = fracture_pressure_gas
    function_of = pressure
    bottom_p_or_t = ${injection_pressure}
    character = -1
    line_length = 1
    point_file = injector.traj
    unit_weight = '0 0 0'
    fluid_phase = 1
    use_mobility = true
    #point_not_found_behavior = WARNING
  []
  [water_production]
    type = PorousFlowPeacemanBorehole
    SumQuantityUO = mass_water_produced
    variable = fracture_pressure_water
    function_of = pressure
    bottom_p_or_t = ${production_pressure}
    character = 1
    line_length = 1
    point_file = producer.traj
    unit_weight = '0 0 0'
    fluid_phase = 0
    use_mobility = true
    enable = ${enable_production}
    #point_not_found_behavior = WARNING
  []
  [gas_production]
    type = PorousFlowPeacemanBorehole
    SumQuantityUO = mass_gas_produced
    variable = fracture_pressure_gas
    function_of = pressure
    bottom_p_or_t = ${production_pressure}
    character = 1
    line_length = 1
    point_file = producer.traj
    unit_weight = '0 0 0'
    fluid_phase = 1
    use_mobility = true
    enable = ${enable_production}
    #point_not_found_behavior = WARNING
  []
  [heat_production_water]
    type = PorousFlowPeacemanBorehole
    SumQuantityUO = heat_water_produced
    variable = fracture_temperature
    function_of = pressure
    bottom_p_or_t = ${production_pressure}
    character = 1
    line_length = 1
    point_file = producer.traj
    unit_weight = '0 0 0'
    fluid_phase = 0
    use_mobility = true
    use_enthalpy = true
    enable = ${enable_production}
    #point_not_found_behavior = WARNING
  []
  [heat_production_gas]
    type = PorousFlowPeacemanBorehole
    SumQuantityUO = heat_gas_produced
    variable = fracture_temperature
    function_of = pressure
    bottom_p_or_t = ${production_pressure}
    character = 1
    line_length = 1
    point_file = producer.traj
    unit_weight = '0 0 0'
    fluid_phase = 1
    use_mobility = true
    use_enthalpy = true
    enable = ${enable_production}
    #point_not_found_behavior = WARNING
  []
[]
[AuxVariables]
  [fracture_massfraction_ph0_sp0]
    initial_condition = 1
  []
  [fracture_massfraction_ph1_sp0]
    initial_condition = 0
  []
  [fracture_massfraction_ph0_sp1]
  []
  [fracture_massfraction_ph1_sp1]
  []
  [fracture_saturation_gas]
    order = FIRST
    family = MONOMIAL
  []
  [fracture_saturation_water]
    order = FIRST
    family = MONOMIAL
  []
  [fracture_density_water]
    order = CONSTANT
    family = MONOMIAL
  []
  [fracture_density_gas]
    order = CONSTANT
    family = MONOMIAL
  []
  [fracture_viscosity_water]
    order = CONSTANT
    family = MONOMIAL
  []
  [fracture_viscosity_gas]
    order = CONSTANT
    family = MONOMIAL
  []
  [fracture_enthalpy_gas]
    order = CONSTANT
    family = MONOMIAL
  []
  [fracture_enthalpy_water]
    order = CONSTANT
    family = MONOMIAL
  []
  [matrix_temperature_transfer]
    initial_condition = ${initial_temperature}
    enable = ${conductive_heat_transfer}
  []
  [matrix_pressure_water_transfer]
    initial_condition = ${initial_pressure_water}
    enable = ${mass_transfer}
  []
  [matrix_pressure_gas_transfer]
    initial_condition = ${initial_pressure_gas}
    enable = ${mass_transfer}
  []
  [heat_transfer_coefficient]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 0.0
    enable = ${conductive_heat_transfer}
  []
  [mass_transfer_coefficient_water]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 0.0
    enable = ${mass_transfer}
  []
  [mass_transfer_coefficient_gas]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 0.0
    enable = ${mass_transfer}
  []
  [element_normal_length]
    order = CONSTANT
    family = MONOMIAL
  []
  [element_normal_thermal_conductivity]
    order = CONSTANT
    family = MONOMIAL
  []
  [element_normal_permeability]
    order = CONSTANT
    family = MONOMIAL
  []
  [element_normal_rho_k_krel_over_mu]
    order = CONSTANT
    family = MONOMIAL
  []
  [heat_transfer_rate]
    initial_condition = 0.0
  []
  [mass_flux_water]
    initial_condition = 0.0
  []
  [mass_flux_gas]
    initial_condition = 0.0
  []
  [normal_dir_x]
    order = CONSTANT
    family = MONOMIAL
  []
  [normal_dir_y]
    order = CONSTANT
    family = MONOMIAL
  []
  [normal_dir_z]
    order = CONSTANT
    family = MONOMIAL
  []
  [rho_water_times_gravity]
    order = CONSTANT
    family = MONOMIAL
  []
  [relative_permeability_water_aux]
    order = CONSTANT
    family = MONOMIAL
  []
  [relative_permeability_gas_aux]
    order = CONSTANT
    family = MONOMIAL
  []
  [one]
    order = CONSTANT
    family = MONOMIAL
  []
[]
[AuxKernels]
  [normal_dir_x_auxkernel]
    # Calculate normal vector of fracture (Transfer Step 1)
    type = PorousFlowElementNormal
    variable = normal_dir_x
    component = x
  []
  [normal_dir_y_auxkernel]
    # Calculate normal vector of fracture (Transfer Step 1)
    type = PorousFlowElementNormal
    variable = normal_dir_y
    component = y
  []
  [normal_dir_z_auxkernel]
    # Calculate normal vector of fracture (Transfer Step 1)
    type = PorousFlowElementNormal
    variable = normal_dir_z
    component = z
  []
  [fracture_saturation_gas]
    type = PorousFlowPropertyAux
    property = saturation
    phase = 1
    variable = fracture_saturation_gas
  []
  [fracture_saturation_water]
    type = PorousFlowPropertyAux
    property = saturation
    phase = 0
    variable = fracture_saturation_water
  []
  [fracture_enthalpy_gas]
    type = PorousFlowPropertyAux
    property = enthalpy
    phase = 1
    variable = fracture_enthalpy_gas
  []
  [fracture_enthalpy_water]
    type = PorousFlowPropertyAux
    property = enthalpy
    phase = 0
    variable = fracture_enthalpy_water
  []
  [fracture_density_water]
    type = PorousFlowPropertyAux
    property = density
    phase = 0
    variable = fracture_density_water
  []
  [fracture_density_gas]
    type = PorousFlowPropertyAux
    property = density
    phase = 1
    variable = fracture_density_gas
  []
  [fracture_viscosity_water]
    type = PorousFlowPropertyAux
    property = viscosity
    phase = 0
    variable = fracture_viscosity_water
  []
  [fracture_viscosity_gas]
    type = PorousFlowPropertyAux
    property = viscosity
    phase = 1
    variable = fracture_viscosity_gas
  []
  [heat_transfer_coefficient_auxkernel]
    # Calculate heat transfer coefficient (Transfer Step 6a)
    type = ParsedAux
    variable = heat_transfer_coefficient
    coupled_variables = 'element_normal_length element_normal_thermal_conductivity'
    constant_names = h_s
    constant_expressions = 1e3
    expression = 'if(element_normal_length = 0, 0, h_s * element_normal_thermal_conductivity * 2 * element_normal_length / (h_s * element_normal_length * element_normal_length * element_normal_thermal_conductivity * 2 * element_normal_length))'
    enable = ${conductive_heat_transfer}
  []
  [mass_transfer_coefficient_water_auxkernel]
    # Calculate mass transfer coefficient for water (Transfer Step 6b)
    type = ParsedAux
    variable = mass_transfer_coefficient_water
    coupled_variables = 'element_normal_length element_normal_permeability fracture_density_water fracture_viscosity_water relative_permeability_water_aux'
    expression = 'if(element_normal_length = 0, 0, 2 * fracture_density_water * element_normal_permeability * relative_permeability_water_aux / (fracture_viscosity_water * element_normal_length))'
    #coupled_variables = 'element_normal_rho_k_krel_over_mu element_normal_length'
    #expression = 'if(element_normal_length = 0, 0, 2 / element_normal_length * element_normal_rho_k_krel_over_mu)'
    enable = ${mass_transfer}
  []
  [mass_transfer_coefficient_gas_auxkernel]
    # Calculate mass transfer coefficient for gas (Transfer Step 6c)
    type = ParsedAux
    variable = mass_transfer_coefficient_gas
    coupled_variables = 'element_normal_length element_normal_permeability fracture_density_gas fracture_viscosity_gas relative_permeability_gas_aux'
    expression = 'if(element_normal_length = 0, 0, 2 * fracture_density_gas * element_normal_permeability * relative_permeability_gas_aux / (fracture_viscosity_gas * element_normal_length))'
    enable = ${mass_transfer}
  []
  [relative_permeability_water_material_aux]
    # Use relative permeability material property as AuxVariable
    type = MaterialRealAux
    property = PorousFlow_relative_permeability_qp0
    variable = relative_permeability_water_aux
  []
  [relative_permeability_gas_material_aux]
    # Use relative permeability material property as AuxVariable
    type = MaterialRealAux
    property = PorousFlow_relative_permeability_qp1
    variable = relative_permeability_gas_aux
  []
  [one]
    type = ConstantAux
    variable = one
    value = 1
  []
[]
[Materials]
  [fracture_temperature]
    type = PorousFlowTemperature
    temperature = fracture_temperature
  []
  [pore_pressures]
    type = PorousFlow2PhasePP
    phase0_porepressure = fracture_pressure_water
    phase1_porepressure = fracture_pressure_gas
    capillary_pressure = capillary_pressure
  []
  [massfrac]
    type = PorousFlowMassFraction
    mass_fraction_vars = 'fracture_massfraction_ph0_sp0 fracture_massfraction_ph1_sp0'
  []
  [water]
    type = PorousFlowSingleComponentFluid
    fp = ${water_fluid_properties} # Fluid properties
    phase = 0
  []
  [gas]
    type = PorousFlowSingleComponentFluid
    fp = ${gas_fluid_properties} # Fluid properties
    phase = 1
  []
  [relative_permeability_water]
    type = PorousFlowRelativePermeabilityCorey
    n = 2
    phase = 0
    s_res = 0.1
    sum_s_res = 0.1
  []
  [relative_permeability_gas]
    type = PorousFlowRelativePermeabilityCorey
    n = 2
    phase = 1
  []
  [porosity]
    type = PorousFlowPorosityConst # To supply initial value
    porosity = ${porosity}
  []
  [biot_modulus]
    type = PorousFlowConstantBiotModulus
    solid_bulk_compliance = 1E-10
    fluid_bulk_modulus = 2E9
  []
  [permeability]
    type = PorousFlowPermeabilityConst
    permeability = '${permeability} 0 0   0 ${permeability} 0   0 0 ${permeability}'
  []
  [thermal_expansion]
    type = PorousFlowConstantThermalExpansionCoefficient
    fluid_coefficient = 5E-6
    drained_coefficient = 2E-4
  []
  [thermal_conductivity]
    type = PorousFlowThermalConductivityIdeal
    dry_thermal_conductivity = '${thermal_conductivity} 0 0  0 ${thermal_conductivity} 0  0 0 ${thermal_conductivity}'
  []
  [rock_heat]
    type = PorousFlowMatrixInternalEnergy
    density = 2500.0
    specific_heat_capacity = 0
  []
  [effective_fluid_pressure]
    type = PorousFlowEffectiveFluidPressure
  []
[]
[FluidProperties]
  [eos_water]
    type = Water97FluidProperties
  []
  [eos_gas]
    type = CO2FluidProperties
  []
  [tabulated_water]
    type = TabulatedBicubicFluidProperties
    fp = eos_water
    fluid_property_file = fluid_properties_water.csv
    interpolated_properties = 'density enthalpy internal_energy viscosity'
    temperature_min = 300 # K
    temperature_max = 900 # K
    pressure_min = 5e6 # Pa
    pressure_max = 50e6 # Pa
    num_T = 100
    num_p = 100
    error_on_out_of_bounds = False
  []
  [tabulated_gas]
    type = TabulatedBicubicFluidProperties
    fp = eos_gas
    fluid_property_file = fluid_properties_gas.csv
    interpolated_properties = 'density enthalpy internal_energy viscosity'
    temperature_min = 300 # K
    temperature_max = 900 # K
    pressure_min = 5e6 # Pa
    pressure_max = 50e6 # Pa
    num_T = 100
    num_p = 100
    error_on_out_of_bounds = False
  []
[]
[UserObjects]
  [mass_water_produced]
    type = PorousFlowSumQuantity
  []
  [mass_gas_produced]
    type = PorousFlowSumQuantity
  []
  [mass_gas_injected]
    type = PorousFlowSumQuantity
  []
  [heat_water_produced]
    type = PorousFlowSumQuantity
  []
  [heat_gas_produced]
    type = PorousFlowSumQuantity
  []
  [dictator]
    type = PorousFlowDictator
    porous_flow_vars = 'fracture_pressure_water fracture_temperature fracture_pressure_gas'
    number_fluid_phases = 2
    number_fluid_components = 2
  []
  [capillary_pressure]
    type = PorousFlowCapillaryPressureVG
    alpha = 1e-6
    m = 0.6
    s_scale = 0.9
  []
[]
[BCs]
  [injection_temperature]
    type = DirichletBC
    variable = fracture_temperature
    value = ${injection_temperature}
    boundary = 'injection_node'
  []
[]
[ICs]
  [injection_temperature]
    type = ConstantIC
    variable = fracture_temperature
    value = ${injection_temperature}
    boundary = 'injection_node'
  []
[]
[Functions]
  [mass_rate_water_production]
    type = ParsedFunction
    symbol_values = 'dt mass_water_produced_pp'
    symbol_names = 'dt mass_water_produced_pp'
    expression = 'mass_water_produced_pp/dt'
  []
  [mass_rate_gas_production]
    type = ParsedFunction
    symbol_values = 'dt mass_gas_produced_pp'
    symbol_names = 'dt mass_gas_produced_pp'
    expression = 'mass_gas_produced_pp/dt'
  []
  [mass_rate_gas_injection]
    type = ParsedFunction
    symbol_values = 'dt mass_gas_injected_pp'
    symbol_names = 'dt mass_gas_injected_pp'
    expression = 'mass_gas_injected_pp/dt'
  []
[]
[Postprocessors]
  [dt]
    type = TimestepSize
    outputs = 'none'
  []
  [heat_water_produced_pp]
    type = PorousFlowPlotQuantity
    uo = heat_water_produced
    outputs = csv
  []
  [heat_gas_produced_pp]
    type = PorousFlowPlotQuantity
    uo = heat_gas_produced
    outputs = csv
  []
  [mass_gas_injected_pp]
    type = PorousFlowPlotQuantity
    uo = mass_gas_injected
    outputs = csv
  []
  [mass_water_produced_pp]
    type = PorousFlowPlotQuantity
    uo = mass_water_produced
    outputs = csv
  []
  [mass_gas_produced_pp]
    type = PorousFlowPlotQuantity
    uo = mass_gas_produced
    outputs = csv
  []
  [mass_rate_water_production]
    type = FunctionValuePostprocessor
    function = mass_rate_water_production
    outputs = csv
  []
  [mass_rate_gas_production]
    type = FunctionValuePostprocessor
    function = mass_rate_gas_production
    outputs = csv
  []
  [mass_rate_gas_injection]
    type = FunctionValuePostprocessor
    function = mass_rate_gas_injection
    outputs = csv
  []
  [production_saturation_gas]
    type = PointValue
    point = ${production_point}
    variable = fracture_saturation_gas
    outputs = csv
  []
  [injection_saturation_gas]
    type = PointValue
    point = ${injection_point}
    variable = fracture_saturation_gas
    outputs = csv
  []
  [production_pressure_water]
    type = PointValue
    point = ${production_point}
    variable = fracture_pressure_water
    outputs = csv
  []
  [production_pressure_gas]
    type = PointValue
    point = ${production_point}
    variable = fracture_pressure_gas
    outputs = csv
  []
  [injection_pressure_gas]
    type = PointValue
    point = ${production_point}
    variable = fracture_pressure_gas
    outputs = csv
  []
  [injection_density_gas]
    type = PointValue
    point = ${injection_point}
    variable = fracture_density_gas
    outputs = csv
  []
  [injection_density_water]
    type = PointValue
    point = ${injection_point}
    variable = fracture_density_water
    outputs = csv
  []
  [injection_temperature]
    type = PointValue
    point = ${injection_point}
    variable = fracture_temperature
    outputs = csv
  []
  [injection_viscosity_water]
    type = PointValue
    point = ${injection_point}
    variable = fracture_viscosity_water
    outputs = csv
  []
  [injection_viscosity_gas]
    type = PointValue
    point = ${injection_point}
    variable = fracture_viscosity_gas
    outputs = csv
  []
  [injection_enthalpy_water]
    type = PointValue
    point = ${injection_point}
    variable = fracture_enthalpy_water
    outputs = csv
  []
  [injection_enthalpy_gas]
    type = PointValue
    point = ${injection_point}
    variable = fracture_enthalpy_gas
    outputs = csv
  []
  [total_area]
    type = ElementIntegralVariablePostprocessor
    variable = one
    outputs = csv
  []
  [gas_swept_area]
    type = ElementIntegralVariablePostprocessor
    variable = fracture_saturation_gas
    outputs = csv
  []
[]
[VectorPostprocessors]
  # Send heat to matrix (Transfer Step 9a)
  [heat_transfer_rate]
    type = NodalValueSampler
    outputs = none
    sort_by = id
    variable = heat_transfer_rate
    enable = ${conductive_heat_transfer}
  []
  # Send mass of water to matrix (Transfer Step 9b)
  [mass_flux_water]
    type = NodalValueSampler
    outputs = none
    sort_by = id
    variable = mass_flux_water
    enable = ${mass_transfer}
  []
  # Send mass of gas to matrix (Transfer Step 9b)
  [mass_flux_gas]
    type = NodalValueSampler
    outputs = none
    sort_by = id
    variable = mass_flux_gas
    enable = ${mass_transfer}
  []
[]
[Preconditioning]
  active = preferred_but_might_not_be_installed
  [basic]
    type = SMP
    full = true
    petsc_options = '-ksp_diagonal_scale -ksp_diagonal_scale_fix'
    petsc_options_iname = '-pc_type -sub_pc_type -sub_pc_factor_shift_type -pc_asm_overlap'
    petsc_options_value = ' asm      lu           NONZERO                   2'
  []
  [preferred_but_might_not_be_installed]
    type = SMP
    full = true
    petsc_options = ''
    petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
    petsc_options_value = ' lu       mumps                       '
  []
[]
[Executioner]
  type = Transient
  solve_type = NEWTON
  end_time = ${simulation_time}
  nl_max_its = 15 # Maximum number of non-linear iterations
  l_max_its = 1000
  nl_abs_tol = 1e-3
  automatic_scaling = true
  compute_scaling_once = true
  [TimeStepper]
    type = IterationAdaptiveDT
    optimal_iterations = 10
    dt = 1
    growth_factor = 1.5
    cutback_factor = 0.5
  []
[]
[Outputs]
  print_linear_residuals = false
  checkpoint = false # Create checkpoint files for recovering simulation
  [ex]
    type = Exodus
    sync_times = '0.000000e+00 4.320000e+05 8.640000e+05 1.296000e+06 1.728000e+06 2.160000e+06 2.592000e+06 3.024000e+06 3.456000e+06 3.888000e+06 4.320000e+06 4.752000e+06 5.184000e+06 5.616000e+06 6.048000e+06 6.480000e+06 6.912000e+06 7.344000e+06 7.776000e+06 8.208000e+06 8.640000e+06 9.072000e+06 9.504000e+06 9.936000e+06 1.036800e+07 1.080000e+07 1.123200e+07 1.166400e+07 1.209600e+07 1.252800e+07 1.296000e+07 1.339200e+07 1.382400e+07 1.425600e+07 1.468800e+07 1.512000e+07 1.555200e+07 1.598400e+07 1.641600e+07 1.684800e+07 1.728000e+07 1.771200e+07 1.814400e+07 1.857600e+07 1.900800e+07 1.944000e+07 1.987200e+07 2.030400e+07 2.073600e+07 2.116800e+07 2.160000e+07 2.203200e+07 2.246400e+07 2.289600e+07 2.332800e+07 2.376000e+07 2.419200e+07 2.462400e+07 2.505600e+07 2.548800e+07 2.592000e+07 2.635200e+07 2.678400e+07 2.721600e+07 2.764800e+07 2.808000e+07 2.851200e+07 2.894400e+07 2.937600e+07 2.980800e+07 3.024000e+07 3.067200e+07 3.110400e+07 3.153600e+07 3.196800e+07 3.240000e+07 3.283200e+07 3.326400e+07 3.369600e+07 3.412800e+07 3.456000e+07 3.499200e+07 3.542400e+07 3.585600e+07 3.628800e+07 3.672000e+07 3.715200e+07 3.758400e+07 3.801600e+07 3.844800e+07 3.888000e+07 3.931200e+07 3.974400e+07 4.017600e+07 4.060800e+07 4.104000e+07 4.147200e+07 4.190400e+07 4.233600e+07 4.276800e+07 4.320000e+07 4.363200e+07 4.406400e+07 4.449600e+07 4.492800e+07 4.536000e+07 4.579200e+07 4.622400e+07 4.665600e+07 4.708800e+07 4.752000e+07 4.795200e+07 4.838400e+07 4.881600e+07 4.924800e+07 4.968000e+07 5.011200e+07 5.054400e+07 5.097600e+07 5.140800e+07 5.184000e+07 5.227200e+07 5.270400e+07 5.313600e+07 5.356800e+07 5.400000e+07 5.443200e+07 5.486400e+07 5.529600e+07 5.572800e+07 5.616000e+07 5.659200e+07 5.702400e+07 5.745600e+07 5.788800e+07 5.832000e+07 5.875200e+07 5.918400e+07 5.961600e+07 6.004800e+07 6.048000e+07 6.091200e+07 6.134400e+07 6.177600e+07 6.220800e+07 6.264000e+07 6.307200e+07 6.350400e+07 6.393600e+07 6.436800e+07 6.480000e+07 6.523200e+07 6.566400e+07 6.609600e+07 6.652800e+07 6.696000e+07 6.739200e+07 6.782400e+07 6.825600e+07 6.868800e+07 6.912000e+07 6.955200e+07 6.998400e+07 7.041600e+07 7.084800e+07 7.128000e+07 7.171200e+07 7.214400e+07 7.257600e+07 7.300800e+07 7.344000e+07 7.387200e+07 7.430400e+07 7.473600e+07 7.516800e+07 7.560000e+07 7.603200e+07 7.646400e+07 7.689600e+07 7.732800e+07 7.776000e+07 7.819200e+07 7.862400e+07 7.905600e+07 7.948800e+07 7.992000e+07 8.035200e+07 8.078400e+07 8.121600e+07 8.164800e+07 8.208000e+07 8.251200e+07 8.294400e+07 8.337600e+07 8.380800e+07 8.424000e+07 8.467200e+07 8.510400e+07 8.553600e+07 8.596800e+07 8.640000e+07 8.683200e+07 8.726400e+07 8.769600e+07 8.812800e+07 8.856000e+07 8.899200e+07 8.942400e+07 8.985600e+07 9.028800e+07 9.072000e+07 9.115200e+07 9.158400e+07 9.201600e+07 9.244800e+07 9.288000e+07 9.331200e+07 9.374400e+07 9.417600e+07 9.460800e+07 9.504000e+07 9.547200e+07 9.590400e+07 9.633600e+07 9.676800e+07 9.720000e+07 9.763200e+07 9.806400e+07 9.849600e+07 9.892800e+07 9.936000e+07 9.979200e+07 1.002240e+08 1.006560e+08 1.010880e+08 1.015200e+08 1.019520e+08 1.023840e+08 1.028160e+08 1.032480e+08 1.036800e+08 1.041120e+08 1.045440e+08 1.049760e+08 1.054080e+08 1.058400e+08 1.062720e+08 1.067040e+08 1.071360e+08 1.075680e+08 1.080000e+08 1.084320e+08 1.088640e+08 1.092960e+08 1.097280e+08 1.101600e+08 1.105920e+08 1.110240e+08 1.114560e+08 1.118880e+08 1.123200e+08 1.127520e+08 1.131840e+08 1.136160e+08 1.140480e+08 1.144800e+08 1.149120e+08 1.153440e+08 1.157760e+08 1.162080e+08 1.166400e+08 1.170720e+08 1.175040e+08 1.179360e+08 1.183680e+08 1.188000e+08 1.192320e+08 1.196640e+08 1.200960e+08 1.205280e+08 1.209600e+08 1.213920e+08 1.218240e+08 1.222560e+08 1.226880e+08 1.231200e+08 1.235520e+08 1.239840e+08 1.244160e+08 1.248480e+08 1.252800e+08 1.257120e+08 1.261440e+08 1.265760e+08 1.270080e+08 1.274400e+08 1.278720e+08 1.283040e+08 1.287360e+08 1.291680e+08 1.296000e+08 1.300320e+08 1.304640e+08 1.308960e+08 1.313280e+08 1.317600e+08 1.321920e+08 1.326240e+08 1.330560e+08 1.334880e+08 1.339200e+08 1.343520e+08 1.347840e+08 1.352160e+08 1.356480e+08 1.360800e+08 1.365120e+08 1.369440e+08 1.373760e+08 1.378080e+08 1.382400e+08 1.386720e+08 1.391040e+08 1.395360e+08 1.399680e+08 1.404000e+08 1.408320e+08 1.412640e+08 1.416960e+08 1.421280e+08 1.425600e+08 1.429920e+08 1.434240e+08 1.438560e+08 1.442880e+08 1.447200e+08 1.451520e+08 1.455840e+08 1.460160e+08 1.464480e+08 1.468800e+08 1.473120e+08 1.477440e+08 1.481760e+08 1.486080e+08 1.490400e+08 1.494720e+08 1.499040e+08 1.503360e+08 1.507680e+08 1.512000e+08 1.516320e+08 1.520640e+08 1.524960e+08 1.529280e+08 1.533600e+08 1.537920e+08 1.542240e+08 1.546560e+08 1.550880e+08 1.555200e+08 1.559520e+08 1.563840e+08 1.568160e+08 1.572480e+08 1.576800e+08 1.581120e+08 1.585440e+08 1.589760e+08 1.594080e+08 1.598400e+08 1.602720e+08 1.607040e+08 1.611360e+08 1.615680e+08 1.620000e+08 1.624320e+08 1.628640e+08 1.632960e+08 1.637280e+08 1.641600e+08 1.645920e+08 1.650240e+08 1.654560e+08 1.658880e+08 1.663200e+08 1.667520e+08 1.671840e+08 1.676160e+08 1.680480e+08 1.684800e+08 1.689120e+08 1.693440e+08 1.697760e+08 1.702080e+08 1.706400e+08 1.710720e+08 1.715040e+08 1.719360e+08 1.723680e+08 1.728000e+08 1.732320e+08 1.736640e+08 1.740960e+08 1.745280e+08 1.749600e+08 1.753920e+08 1.758240e+08 1.762560e+08 1.766880e+08 1.771200e+08 1.775520e+08 1.779840e+08 1.784160e+08 1.788480e+08 1.792800e+08 1.797120e+08 1.801440e+08 1.805760e+08 1.810080e+08 1.814400e+08 1.818720e+08 1.823040e+08 1.827360e+08 1.831680e+08 1.836000e+08 1.840320e+08 1.844640e+08 1.848960e+08 1.853280e+08 1.857600e+08 1.861920e+08 1.866240e+08 1.870560e+08 1.874880e+08 1.879200e+08 1.883520e+08 1.887840e+08 1.892160e+08 1.896480e+08 1.900800e+08 1.905120e+08 1.909440e+08 1.913760e+08 1.918080e+08 1.922400e+08 1.926720e+08 1.931040e+08 1.935360e+08 1.939680e+08 1.944000e+08 1.948320e+08 1.952640e+08 1.956960e+08 1.961280e+08 1.965600e+08 1.969920e+08 1.974240e+08 1.978560e+08 1.982880e+08 1.987200e+08 1.991520e+08 1.995840e+08 2.000160e+08 2.004480e+08 2.008800e+08 2.013120e+08 2.017440e+08 2.021760e+08 2.026080e+08 2.030400e+08 2.034720e+08 2.039040e+08 2.043360e+08 2.047680e+08 2.052000e+08 2.056320e+08 2.060640e+08 2.064960e+08 2.069280e+08 2.073600e+08 2.077920e+08 2.082240e+08 2.086560e+08 2.090880e+08 2.095200e+08 2.099520e+08 2.103840e+08 2.108160e+08 2.112480e+08 2.116800e+08 2.121120e+08 2.125440e+08 2.129760e+08 2.134080e+08 2.138400e+08 2.142720e+08 2.147040e+08 2.151360e+08 2.155680e+08 2.160000e+08 2.164320e+08 2.168640e+08 2.172960e+08 2.177280e+08 2.181600e+08 2.185920e+08 2.190240e+08 2.194560e+08 2.198880e+08 2.203200e+08 2.207520e+08 2.211840e+08 2.216160e+08 2.220480e+08 2.224800e+08 2.229120e+08 2.233440e+08 2.237760e+08 2.242080e+08 2.246400e+08 2.250720e+08 2.255040e+08 2.259360e+08 2.263680e+08 2.268000e+08 2.272320e+08 2.276640e+08 2.280960e+08 2.285280e+08 2.289600e+08 2.293920e+08 2.298240e+08 2.302560e+08 2.306880e+08 2.311200e+08 2.315520e+08 2.319840e+08 2.324160e+08 2.328480e+08 2.332800e+08 2.337120e+08 2.341440e+08 2.345760e+08 2.350080e+08 2.354400e+08 2.358720e+08 2.363040e+08 2.367360e+08 2.371680e+08 2.376000e+08 2.380320e+08 2.384640e+08 2.388960e+08 2.393280e+08 2.397600e+08 2.401920e+08 2.406240e+08 2.410560e+08 2.414880e+08 2.419200e+08 2.423520e+08 2.427840e+08 2.432160e+08 2.436480e+08 2.440800e+08 2.445120e+08 2.449440e+08 2.453760e+08 2.458080e+08 2.462400e+08 2.466720e+08 2.471040e+08 2.475360e+08 2.479680e+08 2.484000e+08 2.488320e+08 2.492640e+08 2.496960e+08 2.501280e+08 2.505600e+08 2.509920e+08 2.514240e+08 2.518560e+08 2.522880e+08 2.527200e+08 2.531520e+08 2.535840e+08 2.540160e+08 2.544480e+08 2.548800e+08 2.553120e+08 2.557440e+08 2.561760e+08 2.566080e+08 2.570400e+08 2.574720e+08 2.579040e+08 2.583360e+08 2.587680e+08 2.592000e+08 2.596320e+08 2.600640e+08 2.604960e+08 2.609280e+08 2.613600e+08 2.617920e+08 2.622240e+08 2.626560e+08 2.630880e+08 2.635200e+08 2.639520e+08 2.643840e+08 2.648160e+08 2.652480e+08 2.656800e+08 2.661120e+08 2.665440e+08 2.669760e+08 2.674080e+08 2.678400e+08 2.682720e+08 2.687040e+08 2.691360e+08 2.695680e+08 2.700000e+08 2.704320e+08 2.708640e+08 2.712960e+08 2.717280e+08 2.721600e+08 2.725920e+08 2.730240e+08 2.734560e+08 2.738880e+08 2.743200e+08 2.747520e+08 2.751840e+08 2.756160e+08 2.760480e+08 2.764800e+08 2.769120e+08 2.773440e+08 2.777760e+08 2.782080e+08 2.786400e+08 2.790720e+08 2.795040e+08 2.799360e+08 2.803680e+08 2.808000e+08 2.812320e+08 2.816640e+08 2.820960e+08 2.825280e+08 2.829600e+08 2.833920e+08 2.838240e+08 2.842560e+08 2.846880e+08 2.851200e+08 2.855520e+08 2.859840e+08 2.864160e+08 2.868480e+08 2.872800e+08 2.877120e+08 2.881440e+08 2.885760e+08 2.890080e+08 2.894400e+08 2.898720e+08 2.903040e+08 2.907360e+08 2.911680e+08 2.916000e+08 2.920320e+08 2.924640e+08 2.928960e+08 2.933280e+08 2.937600e+08 2.941920e+08 2.946240e+08 2.950560e+08 2.954880e+08 2.959200e+08 2.963520e+08 2.967840e+08 2.972160e+08 2.976480e+08 2.980800e+08 2.985120e+08 2.989440e+08 2.993760e+08 2.998080e+08 3.002400e+08 3.006720e+08 3.011040e+08 3.015360e+08 3.019680e+08 3.024000e+08 3.028320e+08 3.032640e+08 3.036960e+08 3.041280e+08 3.045600e+08 3.049920e+08 3.054240e+08 3.058560e+08 3.062880e+08 3.067200e+08 3.071520e+08 3.075840e+08 3.080160e+08 3.084480e+08 3.088800e+08 3.093120e+08 3.097440e+08 3.101760e+08 3.106080e+08 3.110400e+08 3.114720e+08 3.119040e+08 3.123360e+08 3.127680e+08 3.132000e+08 3.136320e+08 3.140640e+08 3.144960e+08 3.149280e+08 3.153600e+08 3.157920e+08 3.162240e+08 3.166560e+08 3.170880e+08 3.175200e+08 3.179520e+08 3.183840e+08 3.188160e+08 3.192480e+08 3.196800e+08 3.201120e+08 3.205440e+08 3.209760e+08 3.214080e+08 3.218400e+08 3.222720e+08 3.227040e+08 3.231360e+08 3.235680e+08 3.240000e+08 3.244320e+08 3.248640e+08 3.252960e+08 3.257280e+08 3.261600e+08 3.265920e+08 3.270240e+08 3.274560e+08 3.278880e+08 3.283200e+08 3.287520e+08 3.291840e+08 3.296160e+08 3.300480e+08 3.304800e+08 3.309120e+08 3.313440e+08 3.317760e+08 3.322080e+08 3.326400e+08 3.330720e+08 3.335040e+08 3.339360e+08 3.343680e+08 3.348000e+08 3.352320e+08 3.356640e+08 3.360960e+08 3.365280e+08 3.369600e+08 3.373920e+08 3.378240e+08 3.382560e+08 3.386880e+08 3.391200e+08 3.395520e+08 3.399840e+08 3.404160e+08 3.408480e+08 3.412800e+08 3.417120e+08 3.421440e+08 3.425760e+08 3.430080e+08 3.434400e+08 3.438720e+08 3.443040e+08 3.447360e+08 3.451680e+08 3.456000e+08 3.460320e+08 3.464640e+08 3.468960e+08 3.473280e+08 3.477600e+08 3.481920e+08 3.486240e+08 3.490560e+08 3.494880e+08 3.499200e+08 3.503520e+08 3.507840e+08 3.512160e+08 3.516480e+08 3.520800e+08 3.525120e+08 3.529440e+08 3.533760e+08 3.538080e+08 3.542400e+08 3.546720e+08 3.551040e+08 3.555360e+08 3.559680e+08 3.564000e+08 3.568320e+08 3.572640e+08 3.576960e+08 3.581280e+08 3.585600e+08 3.589920e+08 3.594240e+08 3.598560e+08 3.602880e+08 3.607200e+08 3.611520e+08 3.615840e+08 3.620160e+08 3.624480e+08 3.628800e+08 3.633120e+08 3.637440e+08 3.641760e+08 3.646080e+08 3.650400e+08 3.654720e+08 3.659040e+08 3.663360e+08 3.667680e+08 3.672000e+08 3.676320e+08 3.680640e+08 3.684960e+08 3.689280e+08 3.693600e+08 3.697920e+08 3.702240e+08 3.706560e+08 3.710880e+08 3.715200e+08 3.719520e+08 3.723840e+08 3.728160e+08 3.732480e+08 3.736800e+08 3.741120e+08 3.745440e+08 3.749760e+08 3.754080e+08 3.758400e+08 3.762720e+08 3.767040e+08 3.771360e+08 3.775680e+08 3.780000e+08 3.784320e+08 3.788640e+08 3.792960e+08 3.797280e+08 3.801600e+08 3.805920e+08 3.810240e+08 3.814560e+08 3.818880e+08 3.823200e+08 3.827520e+08 3.831840e+08 3.836160e+08 3.840480e+08 3.844800e+08 3.849120e+08 3.853440e+08 3.857760e+08 3.862080e+08 3.866400e+08 3.870720e+08 3.875040e+08 3.879360e+08 3.883680e+08 3.888000e+08 3.892320e+08 3.896640e+08 3.900960e+08 3.905280e+08 3.909600e+08 3.913920e+08 3.918240e+08 3.922560e+08 3.926880e+08 3.931200e+08 3.935520e+08 3.939840e+08 3.944160e+08 3.948480e+08 3.952800e+08 3.957120e+08 3.961440e+08 3.965760e+08 3.970080e+08 3.974400e+08 3.978720e+08 3.983040e+08 3.987360e+08 3.991680e+08 3.996000e+08 4.000320e+08 4.004640e+08 4.008960e+08 4.013280e+08 4.017600e+08 4.021920e+08 4.026240e+08 4.030560e+08 4.034880e+08 4.039200e+08 4.043520e+08 4.047840e+08 4.052160e+08 4.056480e+08 4.060800e+08 4.065120e+08 4.069440e+08 4.073760e+08 4.078080e+08 4.082400e+08 4.086720e+08 4.091040e+08 4.095360e+08 4.099680e+08 4.104000e+08 4.108320e+08 4.112640e+08 4.116960e+08 4.121280e+08 4.125600e+08 4.129920e+08 4.134240e+08 4.138560e+08 4.142880e+08 4.147200e+08 4.151520e+08 4.155840e+08 4.160160e+08 4.164480e+08 4.168800e+08 4.173120e+08 4.177440e+08 4.181760e+08 4.186080e+08 4.190400e+08 4.194720e+08 4.199040e+08 4.203360e+08 4.207680e+08 4.212000e+08 4.216320e+08 4.220640e+08 4.224960e+08 4.229280e+08 4.233600e+08 4.237920e+08 4.242240e+08 4.246560e+08 4.250880e+08 4.255200e+08 4.259520e+08 4.263840e+08 4.268160e+08 4.272480e+08 4.276800e+08 4.281120e+08 4.285440e+08 4.289760e+08 4.294080e+08 4.298400e+08 4.302720e+08 4.307040e+08 4.311360e+08 4.315680e+08 4.320000e+08 4.324320e+08 4.328640e+08 4.332960e+08 4.337280e+08 4.341600e+08 4.345920e+08 4.350240e+08 4.354560e+08 4.358880e+08 4.363200e+08 4.367520e+08 4.371840e+08 4.376160e+08 4.380480e+08 4.384800e+08 4.389120e+08 4.393440e+08 4.397760e+08 4.402080e+08 4.406400e+08 4.410720e+08 4.415040e+08 4.419360e+08 4.423680e+08 4.428000e+08 4.432320e+08 4.436640e+08 4.440960e+08 4.445280e+08 4.449600e+08 4.453920e+08 4.458240e+08 4.462560e+08 4.466880e+08 4.471200e+08 4.475520e+08 4.479840e+08 4.484160e+08 4.488480e+08 4.492800e+08 4.497120e+08 4.501440e+08 4.505760e+08 4.510080e+08 4.514400e+08 4.518720e+08 4.523040e+08 4.527360e+08 4.531680e+08 4.536000e+08 4.540320e+08 4.544640e+08 4.548960e+08 4.553280e+08 4.557600e+08 4.561920e+08 4.566240e+08 4.570560e+08 4.574880e+08 4.579200e+08 4.583520e+08 4.587840e+08 4.592160e+08 4.596480e+08 4.600800e+08 4.605120e+08 4.609440e+08 4.613760e+08 4.618080e+08 4.622400e+08 4.626720e+08 4.631040e+08 4.635360e+08 4.639680e+08 4.644000e+08 4.648320e+08 4.652640e+08 4.656960e+08 4.661280e+08 4.665600e+08 4.669920e+08 4.674240e+08 4.678560e+08 4.682880e+08 4.687200e+08 4.691520e+08 4.695840e+08 4.700160e+08 4.704480e+08 4.708800e+08 4.713120e+08 4.717440e+08 4.721760e+08 4.726080e+08 4.730400e+08 4.734720e+08 4.739040e+08 4.743360e+08 4.747680e+08 4.752000e+08 4.756320e+08 4.760640e+08 4.764960e+08 4.769280e+08 4.773600e+08 4.777920e+08 4.782240e+08 4.786560e+08 4.790880e+08 4.795200e+08 4.799520e+08 4.803840e+08 4.808160e+08 4.812480e+08 4.816800e+08 4.821120e+08 4.825440e+08 4.829760e+08 4.834080e+08 4.838400e+08 4.842720e+08 4.847040e+08 4.851360e+08 4.855680e+08 4.860000e+08 4.864320e+08 4.868640e+08 4.872960e+08 4.877280e+08 4.881600e+08 4.885920e+08 4.890240e+08 4.894560e+08 4.898880e+08 4.903200e+08 4.907520e+08 4.911840e+08 4.916160e+08 4.920480e+08 4.924800e+08 4.929120e+08 4.933440e+08 4.937760e+08 4.942080e+08 4.946400e+08 4.950720e+08 4.955040e+08 4.959360e+08 4.963680e+08 4.968000e+08 4.972320e+08 4.976640e+08 4.980960e+08 4.985280e+08 4.989600e+08 4.993920e+08 4.998240e+08 5.002560e+08 5.006880e+08 5.011200e+08 5.015520e+08 5.019840e+08 5.024160e+08 5.028480e+08 5.032800e+08 5.037120e+08 5.041440e+08 5.045760e+08 5.050080e+08 5.054400e+08 5.058720e+08 5.063040e+08 5.067360e+08 5.071680e+08 5.076000e+08 5.080320e+08 5.084640e+08 5.088960e+08 5.093280e+08 5.097600e+08 5.101920e+08 5.106240e+08 5.110560e+08 5.114880e+08 5.119200e+08 5.123520e+08 5.127840e+08 5.132160e+08 5.136480e+08 5.140800e+08 5.145120e+08 5.149440e+08 5.153760e+08 5.158080e+08 5.162400e+08 5.166720e+08 5.171040e+08 5.175360e+08 5.179680e+08 5.184000e+08 5.188320e+08 5.192640e+08 5.196960e+08 5.201280e+08 5.205600e+08 5.209920e+08 5.214240e+08 5.218560e+08 5.222880e+08 5.227200e+08 5.231520e+08 5.235840e+08 5.240160e+08 5.244480e+08 5.248800e+08 5.253120e+08 5.257440e+08 5.261760e+08 5.266080e+08 5.270400e+08 5.274720e+08 5.279040e+08 5.283360e+08 5.287680e+08 5.292000e+08 5.296320e+08 5.300640e+08 5.304960e+08 5.309280e+08 5.313600e+08 5.317920e+08 5.322240e+08 5.326560e+08 5.330880e+08 5.335200e+08 5.339520e+08 5.343840e+08 5.348160e+08 5.352480e+08 5.356800e+08 5.361120e+08 5.365440e+08 5.369760e+08 5.374080e+08 5.378400e+08 5.382720e+08 5.387040e+08 5.391360e+08 5.395680e+08 5.400000e+08 5.404320e+08 5.408640e+08 5.412960e+08 5.417280e+08 5.421600e+08 5.425920e+08 5.430240e+08 5.434560e+08 5.438880e+08 5.443200e+08 5.447520e+08 5.451840e+08 5.456160e+08 5.460480e+08 5.464800e+08 5.469120e+08 5.473440e+08 5.477760e+08 5.482080e+08 5.486400e+08 5.490720e+08 5.495040e+08 5.499360e+08 5.503680e+08 5.508000e+08 5.512320e+08 5.516640e+08 5.520960e+08 5.525280e+08 5.529600e+08 5.533920e+08 5.538240e+08 5.542560e+08 5.546880e+08 5.551200e+08 5.555520e+08 5.559840e+08 5.564160e+08 5.568480e+08 5.572800e+08 5.577120e+08 5.581440e+08 5.585760e+08 5.590080e+08 5.594400e+08 5.598720e+08 5.603040e+08 5.607360e+08 5.611680e+08 5.616000e+08 5.620320e+08 5.624640e+08 5.628960e+08 5.633280e+08 5.637600e+08 5.641920e+08 5.646240e+08 5.650560e+08 5.654880e+08 5.659200e+08 5.663520e+08 5.667840e+08 5.672160e+08 5.676480e+08 5.680800e+08 5.685120e+08 5.689440e+08 5.693760e+08 5.698080e+08 5.702400e+08 5.706720e+08 5.711040e+08 5.715360e+08 5.719680e+08 5.724000e+08 5.728320e+08 5.732640e+08 5.736960e+08 5.741280e+08 5.745600e+08 5.749920e+08 5.754240e+08 5.758560e+08 5.762880e+08 5.767200e+08 5.771520e+08 5.775840e+08 5.780160e+08 5.784480e+08 5.788800e+08 5.793120e+08 5.797440e+08 5.801760e+08 5.806080e+08 5.810400e+08 5.814720e+08 5.819040e+08 5.823360e+08 5.827680e+08 5.832000e+08 5.836320e+08 5.840640e+08 5.844960e+08 5.849280e+08 5.853600e+08 5.857920e+08 5.862240e+08 5.866560e+08 5.870880e+08 5.875200e+08 5.879520e+08 5.883840e+08 5.888160e+08 5.892480e+08 5.896800e+08 5.901120e+08 5.905440e+08 5.909760e+08 5.914080e+08 5.918400e+08 5.922720e+08 5.927040e+08 5.931360e+08 5.935680e+08 5.940000e+08 5.944320e+08 5.948640e+08 5.952960e+08 5.957280e+08 5.961600e+08 5.965920e+08 5.970240e+08 5.974560e+08 5.978880e+08 5.983200e+08 5.987520e+08 5.991840e+08 5.996160e+08 6.000480e+08 6.004800e+08 6.009120e+08 6.013440e+08 6.017760e+08 6.022080e+08 6.026400e+08 6.030720e+08 6.035040e+08 6.039360e+08 6.043680e+08 6.048000e+08 6.052320e+08 6.056640e+08 6.060960e+08 6.065280e+08 6.069600e+08 6.073920e+08 6.078240e+08 6.082560e+08 6.086880e+08 6.091200e+08 6.095520e+08 6.099840e+08 6.104160e+08 6.108480e+08 6.112800e+08 6.117120e+08 6.121440e+08 6.125760e+08 6.130080e+08 6.134400e+08 6.138720e+08 6.143040e+08 6.147360e+08 6.151680e+08 6.156000e+08 6.160320e+08 6.164640e+08 6.168960e+08 6.173280e+08 6.177600e+08 6.181920e+08 6.186240e+08 6.190560e+08 6.194880e+08 6.199200e+08 6.203520e+08 6.207840e+08 6.212160e+08 6.216480e+08 6.220800e+08 6.225120e+08 6.229440e+08 6.233760e+08 6.238080e+08 6.242400e+08 6.246720e+08 6.251040e+08 6.255360e+08 6.259680e+08 6.264000e+08 6.268320e+08 6.272640e+08 6.276960e+08 6.281280e+08 6.285600e+08 6.289920e+08 6.294240e+08 6.298560e+08 6.302880e+08 6.307200e+08 6.311520e+08 6.315840e+08 6.320160e+08 6.324480e+08 6.328800e+08 6.333120e+08 6.337440e+08 6.341760e+08 6.346080e+08 6.350400e+08 6.354720e+08 6.359040e+08 6.363360e+08 6.367680e+08 6.372000e+08 6.376320e+08 6.380640e+08 6.384960e+08 6.389280e+08 6.393600e+08 6.397920e+08 6.402240e+08 6.406560e+08 6.410880e+08 6.415200e+08 6.419520e+08 6.423840e+08 6.428160e+08 6.432480e+08 6.436800e+08 6.441120e+08 6.445440e+08 6.449760e+08 6.454080e+08 6.458400e+08 6.462720e+08 6.467040e+08 6.471360e+08 6.475680e+08 6.480000e+08 6.484320e+08 6.488640e+08 6.492960e+08 6.497280e+08 6.501600e+08 6.505920e+08 6.510240e+08 6.514560e+08 6.518880e+08 6.523200e+08 6.527520e+08 6.531840e+08 6.536160e+08 6.540480e+08 6.544800e+08 6.549120e+08 6.553440e+08 6.557760e+08 6.562080e+08 6.566400e+08 6.570720e+08 6.575040e+08 6.579360e+08 6.583680e+08 6.588000e+08 6.592320e+08 6.596640e+08 6.600960e+08 6.605280e+08 6.609600e+08 6.613920e+08 6.618240e+08 6.622560e+08 6.626880e+08 6.631200e+08 6.635520e+08 6.639840e+08 6.644160e+08 6.648480e+08 6.652800e+08 6.657120e+08 6.661440e+08 6.665760e+08 6.670080e+08 6.674400e+08 6.678720e+08 6.683040e+08 6.687360e+08 6.691680e+08 6.696000e+08 6.700320e+08 6.704640e+08 6.708960e+08 6.713280e+08 6.717600e+08 6.721920e+08 6.726240e+08 6.730560e+08 6.734880e+08 6.739200e+08 6.743520e+08 6.747840e+08 6.752160e+08 6.756480e+08 6.760800e+08 6.765120e+08 6.769440e+08 6.773760e+08 6.778080e+08 6.782400e+08 6.786720e+08 6.791040e+08 6.795360e+08 6.799680e+08 6.804000e+08 6.808320e+08 6.812640e+08 6.816960e+08 6.821280e+08 6.825600e+08 6.829920e+08 6.834240e+08 6.838560e+08 6.842880e+08 6.847200e+08 6.851520e+08 6.855840e+08 6.860160e+08 6.864480e+08 6.868800e+08 6.873120e+08 6.877440e+08 6.881760e+08 6.886080e+08 6.890400e+08 6.894720e+08 6.899040e+08 6.903360e+08 6.907680e+08 6.912000e+08 6.916320e+08 6.920640e+08 6.924960e+08 6.929280e+08 6.933600e+08 6.937920e+08 6.942240e+08 6.946560e+08 6.950880e+08 6.955200e+08 6.959520e+08 6.963840e+08 6.968160e+08 6.972480e+08 6.976800e+08 6.981120e+08 6.985440e+08 6.989760e+08 6.994080e+08 6.998400e+08 7.002720e+08 7.007040e+08 7.011360e+08 7.015680e+08 7.020000e+08 7.024320e+08 7.028640e+08 7.032960e+08 7.037280e+08 7.041600e+08 7.045920e+08 7.050240e+08 7.054560e+08 7.058880e+08 7.063200e+08 7.067520e+08 7.071840e+08 7.076160e+08 7.080480e+08 7.084800e+08 7.089120e+08 7.093440e+08 7.097760e+08 7.102080e+08 7.106400e+08 7.110720e+08 7.115040e+08 7.119360e+08 7.123680e+08 7.128000e+08 7.132320e+08 7.136640e+08 7.140960e+08 7.145280e+08 7.149600e+08 7.153920e+08 7.158240e+08 7.162560e+08 7.166880e+08 7.171200e+08 7.175520e+08 7.179840e+08 7.184160e+08 7.188480e+08 7.192800e+08 7.197120e+08 7.201440e+08 7.205760e+08 7.210080e+08 7.214400e+08 7.218720e+08 7.223040e+08 7.227360e+08 7.231680e+08 7.236000e+08 7.240320e+08 7.244640e+08 7.248960e+08 7.253280e+08 7.257600e+08 7.261920e+08 7.266240e+08 7.270560e+08 7.274880e+08 7.279200e+08 7.283520e+08 7.287840e+08 7.292160e+08 7.296480e+08 7.300800e+08 7.305120e+08 7.309440e+08 7.313760e+08 7.318080e+08 7.322400e+08 7.326720e+08 7.331040e+08 7.335360e+08 7.339680e+08 7.344000e+08 7.348320e+08 7.352640e+08 7.356960e+08 7.361280e+08 7.365600e+08 7.369920e+08 7.374240e+08 7.378560e+08 7.382880e+08 7.387200e+08 7.391520e+08 7.395840e+08 7.400160e+08 7.404480e+08 7.408800e+08 7.413120e+08 7.417440e+08 7.421760e+08 7.426080e+08 7.430400e+08 7.434720e+08 7.439040e+08 7.443360e+08 7.447680e+08 7.452000e+08 7.456320e+08 7.460640e+08 7.464960e+08 7.469280e+08 7.473600e+08 7.477920e+08 7.482240e+08 7.486560e+08 7.490880e+08 7.495200e+08 7.499520e+08 7.503840e+08 7.508160e+08 7.512480e+08 7.516800e+08 7.521120e+08 7.525440e+08 7.529760e+08 7.534080e+08 7.538400e+08 7.542720e+08 7.547040e+08 7.551360e+08 7.555680e+08 7.560000e+08 7.564320e+08 7.568640e+08 7.572960e+08 7.577280e+08 7.581600e+08 7.585920e+08 7.590240e+08 7.594560e+08 7.598880e+08 7.603200e+08 7.607520e+08 7.611840e+08 7.616160e+08 7.620480e+08 7.624800e+08 7.629120e+08 7.633440e+08 7.637760e+08 7.642080e+08 7.646400e+08 7.650720e+08 7.655040e+08 7.659360e+08 7.663680e+08 7.668000e+08 7.672320e+08 7.676640e+08 7.680960e+08 7.685280e+08 7.689600e+08 7.693920e+08 7.698240e+08 7.702560e+08 7.706880e+08 7.711200e+08 7.715520e+08 7.719840e+08 7.724160e+08 7.728480e+08 7.732800e+08 7.737120e+08 7.741440e+08 7.745760e+08 7.750080e+08 7.754400e+08 7.758720e+08 7.763040e+08 7.767360e+08 7.771680e+08 7.776000e+08 7.780320e+08 7.784640e+08 7.788960e+08 7.793280e+08 7.797600e+08 7.801920e+08 7.806240e+08 7.810560e+08 7.814880e+08 7.819200e+08 7.823520e+08 7.827840e+08 7.832160e+08 7.836480e+08 7.840800e+08 7.845120e+08 7.849440e+08 7.853760e+08 7.858080e+08 7.862400e+08 7.866720e+08 7.871040e+08 7.875360e+08 7.879680e+08 7.884000e+08 7.888320e+08 7.892640e+08 7.896960e+08 7.901280e+08 7.905600e+08 7.909920e+08 7.914240e+08 7.918560e+08 7.922880e+08 7.927200e+08 7.931520e+08 7.935840e+08 7.940160e+08 7.944480e+08 7.948800e+08 7.953120e+08 7.957440e+08 7.961760e+08 7.966080e+08 7.970400e+08 7.974720e+08 7.979040e+08 7.983360e+08 7.987680e+08 7.992000e+08 7.996320e+08 8.000640e+08 8.004960e+08 8.009280e+08 8.013600e+08 8.017920e+08 8.022240e+08 8.026560e+08 8.030880e+08 8.035200e+08 8.039520e+08 8.043840e+08 8.048160e+08 8.052480e+08 8.056800e+08 8.061120e+08 8.065440e+08 8.069760e+08 8.074080e+08 8.078400e+08 8.082720e+08 8.087040e+08 8.091360e+08 8.095680e+08 8.100000e+08 8.104320e+08 8.108640e+08 8.112960e+08 8.117280e+08 8.121600e+08 8.125920e+08 8.130240e+08 8.134560e+08 8.138880e+08 8.143200e+08 8.147520e+08 8.151840e+08 8.156160e+08 8.160480e+08 8.164800e+08 8.169120e+08 8.173440e+08 8.177760e+08 8.182080e+08 8.186400e+08 8.190720e+08 8.195040e+08 8.199360e+08 8.203680e+08 8.208000e+08 8.212320e+08 8.216640e+08 8.220960e+08 8.225280e+08 8.229600e+08 8.233920e+08 8.238240e+08 8.242560e+08 8.246880e+08 8.251200e+08 8.255520e+08 8.259840e+08 8.264160e+08 8.268480e+08 8.272800e+08 8.277120e+08 8.281440e+08 8.285760e+08 8.290080e+08 8.294400e+08 8.298720e+08 8.303040e+08 8.307360e+08 8.311680e+08 8.316000e+08 8.320320e+08 8.324640e+08 8.328960e+08 8.333280e+08 8.337600e+08 8.341920e+08 8.346240e+08 8.350560e+08 8.354880e+08 8.359200e+08 8.363520e+08 8.367840e+08 8.372160e+08 8.376480e+08 8.380800e+08 8.385120e+08 8.389440e+08 8.393760e+08 8.398080e+08 8.402400e+08 8.406720e+08 8.411040e+08 8.415360e+08 8.419680e+08 8.424000e+08 8.428320e+08 8.432640e+08 8.436960e+08 8.441280e+08 8.445600e+08 8.449920e+08 8.454240e+08 8.458560e+08 8.462880e+08 8.467200e+08 8.471520e+08 8.475840e+08 8.480160e+08 8.484480e+08 8.488800e+08 8.493120e+08 8.497440e+08 8.501760e+08 8.506080e+08 8.510400e+08 8.514720e+08 8.519040e+08 8.523360e+08 8.527680e+08 8.532000e+08 8.536320e+08 8.540640e+08 8.544960e+08 8.549280e+08 8.553600e+08 8.557920e+08 8.562240e+08 8.566560e+08 8.570880e+08 8.575200e+08 8.579520e+08 8.583840e+08 8.588160e+08 8.592480e+08 8.596800e+08 8.601120e+08 8.605440e+08 8.609760e+08 8.614080e+08 8.618400e+08 8.622720e+08 8.627040e+08 8.631360e+08 8.635680e+08 8.640000e+08 8.644320e+08 8.648640e+08 8.652960e+08 8.657280e+08 8.661600e+08 8.665920e+08 8.670240e+08 8.674560e+08 8.678880e+08 8.683200e+08 8.687520e+08 8.691840e+08 8.696160e+08 8.700480e+08 8.704800e+08 8.709120e+08 8.713440e+08 8.717760e+08 8.722080e+08 8.726400e+08 8.730720e+08 8.735040e+08 8.739360e+08 8.743680e+08 8.748000e+08 8.752320e+08 8.756640e+08 8.760960e+08 8.765280e+08 8.769600e+08 8.773920e+08 8.778240e+08 8.782560e+08 8.786880e+08 8.791200e+08 8.795520e+08 8.799840e+08 8.804160e+08 8.808480e+08 8.812800e+08 8.817120e+08 8.821440e+08 8.825760e+08 8.830080e+08 8.834400e+08 8.838720e+08 8.843040e+08 8.847360e+08 8.851680e+08 8.856000e+08 8.860320e+08 8.864640e+08 8.868960e+08 8.873280e+08 8.877600e+08 8.881920e+08 8.886240e+08 8.890560e+08 8.894880e+08 8.899200e+08 8.903520e+08 8.907840e+08 8.912160e+08 8.916480e+08 8.920800e+08 8.925120e+08 8.929440e+08 8.933760e+08 8.938080e+08 8.942400e+08 8.946720e+08 8.951040e+08 8.955360e+08 8.959680e+08 8.964000e+08 8.968320e+08 8.972640e+08 8.976960e+08 8.981280e+08 8.985600e+08 8.989920e+08 8.994240e+08 8.998560e+08 9.002880e+08 9.007200e+08 9.011520e+08 9.015840e+08 9.020160e+08 9.024480e+08 9.028800e+08 9.033120e+08 9.037440e+08 9.041760e+08 9.046080e+08 9.050400e+08 9.054720e+08 9.059040e+08 9.063360e+08 9.067680e+08 9.072000e+08 9.076320e+08 9.080640e+08 9.084960e+08 9.089280e+08 9.093600e+08 9.097920e+08 9.102240e+08 9.106560e+08 9.110880e+08 9.115200e+08 9.119520e+08 9.123840e+08 9.128160e+08 9.132480e+08 9.136800e+08 9.141120e+08 9.145440e+08 9.149760e+08 9.154080e+08 9.158400e+08 9.162720e+08 9.167040e+08 9.171360e+08 9.175680e+08 9.180000e+08 9.184320e+08 9.188640e+08 9.192960e+08 9.197280e+08 9.201600e+08 9.205920e+08 9.210240e+08 9.214560e+08 9.218880e+08 9.223200e+08 9.227520e+08 9.231840e+08 9.236160e+08 9.240480e+08 9.244800e+08 9.249120e+08 9.253440e+08 9.257760e+08 9.262080e+08 9.266400e+08 9.270720e+08 9.275040e+08 9.279360e+08 9.283680e+08 9.288000e+08 9.292320e+08 9.296640e+08 9.300960e+08 9.305280e+08 9.309600e+08 9.313920e+08 9.318240e+08 9.322560e+08 9.326880e+08 9.331200e+08 9.335520e+08 9.339840e+08 9.344160e+08 9.348480e+08 9.352800e+08 9.357120e+08 9.361440e+08 9.365760e+08 9.370080e+08 9.374400e+08 9.378720e+08 9.383040e+08 9.387360e+08 9.391680e+08 9.396000e+08 9.400320e+08 9.404640e+08 9.408960e+08 9.413280e+08 9.417600e+08 9.421920e+08 9.426240e+08 9.430560e+08 9.434880e+08 9.439200e+08 9.443520e+08 9.447840e+08 9.452160e+08 9.456480e+08'
    sync_only = ${output_only_selected_timesteps}
  []
  [csv]
    type = CSV
    sync_times = '0.000000e+00 4.320000e+05 8.640000e+05 1.296000e+06 1.728000e+06 2.160000e+06 2.592000e+06 3.024000e+06 3.456000e+06 3.888000e+06 4.320000e+06 4.752000e+06 5.184000e+06 5.616000e+06 6.048000e+06 6.480000e+06 6.912000e+06 7.344000e+06 7.776000e+06 8.208000e+06 8.640000e+06 9.072000e+06 9.504000e+06 9.936000e+06 1.036800e+07 1.080000e+07 1.123200e+07 1.166400e+07 1.209600e+07 1.252800e+07 1.296000e+07 1.339200e+07 1.382400e+07 1.425600e+07 1.468800e+07 1.512000e+07 1.555200e+07 1.598400e+07 1.641600e+07 1.684800e+07 1.728000e+07 1.771200e+07 1.814400e+07 1.857600e+07 1.900800e+07 1.944000e+07 1.987200e+07 2.030400e+07 2.073600e+07 2.116800e+07 2.160000e+07 2.203200e+07 2.246400e+07 2.289600e+07 2.332800e+07 2.376000e+07 2.419200e+07 2.462400e+07 2.505600e+07 2.548800e+07 2.592000e+07 2.635200e+07 2.678400e+07 2.721600e+07 2.764800e+07 2.808000e+07 2.851200e+07 2.894400e+07 2.937600e+07 2.980800e+07 3.024000e+07 3.067200e+07 3.110400e+07 3.153600e+07 3.196800e+07 3.240000e+07 3.283200e+07 3.326400e+07 3.369600e+07 3.412800e+07 3.456000e+07 3.499200e+07 3.542400e+07 3.585600e+07 3.628800e+07 3.672000e+07 3.715200e+07 3.758400e+07 3.801600e+07 3.844800e+07 3.888000e+07 3.931200e+07 3.974400e+07 4.017600e+07 4.060800e+07 4.104000e+07 4.147200e+07 4.190400e+07 4.233600e+07 4.276800e+07 4.320000e+07 4.363200e+07 4.406400e+07 4.449600e+07 4.492800e+07 4.536000e+07 4.579200e+07 4.622400e+07 4.665600e+07 4.708800e+07 4.752000e+07 4.795200e+07 4.838400e+07 4.881600e+07 4.924800e+07 4.968000e+07 5.011200e+07 5.054400e+07 5.097600e+07 5.140800e+07 5.184000e+07 5.227200e+07 5.270400e+07 5.313600e+07 5.356800e+07 5.400000e+07 5.443200e+07 5.486400e+07 5.529600e+07 5.572800e+07 5.616000e+07 5.659200e+07 5.702400e+07 5.745600e+07 5.788800e+07 5.832000e+07 5.875200e+07 5.918400e+07 5.961600e+07 6.004800e+07 6.048000e+07 6.091200e+07 6.134400e+07 6.177600e+07 6.220800e+07 6.264000e+07 6.307200e+07 6.350400e+07 6.393600e+07 6.436800e+07 6.480000e+07 6.523200e+07 6.566400e+07 6.609600e+07 6.652800e+07 6.696000e+07 6.739200e+07 6.782400e+07 6.825600e+07 6.868800e+07 6.912000e+07 6.955200e+07 6.998400e+07 7.041600e+07 7.084800e+07 7.128000e+07 7.171200e+07 7.214400e+07 7.257600e+07 7.300800e+07 7.344000e+07 7.387200e+07 7.430400e+07 7.473600e+07 7.516800e+07 7.560000e+07 7.603200e+07 7.646400e+07 7.689600e+07 7.732800e+07 7.776000e+07 7.819200e+07 7.862400e+07 7.905600e+07 7.948800e+07 7.992000e+07 8.035200e+07 8.078400e+07 8.121600e+07 8.164800e+07 8.208000e+07 8.251200e+07 8.294400e+07 8.337600e+07 8.380800e+07 8.424000e+07 8.467200e+07 8.510400e+07 8.553600e+07 8.596800e+07 8.640000e+07 8.683200e+07 8.726400e+07 8.769600e+07 8.812800e+07 8.856000e+07 8.899200e+07 8.942400e+07 8.985600e+07 9.028800e+07 9.072000e+07 9.115200e+07 9.158400e+07 9.201600e+07 9.244800e+07 9.288000e+07 9.331200e+07 9.374400e+07 9.417600e+07 9.460800e+07 9.504000e+07 9.547200e+07 9.590400e+07 9.633600e+07 9.676800e+07 9.720000e+07 9.763200e+07 9.806400e+07 9.849600e+07 9.892800e+07 9.936000e+07 9.979200e+07 1.002240e+08 1.006560e+08 1.010880e+08 1.015200e+08 1.019520e+08 1.023840e+08 1.028160e+08 1.032480e+08 1.036800e+08 1.041120e+08 1.045440e+08 1.049760e+08 1.054080e+08 1.058400e+08 1.062720e+08 1.067040e+08 1.071360e+08 1.075680e+08 1.080000e+08 1.084320e+08 1.088640e+08 1.092960e+08 1.097280e+08 1.101600e+08 1.105920e+08 1.110240e+08 1.114560e+08 1.118880e+08 1.123200e+08 1.127520e+08 1.131840e+08 1.136160e+08 1.140480e+08 1.144800e+08 1.149120e+08 1.153440e+08 1.157760e+08 1.162080e+08 1.166400e+08 1.170720e+08 1.175040e+08 1.179360e+08 1.183680e+08 1.188000e+08 1.192320e+08 1.196640e+08 1.200960e+08 1.205280e+08 1.209600e+08 1.213920e+08 1.218240e+08 1.222560e+08 1.226880e+08 1.231200e+08 1.235520e+08 1.239840e+08 1.244160e+08 1.248480e+08 1.252800e+08 1.257120e+08 1.261440e+08 1.265760e+08 1.270080e+08 1.274400e+08 1.278720e+08 1.283040e+08 1.287360e+08 1.291680e+08 1.296000e+08 1.300320e+08 1.304640e+08 1.308960e+08 1.313280e+08 1.317600e+08 1.321920e+08 1.326240e+08 1.330560e+08 1.334880e+08 1.339200e+08 1.343520e+08 1.347840e+08 1.352160e+08 1.356480e+08 1.360800e+08 1.365120e+08 1.369440e+08 1.373760e+08 1.378080e+08 1.382400e+08 1.386720e+08 1.391040e+08 1.395360e+08 1.399680e+08 1.404000e+08 1.408320e+08 1.412640e+08 1.416960e+08 1.421280e+08 1.425600e+08 1.429920e+08 1.434240e+08 1.438560e+08 1.442880e+08 1.447200e+08 1.451520e+08 1.455840e+08 1.460160e+08 1.464480e+08 1.468800e+08 1.473120e+08 1.477440e+08 1.481760e+08 1.486080e+08 1.490400e+08 1.494720e+08 1.499040e+08 1.503360e+08 1.507680e+08 1.512000e+08 1.516320e+08 1.520640e+08 1.524960e+08 1.529280e+08 1.533600e+08 1.537920e+08 1.542240e+08 1.546560e+08 1.550880e+08 1.555200e+08 1.559520e+08 1.563840e+08 1.568160e+08 1.572480e+08 1.576800e+08 1.581120e+08 1.585440e+08 1.589760e+08 1.594080e+08 1.598400e+08 1.602720e+08 1.607040e+08 1.611360e+08 1.615680e+08 1.620000e+08 1.624320e+08 1.628640e+08 1.632960e+08 1.637280e+08 1.641600e+08 1.645920e+08 1.650240e+08 1.654560e+08 1.658880e+08 1.663200e+08 1.667520e+08 1.671840e+08 1.676160e+08 1.680480e+08 1.684800e+08 1.689120e+08 1.693440e+08 1.697760e+08 1.702080e+08 1.706400e+08 1.710720e+08 1.715040e+08 1.719360e+08 1.723680e+08 1.728000e+08 1.732320e+08 1.736640e+08 1.740960e+08 1.745280e+08 1.749600e+08 1.753920e+08 1.758240e+08 1.762560e+08 1.766880e+08 1.771200e+08 1.775520e+08 1.779840e+08 1.784160e+08 1.788480e+08 1.792800e+08 1.797120e+08 1.801440e+08 1.805760e+08 1.810080e+08 1.814400e+08 1.818720e+08 1.823040e+08 1.827360e+08 1.831680e+08 1.836000e+08 1.840320e+08 1.844640e+08 1.848960e+08 1.853280e+08 1.857600e+08 1.861920e+08 1.866240e+08 1.870560e+08 1.874880e+08 1.879200e+08 1.883520e+08 1.887840e+08 1.892160e+08 1.896480e+08 1.900800e+08 1.905120e+08 1.909440e+08 1.913760e+08 1.918080e+08 1.922400e+08 1.926720e+08 1.931040e+08 1.935360e+08 1.939680e+08 1.944000e+08 1.948320e+08 1.952640e+08 1.956960e+08 1.961280e+08 1.965600e+08 1.969920e+08 1.974240e+08 1.978560e+08 1.982880e+08 1.987200e+08 1.991520e+08 1.995840e+08 2.000160e+08 2.004480e+08 2.008800e+08 2.013120e+08 2.017440e+08 2.021760e+08 2.026080e+08 2.030400e+08 2.034720e+08 2.039040e+08 2.043360e+08 2.047680e+08 2.052000e+08 2.056320e+08 2.060640e+08 2.064960e+08 2.069280e+08 2.073600e+08 2.077920e+08 2.082240e+08 2.086560e+08 2.090880e+08 2.095200e+08 2.099520e+08 2.103840e+08 2.108160e+08 2.112480e+08 2.116800e+08 2.121120e+08 2.125440e+08 2.129760e+08 2.134080e+08 2.138400e+08 2.142720e+08 2.147040e+08 2.151360e+08 2.155680e+08 2.160000e+08 2.164320e+08 2.168640e+08 2.172960e+08 2.177280e+08 2.181600e+08 2.185920e+08 2.190240e+08 2.194560e+08 2.198880e+08 2.203200e+08 2.207520e+08 2.211840e+08 2.216160e+08 2.220480e+08 2.224800e+08 2.229120e+08 2.233440e+08 2.237760e+08 2.242080e+08 2.246400e+08 2.250720e+08 2.255040e+08 2.259360e+08 2.263680e+08 2.268000e+08 2.272320e+08 2.276640e+08 2.280960e+08 2.285280e+08 2.289600e+08 2.293920e+08 2.298240e+08 2.302560e+08 2.306880e+08 2.311200e+08 2.315520e+08 2.319840e+08 2.324160e+08 2.328480e+08 2.332800e+08 2.337120e+08 2.341440e+08 2.345760e+08 2.350080e+08 2.354400e+08 2.358720e+08 2.363040e+08 2.367360e+08 2.371680e+08 2.376000e+08 2.380320e+08 2.384640e+08 2.388960e+08 2.393280e+08 2.397600e+08 2.401920e+08 2.406240e+08 2.410560e+08 2.414880e+08 2.419200e+08 2.423520e+08 2.427840e+08 2.432160e+08 2.436480e+08 2.440800e+08 2.445120e+08 2.449440e+08 2.453760e+08 2.458080e+08 2.462400e+08 2.466720e+08 2.471040e+08 2.475360e+08 2.479680e+08 2.484000e+08 2.488320e+08 2.492640e+08 2.496960e+08 2.501280e+08 2.505600e+08 2.509920e+08 2.514240e+08 2.518560e+08 2.522880e+08 2.527200e+08 2.531520e+08 2.535840e+08 2.540160e+08 2.544480e+08 2.548800e+08 2.553120e+08 2.557440e+08 2.561760e+08 2.566080e+08 2.570400e+08 2.574720e+08 2.579040e+08 2.583360e+08 2.587680e+08 2.592000e+08 2.596320e+08 2.600640e+08 2.604960e+08 2.609280e+08 2.613600e+08 2.617920e+08 2.622240e+08 2.626560e+08 2.630880e+08 2.635200e+08 2.639520e+08 2.643840e+08 2.648160e+08 2.652480e+08 2.656800e+08 2.661120e+08 2.665440e+08 2.669760e+08 2.674080e+08 2.678400e+08 2.682720e+08 2.687040e+08 2.691360e+08 2.695680e+08 2.700000e+08 2.704320e+08 2.708640e+08 2.712960e+08 2.717280e+08 2.721600e+08 2.725920e+08 2.730240e+08 2.734560e+08 2.738880e+08 2.743200e+08 2.747520e+08 2.751840e+08 2.756160e+08 2.760480e+08 2.764800e+08 2.769120e+08 2.773440e+08 2.777760e+08 2.782080e+08 2.786400e+08 2.790720e+08 2.795040e+08 2.799360e+08 2.803680e+08 2.808000e+08 2.812320e+08 2.816640e+08 2.820960e+08 2.825280e+08 2.829600e+08 2.833920e+08 2.838240e+08 2.842560e+08 2.846880e+08 2.851200e+08 2.855520e+08 2.859840e+08 2.864160e+08 2.868480e+08 2.872800e+08 2.877120e+08 2.881440e+08 2.885760e+08 2.890080e+08 2.894400e+08 2.898720e+08 2.903040e+08 2.907360e+08 2.911680e+08 2.916000e+08 2.920320e+08 2.924640e+08 2.928960e+08 2.933280e+08 2.937600e+08 2.941920e+08 2.946240e+08 2.950560e+08 2.954880e+08 2.959200e+08 2.963520e+08 2.967840e+08 2.972160e+08 2.976480e+08 2.980800e+08 2.985120e+08 2.989440e+08 2.993760e+08 2.998080e+08 3.002400e+08 3.006720e+08 3.011040e+08 3.015360e+08 3.019680e+08 3.024000e+08 3.028320e+08 3.032640e+08 3.036960e+08 3.041280e+08 3.045600e+08 3.049920e+08 3.054240e+08 3.058560e+08 3.062880e+08 3.067200e+08 3.071520e+08 3.075840e+08 3.080160e+08 3.084480e+08 3.088800e+08 3.093120e+08 3.097440e+08 3.101760e+08 3.106080e+08 3.110400e+08 3.114720e+08 3.119040e+08 3.123360e+08 3.127680e+08 3.132000e+08 3.136320e+08 3.140640e+08 3.144960e+08 3.149280e+08 3.153600e+08 3.157920e+08 3.162240e+08 3.166560e+08 3.170880e+08 3.175200e+08 3.179520e+08 3.183840e+08 3.188160e+08 3.192480e+08 3.196800e+08 3.201120e+08 3.205440e+08 3.209760e+08 3.214080e+08 3.218400e+08 3.222720e+08 3.227040e+08 3.231360e+08 3.235680e+08 3.240000e+08 3.244320e+08 3.248640e+08 3.252960e+08 3.257280e+08 3.261600e+08 3.265920e+08 3.270240e+08 3.274560e+08 3.278880e+08 3.283200e+08 3.287520e+08 3.291840e+08 3.296160e+08 3.300480e+08 3.304800e+08 3.309120e+08 3.313440e+08 3.317760e+08 3.322080e+08 3.326400e+08 3.330720e+08 3.335040e+08 3.339360e+08 3.343680e+08 3.348000e+08 3.352320e+08 3.356640e+08 3.360960e+08 3.365280e+08 3.369600e+08 3.373920e+08 3.378240e+08 3.382560e+08 3.386880e+08 3.391200e+08 3.395520e+08 3.399840e+08 3.404160e+08 3.408480e+08 3.412800e+08 3.417120e+08 3.421440e+08 3.425760e+08 3.430080e+08 3.434400e+08 3.438720e+08 3.443040e+08 3.447360e+08 3.451680e+08 3.456000e+08 3.460320e+08 3.464640e+08 3.468960e+08 3.473280e+08 3.477600e+08 3.481920e+08 3.486240e+08 3.490560e+08 3.494880e+08 3.499200e+08 3.503520e+08 3.507840e+08 3.512160e+08 3.516480e+08 3.520800e+08 3.525120e+08 3.529440e+08 3.533760e+08 3.538080e+08 3.542400e+08 3.546720e+08 3.551040e+08 3.555360e+08 3.559680e+08 3.564000e+08 3.568320e+08 3.572640e+08 3.576960e+08 3.581280e+08 3.585600e+08 3.589920e+08 3.594240e+08 3.598560e+08 3.602880e+08 3.607200e+08 3.611520e+08 3.615840e+08 3.620160e+08 3.624480e+08 3.628800e+08 3.633120e+08 3.637440e+08 3.641760e+08 3.646080e+08 3.650400e+08 3.654720e+08 3.659040e+08 3.663360e+08 3.667680e+08 3.672000e+08 3.676320e+08 3.680640e+08 3.684960e+08 3.689280e+08 3.693600e+08 3.697920e+08 3.702240e+08 3.706560e+08 3.710880e+08 3.715200e+08 3.719520e+08 3.723840e+08 3.728160e+08 3.732480e+08 3.736800e+08 3.741120e+08 3.745440e+08 3.749760e+08 3.754080e+08 3.758400e+08 3.762720e+08 3.767040e+08 3.771360e+08 3.775680e+08 3.780000e+08 3.784320e+08 3.788640e+08 3.792960e+08 3.797280e+08 3.801600e+08 3.805920e+08 3.810240e+08 3.814560e+08 3.818880e+08 3.823200e+08 3.827520e+08 3.831840e+08 3.836160e+08 3.840480e+08 3.844800e+08 3.849120e+08 3.853440e+08 3.857760e+08 3.862080e+08 3.866400e+08 3.870720e+08 3.875040e+08 3.879360e+08 3.883680e+08 3.888000e+08 3.892320e+08 3.896640e+08 3.900960e+08 3.905280e+08 3.909600e+08 3.913920e+08 3.918240e+08 3.922560e+08 3.926880e+08 3.931200e+08 3.935520e+08 3.939840e+08 3.944160e+08 3.948480e+08 3.952800e+08 3.957120e+08 3.961440e+08 3.965760e+08 3.970080e+08 3.974400e+08 3.978720e+08 3.983040e+08 3.987360e+08 3.991680e+08 3.996000e+08 4.000320e+08 4.004640e+08 4.008960e+08 4.013280e+08 4.017600e+08 4.021920e+08 4.026240e+08 4.030560e+08 4.034880e+08 4.039200e+08 4.043520e+08 4.047840e+08 4.052160e+08 4.056480e+08 4.060800e+08 4.065120e+08 4.069440e+08 4.073760e+08 4.078080e+08 4.082400e+08 4.086720e+08 4.091040e+08 4.095360e+08 4.099680e+08 4.104000e+08 4.108320e+08 4.112640e+08 4.116960e+08 4.121280e+08 4.125600e+08 4.129920e+08 4.134240e+08 4.138560e+08 4.142880e+08 4.147200e+08 4.151520e+08 4.155840e+08 4.160160e+08 4.164480e+08 4.168800e+08 4.173120e+08 4.177440e+08 4.181760e+08 4.186080e+08 4.190400e+08 4.194720e+08 4.199040e+08 4.203360e+08 4.207680e+08 4.212000e+08 4.216320e+08 4.220640e+08 4.224960e+08 4.229280e+08 4.233600e+08 4.237920e+08 4.242240e+08 4.246560e+08 4.250880e+08 4.255200e+08 4.259520e+08 4.263840e+08 4.268160e+08 4.272480e+08 4.276800e+08 4.281120e+08 4.285440e+08 4.289760e+08 4.294080e+08 4.298400e+08 4.302720e+08 4.307040e+08 4.311360e+08 4.315680e+08 4.320000e+08 4.324320e+08 4.328640e+08 4.332960e+08 4.337280e+08 4.341600e+08 4.345920e+08 4.350240e+08 4.354560e+08 4.358880e+08 4.363200e+08 4.367520e+08 4.371840e+08 4.376160e+08 4.380480e+08 4.384800e+08 4.389120e+08 4.393440e+08 4.397760e+08 4.402080e+08 4.406400e+08 4.410720e+08 4.415040e+08 4.419360e+08 4.423680e+08 4.428000e+08 4.432320e+08 4.436640e+08 4.440960e+08 4.445280e+08 4.449600e+08 4.453920e+08 4.458240e+08 4.462560e+08 4.466880e+08 4.471200e+08 4.475520e+08 4.479840e+08 4.484160e+08 4.488480e+08 4.492800e+08 4.497120e+08 4.501440e+08 4.505760e+08 4.510080e+08 4.514400e+08 4.518720e+08 4.523040e+08 4.527360e+08 4.531680e+08 4.536000e+08 4.540320e+08 4.544640e+08 4.548960e+08 4.553280e+08 4.557600e+08 4.561920e+08 4.566240e+08 4.570560e+08 4.574880e+08 4.579200e+08 4.583520e+08 4.587840e+08 4.592160e+08 4.596480e+08 4.600800e+08 4.605120e+08 4.609440e+08 4.613760e+08 4.618080e+08 4.622400e+08 4.626720e+08 4.631040e+08 4.635360e+08 4.639680e+08 4.644000e+08 4.648320e+08 4.652640e+08 4.656960e+08 4.661280e+08 4.665600e+08 4.669920e+08 4.674240e+08 4.678560e+08 4.682880e+08 4.687200e+08 4.691520e+08 4.695840e+08 4.700160e+08 4.704480e+08 4.708800e+08 4.713120e+08 4.717440e+08 4.721760e+08 4.726080e+08 4.730400e+08 4.734720e+08 4.739040e+08 4.743360e+08 4.747680e+08 4.752000e+08 4.756320e+08 4.760640e+08 4.764960e+08 4.769280e+08 4.773600e+08 4.777920e+08 4.782240e+08 4.786560e+08 4.790880e+08 4.795200e+08 4.799520e+08 4.803840e+08 4.808160e+08 4.812480e+08 4.816800e+08 4.821120e+08 4.825440e+08 4.829760e+08 4.834080e+08 4.838400e+08 4.842720e+08 4.847040e+08 4.851360e+08 4.855680e+08 4.860000e+08 4.864320e+08 4.868640e+08 4.872960e+08 4.877280e+08 4.881600e+08 4.885920e+08 4.890240e+08 4.894560e+08 4.898880e+08 4.903200e+08 4.907520e+08 4.911840e+08 4.916160e+08 4.920480e+08 4.924800e+08 4.929120e+08 4.933440e+08 4.937760e+08 4.942080e+08 4.946400e+08 4.950720e+08 4.955040e+08 4.959360e+08 4.963680e+08 4.968000e+08 4.972320e+08 4.976640e+08 4.980960e+08 4.985280e+08 4.989600e+08 4.993920e+08 4.998240e+08 5.002560e+08 5.006880e+08 5.011200e+08 5.015520e+08 5.019840e+08 5.024160e+08 5.028480e+08 5.032800e+08 5.037120e+08 5.041440e+08 5.045760e+08 5.050080e+08 5.054400e+08 5.058720e+08 5.063040e+08 5.067360e+08 5.071680e+08 5.076000e+08 5.080320e+08 5.084640e+08 5.088960e+08 5.093280e+08 5.097600e+08 5.101920e+08 5.106240e+08 5.110560e+08 5.114880e+08 5.119200e+08 5.123520e+08 5.127840e+08 5.132160e+08 5.136480e+08 5.140800e+08 5.145120e+08 5.149440e+08 5.153760e+08 5.158080e+08 5.162400e+08 5.166720e+08 5.171040e+08 5.175360e+08 5.179680e+08 5.184000e+08 5.188320e+08 5.192640e+08 5.196960e+08 5.201280e+08 5.205600e+08 5.209920e+08 5.214240e+08 5.218560e+08 5.222880e+08 5.227200e+08 5.231520e+08 5.235840e+08 5.240160e+08 5.244480e+08 5.248800e+08 5.253120e+08 5.257440e+08 5.261760e+08 5.266080e+08 5.270400e+08 5.274720e+08 5.279040e+08 5.283360e+08 5.287680e+08 5.292000e+08 5.296320e+08 5.300640e+08 5.304960e+08 5.309280e+08 5.313600e+08 5.317920e+08 5.322240e+08 5.326560e+08 5.330880e+08 5.335200e+08 5.339520e+08 5.343840e+08 5.348160e+08 5.352480e+08 5.356800e+08 5.361120e+08 5.365440e+08 5.369760e+08 5.374080e+08 5.378400e+08 5.382720e+08 5.387040e+08 5.391360e+08 5.395680e+08 5.400000e+08 5.404320e+08 5.408640e+08 5.412960e+08 5.417280e+08 5.421600e+08 5.425920e+08 5.430240e+08 5.434560e+08 5.438880e+08 5.443200e+08 5.447520e+08 5.451840e+08 5.456160e+08 5.460480e+08 5.464800e+08 5.469120e+08 5.473440e+08 5.477760e+08 5.482080e+08 5.486400e+08 5.490720e+08 5.495040e+08 5.499360e+08 5.503680e+08 5.508000e+08 5.512320e+08 5.516640e+08 5.520960e+08 5.525280e+08 5.529600e+08 5.533920e+08 5.538240e+08 5.542560e+08 5.546880e+08 5.551200e+08 5.555520e+08 5.559840e+08 5.564160e+08 5.568480e+08 5.572800e+08 5.577120e+08 5.581440e+08 5.585760e+08 5.590080e+08 5.594400e+08 5.598720e+08 5.603040e+08 5.607360e+08 5.611680e+08 5.616000e+08 5.620320e+08 5.624640e+08 5.628960e+08 5.633280e+08 5.637600e+08 5.641920e+08 5.646240e+08 5.650560e+08 5.654880e+08 5.659200e+08 5.663520e+08 5.667840e+08 5.672160e+08 5.676480e+08 5.680800e+08 5.685120e+08 5.689440e+08 5.693760e+08 5.698080e+08 5.702400e+08 5.706720e+08 5.711040e+08 5.715360e+08 5.719680e+08 5.724000e+08 5.728320e+08 5.732640e+08 5.736960e+08 5.741280e+08 5.745600e+08 5.749920e+08 5.754240e+08 5.758560e+08 5.762880e+08 5.767200e+08 5.771520e+08 5.775840e+08 5.780160e+08 5.784480e+08 5.788800e+08 5.793120e+08 5.797440e+08 5.801760e+08 5.806080e+08 5.810400e+08 5.814720e+08 5.819040e+08 5.823360e+08 5.827680e+08 5.832000e+08 5.836320e+08 5.840640e+08 5.844960e+08 5.849280e+08 5.853600e+08 5.857920e+08 5.862240e+08 5.866560e+08 5.870880e+08 5.875200e+08 5.879520e+08 5.883840e+08 5.888160e+08 5.892480e+08 5.896800e+08 5.901120e+08 5.905440e+08 5.909760e+08 5.914080e+08 5.918400e+08 5.922720e+08 5.927040e+08 5.931360e+08 5.935680e+08 5.940000e+08 5.944320e+08 5.948640e+08 5.952960e+08 5.957280e+08 5.961600e+08 5.965920e+08 5.970240e+08 5.974560e+08 5.978880e+08 5.983200e+08 5.987520e+08 5.991840e+08 5.996160e+08 6.000480e+08 6.004800e+08 6.009120e+08 6.013440e+08 6.017760e+08 6.022080e+08 6.026400e+08 6.030720e+08 6.035040e+08 6.039360e+08 6.043680e+08 6.048000e+08 6.052320e+08 6.056640e+08 6.060960e+08 6.065280e+08 6.069600e+08 6.073920e+08 6.078240e+08 6.082560e+08 6.086880e+08 6.091200e+08 6.095520e+08 6.099840e+08 6.104160e+08 6.108480e+08 6.112800e+08 6.117120e+08 6.121440e+08 6.125760e+08 6.130080e+08 6.134400e+08 6.138720e+08 6.143040e+08 6.147360e+08 6.151680e+08 6.156000e+08 6.160320e+08 6.164640e+08 6.168960e+08 6.173280e+08 6.177600e+08 6.181920e+08 6.186240e+08 6.190560e+08 6.194880e+08 6.199200e+08 6.203520e+08 6.207840e+08 6.212160e+08 6.216480e+08 6.220800e+08 6.225120e+08 6.229440e+08 6.233760e+08 6.238080e+08 6.242400e+08 6.246720e+08 6.251040e+08 6.255360e+08 6.259680e+08 6.264000e+08 6.268320e+08 6.272640e+08 6.276960e+08 6.281280e+08 6.285600e+08 6.289920e+08 6.294240e+08 6.298560e+08 6.302880e+08 6.307200e+08 6.311520e+08 6.315840e+08 6.320160e+08 6.324480e+08 6.328800e+08 6.333120e+08 6.337440e+08 6.341760e+08 6.346080e+08 6.350400e+08 6.354720e+08 6.359040e+08 6.363360e+08 6.367680e+08 6.372000e+08 6.376320e+08 6.380640e+08 6.384960e+08 6.389280e+08 6.393600e+08 6.397920e+08 6.402240e+08 6.406560e+08 6.410880e+08 6.415200e+08 6.419520e+08 6.423840e+08 6.428160e+08 6.432480e+08 6.436800e+08 6.441120e+08 6.445440e+08 6.449760e+08 6.454080e+08 6.458400e+08 6.462720e+08 6.467040e+08 6.471360e+08 6.475680e+08 6.480000e+08 6.484320e+08 6.488640e+08 6.492960e+08 6.497280e+08 6.501600e+08 6.505920e+08 6.510240e+08 6.514560e+08 6.518880e+08 6.523200e+08 6.527520e+08 6.531840e+08 6.536160e+08 6.540480e+08 6.544800e+08 6.549120e+08 6.553440e+08 6.557760e+08 6.562080e+08 6.566400e+08 6.570720e+08 6.575040e+08 6.579360e+08 6.583680e+08 6.588000e+08 6.592320e+08 6.596640e+08 6.600960e+08 6.605280e+08 6.609600e+08 6.613920e+08 6.618240e+08 6.622560e+08 6.626880e+08 6.631200e+08 6.635520e+08 6.639840e+08 6.644160e+08 6.648480e+08 6.652800e+08 6.657120e+08 6.661440e+08 6.665760e+08 6.670080e+08 6.674400e+08 6.678720e+08 6.683040e+08 6.687360e+08 6.691680e+08 6.696000e+08 6.700320e+08 6.704640e+08 6.708960e+08 6.713280e+08 6.717600e+08 6.721920e+08 6.726240e+08 6.730560e+08 6.734880e+08 6.739200e+08 6.743520e+08 6.747840e+08 6.752160e+08 6.756480e+08 6.760800e+08 6.765120e+08 6.769440e+08 6.773760e+08 6.778080e+08 6.782400e+08 6.786720e+08 6.791040e+08 6.795360e+08 6.799680e+08 6.804000e+08 6.808320e+08 6.812640e+08 6.816960e+08 6.821280e+08 6.825600e+08 6.829920e+08 6.834240e+08 6.838560e+08 6.842880e+08 6.847200e+08 6.851520e+08 6.855840e+08 6.860160e+08 6.864480e+08 6.868800e+08 6.873120e+08 6.877440e+08 6.881760e+08 6.886080e+08 6.890400e+08 6.894720e+08 6.899040e+08 6.903360e+08 6.907680e+08 6.912000e+08 6.916320e+08 6.920640e+08 6.924960e+08 6.929280e+08 6.933600e+08 6.937920e+08 6.942240e+08 6.946560e+08 6.950880e+08 6.955200e+08 6.959520e+08 6.963840e+08 6.968160e+08 6.972480e+08 6.976800e+08 6.981120e+08 6.985440e+08 6.989760e+08 6.994080e+08 6.998400e+08 7.002720e+08 7.007040e+08 7.011360e+08 7.015680e+08 7.020000e+08 7.024320e+08 7.028640e+08 7.032960e+08 7.037280e+08 7.041600e+08 7.045920e+08 7.050240e+08 7.054560e+08 7.058880e+08 7.063200e+08 7.067520e+08 7.071840e+08 7.076160e+08 7.080480e+08 7.084800e+08 7.089120e+08 7.093440e+08 7.097760e+08 7.102080e+08 7.106400e+08 7.110720e+08 7.115040e+08 7.119360e+08 7.123680e+08 7.128000e+08 7.132320e+08 7.136640e+08 7.140960e+08 7.145280e+08 7.149600e+08 7.153920e+08 7.158240e+08 7.162560e+08 7.166880e+08 7.171200e+08 7.175520e+08 7.179840e+08 7.184160e+08 7.188480e+08 7.192800e+08 7.197120e+08 7.201440e+08 7.205760e+08 7.210080e+08 7.214400e+08 7.218720e+08 7.223040e+08 7.227360e+08 7.231680e+08 7.236000e+08 7.240320e+08 7.244640e+08 7.248960e+08 7.253280e+08 7.257600e+08 7.261920e+08 7.266240e+08 7.270560e+08 7.274880e+08 7.279200e+08 7.283520e+08 7.287840e+08 7.292160e+08 7.296480e+08 7.300800e+08 7.305120e+08 7.309440e+08 7.313760e+08 7.318080e+08 7.322400e+08 7.326720e+08 7.331040e+08 7.335360e+08 7.339680e+08 7.344000e+08 7.348320e+08 7.352640e+08 7.356960e+08 7.361280e+08 7.365600e+08 7.369920e+08 7.374240e+08 7.378560e+08 7.382880e+08 7.387200e+08 7.391520e+08 7.395840e+08 7.400160e+08 7.404480e+08 7.408800e+08 7.413120e+08 7.417440e+08 7.421760e+08 7.426080e+08 7.430400e+08 7.434720e+08 7.439040e+08 7.443360e+08 7.447680e+08 7.452000e+08 7.456320e+08 7.460640e+08 7.464960e+08 7.469280e+08 7.473600e+08 7.477920e+08 7.482240e+08 7.486560e+08 7.490880e+08 7.495200e+08 7.499520e+08 7.503840e+08 7.508160e+08 7.512480e+08 7.516800e+08 7.521120e+08 7.525440e+08 7.529760e+08 7.534080e+08 7.538400e+08 7.542720e+08 7.547040e+08 7.551360e+08 7.555680e+08 7.560000e+08 7.564320e+08 7.568640e+08 7.572960e+08 7.577280e+08 7.581600e+08 7.585920e+08 7.590240e+08 7.594560e+08 7.598880e+08 7.603200e+08 7.607520e+08 7.611840e+08 7.616160e+08 7.620480e+08 7.624800e+08 7.629120e+08 7.633440e+08 7.637760e+08 7.642080e+08 7.646400e+08 7.650720e+08 7.655040e+08 7.659360e+08 7.663680e+08 7.668000e+08 7.672320e+08 7.676640e+08 7.680960e+08 7.685280e+08 7.689600e+08 7.693920e+08 7.698240e+08 7.702560e+08 7.706880e+08 7.711200e+08 7.715520e+08 7.719840e+08 7.724160e+08 7.728480e+08 7.732800e+08 7.737120e+08 7.741440e+08 7.745760e+08 7.750080e+08 7.754400e+08 7.758720e+08 7.763040e+08 7.767360e+08 7.771680e+08 7.776000e+08 7.780320e+08 7.784640e+08 7.788960e+08 7.793280e+08 7.797600e+08 7.801920e+08 7.806240e+08 7.810560e+08 7.814880e+08 7.819200e+08 7.823520e+08 7.827840e+08 7.832160e+08 7.836480e+08 7.840800e+08 7.845120e+08 7.849440e+08 7.853760e+08 7.858080e+08 7.862400e+08 7.866720e+08 7.871040e+08 7.875360e+08 7.879680e+08 7.884000e+08 7.888320e+08 7.892640e+08 7.896960e+08 7.901280e+08 7.905600e+08 7.909920e+08 7.914240e+08 7.918560e+08 7.922880e+08 7.927200e+08 7.931520e+08 7.935840e+08 7.940160e+08 7.944480e+08 7.948800e+08 7.953120e+08 7.957440e+08 7.961760e+08 7.966080e+08 7.970400e+08 7.974720e+08 7.979040e+08 7.983360e+08 7.987680e+08 7.992000e+08 7.996320e+08 8.000640e+08 8.004960e+08 8.009280e+08 8.013600e+08 8.017920e+08 8.022240e+08 8.026560e+08 8.030880e+08 8.035200e+08 8.039520e+08 8.043840e+08 8.048160e+08 8.052480e+08 8.056800e+08 8.061120e+08 8.065440e+08 8.069760e+08 8.074080e+08 8.078400e+08 8.082720e+08 8.087040e+08 8.091360e+08 8.095680e+08 8.100000e+08 8.104320e+08 8.108640e+08 8.112960e+08 8.117280e+08 8.121600e+08 8.125920e+08 8.130240e+08 8.134560e+08 8.138880e+08 8.143200e+08 8.147520e+08 8.151840e+08 8.156160e+08 8.160480e+08 8.164800e+08 8.169120e+08 8.173440e+08 8.177760e+08 8.182080e+08 8.186400e+08 8.190720e+08 8.195040e+08 8.199360e+08 8.203680e+08 8.208000e+08 8.212320e+08 8.216640e+08 8.220960e+08 8.225280e+08 8.229600e+08 8.233920e+08 8.238240e+08 8.242560e+08 8.246880e+08 8.251200e+08 8.255520e+08 8.259840e+08 8.264160e+08 8.268480e+08 8.272800e+08 8.277120e+08 8.281440e+08 8.285760e+08 8.290080e+08 8.294400e+08 8.298720e+08 8.303040e+08 8.307360e+08 8.311680e+08 8.316000e+08 8.320320e+08 8.324640e+08 8.328960e+08 8.333280e+08 8.337600e+08 8.341920e+08 8.346240e+08 8.350560e+08 8.354880e+08 8.359200e+08 8.363520e+08 8.367840e+08 8.372160e+08 8.376480e+08 8.380800e+08 8.385120e+08 8.389440e+08 8.393760e+08 8.398080e+08 8.402400e+08 8.406720e+08 8.411040e+08 8.415360e+08 8.419680e+08 8.424000e+08 8.428320e+08 8.432640e+08 8.436960e+08 8.441280e+08 8.445600e+08 8.449920e+08 8.454240e+08 8.458560e+08 8.462880e+08 8.467200e+08 8.471520e+08 8.475840e+08 8.480160e+08 8.484480e+08 8.488800e+08 8.493120e+08 8.497440e+08 8.501760e+08 8.506080e+08 8.510400e+08 8.514720e+08 8.519040e+08 8.523360e+08 8.527680e+08 8.532000e+08 8.536320e+08 8.540640e+08 8.544960e+08 8.549280e+08 8.553600e+08 8.557920e+08 8.562240e+08 8.566560e+08 8.570880e+08 8.575200e+08 8.579520e+08 8.583840e+08 8.588160e+08 8.592480e+08 8.596800e+08 8.601120e+08 8.605440e+08 8.609760e+08 8.614080e+08 8.618400e+08 8.622720e+08 8.627040e+08 8.631360e+08 8.635680e+08 8.640000e+08 8.644320e+08 8.648640e+08 8.652960e+08 8.657280e+08 8.661600e+08 8.665920e+08 8.670240e+08 8.674560e+08 8.678880e+08 8.683200e+08 8.687520e+08 8.691840e+08 8.696160e+08 8.700480e+08 8.704800e+08 8.709120e+08 8.713440e+08 8.717760e+08 8.722080e+08 8.726400e+08 8.730720e+08 8.735040e+08 8.739360e+08 8.743680e+08 8.748000e+08 8.752320e+08 8.756640e+08 8.760960e+08 8.765280e+08 8.769600e+08 8.773920e+08 8.778240e+08 8.782560e+08 8.786880e+08 8.791200e+08 8.795520e+08 8.799840e+08 8.804160e+08 8.808480e+08 8.812800e+08 8.817120e+08 8.821440e+08 8.825760e+08 8.830080e+08 8.834400e+08 8.838720e+08 8.843040e+08 8.847360e+08 8.851680e+08 8.856000e+08 8.860320e+08 8.864640e+08 8.868960e+08 8.873280e+08 8.877600e+08 8.881920e+08 8.886240e+08 8.890560e+08 8.894880e+08 8.899200e+08 8.903520e+08 8.907840e+08 8.912160e+08 8.916480e+08 8.920800e+08 8.925120e+08 8.929440e+08 8.933760e+08 8.938080e+08 8.942400e+08 8.946720e+08 8.951040e+08 8.955360e+08 8.959680e+08 8.964000e+08 8.968320e+08 8.972640e+08 8.976960e+08 8.981280e+08 8.985600e+08 8.989920e+08 8.994240e+08 8.998560e+08 9.002880e+08 9.007200e+08 9.011520e+08 9.015840e+08 9.020160e+08 9.024480e+08 9.028800e+08 9.033120e+08 9.037440e+08 9.041760e+08 9.046080e+08 9.050400e+08 9.054720e+08 9.059040e+08 9.063360e+08 9.067680e+08 9.072000e+08 9.076320e+08 9.080640e+08 9.084960e+08 9.089280e+08 9.093600e+08 9.097920e+08 9.102240e+08 9.106560e+08 9.110880e+08 9.115200e+08 9.119520e+08 9.123840e+08 9.128160e+08 9.132480e+08 9.136800e+08 9.141120e+08 9.145440e+08 9.149760e+08 9.154080e+08 9.158400e+08 9.162720e+08 9.167040e+08 9.171360e+08 9.175680e+08 9.180000e+08 9.184320e+08 9.188640e+08 9.192960e+08 9.197280e+08 9.201600e+08 9.205920e+08 9.210240e+08 9.214560e+08 9.218880e+08 9.223200e+08 9.227520e+08 9.231840e+08 9.236160e+08 9.240480e+08 9.244800e+08 9.249120e+08 9.253440e+08 9.257760e+08 9.262080e+08 9.266400e+08 9.270720e+08 9.275040e+08 9.279360e+08 9.283680e+08 9.288000e+08 9.292320e+08 9.296640e+08 9.300960e+08 9.305280e+08 9.309600e+08 9.313920e+08 9.318240e+08 9.322560e+08 9.326880e+08 9.331200e+08 9.335520e+08 9.339840e+08 9.344160e+08 9.348480e+08 9.352800e+08 9.357120e+08 9.361440e+08 9.365760e+08 9.370080e+08 9.374400e+08 9.378720e+08 9.383040e+08 9.387360e+08 9.391680e+08 9.396000e+08 9.400320e+08 9.404640e+08 9.408960e+08 9.413280e+08 9.417600e+08 9.421920e+08 9.426240e+08 9.430560e+08 9.434880e+08 9.439200e+08 9.443520e+08 9.447840e+08 9.452160e+08 9.456480e+08'
    sync_only = ${output_only_selected_timesteps}
  []
[]
[Debug]
  show_material_props = false
  show_var_residual_norms = true
[]
