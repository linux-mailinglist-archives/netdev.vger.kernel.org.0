Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8121A53A3B3
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 13:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352589AbiFALR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 07:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349100AbiFALR5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 07:17:57 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93C5360B93
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 04:17:56 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id c14so1577516pgu.13
        for <netdev@vger.kernel.org>; Wed, 01 Jun 2022 04:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=zgtg5YY4jxLLXJWg7yCH0UX5NIavoSEKqMcQkwk1jy8=;
        b=iVctfEk/aFz/ZdHQcUCWxtMjHH035La+UIBcOyoXJYzVxhVcfdCBsimFa2OeG10qXR
         maNOi9bczGYUXgMLMcEvpBHDNXdTTs2rmLUjAM6ZLLjduXPmK/oUY8Pup6HWDJ5gNed7
         TUN4TBaNb1xWmciQ9QgeJoExJCcLg81GwEhVJpn75RZN36wTHpre3s+P1z2cc3v9y8zn
         6ICqbv33zoLhoCxChTilA+BxiYG24A3BIAMouwbclWo+G4vf/n5Bd8EWR0xyQa9sd64I
         GFe7+1F84SQnvV4lk0zYEvy69QgDlI0+qv3xYFbPYQwVMlkqdJQ/1geI0vCl4v/9Klz7
         X+Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=zgtg5YY4jxLLXJWg7yCH0UX5NIavoSEKqMcQkwk1jy8=;
        b=4ZsoBjUzPnHxCCr8TIQOl95exnhqEPxTlYbYSDooSSmm39iVsDdU9I9+1+uIZyNiOE
         WzmYqpkea6113GfabKbPqFsioqjOYxH2RQ89jIqmDo5ZRLTfNaCpTz0CmjEiSJtI8MLi
         7JwHFinBwMYWWaY/UxyeoGWiCWQEOPCSdzp1lrylMLqDHJDacmbNo9mJAzXOqm2iXX21
         czcpRw6HhvDkre1rx4WMnz8Lv4eyj/zP+cEl7Zm/3mVuI8FbxPKNquur/zMBuFBf3zvg
         taX/3LWLZypeD7UsbMjjh4wQbaefPDvMEhPnLSlxsNhEVrk23AfdDWGojUvrBwMuZXmc
         6/jA==
X-Gm-Message-State: AOAM531sdGGySxCsCWp7tVPlXDap6uOm7TDFp7W6U9wywhE9qGPE747Q
        3zXRVxI4Oraoid6Fs/5bLRwVDw==
X-Google-Smtp-Source: ABdhPJwM490RUsniubXRkmNYnyI+tr1XMJKqnGG0kO6Rq61B0Ohjjj9OD/juAWkW/qlOjvxAu8Ju7g==
X-Received: by 2002:a05:6a00:cd2:b0:518:e103:7cee with SMTP id b18-20020a056a000cd200b00518e1037ceemr37788845pfv.67.1654082276096;
        Wed, 01 Jun 2022 04:17:56 -0700 (PDT)
Received: from [10.71.57.194] ([139.177.225.241])
        by smtp.gmail.com with ESMTPSA id x18-20020aa79ad2000000b0051bbbf14c6csm349622pfp.55.2022.06.01.04.17.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jun 2022 04:17:55 -0700 (PDT)
Message-ID: <041465f0-0fd3-fd39-0dac-8093a1c98c00@bytedance.com>
Date:   Wed, 1 Jun 2022 19:17:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: Re: [PATCH v4 2/2] selftest/bpf/benchs: Add bpf_map benchmark
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Chengming Zhou <zhouchengming@bytedance.com>
References: <20220601084149.13097-1-zhoufeng.zf@bytedance.com>
 <20220601084149.13097-3-zhoufeng.zf@bytedance.com>
 <CAADnVQ+qmvYK_Ttsjgo49Ga7paghicFg_O3=1sYZKbdps4877Q@mail.gmail.com>
From:   Feng Zhou <zhoufeng.zf@bytedance.com>
In-Reply-To: <CAADnVQ+qmvYK_Ttsjgo49Ga7paghicFg_O3=1sYZKbdps4877Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

在 2022/6/1 下午5:53, Alexei Starovoitov 写道:
> On Wed, Jun 1, 2022 at 10:42 AM Feng zhou <zhoufeng.zf@bytedance.com> wrote:
>> +struct {
>> +       __uint(type, BPF_MAP_TYPE_HASH);
>> +       __type(key, u32);
>> +       __type(value, u64);
>> +       __uint(max_entries, MAX_ENTRIES);
>> +} hash_map_bench SEC(".maps");
>> +
>> +u64 __attribute__((__aligned__(256))) percpu_time[256];
> aligned 256 ?
> What is the point?

I didn't think too much about it here, just referenced it from 
tools/testing/selftests/bpf/progs/bloom_filter_bench.c

>
>> +u64 nr_loops;
>> +
>> +static int loop_update_callback(__u32 index, u32 *key)
>> +{
>> +       u64 init_val = 1;
>> +
>> +       bpf_map_update_elem(&hash_map_bench, key, &init_val, BPF_ANY);
>> +       return 0;
>> +}
>> +
>> +SEC("fentry/" SYS_PREFIX "sys_getpgid")
>> +int benchmark(void *ctx)
>> +{
>> +       u32 key = bpf_get_prandom_u32() % MAX_ENTRIES + MAX_ENTRIES;
> What is the point of random ?
> just key = MAX_ENTRIES would be the same, no?
> or key = -1 ?

If all threads on different cpu trigger sys_getpgid and lookup the same 
key, it will cause
"ret = htab_lock_bucket(htab, b, hash, &flags); "
the lock competition here is fierce, and unnecessary overhead is 
introduced,
and I don't want it to interfere with the test.

>
>> +       u32 cpu = bpf_get_smp_processor_id();
>> +       u64 start_time = bpf_ktime_get_ns();
>> +
>> +       bpf_loop(nr_loops, loop_update_callback, &key, 0);
>> +       percpu_time[cpu & 255] = bpf_ktime_get_ns() - start_time;
>> +       return 0;
>> +}
>> --
>> 2.20.1
>>

