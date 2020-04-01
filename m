Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B81C519B8DE
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 01:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733262AbgDAXS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 19:18:27 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:35822 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732537AbgDAXS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 19:18:27 -0400
Received: by mail-il1-f196.google.com with SMTP id 7so1783112ill.2
        for <netdev@vger.kernel.org>; Wed, 01 Apr 2020 16:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aStNwHGcg4HXgGp/sSqVaH0OjggLXkpoemAa7H6Bkb0=;
        b=Dn5mU/W/+GRdMM3sDBTNeLnkiFRb44aiL0YQOTntjU8euIcQFhES3L/oeOm6yB5HBU
         CSSOyEy5QLInpY8AwQGo1wsgahYyQxtjbuyj65M8BaG3zzG+oGp1/w/DrLbXolu6yTa0
         HPmC8ADsY5vjV20y5HB0hkOOHJHZWG2x+uyFxKL9w0uc9x0ttsSN/EqS0jLy+U9j6VmE
         ADgrnsI372y7EiFFnB+ELkTKx6NlLQweK85wf6oLvY1pkc0QaiL+5waFQlm8V8+/Ooz/
         cKv5MLodezEM8O9O2GwczBvLZlh6+3iIMq6fA7n4H7pUQOWNJI2kHrIzBM8D6qcKDuR2
         raPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aStNwHGcg4HXgGp/sSqVaH0OjggLXkpoemAa7H6Bkb0=;
        b=aFS9yEe1eGdObLa7olEDTrM/M2yITiwWcPMzuHNOkwyO6qijurPCnwFPx1hCXPAS77
         dCFf79gXY5IvkFpGpqKFSGohLAnshBW1D3VOPzg5/6XVSbrKjq7DXqs3ULFA8eCJSL9c
         UjDHzZsNhcoISOm+/cChC3CMxrHcNNiGYunkTXmlgKRk3VCuNj9ei4yBV1TnHseJTiau
         i4i9cgO0ns7UH6OFyoJT9aB4rhHCGlX9FMr2Le6g5OdVY8yIaLk6VqfGWdrA9B9FzGOT
         vDBBTzSdRArhgllfS0EeyFL12pkN2EDdqXYm3dTFTw1ykfjZpmW2RoP5qXZ+E1pdp0yY
         CVsg==
X-Gm-Message-State: AGi0PuYmXid+vZzOu3XmyHNB36sVJktmorJfYpI+XwjAhkAx9j/AcEYE
        dCEyiPF/x6S3bUVC/W+7iG5n5Q==
X-Google-Smtp-Source: APiQypIQ8hziB4HtU+Sptx7pxo5HpJG46+Do1IdUouYHx80x6LVgUrDQUTOsWZ32D3yWbT7UHYbWSw==
X-Received: by 2002:a92:d108:: with SMTP id a8mr443859ilb.107.1585783104162;
        Wed, 01 Apr 2020 16:18:24 -0700 (PDT)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id p76sm939011iod.13.2020.04.01.16.18.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Apr 2020 16:18:23 -0700 (PDT)
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
 <efd2c8b1-4efd-572e-10c5-c45f705274d0@linaro.org>
 <CAKwvOdnZ9KL1Esmdjvk-BTP2a+C24bOWguNVaU3RSXKi1Ouh+w@mail.gmail.com>
From:   Alex Elder <elder@linaro.org>
Message-ID: <5635b511-64f8-b612-eb25-20b43ced4ed3@linaro.org>
Date:   Wed, 1 Apr 2020 18:18:09 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAKwvOdnZ9KL1Esmdjvk-BTP2a+C24bOWguNVaU3RSXKi1Ouh+w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/1/20 5:26 PM, Nick Desaulniers wrote:
> On Wed, Apr 1, 2020 at 1:21 PM Alex Elder <elder@linaro.org> wrote:
>>
>> On 4/1/20 2:54 PM, Nick Desaulniers wrote:
>>> On Wed, Apr 1, 2020 at 12:44 PM Alex Elder <elder@linaro.org> wrote:
>>>>
>>>> Can you tell me where I can find the commit id of the kernel
>>>> that is being built when this error is reported?  I would
>>>> like to examine things and build it myself so I can fix it.
>>>> But so far haven't found what I need to check out.
>>>
>>> From the report: https://groups.google.com/g/clang-built-linux/c/pX-kr_t5l_A
>>
>> That link doesn't work for me.
> 
> Sigh, second internal bug filed against google groups this
> week...settings look correct but I too see a 404 when in private
> browsing mode.
> 
>>
>>> Configuration details:
>>> rr[llvm_url]="https://github.com/llvm/llvm-project.git"
>>> rr[linux_url]="https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git"
>>> rr[linux_branch]="7111951b8d4973bda27ff663f2cf18b663d15b48"
>>
>> That commit is just the one in which Linux v5.6 is tagged.
>> It doesn't include any of this code (but it's the last
>> tagged release that current linus/master is built on).
>>
>> It doesn't answer my question about what commit id was
>> used for this build, unfortunately.
> 
> 7111951b8d4973bda27ff663f2cf18b663d15b48 *is* the commit id that was
> used for the build.  It sync'd the mainline tree at that commit.
> 
>>> the linux_branch looks like a SHA of what the latest ToT of mainline
>>> was when the CI ran.
>>>
>>> I was suspecting that maybe there was a small window between the
>>> regression, and the fix, and when the bot happened to sync.  But it
>>> seems that: e31a50162feb352147d3fc87b9e036703c8f2636 landed before
>>> 7111951b8d4973bda27ff663f2cf18b663d15b48 IIUC.
>>
>> Yes, this:
>>   e31a50162feb bitfield.h: add FIELD_MAX() and field_max()
>> landed about 200 commits after the code that needed it.
>>
>> So there's a chance the kernel that got built was somewhere
>> between those two, and I believe the problem you point out
>> would happen in that case.  This is why I started by asking
>> whether it was something built during a bisect.
>>
>> It's still not clear to me what happened here.  I can explain
>> how this *could* happen, but I don't believe problem exists
>> in the latest upstream kernel commit.
>>
>> Is there something else you think I should do?
> 
> mainline is hosed for aarch64 due to some dtc failures.  I'm not sure
> how TCWG's CI chooses the bisection starting point, but if mainline
> was broken, and it jumped back say 300 commits, then the automated
> bisection may have converged on your first patch, but not the second.

This is similar to the situation I discussed with Maxim this
morning.  A different failure (yes, DTC related) led to an
automated bisect process, which landed on my commit. And my
commit unfortunately has the the known issue that was later
corrected.

Maxim said this was what started the automated bisect:
===
+# 00:01:41 make[2]: *** [arch/arm64/boot/dts/ti/k3-am654-base-board.dtb] Error 2
+# 00:01:41 make[2]: *** [arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dtb] Error 2
+# 00:01:41 make[1]: *** [arch/arm64/boot/dts/ti] Error 2
+# 00:01:41 make: *** [dtbs] Error 2
===

> I just checked out mainline @ 7111951b8d4973bda27ff663f2cf18b663d15b48
> and couldn't reproduce, so I assume the above is what happened.  So
> sorry for the noise, I'll go investigate the dtc failure.  Not sure
> how that skipped -next coverage.

Thank you for following up.

					-Alex
