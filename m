Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A6042EB9EE
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 07:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbhAFGS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 01:18:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:47556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725562AbhAFGSz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 01:18:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA573207AB;
        Wed,  6 Jan 2021 06:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609913894;
        bh=5lp+13jiD6sIpu3g6HHgflH2MeBd+glQhPUXzn5sEb0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CakvhJq/S0InR70KIkE0nT8f4OsK8tazYsMYaSFjfmUD+Huax/XAoFChfqSwh2Ko3
         O2Yr5kMJTtRg84SKasb5ZjVbjiriRmjXC//Mp6svMTkOguihXcYD8Y7jrNAu5hhU9s
         NdGVzXNjj+s9GjbUJWIyH+IHiUgF6TmPNadTJjfPC+mngpvbFg7c/5UFpGfay3esh2
         cYJ3MG2vwyVhJDX/j+RFuMWxX9ZlY7uvVKpUVyQmSjwgaHtsGBtJTIpjBfFO76T5xG
         lQPLPifs3+qF6HuckWFMEKtmfxytThn8qOgCOh6FZpFqy+bNi0rc5xLf/Si1eeEIi4
         d5j4VPRJ+OyIg==
Date:   Wed, 6 Jan 2021 11:48:10 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     Matt Mackall <mpm@selenic.com>,
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
Message-ID: <20210106061810.GO2771@vkoul-mobl>
References: <20210105140305.141401-1-tsbogend@alpha.franken.de>
 <20210105140305.141401-6-tsbogend@alpha.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210105140305.141401-6-tsbogend@alpha.franken.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05-01-21, 15:02, Thomas Bogendoerfer wrote:
> Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

Applied after fixing subsystem name, thanks

-- 
~Vinod
