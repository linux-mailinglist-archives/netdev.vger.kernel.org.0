Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B939A4AC14
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 22:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730469AbfFRUxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 16:53:46 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:35576 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730181AbfFRUxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 16:53:46 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: gtucker)
        with ESMTPSA id F3C85260A33
Subject: Re: next/master boot bisection: next-20190617 on
 sun8i-h2-plus-orangepi-zero
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Kevin Hilman <khilman@baylibre.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
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
From:   Guillaume Tucker <guillaume.tucker@collabora.com>
Message-ID: <7d0a9da1-0b42-d4e9-0690-32d58a6d27de@collabora.com>
Date:   Tue, 18 Jun 2019 21:53:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CAFBinCCrpQNU_JtL0SwEGbwWZ2Qy-b2m5rdjuE0__nDRORGTiQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/06/2019 21:42, Martin Blumenstingl wrote:
> On Tue, Jun 18, 2019 at 6:53 PM Kevin Hilman <khilman@baylibre.com> wrote:
> [...]
>> This seems to have broken on several sunxi SoCs, but also a MIPS SoC
>> (pistachio_marduk):
>>
>> https://storage.kernelci.org/next/master/next-20190618/mips/pistachio_defconfig/gcc-8/lab-baylibre-seattle/boot-pistachio_marduk.html
> today I learned why initializing arrays on the stack is important
> too bad gcc didn't warn that I was about to shoot myself (or someone
> else) in the foot :/
> 
> I just sent a fix: [0]
> 
> sorry for this issue and thanks to Kernel CI for even pointing out the
> offending commit (this makes things a lot easier than just yelling
> that "something is broken")

Glad that helped :)

If you would be so kind as to credit our robot friend in your
patch, it'll be forever grateful:

  Reported-by: "kernelci.org bot" <bot@kernelci.org>

Thanks,
Guillaume

> Martin
> 
> 
> [0] https://patchwork.ozlabs.org/patch/1118313/
> 

