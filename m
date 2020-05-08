Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAE61CB3EA
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 17:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbgEHPt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 11:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726815AbgEHPt5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 11:49:57 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0443C061A0C;
        Fri,  8 May 2020 08:49:55 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id e9so2230520iok.9;
        Fri, 08 May 2020 08:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=RWIVR2TuGd+rmb5LP78ngwU1ETDC2FrMpDLWNruceU4=;
        b=CHlNnhMvpWzFnRfydCQIkgKPWUJKYP03A/nIMEIucD+nCY8RKudvB3dSnOEM2p0MyV
         cphhnJllL///kcXVb0ZJg4zal3AmSmC+lLpARUjzyAWx0YwdXt4Yrcw0iFusHsGe4s9F
         jYe2WbE0iG5mMusWSzmlZkEuwHYGsYMzCiOskrWWUFAlu0LPfzD5nIObygQyT04awxfb
         HJYvuohqdacJX+tmHta1crO80UcVDaj+FTakQ0AXxtWwDRa26+xtUfm3vV51w5UTsJ+5
         CPN5uLjAm79wOGc7MgjNq8Cg2b2orK1wxka7cZN+C7HZtENSe3ob80ksYoJNX8jvL5Nb
         4tog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=RWIVR2TuGd+rmb5LP78ngwU1ETDC2FrMpDLWNruceU4=;
        b=d+M0rmM85T0m7IhMK4zx8AREQQ+XTJZ7Z9mE4KPmv2fArdewHIIIolXDG4AJi6IErQ
         tHMH8IzwO1B64Dd3aGCOdIFF6XcphuIKNmThwtI8KbMn4HREDyc7XBrwOIKIJ1RF6s0V
         q7dSIvnMP3gWYBiu6JlrwC4LnPWUtqhBNAoUs03fVk5wdC3xygyFwRgjNfNOS4KvEfrH
         LGCG39EP0XE7i+3oDqZ14i4cnRLDrO5qzohyev0LvtPQ+nrl466Hpyqonun8UuQw1jaW
         DeMUDFy6k/ciMw6ayxkPcZndJNgYTlLqfKf+1VfwrQHrhvnyXdePR0RWH/MOjirKpR1T
         JKVA==
X-Gm-Message-State: AGi0PuaCroQ7VGoZcOVzKT/8nPAdIrfWLdyXnhq3aMrp3dyXrA7s1YJM
        nLoRppp8mDzbnnWlgLP4KHo=
X-Google-Smtp-Source: APiQypI8M0lf4jxxT3UBdwmciCry1KwbfSVMnmtCSZGYp4dchNIvwk14MgyqRNU4T8vx10I4SdG5CQ==
X-Received: by 2002:a6b:e802:: with SMTP id f2mr3259487ioh.128.1588952995084;
        Fri, 08 May 2020 08:49:55 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id 7sm826201ion.52.2020.05.08.08.49.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 08:49:54 -0700 (PDT)
Date:   Fri, 08 May 2020 08:49:46 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
Message-ID: <5eb57f9a5819c_2a992ad50b5cc5b41@john-XPS-13-9370.notmuch>
In-Reply-To: <20200508070548.2358701-2-andriin@fb.com>
References: <20200508070548.2358701-1-andriin@fb.com>
 <20200508070548.2358701-2-andriin@fb.com>
Subject: RE: [PATCH bpf-next 1/3] selftests/bpf: add benchmark runner
 infrastructure
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> While working on BPF ringbuf implementation, testing, and benchmarking,=
 I've
> developed a pretty generic and modular benchmark runner, which seems to=
 be
> generically useful, as I've already used it for one more purpose (testi=
ng
> fastest way to trigger BPF program, to minimize overhead of in-kernel c=
ode).
> =

> This patch adds generic part of benchmark runner and sets up Makefile f=
or
> extending it with more sets of benchmarks.

Seems useful.

> =

> Benchmarker itself operates by spinning up specified number of producer=
 and
> consumer threads, setting up interval timer sending SIGALARM signal to
> application once a second. Every second, current snapshot with hits/dro=
ps
> counters are collected and stored in an array. Drops are useful for
> producer/consumer benchmarks in which producer might overwhelm consumer=
s.
> =

> Once test finishes after given amount of warm-up and testing seconds, m=
ean and
> stddev are calculated (ignoring warm-up results) and is printed out to =
stdout.
> This setup seems to give consistent and accurate results.
> =

> To validate behavior, I added two atomic counting tests: global and loc=
al.
> For global one, all the producer threads are atomically incrementing sa=
me
> counter as fast as possible. This, of course, leads to huge drop of
> performance once there is more than one producer thread due to CPUs fig=
hting
> for the same memory location.
> =

> Local counting, on the other hand, maintains one counter per each produ=
cer
> thread, incremented independently. Once per second, all counters are re=
ad and
> added together to form final "counting throughput" measurement. As expe=
cted,
> such setup demonstrates linear scalability with number of producers (as=
 long
> as there are enough physical CPU cores, of course). See example output =
below.
> Also, this setup can nicely demonstrate disastrous effects of false sha=
ring,
> if care is not taken to take those per-producer counters apart into
> independent cache lines.
> =

> Demo output shows global counter first with 1 producer, then with 4. Bo=
th
> total and per-producer performance significantly drop. The last run is =
local
> counter with 4 producers, demonstrating near-perfect scalability.
> =

> $ ./bench -a -w1 -d2 -p1 count-global
> Setting up benchmark 'count-global'...
> Benchmark 'count-global' started.
> Iter   0 ( 24.822us): hits  148.179M/s (148.179M/prod), drops    0.000M=
/s
> Iter   1 ( 37.939us): hits  149.308M/s (149.308M/prod), drops    0.000M=
/s
> Iter   2 (-10.774us): hits  150.717M/s (150.717M/prod), drops    0.000M=
/s
> Iter   3 (  3.807us): hits  151.435M/s (151.435M/prod), drops    0.000M=
/s
> Summary: hits  150.488 =C2=B1 1.079M/s (150.488M/prod), drops    0.000 =
=C2=B1 0.000M/s
> =

> $ ./bench -a -w1 -d2 -p4 count-global
> Setting up benchmark 'count-global'...
> Benchmark 'count-global' started.
> Iter   0 ( 60.659us): hits   53.910M/s ( 13.477M/prod), drops    0.000M=
/s
> Iter   1 (-17.658us): hits   53.722M/s ( 13.431M/prod), drops    0.000M=
/s
> Iter   2 (  5.865us): hits   53.495M/s ( 13.374M/prod), drops    0.000M=
/s
> Iter   3 (  0.104us): hits   53.606M/s ( 13.402M/prod), drops    0.000M=
/s
> Summary: hits   53.608 =C2=B1 0.113M/s ( 13.402M/prod), drops    0.000 =
=C2=B1 0.000M/s
> =

> $ ./bench -a -w1 -d2 -p4 count-local
> Setting up benchmark 'count-local'...
> Benchmark 'count-local' started.
> Iter   0 ( 23.388us): hits  640.450M/s (160.113M/prod), drops    0.000M=
/s
> Iter   1 (  2.291us): hits  605.661M/s (151.415M/prod), drops    0.000M=
/s
> Iter   2 ( -6.415us): hits  607.092M/s (151.773M/prod), drops    0.000M=
/s
> Iter   3 ( -1.361us): hits  601.796M/s (150.449M/prod), drops    0.000M=
/s
> Summary: hits  604.849 =C2=B1 2.739M/s (151.212M/prod), drops    0.000 =
=C2=B1 0.000M/s
> =

> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---

Couple nits but otherwise lgtm. I think it should probably be moved
into its own directory though ./bpf/bench/

The other question would be how much stuff do we want to live in
selftests vs outside selftests/bpf but I think its fine and makes
it easy to build small benchmark programs in ./bpf/progs/

>  tools/testing/selftests/bpf/.gitignore    |   1 +
>  tools/testing/selftests/bpf/Makefile      |  11 +-
>  tools/testing/selftests/bpf/bench.c       | 364 ++++++++++++++++++++++=

>  tools/testing/selftests/bpf/bench.h       |  74 +++++
>  tools/testing/selftests/bpf/bench_count.c |  91 ++++++
>  5 files changed, 540 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/bpf/bench.c
>  create mode 100644 tools/testing/selftests/bpf/bench.h
>  create mode 100644 tools/testing/selftests/bpf/bench_count.c
> =

> diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/sel=
ftests/bpf/.gitignore
> index 3ff031972975..1bb204cee853 100644
> --- a/tools/testing/selftests/bpf/.gitignore
> +++ b/tools/testing/selftests/bpf/.gitignore
> @@ -38,3 +38,4 @@ test_cpp
>  /bpf_gcc
>  /tools
>  /runqslower
> +/bench
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selft=
ests/bpf/Makefile
> index 3d942be23d09..ab03362d46e4 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -77,7 +77,7 @@ TEST_PROGS_EXTENDED :=3D with_addr.sh \
>  # Compile but not part of 'make run_tests'
>  TEST_GEN_PROGS_EXTENDED =3D test_sock_addr test_skb_cgroup_id_user \
>  	flow_dissector_load test_flow_dissector test_tcp_check_syncookie_user=
 \
> -	test_lirc_mode2_user xdping test_cpp runqslower
> +	test_lirc_mode2_user xdping test_cpp runqslower bench
>  =

>  TEST_CUSTOM_PROGS =3D urandom_read
>  =

> @@ -405,6 +405,15 @@ $(OUTPUT)/test_cpp: test_cpp.cpp $(OUTPUT)/test_co=
re_extern.skel.h $(BPFOBJ)
>  	$(call msg,CXX,,$@)
>  	$(CXX) $(CFLAGS) $^ $(LDLIBS) -o $@
>  =

> +# Benchmark runner
> +$(OUTPUT)/bench.o:          bench.h
> +$(OUTPUT)/bench_count.o:    bench.h
> +$(OUTPUT)/bench: LDLIBS +=3D -lm
> +$(OUTPUT)/bench: $(OUTPUT)/bench.o \
> +		 $(OUTPUT)/bench_count.o
> +	$(call msg,BINARY,,$@)
> +	$(CC) $(LDFLAGS) -o $@ $(filter %.a %.o,$^) $(LDLIBS)
> +
>  EXTRA_CLEAN :=3D $(TEST_CUSTOM_PROGS) $(SCRATCH_DIR)			\
>  	prog_tests/tests.h map_tests/tests.h verifier/tests.h		\
>  	feature								\
> diff --git a/tools/testing/selftests/bpf/bench.c b/tools/testing/selfte=
sts/bpf/bench.c
> new file mode 100644
> index 000000000000..a20482bb74e2
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/bench.c
> @@ -0,0 +1,364 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2020 Facebook */
> +#define _GNU_SOURCE
> +#include <argp.h>
> +#include <linux/compiler.h>
> +#include <sys/time.h>
> +#include <sched.h>
> +#include <fcntl.h>
> +#include <pthread.h>
> +#include <sys/sysinfo.h>
> +#include <sys/resource.h>
> +#include <signal.h>
> +#include "bench.h"
> +
> +struct env env =3D {
> +	.duration_sec =3D 10,
> +	.warmup_sec =3D 5,

Just curious I'm guessing the duration/warmap are arbitrary here? Seems
a bit long I would bet 5,1 would be enough for global/local test at
least.

> +	.affinity =3D false,
> +	.consumer_cnt =3D 1,
> +	.producer_cnt =3D 1,
> +};
> +

[...]

> +void hits_drops_report_progress(int iter, struct bench_res *res, long =
delta_ns)
> +{
> +	double hits_per_sec, drops_per_sec;
> +	double hits_per_prod;
> +
> +	hits_per_sec =3D res->hits / 1000000.0 / (delta_ns / 1000000000.0);
> +	hits_per_prod =3D hits_per_sec / env.producer_cnt;

Per producer counts would also be useful. Averaging over producer cnt cou=
ld
hide issues with fairness.

> +	drops_per_sec =3D res->drops / 1000000.0 / (delta_ns / 1000000000.0);=

> +
> +	printf("Iter %3d (%7.3lfus): ",
> +	       iter, (delta_ns - 1000000000) / 1000.0);
> +
> +	printf("hits %8.3lfM/s (%7.3lfM/prod), drops %8.3lfM/s\n",
> +	       hits_per_sec, hits_per_prod, drops_per_sec);
> +}
> +

[...]

> +const char *argp_program_version =3D "benchmark";
> +const char *argp_program_bug_address =3D "<bpf@vger.kernel.org>";
> +const char argp_program_doc[] =3D
> +"benchmark    Generic benchmarking framework.\n"
> +"\n"
> +"This tool runs benchmarks.\n"
> +"\n"
> +"USAGE: benchmark <mode>\n"
> +"\n"
> +"EXAMPLES:\n"
> +"    benchmark count-local                # run 'count-local' benchmar=
k with 1 producer and 1 consumer\n"
> +"    benchmark -p16 -c8 -a count-local    # run 'count-local' benchmar=
k with 16 producer and 8 consumer threads, pinned to CPUs\n";
> +
> +static const struct argp_option opts[] =3D {
> +	{ "mode", 'm', "MODE", 0, "Benchmark mode"},

"Benchmark mode" hmm not sure what this is for yet. Only on
first patch though so maybe I'll become enlightened?

> +	{ "list", 'l', NULL, 0, "List available benchmarks"},
> +	{ "duration", 'd', "SEC", 0, "Duration of benchmark, seconds"},
> +	{ "warmup", 'w', "SEC", 0, "Warm-up period, seconds"},
> +	{ "producers", 'p', "NUM", 0, "Number of producer threads"},
> +	{ "consumers", 'c', "NUM", 0, "Number of consumer threads"},
> +	{ "verbose", 'v', NULL, 0, "Verbose debug output"},
> +	{ "affinity", 'a', NULL, 0, "Set consumer/producer thread affinity"},=

> +	{ "b2b", 'b', NULL, 0, "Back-to-back mode"},
> +	{ "rb-output", 10001, NULL, 0, "Set consumer/producer thread affinity=
"},
> +	{},
> +};

[...]

> +
> +static void set_thread_affinity(pthread_t thread, int cpu)
> +{
> +	cpu_set_t cpuset;
> +
> +	CPU_ZERO(&cpuset);
> +	CPU_SET(cpu, &cpuset);
> +	if (pthread_setaffinity_np(thread, sizeof(cpuset), &cpuset))
> +		printf("setting affinity to CPU #%d failed: %d\n", cpu, errno);
> +}

Should we error out on affinity errors?

> +
> +static struct bench_state {
> +	int res_cnt;
> +	struct bench_res *results;
> +	pthread_t *consumers;
> +	pthread_t *producers;
> +} state;

[...]

> +
> +static void setup_benchmark()
> +{
> +	int i, err;
> +
> +	if (!env.mode) {
> +		fprintf(stderr, "benchmark mode is not specified\n");
> +		exit(1);
> +	}
> +
> +	for (i =3D 0; i < ARRAY_SIZE(benchs); i++) {
> +		if (strcmp(benchs[i]->name, env.mode) =3D=3D 0) {

Ah the mode. OK maybe in description call it, "Benchmark mode to run" or
"Benchmark test"? Or leave it its probably fine.

> +			bench =3D benchs[i];
> +			break;
> +		}
> +	}
> +	if (!bench) {
> +		fprintf(stderr, "benchmark '%s' not found\n", env.mode);
> +		exit(1);
> +	}
> +
> +	printf("Setting up benchmark '%s'...\n", bench->name);
> +
> +	state.producers =3D calloc(env.producer_cnt, sizeof(*state.producers)=
);
> +	state.consumers =3D calloc(env.consumer_cnt, sizeof(*state.consumers)=
);
> +	state.results =3D calloc(env.duration_sec + env.warmup_sec + 2,
> +			       sizeof(*state.results));
> +	if (!state.producers || !state.consumers || !state.results)
> +		exit(1);
> +
> +	if (bench->validate)
> +		bench->validate();
> +	if (bench->setup)
> +		bench->setup();
> +
> +	for (i =3D 0; i < env.consumer_cnt; i++) {
> +		err =3D pthread_create(&state.consumers[i], NULL,
> +				     bench->consumer_thread, (void *)(long)i);
> +		if (err) {
> +			fprintf(stderr, "failed to create consumer thread #%d: %d\n",
> +				i, -errno);
> +			exit(1);
> +		}
> +		if (env.affinity)
> +			set_thread_affinity(state.consumers[i], i);
> +	}
> +	for (i =3D 0; i < env.producer_cnt; i++) {
> +		err =3D pthread_create(&state.producers[i], NULL,
> +				     bench->producer_thread, (void *)(long)i);
> +		if (err) {
> +			fprintf(stderr, "failed to create producer thread #%d: %d\n",
> +				i, -errno);
> +			exit(1);
> +		}
> +		if (env.affinity)
> +			set_thread_affinity(state.producers[i],
> +					    env.consumer_cnt + i);
> +	}
> +
> +	printf("Benchmark '%s' started.\n", bench->name);
> +}

[...]

> --- /dev/null
> +++ b/tools/testing/selftests/bpf/bench_count.c

How about a ./bpf/bench/ directory? Seems we are going to get a few
bench_* tests here.

