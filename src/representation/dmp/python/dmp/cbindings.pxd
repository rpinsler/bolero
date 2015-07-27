# Declare class that will be wrapped by Cython
from libcpp cimport bool
from libcpp.string cimport string
from libcpp.vector cimport vector
  	
cdef extern from "lib_manager/LibInterface.hpp" namespace "lib_manager":
  cdef cppclass LibManager


cdef extern from "CanonicalSystem.h" namespace "dmp::CanonicalSystem":
    double calculateAlpha(double lastPhaseValue, double dt, double executionTime)
    double calculateAlpha(double lastPhaseValue, int numPhases)
	

cdef extern from "RbfFunctionApproximator.h" namespace "dmp::RbfFunctionApproximator":
    void calculateCenters(double lastPhaseValue, double executionTime,
                          double dt, unsigned numCenters,
                          double overlap, double* centers,
                          double* widths)


cdef extern from "Dmp.h" namespace "dmp::Dmp":
    void determineForces(double* positions, double* velocities,
                         double* accelerations, int posVelAccRows,
                         int posVelAccCols, double* forces,
                         int forcesRows, int forcesCols,
                         double executionTime, double dt,
                         double alphaZ, double betaZ)

	
cdef extern from "Dmp.h" namespace "dmp":
    cdef cppclass Dmp:    
        Dmp(double executionTime, double alpha, double dt,
            unsigned numCenters, double overlap, double alphaZ,
            double betaZ, unsigned integrationSteps)

        Dmp(Dmp other)
                                                                     
        void initialize(double* startPos, double* startVel,
                        double* startAcc, double* endPos,
                        double* endVel, double* endAcc, int len)

        void changeGoal(double* position, double* velocity,
                        double* acceleration, unsigned len)

        void changeTime(double executionTime)

        bool executeStep(double* position, double* velocity,
                         double* acceleration, int len)

        void setWeights(double* newWeights, int rows, int cols)

        void getWeights(double* weights, int rows, int cols)

        void getActivations(double s, bool normalized, double* out, int size)

        void getPhases(double* phases, int len)

        int getTaskDimensions()


cdef extern from "DMPModel.h" namespace "dmp_cpp":
    cdef cppclass DMPModel:
        vector[double] rbf_centers
        double ts_tau
        double ts_dt

        void to_yaml_file(string filepath)


cdef extern from "DMPWrapper.h" namespace "dmp_cpp":
    cdef cppclass DMPWrapper:
        DMPWrapper()
        void init_from_dmp(Dmp& dmp)
        void init_from_yaml(string filepath, string name)
        DMPModel generate_model()
        Dmp dmp()


cdef extern from "RigidBodyDmp.h" namespace "dmp::RigidBodyDmp":
    void determineForces(double* positions, int positionRows,
                         int positionCols, double* rotations,
                         int rotationRows, int rotationCols,
                         double* forces, int forcesRows, int forcesCols,
                         double executionTime, double dt,
                         double alphaZ, double betaZ)

    void determineForces(double* positions, int positionRows,
                         int positionCols,double* forces, int forcesRows,
                         int forcesCols, double executionTime, double dt,
                         double alphaZ, double betaZ)


cdef extern from "RigidBodyDmp.h" namespace "dmp":
    cdef cppclass RigidBodyDmp:    
        RigidBodyDmp(LibManager* manager)
        void setInputs(double *values, int numInputs)
        void getOutputs(double *values, int numOutputs)
        void step()
        bool canStep()
        bool configureYaml(string& yaml)
        bool initializeYaml(string& yaml)
        void getActivations(double s, bool normalized, double* activations, int size)
        void setWeights(double *weights, int rows, int cols)
        void getWeights(double* weights, int rows, int cols)
        void getPhases(double* phases, int len)
