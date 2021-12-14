Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 639DE474CA0
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 21:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237630AbhLNU1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 15:27:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237607AbhLNU1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 15:27:15 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF5AC061574
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 12:27:14 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id 47-20020a9d0332000000b005798ac20d72so22211672otv.9
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 12:27:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5v5jiPKMVhoKa9oPktbJep7rYj1bDC4+fDKLLWPkAzg=;
        b=NtguBbLsXAqG+7WZN7V7gbYjnQ6wkdNPtH9rrzOx5/n8JxhzwtdlfqbHEkHoz3P3IV
         FJFgmp6VQ0XGbAAgXeC7kOwaOeXnllIgaiQTKcFG7nFqzcKGB4OK2YSJh4rIgmD0eLGJ
         QAwc6Wcfy35dEJCzVLdCHqKOTJ2z9wZdSEbZE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5v5jiPKMVhoKa9oPktbJep7rYj1bDC4+fDKLLWPkAzg=;
        b=RdpPg8MBWMywLSmqR71pzMk8ecu2gUtQhKWWJ+w8gaTUpK7PxJ9gHRp19jzq0O0Twe
         /TwQ3TlJQCqjDuYARv/beB6PIyLwoMbzY+TGgg2jkMlNYJoMl31WYDsOY/HqRWcYMd55
         19kf4mz26XMGFDMXTY5LrryzJB/KtBO7ooQ/imH55ECb6SkWrpQ5Ga8vtI7g5D7W5eqD
         4ni3hKoYyfU8c9Prn5dJjm9JsrcGlBSUPBAA8koYXL6MsHDtyJU+MDRAp6lulo8J3/Or
         E2y08HGsiMFVyXKtfWkEZAse1NXHQxky6RMr0h/u1Vxs5+ll94yp7UOS2v8x/2RPmiFS
         WJvQ==
X-Gm-Message-State: AOAM530lDNuBBbvVsHcYdqf9Le3ItHjr7ynSi3HbFqlamIgdcUge+Bx2
        652Yedhr2CvZC02GH6zj/+fZmA==
X-Google-Smtp-Source: ABdhPJyv4fW5I+F9FWYzifWvOIE6BGPtrx9w3YSbp9hwRop2Lq8hW4DweFB5hVyt2vg/P9gCk9nOuw==
X-Received: by 2002:a05:6830:2aa7:: with SMTP id s39mr6194227otu.151.1639513634160;
        Tue, 14 Dec 2021 12:27:14 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id p23sm173635otf.37.2021.12.14.12.27.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Dec 2021 12:27:13 -0800 (PST)
Subject: Re: [PATCH] selftests/bpf: remove ARRAY_SIZE defines from tests
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211210173433.13247-1-skhan@linuxfoundation.org>
 <CAADnVQ+Fnn-NuGoLq1ZYbHM=kR_W01GB1DCFOnQTHhgfDOrnaA@mail.gmail.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <d367441f-bba0-30eb-787a-89b0c06a65dd@linuxfoundation.org>
Date:   Tue, 14 Dec 2021 13:27:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CAADnVQ+Fnn-NuGoLq1ZYbHM=kR_W01GB1DCFOnQTHhgfDOrnaA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/11/21 6:53 PM, Alexei Starovoitov wrote:
> On Fri, Dec 10, 2021 at 9:34 AM Shuah Khan <skhan@linuxfoundation.org> wrote:
>>
>> ARRAY_SIZE is defined in multiple test files. Remove the definitions
>> and include header file for the define instead.
>>
>> Remove ARRAY_SIZE define and add include bpf_util.h to bring in the
>> define.
>>
>> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
>> ---
>>   tools/testing/selftests/bpf/progs/netif_receive_skb.c | 5 +----
>>   tools/testing/selftests/bpf/progs/profiler.inc.h      | 5 +----
>>   tools/testing/selftests/bpf/progs/test_sysctl_loop1.c | 5 +----
>>   tools/testing/selftests/bpf/progs/test_sysctl_loop2.c | 4 +---
>>   tools/testing/selftests/bpf/progs/test_sysctl_prog.c  | 5 +----
>>   5 files changed, 5 insertions(+), 19 deletions(-)
>>
>> diff --git a/tools/testing/selftests/bpf/progs/netif_receive_skb.c b/tools/testing/selftests/bpf/progs/netif_receive_skb.c
>> index 1d8918dfbd3f..7a5ebd330689 100644
>> --- a/tools/testing/selftests/bpf/progs/netif_receive_skb.c
>> +++ b/tools/testing/selftests/bpf/progs/netif_receive_skb.c
>> @@ -5,6 +5,7 @@
>>   #include <bpf/bpf_helpers.h>
>>   #include <bpf/bpf_tracing.h>
>>   #include <bpf/bpf_core_read.h>
>> +#include <bpf/bpf_util.h>
> 
> It doesn't look like you've built it.
> 
> progs/test_sysctl_prog.c:11:10: fatal error: 'bpf/bpf_util.h' file not found
> #include <bpf/bpf_util.h>
>           ^~~~~~~~~~~~~~~~
>    CLNG-BPF [test_maps] socket_cookie_prog.o
> progs/test_sysctl_loop2.c:11:10: fatal error: 'bpf/bpf_util.h' file not found
> #include <bpf/bpf_util.h>
>           ^~~~~~~~~~~~~~~~
> 1 error generated.
> In file included from progs/profiler2.c:6:
> progs/profiler.inc.h:7:10: fatal error: 'bpf/bpf_util.h' file not found
> #include <bpf/bpf_util.h>
>           ^~~~~~~~~~~~~~~~
> 

Sorry about that. I built it - I think something is wrong in my env. Build
fails complaining about not finding vmlinux - I overlooked that the failure
happened before it got to progs.

Error: failed to load BTF from .../vmlinux: No such file or directory

I do have the kernel built with gcc. Is there a clang dependency?

thanks,
-- Shuah

