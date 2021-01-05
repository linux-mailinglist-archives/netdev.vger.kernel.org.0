Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB8262EAFBB
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 17:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729248AbhAEQJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 11:09:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:37918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726571AbhAEQJ2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 11:09:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 519B722C9F;
        Tue,  5 Jan 2021 16:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609862927;
        bh=wJQJGEVMiFp+U9i3KB68KovC4I4ZjyrsTucyHvp+mYU=;
        h=From:To:In-Reply-To:References:Subject:Date:From;
        b=RAq1XL/BRN8XRTSri4cXSrqvujM81ioR4+GUq1AHhXecaj7QiUWiQ88dIVugFlchl
         PLj0Tjq2k++ZbgqOoM47jhkKnKK69EB4dWwbb4SWWCCEgHFfJaIdqiA9j1o8CIDFGb
         VmlHy1C+y878dkjkF4kZd8pHUgF6pphBI9JLc1TNqEr7Y5H/GxrnO2q9j6hXU6/0O6
         F/BC+FOE5W7Pq7VFBMxUdC2Yx5x5dsQz87UyJo6xH3cai7eqArOI3dLNh6M9KIfFCe
         bMnxRc9j/jnfB58g5Lt3IlL35kE9dM38IFdhf5NXVGmzl9LHHUkqI+ApfU/oQDMsjA
         e2FHKR5qKJKMQ==
From:   Mark Brown <broonie@kernel.org>
To:     linux-rtc@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        linux-mtd@lists.infradead.org, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, alsa-devel@alsa-project.org,
        dmaengine@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Dan Williams <dan.j.williams@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-mips@vger.kernel.org, Takashi Iwai <tiwai@suse.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Jaroslav Kysela <perex@perex.cz>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-watchdog@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Vinod Koul <vkoul@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-spi@vger.kernel.org
In-Reply-To: <20210105140305.141401-1-tsbogend@alpha.franken.de>
References: <20210105140305.141401-1-tsbogend@alpha.franken.de>
Subject: Re: (subset) [PATCH 00/10] Remove support for TX49xx
Message-Id: <160986289007.50207.17900821173530027212.b4-ty@kernel.org>
Date:   Tue, 05 Jan 2021 16:08:10 +0000
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

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git for-next

Thanks!

[04/10] spi: txx9: Remove driver
        commit: 74523a5dae0c96d6503fe72da66ee37fd23eb8f5

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
