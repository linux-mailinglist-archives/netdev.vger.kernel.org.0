Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC3D02EC3BB
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 20:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbhAFTL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 14:11:27 -0500
Received: from smtprelay0107.hostedemail.com ([216.40.44.107]:59416 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725822AbhAFTLZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 14:11:25 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id BB2925C0;
        Wed,  6 Jan 2021 19:10:43 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1381:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3872:3876:4321:5007:6737:6738:7652:10004:10400:10848:11026:11232:11473:11658:11783:11914:12048:12297:12438:12740:12895:13069:13311:13357:13439:13894:14181:14659:14721:21080:21451:21611:21627:21939:21990:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:56,LUA_SUMMARY:none
X-HE-Tag: push15_3e110e4274e4
X-Filterd-Recvd-Size: 2304
Received: from [192.168.1.159] (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf11.hostedemail.com (Postfix) with ESMTPA;
        Wed,  6 Jan 2021 19:10:39 +0000 (UTC)
Message-ID: <b84dadc2e98b1986dc800c5f6f202880ed905b38.camel@perches.com>
Subject: Re: [PATCH 05/10] dma: tx49 removal
From:   Joe Perches <joe@perches.com>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Matt Mackall <mpm@selenic.com>,
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
Date:   Wed, 06 Jan 2021 11:10:38 -0800
In-Reply-To: <20210105140305.141401-6-tsbogend@alpha.franken.de>
References: <20210105140305.141401-1-tsbogend@alpha.franken.de>
         <20210105140305.141401-6-tsbogend@alpha.franken.de>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-01-05 at 15:02 +0100, Thomas Bogendoerfer wrote:
> Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
[]
> diff --git a/drivers/dma/txx9dmac.h b/drivers/dma/txx9dmac.h
[]
> @@ -26,11 +26,6 @@
>   * DMA channel.
>   */
>  
> 
> -#ifdef CONFIG_MACH_TX49XX
> -static inline bool txx9_dma_have_SMPCHN(void)
> -{
> -	return true;
> -}
>  #define TXX9_DMA_USE_SIMPLE_CHAIN
>  #else
>  static inline bool txx9_dma_have_SMPCHN(void)

This doesn't look like it compiles as there's now an #else
without an #if


