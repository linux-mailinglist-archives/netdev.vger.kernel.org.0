Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F19822EC384
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 19:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbhAFStq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 13:49:46 -0500
Received: from elvis.franken.de ([193.175.24.41]:33363 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726249AbhAFSto (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 13:49:44 -0500
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1kxDra-0005fm-00; Wed, 06 Jan 2021 19:48:54 +0100
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 4B798C0808; Wed,  6 Jan 2021 19:48:39 +0100 (CET)
Date:   Wed, 6 Jan 2021 19:48:39 +0100
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
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
Subject: Re: [PATCH 00/10] Remove support for TX49xx
Message-ID: <20210106184839.GA7773@alpha.franken.de>
References: <20210105140305.141401-1-tsbogend@alpha.franken.de>
 <CAMuHMdX=trGqj8RzV7r1iTneqDjWOc4e1T-X+R_B34rxxhJpbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdX=trGqj8RzV7r1iTneqDjWOc4e1T-X+R_B34rxxhJpbg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 06, 2021 at 09:37:11AM +0100, Geert Uytterhoeven wrote:
> Hi Thomas,
> 
> CC Nemoto-san (de-facto TX49XX maintainer)
> 
> On Tue, Jan 5, 2021 at 3:03 PM Thomas Bogendoerfer
> <tsbogend@alpha.franken.de> wrote:
> > I couldn't find any buyable product other than reference boards using
> > TX49xx CPUs. And since nobody showed interest in keeping support for
> > it, it's time to remove it.
> 
> I have an RBTX4927 development board in my board farm, boot-test every
> bi-weekly renesas-drivers release on it, and fix kernel issues when they
> appear.
> 
> Is that sufficient to keep it?

for me it is. But now we probaly need some reverts then...

I wonder whether you have seen my mail about the removal

https://lore.kernel.org/linux-mips/20201207105627.GA15866@alpha.franken.de

and my call for people owning MIPS machines

https://lore.kernel.org/linux-mips/20200227144910.GA25011@alpha.franken.de/

Still "unclaimed" machines are

IMG Pistachio SoC based boards (MACH_PISTACHIO(
Toshiba TX39 series based machines (MACH_TX39XX)
NEC VR4100 series based machines (MACH_VR41XX)
Netlogic XLR/XLS based systems (NLM_XLR_BOARD)
Netlogic XLP based systems (NLM_XLP_BOARD)
Sibyte BCM91120C-CRhine (SIBYTE_CRHINE)
Sibyte BCM91120x-Carmel (SIBYTE_CARMEL)
Sibyte BCM91125C-CRhone (SIBYTE_CRHONE)
Sibyte BCM91125E-Rhone (SIBYTE_RHONE)
Sibyte BCM91250C2-LittleSur (SIBYTE_LITTLESUR)
Sibyte BCM91250E-Sentosa (SIBYTE_SENTOSA)

Is there something on this list you also regulary use ?

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
