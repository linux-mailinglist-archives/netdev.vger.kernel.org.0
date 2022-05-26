Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A015953489B
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 04:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345897AbiEZCJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 22:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232421AbiEZCI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 22:08:59 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B5CB19F87
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 19:08:59 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id fw21-20020a17090b129500b001df9f62edd6so5151880pjb.0
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 19:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=R7rKNvHXsGzLgjMUdkYaFVed5E2JRJcJJNqZfVZ+5rk=;
        b=co6cy7kfyLhyWRoqI9xLrDZWZ4RkKwnrUf88l8B6e1qN1ihtUyVs25s3wWNnfPY0kM
         +mxYx5A8uRu/udu4clhRH0E4qEVWGY98p7D4oJoSshLcEbPjvb08+mXZYFmkYwLBZU0o
         9ayYBUL7m3SIvvbu4eJZ+EC7Mp9R4qocfaHcfpDwplTFDxIOUWGCecuHw3A4ICWncNVQ
         0oEefde8JiCMO6/hHIFWCfjVMdqmHrWAF3lz4IlTHicLwIy/Q1himKOYQOtuVr8nNlS6
         utygQAbCTcWDyekohJJeT8axFIOuiSzq6x/lqJyA3UIol+TFIj9quxF0Yb/U2Gc/RWgy
         R54w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=R7rKNvHXsGzLgjMUdkYaFVed5E2JRJcJJNqZfVZ+5rk=;
        b=bX0OiVzhZcvQIOf5Cdl5YIZUuRFKvb7wjSRmECQhEhURyFS9lxZ5L1vFMTULlLx1/e
         t+r0l0sefcdmQ4/lvZ+U/TPut2gekflrS0/IkmXG3279p9f8urXY3ng6znrMdLIUv8FO
         icPC5kwSIn1ZrzcYZ7tOMi24Hno7RRJFUmp0ho6Y4RbfGxQ2j5rxy3ON46ZVHNZVyVzb
         Zzyf7NzHNKEjb68fvBk7Yk9dVNHwARE3+I5n2SqACM9iCHPOeya2JI9Adpy8A5ZhIQBa
         zdaU4QkYtdfiTr+fTYcyvW5DgWMC5SUWg7NuOjp+ayKXqENuEKmVbbOQSA+TTQCGcONS
         ztkg==
X-Gm-Message-State: AOAM531/2z3qXzenaZBxTeQaEdm1JeiVZdRxRm5wZJE46T9QR4GCz+l0
        rwQ809+SygRVa4rIaRul5ClyeQ==
X-Google-Smtp-Source: ABdhPJwGanAZG3Fj5Jtt06ObKLk1KKtCz0LEo3zEuRu6eg3wdFoGtq3zxEAPPb46K4UWT2YaWLQFeQ==
X-Received: by 2002:a17:902:f605:b0:14f:5d75:4fb0 with SMTP id n5-20020a170902f60500b0014f5d754fb0mr35495209plg.101.1653530938546;
        Wed, 25 May 2022 19:08:58 -0700 (PDT)
Received: from [10.71.57.194] ([139.177.225.225])
        by smtp.gmail.com with ESMTPSA id g1-20020a056a001a0100b0051868677e6dsm82610pfv.51.2022.05.25.19.08.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 May 2022 19:08:58 -0700 (PDT)
Message-ID: <1f291e35-808a-92f2-f93a-1bc5c8c3e44d@bytedance.com>
Date:   Thu, 26 May 2022 10:08:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [External] Re: [PATCH v2 2/2] selftest/bpf/benchs: Add bpf_map
 benchmark
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        duanxiongchun@bytedance.com,
        Muchun Song <songmuchun@bytedance.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        zhouchengming@bytedance.com
References: <20220524075306.32306-1-zhoufeng.zf@bytedance.com>
 <20220524075306.32306-3-zhoufeng.zf@bytedance.com>
 <CAEf4BzbPrfFe-3TGf=jJxrp9DT6Z1JaEDhWCd3wTYOPsihUmkA@mail.gmail.com>
From:   Feng Zhou <zhoufeng.zf@bytedance.com>
In-Reply-To: <CAEf4BzbPrfFe-3TGf=jJxrp9DT6Z1JaEDhWCd3wTYOPsihUmkA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

在 2022/5/25 上午7:29, Andrii Nakryiko 写道:
> On Tue, May 24, 2022 at 12:53 AM Feng zhou <zhoufeng.zf@bytedance.com> wrote:
>> From: Feng Zhou <zhoufeng.zf@bytedance.com>
>>
>> Add benchmark for hash_map to reproduce the worst case
>> that non-stop update when map's free is zero.
>>
>> Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
>> ---
>>   tools/testing/selftests/bpf/Makefile          |  4 +-
>>   tools/testing/selftests/bpf/bench.c           |  2 +
>>   .../selftests/bpf/benchs/bench_bpf_map.c      | 78 +++++++++++++++++++
>>   .../selftests/bpf/benchs/run_bench_bpf_map.sh | 10 +++
>>   .../selftests/bpf/progs/bpf_map_bench.c       | 27 +++++++
>>   5 files changed, 120 insertions(+), 1 deletion(-)
>>   create mode 100644 tools/testing/selftests/bpf/benchs/bench_bpf_map.c
>>   create mode 100755 tools/testing/selftests/bpf/benchs/run_bench_bpf_map.sh
>>   create mode 100644 tools/testing/selftests/bpf/progs/bpf_map_bench.c
>>
> [...]
>
>> +static void setup(void)
>> +{
>> +       struct bpf_link *link;
>> +       int map_fd, i, max_entries;
>> +
>> +       setup_libbpf();
>> +
>> +       ctx.skel = bpf_map_bench__open_and_load();
>> +       if (!ctx.skel) {
>> +               fprintf(stderr, "failed to open skeleton\n");
>> +               exit(1);
>> +       }
>> +
>> +       link = bpf_program__attach(ctx.skel->progs.benchmark);
>> +       if (!link) {
>> +               fprintf(stderr, "failed to attach program!\n");
>> +               exit(1);
>> +       }
>> +
>> +       //fill hash_map
> don't use C++ comments

Ok, will do. Thanks.

>
>> +       map_fd = bpf_map__fd(ctx.skel->maps.hash_map_bench);
>> +       max_entries = bpf_map__max_entries(ctx.skel->maps.hash_map_bench);
>> +       for (i = 0; i < max_entries; i++)
>> +               bpf_map_update_elem(map_fd, &i, &i, BPF_ANY);
>> +}
>> +
>> +const struct bench bench_bpf_map = {
>> +       .name = "bpf-map",
> this is too generic name, it's testing one particular scenario, so
> call this out in the name. bpf-hashmap-full-update or something (same
> for all the relevant function and file names)
>

Ok, will do. Thanks.

>> +       .validate = validate,
>> +       .setup = setup,
>> +       .producer_thread = producer,
>> +       .consumer_thread = consumer,
>> +       .measure = measure,
>> +       .report_progress = ops_report_progress,
>> +       .report_final = ops_report_final,
>> +};
>> diff --git a/tools/testing/selftests/bpf/benchs/run_bench_bpf_map.sh b/tools/testing/selftests/bpf/benchs/run_bench_bpf_map.sh
>> new file mode 100755
>> index 000000000000..d7cc969e4f85
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/benchs/run_bench_bpf_map.sh
>> @@ -0,0 +1,10 @@
>> +#!/bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +
>> +source ./benchs/run_common.sh
>> +
>> +set -eufo pipefail
>> +
>> +nr_threads=`expr $(cat /proc/cpuinfo | grep "processor"| wc -l) - 1`
>> +summary=$($RUN_BENCH -p $nr_threads bpf-map)
>> +printf "$summary"
>> diff --git a/tools/testing/selftests/bpf/progs/bpf_map_bench.c b/tools/testing/selftests/bpf/progs/bpf_map_bench.c
>> new file mode 100644
>> index 000000000000..655366e6e0f4
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/progs/bpf_map_bench.c
>> @@ -0,0 +1,27 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* Copyright (c) 2022 Bytedance */
>> +
>> +#include "vmlinux.h"
>> +#include <bpf/bpf_helpers.h>
>> +#include "bpf_misc.h"
>> +
>> +char _license[] SEC("license") = "GPL";
>> +
>> +#define MAX_ENTRIES 1000
>> +
>> +struct {
>> +       __uint(type, BPF_MAP_TYPE_HASH);
>> +       __type(key, u32);
>> +       __type(value, u64);
>> +       __uint(max_entries, MAX_ENTRIES);
>> +} hash_map_bench SEC(".maps");
>> +
>> +SEC("fentry/" SYS_PREFIX "sys_getpgid")
>> +int benchmark(void *ctx)
>> +{
>> +       u32 key = bpf_get_prandom_u32();
>> +       u64 init_val = 1;
>> +
>> +       bpf_map_update_elem(&hash_map_bench, &key, &init_val, BPF_ANY);
>> +       return 0;
>> +}
>> --
>> 2.20.1
>>

