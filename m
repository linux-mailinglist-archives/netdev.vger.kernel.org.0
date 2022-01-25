Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2B4249B47B
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 14:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1574909AbiAYNAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 08:00:36 -0500
Received: from mx1.tq-group.com ([93.104.207.81]:23582 "EHLO mx1.tq-group.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1359066AbiAYM4T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jan 2022 07:56:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1643115378; x=1674651378;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qmHH9G8TVCwWdo3uTby79rF+j0/3SailZLcBZpByLtg=;
  b=MB4CtmBY/kKUZUkbx858aLxhxtieEwNP3ArjS4boMb6N8oV/9x7+oe+7
   vBRLZ4YVEvZ/1JO2JM7klGULc8cKXlCkrMAODKUDhoRxB28SicAlb3MwA
   z4BaKpNCiXG7OZsbwPxYNCX20Nvck+6x4Hz/LZ+ldX2fSU+OXD7ABJ1L3
   qhCGVEW1kcKUCt7niPCL5EASKNk6v9jLS3splPrSApHD9OyMA3IK+xWnD
   qyyDv4o+OVOldOqDDmEWH7qIkVMd4VmaPCCCi8zZkUsMRkMvEb3Tf3C3R
   UUuaUcupgO11DYD/qAb/ED5oLYw/xNWULPE2SGkeHr9g/mXySY1kfHonr
   w==;
X-IronPort-AV: E=Sophos;i="5.88,315,1635199200"; 
   d="scan'208";a="21697221"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 25 Jan 2022 13:56:08 +0100
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Tue, 25 Jan 2022 13:56:09 +0100
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Tue, 25 Jan 2022 13:56:09 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1643115368; x=1674651368;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qmHH9G8TVCwWdo3uTby79rF+j0/3SailZLcBZpByLtg=;
  b=DZazWES6Z7qX74NIrM+i69skWo5ObJhdpFykKEns/urrKSV7FmjkeM2t
   YnBYyu8w987PyL5eZzlJ5LqVC1ihXP16gqLHPxLAtK9NLfyfbbnxMJjnE
   xkheSFbGqZGupY07RAOmoaOCOMZDwMnZDGO5NYbNANthuHRau78001vK2
   zJddEGsKEXtkeB0hUhuWkr3kF7tYn69GziEH85Y5mupr+z4GI7q8lpN8I
   tHnvDwxI2K5PUlNNRZSdV0LyBsYg2DAs8tg6Mfpsr/QsP6qCBNv225Vhv
   9E6GQFdFpwV+AAWYlFUvOpxFqY72lFs4EOW/dDH0eW9QyDbiOHxD6zCA3
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,315,1635199200"; 
   d="scan'208";a="21697220"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 25 Jan 2022 13:56:08 +0100
Received: from schifferm-ubuntu (SCHIFFERM-M2.tq-net.de [10.121.201.138])
        by vtuxmail01.tq-net.de (Postfix) with ESMTPA id 966B4280065;
        Tue, 25 Jan 2022 13:56:07 +0100 (CET)
Message-ID: <33e55c4c0a637b23d76db5d33872378ad04121bd.camel@ew.tq-group.com>
Subject: Re: [PATCH] driver core: platform: Rename
 platform_get_irq_optional() to platform_get_irq_silent()
From:   Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
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
        Niklas =?ISO-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@ragnatech.se>,
        linux-mediatek@lists.infradead.org,
        Brian Norris <computersforpeace@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Date:   Tue, 25 Jan 2022 13:56:05 +0100
In-Reply-To: <CAMuHMdXouECKa43OwUgQ6dA+gNeOqEZHZgOmQzqknzYiA924YA@mail.gmail.com>
References: <CAMuHMdWsMGPiQaPS0-PJ_+Mc5VQ37YdLfbHr_aS40kB+SfW-aw@mail.gmail.com>
         <20220112213121.5ruae5mxwj6t3qiy@pengutronix.de>
         <Yd9L9SZ+g13iyKab@sirena.org.uk>
         <20220113110831.wvwbm75hbfysbn2d@pengutronix.de>
         <YeA7CjOyJFkpuhz/@sirena.org.uk>
         <20220113194358.xnnbhsoyetihterb@pengutronix.de>
         <YeF05vBOzkN+xYCq@smile.fi.intel.com>
         <20220115154539.j3tsz5ioqexq2yuu@pengutronix.de>
         <YehdsUPiOTwgZywq@smile.fi.intel.com>
         <20220120075718.5qtrpc543kkykaow@pengutronix.de>
         <Ye6/NgfxsZnpXE09@smile.fi.intel.com>
         <15796e57-f7d4-9c66-3b53-0b026eaf31d8@omp.ru>
         <CAMuHMdXouECKa43OwUgQ6dA+gNeOqEZHZgOmQzqknzYiA924YA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-01-25 at 09:25 +0100, Geert Uytterhoeven wrote:
> Hi Sergey,
> 
> On Mon, Jan 24, 2022 at 10:02 PM Sergey Shtylyov <s.shtylyov@omp.ru>
> wrote:
> > On 1/24/22 6:01 PM, Andy Shevchenko wrote:
> > > > > > > > > It'd certainly be good to name anything that doesn't
> > > > > > > > > correspond to one
> > > > > > > > > of the existing semantics for the API (!) something
> > > > > > > > > different rather
> > > > > > > > > than adding yet another potentially overloaded
> > > > > > > > > meaning.
> > > > > > > > 
> > > > > > > > It seems we're (at least) three who agree about this.
> > > > > > > > Here is a patch
> > > > > > > > fixing the name.
> > > > > > > 
> > > > > > > And similar number of people are on the other side.
> > > > > > 
> > > > > > If someone already opposed to the renaming (and not only
> > > > > > the name) I
> > > > > > must have missed that.
> > > > > > 
> > > > > > So you think it's a good idea to keep the name
> > > > > > platform_get_irq_optional() despite the "not found" value
> > > > > > returned by it
> > > > > > isn't usable as if it were a normal irq number?
> > > > > 
> > > > > I meant that on the other side people who are in favour of
> > > > > Sergey's patch.
> > > > > Since that I commented already that I opposed the renaming
> > > > > being a standalone
> > > > > change.
> > > > > 
> > > > > Do you agree that we have several issues with
> > > > > platform_get_irq*() APIs?
> > [...]
> > > > > 2. The vIRQ0 handling: a) WARN() followed by b) returned
> > > > > value 0
> > > > 
> > > > I'm happy with the vIRQ0 handling. Today platform_get_irq() and
> > > > it's
> > > > silent variant returns either a valid and usuable irq number or
> > > > a
> > > > negative error value. That's totally fine.
> > > 
> > > It might return 0.
> > > Actually it seems that the WARN() can only be issued in two
> > > cases:
> > > - SPARC with vIRQ0 in one of the array member
> > > - fallback to ACPI for GPIO IRQ resource with index 0
> > 
> >    You have probably missed the recent discovery that
> > arch/sh/boards/board-aps4*.c
> > causes IRQ0 to be passed as a direct IRQ resource?
> 
> So far no one reported seeing the big fat warning ;-)

FWIW, we had a similar issue with an IRQ resource passed from the
tqmx86 MFD driver do the GPIO driver, which we noticed due to this
warning, and which was fixed
in a946506c48f3bd09363c9d2b0a178e55733bcbb6
and 9b87f43537acfa24b95c236beba0f45901356eb2.
I believe these changes are what promted this whole discussion and led
to my "Reported-by" on the patch?

It is not entirely clear to me when IRQ 0 is valid and when it isn't,
but the warning seems useful to me. Maybe it would make more sense to
warn when such an IRQ resource is registered for a platform device, and
not when it is looked up?

My opinion is that it would be very confusing if there are any places
in the kernel (on some platforms) where IRQ 0 is valid, but for
platform_get_irq() it would suddenly mean "not found". Keeping a
negative return value seems preferable to me for this reason.

(An alternative, more involved idea would be to add 1 to all IRQ
"cookies", so IRQ 0 would return 1, leaving 0 as a special value. I
have absolutely no idea how big the API surface is that would need
changes, and it is likely not worth the effort at all.)


> 
> > > The bottom line here is the SPARC case. Anybody familiar with the
> > > platform
> > > can shed a light on this. If there is no such case, we may remove
> > > warning
> > > along with ret = 0 case from platfrom_get_irq().
> > 
> >    I'm afraid you're too fast here... :-)
> >    We'll have a really hard time if we continue to allow IRQ0 to be
> > returned by
> > platform_get_irq() -- we'll have oto fileter it out in the callers
> > then...
> 
> So far no one reported seeing the big fat warning?
> 
> > > > > 3. The specific cookie for "IRQ not found, while no error
> > > > > happened" case
> > > > 
> > > > Not sure what you mean here. I have no problem that a situation
> > > > I can
> > > > cope with is called an error for the query function. I just do
> > > > error
> > > > handling and continue happily. So the part "while no error
> > > > happened" is
> > > > irrelevant to me.
> > > 
> > > I meant that instead of using special error code, 0 is very much
> > > good for
> > > the cases when IRQ is not found. It allows to distinguish -ENXIO
> > > from the
> > > low layer from -ENXIO with this magic meaning.
> > 
> >    I don't see how -ENXIO can trickle from the lower layers,
> > frankly...
> 
> It might one day, leading to very hard to track bugs.

As gregkh noted, changing the return value without also making the
compile fail will be a huge PITA whenever driver patches are back- or
forward-ported, as it would require subtle changes in error paths,
which can easily slip through unnoticed, in particular with half-
automated stable backports.

Even if another return value like -ENODEV might be better aligned with
...regulator_get_optional() and similar functions, or we even find a
way to make 0 usable for this, none of the proposed changes strike me
as big enough a win to outweigh the churn caused by making such a
change at all.

Kind regards,
Matthias



> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- 
> geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a
> hacker. But
> when I'm talking to journalists I just say "programmer" or something
> like that.
>                                 -- Linus Torvalds

