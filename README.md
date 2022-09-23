# Model-Based Design and Verification for Infusion Pump

## Infusion Pump Overview:

Infusion pump is a medical device used to deliver fluids (medication or nutrients) into a patient's body in a controlled manner.
There are several types of infusion pumps distinguished by being either, manual, or semiautomatic or fully automatic. 
In manual pumps, the flow control depends on the pressure created as result of gravity, since it consists in two liquid reservoirs and a three-way stopcock used to regulate the flow manually, which differs from the semiautomatic type which in turn is automatically controlled by a set of LED/phototransistor counting the number of times the beam is interrupted and emitting alarms. 
The automatic pumps are used when a better precision is needed. In this modeling example, a syringe mechanism is used to serve as the fluid reservoir. DC motor is used to manage liquid movement through positioning the plunger. 

![Top Level Model](Image/top_level.jpg)

## Model-Based Design in Medical Device:

The Medical Device community is increasingly looking towards modeling and simulation techniques used in other safety-critical applications to reduce design risks and reduce probability of device recalls, in an environment of ever-increasing system and software complexity. 
Model-Based Design is a simulation-based software development environment that incorporates verification and validation into the workflow. As a result, the functionality of the software is comprehensively tested and verified before you integrate it into a medical device. In addition, most of the documentation required by IEC 62304 standard are automatically created for regulatory compliance.
Model-Based Design is not new and has been been used for many years by the Aerospace,Automotive and Transportation industries for developing safety critical software systems.

This project provides principles of model based design through the example of an infusion pump and simulating its dynamics. Using Simulink, Stateflow and Simscape, we can build, simulate, implment and test any dynamics system and understand the behavior of any device. 

## Resources 
Modeling infusion pump in Simulink video : https://www.mathworks.com/videos/series/modeling-an-infusion-pump.html

## Products
- MATLAB™
- Simulink™
- Stateflow™
- Simscape™
- Simscape Multibody™
- Simscape Fluids™
- Simulink Test™
- Simulink Requirements™


_The license is available in the License file within this repository_
_Copyright 2022 The MathWorks, Inc._
