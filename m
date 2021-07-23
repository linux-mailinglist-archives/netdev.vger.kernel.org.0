Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2AF3D3D47
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 18:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbhGWPdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 11:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbhGWPdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 11:33:11 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36BA8C061575
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 09:13:41 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id h24-20020a1ccc180000b029022e0571d1a0so1924246wmb.5
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 09:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hoZ8tObBp01dBlHMcbfOWYxKB4odH22+CIykTPPnENQ=;
        b=J1EVlPz7Fbs+tr6D7Bu9paBuIvBA55KDO7bhpWtzZn/+TtgkirDr8Dh9CUoYewrg77
         YSqVD3MMgvmn9/I+3ksCGRCg+frKAixxPcgxcCSll3aWSQL/dYjMMqMxhaZhgNlfM1fd
         BDN2jpBufgquKGH62LesNPZF0d6e5f/AiLHDNQJHDt2zpiAXNyVfpEW8I6C93y9dD/uk
         RYKtT3rGCaRS+27I53g25N4nDfs8hfWVCph150HSuxU1+o7hiIfWNhOzvFtSO+yOTEE5
         +2y5lhUS7Hj4TmaKOCNRuzYtJt9a1gMQa+58VhAX+SOd8q7lVig46s8y3lFCO52Z8kaa
         XadQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hoZ8tObBp01dBlHMcbfOWYxKB4odH22+CIykTPPnENQ=;
        b=IJW3wKthY5Mry+5bt43MgwSUAresJFrp08xBHgCq8OdY4960HVLFhrq6cJJGkJ9LUp
         eS2gKIBpmt5fxyQEeYVXmqLXmXPFA0iPofo2OVzfhzO5pYIkjTA6GKSN3GDVmP/z8fq3
         UHEMR/ZWj41pJlvTxeFXorZDnx0JEbnFbCAddb6q/bQ3t/pddmipNSABX0S+5OEn5nKN
         qazAdjKjhH0JG1BeDqEY/PvFXKZIHX1vYalX6wptrEe8kOYlj7837aiDyPMPDh85ewGE
         QnlTTnH0VGhFMRtM0FtbnOC95VEDN2inoDrgEYwgbBEN9cnwtsbJfPgzcVY8oCAfSmLs
         N3+Q==
X-Gm-Message-State: AOAM531Vqvx4ZAsLII8YYw/df3FYXsXiV8C5bhnSUgz2nHvNzILi4szG
        4oPboz77EK2vOxbHjnowxvlYgg==
X-Google-Smtp-Source: ABdhPJyapXtCvaG+gNhfztmSLFl0sLgbip8zM+sYYAy2EJ6kAIUPeom1MKENc/5rejsHV/DF9solvg==
X-Received: by 2002:a05:600c:2107:: with SMTP id u7mr12679048wml.52.1627056819848;
        Fri, 23 Jul 2021 09:13:39 -0700 (PDT)
Received: from [192.168.1.8] ([149.86.74.37])
        by smtp.gmail.com with ESMTPSA id p11sm1626075wre.83.2021.07.23.09.13.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jul 2021 09:13:39 -0700 (PDT)
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
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <004ebf5f-bac1-117b-e833-2f5ef6df0b4b@isovalent.com>
Date:   Fri, 23 Jul 2021 17:13:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CAEf4BzY4jVKN=3CdaLU1WOekGbT915dweNx0R4KMrW8U7E20cw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2021-07-23 08:54 UTC-0700 ~ Andrii Nakryiko <andrii.nakryiko@gmail.com>
> On Fri, Jul 23, 2021 at 2:31 AM Quentin Monnet <quentin@isovalent.com> wrote:
>>
>> 2021-07-22 17:39 UTC-0700 ~ Andrii Nakryiko <andrii.nakryiko@gmail.com>
>>> On Wed, Jul 21, 2021 at 8:38 AM Quentin Monnet <quentin@isovalent.com> wrote:
>>>>
>>>> Rename function btf__get_from_id() as btf__load_from_kernel_by_id() to
>>>> better indicate what the function does. Change the new function so that,
>>>> instead of requiring a pointer to the pointer to update and returning
>>>> with an error code, it takes a single argument (the id of the BTF
>>>> object) and returns the corresponding pointer. This is more in line with
>>>> the existing constructors.
>>>>
>>>> The other tools calling the deprecated btf__get_from_id() function will
>>>> be updated in a future commit.
>>>>
>>>> References:
>>>>
>>>> - https://github.com/libbpf/libbpf/issues/278
>>>> - https://github.com/libbpf/libbpf/wiki/Libbpf:-the-road-to-v1.0#btfh-apis
>>>>

>>>> diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
>>>> index 7e0de560490e..6654bdee7ad7 100644
>>>> --- a/tools/lib/bpf/btf.c
>>>> +++ b/tools/lib/bpf/btf.c
>>>> @@ -1383,21 +1383,30 @@ struct btf *btf_get_from_fd(int btf_fd, struct btf *base_btf)
>>>>         return btf;
>>>>  }
>>>>
>>>> +struct btf *btf__load_from_kernel_by_id(__u32 id)
>>>> +{
>>>> +       struct btf *btf;
>>>> +       int btf_fd;
>>>> +
>>>> +       btf_fd = bpf_btf_get_fd_by_id(id);
>>>> +       if (btf_fd < 0)
>>>> +               return ERR_PTR(-errno);
>>>
>>> please use libbpf_err_ptr() for consistency, see
>>> bpf_object__open_mem() for an example
>>
>> I can do that, but I'll need to uncouple btf__get_from_id() from the new
>> function. If it calls btf__load_from_kernel_by_id() and
>> LIBBPF_STRICT_CLEAN_PTRS is set, it would change its return value.
> 
> No it won't, if libbpf_get_error() is used right after the API call.

But we cannot be sure that users currently call libbpf_get_error() after
btf__get_from_id()? I'm fine if we assume they do (users currently
selecting the CLEAN_PTRS are probably savvy enough to call it I guess),
I'll update as you suggest.

> With CLEAN_PTRS the result pointer is NULL but actual error is passed
> through errno. libbpf_get_error() knows about this and extracts error
> from errno if passed NULL pointer. With returning ERR_PTR(-errno) from
> btf__load_from_kernel_by_id() you are breaking CLEAN_PTRS guarantees.
OK right, this makes sense to me for btf__load_from_kernel_by_id().
