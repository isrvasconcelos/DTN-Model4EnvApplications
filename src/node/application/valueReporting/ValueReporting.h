/****************************************************************************
 *  Copyright: National ICT Australia,  2007 - 2011                         *
 *  Developed at the ATP lab, Networked Systems research theme              *
 *  Author(s): Dimosthenis Pediaditakis, Yuriy Tselishchev                  *
 *  This file is distributed under the terms in the attached LICENSE file.  *
 *  If you do not find this file, copies can be found by writing to:        *
 *                                                                          *
 *      NICTA, Locked Bag 9013, Alexandria, NSW 1435, Australia             *
 *      Attention:  License Inquiry.                                        *
 *                                                                          *
 ****************************************************************************/

#ifndef _VALUEREPORTING_H_
#define _VALUEREPORTING_H_

#include "ValueReportingPacket_m.h"
#include "VirtualApplication.h"
#include "algorithms.h"

enum ValueReportingTimers {
	REQUEST_SAMPLE = 1,
	SEND_DATA = 2,
};

class ValueReporting: public VirtualApplication { // Isr.: Modified (Feb, 2016)
 private:
	double maxSampleInterval;
	double minSampleInterval;

	int routingLevel;
	double lastSensedValue;
	int currSentSampleSN;

	double randomBackoffIntervalFraction;
	bool sentOnce;
	int loopControl;
	bool keepSampling;

	// Output info
	int seed;
	int numNodes;
	int timeLimit;
	int sinkSpeed;
	int sampleRate;
	int bufferSize;
	int contamination;
	string txPower;
	string evaluation;
	string samplingAlgorithm;

	// Sensing nodes
	bool sendNow; // default value should be: false
	bool displaySampleSensing;
	bool done;
	queue<double> nodeBuffer;

	// Sink only
	bool hold; // default value should be: false
	int notifyLocationPeriod; // 
	double bufferFree;
	string ogkDropPointer; // Points to the node which the data set will be sampled.
	vector<string> dropQueue; //
	unordered_map<string, vector< pair<double,int> >> sinkBuffer; // pair<double, int> where -> #first: data sample | second: sequence number

 protected:
	void startup();

	void fromNetworkLayer(ApplicationPacket *, const char *, double, double);
	void handleSensorReading(SensorReadingMessage *);
	void dropQueueAppend(string ID);
	void timerFiredCallback(int);
	void sampleWith(string name);
	void outputSinkBuffer();
	void updateFreeBuffer();
	void avoidLoop();

	void outputSinkBufferSamples();
	string generateFileNamePrefix();

	ValueReportingDataPacket* createDataPkt(double sensValue, int seqNumber);
	ValueReportingDataPacket* createControlPkt(string command);
};

#endif				// _VALUEREPORTING_APPLICATIONMODULE_H_
