Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C59E626F0
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 19:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730753AbfGHRPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 13:15:50 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:39276 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbfGHRPu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 13:15:50 -0400
Received: by mail-qt1-f196.google.com with SMTP id l9so10528548qtu.6;
        Mon, 08 Jul 2019 10:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MBlubbU0R5XFJCwlDpOx2qjTnessXq3omSttHg+Xzyc=;
        b=oXt2PJIQ/dBE0txvV7Dyh6C+enhe4trh97ibz0Rvtxa5NXu8QmVlCILQS3evg0WQA4
         SXX07Ygwd8p5STAY7Z5f02gXQm9saH6X3EJABWC/CQQsF2LMe451ki6kZ719tyHNmLwT
         5Z9hRQgR6KpV+l2Q8DDPD/tlQDbpNIfkzAv1mdBgqKJTZObDAPMZWvfFo4HchalagwF3
         sSt6ZRlgo6FTZdTszWLDEZwnFw0Uis2HSytxdG8hIfi/Z+1oBefU9y5FSDWI/DVlEXq+
         smZLpgfzutmz+00x372Vp78MVYxYos01ngv/jkxNoXvyyA+xw9f4GGf6igizNw2A/iX0
         pm7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MBlubbU0R5XFJCwlDpOx2qjTnessXq3omSttHg+Xzyc=;
        b=EPACDr21QWEi6JgiTmoAvd2IyNLw9pxhc9szF7N8MZZeugXIby3oQPYpGmBCQm6/iy
         /ElvEI8VgHcWMxZAuBdhkN+pCwykXcEAMW6ERmLJxj6ap5XyOcQ7v25AZ+6cbe8jSupL
         8rsdSgu5jIGVvt/RFqWhYeM68KLllH7rXTzFzDyDto61O+XfnDhtAmpGPqo9InIcUmc2
         jw0mnzRla7vgypvwWUVf1JHXwatRNeL+Wh3sW04eTxdXP1o/88N8fKm8/4NpRLJD81Un
         574/6TXVe5K7KdQXGtro2a07HcjbjLu2sG/GqlVuvzmv0ta8XRrnQ1ad26L8DhVZrq7a
         6EfA==
X-Gm-Message-State: APjAAAXUEW8z4NgGUwJeIKNYioIx1O9J9+ZSuv0R8G7r5A8+ivTUJedn
        ZBJ5H5tNMOn7zpoz0VKO2yk=
X-Google-Smtp-Source: APXvYqz6x6JXW16TCNSVO7lwn8WNf66n+kLKcO6caiauw+YJLKFAwMyW03a1AyXHYiORzzPNDDNnGw==
X-Received: by 2002:a0c:acfb:: with SMTP id n56mr16088170qvc.87.1562606148442;
        Mon, 08 Jul 2019 10:15:48 -0700 (PDT)
Received: from quaco.ghostprotocols.net (179-240-135-35.3g.claro.net.br. [179.240.135.35])
        by smtp.gmail.com with ESMTPSA id i16sm7405001qkk.1.2019.07.08.10.15.45
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 10:15:46 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 9E43840340; Mon,  8 Jul 2019 14:15:37 -0300 (-03)
Date:   Mon, 8 Jul 2019 14:15:37 -0300
To:     Kris Van Hees <kris.van.hees@oracle.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        dtrace-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, mhiramat@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, Peter Zijlstra <peterz@infradead.org>,
        Chris Mason <clm@fb.com>
Subject: Re: [PATCH 1/1] tools/dtrace: initial implementation of DTrace
Message-ID: <20190708171537.GA11960@kernel.org>
References: <201907040313.x643D8Pg025951@userv0121.oracle.com>
 <201907040314.x643EUoA017906@aserv0122.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201907040314.x643EUoA017906@aserv0122.oracle.com>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Wed, Jul 03, 2019 at 08:14:30PM -0700, Kris Van Hees escreveu:
> This initial implementation of a tiny subset of DTrace functionality
> provides the following options:
> 
> 	dtrace [-lvV] [-b bufsz] -s script
> 	    -b  set trace buffer size
> 	    -l  list probes (only works with '-s script' for now)
> 	    -s  enable or list probes for the specified BPF program
> 	    -V  report DTrace API version
> 
> The patch comprises quite a bit of code due to DTrace requiring a few
> crucial components, even in its most basic form.
> 
> The code is structured around the command line interface implemented in
> dtrace.c.  It provides option parsing and drives the three modes of
> operation that are currently implemented:
> 
> 1. Report DTrace API version information.
> 	Report the version information and terminate.
> 
> 2. List probes in BPF programs.
> 	Initialize the list of probes that DTrace recognizes, load BPF
> 	programs, parse all BPF ELF section names, resolve them into
> 	known probes, and emit the probe names.  Then terminate.
> 
> 3. Load BPF programs and collect tracing data.
> 	Initialize the list of probes that DTrace recognizes, load BPF
> 	programs and attach them to their corresponding probes, set up
> 	perf event output buffers, and start processing tracing data.
> 
> This implementation makes extensive use of BPF (handled by dt_bpf.c) and
> the perf event output ring buffer (handled by dt_buffer.c).  DTrace-style
> probe handling (dt_probe.c) offers an interface to probes that hides the
> implementation details of the individual probe types by provider (dt_fbt.c
> and dt_syscall.c).  Probe lookup by name uses a hashtable implementation
> (dt_hash.c).  The dt_utils.c code populates a list of online CPU ids, so
> we know what CPUs we can obtain tracing data from.
> 
> Building the tool is trivial because its only dependency (libbpf) is in
> the kernel tree under tools/lib/bpf.  A simple 'make' in the tools/dtrace
> directory suffices.
> 
> The 'dtrace' executable needs to run as root because BPF programs cannot
> be loaded by non-root users.
> 
> Signed-off-by: Kris Van Hees <kris.van.hees@oracle.com>
> Reviewed-by: David Mc Lean <david.mclean@oracle.com>
> Reviewed-by: Eugene Loh <eugene.loh@oracle.com>
> ---
>  MAINTAINERS                |   6 +
>  tools/dtrace/Makefile      |  88 ++++++++++
>  tools/dtrace/bpf_sample.c  | 145 ++++++++++++++++
>  tools/dtrace/dt_bpf.c      | 188 +++++++++++++++++++++
>  tools/dtrace/dt_buffer.c   | 331 +++++++++++++++++++++++++++++++++++++
>  tools/dtrace/dt_fbt.c      | 201 ++++++++++++++++++++++
>  tools/dtrace/dt_hash.c     | 211 +++++++++++++++++++++++
>  tools/dtrace/dt_probe.c    | 230 ++++++++++++++++++++++++++
>  tools/dtrace/dt_syscall.c  | 179 ++++++++++++++++++++
>  tools/dtrace/dt_utils.c    | 132 +++++++++++++++
>  tools/dtrace/dtrace.c      | 249 ++++++++++++++++++++++++++++
>  tools/dtrace/dtrace.h      |  13 ++
>  tools/dtrace/dtrace_impl.h | 101 +++++++++++
>  13 files changed, 2074 insertions(+)
>  create mode 100644 tools/dtrace/Makefile
>  create mode 100644 tools/dtrace/bpf_sample.c
>  create mode 100644 tools/dtrace/dt_bpf.c
>  create mode 100644 tools/dtrace/dt_buffer.c
>  create mode 100644 tools/dtrace/dt_fbt.c
>  create mode 100644 tools/dtrace/dt_hash.c
>  create mode 100644 tools/dtrace/dt_probe.c
>  create mode 100644 tools/dtrace/dt_syscall.c
>  create mode 100644 tools/dtrace/dt_utils.c
>  create mode 100644 tools/dtrace/dtrace.c
>  create mode 100644 tools/dtrace/dtrace.h
>  create mode 100644 tools/dtrace/dtrace_impl.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 606d1f80bc49..668468834865 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5474,6 +5474,12 @@ W:	https://linuxtv.org
>  S:	Odd Fixes
>  F:	drivers/media/pci/dt3155/
>  
> +DTRACE
> +M:	Kris Van Hees <kris.van.hees@oracle.com>
> +L:	dtrace-devel@oss.oracle.com
> +S:	Maintained
> +F:	tools/dtrace/
> +
>  DVB_USB_AF9015 MEDIA DRIVER
>  M:	Antti Palosaari <crope@iki.fi>
>  L:	linux-media@vger.kernel.org
> diff --git a/tools/dtrace/Makefile b/tools/dtrace/Makefile
> new file mode 100644
> index 000000000000..99fd0f9dd1d6
> --- /dev/null
> +++ b/tools/dtrace/Makefile
> @@ -0,0 +1,88 @@
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# This Makefile is based on samples/bpf.
> +#
> +# Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
> +
> +DT_VERSION		:= 2.0.0
> +DT_GIT_VERSION		:= $(shell git rev-parse HEAD 2>/dev/null || \
> +				   echo Unknown)
> +
> +DTRACE_PATH		?= $(abspath $(srctree)/$(src))
> +TOOLS_PATH		:= $(DTRACE_PATH)/..
> +SAMPLES_PATH		:= $(DTRACE_PATH)/../../samples
> +
> +hostprogs-y		:= dtrace
> +
> +LIBBPF			:= $(TOOLS_PATH)/lib/bpf/libbpf.a
> +OBJS			:= dt_bpf.o dt_buffer.o dt_utils.o dt_probe.o \
> +			   dt_hash.o \
> +			   dt_fbt.o dt_syscall.o
> +
> +dtrace-objs		:= $(OBJS) dtrace.o
> +
> +always			:= $(hostprogs-y)
> +always			+= bpf_sample.o
> +
> +KBUILD_HOSTCFLAGS	+= -DDT_VERSION=\"$(DT_VERSION)\"
> +KBUILD_HOSTCFLAGS	+= -DDT_GIT_VERSION=\"$(DT_GIT_VERSION)\"
> +KBUILD_HOSTCFLAGS	+= -I$(srctree)/tools/lib
> +KBUILD_HOSTCFLAGS	+= -I$(srctree)/tools/perf

Interesting, what are you using from tools/perf/? So that we can move to
tools/{include,lib,arch}.

> +KBUILD_HOSTCFLAGS	+= -I$(srctree)/tools/include/uapi
> +KBUILD_HOSTCFLAGS	+= -I$(srctree)/tools/include/
> +KBUILD_HOSTCFLAGS	+= -I$(srctree)/usr/include
> +
> +KBUILD_HOSTLDLIBS	:= $(LIBBPF) -lelf
> +
> +LLC			?= llc
> +CLANG			?= clang
> +LLVM_OBJCOPY		?= llvm-objcopy
> +
> +ifdef CROSS_COMPILE
> +HOSTCC			= $(CROSS_COMPILE)gcc
> +CLANG_ARCH_ARGS		= -target $(ARCH)
> +endif
> +
> +all:
> +	$(MAKE) -C ../../ $(CURDIR)/ DTRACE_PATH=$(CURDIR)
> +
> +clean:
> +	$(MAKE) -C ../../ M=$(CURDIR) clean
> +	@rm -f *~
> +
> +$(LIBBPF): FORCE
> +	$(MAKE) -C $(dir $@) RM='rm -rf' LDFLAGS= srctree=$(DTRACE_PATH)/../../ O=
> +
> +FORCE:
> +
> +.PHONY: verify_cmds verify_target_bpf $(CLANG) $(LLC)
> +
> +verify_cmds: $(CLANG) $(LLC)
> +	@for TOOL in $^ ; do \
> +		if ! (which -- "$${TOOL}" > /dev/null 2>&1); then \
> +			echo "*** ERROR: Cannot find LLVM tool $${TOOL}" ;\
> +			exit 1; \
> +		else true; fi; \
> +	done
> +
> +verify_target_bpf: verify_cmds
> +	@if ! (${LLC} -march=bpf -mattr=help > /dev/null 2>&1); then \
> +		echo "*** ERROR: LLVM (${LLC}) does not support 'bpf' target" ;\
> +		echo "   NOTICE: LLVM version >= 3.7.1 required" ;\
> +		exit 2; \
> +	else true; fi
> +
> +$(DTRACE_PATH)/*.c: verify_target_bpf $(LIBBPF)
> +$(src)/*.c: verify_target_bpf $(LIBBPF)
> +
> +$(obj)/%.o: $(src)/%.c
> +	@echo "  CLANG-bpf " $@
> +	$(Q)$(CLANG) $(NOSTDINC_FLAGS) $(LINUXINCLUDE) $(EXTRA_CFLAGS) -I$(obj) \
> +		-I$(srctree)/tools/testing/selftests/bpf/ \
> +		-D__KERNEL__ -D__BPF_TRACING__ -Wno-unused-value -Wno-pointer-sign \
> +		-D__TARGET_ARCH_$(ARCH) -Wno-compare-distinct-pointer-types \
> +		-Wno-gnu-variable-sized-type-not-at-end \
> +		-Wno-address-of-packed-member -Wno-tautological-compare \
> +		-Wno-unknown-warning-option $(CLANG_ARCH_ARGS) \
> +		-I$(srctree)/samples/bpf/ -include asm_goto_workaround.h \
> +		-O2 -emit-llvm -c $< -o -| $(LLC) -march=bpf $(LLC_FLAGS) -filetype=obj -o $@


We have the above in tools/perf/util/llvm-utils.c, perhaps we need to
move it to some place in lib/ to share?

> diff --git a/tools/dtrace/bpf_sample.c b/tools/dtrace/bpf_sample.c
> new file mode 100644
> index 000000000000..49f350390b5f
> --- /dev/null
> +++ b/tools/dtrace/bpf_sample.c
> @@ -0,0 +1,145 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * This sample DTrace BPF tracing program demonstrates how actions can be
> + * associated with different probe types.
> + *
> + * The kprobe/ksys_write probe is a Function Boundary Tracing (FBT) entry probe
> + * on the ksys_write(fd, buf, count) function in the kernel.  Arguments to the
> + * function can be retrieved from the CPU registers (struct pt_regs).
> + *
> + * The tracepoint/syscalls/sys_enter_write probe is a System Call entry probe
> + * for the write(d, buf, count) system call.  Arguments to the system call can
> + * be retrieved from the tracepoint data passed to the BPF program as context
> + * struct syscall_data) when the probe fires.
> + *
> + * The BPF program associated with each probe prepares a DTrace BPF context
> + * (struct dt_bpf_context) that stores the probe ID and up to 10 arguments.
> + * Only 3 arguments are used in this sample.  Then the prorgams call a shared
> + * BPF function (bpf_action) that implements the actual action to be taken when
> + * a probe fires.  It prepares a data record to be stored in the tracing buffer
> + * and submits it to the buffer.  The data in the data record is obtained from
> + * the DTrace BPF context.
> + *
> + * Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
> + */
> +#include <uapi/linux/bpf.h>
> +#include <linux/ptrace.h>
> +#include <linux/version.h>
> +#include <uapi/linux/unistd.h>
> +#include "bpf_helpers.h"
> +
> +#include "dtrace.h"
> +
> +struct syscall_data {
> +	struct pt_regs *regs;
> +	long syscall_nr;
> +	long arg[6];
> +};
> +
> +struct bpf_map_def SEC("maps") buffers = {
> +	.type = BPF_MAP_TYPE_PERF_EVENT_ARRAY,
> +	.key_size = sizeof(u32),
> +	.value_size = sizeof(u32),
> +	.max_entries = NR_CPUS,
> +};
> +
> +#if defined(__amd64)
> +# define GET_REGS_ARG0(regs)	((regs)->di)
> +# define GET_REGS_ARG1(regs)	((regs)->si)
> +# define GET_REGS_ARG2(regs)	((regs)->dx)
> +# define GET_REGS_ARG3(regs)	((regs)->cx)
> +# define GET_REGS_ARG4(regs)	((regs)->r8)
> +# define GET_REGS_ARG5(regs)	((regs)->r9)
> +#else
> +# warning Argument retrieval from pt_regs is not supported yet on this arch.
> +# define GET_REGS_ARG0(regs)	0
> +# define GET_REGS_ARG1(regs)	0
> +# define GET_REGS_ARG2(regs)	0
> +# define GET_REGS_ARG3(regs)	0
> +# define GET_REGS_ARG4(regs)	0
> +# define GET_REGS_ARG5(regs)	0
> +#endif

We have this in tools/testing/selftests/bpf/bpf_helpers.h, probably need
to move to some other place in tools/include/ where this can be shared.

- Arnaldo
