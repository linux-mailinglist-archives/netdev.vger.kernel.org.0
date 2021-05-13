Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67B2837F130
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 04:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbhEMCPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 22:15:18 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:5104 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbhEMCPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 22:15:17 -0400
Received: from dggeml706-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FgZsL4G5SzYgKH;
        Thu, 13 May 2021 10:11:34 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggeml706-chm.china.huawei.com (10.3.17.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 13 May 2021 10:14:02 +0800
Received: from [127.0.0.1] (10.174.177.72) by dggpemm500006.china.huawei.com
 (7.185.36.236) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 13 May
 2021 10:14:02 +0800
Subject: Re: [PATCH 1/1] libbpf: Delete an unneeded bool conversion
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Leon Romanovsky <leon@kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
References: <20210510124315.3854-1-thunder.leizhen@huawei.com>
 <CAEf4BzaADXguVoh0KXxGYhzG68eA1bqfKH1T1SWyPvkE5BHa5g@mail.gmail.com>
 <YJoRd4reWa1viW76@unreal>
 <CAEf4BzaYsjWh_10a4yeSVpAAwC-f=zUNANb10VN2xZ1b5dsY-A@mail.gmail.com>
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <f82343ec-9d67-d033-dd07-813e7d981c4f@huawei.com>
Date:   Thu, 13 May 2021 10:14:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CAEf4BzaYsjWh_10a4yeSVpAAwC-f=zUNANb10VN2xZ1b5dsY-A@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.72]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/5/13 3:02, Andrii Nakryiko wrote:
> On Mon, May 10, 2021 at 10:09 PM Leon Romanovsky <leon@kernel.org> wrote:
>>
>> On Mon, May 10, 2021 at 11:00:29AM -0700, Andrii Nakryiko wrote:
>>> On Mon, May 10, 2021 at 5:43 AM Zhen Lei <thunder.leizhen@huawei.com> wrote:
>>>>
>>>> The result of an expression consisting of a single relational operator is
>>>> already of the bool type and does not need to be evaluated explicitly.
>>>>
>>>> No functional change.
>>>>
>>>> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
>>>> ---
>>>
>>> See [0] and [1].
>>>
>>>   [0] https://lore.kernel.org/bpf/CAEf4BzYgLf5g3oztbA-CJR4gQ7AVKQAGrsHWCOgTtUMUM-Mxfg@mail.gmail.com/
>>>   [1] https://lore.kernel.org/bpf/CAEf4BzZQ6=-h3g1duXFwDLr92z7nE6ajv8Rz_Zv=qx=-F3sRVA@mail.gmail.com/
>>
>> How long do you plan to fight with such patches?
> 
> As long as necessary. There are better ways to contribute to libbpf
> than doing cosmetic changes to the perfectly correct code.

No small stream, no river and sea.

There are no improvements to functionality, but may slightly speed up compilation.
With more such accumulations, it is possible that the compilation of allmodconfig
results in a second-level improvement.

I don't know if you agree, at least I think so.

> 
>>
>> Thanks
>>
>>>
>>>>  tools/lib/bpf/libbpf.c | 2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>>>> index e2a3cf4378140f2..fa02213c451f4d2 100644
>>>> --- a/tools/lib/bpf/libbpf.c
>>>> +++ b/tools/lib/bpf/libbpf.c
>>>> @@ -1504,7 +1504,7 @@ static int set_kcfg_value_tri(struct extern_desc *ext, void *ext_val,
>>>>                                 ext->name, value);
>>>>                         return -EINVAL;
>>>>                 }
>>>> -               *(bool *)ext_val = value == 'y' ? true : false;
>>>> +               *(bool *)ext_val = value == 'y';
>>>>                 break;
>>>>         case KCFG_TRISTATE:
>>>>                 if (value == 'y')
>>>> --
>>>> 2.26.0.106.g9fadedd
>>>>
>>>>
> 
> .
> 

