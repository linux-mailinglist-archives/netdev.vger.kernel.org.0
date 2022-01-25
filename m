Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4BB49AE24
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 09:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1451264AbiAYIgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 03:36:31 -0500
Received: from mail-qv1-f51.google.com ([209.85.219.51]:38608 "EHLO
        mail-qv1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378752AbiAYIb3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 03:31:29 -0500
Received: by mail-qv1-f51.google.com with SMTP id b12so4529982qvz.5;
        Tue, 25 Jan 2022 00:31:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0nj3tQtaS2Jftix8pFrL2+Rvw9SRm0Q+IWJ3wAkzl0s=;
        b=WB9h79SHkFBh8zEGcIeB7E5HjafQdfpc08WU2JJUiiPYqy9M9KJ/1Obbo3AoYDuZM1
         L1ZQ35GjmvhlgLfu/XAavya6XuAAD+5NoospC4UKkm5iDbh8x7/5myPjkvSpHJx+1S1t
         MJoJYqGdK7EVegPvSwcyshqEkzm5FfysYVYEy17n9KIBsqKUHA751y1SqRy7fxRZTJIJ
         XwSLmmOSBQVCaiCt5Lp+1+6RoKze+67Ygj9GhfzsJEBTjeJWUcv/cptoSXjrRnyPWrD9
         Bp/hDQh9OiCwjzfUPD47V6Yg/M2Hs5SNbYhyiB9BDtvD2gf0W0vSHVNHDpyLrrFV4q7J
         DrAg==
X-Gm-Message-State: AOAM533jz79E3Mb70YzDiCSOaQNE/eMwJqeM8QoYVLs1gyCdu9MFvtXH
        rBe1oSOzAy87kimGpLjSGZsXQpf32NMPiu/s
X-Google-Smtp-Source: ABdhPJxcd215HVffZw8fBf1K2zIojl7li593qA7bzWJqK/5Jrw3HmZ2JtI9Yl6fpG+4KjmAtaakXdQ==
X-Received: by 2002:a05:6214:3006:: with SMTP id ke6mr15873363qvb.59.1643099481113;
        Tue, 25 Jan 2022 00:31:21 -0800 (PST)
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com. [209.85.219.50])
        by smtp.gmail.com with ESMTPSA id d8sm8722166qtd.70.2022.01.25.00.31.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 00:31:21 -0800 (PST)
Received: by mail-qv1-f50.google.com with SMTP id k4so24225123qvt.6;
        Tue, 25 Jan 2022 00:31:20 -0800 (PST)
X-Received: by 2002:a05:6102:a04:: with SMTP id t4mr1874173vsa.77.1643099137125;
 Tue, 25 Jan 2022 00:25:37 -0800 (PST)
MIME-Version: 1.0
References: <CAMuHMdWsMGPiQaPS0-PJ_+Mc5VQ37YdLfbHr_aS40kB+SfW-aw@mail.gmail.com>
 <20220112213121.5ruae5mxwj6t3qiy@pengutronix.de> <Yd9L9SZ+g13iyKab@sirena.org.uk>
 <20220113110831.wvwbm75hbfysbn2d@pengutronix.de> <YeA7CjOyJFkpuhz/@sirena.org.uk>
 <20220113194358.xnnbhsoyetihterb@pengutronix.de> <YeF05vBOzkN+xYCq@smile.fi.intel.com>
 <20220115154539.j3tsz5ioqexq2yuu@pengutronix.de> <YehdsUPiOTwgZywq@smile.fi.intel.com>
 <20220120075718.5qtrpc543kkykaow@pengutronix.de> <Ye6/NgfxsZnpXE09@smile.fi.intel.com>
 <15796e57-f7d4-9c66-3b53-0b026eaf31d8@omp.ru>
In-Reply-To: <15796e57-f7d4-9c66-3b53-0b026eaf31d8@omp.ru>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 25 Jan 2022 09:25:25 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXouECKa43OwUgQ6dA+gNeOqEZHZgOmQzqknzYiA924YA@mail.gmail.com>
Message-ID: <CAMuHMdXouECKa43OwUgQ6dA+gNeOqEZHZgOmQzqknzYiA924YA@mail.gmail.com>
Subject: Re: [PATCH] driver core: platform: Rename platform_get_irq_optional()
 to platform_get_irq_silent()
To:     Sergey Shtylyov <s.shtylyov@omp.ru>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        KVM list <kvm@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>, linux-iio@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Guenter Roeck <groeck@chromium.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        MTD Maling List <linux-mtd@lists.infradead.org>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        linux-phy@lists.infradead.org, Jiri Slaby <jirislaby@kernel.org>,
        openipmi-developer@lists.sourceforge.net,
        Khuong Dinh <khuong@os.amperecomputing.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Kamal Dasu <kdasu.kdev@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        Robert Richter <rric@kernel.org>,
        Saravanan Sekar <sravanhome@gmail.com>,
        Corey Minyard <minyard@acm.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        John Garry <john.garry@huawei.com>,
        Peter Korsgaard <peter@korsgaard.com>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Mark Gross <markgross@kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Sebastian Reichel <sre@kernel.org>,
        Eric Auger <eric.auger@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Takashi Iwai <tiwai@suse.com>,
        platform-driver-x86@vger.kernel.org,
        Benson Leung <bleung@chromium.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-edac@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Mun Yew Tham <mun.yew.tham@intel.com>,
        Hans de Goede <hdegoede@redhat.com>, netdev@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux-spi <linux-spi@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        James Morse <james.morse@arm.com>,
        Zha Qipeng <qipeng.zha@intel.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Richard Weinberger <richard@nod.at>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        linux-mediatek@lists.infradead.org,
        Brian Norris <computersforpeace@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sergey,

On Mon, Jan 24, 2022 at 10:02 PM Sergey Shtylyov <s.shtylyov@omp.ru> wrote:
> On 1/24/22 6:01 PM, Andy Shevchenko wrote:
> >>>>>>> It'd certainly be good to name anything that doesn't correspond to one
> >>>>>>> of the existing semantics for the API (!) something different rather
> >>>>>>> than adding yet another potentially overloaded meaning.
> >>>>>>
> >>>>>> It seems we're (at least) three who agree about this. Here is a patch
> >>>>>> fixing the name.
> >>>>>
> >>>>> And similar number of people are on the other side.
> >>>>
> >>>> If someone already opposed to the renaming (and not only the name) I
> >>>> must have missed that.
> >>>>
> >>>> So you think it's a good idea to keep the name
> >>>> platform_get_irq_optional() despite the "not found" value returned by it
> >>>> isn't usable as if it were a normal irq number?
> >>>
> >>> I meant that on the other side people who are in favour of Sergey's patch.
> >>> Since that I commented already that I opposed the renaming being a standalone
> >>> change.
> >>>
> >>> Do you agree that we have several issues with platform_get_irq*() APIs?
> [...]
> >>> 2. The vIRQ0 handling: a) WARN() followed by b) returned value 0
> >>
> >> I'm happy with the vIRQ0 handling. Today platform_get_irq() and it's
> >> silent variant returns either a valid and usuable irq number or a
> >> negative error value. That's totally fine.
> >
> > It might return 0.
> > Actually it seems that the WARN() can only be issued in two cases:
> > - SPARC with vIRQ0 in one of the array member
> > - fallback to ACPI for GPIO IRQ resource with index 0
>
>    You have probably missed the recent discovery that arch/sh/boards/board-aps4*.c
> causes IRQ0 to be passed as a direct IRQ resource?

So far no one reported seeing the big fat warning ;-)

> > The bottom line here is the SPARC case. Anybody familiar with the platform
> > can shed a light on this. If there is no such case, we may remove warning
> > along with ret = 0 case from platfrom_get_irq().
>
>    I'm afraid you're too fast here... :-)
>    We'll have a really hard time if we continue to allow IRQ0 to be returned by
> platform_get_irq() -- we'll have oto fileter it out in the callers then...

So far no one reported seeing the big fat warning?

> >>> 3. The specific cookie for "IRQ not found, while no error happened" case
> >>
> >> Not sure what you mean here. I have no problem that a situation I can
> >> cope with is called an error for the query function. I just do error
> >> handling and continue happily. So the part "while no error happened" is
> >> irrelevant to me.
> >
> > I meant that instead of using special error code, 0 is very much good for
> > the cases when IRQ is not found. It allows to distinguish -ENXIO from the
> > low layer from -ENXIO with this magic meaning.
>
>    I don't see how -ENXIO can trickle from the lower layers, frankly...

It might one day, leading to very hard to track bugs.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
