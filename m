Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9021F53B227
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 05:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233599AbiFBD3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 23:29:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233578AbiFBD3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 23:29:23 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57C6E267CE4
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 20:29:17 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id y196so3646416pfb.6
        for <netdev@vger.kernel.org>; Wed, 01 Jun 2022 20:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=d7/X5D/XlWDgxC+lr9ny4gEaWSqGcdWBVlXv9V2nJSc=;
        b=4zgwd/soJ4OlZOpXRWMVKCorWv2P8U3su0NGdknMw1o/lf/a30yo2AcvaHVixK4JcF
         HEf5qgd8iNm+Iu7TGuu2W1/UAlo7NIcftpk4VWQyeAjUF4m3RkS1x0+QylTvUiPn+dut
         0gAvKdf3riJQgRXO4pz/G7rmweSBnWdvYJmsAYhq+wR364cs2wiiVzu7zzRMQYV3G109
         HHJiCxvOCctMT0SRMlJaiGxpSd4U8IgIT8sP9fNkHkuXAPdeo3jrj/I2q0IP+EjNieEG
         b22fM9Zpj5PBalBM5lVDOBwBkL7xz4P42CIx8Q1qgw1Xd2Kker2XfNkgN2SGUIn+IV3W
         30rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=d7/X5D/XlWDgxC+lr9ny4gEaWSqGcdWBVlXv9V2nJSc=;
        b=JioG7KsIccof20ZDp1aoZtc8xk73pSXf9Md/pSK4caMFBgLb7L8d8qdZ4Ut3G2hl27
         uCWarnmgrbcTBw7VjqlzLvCITFMWtaJJ+IUNb3S6NVnzd4BycUcvc5udArlq+BpKFeaf
         e/dyu3EPYZQBCivXNqFJhnVkS/tS/kYUMmREEI4BQ53gK9xOeTOp84mUn2ktUnvYuGQf
         4E6lukc+bpCwqt4F+6l+OCvOliQ+inHErUUSMmI5tH5UXd8EzwfZ2iOaC8EXslRt/wuW
         xOE68jj7pJLVi1G8GTbOMxBLaG3HnQ2cmjXUA+yZZxU+pSVwIUhubKTH3mp3azVM3ECY
         rFeg==
X-Gm-Message-State: AOAM5326WfDr8iVskcyOl1zlq2UJAjOXlKlz0ueFDgwGHWli4eEc91k7
        5hOLORdBnVwu6DyvmD1MmfOFIA==
X-Google-Smtp-Source: ABdhPJz5XXjx1kduDqvTabORmcqulZrn95ibw4rCM4QDXk4FGV+QJnfefUP2GHpZKCvFFGv71aOTSQ==
X-Received: by 2002:a05:6a00:889:b0:510:91e6:6463 with SMTP id q9-20020a056a00088900b0051091e66463mr2840480pfj.58.1654140556716;
        Wed, 01 Jun 2022 20:29:16 -0700 (PDT)
Received: from [10.71.57.194] ([139.177.225.241])
        by smtp.gmail.com with ESMTPSA id v4-20020a1709028d8400b00163cdf1a200sm2239756plo.38.2022.06.01.20.29.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jun 2022 20:29:16 -0700 (PDT)
Message-ID: <6181d77a-66ed-76ff-35a4-b24134bc67fb@bytedance.com>
Date:   Thu, 2 Jun 2022 11:29:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: Re: Re: [PATCH v4 2/2] selftest/bpf/benchs: Add bpf_map benchmark
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
 <041465f0-0fd3-fd39-0dac-8093a1c98c00@bytedance.com>
 <CAADnVQ+cCoH=DAoyLGtJ5HvdNVgFBgTW=wCHs1wvFQuwyhcWOw@mail.gmail.com>
From:   Feng Zhou <zhoufeng.zf@bytedance.com>
In-Reply-To: <CAADnVQ+cCoH=DAoyLGtJ5HvdNVgFBgTW=wCHs1wvFQuwyhcWOw@mail.gmail.com>
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

在 2022/6/1 下午7:37, Alexei Starovoitov 写道:
> On Wed, Jun 1, 2022 at 1:17 PM Feng Zhou <zhoufeng.zf@bytedance.com> wrote:
>> 在 2022/6/1 下午5:53, Alexei Starovoitov 写道:
>>> On Wed, Jun 1, 2022 at 10:42 AM Feng zhou <zhoufeng.zf@bytedance.com> wrote:
>>>> +struct {
>>>> +       __uint(type, BPF_MAP_TYPE_HASH);
>>>> +       __type(key, u32);
>>>> +       __type(value, u64);
>>>> +       __uint(max_entries, MAX_ENTRIES);
>>>> +} hash_map_bench SEC(".maps");
>>>> +
>>>> +u64 __attribute__((__aligned__(256))) percpu_time[256];
>>> aligned 256 ?
>>> What is the point?
>> I didn't think too much about it here, just referenced it from
>> tools/testing/selftests/bpf/progs/bloom_filter_bench.c
>>
>>>> +u64 nr_loops;
>>>> +
>>>> +static int loop_update_callback(__u32 index, u32 *key)
>>>> +{
>>>> +       u64 init_val = 1;
>>>> +
>>>> +       bpf_map_update_elem(&hash_map_bench, key, &init_val, BPF_ANY);
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +SEC("fentry/" SYS_PREFIX "sys_getpgid")
>>>> +int benchmark(void *ctx)
>>>> +{
>>>> +       u32 key = bpf_get_prandom_u32() % MAX_ENTRIES + MAX_ENTRIES;
>>> What is the point of random ?
>>> just key = MAX_ENTRIES would be the same, no?
>>> or key = -1 ?
>> If all threads on different cpu trigger sys_getpgid and lookup the same
>> key, it will cause
>> "ret = htab_lock_bucket(htab, b, hash, &flags);"
>> the lock competition here is fierce, and unnecessary overhead is
>> introduced,
>> and I don't want it to interfere with the test.
> I see.
> but using random leaves it to chance.
> Use cpu+max_entries then?

Ok, will do. Thanks.


