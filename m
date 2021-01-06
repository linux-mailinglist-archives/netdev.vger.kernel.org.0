Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8292EBB2C
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 09:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbhAFIiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 03:38:05 -0500
Received: from mail-oo1-f48.google.com ([209.85.161.48]:42963 "EHLO
        mail-oo1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbhAFIiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 03:38:04 -0500
Received: by mail-oo1-f48.google.com with SMTP id x203so586896ooa.9;
        Wed, 06 Jan 2021 00:37:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7OzcDXMwatEtiJomNBi1fhi3zuuxEWhyROAP2OwThNY=;
        b=EQ71xKWn6jEzk16xLKPw5tpURAioSNiH1WBf7m9kaDOShUYzWqDQ2s2wBGAg4P9H3J
         Mn4cea36V3yDJZZrvHcNzPWnFPRSJt/NLvTmeFnFgsH0whYPMW6IM5yqwm8jTr01KMl9
         ZZEi8CE6gy5fRn7AkvD+pvWO05miEnxQilI78QQh7PLj6v+I+0jCuNrUcUv+dhGZEZiv
         v0c6RD3T94Qw07f4jhO5ADNuzjlIEToYcUiiqj4wivYB6ei9N9PpupqdcyyFF4eRsE0X
         6gjpUPUB00Jm1SxknefDlc66XhPGX55zcpbDjCYhJR+gAdb4eHo6ri1rjep5ilymjGKm
         mnxQ==
X-Gm-Message-State: AOAM530lsAiSTA+Tt8ZbOkvKTVNeR7z6UzFGVNcIKOS+9jJv/Yr6Dj3n
        xMVsCDhZjaRef2yEGQJb1xW7zzukJ5CfJtulSPc=
X-Google-Smtp-Source: ABdhPJz+riLQ42T+q9EFB1XsbUqjCK7bS2nCYCFI4IXj5lNnjzpQBlfNrLzEuiXe37snmeLQrap5l7udgxcoLsEDH3o=
X-Received: by 2002:a4a:8353:: with SMTP id q19mr2071403oog.40.1609922242555;
 Wed, 06 Jan 2021 00:37:22 -0800 (PST)
MIME-Version: 1.0
References: <20210105140305.141401-1-tsbogend@alpha.franken.de>
In-Reply-To: <20210105140305.141401-1-tsbogend@alpha.franken.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 6 Jan 2021 09:37:11 +0100
Message-ID: <CAMuHMdX=trGqj8RzV7r1iTneqDjWOc4e1T-X+R_B34rxxhJpbg@mail.gmail.com>
Subject: Re: [PATCH 00/10] Remove support for TX49xx
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vkoul@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Mark Brown <broonie@kernel.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        dmaengine <dmaengine@vger.kernel.org>, linux-ide@vger.kernel.org,
        MTD Maling List <linux-mtd@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>, linux-rtc@vger.kernel.org,
        linux-spi <linux-spi@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Thomas,

CC Nemoto-san (de-facto TX49XX maintainer)

On Tue, Jan 5, 2021 at 3:03 PM Thomas Bogendoerfer
<tsbogend@alpha.franken.de> wrote:
> I couldn't find any buyable product other than reference boards using
> TX49xx CPUs. And since nobody showed interest in keeping support for
> it, it's time to remove it.

I have an RBTX4927 development board in my board farm, boot-test every
bi-weekly renesas-drivers release on it, and fix kernel issues when they
appear.

Is that sufficient to keep it?

TX49xx SoCs were used in Sony LocationFree base stations, running
VxWorks. You can no longer buy them.
I'm not aware of anyone ever porting Linux to them.
https://en.wikipedia.org/wiki/LocationFree_Player

>   spi: txx9: Remove driver

I only noticed the planned removal when I saw the SPI patch was applied.
Doesn't matter for me, as SPI is only present on TX4938, not on TX4927 ;-)

Gr{oetje,eeting}s,

                        Geert


--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
