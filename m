Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC9231E840D
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 18:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbgE2Qvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 12:51:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:43274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726616AbgE2Qvw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 12:51:52 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2867D207BC;
        Fri, 29 May 2020 16:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590771111;
        bh=9G4SXdzVTTuVKU3TFoSGLy1WOjJ7O3h3F2pyUxL2bZs=;
        h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
        b=YbjULt5sQyIChLnD+WAyKE/2RUP0ecbWC7n1YAW18hc+gcDAbs/1ySRmBOAH1iXEc
         HIipkmvr9NKKphDbGsswhKsBnpvsxNkA4eVo145vc1QiNuJ2FqdwWt3zhId/U+UluC
         exXK8gi8dWdP7T0iW6T01y08orHcPbjUo8tQDd4U=
Date:   Fri, 29 May 2020 17:51:49 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net
Cc:     linux@armlinux.org.uk, claudiu.manoil@nxp.com,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, andrew@lunn.ch,
        allan.nielsen@microchip.com, antoine.tenart@bootlin.com,
        netdev@vger.kernel.org, fido_max@inbox.ru,
        alexandre.belloni@bootlin.com, radu-andrei.bulie@nxp.com,
        horatiu.vultur@microchip.com, alexandru.marginean@nxp.com,
        UNGLinuxDriver@microchip.com, madalin.bucur@oss.nxp.com
In-Reply-To: <20200527234113.2491988-1-olteanv@gmail.com>
References: <20200527234113.2491988-1-olteanv@gmail.com>
Subject: Re: [PATCH net-next 00/11] New DSA driver for VSC9953 Seville switch
Message-Id: <159077110912.28779.6447184623286195668.b4-ty@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 May 2020 02:41:02 +0300, Vladimir Oltean wrote:
> Looking at the Felix and Ocelot drivers, Maxim asked if it would be
> possible to use them as a base for a new driver for the switch inside
> NXP T1040. Turns out, it is! The result is a driver eerily similar to
> Felix.
> 
> The biggest challenge seems to be getting register read/write API
> generic enough to cover such wild bitfield variations between hardware
> generations. There is a patch on the regmap core which I would like to
> get in through the networking subsystem, if possible (and if Mark is
> ok), since it's a trivial addition.
> 
> [...]

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git for-next

Thanks!

[1/1] regmap: add helper for per-port regfield initialization
      commit: 8baebfc2aca26e3fa67ab28343671b82be42b22c

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
