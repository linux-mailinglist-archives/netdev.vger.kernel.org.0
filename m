Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E41B3B5885
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 01:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728724AbfIQX2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 19:28:13 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:35466 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfIQX2N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 19:28:13 -0400
Received: by mail-qt1-f195.google.com with SMTP id m15so6650523qtq.2;
        Tue, 17 Sep 2019 16:28:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QObwZDgaxtl27tWC1JznlGz6uTSM/Q0uCMiJ7OYqwWA=;
        b=GCQCKVVF9+OPd4C3FqedzJBckxoaqaTfqgEqfd35WPU8v3qTehFqMLORS4DVfxTvb5
         jQT/jr5Cge71thlJXmfgIzguxxa6GVHmVKKIMQuqbBlGbB7FhLZz/mvhsmzgJIETD6oV
         5xSyJtuGEylWJRbW8X6c7tqNpYDtt6wJC617IaHEmnKn3J9LURKpXSZkLX0mx899MT8h
         8DZs6X0Pon/iG8PB89PudDxjSKZlFkUZzDwcMU2xamDQHgcufp6m3Xe+reG9he+ZNUa9
         rftrxDLWXrECbvkXRuJbLXtxmZXUdmdEhIpV8+9U76rCHSCv+sqcTemIgwVd0OAXT4Hc
         GSdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QObwZDgaxtl27tWC1JznlGz6uTSM/Q0uCMiJ7OYqwWA=;
        b=SI5vTsns6ZZi9N1UV9UQtwRyMLS37w0WuUhwunGYouXZyXYL2ou324NLmzZbSE7zeX
         ykJ6p2Z2d8gVVH6VW9HRzLC5BH9U+5PLZD+eZgLW0EaBYuJevp6C/986bzZBJqPLA6b+
         TNO1dBtyXS2JblEei/x67o1+thAw3oQnppoG9O5aL1H4oWDjiEVqvQsuDn0UnBJnbg1Z
         bFDk8SfWK/8XjVWCWgpXRnkVOPtxGcECyOnOnzU9c5csDY1+Akkz21/VCD2r711ooT4V
         BtF90cKr65YH8+Ks4N9ZEnjl3F8ojVUUk5JNpH/R+EviY8xHJob2DOas/f4f/SexweOL
         2cCA==
X-Gm-Message-State: APjAAAWPWqDTmN3/hi/IPsV2UWn0O3XqcDPZ21/bWsMjlEopoFFZOQsk
        0hJDwiMMA7JJI5QN58HGBBNss+gsHOxiaw+PwqE=
X-Google-Smtp-Source: APXvYqwknimtDRbVoUPxVhHcIdf0wClaVNvMK7uPI8ud7Oo4gygHArcWRAjyAKH84hBFSsQUP2A4EsbWp2j0UPX384E=
X-Received: by 2002:a0c:88f0:: with SMTP id 45mr1082154qvo.78.1568762891894;
 Tue, 17 Sep 2019 16:28:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190916105433.11404-1-ivan.khoronzhuk@linaro.org> <20190916105433.11404-9-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20190916105433.11404-9-ivan.khoronzhuk@linaro.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 17 Sep 2019 16:28:01 -0700
Message-ID: <CAEf4BzYFoJJk+WM51YT7NwCxQpy117DAMmgiJ1YbqaW9UUWpEg@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 08/14] samples: bpf: makefile: base target
 programs rules on Makefile.target
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        clang-built-linux@googlegroups.com,
        sergei.shtylyov@cogentembedded.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 16, 2019 at 3:58 AM Ivan Khoronzhuk
<ivan.khoronzhuk@linaro.org> wrote:
>

Please don't prepend "samples: bpf: makefile:" to patches,
"samples/bpf: " is a typical we've used for BPF samples changes.


> The main reason for that - HOSTCC and CC have different aims.
> HOSTCC is used to build programs running on host, that can
> cross-comple target programs with CC. It was tested for arm and arm64
> cross compilation, based on linaro toolchain, but should work for
> others.
>
> So, in order to split cross compilation (CC) with host build (HOSTCC),
> lets base samples on Makefile.target. It allows to cross-compile
> samples/bpf programs with CC while auxialry tools running on host
> built with HOSTCC.
>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> ---
>  samples/bpf/Makefile | 135 ++++++++++++++++++++++---------------------
>  1 file changed, 69 insertions(+), 66 deletions(-)
>
> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> index 9d923546e087..1579cc16a1c2 100644
> --- a/samples/bpf/Makefile
> +++ b/samples/bpf/Makefile
> @@ -4,55 +4,53 @@ BPF_SAMPLES_PATH ?= $(abspath $(srctree)/$(src))
>  TOOLS_PATH := $(BPF_SAMPLES_PATH)/../../tools
>
>  # List of programs to build
> -hostprogs-y := test_lru_dist
> -hostprogs-y += sock_example
> -hostprogs-y += fds_example
> -hostprogs-y += sockex1
> -hostprogs-y += sockex2
> -hostprogs-y += sockex3
> -hostprogs-y += tracex1
> -hostprogs-y += tracex2
> -hostprogs-y += tracex3
> -hostprogs-y += tracex4
> -hostprogs-y += tracex5
> -hostprogs-y += tracex6
> -hostprogs-y += tracex7
> -hostprogs-y += test_probe_write_user
> -hostprogs-y += trace_output
> -hostprogs-y += lathist
> -hostprogs-y += offwaketime
> -hostprogs-y += spintest
> -hostprogs-y += map_perf_test
> -hostprogs-y += test_overhead
> -hostprogs-y += test_cgrp2_array_pin
> -hostprogs-y += test_cgrp2_attach
> -hostprogs-y += test_cgrp2_sock
> -hostprogs-y += test_cgrp2_sock2
> -hostprogs-y += xdp1
> -hostprogs-y += xdp2
> -hostprogs-y += xdp_router_ipv4
> -hostprogs-y += test_current_task_under_cgroup
> -hostprogs-y += trace_event
> -hostprogs-y += sampleip
> -hostprogs-y += tc_l2_redirect
> -hostprogs-y += lwt_len_hist
> -hostprogs-y += xdp_tx_iptunnel
> -hostprogs-y += test_map_in_map
> -hostprogs-y += per_socket_stats_example
> -hostprogs-y += xdp_redirect
> -hostprogs-y += xdp_redirect_map
> -hostprogs-y += xdp_redirect_cpu
> -hostprogs-y += xdp_monitor
> -hostprogs-y += xdp_rxq_info
> -hostprogs-y += syscall_tp
> -hostprogs-y += cpustat
> -hostprogs-y += xdp_adjust_tail
> -hostprogs-y += xdpsock
> -hostprogs-y += xdp_fwd
> -hostprogs-y += task_fd_query
> -hostprogs-y += xdp_sample_pkts
> -hostprogs-y += ibumad
> -hostprogs-y += hbm
> +tprogs-y := test_lru_dist
> +tprogs-y += sock_example
> +tprogs-y += fds_example
> +tprogs-y += sockex1
> +tprogs-y += sockex2
> +tprogs-y += sockex3
> +tprogs-y += tracex1
> +tprogs-y += tracex2
> +tprogs-y += tracex3
> +tprogs-y += tracex4
> +tprogs-y += tracex5
> +tprogs-y += tracex6
> +tprogs-y += tracex7
> +tprogs-y += test_probe_write_user
> +tprogs-y += trace_output
> +tprogs-y += lathist
> +tprogs-y += offwaketime
> +tprogs-y += spintest
> +tprogs-y += map_perf_test
> +tprogs-y += test_overhead
> +tprogs-y += test_cgrp2_array_pin
> +tprogs-y += test_cgrp2_attach
> +tprogs-y += test_cgrp2_sock
> +tprogs-y += test_cgrp2_sock2
> +tprogs-y += xdp1
> +tprogs-y += xdp2
> +tprogs-y += xdp_router_ipv4
> +tprogs-y += test_current_task_under_cgroup
> +tprogs-y += trace_event
> +tprogs-y += sampleip
> +tprogs-y += tc_l2_redirect
> +tprogs-y += lwt_len_hist
> +tprogs-y += xdp_tx_iptunnel
> +tprogs-y += test_map_in_map
> +tprogs-y += xdp_redirect_map
> +tprogs-y += xdp_redirect_cpu
> +tprogs-y += xdp_monitor
> +tprogs-y += xdp_rxq_info
> +tprogs-y += syscall_tp
> +tprogs-y += cpustat
> +tprogs-y += xdp_adjust_tail
> +tprogs-y += xdpsock
> +tprogs-y += xdp_fwd
> +tprogs-y += task_fd_query
> +tprogs-y += xdp_sample_pkts
> +tprogs-y += ibumad
> +tprogs-y += hbm
>
>  # Libbpf dependencies
>  LIBBPF = $(TOOLS_PATH)/lib/bpf/libbpf.a
> @@ -111,7 +109,7 @@ ibumad-objs := bpf_load.o ibumad_user.o $(TRACE_HELPERS)
>  hbm-objs := bpf_load.o hbm.o $(CGROUP_HELPERS)
>
>  # Tell kbuild to always build the programs
> -always := $(hostprogs-y)
> +always := $(tprogs-y)
>  always += sockex1_kern.o
>  always += sockex2_kern.o
>  always += sockex3_kern.o
> @@ -170,21 +168,6 @@ always += ibumad_kern.o
>  always += hbm_out_kern.o
>  always += hbm_edt_kern.o
>
> -KBUILD_HOSTCFLAGS += -I$(objtree)/usr/include
> -KBUILD_HOSTCFLAGS += -I$(srctree)/tools/lib/bpf/
> -KBUILD_HOSTCFLAGS += -I$(srctree)/tools/testing/selftests/bpf/
> -KBUILD_HOSTCFLAGS += -I$(srctree)/tools/lib/ -I$(srctree)/tools/include
> -KBUILD_HOSTCFLAGS += -I$(srctree)/tools/perf
> -
> -HOSTCFLAGS_bpf_load.o += -Wno-unused-variable
> -
> -KBUILD_HOSTLDLIBS              += $(LIBBPF) -lelf
> -HOSTLDLIBS_tracex4             += -lrt
> -HOSTLDLIBS_trace_output        += -lrt
> -HOSTLDLIBS_map_perf_test       += -lrt
> -HOSTLDLIBS_test_overhead       += -lrt
> -HOSTLDLIBS_xdpsock             += -pthread
> -
>  ifeq ($(ARCH), arm)
>  # Strip all except -D__LINUX_ARM_ARCH__ option needed to handle linux
>  # headers when arm instruction set identification is requested.
> @@ -192,9 +175,27 @@ ARM_ARCH_SELECTOR = $(shell echo "$(KBUILD_CFLAGS) " | \
>                     sed 's/[[:blank:]]/\n/g' | sed '/^-D__LINUX_ARM_ARCH__/!d')
>
>  CLANG_EXTRA_CFLAGS := $(ARM_ARCH_SELECTOR)
> -KBUILD_HOSTCFLAGS := $(ARM_ARCH_SELECTOR)
> +TPROGS_CFLAGS += $(ARM_ARCH_SELECTOR)
>  endif
>
> +TPROGS_LDLIBS := $(KBUILD_HOSTLDLIBS)

Please group TPROGS_LDLIBS definition together with the one below,
there doesn't seem to be a reason to split them this way.

But also, it's kind of weird to use host libraries as cross-compiled
libraries as well. Is that intentional?

> +TPROGS_CFLAGS += $(KBUILD_HOSTCFLAGS) $(HOST_EXTRACFLAGS)

Same here, is it right to use HOSTCFLAGS and HOST_EXTRACFLAGS as a
base for cross-compiled cflags?

> +TPROGS_CFLAGS += -I$(objtree)/usr/include
> +TPROGS_CFLAGS += -I$(srctree)/tools/lib/bpf/
> +TPROGS_CFLAGS += -I$(srctree)/tools/testing/selftests/bpf/
> +TPROGS_CFLAGS += -I$(srctree)/tools/lib/
> +TPROGS_CFLAGS += -I$(srctree)/tools/include
> +TPROGS_CFLAGS += -I$(srctree)/tools/perf
> +
> +TPROGCFLAGS_bpf_load.o += -Wno-unused-variable
> +
> +TPROGS_LDLIBS                  += $(LIBBPF) -lelf
> +TPROGLDLIBS_tracex4            += -lrt
> +TPROGLDLIBS_trace_output       += -lrt
> +TPROGLDLIBS_map_perf_test      += -lrt
> +TPROGLDLIBS_test_overhead      += -lrt
> +TPROGLDLIBS_xdpsock            += -pthread
> +
>  # Allows pointing LLC/CLANG to a LLVM backend with bpf support, redefine on cmdline:
>  #  make samples/bpf/ LLC=~/git/llvm/build/bin/llc CLANG=~/git/llvm/build/bin/clang
>  LLC ?= llc
> @@ -285,6 +286,8 @@ $(obj)/hbm_out_kern.o: $(src)/hbm.h $(src)/hbm_kern.h
>  $(obj)/hbm.o: $(src)/hbm.h
>  $(obj)/hbm_edt_kern.o: $(src)/hbm.h $(src)/hbm_kern.h
>
> +-include $(BPF_SAMPLES_PATH)/Makefile.target
> +
>  # asm/sysreg.h - inline assembly used by it is incompatible with llvm.
>  # But, there is no easy way to fix it, so just exclude it since it is
>  # useless for BPF samples.
> --
> 2.17.1
>
