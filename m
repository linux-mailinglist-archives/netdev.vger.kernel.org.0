Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E92222EEE94
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 09:29:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727649AbhAHI2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 03:28:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:59414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727418AbhAHI2k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 03:28:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CC7A23435;
        Fri,  8 Jan 2021 08:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610094479;
        bh=SAoDiXJG+49pPIJcmLEdT3YdpudMLb3tXzuV+M1ddMg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EnEKOJIN+WnD4u6lFgo77faKCj54N+d/pFKhcGzW/Y3/Ccl68siuEONd2+MQVmWwA
         g8i5J1Jp9PRFqP+bjh1UVHmW6ZNZoM79Em/nHN5DHOG6ps9hEvQuax6LdoYTVQba6R
         W0M3rPvSPrbm/vYAaPU9CsppYeuXAhSoIAN8UGVK69VCDMDjU1FlkyeISfeCHTf0Cp
         UrPLrlJpGz0S4tUYkZu+D7Yp8uZm4/13PvNs53jDnTG1yuR/TZx3S6Q2A5kjWrfu5R
         w1MefWO2hD7veYyvb2xtc7eB2pAO3ZpInFWl5OgE2Cy2VRAsn/olPyc/xhF+bAgyze
         9qY+rCVqge15w==
Date:   Fri, 8 Jan 2021 13:57:54 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     Joe Perches <joe@perches.com>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Dan Williams <dan.j.williams@intel.com>,
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
Message-ID: <20210108082754.GW2771@vkoul-mobl>
References: <20210105140305.141401-1-tsbogend@alpha.franken.de>
 <20210105140305.141401-6-tsbogend@alpha.franken.de>
 <b84dadc2e98b1986dc800c5f6f202880ed905b38.camel@perches.com>
 <20210107164015.GA12533@alpha.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210107164015.GA12533@alpha.franken.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07-01-21, 17:40, Thomas Bogendoerfer wrote:
> On Wed, Jan 06, 2021 at 11:10:38AM -0800, Joe Perches wrote:
> > On Tue, 2021-01-05 at 15:02 +0100, Thomas Bogendoerfer wrote:
> > > Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> > []
> > > diff --git a/drivers/dma/txx9dmac.h b/drivers/dma/txx9dmac.h
> > []
> > > @@ -26,11 +26,6 @@
> > >   * DMA channel.
> > >   */
> > >  
> > > 
> > > -#ifdef CONFIG_MACH_TX49XX
> > > -static inline bool txx9_dma_have_SMPCHN(void)
> > > -{
> > > -	return true;
> > > -}
> > >  #define TXX9_DMA_USE_SIMPLE_CHAIN
> > >  #else
> > >  static inline bool txx9_dma_have_SMPCHN(void)
> > 
> > This doesn't look like it compiles as there's now an #else
> > without an #if
> 
> you are right, no idea what I had in mind while doing that.
> 
> Vinod,
> 
> as this patch series found a still active user of the platform,
> could you drop the patch from your tree, or do you want a revert
> from me ?

Dropped now

-- 
~Vinod
