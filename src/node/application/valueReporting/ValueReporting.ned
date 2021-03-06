//***************************************************************************************
//*  Copyright: National ICT Australia, 2007 - 2010                                     *
//*  Developed at the ATP lab, Networked Systems research theme                         *
//*  Author(s): Dimosthenis Pediaditakis, Yuriy Tselishchev                             *
//*  This file is distributed under the terms in the attached LICENSE file.             *
//*  If you do not find this file, copies can be found by writing to:                   *
//*                                                                                     *
//*      NICTA, Locked Bag 9013, Alexandria, NSW 1435, Australia                        *
//*      Attention:  License Inquiry.                                                   *
//*                                                                                     *
//***************************************************************************************

package node.application.valueReporting;

// The sensor node module. Connects to the wireless channel in order to communicate 
// with other nodes. Connects to physical processes so it can sample them.

simple ValueReporting like node.application.iApplication {
 parameters:
 	string applicationID = default ("valueReporting");
	string samplingAlgorithm = default ("");
	string evaluation = default("");

	bool collectTraceInfo = default (true);
	int priority = default (1);
	int packetHeaderOverhead = default (8);	// in bytes
	int constantDataPayload = default (12);	// in bytes
	int maxSampleInterval = default (2500);// in msec
	int minSampleInterval = default (250);	// in msec
	int bufferSize = default (1000);
	int contamination = default(0);
	int sampleRate = default (25); //  between [1,100] %
	double sinkSpeed = default(2); // (m/s) temporary solution

	bool isSink = default (false);
	bool displaySampleSensing = default (false);

	int seed = default (1);
	int nodes = default (50);
	

 gates:
 	output toCommunicationModule;
	output toSensorDeviceManager;
	input fromCommunicationModule;
	input fromSensorDeviceManager;
	input fromResourceManager;
}

