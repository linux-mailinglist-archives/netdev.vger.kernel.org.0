Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31C44477D6F
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 21:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241404AbhLPUWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 15:22:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241385AbhLPUWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 15:22:42 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD04CC06173F
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 12:22:41 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id p65so39526iof.3
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 12:22:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0T7rNo/e5FufAn3aYgt2vkQlK/clnujdeot+jLE4neo=;
        b=R3fD55lzr+nGW9I4G2Q7OmwsZ+A3tOZS3nNWyUt4DDRohhTcHOGwBZaR5+dTtgB3RP
         JwiI2x2Ov6TOBcYmmAw9/s/ZNAS2ksyLrtY3/nTQ+e9lYRC7RAqLDfknh1LBKzrqWLCk
         MGHm6d3KlBOq9+K7js8SEmq+LXxwGyzPSEPVU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0T7rNo/e5FufAn3aYgt2vkQlK/clnujdeot+jLE4neo=;
        b=5G3QmXdMqPmwWGR0E+rHez3Uk2aw95uobc0uHDA0NWQuqUTtoskADzS56Ydo/aTptt
         0fuj8ZVuh9ET3TrMEde8oX4j03HzbK1HV1XAlbs3KUulE0ouFTcQkWuF4VAHIXnyu32r
         0QCj5msxTwWzTRmgYNwlUpWlCC83rZqPSz2S08OHxuI2Lv5bWx0abL98jHJLSeSic2/f
         cWfwihzJIUQOBk7x6kLcIcqgzv9p7rEwt7Az9IYp0TegkmiQ49jrzzdBSaIEYsXB00xF
         fiDo+iN3JKs8v3NghfW3FlJBm/6mbTInNHsPIATjGnVKR9Jg66jzK/Pav9s/5155mOXH
         m3LA==
X-Gm-Message-State: AOAM530n0u5dbbj/Ra72q5TKWyKPP7giJ1lyg6mck+NccSlMnM7okXhv
        YJRIgghInjKOWgfL5CofR/L2bA==
X-Google-Smtp-Source: ABdhPJyYLL5VRNmwQRNtyvoUJxEz7Sp5J+zYsWkhlRjtgxziInjf10CL8GKwN06nI/UybFNDuc2VmA==
X-Received: by 2002:a05:6638:248d:: with SMTP id x13mr10930244jat.249.1639686161219;
        Thu, 16 Dec 2021 12:22:41 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id u4sm3388717ilv.66.2021.12.16.12.22.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Dec 2021 12:22:40 -0800 (PST)
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
 <53490dba-b7fd-a3f8-6574-5736c83aa90d@linuxfoundation.org>
 <CAEf4BzYA1h2kVF3945hxdcR8gf08GFpLiN1OwjedzTrzaAparA@mail.gmail.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <cc4d6562-3d2e-2c0a-cb31-2733d2189f5c@linuxfoundation.org>
Date:   Thu, 16 Dec 2021 13:22:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CAEf4BzYA1h2kVF3945hxdcR8gf08GFpLiN1OwjedzTrzaAparA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/16/21 1:03 PM, Andrii Nakryiko wrote:
> On Thu, Dec 16, 2021 at 11:51 AM Shuah Khan <skhan@linuxfoundation.org> wrote:
>>
>> On 12/16/21 12:30 PM, Andrii Nakryiko wrote:
>>> On Thu, Dec 16, 2021 at 6:42 AM Shuah Khan <skhan@linuxfoundation.org> wrote:
>>>>
>>>> On 12/15/21 9:04 PM, Andrii Nakryiko wrote:
>>>>> On Tue, Dec 14, 2021 at 12:27 PM Shuah Khan <skhan@linuxfoundation.org> wrote:
>>>>>>
>>>>>> On 12/11/21 6:53 PM, Alexei Starovoitov wrote:
>>>>>>> On Fri, Dec 10, 2021 at 9:34 AM Shuah Khan <skhan@linuxfoundation.org> wrote:
>>>>>>>>
>>>>>>>> ARRAY_SIZE is defined in multiple test files. Remove the definitions
>>>>>>>> and include header file for the define instead.
>>>>>>>>
>>>>>>>> Remove ARRAY_SIZE define and add include bpf_util.h to bring in the
>>>>>>>> define.
>>>>>>>>
>>>>>>>> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
>>>>>>>> ---
>>>>>>>>      tools/testing/selftests/bpf/progs/netif_receive_skb.c | 5 +----
>>>>>>>>      tools/testing/selftests/bpf/progs/profiler.inc.h      | 5 +----
>>>>>>>>      tools/testing/selftests/bpf/progs/test_sysctl_loop1.c | 5 +----
>>>>>>>>      tools/testing/selftests/bpf/progs/test_sysctl_loop2.c | 4 +---
>>>>>>>>      tools/testing/selftests/bpf/progs/test_sysctl_prog.c  | 5 +----
>>>>>>>>      5 files changed, 5 insertions(+), 19 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/tools/testing/selftests/bpf/progs/netif_receive_skb.c b/tools/testing/selftests/bpf/progs/netif_receive_skb.c
>>>>>>>> index 1d8918dfbd3f..7a5ebd330689 100644
>>>>>>>> --- a/tools/testing/selftests/bpf/progs/netif_receive_skb.c
>>>>>>>> +++ b/tools/testing/selftests/bpf/progs/netif_receive_skb.c
>>>>>>>> @@ -5,6 +5,7 @@
>>>>>>>>      #include <bpf/bpf_helpers.h>
>>>>>>>>      #include <bpf/bpf_tracing.h>
>>>>>>>>      #include <bpf/bpf_core_read.h>
>>>>>>>> +#include <bpf/bpf_util.h>
>>>>>>>
>>>>>>> It doesn't look like you've built it.
>>>>>>>
>>>>>>> progs/test_sysctl_prog.c:11:10: fatal error: 'bpf/bpf_util.h' file not found
>>>>>>> #include <bpf/bpf_util.h>
>>>>>>>              ^~~~~~~~~~~~~~~~
>>>>>>>       CLNG-BPF [test_maps] socket_cookie_prog.o
>>>>>>> progs/test_sysctl_loop2.c:11:10: fatal error: 'bpf/bpf_util.h' file not found
>>>>>>> #include <bpf/bpf_util.h>
>>>>>>>              ^~~~~~~~~~~~~~~~
>>>>>>> 1 error generated.
>>>>>>> In file included from progs/profiler2.c:6:
>>>>>>> progs/profiler.inc.h:7:10: fatal error: 'bpf/bpf_util.h' file not found
>>>>>>> #include <bpf/bpf_util.h>
>>>>>>>              ^~~~~~~~~~~~~~~~
>>>>>>>
>>>>>>
>>>>>> Sorry about that. I built it - I think something is wrong in my env. Build
>>>>>> fails complaining about not finding vmlinux - I overlooked that the failure
>>>>>> happened before it got to progs.
>>>>>>
>>>>>> Error: failed to load BTF from .../vmlinux: No such file or directory
>>>>>
>>>>> Please make sure that you build vmlinux before you build selftests,
>>>>> BPF selftests use vmlinux to generate vmlinux.h with all kernel types
>>>>> (among other things). So please also make sure that all the setting in
>>>>> selftests/bpf/config were used in your Kconfig.
>>>>>
>>>>>>
>>>>
>>>> The problem in my env. is that I don't have CONFIG_DEBUG_INFO_BTF in
>>>> my config and then don't have the dwarves and llvm-strip on my system.
>>>> Pains of upgrading.
>>>>
>>>> I am all set now. On the other hand the vmlinux.h is a mess. It has
>>>> no guards for defines and including stdio.h and this generated
>>>> vmlinux.h causes all sorts of problems.
>>>
>>> It does have
>>>
>>> #ifndef __VMLINUX_H__
>>> #define __VMLINUX_H__
>>>
>>> Are we talking about the same vmlinux.h here?
>>>
>>
>> Yes we are. The guard it has works when vmlinux.h is included
>> twice. It defines a lot of common defines which are the problem.
>> Unless you add guards around each one of them, including vmlinux.h
>> is problematic if you also include other standard includes.
>>
>> You can try to include bpf_util.h for example from one of the
>> test in progs to see the problem.
> 
> bpf_util.h is a user-space header, it's not going to work from the BPF
> program side. If you look at any of progs/*.c (all of which are BPF
> program-side source code), not a single one is including bpf_util.h.
> 

Whether bpf_util.h can be included from progs isn't the main thing here.
progs/test*.c including vmlinux.h (most of them seem to) can,'t include
any standard .h files.

"including vmlinux.h is problematic if a test also had to include other
  standard includes."

This makes this header file restrictive and works in one case and one
case only when no other standard headers aren't included.

thanks,
-- Shuah
