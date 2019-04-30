Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCB1AF2AE
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 11:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbfD3JV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 05:21:57 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33710 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbfD3JV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 05:21:56 -0400
Received: by mail-wm1-f67.google.com with SMTP id z6so1875310wmi.0
        for <netdev@vger.kernel.org>; Tue, 30 Apr 2019 02:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iaFDFnvVtS1iWSBFrIIKUe+7Fko1T4rJ0OHw8pGokPc=;
        b=SGZs7DUnbcoM2RcuSABcJ5nEoFb5Jh0yeaPcnF7PUPj+8pC9/WQCx9BoIHQSJleqz3
         N/9J58myQKiVQXvIx8lwvoC+4AC9LE0osAegiYd5wfE42z2H/ePs54RyDNrRSTAa2IXw
         7ByXxjQSOPkiK2LuY8u2671JH6lLW96Vv1MD5QJe62rqoc7RjuFVEEa0byaLidAP6+ss
         mJg+n7238TTgYfVBHgjWao3xUI8HqccPyvjGIsXVyTLswrqQWSqnLM/WCl2P2UDefbzq
         wY1iDaaKC5b4iIaEUCuRGx9TKrASiJp1IY0YURTny0z3gzpj5c7obFWhL8lZPD35gAo3
         RPrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iaFDFnvVtS1iWSBFrIIKUe+7Fko1T4rJ0OHw8pGokPc=;
        b=CxOmT4VWXuG/RrD77aLun56fNXGK5XMTW1CLrMGZKW4Iydw8+GZMw/pSEZ8+pg+fC8
         he8yP6lhIOrFNeJc4P5dETmvmEKlCIy2KmNhirqVQQ0Rs9Hepebw6ud4Nf23Kcpnk9a1
         xiEtiNthPbY22sIjU6Q4/DJ9p56wqAfmjBKeQfKIfOxEGsY92JaXknSXcNpIQmDHZ7zU
         scOqczn3QswHqpWPOPe6yq9o04tPlZozloGlrmOqAzB7TD9ugMPE4ag4JCP6RCOJ6EE/
         p3mR/AJLZfXZzZxuFcrqiL9K2xg1MiL1TixsFF+QwCq1CzUbi/SGaV0FdCqtgHsNHhyR
         iNwg==
X-Gm-Message-State: APjAAAWkq6YLWBsl7ys5qWnmJrToxzTQRJ5yxYLS0goM7Lmfsl8cWlgk
        AJiMo7hDBAQX6ApOF69Uk1yaww==
X-Google-Smtp-Source: APXvYqx+yh3Iadp8l8x5yFZGysITBwlj+gNULdwM6jjBvepbMk7WQhnCC99IjaETLKFpNyD41sTd9w==
X-Received: by 2002:a7b:c054:: with SMTP id u20mr2564880wmc.100.1556616114786;
        Tue, 30 Apr 2019 02:21:54 -0700 (PDT)
Received: from [192.168.1.2] ([194.53.187.71])
        by smtp.gmail.com with ESMTPSA id r2sm9694774wrr.65.2019.04.30.02.21.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Apr 2019 02:21:54 -0700 (PDT)
Subject: Re: [PATCH] bpftool: exclude bash-completion/bpftool from .gitignore
 pattern
To:     Masahiro Yamada <yamada.masahiro@socionext.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Sirio Balmelli <sirio@b-ad.ch>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>, Yonghong Song <yhs@fb.com>,
        Taeung Song <treeze.taeung@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
References: <1556549259-16298-1-git-send-email-yamada.masahiro@socionext.com>
 <ec1d2c14-ae27-38c7-9b79-4e323161d6f5@netronome.com>
 <CAK7LNARBOtOMr-=FRh0K1nMFLijRjRCMHYb0L=NY7KZQGydVrQ@mail.gmail.com>
From:   Quentin Monnet <quentin.monnet@netronome.com>
Message-ID: <ca18f97d-0a16-0c2f-2849-841633ad09cb@netronome.com>
Date:   Tue, 30 Apr 2019 10:21:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAK7LNARBOtOMr-=FRh0K1nMFLijRjRCMHYb0L=NY7KZQGydVrQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-04-30 09:15 UTC+0900 ~ Masahiro Yamada <yamada.masahiro@socionext.com>
> Hi Quentin,
> 
> 
> On Tue, Apr 30, 2019 at 12:33 AM Quentin Monnet
> <quentin.monnet@netronome.com> wrote:
>>
>> 2019-04-29 23:47 UTC+0900 ~ Masahiro Yamada <yamada.masahiro@socionext.com>
>>> tools/bpf/bpftool/.gitignore has the "bpftool" pattern, which is
>>> intended to ignore the following build artifact:
>>>
>>>    tools/bpf/bpftool/bpftool
>>>
>>> However, the .gitignore entry is effective not only for the current
>>> directory, but also for any sub-directories.
>>>
>>> So, the following file is also considered to be ignored:
>>>
>>>    tools/bpf/bpftool/bash-completion/bpftool
>>>
>>> It is obviously version-controlled, so should be excluded from the
>>> .gitignore pattern.
>>>
>>> You can fix it by prefixing the pattern with '/', which means it is
>>> only effective in the current directory.
>>>
>>> I prefixed the other patterns consistently. IMHO, '/' prefixing is
>>> safer when you intend to ignore specific files.
>>>
>>> Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
>>> ---
>>
>> Hi,
>>
>> “Files already tracked by Git are not affected” by the .gitignore (says
>> the relevant man page), so bash completion file is not ignored. It would
>> be if we were to add the sources to the index of a new Git repo. But
>> sure, it does not cost much to make the .gitignore cleaner.
> 
> Right, git seems to be flexible enough.
> 
> 
> But, .gitignore is useful to identify
> build artifacts in general.
> In fact, other than git, some projects
> already parse this.
> 
> For example, tar(1) supports:
> 
>       --exclude-vcs-ignores
>             read exclude patterns from the VCS ignore files
> 
> 
> As of writing, this option works only to some extent,
> but I thought this would be useful to create a source
> package without relying on "git archive".
> 
> When I tried "tar --exclude-vcs-ignores", I noticed
> tools/bpf/bpftool/bash-completion/bpftool was not
> contained in the tarball.
> 
> That's why I sent this patch.

Ok, thanks for explaining! Makes sense to me now.

> 
> I can add more info in v2 to clarify
> my motivation though.

Sounds good, yes please.

> 
> 
>>>
>>>   tools/bpf/bpftool/.gitignore | 8 ++++----
>>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/tools/bpf/bpftool/.gitignore b/tools/bpf/bpftool/.gitignore
>>> index 67167e4..19efcc8 100644
>>> --- a/tools/bpf/bpftool/.gitignore
>>> +++ b/tools/bpf/bpftool/.gitignore
>>> @@ -1,5 +1,5 @@
>>>   *.d
>>> -bpftool
>>> -bpftool*.8
>>> -bpf-helpers.*
>>> -FEATURE-DUMP.bpftool
>>> +/bpftool
>>> +/bpftool*.8
>>> +/bpf-helpers.*
>>
>> Careful when you add all those slashes, however. "bpftool*.8" and
>> "bpf-helpers.*" should match files under Documentation/, so you do NOT
>> want to prefix them with just a "/".
> 
> OK, I should not have touched what I was unsure about.
> Will fix in v2.

Thanks!
Quentin
