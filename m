Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5F88449ED5
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 23:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240819AbhKHW7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 17:59:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238608AbhKHW7f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 17:59:35 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E707C061570;
        Mon,  8 Nov 2021 14:56:50 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id 188so4187002pgb.7;
        Mon, 08 Nov 2021 14:56:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yLjtf1aShycEFgJcV+pl71m6jWJoRoxnaVNiORqeY9k=;
        b=oKsdcojyVYKTdaInPj4LP/6r8Qj1unTEmIBn9Nw2PAAu6GAQhoptMskGRcec2T6nqM
         R12gwetbPo+nBf+c1Ca5olKZr4lGpsDQ6SRWJGsZ9KyZr1sCzOY2Na1QLW5swytQL9Il
         QPLu/RT+4Ax/epvfAD+snRylr9GtG++1XUhvtb79B/u0BWUP1Fk/zFFlVVK8SF7hzMjp
         1naeZ6LW6YilDyU4Hfnh7zoILDNw+z19UxUFF8EtucYMf8EHU/TW/ax8SA07dSge9sBc
         ayJCmn3W9QrCV2N1gj3bqKVbe4EWYgB76+mZI/aFV+9+GudJCyqyucjZZzLs001BR/NB
         jlbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yLjtf1aShycEFgJcV+pl71m6jWJoRoxnaVNiORqeY9k=;
        b=jShLi2+AR0Ukd6nUiJUgNrpsCoz2VoBPbH+4c0PnRQN1v1iwxBzmRDgpv7FrAMNMU7
         Hlux0lK/0Umf4R0myTd3F6WJl0F+69Mn+v08myRV3Twy4+di6JNgVW36DAasOzA4q8hl
         N7F1r+myUX8DqeM49k0gsKt25BuW70Tta1yO8WCATNMA1QhXv/oRl1mYrfrzpnkqXMwW
         q5qXj38IZcZ4vhBFTkQGRFRi7c0IWJdgIS5OFbXGRHfmbNgxA4bZ0Q9Khd14tMsZzRIC
         7e5sjy4NX95/eBPD35cRGpi+B+mEl1pLo7RakgP/hHwnf3Kc8iu1lL9gBYjm2Q1JzkY2
         eq9w==
X-Gm-Message-State: AOAM530Jnts6lEJH77Af0KvHukHNy96vFI8WG7AQO+1h0/phbJu3PaRQ
        GM8ocoYjuCKWeYGEi5BYLl4=
X-Google-Smtp-Source: ABdhPJxAAsK1zJEIiHNnajN+WvLXbl23cfWfyQHqSKgr0O0cV/R+IYLflSRMEXsEai/VLCV3imPNLw==
X-Received: by 2002:a63:88c2:: with SMTP id l185mr2329669pgd.168.1636412209990;
        Mon, 08 Nov 2021 14:56:49 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id f8sm340279pjq.29.2021.11.08.14.56.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Nov 2021 14:56:49 -0800 (PST)
Subject: Re: [PATCH v5 bpf-next 1/2] bpf: introduce helper bpf_find_vma
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "hengqi.chen@gmail.com" <hengqi.chen@gmail.com>,
        Yonghong Song <yhs@fb.com>
References: <20211105232330.1936330-1-songliubraving@fb.com>
 <20211105232330.1936330-2-songliubraving@fb.com>
 <0ee9be06-6552-d8e3-74c7-7a96a46c8888@gmail.com>
 <099A4F8E-0BB7-409B-8E40-8538AAC04DC5@fb.com>
 <048f6048-b5ff-4ab7-29dc-0cbae919d655@gmail.com>
 <c824244f-996e-fb0c-3090-2e217681c6a1@gmail.com>
Message-ID: <23f914ba-36ea-7270-f0a7-9f2e4b396535@gmail.com>
Date:   Mon, 8 Nov 2021 14:56:40 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <c824244f-996e-fb0c-3090-2e217681c6a1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/8/21 2:43 PM, Eric Dumazet wrote:
> 
> 
> On 11/8/21 2:27 PM, Eric Dumazet wrote:
>>
>>
>> On 11/8/21 1:59 PM, Song Liu wrote:
>>>
>>>
>>>> On Nov 8, 2021, at 10:36 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>>>
>>>>
>>>>
>>>> On 11/5/21 4:23 PM, Song Liu wrote:
>>>>> In some profiler use cases, it is necessary to map an address to the
>>>>> backing file, e.g., a shared library. bpf_find_vma helper provides a
>>>>> flexible way to achieve this. bpf_find_vma maps an address of a task to
>>>>> the vma (vm_area_struct) for this address, and feed the vma to an callback
>>>>> BPF function. The callback function is necessary here, as we need to
>>>>> ensure mmap_sem is unlocked.
>>>>>
>>>>> It is necessary to lock mmap_sem for find_vma. To lock and unlock mmap_sem
>>>>> safely when irqs are disable, we use the same mechanism as stackmap with
>>>>> build_id. Specifically, when irqs are disabled, the unlocked is postponed
>>>>> in an irq_work. Refactor stackmap.c so that the irq_work is shared among
>>>>> bpf_find_vma and stackmap helpers.
>>>>>
>>>>> Acked-by: Yonghong Song <yhs@fb.com>
>>>>> Tested-by: Hengqi Chen <hengqi.chen@gmail.com>
>>>>> Signed-off-by: Song Liu <songliubraving@fb.com>
>>>>> ---
>>>>
>>>> ...
>>>>
>>>>> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
>>>>> index dbc3ad07e21b6..cdb0fba656006 100644
>>>>> --- a/kernel/bpf/btf.c
>>>>> +++ b/kernel/bpf/btf.c
>>>>> @@ -6342,7 +6342,10 @@ const struct bpf_func_proto bpf_btf_find_by_name_kind_proto = {
>>>>> 	.arg4_type	= ARG_ANYTHING,
>>>>> };
>>>>>
>>>>> -BTF_ID_LIST_GLOBAL_SINGLE(btf_task_struct_ids, struct, task_struct)
>>>>> +BTF_ID_LIST_GLOBAL(btf_task_struct_ids)
>>>>> +BTF_ID(struct, task_struct)
>>>>> +BTF_ID(struct, file)
>>>>> +BTF_ID(struct, vm_area_struct)
>>>>
>>>> $ nm -v vmlinux |grep -A3 btf_task_struct_ids
>>>> ffffffff82adfd9c R btf_task_struct_ids
>>>> ffffffff82adfda0 r __BTF_ID__struct__file__715
>>>> ffffffff82adfda4 r __BTF_ID__struct__vm_area_struct__716
>>>> ffffffff82adfda8 r bpf_skb_output_btf_ids
>>>>
>>>> KASAN thinks btf_task_struct_ids has 4 bytes only.
>>>
>>> I have KASAN enabled, but couldn't repro this issue. I think
>>> btf_task_struct_ids looks correct:
>>>
>>> nm -v vmlinux | grep -A3 -B1 btf_task_struct_ids
>>> ffffffff83cf8260 r __BTF_ID__struct__task_struct__1026
>>> ffffffff83cf8260 R btf_task_struct_ids
>>> ffffffff83cf8264 r __BTF_ID__struct__file__1027
>>> ffffffff83cf8268 r __BTF_ID__struct__vm_area_struct__1028
>>> ffffffff83cf826c r bpf_skb_output_btf_ids
>>>
>>> Did I miss something?
>>>
>>> Thanks,
>>> Song
>>>
>>
>> I will release the syzbot bug, so that you can use its .config
>>
>> Basically, we have
>>
>> u32 btf_task_struct_ids[1];
> 
> That is, if  
> 
> # CONFIG_DEBUG_INFO_BTF is not set
> 

This is how btf_sock_ids gets defined :

#ifdef CONFIG_DEBUG_INFO_BTF
BTF_ID_LIST_GLOBAL(btf_sock_ids)
#define BTF_SOCK_TYPE(name, type) BTF_ID(struct, type)
BTF_SOCK_TYPE_xxx
#undef BTF_SOCK_TYPE
#else
u32 btf_sock_ids[MAX_BTF_SOCK_TYPE];
#endif


Perhaps do the same for btf_task_struct_ids ?

Thanks.

