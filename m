Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD052EAD24
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 15:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730735AbhAEOH3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 5 Jan 2021 09:07:29 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:44687 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728264AbhAEOH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 09:07:27 -0500
X-Originating-IP: 90.89.98.255
Received: from xps13 (lfbn-tou-1-1535-bdcst.w90-89.abo.wanadoo.fr [90.89.98.255])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 4F0391C000F;
        Tue,  5 Jan 2021 14:06:37 +0000 (UTC)
Date:   Tue, 5 Jan 2021 15:06:36 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vkoul@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
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
Subject: Re: [PATCH 06/10] mtd: Remove drivers used by TX49xx
Message-ID: <20210105150636.175598fc@xps13>
In-Reply-To: <20210105140305.141401-7-tsbogend@alpha.franken.de>
References: <20210105140305.141401-1-tsbogend@alpha.franken.de>
        <20210105140305.141401-7-tsbogend@alpha.franken.de>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Thomas,

Thomas Bogendoerfer <tsbogend@alpha.franken.de> wrote on Tue,  5 Jan
2021 15:02:51 +0100:

> CPU support for TX49xx is getting removed, so remove MTD support for it.
> 
> Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

If the removal happens, you may take this patch through the mips tree.

Acked-by: Miquel Raynal <miquel.raynal@bootlin.com>

One less driver to convert to ->exec_op() :-)

> ---
>  drivers/mtd/maps/Kconfig                 |   6 -
>  drivers/mtd/maps/Makefile                |   1 -
>  drivers/mtd/maps/rbtx4939-flash.c        | 133 -------
>  drivers/mtd/nand/raw/Kconfig             |   7 -
>  drivers/mtd/nand/raw/Makefile            |   1 -
>  drivers/mtd/nand/raw/txx9ndfmc.c         | 423 -----------------------
>  include/linux/platform_data/txx9/ndfmc.h |  28 --
>  7 files changed, 599 deletions(-)
>  delete mode 100644 drivers/mtd/maps/rbtx4939-flash.c
>  delete mode 100644 drivers/mtd/nand/raw/txx9ndfmc.c
>  delete mode 100644 include/linux/platform_data/txx9/ndfmc.h

Thanks,
Miquèl
