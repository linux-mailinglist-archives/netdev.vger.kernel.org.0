Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC9DB242C0C
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 17:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbgHLPRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 11:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726447AbgHLPRB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 11:17:01 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94AB4C061383
        for <netdev@vger.kernel.org>; Wed, 12 Aug 2020 08:17:00 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id x15so1235651plr.11
        for <netdev@vger.kernel.org>; Wed, 12 Aug 2020 08:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DqMLAttHHKthLdaUAJc4ZTcC4RJVQ+5nxIQWYtpPYm8=;
        b=HlU89hMqmd2jy/KE6+7lx+H5e9jtxihF9pW+M+EdgEnNcrl7jBo3FvcqdUorHRi+9M
         nnP6GSl86UwR2BZwkIA3qcsjlUZjOhYuAC4mGoqoJk4P37l7YrGBpwx8Pqv8GQ9D/ZxB
         HvJnhYfib3grTSBnfsiuNN2ui6ocZs5ga2QqtCluHdwjTB6ADfsRkOCOdxZM1pTiV6c2
         Sns2yiaGlCrHfs21tPI0U5E2f1mMZTGTB+MNEzwH6Ei4/t4YLB/YAGdt+jDIf219GzAM
         pLyPRryFFkBN8z6T/YU4YS9Eaz1wZBg4LuyLT7KxdguGvZCMJU9k61X2CAhdlOgSegNp
         nz/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DqMLAttHHKthLdaUAJc4ZTcC4RJVQ+5nxIQWYtpPYm8=;
        b=MHp1WdogJ/f4qMhwsWTGLNj/9TBc3OYAR/AoVthspfZl/lIfMGKPjNTpjqWAIrUROZ
         kFkqVnQY6CUWO5eBU2+aVfkoKt85gqsBVvjc2T2UZyoZ2iswy6TegH3hGesldJqsMgno
         0u7qvG6EyscB10Qxs+r7euAnKJTu+IzDH1KvYZUgsJMmx0tzCoome0xDbmIj0F5HDdBW
         pYl9fREbiTHyVkFVXE6dis2NBfJKLvQM5xiLUEsmviod25BhT248dyqSD2S29xXG6VNr
         AmaevB1EfmmhlBckxOBe+2zv1mEYny77cgEvMM60sAzVeoWOxNeuK/lYDbuP+qHxpTEV
         m0Zg==
X-Gm-Message-State: AOAM5310LDbJa2Ocy6Tv8l+XSxDUsyBZ8Mxea+UCSwZYjmrOMfyqMA2J
        0OFjklSN1okliV3cc3ay0I+HvKAU
X-Google-Smtp-Source: ABdhPJwmVgQxgNXcGkKABu32u0yDGOAu1Aa8tvuz+gmo7K3mdLzYIBMIixtmy6EETuNfWKgtzlfWcQ==
X-Received: by 2002:a17:902:221:: with SMTP id 30mr5898136plc.222.1597245419534;
        Wed, 12 Aug 2020 08:16:59 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id e4sm2812297pfd.204.2020.08.12.08.16.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Aug 2020 08:16:58 -0700 (PDT)
Subject: Re: Flaw in "random32: update the net random state on interrupt and
 activity"
To:     sedat.dilek@gmail.com, Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org
References: <CA+icZUXzW3RTyr5M_r-YYBB_k7Yw_JnurwPV5o0xGNpn7QPgRw@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <6d9a041f-858e-2426-67a9-4e15acd06a95@gmail.com>
Date:   Wed, 12 Aug 2020 08:16:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CA+icZUXzW3RTyr5M_r-YYBB_k7Yw_JnurwPV5o0xGNpn7QPgRw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/11/20 11:03 PM, Sedat Dilek wrote:
> [ CC netdev ]
> [ Please CC me I am not subscribed to this mailing-list ]
> 
> Hi Eric,
> 
> I have added your diffs from [0] and have some troubles to display the
> prandom_32 trace-events (I mostly followed [1]):
> 
> I did:
> 
> echo prandom_u32 >> /sys/kernel/debug/tracing/set_event
> echo traceon > /sys/kernel/debug/tracing/events/random/prandom_u32/trigger
> echo 1 > /sys/kernel/debug/tracing/events/enable
> 
> cat /sys/kernel/debug/tracing/set_event | grep prandom
> random:prandom_u32
> cat /sys/kernel/debug/tracing/events/random/prandom_u32/trigger
> traceon:unlimited
> cat /sys/kernel/debug/tracing/events/enable
> X
> 
> Following [2] and [3] I wanted to use perf:
> 
> # /home/dileks/bin/perf list | grep prandom
>   random:prandom_u32                                 [Tracepoint event]
> 
> Following the example in [4]:
> 
> # /home/dileks/bin/perf probe --add tcp_sendmsg
> # /home/dileks/bin/perf record -e probe:tcp_sendmsg -a -g -- sleep 10
> # /home/dileks/bin/perf report --stdio
> 
> That gives me a report.
> 
> Adapting:
> 
> # /home/dileks/bin/perf probe --add tcp_conn_request
> 
> # /home/dileks/bin/perf list | grep probe:
>   probe:tcp_conn_request                             [Tracepoint event]
>   probe:tcp_sendmsg                                  [Tracepoint event]
> 
> # home/dileks/bin/perf record -e probe:tcp_conn_request -a -g -- sleep 10
> 
> # /home/dileks/bin/perf report --stdio
> Error:
> The perf.data data has no samples!
> # To display the perf.data header info, please use
> --header/--header-only options.
> #
> 
> # /home/dileks/bin/perf report --stdio --header-only
> # ========
> # captured on    : Wed Aug 12 07:39:42 2020
> # header version : 1
> # data offset    : 440
> # data size      : 2123144
> # feat offset    : 2123584
> # hostname : iniza
> # os release : 5.8.1-2-amd64-llvm11-ias
> # perf version : 5.8.1
> # arch : x86_64
> # nrcpus online : 4
> # nrcpus avail : 4
> # cpudesc : Intel(R) Core(TM) i5-2467M CPU @ 1.60GHz
> # cpuid : GenuineIntel,6,42,7
> # total memory : 8046012 kB
> # cmdline : /home/dileks/bin/perf record -e probe:tcp_conn_request -a
> -g -- sleep 10
> # event : name = probe:tcp_conn_request, , id = { 304, 305, 306, 307
> }, type = 2, size = 120, config = 0x866, { sample_period, sample_freq
> } = 1, sample_type = IP|TID|TIME|CALLCHAIN|CPU|PERIO>
> # event : name = dummy:HG, , id = { 308, 309, 310, 311 }, type = 1,
> size = 120, config = 0x9, { sample_period, sample_freq } = 4000,
> sample_type = IP|TID|TIME|CALLCHAIN|CPU|PERIOD|IDENTIFIER,>
> # CPU_TOPOLOGY info available, use -I to display
> # NUMA_TOPOLOGY info available, use -I to display
> # pmu mappings: software = 1, power = 14, uprobe = 7, cpu = 4,
> cstate_core = 12, breakpoint = 5, uncore_cbox_0 = 9, tracepoint = 2,
> cstate_pkg = 13, uncore_arb = 11, kprobe = 6, i915 = 15, ms>
> # CACHE info available, use -I to display
> # time of first sample : 0.000000
> # time of last sample : 0.000000
> # sample duration :      0.000 ms
> # MEM_TOPOLOGY info available, use -I to display
> # bpf_prog_info 3: bpf_prog_6deef7357e7b4530 addr 0xffffffffc01d7834 size 66
> # bpf_prog_info 4: bpf_prog_6deef7357e7b4530 addr 0xffffffffc01df7e8 size 66
> # bpf_prog_info 5: bpf_prog_6deef7357e7b4530 addr 0xffffffffc041ca18 size 66
> # bpf_prog_info 6: bpf_prog_6deef7357e7b4530 addr 0xffffffffc041eb58 size 66
> # bpf_prog_info 7: bpf_prog_6deef7357e7b4530 addr 0xffffffffc1061dc0 size 66
> # bpf_prog_info 8: bpf_prog_6deef7357e7b4530 addr 0xffffffffc1063388 size 66
> # bpf_prog_info 12: bpf_prog_6deef7357e7b4530 addr 0xffffffffc129c244 size 66
> # bpf_prog_info 13: bpf_prog_6deef7357e7b4530 addr 0xffffffffc129e8c0 size 66
> # cpu pmu capabilities: branches=16, max_precise=2, pmu_name=sandybridge
> # missing features: BRANCH_STACK GROUP_DESC AUXTRACE STAT CLOCKID
> DIR_FORMAT COMPRESSED
> # ========
> #
> 
> In dmesg I see:
> 
> [Wed Aug 12 07:30:52 2020] Scheduler tracepoints stat_sleep,
> stat_iowait, stat_blocked and stat_runtime require the kernel
> parameter schedstats=enable or kernel.sched_schedstats=1
> 
> CONFIG_SCHEDSTATS=y is set.
> 
> # echo 1 > /proc/sys/kernel/sched_schedstats
> # cat /proc/sys/kernel/sched_schedstats
> 1
> 
> Still seeing:
> # /home/dileks/bin/perf report --stdio
> Error:
> The perf.data data has no samples!
> # To display the perf.data header info, please use
> --header/--header-only options.
> #
> 
> Do I miss to set some required Kconfigs?
> I have attached my latest kernel-config file.
> 
> So I need a helping hand how to trace prandom_u32 events in general?


perf record -a -g -e random:prandom_u32  sleep 5

Then something like

perf report --no-children

or "perf script"

> 
> How to add it as a kernel-boot-parameter (see [4])?
> 
> Any help appreciated and thanks in advance.
> 
> Thanks.
> 
> Regards,
> - Sedat -
> 
> [0] https://marc.info/?l=linux-netdev&m=159716173516111&w=2
> [1] https://www.kernel.org/doc/html/v5.8/trace/events.html
> [2] http://www.brendangregg.com/perf.html
> [3] http://www.brendangregg.com/perf.html#DynamicTracing
> [4] https://www.kernel.org/doc/html/v5.8/trace/events.html#boot-option
> 
