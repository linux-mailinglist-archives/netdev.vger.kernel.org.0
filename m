Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 479EABD231
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 20:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406632AbfIXS45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 14:56:57 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:42607 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393934AbfIXS45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 14:56:57 -0400
Received: by mail-io1-f66.google.com with SMTP id n197so7057249iod.9
        for <netdev@vger.kernel.org>; Tue, 24 Sep 2019 11:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Y8tNiK4rit2T6OMD6IzNrQ4BfMuscrxy1rt5VXtm+tI=;
        b=Xr06tKBbA+9l6ICEUz9htZ+54hFp+f6YK/2A0gDT0hrONApWuhQPfekYYKewbD2jrK
         Ryz55u+sA7DW6nnZQRUCUAdQhkayIOnPbsATSN8IUXy+NFt4RRNkhLu7MfSkOZcUSmls
         IqzwVZl1lZXDGp8zqum09utri5xe30dCxwLQ0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Y8tNiK4rit2T6OMD6IzNrQ4BfMuscrxy1rt5VXtm+tI=;
        b=Kb6fnD2nLeMx1IqH39EsXcnlU6VKjkUISh5dmYboniSKph9/LXNtFaKnT+eVcC+dDE
         4AmLkcyqTYLtI7EWazCnK0fb9OJxE2BKoyVunwmX2GottVNknx/q4sci+WXlQ+c7NcC4
         3nNSuGnE73oN1sgELSbmc1hdnoY4d7P9qbxtb3k9eucWIskoNh3sgv/9Q/cjQtnOxMf/
         TLaQRaBSUBA83ZB0bqcO7NBYOMwfXu5JT/llpWmLuN45l28agU7lQbt7uRR3NrWJH0KW
         Vq19PRgx2JlHAqjlE9MxxyjB+ES1+ysx/LsawxVQlmlMsRsHBWXWNzl6YPODssj8k6C0
         eSqg==
X-Gm-Message-State: APjAAAWCoI12tinpAitlNwHHYco0MHSMZd7Base9/BkrbTj96AILbkFl
        LtoUlpUQs48HOmi73P5Rys6ZTA==
X-Google-Smtp-Source: APXvYqyKWDtCY4YdYQXOim7uq5RVUadF5MI6py2IpIblH3mZtd/NckBWC4savx9a8Fleox5tyB3JIQ==
X-Received: by 2002:a6b:e016:: with SMTP id z22mr2461709iog.59.1569351414590;
        Tue, 24 Sep 2019 11:56:54 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id m9sm2375018ion.65.2019.09.24.11.56.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Sep 2019 11:56:54 -0700 (PDT)
Subject: Re: Linux 5.4 - bpf test build fails
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Shuah Khan <skhan@linuxfoundation.org>
References: <742ecabe-45ce-cf6e-2540-25d6dc23c45f@linuxfoundation.org>
 <0a5bf608-bb15-c116-8e58-7224b6c3b62f@fb.com>
 <05b7830c-1fa8-b613-0535-1f5f5a40a25a@linuxfoundation.org>
 <20190924184946.GB5889@pc-63.home>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <edb38c06-a75f-89df-60cd-d9d2de1879d6@linuxfoundation.org>
Date:   Tue, 24 Sep 2019 12:56:53 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190924184946.GB5889@pc-63.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/24/19 12:49 PM, Daniel Borkmann wrote:
> On Tue, Sep 24, 2019 at 09:48:35AM -0600, Shuah Khan wrote:
>> On 9/24/19 9:43 AM, Yonghong Song wrote:
>>> On 9/24/19 8:26 AM, Shuah Khan wrote:
>>>> Hi Alexei and Daniel,
>>>>
>>>> bpf test doesn't build on Linux 5.4 mainline. Do you know what's
>>>> happening here.
>>>>
>>>> make -C tools/testing/selftests/bpf/
>>>>
>>>> -c progs/test_core_reloc_ptr_as_arr.c -o - || echo "clang failed") | \
>>>> llc -march=bpf -mcpu=generic  -filetype=obj -o
>>>> /mnt/data/lkml/linux_5.4/tools/testing/selftests/bpf/test_core_reloc_ptr_as_arr.o
>>>>
>>>> progs/test_core_reloc_ptr_as_arr.c:25:6: error: use of unknown builtin
>>>>          '__builtin_preserve_access_index' [-Wimplicit-function-declaration]
>>>>            if (BPF_CORE_READ(&out->a, &in[2].a))
>>>>                ^
>>>> ./bpf_helpers.h:533:10: note: expanded from macro 'BPF_CORE_READ'
>>>>                           __builtin_preserve_access_index(src))
>>>>                           ^
>>>> progs/test_core_reloc_ptr_as_arr.c:25:6: warning: incompatible integer to
>>>>          pointer conversion passing 'int' to parameter of type 'const void *'
>>>>          [-Wint-conversion]
>>>>            if (BPF_CORE_READ(&out->a, &in[2].a))
>>>>                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>>> ./bpf_helpers.h:533:10: note: expanded from macro 'BPF_CORE_READ'
>>>>                           __builtin_preserve_access_index(src))
>>>>                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>>> 1 warning and 1 error generated.
>>>> llc: error: llc: <stdin>:1:1: error: expected top-level entity
>>>> clang failed
>>>>
>>>> Also
>>>>
>>>> make TARGETS=bpf kselftest fails as well. Dependency between
>>>> tools/lib/bpf and the test. How can we avoid this type of
>>>> dependency or resolve it in a way it doesn't result in build
>>>> failures?
>>>
>>> Thanks, Shuah.
>>>
>>> The clang __builtin_preserve_access_index() intrinsic is
>>> introduced in LLVM9 (which just released last week) and
>>> the builtin and other CO-RE features are only supported
>>> in LLVM10 (current development branch) with more bug fixes
>>> and added features.
>>>
>>> I think we should do a feature test for llvm version and only
>>> enable these tests when llvm version >= 10.
>>
>> Yes. If new tests depend on a particular llvm revision, the failing
>> the build is a regression. I would like to see older tests that don't
>> have dependency build and run.
> 
> So far we haven't made it a requirement as majority of BPF contributors
> that would run/add tests in here are also on bleeding edge LLVM anyway
> and other CIs like 0-day bot have simply upgraded their LLVM version
> from git whenever there was a failure similar to the one here so its
> ensured that really /all/ test cases are running and nothing would be
> skipped. There is worry to some degree that CIs just keep sticking to
> an old compiler since tests "just" pass and regressions wouldn't be
> caught on new releases for those that are skipped. >

Sure. Bleeding edge is developer mode. We still have to be concerned
about users that might not upgrade quickly.

> That said, for the C based tests, it should actually be straight forward
> to categorize them based on built-in macros like ...
> 
> $ echo | clang -dM -E -
> [...]
> #define __clang_major__ 10
> #define __clang_minor__ 0
> [...]
> 

What would nice running the tests you can run and then say some tests
aren't going to run. Is this something you can support?

> ... given there is now also bpf-gcc, the test matrix gets bigger anyway,
> so it might be worth rethinking to run the suite multiple times with
> different major llvm{,gcc} versions at some point to make sure their
> generated BPF bytecode keeps passing the verifier, and yell loudly if
> newer features had to be skipped due to lack of recent compiler version.
> This would be a super set of /just/ skipping tests and improve coverage
> at the same time.
> 

Probably. Reality is most users will just quit and add bpf to "hard to
run category" of tests.

thanks,
-- Shuah

