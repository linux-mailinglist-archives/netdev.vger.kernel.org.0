Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA1E48DFD0
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 22:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236263AbiAMVnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 16:43:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235254AbiAMVnE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 16:43:04 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5F8CC06161C;
        Thu, 13 Jan 2022 13:43:03 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id o3so11765216pjs.1;
        Thu, 13 Jan 2022 13:43:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=chMleOaZP5LLYybKEvqzaEnOntGIKeyxzv8RxEMS/pU=;
        b=oOc3d8quuL+d364W7KNWQtMdgtUPWTOWcsp8cMWNvHDxrhgRW2/iqLsZTnFsASrpLY
         68f6X/M1x+sO4IK/5z8GRukqDLM7CHf4rk2qB/zOlWi9G1eAn8tq+zp6RKqI0IPYCVAa
         hUGAgdHmZB/tYYdmRvOmZ4JNl+7KaTpFtgGI83AIVn9odjlTyVtSNxGjna9I3MmeJxnP
         LOezyDSKBJbwulklkuNOKWH9DWBVEMZVRl505lf6yiD2x6vDvZWbGecOdmYT0deqt9nE
         7oj6Lo5rPX0mYmnixNE6GUUU70z4K2CwYIE2HI3Z8c69J6dTeJP+r1nvFkXQlYsjlWb9
         Puog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=chMleOaZP5LLYybKEvqzaEnOntGIKeyxzv8RxEMS/pU=;
        b=QHOYRG/nrfl4koWEJiDfqsnGR7cx6gwQoWB3GZrWGV5Jm+mGhgU2oJBOVGs1d91qFs
         YKEalHAq/WhDO3wKhvAAiS8zdXatfsHpJGeNM11Yknr/paokwUvDUHQMS1EqVMpXSTpQ
         8JCyWBHqGUEw0SsWI1aDjNvTNarBcn8bW0URJoDmK3TttnoZYva4YHb5nvGBAhftrWiV
         oN8MSxY/igu+98YFqlmUpz+jxUppzDTy73SFLux8bq9KheaibR+lrzuir7LrZGEGQvmf
         +gxLyfQcrmZV2rSPj7BhsihZT4GMwq0Il/WkiIqdgS8bHoO+pCI2mOqy3naSVNeCkFCm
         Yo/A==
X-Gm-Message-State: AOAM531lftljLgVSLheaLb+KOHwuzjHS5UQVSYczmzkfm72T5DlB4KDo
        pPFmwv0thZJf359F6AMOKl0=
X-Google-Smtp-Source: ABdhPJza7nTyxaYu7zMa+CS3ya6yZ7jUqwYQkOFFet8Qv/maBjKZ7v19D4TMGEeuYYibqr5z1N9W+A==
X-Received: by 2002:a17:902:e790:b0:149:7a3f:826a with SMTP id cp16-20020a170902e79000b001497a3f826amr6595655plb.76.1642110183142;
        Thu, 13 Jan 2022 13:43:03 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:4a48:c1d3:c1c0:b78e:9e36? ([2600:8802:b00:4a48:c1d3:c1c0:b78e:9e36])
        by smtp.gmail.com with ESMTPSA id r26sm2983811pgu.65.2022.01.13.13.42.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Jan 2022 13:43:02 -0800 (PST)
Message-ID: <745c601f-c782-0904-f786-c9bfced8f11c@gmail.com>
Date:   Thu, 13 Jan 2022 13:42:57 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH] driver core: platform: Rename platform_get_irq_optional()
 to platform_get_irq_silent()
Content-Language: en-US
To:     =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, Ulf Hansson <ulf.hansson@linaro.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        KVM list <kvm@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>, linux-iio@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Guenter Roeck <groeck@chromium.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        MTD Maling List <linux-mtd@lists.infradead.org>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        linux-phy@lists.infradead.org, Jiri Slaby <jirislaby@kernel.org>,
        openipmi-developer@lists.sourceforge.net,
        "David S. Miller" <davem@davemloft.net>,
        Khuong Dinh <khuong@os.amperecomputing.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Kamal Dasu <kdasu.kdev@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        Robert Richter <rric@kernel.org>,
        Saravanan Sekar <sravanhome@gmail.com>,
        Corey Minyard <minyard@acm.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        John Garry <john.garry@huawei.com>,
        Peter Korsgaard <peter@korsgaard.com>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Mark Gross <markgross@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Sebastian Reichel <sre@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Takashi Iwai <tiwai@suse.com>,
        platform-driver-x86@vger.kernel.org,
        Benson Leung <bleung@chromium.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-edac@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omp.ru>,
        Mun Yew Tham <mun.yew.tham@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        James Morse <james.morse@arm.com>,
        Zha Qipeng <qipeng.zha@intel.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Richard Weinberger <richard@nod.at>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        linux-mediatek@lists.infradead.org,
        Brian Norris <computersforpeace@gmail.com>,
        netdev@vger.kernel.org
References: <20220110195449.12448-2-s.shtylyov@omp.ru>
 <20220110201014.mtajyrfcfznfhyqm@pengutronix.de> <YdyilpjC6rtz6toJ@lunn.ch>
 <CAMuHMdWK3RKVXRzMASN4HaYfLckdS7rBvSopafq+iPADtGEUzA@mail.gmail.com>
 <20220112085009.dbasceh3obfok5dc@pengutronix.de>
 <CAMuHMdWsMGPiQaPS0-PJ_+Mc5VQ37YdLfbHr_aS40kB+SfW-aw@mail.gmail.com>
 <20220112213121.5ruae5mxwj6t3qiy@pengutronix.de>
 <Yd9L9SZ+g13iyKab@sirena.org.uk>
 <20220113110831.wvwbm75hbfysbn2d@pengutronix.de>
 <YeA7CjOyJFkpuhz/@sirena.org.uk>
 <20220113194358.xnnbhsoyetihterb@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220113194358.xnnbhsoyetihterb@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/13/2022 11:43 AM, Uwe Kleine-König wrote:
> The subsystems regulator, clk and gpio have the concept of a dummy
> resource. For regulator, clk and gpio there is a semantic difference
> between the regular _get() function and the _get_optional() variant.
> (One might return the dummy resource, the other won't. Unfortunately
> which one implements which isn't the same for these three.) The
> difference between platform_get_irq() and platform_get_irq_optional() is
> only that the former might emit an error message and the later won't.
> 
> To prevent people's expectations that there is a semantic difference
> between these too, rename platform_get_irq_optional() to
> platform_get_irq_silent() to make the actual difference more obvious.
> 
> The #define for the old name can and should be removed once all patches
> currently in flux still relying on platform_get_irq_optional() are
> fixed.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
> Hello,
> 
> On Thu, Jan 13, 2022 at 02:45:30PM +0000, Mark Brown wrote:
>> On Thu, Jan 13, 2022 at 12:08:31PM +0100, Uwe Kleine-König wrote:
>>
>>> This is all very unfortunate. In my eyes b) is the most sensible
>>> sense, but the past showed that we don't agree here. (The most annoying
>>> part of regulator_get is the warning that is emitted that regularily
>>> makes customers ask what happens here and if this is fixable.)
>>
>> Fortunately it can be fixed, and it's safer to clearly specify things.
>> The prints are there because when the description is wrong enough to
>> cause things to blow up we can fail to boot or run messily and
>> forgetting to describe some supplies (or typoing so they haven't done
>> that) and people were having a hard time figuring out what might've
>> happened.
> 
> Yes, that's right. I sent a patch for such a warning in 2019 and pinged
> occationally. Still waiting for it to be merged :-\
> (https://lore.kernel.org/r/20190625100412.11815-1-u.kleine-koenig@pengutronix.de)
> 
>>> I think at least c) is easy to resolve because
>>> platform_get_irq_optional() isn't that old yet and mechanically
>>> replacing it by platform_get_irq_silent() should be easy and safe.
>>> And this is orthogonal to the discussion if -ENOXIO is a sensible return
>>> value and if it's as easy as it could be to work with errors on irq
>>> lookups.
>>
>> It'd certainly be good to name anything that doesn't correspond to one
>> of the existing semantics for the API (!) something different rather
>> than adding yet another potentially overloaded meaning.
> 
> It seems we're (at least) three who agree about this. Here is a patch
> fixing the name.

 From an API naming perspective this does not make much sense anymore 
with the name chosen, it is understood that whent he function is called 
platform_get_irq_optional(), optional applies to the IRQ. An optional 
IRQ is something people can reason about because it makes sense.

What is a a "silent" IRQ however? It does not apply to the object it is 
trying to fetch to anymore, but to the message that may not be printed 
in case the resource failed to be obtained, because said resource is 
optional. Woah, that's quite a stretch.

Following the discussion and original 2 patches set from Sergey, it is 
not entirely clear to me anymore what is it that we are trying to fix.

I nearly forgot, I would paint it blue, sky blue, not navy blue, not 
light blue ;)
-- 
Florian
