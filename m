Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8F9D38D88B
	for <lists+netdev@lfdr.de>; Sun, 23 May 2021 05:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbhEWDfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 May 2021 23:35:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:42648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231531AbhEWDfy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 May 2021 23:35:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A7DC61164;
        Sun, 23 May 2021 03:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621740868;
        bh=HhFxdBT1epQNNvTBkIY3LVRCuaHvlaJA5VJBEje+L4E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JGc8FAM1eJB6PhnU23H1RP5UgsbqiRLerp5Ev3mREPePNLxK1RTVokmsBQDIvudyI
         1SALGqCJOqe2BJvDEyXmLVlY/sSlvtOQyKemcjeGiu/FTk/xhnj3ZrqcWVqcSTNgju
         EY8xkkDzgiGjtofPWHEX4Ibdyl4Z4nQbX/etVHeZcR9xZoVK700aXXwlWaFruH5/yt
         P7AA+5CCwyPySc+cQFdPyJ0gipJzNINxX4P4bsjc/EvROiRpvr77ZSlKpWsnK8kVzO
         CqJvQ9fEGRFY2nGK6kFvb/+nryCWbq3DZNBlfQFmk2mJUUMt9q6J6+olsu6WqyGd4l
         AVc1CJrDyqDgA==
Date:   Sun, 23 May 2021 11:34:22 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Sascha Hauer <s.hauer@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com,
        Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: Re: [PATCH v3 0/7] remove different PHY fixups
Message-ID: <20210523033421.GS8194@dragon>
References: <20210511043735.30557-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511043735.30557-1-o.rempel@pengutronix.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 11, 2021 at 06:37:28AM +0200, Oleksij Rempel wrote:
> changes v3:
> - split arch and dts changes
> 
> changes v2:
> - rebase against latest kernel
> - fix networking on RIoTBoard
> 
> This patch series tries to remove most of the imx6 and imx7 board
> specific PHY configuration via fixup, as this breaks the PHYs when
> connected to switch chips or USB Ethernet MACs.
> 
> Each patch has the possibility to break boards, but contains a
> recommendation to fix the problem in a more portable and future-proof
> way.
> 
> Oleksij Rempel (7):
>   ARM i.MX6q: remove PHY fixup for KSZ9031
>   ARM i.MX6q: remove part of ar8031_phy_fixup()
>   ARM i.MX6q: remove BMCR_PDOWN handler in ar8035_phy_fixup()
>   ARM i.MX6q: remove clk-out fixup for the Atheros AR8031 and AR8035
>     PHYs
>   ARM i.MX6q: remove Atheros AR8035 SmartEEE fixup

Changed the subject prefix to 'ARM: imx6q: ...', and applied the series.

Shawn

>   ARM: imx6sx: remove Atheros AR8031 PHY fixup
>   ARM: imx7d: remove Atheros AR8031 PHY fixup
> 
>  arch/arm/mach-imx/mach-imx6q.c  | 85 ---------------------------------
>  arch/arm/mach-imx/mach-imx6sx.c | 26 ----------
>  arch/arm/mach-imx/mach-imx7d.c  | 22 ---------
>  3 files changed, 133 deletions(-)
> 
> -- 
> 2.29.2
> 
