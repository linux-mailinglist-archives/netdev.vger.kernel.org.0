Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9D68225D27
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 13:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728444AbgGTLMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 07:12:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:52084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727094AbgGTLMN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 07:12:13 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 689E92073A;
        Mon, 20 Jul 2020 11:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595243533;
        bh=9Yy+1VjcfL5aQqBqsh+BDfHhT28teG125L+0sNy5ehc=;
        h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
        b=hAnDisAU5CkKAmHpE/TlDXaSa61cF0JA6RYkNQwVsbS2KHEPnHbsA064m/XFR1u/T
         z//PW9qlfb6Lwl2oAr78zQ6ONpyQ79rnqVCxfhGpQ0WbjKfNRt5Zp9J68zrYhDPdF8
         wriqqXI+iRwPMIMpW2FBryFhRaNOpStEuiSEMfmY=
Date:   Mon, 20 Jul 2020 12:12:00 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Guenter Roeck <linux@roeck-us.net>,
        Rob Herring <robh+dt@kernel.org>,
        Niklas <niklas.soderlund@ragnatech.se>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        "David S. Miller" <davem@davemloft.net>,
        Magnus Damm <magnus.damm@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     devicetree@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-i2c@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-spi@vger.kernel.org, Prabhakar <prabhakar.csengg@gmail.com>,
        netdev@vger.kernel.org, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Amit Kucheria <amit.kucheria@verdurent.com>
In-Reply-To: <1594811350-14066-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <1594811350-14066-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: Re: [PATCH 00/20] Add support for [H]SCIF/TMU/CMT/THS/SDHI/MSIOF/CAN[FD]/I2C/IIC/RWDT on R8A774E1
Message-Id: <159524352070.8289.9628744508547399473.b4-ty@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Jul 2020 12:08:50 +0100, Lad Prabhakar wrote:
> This patch series enables support for following on RZ/G2H SoC,
> * CPU OPP
> * THS
> * CMT/TMU
> * I2C/IIC
> * MSIOF
> * RWDT
> * SDHI
> * SCIF/HSCIF
> * CAN/CANFD
> 
> [...]

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git for-next

Thanks!

[1/1] spi: renesas,sh-msiof: Add r8a774e1 support
      commit: b4f7f5f5470588e45e5d004f1dc4887af20f18c0

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
