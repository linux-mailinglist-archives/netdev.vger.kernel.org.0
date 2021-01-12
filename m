Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00FBF2F405C
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387751AbhALXe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 18:34:29 -0500
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:36775 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733047AbhALXe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 18:34:28 -0500
X-Originating-IP: 86.202.109.140
Received: from localhost (lfbn-lyo-1-13-140.w86-202.abo.wanadoo.fr [86.202.109.140])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id A8AE81BF20B;
        Tue, 12 Jan 2021 23:33:41 +0000 (UTC)
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Jaroslav Kysela <perex@perex.cz>, Matt Mackall <mpm@selenic.com>,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Vinod Koul <vkoul@kernel.org>, dmaengine@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        Richard Weinberger <richard@nod.at>,
        Alessandro Zummo <a.zummo@towertech.it>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Brown <broonie@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Takashi Iwai <tiwai@suse.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-crypto@vger.kernel.org,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-kernel@vger.kernel.org, linux-rtc@vger.kernel.org,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips@vger.kernel.org, linux-watchdog@vger.kernel.org,
        alsa-devel@alsa-project.org,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        linux-ide@vger.kernel.org, linux-spi@vger.kernel.org
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: Re: (subset) [PATCH 00/10] Remove support for TX49xx
Date:   Wed, 13 Jan 2021 00:33:30 +0100
Message-Id: <161049432258.352381.2804715824942772218.b4-ty@bootlin.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210105140305.141401-1-tsbogend@alpha.franken.de>
References: <20210105140305.141401-1-tsbogend@alpha.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Jan 2021 15:02:45 +0100, Thomas Bogendoerfer wrote:
> I couldn't find any buyable product other than reference boards using
> TX49xx CPUs. And since nobody showed interest in keeping support for
> it, it's time to remove it.
> 
> I've split up the removal into seperate parts for different maintainers.
> So if the patch fits your needs, please take it via your tree or
> give me an ack so I can apply them  the mips-next tree.
> 
> [...]

Applied, thanks!

[08/10] rtc: tx4939: Remove driver
        commit: 446667df283002fdda0530523347ffd1cf053373

Best regards,
-- 
Alexandre Belloni <alexandre.belloni@bootlin.com>
