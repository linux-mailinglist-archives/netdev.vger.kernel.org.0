Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ABDA2EBFF8
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 16:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbhAFO7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 09:59:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:35098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726326AbhAFO7W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 09:59:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5D8723110;
        Wed,  6 Jan 2021 14:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609945121;
        bh=fs4tnAAHZc6P9CcCZmtXnqhshJdz+3INo0fDCULFaD8=;
        h=From:To:In-Reply-To:References:Subject:Date:From;
        b=grRap1qACe13qOi+OZcRSFbPBF+dIr/ws3L/0hIw9hJfGzIKvP7l6ogZ4IDw43yGy
         2LHdh5/KkLIX5OZy0HUphNkwfKucd730v8Tp6LLuzacbNiujVv7S8AcFgKaat4EO7E
         y+/PvinZw7ISykZaboaWt60Ak3aP6L6FH/2ur96+2LlVa2dRoeg/GHIVTXjbL9m+/N
         lmUrNwQGiW3vl9pfoybJQC9JwzVTaaO03pya7nRF3kZVYLga8QDzM2brjULMEAV5En
         tz4bM66daxGgVwHYO/b7ctz5giI8LEijCXhmI8MPhXeH67zs/Q6iAskX79k3QrpAy9
         gww2PkLy1Faag==
From:   Mark Brown <broonie@kernel.org>
To:     Takashi Iwai <tiwai@suse.com>, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, Guenter Roeck <linux@roeck-us.net>,
        Dan Williams <dan.j.williams@intel.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        linux-rtc@vger.kernel.org,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-spi@vger.kernel.org, linux-ide@vger.kernel.org,
        Jaroslav Kysela <perex@perex.cz>, linux-crypto@vger.kernel.org,
        linux-watchdog@vger.kernel.org,
        Richard Weinberger <richard@nod.at>, dmaengine@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Matt Mackall <mpm@selenic.com>, alsa-devel@alsa-project.org,
        linux-mips@vger.kernel.org, Vignesh Raghavendra <vigneshr@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alessandro Zummo <a.zummo@towertech.it>
In-Reply-To: <20210105140305.141401-1-tsbogend@alpha.franken.de>
References: <20210105140305.141401-1-tsbogend@alpha.franken.de>
Subject: Re: (subset) [PATCH 00/10] Remove support for TX49xx
Message-Id: <160994509314.52132.9683741232298303961.b4-ty@kernel.org>
Date:   Wed, 06 Jan 2021 14:58:13 +0000
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

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-next

Thanks!

[10/10] ASoC: txx9: Remove driver
        commit: a8644292ea46064f990e4a3c4585bdb294c0d89a

All being well this means that it will be integrated into the linux-next
tree (usually sometime in the next 24 hours) and sent to Linus during
the next merge window (or sooner if it is a bug fix), however if
problems are discovered then the patch may be dropped or reverted.

You may get further e-mails resulting from automated or manual testing
and review of the tree, please engage with people reporting problems and
send followup patches addressing any issues that are reported if needed.

If any updates are required or you are submitting further changes they
should be sent as incremental updates against current git, existing
patches will not be replaced.

Please add any relevant lists and maintainers to the CCs when replying
to this mail.

Thanks,
Mark
