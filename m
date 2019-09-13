Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B48DB2854
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 00:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404040AbfIMW0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 18:26:06 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:37588 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390452AbfIMW0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 18:26:06 -0400
Received: by mail-lf1-f65.google.com with SMTP id w67so23255368lff.4
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 15:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=h/ZsG9TiksBOb3vTyStnE+gAds3+4twuqY6gy9FAaAE=;
        b=YwEtvPh3RfN2iuoD5W2xi2CNk0VxkP1PCuuTkkTl9zPZaT0qrG8G4nUhOi+tNHZfIF
         K130ha+U6wOI9Mg+XODQApdYgjHsWjZWJU/6P5qz9KUlwHo5qJp1npPR4Rgmu7STUdhN
         WoAprub/Z0E/Bc9bcU0uZc5mA6ywOcBC580MLuQQYCbDKGxNTFhAA9eFmN6eADWurxzx
         WCrudN7y+hwBV1BSUQZ4Lz3DMY//io+jQ8XoG4F3GvvmxbkGQQQMwyn+2g5+5L9QwBVU
         goJ4E0Te/PwieFGsghB7hRGB1ss/k/+ratmzLqwEj6lSZ5mh1JmtnRI/jHzSk+bmPJaa
         3cjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=h/ZsG9TiksBOb3vTyStnE+gAds3+4twuqY6gy9FAaAE=;
        b=D8VRfvluyryCNisF+zRCpf82TbA74Qud0iih9dGdrEH6+LzFPQl3OJEUau+51vPhvU
         TwiiMPkRDBSFt0oTVIaPvHsYppjFADNvC7oz2ZAatrIpLyMkRU2oqiwSv6WVou00SEq0
         OC/QjCDuvcDIDhwe6PhgNFSYRuS9dPvY9lM08QT/0V+PRVLHuxb6PHF1hUXnJYL96d61
         ojEOqpoEkhMZWWt04EhnjmqpUMj+VCOUBOldw5loF3ZsXmonLgYW4MDxkMgOq4q6BNnm
         4aZKSwNldIwZn1MDN4fS3LRPo1Ruox6wh8zzpQ2XobB5m2oxkVFxnPdBG9MdsXo6l1lw
         pVeA==
X-Gm-Message-State: APjAAAUzVuuJMqo8UFYb5UbsAothQ7SEUro7epCV8xLptOpmOeRIjcCm
        G9zcDzG90cCaoGHCHRJOQSx9gQ==
X-Google-Smtp-Source: APXvYqxm2rfUnpYjwbFLo7ucVJa6f5H/uMO27jTt2YV4xZKTEUCCuOBiM2qiNHGXqu6UwZahn0HGzA==
X-Received: by 2002:ac2:5ec1:: with SMTP id d1mr31448979lfq.83.1568413561225;
        Fri, 13 Sep 2019 15:26:01 -0700 (PDT)
Received: from khorivan (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id r8sm7173068lfm.71.2019.09.13.15.26.00
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 13 Sep 2019 15:26:00 -0700 (PDT)
Date:   Sat, 14 Sep 2019 01:25:58 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Yonghong Song <yhs@fb.com>
Cc:     "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH bpf-next 08/11] samples: bpf: makefile: base progs build
 on makefile.progs
Message-ID: <20190913222552.GE26724@khorivan>
Mail-Followup-To: Yonghong Song <yhs@fb.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" <clang-built-linux@googlegroups.com>
References: <20190910103830.20794-1-ivan.khoronzhuk@linaro.org>
 <20190910103830.20794-9-ivan.khoronzhuk@linaro.org>
 <dd4cd83f-7e35-ad07-8a53-d34c13c074a5@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <dd4cd83f-7e35-ad07-8a53-d34c13c074a5@fb.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 13, 2019 at 09:41:25PM +0000, Yonghong Song wrote:
>
>
>On 9/10/19 11:38 AM, Ivan Khoronzhuk wrote:
>> The main reason for that - HOSTCC and CC have different aims.
>> It was tested for arm cross compilation, based on linaro toolchain,
>> but should work for others.
>>
>> In order to split cross compilation (CC) with host build (HOSTCC),
>> lets base bpf samples on Makefile.progs. It allows to cross-compile
>> samples/bpf progs with CC while auxialry tools running on host built
>> with HOSTCC.
>
>I got a compilation failure with the following error
>
>$ make samples/bpf/
>   ...
>   LD  samples/bpf/hbm
>   CC      samples/bpf/syscall_nrs.s
>gcc: error: -pg and -fomit-frame-pointer are incompatible
>make[2]: *** [samples/bpf/syscall_nrs.s] Error 1
>make[1]: *** [samples/bpf/] Error 2
>make: *** [sub-make] Error 2
>
>Could you take a look?
Yes, sure.
Ilias also observer this, interesting that on my setup for cross and
native build on arm and arm64 doesn't have this error. Now I see log
and know how to proceed, I will fix it, maybe by using another var
for cflags.

Despite of it, just to be sure in order to avoid smth like this at least
for native build, I will add one more patch like:

"
    samples: bpf: makefile: don't use host cflags when cross compile

    While compile natively, the hosts cflags and ldflags are equal to ones
    used from HOSTCFLAGS and HOSTLDFLAGS. When cross compiling it should
    have own, used for target arch. While verification, for arm, arm64 and
    x86_64 the following flags were used alsways:

    -Wall
    -O2
    -fomit-frame-pointer
    -Wmissing-prototypes
    -Wstrict-prototypes

    So, add them as they were verified and used before adding
    Makefile.progs, but anyway limit it only for cross compile options as
    for host can be some configurations when another options can be used,
    So, for host arch samples left all as is, it allows to avoid potential
    option mistmatches for existent environments.
"

+ifdef CROSS_COMPILE
+ccflags-y += -Wall
+ccflags-y += -O2
+ccflags-y += -fomit-frame-pointer
+ccflags-y += -Wmissing-prototypes
+ccflags-y += -Wstrict-prototypes
+else
+ccflags-y += $(KBUILD_HOSTCFLAGS) $(HOST_EXTRACFLAGS)
+PROGS_LDLIBS := $(KBUILD_HOSTLDLIBS)
+endif

>
>>
>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
>> ---
>>   samples/bpf/Makefile | 138 +++++++++++++++++++++++--------------------
>>   1 file changed, 73 insertions(+), 65 deletions(-)
>>
>> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
>> index f5dbf3d0c5f3..625a71f2e9d2 100644
>> --- a/samples/bpf/Makefile
>> +++ b/samples/bpf/Makefile
>> @@ -4,55 +4,53 @@ BPF_SAMPLES_PATH ?= $(abspath $(srctree)/$(src))
>>   TOOLS_PATH := $(BPF_SAMPLES_PATH)/../../tools
>>
>>   # List of programs to build
>> -hostprogs-y := test_lru_dist
>> -hostprogs-y += sock_example
>> -hostprogs-y += fds_example
>> -hostprogs-y += sockex1
>> -hostprogs-y += sockex2
>> -hostprogs-y += sockex3
>> -hostprogs-y += tracex1
>> -hostprogs-y += tracex2
>> -hostprogs-y += tracex3
>> -hostprogs-y += tracex4
>> -hostprogs-y += tracex5
>> -hostprogs-y += tracex6
>> -hostprogs-y += tracex7
>> -hostprogs-y += test_probe_write_user
>> -hostprogs-y += trace_output
>> -hostprogs-y += lathist
>> -hostprogs-y += offwaketime
>> -hostprogs-y += spintest
>> -hostprogs-y += map_perf_test
>> -hostprogs-y += test_overhead
>> -hostprogs-y += test_cgrp2_array_pin
>> -hostprogs-y += test_cgrp2_attach
>> -hostprogs-y += test_cgrp2_sock
>> -hostprogs-y += test_cgrp2_sock2
>> -hostprogs-y += xdp1
>> -hostprogs-y += xdp2
>> -hostprogs-y += xdp_router_ipv4
>> -hostprogs-y += test_current_task_under_cgroup
>> -hostprogs-y += trace_event
>> -hostprogs-y += sampleip
>> -hostprogs-y += tc_l2_redirect
>> -hostprogs-y += lwt_len_hist
>> -hostprogs-y += xdp_tx_iptunnel
>> -hostprogs-y += test_map_in_map
>> -hostprogs-y += per_socket_stats_example
>> -hostprogs-y += xdp_redirect
>> -hostprogs-y += xdp_redirect_map
>> -hostprogs-y += xdp_redirect_cpu
>> -hostprogs-y += xdp_monitor
>> -hostprogs-y += xdp_rxq_info
>> -hostprogs-y += syscall_tp
>> -hostprogs-y += cpustat
>> -hostprogs-y += xdp_adjust_tail
>> -hostprogs-y += xdpsock
>> -hostprogs-y += xdp_fwd
>> -hostprogs-y += task_fd_query
>> -hostprogs-y += xdp_sample_pkts
>> -hostprogs-y += ibumad
>> -hostprogs-y += hbm
>> +progs-y := test_lru_dist
>> +progs-y += sock_example
>> +progs-y += fds_example
>> +progs-y += sockex1
>> +progs-y += sockex2
>> +progs-y += sockex3
>> +progs-y += tracex1
>> +progs-y += tracex2
>> +progs-y += tracex3
>> +progs-y += tracex4
>> +progs-y += tracex5
>> +progs-y += tracex6
>> +progs-y += tracex7
>> +progs-y += test_probe_write_user
>> +progs-y += trace_output
>> +progs-y += lathist
>> +progs-y += offwaketime
>> +progs-y += spintest
>> +progs-y += map_perf_test
>> +progs-y += test_overhead
>> +progs-y += test_cgrp2_array_pin
>> +progs-y += test_cgrp2_attach
>> +progs-y += test_cgrp2_sock
>> +progs-y += test_cgrp2_sock2
>> +progs-y += xdp1
>> +progs-y += xdp2
>> +progs-y += xdp_router_ipv4
>> +progs-y += test_current_task_under_cgroup
>> +progs-y += trace_event
>> +progs-y += sampleip
>> +progs-y += tc_l2_redirect
>> +progs-y += lwt_len_hist
>> +progs-y += xdp_tx_iptunnel
>> +progs-y += test_map_in_map
>> +progs-y += xdp_redirect_map
>> +progs-y += xdp_redirect_cpu
>> +progs-y += xdp_monitor
>> +progs-y += xdp_rxq_info
>> +progs-y += syscall_tp
>> +progs-y += cpustat
>> +progs-y += xdp_adjust_tail
>> +progs-y += xdpsock
>> +progs-y += xdp_fwd
>> +progs-y += task_fd_query
>> +progs-y += xdp_sample_pkts
>> +progs-y += ibumad
>> +progs-y += hbm
>>
>>   # Libbpf dependencies
>>   LIBBPF = $(TOOLS_PATH)/lib/bpf/libbpf.a
>> @@ -111,7 +109,7 @@ ibumad-objs := bpf_load.o ibumad_user.o $(TRACE_HELPERS)
>>   hbm-objs := bpf_load.o hbm.o $(CGROUP_HELPERS)
>>
>>   # Tell kbuild to always build the programs
>> -always := $(hostprogs-y)
>> +always := $(progs-y)
>>   always += sockex1_kern.o
>>   always += sockex2_kern.o
>>   always += sockex3_kern.o
>> @@ -170,21 +168,6 @@ always += ibumad_kern.o
>>   always += hbm_out_kern.o
>>   always += hbm_edt_kern.o
>>
>> -KBUILD_HOSTCFLAGS += -I$(objtree)/usr/include
>> -KBUILD_HOSTCFLAGS += -I$(srctree)/tools/lib/bpf/
>> -KBUILD_HOSTCFLAGS += -I$(srctree)/tools/testing/selftests/bpf/
>> -KBUILD_HOSTCFLAGS += -I$(srctree)/tools/lib/ -I$(srctree)/tools/include
>> -KBUILD_HOSTCFLAGS += -I$(srctree)/tools/perf
>> -
>> -HOSTCFLAGS_bpf_load.o += -Wno-unused-variable
>> -
>> -KBUILD_HOSTLDLIBS		+= $(LIBBPF) -lelf
>> -HOSTLDLIBS_tracex4		+= -lrt
>> -HOSTLDLIBS_trace_output	+= -lrt
>> -HOSTLDLIBS_map_perf_test	+= -lrt
>> -HOSTLDLIBS_test_overhead	+= -lrt
>> -HOSTLDLIBS_xdpsock		+= -pthread
>> -
>>   # Strip all expet -D options needed to handle linux headers
>>   # for arm it's __LINUX_ARM_ARCH__ and potentially others fork vars
>>   D_OPTIONS = $(shell echo "$(KBUILD_CFLAGS) " | sed 's/[[:blank:]]/\n/g' | \
>> @@ -194,6 +177,29 @@ ifeq ($(ARCH), arm)
>>   CLANG_EXTRA_CFLAGS := $(D_OPTIONS)
>>   endif
>>
>> +ccflags-y += -I$(objtree)/usr/include
>> +ccflags-y += -I$(srctree)/tools/lib/bpf/
>> +ccflags-y += -I$(srctree)/tools/testing/selftests/bpf/
>> +ccflags-y += -I$(srctree)/tools/lib/
>> +ccflags-y += -I$(srctree)/tools/include
>> +ccflags-y += -I$(srctree)/tools/perf
>> +ccflags-y += $(D_OPTIONS)
>> +ccflags-y += -Wall
>> +ccflags-y += -fomit-frame-pointer
>> +ccflags-y += -Wmissing-prototypes
>> +ccflags-y += -Wstrict-prototypes
>> +
>> +PROGS_CFLAGS := $(ccflags-y)
>> +
>> +PROGCFLAGS_bpf_load.o += -Wno-unused-variable
>> +
>> +PROGS_LDLIBS			:= $(LIBBPF) -lelf
>> +PROGLDLIBS_tracex4		+= -lrt
>> +PROGLDLIBS_trace_output		+= -lrt
>> +PROGLDLIBS_map_perf_test	+= -lrt
>> +PROGLDLIBS_test_overhead	+= -lrt
>> +PROGLDLIBS_xdpsock		+= -pthread
>> +
>>   # Allows pointing LLC/CLANG to a LLVM backend with bpf support, redefine on cmdline:
>>   #  make samples/bpf/ LLC=~/git/llvm/build/bin/llc CLANG=~/git/llvm/build/bin/clang
>>   LLC ?= llc
>> @@ -284,6 +290,8 @@ $(obj)/hbm_out_kern.o: $(src)/hbm.h $(src)/hbm_kern.h
>>   $(obj)/hbm.o: $(src)/hbm.h
>>   $(obj)/hbm_edt_kern.o: $(src)/hbm.h $(src)/hbm_kern.h
>>
>> +-include $(BPF_SAMPLES_PATH)/Makefile.prog
>> +
>>   # asm/sysreg.h - inline assembly used by it is incompatible with llvm.
>>   # But, there is no easy way to fix it, so just exclude it since it is
>>   # useless for BPF samples.
>>

-- 
Regards,
Ivan Khoronzhuk
