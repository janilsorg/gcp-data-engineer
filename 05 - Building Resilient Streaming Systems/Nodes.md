# System Lag/Elements Added
<p>
System Lag is an important metric for streaming pipelines. It represents the amount of time data elements are waiting to be processed since they "arrived" in the input of the transformation step.</p>

<p>
Elements Added metric under output collections tells you how many data elements exited this step (for the Read PubSub Msg step of the pipeline it also represents the number of Pub/Sub messages read from the topic by the Pub/Sub IO connector).
</p>


# Dataflow Metrics
 - Job status: Job status (Failed, Successful), reported as an enum every 30 secs and on update.
 - Elapsed time: Job elapsed time (measured in seconds), reported every 30 secs.
 - System lag: Max lag across the entire pipeline, reported in seconds.
 - Current vCPU count: Current # of virtual CPUs used by job and updated on value change.
 - Estimated byte count: Number of bytes processed per PCollection. 