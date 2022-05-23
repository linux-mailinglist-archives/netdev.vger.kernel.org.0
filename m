Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 645C2530797
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 04:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349522AbiEWCVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 22:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344273AbiEWCVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 22:21:39 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C882B7EB
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 19:21:37 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id a38so9602100pgl.9
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 19:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=ftAlGkfVN9yFSMHjqy7cpbDkYMyhHDjfXWpCptFDTFo=;
        b=5ZfHbADabs94TwJ/7qwTLt2CQFczUjYovL6BMHmANuny7SYgbvOIrrYRILUThJn9sq
         e5qfNR/l4K6h8svb+auQZgVyvlGygBilUm09/AZMOyp1neoo8ub+9uWPBnDrkD9oLrmn
         yS3LSDeZZ7st/cOadWljRiZF2y/DrWsTb208bbRC2AnJy2IrM9owWxGPLKv4nbZAZHV0
         621c5uRoXUUXfg2ALD7+dYqA7R+RLO8yb4dDZCkxDHPNmEvMzlmY8k/V6xyFDqtSl2YD
         V8396IHfHEulh4iSKKZ+mG9pifb9qGwd49VlcB+22DNVNWqYsJ/litMpU1fxM0PC7RZL
         BaEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ftAlGkfVN9yFSMHjqy7cpbDkYMyhHDjfXWpCptFDTFo=;
        b=jEndcFYq6d7CUQXWXDoPM/AHpEd3JZmlVIbEFTwKzLF0rrBiZQ8692vAlTmWBLZ0yH
         /wzS2WguRpkt5a3J0demzCQ+Gw4li3vM2/GOhlx7RWObZPabXwNNo4kTjQZ2pfNrCUt8
         eC84eXM6/CVTmd5Xxf9B/RZtgzed0JHvS+ii12d/oZR9RLsrJkaZY9FJ1532Z5WmSMTI
         gudnqzy9qnz7bo58cP52nwJgjawcS42VfEyRuhIKGZjxv7DY6FB2+2UuoKjfYqYaSaCA
         7KbkUWISXBonXHAjtR+l4rl0RC6cNMBUeZIQ9f2+DTv/9V+ql3W7/rcXHqHUEewinpyj
         7wXg==
X-Gm-Message-State: AOAM5338RjrrTD3ZK7164+RxIoPfP2g9I6a4+t9TzZKPBmhjbwCjCl4S
        T/HRLfgck1yK88MmONX+PKNO1Q==
X-Google-Smtp-Source: ABdhPJxRaFpMXHUmAwAQvJOURtMeJdgu+9o6mOi0Xa1VO1LPiywHr+NUZm86xDqsmpq+lh4gOGMk3A==
X-Received: by 2002:a63:553:0:b0:3f5:f32a:7c54 with SMTP id 80-20020a630553000000b003f5f32a7c54mr17959211pgf.138.1653272497211;
        Sun, 22 May 2022 19:21:37 -0700 (PDT)
Received: from [10.71.57.194] ([139.177.225.241])
        by smtp.gmail.com with ESMTPSA id y12-20020aa7854c000000b0050dc7628195sm5846585pfn.111.2022.05.22.19.21.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 May 2022 19:21:36 -0700 (PDT)
Message-ID: <ed3b33cb-7ff5-4f20-4657-4c8c7a9ba45f@bytedance.com>
Date:   Mon, 23 May 2022 10:21:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [External] Re: [PATCH bpf-next v2] selftests/bpf: fix some bugs
 in map_lookup_percpu_elem testcase
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joanne Koong <joannekoong@fb.com>,
        Geliang Tang <geliang.tang@suse.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        duanxiongchun@bytedance.com,
        Muchun Song <songmuchun@bytedance.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        zhouchengming@bytedance.com, Yosry Ahmed <yosryahmed@google.com>
References: <20220518025053.20492-1-zhoufeng.zf@bytedance.com>
 <cd5bb286-506b-5cdb-f721-0464a58659db@fb.com>
 <CAEf4BzaE_WJBQ6xxMy8VmJy3OsPyCCjyRKi_F-CdPLwVVp+7Ng@mail.gmail.com>
From:   Feng Zhou <zhoufeng.zf@bytedance.com>
In-Reply-To: <CAEf4BzaE_WJBQ6xxMy8VmJy3OsPyCCjyRKi_F-CdPLwVVp+7Ng@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

在 2022/5/21 上午6:00, Andrii Nakryiko 写道:
> On Wed, May 18, 2022 at 8:44 AM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>> On 5/17/22 7:50 PM, Feng zhou wrote:
>>> From: Feng Zhou <zhoufeng.zf@bytedance.com>
>>>
>>> comments from Andrii Nakryiko, details in here:
>>> https://lore.kernel.org/lkml/20220511093854.411-1-zhoufeng.zf@bytedance.com/T/
>>>
>>> use /* */ instead of //
>>> use libbpf_num_possible_cpus() instead of sysconf(_SC_NPROCESSORS_ONLN)
>>> use 8 bytes for value size
>>> fix memory leak
>>> use ASSERT_EQ instead of ASSERT_OK
>>> add bpf_loop to fetch values on each possible CPU
>>>
>>> Fixes: ed7c13776e20c74486b0939a3c1de984c5efb6aa ("selftests/bpf: add test case for bpf_map_lookup_percpu_elem")
>>> Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
>> Acked-by: Yonghong Song <yhs@fb.com>
>
> I've fixed remaining formatting issues and added my_pid check to avoid
> accidental interference with other tests/processes. Applied to
> bpf-next, thanks.

Ok, Thanks.

