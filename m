Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ACDC62BE5
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 00:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728497AbfGHWkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 18:40:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60510 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbfGHWkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 18:40:09 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x68McqdD020066;
        Mon, 8 Jul 2019 22:39:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=uu5HsSb2/JPLWIgEDLbTgyDku+5uKutxTY+9LlNx9v0=;
 b=aqvqE3O1PMu5BciMf68/utM2m/9/J8gznQI0rWYFrQHqt1a0xYac5MTXS+cIohySXfcl
 d0h3MY1xdQerWgR2ZKU0iZXFd8DafAXzjFVbdCUQZvx3PpbSEk7ZM+MmxHg/3JUWMZJz
 bF0+5Ms9QPhhZdQaKcHMQOQDHWbjg9kkcPVzg1KMtXTho/rOzF9wNdO0mz/GqQYY8AmS
 n5X6xY/xXdMjh+MpU/IuD29f0dmnqsL9IacpJwO5+uXdahCRErtSALbuDPi0XBn4FuPU
 SwSF8WPQ2Gle5LgHJqAqdOp9p+AB/aWviW+KEr+3+TrfIO05w8J2VUKRm9Khv/mt78vY Qg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2tjm9qgy1t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Jul 2019 22:39:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x68Md09q084016;
        Mon, 8 Jul 2019 22:39:04 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 2tjgrtrm3e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 08 Jul 2019 22:39:04 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x68Md3lf084529;
        Mon, 8 Jul 2019 22:39:03 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2tjgrtrm2a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Jul 2019 22:39:03 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x68McsdX028655;
        Mon, 8 Jul 2019 22:38:54 GMT
Received: from localhost (/10.159.211.102)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 08 Jul 2019 15:38:53 -0700
Date:   Mon, 8 Jul 2019 18:38:51 -0400
From:   Kris Van Hees <kris.van.hees@oracle.com>
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     Kris Van Hees <kris.van.hees@oracle.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, dtrace-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        mhiramat@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        Peter Zijlstra <peterz@infradead.org>, Chris Mason <clm@fb.com>
Subject: Re: [PATCH 1/1] tools/dtrace: initial implementation of DTrace
Message-ID: <20190708223851.GD20847@oracle.com>
References: <201907040313.x643D8Pg025951@userv0121.oracle.com>
 <201907040314.x643EUoA017906@aserv0122.oracle.com>
 <20190708171537.GA11960@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708171537.GA11960@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9312 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907080277
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 08, 2019 at 02:15:37PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Wed, Jul 03, 2019 at 08:14:30PM -0700, Kris Van Hees escreveu:
> > This initial implementation of a tiny subset of DTrace functionality
> > provides the following options:
> > 
> > 	dtrace [-lvV] [-b bufsz] -s script
> > 	    -b  set trace buffer size
> > 	    -l  list probes (only works with '-s script' for now)
> > 	    -s  enable or list probes for the specified BPF program
> > 	    -V  report DTrace API version
> > 
> > The patch comprises quite a bit of code due to DTrace requiring a few
> > crucial components, even in its most basic form.
> > 
> > The code is structured around the command line interface implemented in
> > dtrace.c.  It provides option parsing and drives the three modes of
> > operation that are currently implemented:
> > 
> > 1. Report DTrace API version information.
> > 	Report the version information and terminate.
> > 
> > 2. List probes in BPF programs.
> > 	Initialize the list of probes that DTrace recognizes, load BPF
> > 	programs, parse all BPF ELF section names, resolve them into
> > 	known probes, and emit the probe names.  Then terminate.
> > 
> > 3. Load BPF programs and collect tracing data.
> > 	Initialize the list of probes that DTrace recognizes, load BPF
> > 	programs and attach them to their corresponding probes, set up
> > 	perf event output buffers, and start processing tracing data.
> > 
> > This implementation makes extensive use of BPF (handled by dt_bpf.c) and
> > the perf event output ring buffer (handled by dt_buffer.c).  DTrace-style
> > probe handling (dt_probe.c) offers an interface to probes that hides the
> > implementation details of the individual probe types by provider (dt_fbt.c
> > and dt_syscall.c).  Probe lookup by name uses a hashtable implementation
> > (dt_hash.c).  The dt_utils.c code populates a list of online CPU ids, so
> > we know what CPUs we can obtain tracing data from.
> > 
> > Building the tool is trivial because its only dependency (libbpf) is in
> > the kernel tree under tools/lib/bpf.  A simple 'make' in the tools/dtrace
> > directory suffices.
> > 
> > The 'dtrace' executable needs to run as root because BPF programs cannot
> > be loaded by non-root users.
> > 
> > Signed-off-by: Kris Van Hees <kris.van.hees@oracle.com>
> > Reviewed-by: David Mc Lean <david.mclean@oracle.com>
> > Reviewed-by: Eugene Loh <eugene.loh@oracle.com>
> > ---
> >  MAINTAINERS                |   6 +
> >  tools/dtrace/Makefile      |  88 ++++++++++
> >  tools/dtrace/bpf_sample.c  | 145 ++++++++++++++++
> >  tools/dtrace/dt_bpf.c      | 188 +++++++++++++++++++++
> >  tools/dtrace/dt_buffer.c   | 331 +++++++++++++++++++++++++++++++++++++
> >  tools/dtrace/dt_fbt.c      | 201 ++++++++++++++++++++++
> >  tools/dtrace/dt_hash.c     | 211 +++++++++++++++++++++++
> >  tools/dtrace/dt_probe.c    | 230 ++++++++++++++++++++++++++
> >  tools/dtrace/dt_syscall.c  | 179 ++++++++++++++++++++
> >  tools/dtrace/dt_utils.c    | 132 +++++++++++++++
> >  tools/dtrace/dtrace.c      | 249 ++++++++++++++++++++++++++++
> >  tools/dtrace/dtrace.h      |  13 ++
> >  tools/dtrace/dtrace_impl.h | 101 +++++++++++
> >  13 files changed, 2074 insertions(+)
> >  create mode 100644 tools/dtrace/Makefile
> >  create mode 100644 tools/dtrace/bpf_sample.c
> >  create mode 100644 tools/dtrace/dt_bpf.c
> >  create mode 100644 tools/dtrace/dt_buffer.c
> >  create mode 100644 tools/dtrace/dt_fbt.c
> >  create mode 100644 tools/dtrace/dt_hash.c
> >  create mode 100644 tools/dtrace/dt_probe.c
> >  create mode 100644 tools/dtrace/dt_syscall.c
> >  create mode 100644 tools/dtrace/dt_utils.c
> >  create mode 100644 tools/dtrace/dtrace.c
> >  create mode 100644 tools/dtrace/dtrace.h
> >  create mode 100644 tools/dtrace/dtrace_impl.h
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 606d1f80bc49..668468834865 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -5474,6 +5474,12 @@ W:	https://linuxtv.org
> >  S:	Odd Fixes
> >  F:	drivers/media/pci/dt3155/
> >  
> > +DTRACE
> > +M:	Kris Van Hees <kris.van.hees@oracle.com>
> > +L:	dtrace-devel@oss.oracle.com
> > +S:	Maintained
> > +F:	tools/dtrace/
> > +
> >  DVB_USB_AF9015 MEDIA DRIVER
> >  M:	Antti Palosaari <crope@iki.fi>
> >  L:	linux-media@vger.kernel.org
> > diff --git a/tools/dtrace/Makefile b/tools/dtrace/Makefile
> > new file mode 100644
> > index 000000000000..99fd0f9dd1d6
> > --- /dev/null
> > +++ b/tools/dtrace/Makefile
> > @@ -0,0 +1,88 @@
> > +# SPDX-License-Identifier: GPL-2.0
> > +#
> > +# This Makefile is based on samples/bpf.
> > +#
> > +# Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
> > +
> > +DT_VERSION		:= 2.0.0
> > +DT_GIT_VERSION		:= $(shell git rev-parse HEAD 2>/dev/null || \
> > +				   echo Unknown)
> > +
> > +DTRACE_PATH		?= $(abspath $(srctree)/$(src))
> > +TOOLS_PATH		:= $(DTRACE_PATH)/..
> > +SAMPLES_PATH		:= $(DTRACE_PATH)/../../samples
> > +
> > +hostprogs-y		:= dtrace
> > +
> > +LIBBPF			:= $(TOOLS_PATH)/lib/bpf/libbpf.a
> > +OBJS			:= dt_bpf.o dt_buffer.o dt_utils.o dt_probe.o \
> > +			   dt_hash.o \
> > +			   dt_fbt.o dt_syscall.o
> > +
> > +dtrace-objs		:= $(OBJS) dtrace.o
> > +
> > +always			:= $(hostprogs-y)
> > +always			+= bpf_sample.o
> > +
> > +KBUILD_HOSTCFLAGS	+= -DDT_VERSION=\"$(DT_VERSION)\"
> > +KBUILD_HOSTCFLAGS	+= -DDT_GIT_VERSION=\"$(DT_GIT_VERSION)\"
> > +KBUILD_HOSTCFLAGS	+= -I$(srctree)/tools/lib
> > +KBUILD_HOSTCFLAGS	+= -I$(srctree)/tools/perf
> 
> Interesting, what are you using from tools/perf/? So that we can move to
> tools/{include,lib,arch}.

This is my mistake...  an earlier version of the code (as I was developing it)
was using stuff from tools/perf, but that is no longer the case.  Removing it.

> > +KBUILD_HOSTCFLAGS	+= -I$(srctree)/tools/include/uapi
> > +KBUILD_HOSTCFLAGS	+= -I$(srctree)/tools/include/
> > +KBUILD_HOSTCFLAGS	+= -I$(srctree)/usr/include
> > +
> > +KBUILD_HOSTLDLIBS	:= $(LIBBPF) -lelf
> > +
> > +LLC			?= llc
> > +CLANG			?= clang
> > +LLVM_OBJCOPY		?= llvm-objcopy
> > +
> > +ifdef CROSS_COMPILE
> > +HOSTCC			= $(CROSS_COMPILE)gcc
> > +CLANG_ARCH_ARGS		= -target $(ARCH)
> > +endif
> > +
> > +all:
> > +	$(MAKE) -C ../../ $(CURDIR)/ DTRACE_PATH=$(CURDIR)
> > +
> > +clean:
> > +	$(MAKE) -C ../../ M=$(CURDIR) clean
> > +	@rm -f *~
> > +
> > +$(LIBBPF): FORCE
> > +	$(MAKE) -C $(dir $@) RM='rm -rf' LDFLAGS= srctree=$(DTRACE_PATH)/../../ O=
> > +
> > +FORCE:
> > +
> > +.PHONY: verify_cmds verify_target_bpf $(CLANG) $(LLC)
> > +
> > +verify_cmds: $(CLANG) $(LLC)
> > +	@for TOOL in $^ ; do \
> > +		if ! (which -- "$${TOOL}" > /dev/null 2>&1); then \
> > +			echo "*** ERROR: Cannot find LLVM tool $${TOOL}" ;\
> > +			exit 1; \
> > +		else true; fi; \
> > +	done
> > +
> > +verify_target_bpf: verify_cmds
> > +	@if ! (${LLC} -march=bpf -mattr=help > /dev/null 2>&1); then \
> > +		echo "*** ERROR: LLVM (${LLC}) does not support 'bpf' target" ;\
> > +		echo "   NOTICE: LLVM version >= 3.7.1 required" ;\
> > +		exit 2; \
> > +	else true; fi
> > +
> > +$(DTRACE_PATH)/*.c: verify_target_bpf $(LIBBPF)
> > +$(src)/*.c: verify_target_bpf $(LIBBPF)
> > +
> > +$(obj)/%.o: $(src)/%.c
> > +	@echo "  CLANG-bpf " $@
> > +	$(Q)$(CLANG) $(NOSTDINC_FLAGS) $(LINUXINCLUDE) $(EXTRA_CFLAGS) -I$(obj) \
> > +		-I$(srctree)/tools/testing/selftests/bpf/ \
> > +		-D__KERNEL__ -D__BPF_TRACING__ -Wno-unused-value -Wno-pointer-sign \
> > +		-D__TARGET_ARCH_$(ARCH) -Wno-compare-distinct-pointer-types \
> > +		-Wno-gnu-variable-sized-type-not-at-end \
> > +		-Wno-address-of-packed-member -Wno-tautological-compare \
> > +		-Wno-unknown-warning-option $(CLANG_ARCH_ARGS) \
> > +		-I$(srctree)/samples/bpf/ -include asm_goto_workaround.h \
> > +		-O2 -emit-llvm -c $< -o -| $(LLC) -march=bpf $(LLC_FLAGS) -filetype=obj -o $@
> 
> 
> We have the above in tools/perf/util/llvm-utils.c, perhaps we need to
> move it to some place in lib/ to share?

Yes, if there is a way to put things like this in a central location so we can
maintain a single copy that would be a good idea indeed.

> > diff --git a/tools/dtrace/bpf_sample.c b/tools/dtrace/bpf_sample.c
> > new file mode 100644
> > index 000000000000..49f350390b5f
> > --- /dev/null
> > +++ b/tools/dtrace/bpf_sample.c
> > @@ -0,0 +1,145 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * This sample DTrace BPF tracing program demonstrates how actions can be
> > + * associated with different probe types.
> > + *
> > + * The kprobe/ksys_write probe is a Function Boundary Tracing (FBT) entry probe
> > + * on the ksys_write(fd, buf, count) function in the kernel.  Arguments to the
> > + * function can be retrieved from the CPU registers (struct pt_regs).
> > + *
> > + * The tracepoint/syscalls/sys_enter_write probe is a System Call entry probe
> > + * for the write(d, buf, count) system call.  Arguments to the system call can
> > + * be retrieved from the tracepoint data passed to the BPF program as context
> > + * struct syscall_data) when the probe fires.
> > + *
> > + * The BPF program associated with each probe prepares a DTrace BPF context
> > + * (struct dt_bpf_context) that stores the probe ID and up to 10 arguments.
> > + * Only 3 arguments are used in this sample.  Then the prorgams call a shared
> > + * BPF function (bpf_action) that implements the actual action to be taken when
> > + * a probe fires.  It prepares a data record to be stored in the tracing buffer
> > + * and submits it to the buffer.  The data in the data record is obtained from
> > + * the DTrace BPF context.
> > + *
> > + * Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
> > + */
> > +#include <uapi/linux/bpf.h>
> > +#include <linux/ptrace.h>
> > +#include <linux/version.h>
> > +#include <uapi/linux/unistd.h>
> > +#include "bpf_helpers.h"
> > +
> > +#include "dtrace.h"
> > +
> > +struct syscall_data {
> > +	struct pt_regs *regs;
> > +	long syscall_nr;
> > +	long arg[6];
> > +};
> > +
> > +struct bpf_map_def SEC("maps") buffers = {
> > +	.type = BPF_MAP_TYPE_PERF_EVENT_ARRAY,
> > +	.key_size = sizeof(u32),
> > +	.value_size = sizeof(u32),
> > +	.max_entries = NR_CPUS,
> > +};
> > +
> > +#if defined(__amd64)
> > +# define GET_REGS_ARG0(regs)	((regs)->di)
> > +# define GET_REGS_ARG1(regs)	((regs)->si)
> > +# define GET_REGS_ARG2(regs)	((regs)->dx)
> > +# define GET_REGS_ARG3(regs)	((regs)->cx)
> > +# define GET_REGS_ARG4(regs)	((regs)->r8)
> > +# define GET_REGS_ARG5(regs)	((regs)->r9)
> > +#else
> > +# warning Argument retrieval from pt_regs is not supported yet on this arch.
> > +# define GET_REGS_ARG0(regs)	0
> > +# define GET_REGS_ARG1(regs)	0
> > +# define GET_REGS_ARG2(regs)	0
> > +# define GET_REGS_ARG3(regs)	0
> > +# define GET_REGS_ARG4(regs)	0
> > +# define GET_REGS_ARG5(regs)	0
> > +#endif
> 
> We have this in tools/testing/selftests/bpf/bpf_helpers.h, probably need
> to move to some other place in tools/include/ where this can be shared.

I should be using the ones in bpf_helpers (since I already include that
anyway), and yes, if we can move that to a general use location under
tools/include that would be a good idea.

Also, I jsut updated my code to use this and I added a PT_REGS_PARM6(x) for
all the listed archs because I need to be able to get to up to 6 parameters
rather than the supported 5.  As far as I can see, all listed archs support
argument passing of at least 6 arguments so this should be no problem.

Any objections?
