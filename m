Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81454514264
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 08:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351544AbiD2Gfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 02:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237453AbiD2Gfo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 02:35:44 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C67DAB9F13
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 23:32:26 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1651213944;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QqgVeMPsWGnOQhz4oVzHwiyJ9rj1VsnTUxUpXZenVIo=;
        b=x+u/QPxMPsgqKsCSm868DEzfFK0Dgatx6PICiPIj4IFdfxudYXDd10MhdEYE7NddLB5mmJ
        6gX+Ssbw6GPUkXNK5jGRznEjkroGfha3r6+diChUvIFJTSMcxSifdD2/CdzAkVk09NVYP2
        Ok7sbwoobe2Wti1amx/L4HytBQBHk/vXKg84q+YCwRqZvzZLfMFlJgATHwbO2js8uTITps
        VWIZuQZSjTlvGEvmnoL7O2HoSOkk0fKMzNcoqnzZUPMb0ymM9CTL9R5r6ZtaAs7ibi+itC
        2fA+mYi41h9WdxEIuXxovLSPhy4WybhQf1+rJ4fTDMkdsoFrF/DYVus6FCAaQA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1651213944;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QqgVeMPsWGnOQhz4oVzHwiyJ9rj1VsnTUxUpXZenVIo=;
        b=eAe196161rh/TEwnXzWjhLbEWBAFSIRbJJtMgIDsoqfbDUXeJ/ytNydWBCDl9uoxftfkRS
        YbWA4K3vxpL7D9DQ==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        "Y . b . Lu" <yangbo.lu@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yannick Vignon <yannick.vignon@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next] selftests: forwarding: add Per-Stream
 Filtering and Policing test for Ocelot
In-Reply-To: <20220428204839.1720129-1-vladimir.oltean@nxp.com>
References: <20220428204839.1720129-1-vladimir.oltean@nxp.com>
Date:   Fri, 29 Apr 2022 08:32:22 +0200
Message-ID: <87v8usiemh.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

Hi Vladimir,

On Thu Apr 28 2022, Vladimir Oltean wrote:
> The Felix VSC9959 switch in NXP LS1028A supports the tc-gate action
> which enforced time-based access control per stream. A stream as seen by
> this switch is identified by {MAC DA, VID}.
>
> We use the standard forwarding selftest topology with 2 host interfaces
> and 2 switch interfaces. The host ports must require timestamping non-IP
> packets and supporting tc-etf offload, for isochron to work. The
> isochron program monitors network sync status (ptp4l, phc2sys) and
> deterministically transmits packets to the switch such that the tc-gate
> action either (a) always accepts them based on its schedule, or
> (b) always drops them.
>
> I tried to keep as much of the logic that isn't specific to the NXP
> LS1028A in a new tsn_lib.sh, for future reuse. This covers
> synchronization using ptp4l and phc2sys, and isochron.

For running this selftest `isochron` tool is required. That's neither
packaged on Linux distributions or available in the kernel source. I
guess, it has to be built from your Github account/repository?

>
> The cycle-time chosen for this selftest isn't particularly impressive
> (and the focus is the functionality of the switch), but I didn't really
> know what to do better, considering that it will mostly be run during
> debugging sessions, various kernel bloatware would be enabled, like
> lockdep, KASAN, etc, and we certainly can't run any races with those on.
>
> I tried to look through the kselftest framework for other real time
> applications and didn't really find any, so I'm not sure how better to
> prepare the environment in case we want to go for a lower cycle time.
> At the moment, the only thing the selftest is ensuring is that dynamic
> frequency scaling is disabled on the CPU that isochron runs on. It would
> probably be useful to have a blacklist of kernel config options (checked
> through zcat /proc/config.gz) and some cyclictest scripts to run
> beforehand, but I saw none of those.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

[snip]

> diff --git a/tools/testing/selftests/net/forwarding/tsn_lib.sh b/tools/testing/selftests/net/forwarding/tsn_lib.sh
> new file mode 100644
> index 000000000000..efac5badd5a0
> --- /dev/null
> +++ b/tools/testing/selftests/net/forwarding/tsn_lib.sh
> @@ -0,0 +1,219 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright 2021-2022 NXP
> +
> +# Tunables
> +UTC_TAI_OFFSET=37

Why do you need the UTC to TAI offset? isochron could just use CLOCK_TAI
as clockid for the task scheduling.

> +ISOCHRON_CPU=1

Seems reasonable to assume two cpus.

> +
> +# https://github.com/vladimiroltean/tsn-scripts
> +# WARNING: isochron versions pre-1.0 are unstable,
> +# always use the latest version
> +require_command isochron
> +require_command phc2sys
> +require_command ptp4l
> +
> +phc2sys_start()
> +{
> +	local if_name=$1
> +	local uds_address=$2
> +	local extra_args=""
> +
> +	if ! [ -z "${uds_address}" ]; then
> +		extra_args="${extra_args} -z ${uds_address}"
> +	fi
> +
> +	phc2sys_log="$(mktemp)"
> +
> +	chrt -f 10 phc2sys -m \
> +		-c ${if_name} \
> +		-s CLOCK_REALTIME \
> +		-O ${UTC_TAI_OFFSET} \
> +		--step_threshold 0.00002 \
> +		--first_step_threshold 0.00002 \
> +		${extra_args} \
> +		> "${phc2sys_log}" 2>&1 &
> +	phc2sys_pid=$!
> +
> +	echo "phc2sys logs to ${phc2sys_log} and has pid ${phc2sys_pid}"
> +
> +	sleep 1
> +}
> +
> +phc2sys_stop()
> +{
> +	{ kill ${phc2sys_pid} && wait ${phc2sys_pid}; } 2> /dev/null
> +	rm "${phc2sys_log}" 2> /dev/null
> +}
> +
> +ptp4l_start()
> +{
> +	local if_name=$1
> +	local slave_only=$2
> +	local uds_address=$3
> +	local log="ptp4l_log_${if_name}"
> +	local pid="ptp4l_pid_${if_name}"
> +	local extra_args=""
> +
> +	if [ "${slave_only}" = true ]; then
> +		extra_args="${extra_args} -s"
> +	fi
> +
> +	# declare dynamic variables ptp4l_log_${if_name} and ptp4l_pid_${if_name}
> +	# as global, so that they can be referenced later
> +	declare -g "${log}=$(mktemp)"
> +
> +	chrt -f 10 ptp4l -m -2 -P \
> +		-i ${if_name} \
> +		--step_threshold 0.00002 \
> +		--first_step_threshold 0.00002 \
> +		--tx_timestamp_timeout 100 \
> +		--uds_address="${uds_address}" \
> +		${extra_args} \
> +		> "${!log}" 2>&1 &
> +	declare -g "${pid}=$!"
> +
> +	echo "ptp4l for interface ${if_name} logs to ${!log} and has pid ${!pid}"
> +
> +	sleep 1
> +}
> +
> +ptp4l_stop()
> +{
> +	local if_name=$1
> +	local log="ptp4l_log_${if_name}"
> +	local pid="ptp4l_pid_${if_name}"
> +
> +	{ kill ${!pid} && wait ${!pid}; } 2> /dev/null
> +	rm "${!log}" 2> /dev/null
> +}
> +
> +cpufreq_max()
> +{
> +	local cpu=$1
> +	local freq="cpu${cpu}_freq"
> +	local governor="cpu${cpu}_governor"
> +
> +	# declare dynamic variables cpu${cpu}_freq and cpu${cpu}_governor as
> +	# global, so they can be referenced later
> +	declare -g "${freq}=$(cat /sys/bus/cpu/devices/cpu${cpu}/cpufreq/scaling_min_freq)"
> +	declare -g "${governor}=$(cat /sys/bus/cpu/devices/cpu${cpu}/cpufreq/scaling_governor)"
> +
> +	cat /sys/bus/cpu/devices/cpu${cpu}/cpufreq/scaling_max_freq > \
> +		/sys/bus/cpu/devices/cpu${cpu}/cpufreq/scaling_min_freq
> +	echo -n "performance" > \
> +		/sys/bus/cpu/devices/cpu${cpu}/cpufreq/scaling_governor
> +}
> +
> +cpufreq_restore()
> +{
> +	local cpu=$1
> +	local freq="cpu${cpu}_freq"
> +	local governor="cpu${cpu}_governor"
> +
> +	echo "${!freq}" > /sys/bus/cpu/devices/cpu${cpu}/cpufreq/scaling_min_freq
> +	echo -n "${!governor}" > \
> +		/sys/bus/cpu/devices/cpu${cpu}/cpufreq/scaling_governor
> +}
> +
> +isochron_recv_start()
> +{
> +	local if_name=$1
> +	local uds=$2
> +	local extra_args=$3
> +
> +	if ! [ -z "${uds}" ]; then
> +		extra_args="--unix-domain-socket ${uds}"
> +	fi
> +
> +	isochron rcv \
> +		--interface ${if_name} \
> +		--sched-priority 98 \
> +		--sched-rr \

Why SCHED_RR?

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmJrhnYTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgtlvD/9p9fEFfwY7QVD3y+dyDDr1lTSOVqD0
D90PcCTL5SW1lfCDxBNAyFOhYAvuoS7C60DCvHcKLRDVS3W7Tv4wpIgCbsBBgqo3
VDseDZU/PjiYLC1Xu7lufYr1KFoGe5KrcNQ82u2NZSXyb0K0SVVDjFehknJb/Wn+
VAf59bx4XMnYa8wJXYgmcV+BzoeN6Q3A/hqaOCSeQh5WMiwri3QDULlwFOzO4MZO
wzlUuR2DhoJQEgbx6dCHUEyAyayvPtBj9qmekU3b0+7vXrzy+XlfeL0XXVwl2tWc
aasuWVr/OUim1GeoX8S0o9e+UV71o4N35sJOq7VVQO4QDEUi4PntVphWGR6fyGl3
LDQgMVqWeNmMhN+rFry0qn3pXBEY0Tmo89B4ohLwvbZm+u96ku6rBs+rkLIdu3P5
BAo6iQkGgLh8s/5ie+ifR6s9uOHoGp2w6qvTVeqR1XgrXY38TFp9jVihOZaVX+n5
fYmLccNOWD7vsvPKYPzz/S8M9nxCXcRWGzFX0lWQ4F/T6j3RSqarMNjB+JNELdeW
YtBXnJ/EMP3elDxsqgOFZbw+IN0VhNyavc94/JUN0sBeXTdT9SZiNNoLOipCpemE
jjz7jWNkyCH/YrcSkRwzpSAsG6iXy/w+gempM9RnASDz6z8Cg6o1YF+RVJvQ5vCU
2bGdv4lGPEf4TA==
=B7NJ
-----END PGP SIGNATURE-----
--=-=-=--
