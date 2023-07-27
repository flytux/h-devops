#!/bin/bash
set -e
set -x

PINPOINT_VERSION=2.5.2
SPRING_PROFILES=release

### Pinpoint-Agent

PROFILER_TRANSPORT_STAT_COLLECTOR_PORT=9992
PROFILER_SAMPLING_NEW_THROUGHPUT=0
PROFILER_TRANSPORT_MODULE=GRPC
PROFILER_SAMPLING_CONTINUE_THROUGHPUT=0
DEBUG_LEVEL=INFO
PROFILER_SAMPLING_PERCENT_SAMPLING_RATE=100
COLLECTOR_IP=pipoint-pinpoint-collector
PROFILER_TRANSPORT_METADATA_COLLECTOR_PORT=9991
PROFILER_TRANSPORT_SPAN_COLLECTOR_PORT=9993
PROFILER_TRANSPORT_AGENT_COLLECTOR_PORT=9991
PROFILER_SAMPLING_COUNTING_SAMPLING_RATE=1
PROFILER_SAMPLING_TYPE=COUNTING

### Pinpoint-quickstart

APP_PORT=8080

#sed -i "/profiler.transport.module=/ s/=.*/=${PROFILER_TRANSPORT_MODULE}/" /pinpoint-agent/pinpoint.config
sed -i "/profiler.transport.module=/ s/=.*/=${PROFILER_TRANSPORT_MODULE}/" /pinpoint-agent/profiles/local/pinpoint.config /pinpoint-agent/profiles/release/pinpoint.config

sed -i "/profiler.collector.ip=/ s/=.*/=${COLLECTOR_IP}/" /pinpoint-agent/profiles/local/pinpoint.config /pinpoint-agent/profiles/release/pinpoint.config
sed -i "/profiler.collector.tcp.port=/ s/=.*/=${COLLECTOR_TCP_PORT}/" /pinpoint-agent/pinpoint-root.config
sed -i "/profiler.collector.stat.port=/ s/=.*/=${COLLECTOR_STAT_PORT}/" /pinpoint-agent/pinpoint-root.config
sed -i "/profiler.collector.span.port=/ s/=.*/=${COLLECTOR_SPAN_PORT}/" /pinpoint-agent/pinpoint-root.config

#sed -i "/profiler.transport.grpc.collector.ip=/ s/=.*/=${COLLECTOR_IP}/" /pinpoint-agent/pinpoint.config
sed -i "/profiler.transport.grpc.collector.ip=/ s/=.*/=${COLLECTOR_IP}/" /pinpoint-agent/profiles/local/pinpoint.config /pinpoint-agent/profiles/release/pinpoint.config
sed -i "/profiler.transport.grpc.agent.collector.port=/ s/=.*/=${PROFILER_TRANSPORT_AGENT_COLLECTOR_PORT}/" /pinpoint-agent/pinpoint-root.config
sed -i "/profiler.transport.grpc.metadata.collector.port=/ s/=.*/=${PROFILER_TRANSPORT_METADATA_COLLECTOR_PORT}/" /pinpoint-agent/pinpoint-root.config
sed -i "/profiler.transport.grpc.stat.collector.port=/ s/=.*/=${PROFILER_TRANSPORT_STAT_COLLECTOR_PORT}/" /pinpoint-agent/pinpoint-root.config
sed -i "/profiler.transport.grpc.span.collector.port=/ s/=.*/=${PROFILER_TRANSPORT_SPAN_COLLECTOR_PORT}/" /pinpoint-agent/pinpoint-root.config
sed -i "/profiler.sampling.type=/ s/=.*/=${PROFILER_SAMPLING_TYPE}/" /pinpoint-agent/profiles/local/pinpoint.config /pinpoint-agent/profiles/release/pinpoint.config
sed -i "/profiler.sampling.counting.sampling-rate=/ s/=.*/=${PROFILER_SAMPLING_COUNTING_SAMPLING_RATE}/" /pinpoint-agent/profiles/local/pinpoint.config /pinpoint-agent/profiles/release/pinpoint.config
sed -i "/profiler.sampling.percent.sampling-rate=/ s/=.*/=${PROFILER_SAMPLING_PERCENT_SAMPLING_RATE}/" /pinpoint-agent/profiles/local/pinpoint.config /pinpoint-agent/profiles/release/pinpoint.config
sed -i "/profiler.sampling.new.throughput=/ s/=.*/=${PROFILER_SAMPLING_NEW_THROUGHPUT}/" /pinpoint-agent/profiles/local/pinpoint.config /pinpoint-agent/profiles/release/pinpoint.config
sed -i "/profiler.sampling.continue.throughput=/ s/=.*/=${PROFILER_SAMPLING_CONTINUE_THROUGHPUT}/" /pinpoint-agent/profiles/local/pinpoint.config /pinpoint-agent/profiles/release/pinpoint.config

sed -i "/Root level=/ s/=.*/=\"${DEBUG_LEVEL}\">/g" /pinpoint-agent/profiles/local/log4j2.xml /pinpoint-agent/profiles/release/log4j2.xml

exec "$@"

