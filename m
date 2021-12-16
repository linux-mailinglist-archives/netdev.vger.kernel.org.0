Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96FA8477CD2
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 20:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241104AbhLPTvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 14:51:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241097AbhLPTvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 14:51:12 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07AC4C06173E
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 11:51:12 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id n104-20020a9d2071000000b005799790cf0bso208369ota.5
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 11:51:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TSyw+5NE57grmXEvJooaI5xtGgoQMSQLuPJVw3Fnbz0=;
        b=Tpyf7pdfSIzTQJ5ddM2RQ/4ufoSTi693T/ZvMrPXpEsrX+dek4KH9zcyfyqnda/mpV
         oK8+bQs73J8jGLrrMPKmsDYnHYixb1TrYcFvGpRuIqaon/M3jsb2/0QY1AmETvx7rJBu
         65BPv3eRq6Z+Nfi0Wbajl/LtknopCWZwg07gM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TSyw+5NE57grmXEvJooaI5xtGgoQMSQLuPJVw3Fnbz0=;
        b=tGjOuGUzatztklcFZHCF1F3ojLauw3/+amCLhCBUCoJ7lvP4SCsxCt5pC3RuvwBogX
         glWrqyisCwLovNxxEBlvgMz++SbqTSscUvlRKEh49IGEL/UjF9SBmuqAlyeE2ysrYKFF
         QP+PREsWt4tp4ZURejYpVoygn9xstHkfp33gYxXDyoNS9CT18jG9UMabQsP/DmUMM8t/
         9YRBUuHfAQBhjsVGy7dlyQhUKN7BCYRpmxq4ZhIW628cSAdCrXKURerxP8wTiwwVT6jY
         sXS4cXhfwPrNoIxdk1Qc3jX0g+1d5spnrUexdQBZR3tS6bLlvkH1uNjLjM7iElRTQJmP
         TNsA==
X-Gm-Message-State: AOAM533mIoG6a2Nzyjf448I+6Ds7Lk6bHML+fHaKcMVti1WFi9NUrLeQ
        dKslo/0cxFqLkXAa6X59SIndPw==
X-Google-Smtp-Source: ABdhPJzkPk7UAaVmdoip7gq4iwOC5yGm+pzaLqDeNMEUG5lPY0sMchwnWFV03x5CAd8cbbCPLNJxXg==
X-Received: by 2002:a9d:798d:: with SMTP id h13mr13577040otm.132.1639684270667;
        Thu, 16 Dec 2021 11:51:10 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id 52sm534911oth.52.2021.12.16.11.51.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Dec 2021 11:51:10 -0800 (PST)
Subject: Re: [PATCH] selftests/bpf: remove ARRAY_SIZE defines from tests
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211210173433.13247-1-skhan@linuxfoundation.org>
 <CAADnVQ+Fnn-NuGoLq1ZYbHM=kR_W01GB1DCFOnQTHhgfDOrnaA@mail.gmail.com>
 <d367441f-bba0-30eb-787a-89b0c06a65dd@linuxfoundation.org>
 <CAEf4BzahZhCEroeMWNTu-kGsuFCDaNCvbkiFW7ci0EUOWTwmqQ@mail.gmail.com>
 <d3c1b7f4-5363-c23e-4837-5eaf07f63ebc@linuxfoundation.org>
 <CAEf4BzYKnoD_x7fZ4Fwp0Kg-wT6HMXOG0CMRSG4U+qQ0R27yzQ@mail.gmail.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <53490dba-b7fd-a3f8-6574-5736c83aa90d@linuxfoundation.org>
Date:   Thu, 16 Dec 2021 12:51:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CAEf4BzYKnoD_x7fZ4Fwp0Kg-wT6HMXOG0CMRSG4U+qQ0R27yzQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/16/21 12:30 PM, Andrii Nakryiko wrote:
> On Thu, Dec 16, 2021 at 6:42 AM Shuah Khan <skhan@linuxfoundation.org> wrote:
>>
>> On 12/15/21 9:04 PM, Andrii Nakryiko wrote:
>>> On Tue, Dec 14, 2021 at 12:27 PM Shuah Khan <skhan@linuxfoundation.org> wrote:
>>>>
>>>> On 12/11/21 6:53 PM, Alexei Starovoitov wrote:
>>>>> On Fri, Dec 10, 2021 at 9:34 AM Shuah Khan <skhan@linuxfoundation.org> wrote:
>>>>>>
>>>>>> ARRAY_SIZE is defined in multiple test files. Remove the definitions
>>>>>> and include header file for the define instead.
>>>>>>
>>>>>> Remove ARRAY_SIZE define and add include bpf_util.h to bring in the
>>>>>> define.
>>>>>>
>>>>>> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
>>>>>> ---
>>>>>>     tools/testing/selftests/bpf/progs/netif_receive_skb.c | 5 +----
>>>>>>     tools/testing/selftests/bpf/progs/profiler.inc.h      | 5 +----
>>>>>>     tools/testing/selftests/bpf/progs/test_sysctl_loop1.c | 5 +----
>>>>>>     tools/testing/selftests/bpf/progs/test_sysctl_loop2.c | 4 +---
>>>>>>     tools/testing/selftests/bpf/progs/test_sysctl_prog.c  | 5 +----
>>>>>>     5 files changed, 5 insertions(+), 19 deletions(-)
>>>>>>
>>>>>> diff --git a/tools/testing/selftests/bpf/progs/netif_receive_skb.c b/tools/testing/selftests/bpf/progs/netif_receive_skb.c
>>>>>> index 1d8918dfbd3f..7a5ebd330689 100644
>>>>>> --- a/tools/testing/selftests/bpf/progs/netif_receive_skb.c
>>>>>> +++ b/tools/testing/selftests/bpf/progs/netif_receive_skb.c
>>>>>> @@ -5,6 +5,7 @@
>>>>>>     #include <bpf/bpf_helpers.h>
>>>>>>     #include <bpf/bpf_tracing.h>
>>>>>>     #include <bpf/bpf_core_read.h>
>>>>>> +#include <bpf/bpf_util.h>
>>>>>
>>>>> It doesn't look like you've built it.
>>>>>
>>>>> progs/test_sysctl_prog.c:11:10: fatal error: 'bpf/bpf_util.h' file not found
>>>>> #include <bpf/bpf_util.h>
>>>>>             ^~~~~~~~~~~~~~~~
>>>>>      CLNG-BPF [test_maps] socket_cookie_prog.o
>>>>> progs/test_sysctl_loop2.c:11:10: fatal error: 'bpf/bpf_util.h' file not found
>>>>> #include <bpf/bpf_util.h>
>>>>>             ^~~~~~~~~~~~~~~~
>>>>> 1 error generated.
>>>>> In file included from progs/profiler2.c:6:
>>>>> progs/profiler.inc.h:7:10: fatal error: 'bpf/bpf_util.h' file not found
>>>>> #include <bpf/bpf_util.h>
>>>>>             ^~~~~~~~~~~~~~~~
>>>>>
>>>>
>>>> Sorry about that. I built it - I think something is wrong in my env. Build
>>>> fails complaining about not finding vmlinux - I overlooked that the failure
>>>> happened before it got to progs.
>>>>
>>>> Error: failed to load BTF from .../vmlinux: No such file or directory
>>>
>>> Please make sure that you build vmlinux before you build selftests,
>>> BPF selftests use vmlinux to generate vmlinux.h with all kernel types
>>> (among other things). So please also make sure that all the setting in
>>> selftests/bpf/config were used in your Kconfig.
>>>
>>>>
>>
>> The problem in my env. is that I don't have CONFIG_DEBUG_INFO_BTF in
>> my config and then don't have the dwarves and llvm-strip on my system.
>> Pains of upgrading.
>>
>> I am all set now. On the other hand the vmlinux.h is a mess. It has
>> no guards for defines and including stdio.h and this generated
>> vmlinux.h causes all sorts of problems.
> 
> It does have
> 
> #ifndef __VMLINUX_H__
> #define __VMLINUX_H__
> 
> Are we talking about the same vmlinux.h here?
> 

Yes we are. The guard it has works when vmlinux.h is included
twice. It defines a lot of common defines which are the problem.
Unless you add guards around each one of them, including vmlinux.h
is problematic if you also include other standard includes.

You can try to include bpf_util.h for example from one of the
test in progs to see the problem.

thanks,
-- Shuah
