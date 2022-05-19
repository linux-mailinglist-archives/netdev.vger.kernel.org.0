Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F91152CD17
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 09:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233945AbiESHbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 03:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234501AbiESHbn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 03:31:43 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E526EC40
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 00:31:38 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id a23-20020a17090acb9700b001df4e9f4870so4465099pju.1
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 00:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=ArdF743BZoqLFAyXjQk+7RdvsBaiXgNZpZL36JdMpVg=;
        b=DTvtdeKgRe67G7EM5fDtunxlx5QDX6RJ0KixOqk+xQS+QKDYZYtlOhGglZAQ+r6O5j
         rLJcaC4kxERUnin32BPyux8DBTQfBHWXGfUU7xYSiEup5hHPuHN/txD5u5uOwBslOy4l
         MrfBG1ZjfcSda8Ut+o7xy/CulLZMJ9Hhx+7sgl7PxgTaa71+RO7TbuFjW2RkVFk12GD7
         RFMZVxYs5XL8kq6UAgBk/GkRp5jBHj7wfTakbn1MS6ABUdMAdZMlSuUtCIgBkeh7pgWb
         01G1E/JSO31wZ2QL4foYYzppRq2OdeSMMwx7laOkx6kGtzlFFr8i7X8vP3E1JCQ+P8XZ
         oRkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ArdF743BZoqLFAyXjQk+7RdvsBaiXgNZpZL36JdMpVg=;
        b=MUBhDfRF6S2DARiIYmWX4hArvON8gMklEtbTtsYs28rIpj14vEQZWn/tXxG+NEDgEo
         QJxXAuYxB/1cu16SmSdmgr1NXggQ7SCbMDU1ozqi5XwDswiRMhmNEampSb03RLp7BbQA
         Vqf4s/QNVtuH1yr42ksnDJ+0wFEoZl2odkHcP01nJ7/0Bwh7XbSKBk+9BRFn6IqBrGpR
         iC0NiRH8YYaNr5f1YWWaf/JYX/SNyunjOB/D0bjFyfTj8zeMUA2WmgABXEBOuiRMhZNM
         7H27awOQkkQ860YIiLBibL4eEPh02XaBAu47adybtCAkR6EaCpsi6RgvpiEXH4NDYULM
         PwUg==
X-Gm-Message-State: AOAM532oxn9Vx68Z16NnMSFggaaUI9faAoFBABgcqGuTeoIaWa2BH+fo
        PAv2xBo/X1yRpZ7kG+EP9a0iVQ==
X-Google-Smtp-Source: ABdhPJzxrKB1/kR9Vev93w/bW8HjKfjBRysabAI2TMofvhcpo6g8SjVBAT+ron7MvWu5Ar6TVfIU8g==
X-Received: by 2002:a17:90a:db95:b0:1df:37e7:6a28 with SMTP id h21-20020a17090adb9500b001df37e76a28mr4380345pjv.204.1652945498470;
        Thu, 19 May 2022 00:31:38 -0700 (PDT)
Received: from [10.71.57.194] ([139.177.225.241])
        by smtp.gmail.com with ESMTPSA id mq7-20020a17090b380700b001cd4989ff5esm2842065pjb.37.2022.05.19.00.31.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 May 2022 00:31:38 -0700 (PDT)
Message-ID: <da615af0-8dfb-9487-8b41-61e48d68c1d7@bytedance.com>
Date:   Thu, 19 May 2022 15:31:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [External] Re: [PATCH bpf-next] selftests/bpf: fix some bugs in
 map_lookup_percpu_elem testcase
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joanne Koong <joannekoong@fb.com>,
        Geliang Tang <geliang.tang@suse.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        duanxiongchun@bytedance.com,
        Muchun Song <songmuchun@bytedance.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        zhouchengming@bytedance.com, Yosry Ahmed <yosryahmed@google.com>
References: <20220516022453.68420-1-zhoufeng.zf@bytedance.com>
 <CAEf4BzZ0eRh4ufQnc69B=6WQt_Oy3DNPL-TM-rsUW1KX--SBvQ@mail.gmail.com>
 <196f6ae9-f899-16c8-a5d3-a1c771fa9900@bytedance.com>
 <CAEf4BzabT5xdscH8jgTbAVhj415k=1MziKmAXTi6yfeo1DTBRw@mail.gmail.com>
From:   Feng Zhou <zhoufeng.zf@bytedance.com>
In-Reply-To: <CAEf4BzabT5xdscH8jgTbAVhj415k=1MziKmAXTi6yfeo1DTBRw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

在 2022/5/19 下午12:38, Andrii Nakryiko 写道:
> On Wed, May 18, 2022 at 8:27 PM Feng Zhou <zhoufeng.zf@bytedance.com> wrote:
>> 在 2022/5/19 上午8:17, Andrii Nakryiko 写道:
>>> On Sun, May 15, 2022 at 7:25 PM Feng zhou <zhoufeng.zf@bytedance.com> wrote:
>>>> From: Feng Zhou <zhoufeng.zf@bytedance.com>
>>>>
>>>> comments from Andrii Nakryiko, details in here:
>>>> https://lore.kernel.org/lkml/20220511093854.411-1-zhoufeng.zf@bytedance.com/T/
>>>>
>>>> use /* */ instead of //
>>>> use libbpf_num_possible_cpus() instead of sysconf(_SC_NPROCESSORS_ONLN)
>>>> use 8 bytes for value size
>>>> fix memory leak
>>>> use ASSERT_EQ instead of ASSERT_OK
>>>> add bpf_loop to fetch values on each possible CPU
>>>>
>>>> Fixes: ed7c13776e20c74486b0939a3c1de984c5efb6aa ("selftests/bpf: add test case for bpf_map_lookup_percpu_elem")
>>>> Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
>>>> ---
>>>>    .../bpf/prog_tests/map_lookup_percpu_elem.c   | 49 +++++++++------
>>>>    .../bpf/progs/test_map_lookup_percpu_elem.c   | 61 ++++++++++++-------
>>>>    2 files changed, 70 insertions(+), 40 deletions(-)
>>>>
>>>> diff --git a/tools/testing/selftests/bpf/prog_tests/map_lookup_percpu_elem.c b/tools/testing/selftests/bpf/prog_tests/map_lookup_percpu_elem.c
>>>> index 58b24c2112b0..89ca170f1c25 100644
>>>> --- a/tools/testing/selftests/bpf/prog_tests/map_lookup_percpu_elem.c
>>>> +++ b/tools/testing/selftests/bpf/prog_tests/map_lookup_percpu_elem.c
>>>> @@ -1,30 +1,39 @@
>>>> -// SPDX-License-Identifier: GPL-2.0
>>>> -// Copyright (c) 2022 Bytedance
>>>> +/* SPDX-License-Identifier: GPL-2.0 */
>>> heh, so for SPDX license comment the rule is to use // in .c files :)
>>> so keep SPDX as // and all others as /* */
>> will do. Thanks.
>>
>>>> +/* Copyright (c) 2022 Bytedance */
>>>>
>>>>    #include <test_progs.h>
>>>>
>>>>    #include "test_map_lookup_percpu_elem.skel.h"
>>>>
>>>> -#define TEST_VALUE  1
>>>> -
>>>>    void test_map_lookup_percpu_elem(void)
>>>>    {
>>>>           struct test_map_lookup_percpu_elem *skel;
>>>> -       int key = 0, ret;
>>>> -       int nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
>>>> -       int *buf;
>>>> +       __u64 key = 0, sum;
>>>> +       int ret, i;
>>>> +       int nr_cpus = libbpf_num_possible_cpus();
>>>> +       __u64 *buf;
>>>>
>>>> -       buf = (int *)malloc(nr_cpus*sizeof(int));
>>>> +       buf = (__u64 *)malloc(nr_cpus*sizeof(__u64));
>>> no need for casting
>> casting means no '(__u64 *)'?
>> just like this:
>> 'buf = malloc(nr_cpus * sizeof(__u64));'
>>
> yes, in C you don't need to explicitly cast void * to other pointer types

Ok, Thanks.

>
>>>>           if (!ASSERT_OK_PTR(buf, "malloc"))
>>>>                   return;
>>>> -       memset(buf, 0, nr_cpus*sizeof(int));
>>>> -       buf[0] = TEST_VALUE;
>>>>
>>>> -       skel = test_map_lookup_percpu_elem__open_and_load();
>>>> -       if (!ASSERT_OK_PTR(skel, "test_map_lookup_percpu_elem__open_and_load"))
>>>> -               return;
>>>> +       for (i=0; i<nr_cpus; i++)
>>> spaces between operators
>> will do. Thanks.
>>
>>>> +               buf[i] = i;
>>>> +       sum = (nr_cpus-1)*nr_cpus/2;
>>> same, please follow kernel code style
>> will do. Thanks.
>>
>>>> +
>>>> +       skel = test_map_lookup_percpu_elem__open();
>>>> +       if (!ASSERT_OK_PTR(skel, "test_map_lookup_percpu_elem__open"))
>>>> +               goto exit;
>>>> +
>>> nit: keep it simple, init skel to NULL and use single cleanup goto
>>> label that will destroy skel unconditionally (it deals with NULL just
>>> fine)
>> will do. Thanks.
>>
>>>> +       skel->rodata->nr_cpus = nr_cpus;
>>>> +
>>>> +       ret = test_map_lookup_percpu_elem__load(skel);
>>>> +       if (!ASSERT_OK(ret, "test_map_lookup_percpu_elem__load"))
>>>> +               goto cleanup;
>>>> +
>>>>           ret = test_map_lookup_percpu_elem__attach(skel);
>>>> -       ASSERT_OK(ret, "test_map_lookup_percpu_elem__attach");
>>>> +       if (!ASSERT_OK(ret, "test_map_lookup_percpu_elem__attach"))
>>>> +               goto cleanup;
>>>>
>>>>           ret = bpf_map_update_elem(bpf_map__fd(skel->maps.percpu_array_map), &key, buf, 0);
>>>>           ASSERT_OK(ret, "percpu_array_map update");
>>> [...]
>>

