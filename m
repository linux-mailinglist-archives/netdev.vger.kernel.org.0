Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E04D2ED480
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 17:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728475AbhAGQle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 11:41:34 -0500
Received: from elvis.franken.de ([193.175.24.41]:34782 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727874AbhAGQld (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 11:41:33 -0500
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1kxYL4-0000Tv-00; Thu, 07 Jan 2021 17:40:42 +0100
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 98E5BC080E; Thu,  7 Jan 2021 17:40:15 +0100 (CET)
Date:   Thu, 7 Jan 2021 17:40:15 +0100
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Joe Perches <joe@perches.com>
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
        Takashi Iwai <tiwai@suse.com>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        dmaengine@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-watchdog@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH 05/10] dma: tx49 removal
Message-ID: <20210107164015.GA12533@alpha.franken.de>
References: <20210105140305.141401-1-tsbogend@alpha.franken.de>
 <20210105140305.141401-6-tsbogend@alpha.franken.de>
 <b84dadc2e98b1986dc800c5f6f202880ed905b38.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b84dadc2e98b1986dc800c5f6f202880ed905b38.camel@perches.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 06, 2021 at 11:10:38AM -0800, Joe Perches wrote:
> On Tue, 2021-01-05 at 15:02 +0100, Thomas Bogendoerfer wrote:
> > Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> []
> > diff --git a/drivers/dma/txx9dmac.h b/drivers/dma/txx9dmac.h
> []
> > @@ -26,11 +26,6 @@
> >   * DMA channel.
> >   */
> >  
> > 
> > -#ifdef CONFIG_MACH_TX49XX
> > -static inline bool txx9_dma_have_SMPCHN(void)
> > -{
> > -	return true;
> > -}
> >  #define TXX9_DMA_USE_SIMPLE_CHAIN
> >  #else
> >  static inline bool txx9_dma_have_SMPCHN(void)
> 
> This doesn't look like it compiles as there's now an #else
> without an #if

you are right, no idea what I had in mind while doing that.

Vinod,

as this patch series found a still active user of the platform,
could you drop the patch from your tree, or do you want a revert
from me ?

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
