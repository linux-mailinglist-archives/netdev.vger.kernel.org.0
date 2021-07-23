Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CEF43D3F1B
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 19:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231811AbhGWRE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 13:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231777AbhGWRE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 13:04:28 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1FA4C061757
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 10:45:01 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id y8so3156725wrt.10
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 10:45:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MHsr1AcjnBRoKC9p4VaeLXl6X6BB2o9O0KPoR23uJXI=;
        b=f2+hr251a8pSwPCgr4O5RshIAei5r6DN/hrzWzEdkoTUCoaUzDZaeiB+XuhXPwhpQc
         62zyJobVCaGC38hilodh3/i8S2dm8c4jGYVmA3RVz/61Jf13lSW/N0H9MBbeYdtgWWSL
         DcjoGFPPnZ9JuAt2qIGE+CgwPGwKmvG0/LrEiwbfNC0qZv7k7I8p1REvX497Rel8OYZt
         m98ypMiDWMJBflPOPzGzkP8igw6NCGvHq1AmlkAiEiYrnlkuDapBDfTSt/ta6Cz/vX9i
         1td/mjXWkafmQmNXGbhPzRMz2CLL7k/sYV2lj5oTLt3gDGFig0xY5UQf69bybMBUmvse
         R9uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MHsr1AcjnBRoKC9p4VaeLXl6X6BB2o9O0KPoR23uJXI=;
        b=NzHLouoNFxW8040hZ8jGTxAfsDENWfjpYGCCfkCV0I71GWliWBTz2CpeXWH4f46G76
         qeLR/MvCEbQVOg+Zl2o8iun8QtH60GQ8opLVT4kP8je9iMcWNV5q16fK7BIy7BODGkaE
         RtRUr0h70X8YsxVybtLhkYn86zqcC6xbF8CZGxZ1f9mT7mIM8mdD+/fszSeDOho6gg6B
         mZ4QEDACjarNX+7XdMf0jb8e3uCuwXyp6jOeCseaHqfksGBiOXAnP0VP8e/6Jyjukw38
         ajm4TY//0qNQWTwkrvbHf3y0mXwvE4sr1T+Yr8gVVbg5Dq2d7fWsf+m9KqNoEqKjOR+h
         f9ow==
X-Gm-Message-State: AOAM531K7GEumy7KRDOSau2DqPzac61Rc2oCZuweYHtcUD/zhnlC8oto
        Vr1cukEQJTg2vk7bcFrrBR/myA==
X-Google-Smtp-Source: ABdhPJwAtesOopb37ndouBoLUqAxzqoSIBSYW90SBmasZTCqm0wo/yRARypXK1PcPHFG39aVG+f8PA==
X-Received: by 2002:a5d:63d1:: with SMTP id c17mr2460161wrw.328.1627062300583;
        Fri, 23 Jul 2021 10:45:00 -0700 (PDT)
Received: from [192.168.1.8] ([149.86.71.195])
        by smtp.gmail.com with ESMTPSA id p11sm1847374wre.83.2021.07.23.10.44.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jul 2021 10:44:59 -0700 (PDT)
Subject: Re: [PATCH bpf-next v2 2/5] libbpf: rename btf__get_from_id() as
 btf__load_from_kernel_by_id()
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
References: <20210721153808.6902-1-quentin@isovalent.com>
 <20210721153808.6902-3-quentin@isovalent.com>
 <CAEf4BzZqEZLt0_qgmniY-hqgEg7q0ur0Z5U0r8KFTwSz=2StSg@mail.gmail.com>
 <88d3cd19-5985-ad73-5f23-4f6f7d1b1be2@isovalent.com>
 <CAEf4BzY4jVKN=3CdaLU1WOekGbT915dweNx0R4KMrW8U7E20cw@mail.gmail.com>
 <004ebf5f-bac1-117b-e833-2f5ef6df0b4b@isovalent.com>
 <CAEf4BzZAW_n=tgCNvsDY83FRL37DY_wODfhp+XNr6DA7C3A1qw@mail.gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <552493f9-179d-9a02-d5e7-5f78b56a18c3@isovalent.com>
Date:   Fri, 23 Jul 2021 18:44:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CAEf4BzZAW_n=tgCNvsDY83FRL37DY_wODfhp+XNr6DA7C3A1qw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2021-07-23 10:18 UTC-0700 ~ Andrii Nakryiko <andrii.nakryiko@gmail.com>
> On Fri, Jul 23, 2021 at 9:13 AM Quentin Monnet <quentin@isovalent.com> wrote:
>>
>> 2021-07-23 08:54 UTC-0700 ~ Andrii Nakryiko <andrii.nakryiko@gmail.com>
>>> On Fri, Jul 23, 2021 at 2:31 AM Quentin Monnet <quentin@isovalent.com> wrote:
>>>>
>>>> 2021-07-22 17:39 UTC-0700 ~ Andrii Nakryiko <andrii.nakryiko@gmail.com>
>>>>> On Wed, Jul 21, 2021 at 8:38 AM Quentin Monnet <quentin@isovalent.com> wrote:
>>>>>>
>>>>>> Rename function btf__get_from_id() as btf__load_from_kernel_by_id() to
>>>>>> better indicate what the function does. Change the new function so that,
>>>>>> instead of requiring a pointer to the pointer to update and returning
>>>>>> with an error code, it takes a single argument (the id of the BTF
>>>>>> object) and returns the corresponding pointer. This is more in line with
>>>>>> the existing constructors.
>>>>>>
>>>>>> The other tools calling the deprecated btf__get_from_id() function will
>>>>>> be updated in a future commit.
>>>>>>
>>>>>> References:
>>>>>>
>>>>>> - https://github.com/libbpf/libbpf/issues/278
>>>>>> - https://github.com/libbpf/libbpf/wiki/Libbpf:-the-road-to-v1.0#btfh-apis
>>>>>>
>>
>>>>>> diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
>>>>>> index 7e0de560490e..6654bdee7ad7 100644
>>>>>> --- a/tools/lib/bpf/btf.c
>>>>>> +++ b/tools/lib/bpf/btf.c
>>>>>> @@ -1383,21 +1383,30 @@ struct btf *btf_get_from_fd(int btf_fd, struct btf *base_btf)
>>>>>>         return btf;
>>>>>>  }
>>>>>>
>>>>>> +struct btf *btf__load_from_kernel_by_id(__u32 id)
>>>>>> +{
>>>>>> +       struct btf *btf;
>>>>>> +       int btf_fd;
>>>>>> +
>>>>>> +       btf_fd = bpf_btf_get_fd_by_id(id);
>>>>>> +       if (btf_fd < 0)
>>>>>> +               return ERR_PTR(-errno);
>>>>>
>>>>> please use libbpf_err_ptr() for consistency, see
>>>>> bpf_object__open_mem() for an example
>>>>
>>>> I can do that, but I'll need to uncouple btf__get_from_id() from the new
>>>> function. If it calls btf__load_from_kernel_by_id() and
>>>> LIBBPF_STRICT_CLEAN_PTRS is set, it would change its return value.
>>>
>>> No it won't, if libbpf_get_error() is used right after the API call.
>>
>> But we cannot be sure that users currently call libbpf_get_error() after
>> btf__get_from_id()? I'm fine if we assume they do (users currently
>> selecting the CLEAN_PTRS are probably savvy enough to call it I guess),
>> I'll update as you suggest.
> 
> I think you are still confused.

OK, I think I was.
I'm not arguing against the contract, but I thought your suggestion
would introduce a change in btf__get_from_id()'s behaviour. Reading
again through the code and your explanations, there should be no change
indeed, I just misunderstood in the first place. Apologies, and thanks
for your patience :). I'll prepare v3 soon.

Quentin
