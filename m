Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE7F53DF886
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 01:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234100AbhHCXcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 19:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232935AbhHCXcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 19:32:48 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 596B9C061757;
        Tue,  3 Aug 2021 16:32:36 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id g23-20020a17090a5797b02901765d605e14so1012205pji.5;
        Tue, 03 Aug 2021 16:32:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=34AaGeDVimxlTQZdPIdG0oWMTYSbIPQem41FCMNHxKM=;
        b=B5RaLQDjUVTF2G3A0H2iogjAtQBgCsU2HaNId7jZ/1TFUvLkUJLAmxEay63zY/7hc6
         TrXp6w2QSLu32ZMr+R5EjR2bRCb+ThpxrFSQVz2nWbdhf4BfOrgek3r/CYyFbN6HQEcc
         /YMQLOReqItYgLi/AagIMSx3PD5369THpzO/rxiXzp8snzAxwtWBv9+DLF664oB9HRUp
         KNIvMH8VC9wceBwN2YmjQHVaWiQh1KhyMrAx9N+1mnHH0bmZbEOpaNpdcYOwT4oOVYuB
         W7Z1QpDxfCvpKLOoRHEzpYXTmAKN1E2MCLcS/AfdDUl7kvmZLlXa0DWxs7AaZ2Ry6Eyt
         /kRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=34AaGeDVimxlTQZdPIdG0oWMTYSbIPQem41FCMNHxKM=;
        b=mp0v0WXdzX7Hcakmavw7vI/PHJyARKjBWpWzCkSfcszQ7ICeicD0W8cdgxNkOdufKo
         dkKwftbWtIWuHhwr/p9cCiSPpWsmntdwz+L4gWEg7Gz1EPPxNJMthpqTJQGOF4a4DLPP
         2fF7w4uqiJ6FtuW0BZMYxKaL0H2Op6WUxWVEDvxgHqwPKkCf7jFShdUT16hqP9KPAeDJ
         d/vKKeuRehWEfBDTLypH3NSMrkOrD+2qZB89ZxTw1czgF+nmnsgns0HwoUnmnyfofUus
         0R21yetT0xv9NOkKyGn08pw8NqXBH1ezmgcPvgglo1S9uhVOVwjeIMSN/SZ7zpdl8W14
         Ozkw==
X-Gm-Message-State: AOAM533w/CEZz5tMgzmh5z+FUQWPuGpk1Id7o/pINPIsvFKjKpphyFX+
        KXu3ueJLBAQepUv/m4u//nM=
X-Google-Smtp-Source: ABdhPJy8ODsZH5/wL81gfGYeAu8a/58BhYyG2BHKDfZs83yrGoscu8tKF0wrqWxpc7cnEm+C6iCaZg==
X-Received: by 2002:a17:90a:1148:: with SMTP id d8mr25792728pje.106.1628033555828;
        Tue, 03 Aug 2021 16:32:35 -0700 (PDT)
Received: from localhost ([2405:201:6014:d0bb:dc30:f309:2f53:5818])
        by smtp.gmail.com with ESMTPSA id j3sm302032pfe.98.2021.08.03.16.32.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 16:32:35 -0700 (PDT)
Date:   Wed, 4 Aug 2021 05:02:30 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 2/8] samples: bpf: Add common infrastructure
 for XDP samples
Message-ID: <20210803233230.px3mfwjme6jxnoph@apollo.localdomain>
References: <20210728165552.435050-1-memxor@gmail.com>
 <20210728165552.435050-3-memxor@gmail.com>
 <6a0ba11a-d2a5-38ec-0462-58212c8a4ca7@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a0ba11a-d2a5-38ec-0462-58212c8a4ca7@iogearbox.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 04, 2021 at 04:36:35AM IST, Daniel Borkmann wrote:
> On 7/28/21 6:55 PM, Kumar Kartikeya Dwivedi wrote:
> > This file implements some common helpers to consolidate differences in
> > features and functionality between the various XDP samples and give them
> > a consistent look, feel, and reporting capabilities.
> >
> > Some of the key features are:
> >   * A concise output format accompanied by helpful text explaining its
> >     fields.
> >   * An elaborate output format building upon the concise one, and folding
> >     out details in case of errors and staying out of view otherwise.
> >   * Extended reporting of redirect errors by capturing hits for each
> >     errno and displaying them inline (ENETDOWN, EINVAL, ENOSPC, etc.)
> >     to aid debugging.
> >   * Reporting of each xdp_exception action for all samples that use these
> >     helpers (XDP_ABORTED, etc.) to aid debugging.
> >   * Capturing per ifindex pair devmap_xmit counts for decomposing the
> >     total TX count per devmap redirection.
> >   * Ability to jump to source locations invoking tracepoints.
> >   * Faster retrieval of stats per polling interval using mmap'd eBPF
> >     array map (through .bss).
> >   * Printing driver names for devices redirecting packets.
> >   * Printing summarized total statistics for the entire session.
> >   * Ability to dynamically switch between concise and verbose mode, using
> >     SIGQUIT (Ctrl + \).
> >
> > The goal is sharing these helpers that most of the XDP samples implement
> > in some form but differently for each, lacking in some respect compared
> > to one another.
> >
> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
>
> Overall I think it's okay to try to streamline the individual XDP tools, but I
> also tend to wonder whether we keep going beyond the original purpose of kernel
> samples where the main goal is to provide small, easy to hack & stand-alone code
> snippets (like in samples/seccomp ... no doubt we have it more complex in BPF
> land, but still); things people can take away and extend for their purpose. A big
> portion of the samples are still better off in selftests so they can be run in CI,
> and those that are not should generally be simplified for developers to rip out,
> modify, experiment, and build actual applications on top.
>
> > ---
> >   samples/bpf/Makefile            |    3 +-
> >   samples/bpf/xdp_sample_shared.h |   47 +
> >   samples/bpf/xdp_sample_user.c   | 1732 +++++++++++++++++++++++++++++++
> >   samples/bpf/xdp_sample_user.h   |   94 ++
>
> I would have wished that rather than a single patch to get all the boilerplate
> code in at once to have incremental improvements that refactor the individual
> sample tools along the way.
>

I see. I'll try to split these into smaller changes.

> >   4 files changed, 1875 insertions(+), 1 deletion(-)
> >   create mode 100644 samples/bpf/xdp_sample_shared.h
> >   create mode 100644 samples/bpf/xdp_sample_user.c
> >   create mode 100644 samples/bpf/xdp_sample_user.h
> >
> > diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> > index 036998d11ded..d8fc3e6930f9 100644
> > --- a/samples/bpf/Makefile
> > +++ b/samples/bpf/Makefile
> > @@ -62,6 +62,7 @@ LIBBPF = $(TOOLS_PATH)/lib/bpf/libbpf.a
> >   CGROUP_HELPERS := ../../tools/testing/selftests/bpf/cgroup_helpers.o
> >   TRACE_HELPERS := ../../tools/testing/selftests/bpf/trace_helpers.o
> > +XDP_SAMPLE := xdp_sample_user.o
> >   fds_example-objs := fds_example.o
> >   sockex1-objs := sockex1_user.o
> > @@ -210,7 +211,7 @@ TPROGS_CFLAGS += --sysroot=$(SYSROOT)
> >   TPROGS_LDFLAGS := -L$(SYSROOT)/usr/lib
> >   endif
> > -TPROGS_LDLIBS			+= $(LIBBPF) -lelf -lz
> > +TPROGS_LDLIBS			+= $(LIBBPF) -lelf -lz -lm
> >   TPROGLDLIBS_tracex4		+= -lrt
> >   TPROGLDLIBS_trace_output	+= -lrt
> >   TPROGLDLIBS_map_perf_test	+= -lrt
> > diff --git a/samples/bpf/xdp_sample_shared.h b/samples/bpf/xdp_sample_shared.h
> > new file mode 100644
> > index 000000000000..0eb3c2b526d4
> > --- /dev/null
> > +++ b/samples/bpf/xdp_sample_shared.h
> > @@ -0,0 +1,47 @@
> > +#ifndef _XDP_SAMPLE_SHARED_H
> > +#define _XDP_SAMPLE_SHARED_H
> > +
> > +/*
> > + * Relaxed load/store
> > + * __atomic_load_n/__atomic_store_n built-in is not supported for BPF target
> > + */
> > +#define NO_TEAR_LOAD(var) ({ (*(volatile typeof(var) *)&(var)); })
> > +#define NO_TEAR_STORE(var, val) ({ *((volatile typeof(var) *)&(var)) = (val); })
>
> Can't we reuse READ_ONCE() / WRITE_ONCE() from tools/include/linux/compiler.h instead
> of readding the same here again? We already rely on using the tooling include infra
> anyway for samples.
>

Ok, I'll use those.

> > +/* This does a load + store instead of the expensive atomic fetch add, but store
> > + * is still atomic so that userspace reading the value reads the old or the new
> > + * one, but not a partial store.
> > + */
> > +#define NO_TEAR_ADD(var, val)                                                  \
> > +	({                                                                     \
> > +		typeof(val) __val = (val);                                     \
> > +		if (__val)                                                     \
> > +			NO_TEAR_STORE((var), (var) + __val);                   \
> > +	})
> > +
> > +#define NO_TEAR_INC(var) NO_TEAR_ADD((var), 1)
>
> This could likely also go there.
>

Ok.

> > +#define MAX_CPUS 64
>
> Given this is a heavy rework of samples, can't we also fix up this assumption?
>

Ok, I'll use CONFIG_NR_CPUS.

> > +#define ELEMENTS_OF(x) (sizeof(x) / sizeof(*(x)))
>
> See ARRAY_SIZE() under tools/include/linux/kernel.h .
>

Ok.

> > +struct datarec {
> > +	size_t processed;
> > +	size_t dropped;
> > +	size_t issue;
> > +	union {
> > +		size_t xdp_pass;
> > +		size_t info;
> > +	};
> > +	size_t xdp_drop;
> > +	size_t xdp_redirect;
>
> Why all size_t, can't we just use __u64 for the stats?
>

READ_ONCE/WRITE_ONCE can tear for __u64 on 32-bit systems, which will lead to
printing potentially incorrect output. size_t/unsigned long shouldn't.

> > +} __attribute__((aligned(64)));
> > +
> > +struct sample_data {
> > +	struct datarec rx_cnt[MAX_CPUS];
> > +	struct datarec redirect_err_cnt[7 * MAX_CPUS];
> > +	struct datarec cpumap_enqueue_cnt[MAX_CPUS * MAX_CPUS];
> > +	struct datarec cpumap_kthread_cnt[MAX_CPUS];
> > +	struct datarec exception_cnt[6 * MAX_CPUS];
> > +	struct datarec devmap_xmit_cnt[MAX_CPUS];
> > +};
> > +
> > +#endif
> > diff --git a/samples/bpf/xdp_sample_user.c b/samples/bpf/xdp_sample_user.c
> > new file mode 100644
> > index 000000000000..06efc2bfd84e
> > --- /dev/null
> > +++ b/samples/bpf/xdp_sample_user.c
> > @@ -0,0 +1,1732 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +#define _GNU_SOURCE
> > +
> > +#include <errno.h>
> > +#include <signal.h>
> > +#include <stdio.h>
> > +#include <stdlib.h>
> > +#include <stdbool.h>
> > +#include <string.h>
> > +#include <unistd.h>
> > +#include <math.h>
> > +#include <locale.h>
> > +#include <sys/signalfd.h>
> > +#include <sys/resource.h>
> > +#include <sys/sysinfo.h>
> > +#include <sys/timerfd.h>
> > +#include <getopt.h>
> > +#include <net/if.h>
> > +#include <time.h>
> > +#include <linux/limits.h>
> > +#include <sys/ioctl.h>
> > +#include <net/if.h>
> > +#include <poll.h>
> > +#include <linux/ethtool.h>
> > +#include <linux/sockios.h>
> > +#ifndef SIOCETHTOOL
> > +#define SIOCETHTOOL 0x8946
> > +#endif
> > +#include <fcntl.h>
> > +#include <arpa/inet.h>
> > +#include <linux/if_link.h>
> > +#include <sys/utsname.h>
> > +#include <bpf/bpf.h>
> > +#include <bpf/libbpf.h>
> > +#include "bpf_util.h"
> > +#include "xdp_sample_user.h"
>
> nit: Pls order the above a bit better.
>

Ok, will do.

> > +#define __sample_print(fmt, cond, printer, ...)                                \
> > +	({                                                                     \
> > +		if (cond)                                                      \
> > +			printer(fmt, ##__VA_ARGS__);                           \
> > +	})
> > +
> > +#define print_always(fmt, ...) __sample_print(fmt, 1, printf, ##__VA_ARGS__)
> > +#define print_default(fmt, ...)                                                \
> > +	__sample_print(fmt, sample.log_level & LL_DEFAULT, printf, ##__VA_ARGS__)
> > +#define __print_err(err, fmt, printer, ...)                                    \
> > +	({                                                                     \
> > +		__sample_print(fmt, err > 0 || sample.log_level & LL_DEFAULT,  \
> > +			       printer, ##__VA_ARGS__);                        \
> > +		sample.err_exp = sample.err_exp ? true : err > 0;              \
> > +	})
> > +#define print_err(err, fmt, ...) __print_err(err, fmt, printf, ##__VA_ARGS__)
> > +
> > +#define print_link_err(err, str, width, type)                                  \
> > +	__print_err(err, str, print_link, width, type)
>
> Couldn't this all be more generalized so other non-XDP samples can use it as well
> potentially?
>

It's a bit tied into what the log level means, but I'll try.

> > +#define __COLUMN(x) "%'10" x " %-13s"
> > +#define FMT_COLUMNf __COLUMN(".0f")
> > +#define FMT_COLUMNd __COLUMN("d")
> > +#define FMT_COLUMNl __COLUMN("llu")
> > +#define RX(rx) rx, "rx/s"
> > +#define PPS(pps) pps, "pkt/s"
> > +#define DROP(drop) drop, "drop/s"
> > +#define ERR(err) err, "error/s"
> > +#define HITS(hits) hits, "hit/s"
> > +#define XMIT(xmit) xmit, "xmit/s"
> > +#define PASS(pass) pass, "pass/s"
> > +#define REDIR(redir) redir, "redir/s"
> > +#define NANOSEC_PER_SEC 1000000000 /* 10^9 */
> > +
> > +#define XDP_UNKNOWN (XDP_REDIRECT + 1)
> > +#define XDP_ACTION_MAX (XDP_UNKNOWN + 1)
> > +#define XDP_REDIRECT_ERR_MAX	7
> > +
> > +enum tp_type {
> > +	TP_REDIRECT_CNT,
> > +	TP_REDIRECT_MAP_CNT,
> > +	TP_REDIRECT_ERR_CNT,
> > +	TP_REDIRECT_MAP_ERR_CNT,
> > +	TP_CPUMAP_ENQUEUE_CNT,
> > +	TP_CPUMAP_KTHREAD_CNT,
> > +	TP_EXCEPTION_CNT,
> > +	TP_DEVMAP_XMIT_CNT,
> > +	NUM_TP,
> > +};
> > +
> > +enum map_type {
> > +	MAP_DEVMAP_XMIT_MULTI,
> > +	NUM_MAP,
> > +};
> > +
> > +enum log_level {
> > +	LL_DEFAULT = 1U << 0,
> > +	LL_SIMPLE  = 1U << 1,
> > +	LL_DEBUG   = 1U << 2,
> > +};
> > +
> > +struct record {
> > +	__u64 timestamp;
> > +	struct datarec total;
> > +	struct datarec *cpu;
> > +};
> > +
> > +struct stats_record {
> > +	struct record rx_cnt;
> > +	struct record redir_err[XDP_REDIRECT_ERR_MAX];
> > +	struct record kthread;
> > +	struct record exception[XDP_ACTION_MAX];
> > +	struct record devmap_xmit;
> > +	struct hash_map *devmap_xmit_multi;
> > +	struct record enq[];
> > +};
> > +
> > +struct sample_output {
> > +	struct {
> > +		__u64 rx;
> > +		__u64 redir;
> > +		__u64 drop;
> > +		__u64 drop_xmit;
> > +		__u64 err;
> > +		__u64 xmit;
> > +	} totals;
> > +	struct {
> > +		__u64 pps;
> > +		__u64 drop;
> > +		__u64 err;
> > +	} rx_cnt;
> > +	struct {
> > +		__u64 suc;
> > +		__u64 err;
> > +	} redir_cnt;
> > +	struct {
> > +		__u64 hits;
> > +	} except_cnt;
> > +	struct {
> > +		__u64 pps;
> > +		__u64 drop;
> > +		__u64 err;
> > +		double bavg;
> > +	} xmit_cnt;
> > +};
> > +
> > +static struct {
> > +	enum log_level log_level;
> > +	struct sample_output out;
> > +	struct sample_data *data;
> > +	unsigned long interval;
> > +	int map_fd[NUM_MAP];
> > +	struct xdp_desc {
> > +		int ifindex;
> > +		__u32 prog_id;
> > +		int flags;
> > +	} xdp_progs[32];
> > +	bool err_exp;
> > +	int xdp_cnt;
> > +	int n_cpus;
> > +	int sig_fd;
> > +	int mask;
> > +} sample;
> > +
> > +static const char *xdp_redirect_err_names[XDP_REDIRECT_ERR_MAX] = {
> > +	/* Key=1 keeps unknown errors */
> > +	"Success", "Unknown", "EINVAL", "ENETDOWN", "EMSGSIZE",
> > +	"EOPNOTSUPP", "ENOSPC",
> > +};
> > +
> > +/* Keyed from Unknown */
> > +static const char *xdp_redirect_err_help[XDP_REDIRECT_ERR_MAX - 1] = {
> > +	"Unknown error",
> > +	"Invalid redirection",
> > +	"Device being redirected to is down",
> > +	"Packet length too large for device",
> > +	"Operation not supported",
> > +	"No space in ptr_ring of cpumap kthread",
> > +};
> > +
> > +static const char *xdp_action_names[XDP_ACTION_MAX] = {
> > +	[XDP_ABORTED]	= "XDP_ABORTED",
> > +	[XDP_DROP]	= "XDP_DROP",
> > +	[XDP_PASS]	= "XDP_PASS",
> > +	[XDP_TX]	= "XDP_TX",
> > +	[XDP_REDIRECT]	= "XDP_REDIRECT",
> > +	[XDP_UNKNOWN]	= "XDP_UNKNOWN",
> > +};
> > +
> > +static const char *elixir_search[NUM_TP] = {
> > +	[TP_REDIRECT_CNT] = "_trace_xdp_redirect",
> > +	[TP_REDIRECT_MAP_CNT] = "_trace_xdp_redirect_map",
> > +	[TP_REDIRECT_ERR_CNT] = "_trace_xdp_redirect_err",
> > +	[TP_REDIRECT_MAP_ERR_CNT] = "_trace_xdp_redirect_map_err",
> > +	[TP_CPUMAP_ENQUEUE_CNT] = "trace_xdp_cpumap_enqueue",
> > +	[TP_CPUMAP_KTHREAD_CNT] = "trace_xdp_cpumap_kthread",
> > +	[TP_EXCEPTION_CNT] = "trace_xdp_exception",
> > +	[TP_DEVMAP_XMIT_CNT] = "trace_xdp_devmap_xmit",
> > +};
>
> nit: inconsistent style wrt tabs on elixir_search vs xdp_action_names, generally
> like the latter is preferred.

Ok, I'll fix all instances.

> > +/* Dumb hashmap to store ifindex pairs datarec for devmap_xmit_cnt_multi */
> > +#define HASH_BUCKETS (1 << 5)
> > +#define HASH_MASK    (HASH_BUCKETS - 1)
> > +
> > +#define hash_map_for_each(entry, map)                                          \
> > +	for (int __i = 0; __i < HASH_BUCKETS; __i++)                           \
> > +		for (entry = map->buckets[__i]; entry; entry = entry->next)
> > +
> > +struct map_entry {
> > +	struct map_entry *next;
> > +	__u64 pair;
> > +	struct record *val;
> > +};
> > +
> > +struct hash_map {
> > +	struct map_entry *buckets[HASH_BUCKETS];
> > +};
> > +
> > +/* From tools/lib/bpf/hashmap.h */
>
> Should this also have same license then?
>
> > +static size_t hash_bits(size_t h, int bits)
> > +{
> > +	/* shuffle bits and return requested number of upper bits */
> > +	if (bits == 0)
> > +		return 0;
> > +
> > +#if (__SIZEOF_SIZE_T__ == __SIZEOF_LONG_LONG__)
> > +	/* LP64 case */
> > +	return (h * 11400714819323198485llu) >> (__SIZEOF_LONG_LONG__ * 8 - bits);
> > +#elif (__SIZEOF_SIZE_T__ <= __SIZEOF_LONG__)
> > +	return (h * 2654435769lu) >> (__SIZEOF_LONG__ * 8 - bits);
> > +#else
> > +#	error "Unsupported size_t size"
> > +#endif
> > +}
> > +
> > +static __u64 gettime(void)
> > +{
> > +	struct timespec t;
> > +	int res;
> > +
> > +	res = clock_gettime(CLOCK_MONOTONIC, &t);
> > +	if (res < 0) {
> > +		fprintf(stderr, "Error with gettimeofday! (%i)\n", res);
> > +		exit(EXIT_FAIL);
> > +	}
> > +	return (__u64) t.tv_sec * NANOSEC_PER_SEC + t.tv_nsec;
> > +}
> > +
> > +int sample_get_cpus(void)
> > +{
> > +	int cpus = get_nprocs_conf();
> > +	return cpus < MAX_CPUS ? cpus : MAX_CPUS;
> > +}
> > +
> > +static int hash_map_add(struct hash_map *map, __u64 pair, struct record *val)
> > +{
> > +	struct map_entry *e, **b;
> > +
> > +	e = calloc(1, sizeof(*e));
> > +	if (!e)
> > +		return -ENOMEM;
> > +
> > +	val->timestamp = gettime();
> > +
> > +	e->pair = pair;
> > +	e->val = val;
> > +
> > +	b = &map->buckets[hash_bits((size_t)pair, 5) & HASH_MASK];
> > +	if (*b)
> > +		e->next = *b;
> > +	*b = e;
> > +
> > +	return 0;
> > +}
> > +
> > +static struct map_entry *hash_map_find(struct hash_map *map, __u64 pair)
> > +{
> > +	struct map_entry *e;
> > +
> > +	e = map->buckets[hash_bits((size_t)pair, 5) & HASH_MASK];
> > +	for (; e; e = e->next) {
> > +		if (e->pair == pair)
> > +			break;
> > +	}
> > +
> > +	return e;
> > +}
> > +
> > +static void hash_map_destroy(struct hash_map *map)
> > +{
> > +	if (!map)
> > +		return;
> > +
> > +	for (int i = 0; i < HASH_BUCKETS; i++) {
> > +		struct map_entry *e, *f;
> > +
> > +		e = map->buckets[i];
> > +		while (e) {
> > +			f = e;
> > +			e = e->next;
> > +			free(f->val->cpu);
> > +			free(f->val);
> > +			free(f);
> > +		}
> > +	}
> > +}
>
> There's also an existing hashtable implementation under
> tools/include/linux/hashtable.h, can't we reuse that one?
>

I didn't notice this. I'll switch to using it.

> [...]
> > +static const char *make_url(enum tp_type i)
> > +{
> > +	const char *key = elixir_search[i];
> > +	static struct utsname uts = {};
> > +	static char url[128];
> > +	static bool uts_init;
> > +	int maj, min;
> > +	char c[2];
> > +
> > +	if (!uts_init) {
> > +		if (uname(&uts) < 0)
> > +			return NULL;
> > +		uts_init = true;
> > +	}
> > +
> > +	if (!key || sscanf(uts.release, "%d.%d%1s", &maj, &min, c) != 3)
> > +		return NULL;
> > +
> > +	snprintf(url, sizeof(url), "https://elixir.bootlin.com/linux/v%d.%d/C/ident/%s",
> > +		 maj, min, key);
> > +
> > +	return url;
> > +}
>
> I don't think this whole make_url() belongs in here with the link construction to
> elixir.bootlin.com, it's just confusing when you have downstream trees with custom
> backports.
>

Right, it only considers the upstream kernel. I guess I'll just drop it.

[...]

I'll also address everything else, thanks!

--
Kartikeya
