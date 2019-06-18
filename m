Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC4484ACE4
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 23:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731064AbfFRVHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 17:07:12 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:35634 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730696AbfFRVHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 17:07:10 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: gtucker)
        with ESMTPSA id EFF1D285136
Subject: Re: next/master boot bisection: next-20190617 on
 sun8i-h2-plus-orangepi-zero
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     Kevin Hilman <khilman@baylibre.com>,
        "David S. Miller" <davem@davemloft.net>,
        tomeu.vizoso@collabora.com, mgalka@collabora.com,
        broonie@kernel.org, matthew.hart@linaro.org,
        enric.balletbo@collabora.com, Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
References: <5d089fb6.1c69fb81.4f92.9134@mx.google.com>
 <7hr27qdedo.fsf@baylibre.com>
 <CAFBinCCrpQNU_JtL0SwEGbwWZ2Qy-b2m5rdjuE0__nDRORGTiQ@mail.gmail.com>
 <7d0a9da1-0b42-d4e9-0690-32d58a6d27de@collabora.com>
 <CAFBinCA7gMLJ=jPqgRgHcBABBvC7bWVt8VJhLZ5uN=03WL1UWQ@mail.gmail.com>
From:   Guillaume Tucker <guillaume.tucker@collabora.com>
Message-ID: <2af9b9a5-cdf8-afce-5a75-d66c99eb82a2@collabora.com>
Date:   Tue, 18 Jun 2019 22:07:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CAFBinCA7gMLJ=jPqgRgHcBABBvC7bWVt8VJhLZ5uN=03WL1UWQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Martin,

On 18/06/2019 21:58, Martin Blumenstingl wrote:
> Hi Guillaume,
> 
> On Tue, Jun 18, 2019 at 10:53 PM Guillaume Tucker
> <guillaume.tucker@collabora.com> wrote:
>>
>> On 18/06/2019 21:42, Martin Blumenstingl wrote:
>>> On Tue, Jun 18, 2019 at 6:53 PM Kevin Hilman <khilman@baylibre.com> wrote:
>>> [...]
>>>> This seems to have broken on several sunxi SoCs, but also a MIPS SoC
>>>> (pistachio_marduk):
>>>>
>>>> https://storage.kernelci.org/next/master/next-20190618/mips/pistachio_defconfig/gcc-8/lab-baylibre-seattle/boot-pistachio_marduk.html
>>> today I learned why initializing arrays on the stack is important
>>> too bad gcc didn't warn that I was about to shoot myself (or someone
>>> else) in the foot :/
>>>
>>> I just sent a fix: [0]
>>>
>>> sorry for this issue and thanks to Kernel CI for even pointing out the
>>> offending commit (this makes things a lot easier than just yelling
>>> that "something is broken")
>>
>> Glad that helped :)
>>
>> If you would be so kind as to credit our robot friend in your
>> patch, it'll be forever grateful:
>>
>>   Reported-by: "kernelci.org bot" <bot@kernelci.org>
> sure
> do you want me to re-send my other patch or should I just reply to it
> adding the Reported-by tag and hope that Dave will catch it when
> applying the patch?

Well that's no big deal so replying would already be great.  The
important part is that the fix gets applied.

> in either case: I did mention in the patch description that Kernel CI caught it

I see, thanks!

> by the way: I didn't know how to credit the Kernel CI bot.
> syzbot / syzkaller makes that bit easy as it's mentioned in the
> generated email, see [0] for a (random) example
> have you considered adding the Reported-by to the generated email?

Yes, we've got some bugs to fix first but that will be added to
the email report soon (next week I guess).  Thanks for the
suggestion though.

Guillaume

> [0] https://lkml.org/lkml/2019/4/19/638
