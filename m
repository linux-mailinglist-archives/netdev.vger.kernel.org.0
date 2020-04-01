Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 294BF19B6E4
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 22:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732872AbgDAUVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 16:21:37 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:43167 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727178AbgDAUVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 16:21:37 -0400
Received: by mail-il1-f196.google.com with SMTP id g15so1291196ilj.10
        for <netdev@vger.kernel.org>; Wed, 01 Apr 2020 13:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NZ7ptwZtc0lwD8ofFzTzdr4FmIeRPKr07pDioEHD4o4=;
        b=d0dPOKW8rex5FOSqe5KaBMzBgEkYcOP3euVyUUMVUMuVX2TFUfi/mdjcwGJ1kCpNI6
         TjsUrfnUzUOxvBu/MTscDJobOUJaE1VDz1M2Osp4+QQfW6NYU7RKe9FUvCC7lRWOJG/B
         Z/C7/xuRBmLAMFukHH64T5VfCFmKskqNg7knxOyRFv2W+ejtAyK6J5P1xsKONWLuqmhR
         ZOhl3NTW74ZpvVnfLyXB0LJXKmovj5gwnbjHR0hZ15akHcnUBTwXQ8xRQXaTj64XEagd
         nz1Pz0dJxQ7ciCfXmyz9v1dibe5qPn6RZHfRuiqbg0Yyhz7l0qAEJg0ai0bZxuCkYDUT
         2QgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NZ7ptwZtc0lwD8ofFzTzdr4FmIeRPKr07pDioEHD4o4=;
        b=mcyIhy0/Eyep48hVzuLNSGU5pWt1RKefVyymvX/ko9fnPwzyL2dlYwbpNMOmq0EuX2
         MLkJUukaPG9dscIadhzR0tM4T567zBTqPCqulGRSRXcDCTYGHCMylxq+9O+ifNNS0YfQ
         IxaTqUrUSbm2tg2YK31jGGg9GEbQqv+MaDDkfzU5+9JDwiBriYxj7TIpcgplnfVoXjr6
         aVArCrfgK2xD6RvVjWoKNeahQ+qAQW6frYXRY+0yO+Haji8RSSUywEbGLwt8jqQWXJZv
         AAq9t8s0PhwZFKARCADH7yx7O2S+Nu20Py4cBX5NFi7mM2p4FGQ3ajfxztcSXgxGHkFS
         ZMgw==
X-Gm-Message-State: ANhLgQ2nHB9/DDEQiJnEKs0A5/FiqCxrLsk5hdDpaumX2QrtD8h8nKFz
        hzDlMgFzfTauVrUfSt0BGDpEQcce6cKZcw==
X-Google-Smtp-Source: ADFU+vsc1fZ+0cuH55zfqwH9e+3XmcFy1wOjslGUdGyb4NfU6OF3tDgPVYRNCMs3LdKmnvGKq8ixLg==
X-Received: by 2002:a05:6e02:e8c:: with SMTP id t12mr23377868ilj.196.1585772494254;
        Wed, 01 Apr 2020 13:21:34 -0700 (PDT)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id m70sm990629ilh.84.2020.04.01.13.21.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Apr 2020 13:21:33 -0700 (PDT)
Subject: Re: [PATCH v3] bitfield.h: add FIELD_MAX() and field_max()
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Maxim Kuvyrkov <maxim.kuvyrkov@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>
References: <20200311024240.26834-1-elder@linaro.org>
 <20200401173515.142249-1-ndesaulniers@google.com>
 <3659efd7-4e72-6bff-5657-c1270e8553f4@linaro.org>
 <CAKwvOdn7TpsZJ70mRiQARJc9Fy+364PXSAiPnSpc_M9pOaXjGw@mail.gmail.com>
 <3c878065-8d25-8177-b7c4-9813b60c9ff6@linaro.org>
 <CAKwvOdnZ-QNeYQ_G-aEuo8cC_m68E5mAC4cskwAQpJJQPc1BSg@mail.gmail.com>
From:   Alex Elder <elder@linaro.org>
Message-ID: <efd2c8b1-4efd-572e-10c5-c45f705274d0@linaro.org>
Date:   Wed, 1 Apr 2020 15:21:19 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAKwvOdnZ-QNeYQ_G-aEuo8cC_m68E5mAC4cskwAQpJJQPc1BSg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/1/20 2:54 PM, Nick Desaulniers wrote:
> On Wed, Apr 1, 2020 at 12:44 PM Alex Elder <elder@linaro.org> wrote:
>>
>> On 4/1/20 2:13 PM, Nick Desaulniers wrote:
>>> On Wed, Apr 1, 2020 at 11:24 AM Alex Elder <elder@linaro.org> wrote:
>>>>
>>>> On 4/1/20 12:35 PM, Nick Desaulniers wrote:
>>>>>> Define FIELD_MAX(), which supplies the maximum value that can be
>>>>>> represented by a field value.  Define field_max() as well, to go
>>>>>> along with the lower-case forms of the field mask functions.
>>>>>>
>>>>>> Signed-off-by: Alex Elder <elder@linaro.org>
>>>>>> Acked-by: Jakub Kicinski <kuba@kernel.org>
>>>>>> ---
>>>>>> v3: Rebased on latest netdev-next/master.
>>>>>>
>>>>>> David, please take this into net-next as soon as possible.  When the
>>>>>> IPA code was merged the other day this prerequisite patch was not
>>>>>> included, and as a result the IPA driver fails to build.  Thank you.
>>>>>>
>>>>>>   See: https://lkml.org/lkml/2020/3/10/1839
>>>>>>
>>>>>>                                      -Alex
>>>>>
>>>>> In particular, this seems to now have regressed into mainline for the 5.7
>>>>> merge window as reported by Linaro's ToolChain Working Group's CI.
>>>>> Link: https://github.com/ClangBuiltLinux/linux/issues/963
>>>>
>>>> Is the problem you're referring to the result of a build done
>>>> in the midst of a bisect?
>>>>
>>>> The fix for this build error is currently present in the
>>>> torvalds/linux.git master branch:
>>>>     6fcd42242ebc soc: qcom: ipa: kill IPA_RX_BUFFER_ORDER
>>>
>>> Is that right? That patch is in mainline, but looks unrelated to what
>>> I'm referring to.
>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6fcd42242ebcc98ebf1a9a03f5e8cb646277fd78
>>> From my github link above, the issue I'm referring to is a
>>> -Wimplicit-function-declaration warning related to field_max.
>>> 6fcd42242ebc doesn't look related.
>>
>> I'm very sorry, I pointed you at the wrong commit.  This one is
>> also present in torvalds/linux.git master:
>>
>>   e31a50162feb bitfield.h: add FIELD_MAX() and field_max()
>>
>> It defines field_max() as a macro in <linux/bitfield.h>, and
>> "gsi.c" includes that header file.
>>
>> This was another commit that got added late, after the initial
>> IPA code was accepted.
> 
> Yep, that looks better.

Sorry about that.  The two actually are related in a way, because
without the first one I pointed you at, a *different* problem
involving field_max() gets triggered.  But that's irrelevant to
this discussion...

>>>> I may be mistaken, but I believe this is the same problem I discussed
>>>> with Maxim Kuvyrkov this morning.  A different build problem led to
>>>> an automated bisect, which conluded this was the cause because it
>>>> landed somewhere between the initial pull of the IPA code and the fix
>>>> I reference above.
>>>
>>> Yes, Maxim runs Linaro's ToolChain Working Group (IIUC, but you work
>>> there, so you probably know better than I do), that's the CI I was
>>> referring to.
>>>
>>> I'm more concerned when I see reports of regressions *in mainline*.
>>> The whole point of -next is that warnings reported there get fixed
>>> BEFORE the merge window opens, so that we don't regress mainline.  Or
>>> we drop the patches in -next.
>>
>> Can you tell me where I can find the commit id of the kernel
>> that is being built when this error is reported?  I would
>> like to examine things and build it myself so I can fix it.
>> But so far haven't found what I need to check out.
> 
> From the report: https://groups.google.com/g/clang-built-linux/c/pX-kr_t5l_A

That link doesn't work for me.

> Configuration details:
> rr[llvm_url]="https://github.com/llvm/llvm-project.git"
> rr[linux_url]="https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git"
> rr[linux_branch]="7111951b8d4973bda27ff663f2cf18b663d15b48"

That commit is just the one in which Linux v5.6 is tagged.
It doesn't include any of this code (but it's the last
tagged release that current linus/master is built on).

It doesn't answer my question about what commit id was
used for this build, unfortunately.

> the linux_branch looks like a SHA of what the latest ToT of mainline
> was when the CI ran.
> 
> I was suspecting that maybe there was a small window between the
> regression, and the fix, and when the bot happened to sync.  But it
> seems that: e31a50162feb352147d3fc87b9e036703c8f2636 landed before
> 7111951b8d4973bda27ff663f2cf18b663d15b48 IIUC.

Yes, this:
  e31a50162feb bitfield.h: add FIELD_MAX() and field_max()
landed about 200 commits after the code that needed it.

So there's a chance the kernel that got built was somewhere
between those two, and I believe the problem you point out
would happen in that case.  This is why I started by asking
whether it was something built during a bisect.

It's still not clear to me what happened here.  I can explain
how this *could* happen, but I don't believe problem exists
in the latest upstream kernel commit.

Is there something else you think I should do?

					-Alex

> So I think the bot had your change when it ran, so still seeing a
> failure is curious.  Unless I've misunderstood something.
