Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B92D038D884
	for <lists+netdev@lfdr.de>; Sun, 23 May 2021 05:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231570AbhEWD12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 May 2021 23:27:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:37462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231523AbhEWD10 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 May 2021 23:27:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99E7F610FA;
        Sun, 23 May 2021 03:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621740361;
        bh=Bw3aflHWbXQS/vdgfvjgSfEYu6dVcAsoZ5F+6Nr8pNc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qHUzt018Ooj+awK55AjVwUMqu4z0eHietWktdWCgRgrui7DkFDVyPw07837nJZwFE
         12auBSFol1jUB/KHm9Dzh8lw9N40FyZf+zWNruVl+fShoYswsZVnD1lTHGE7CGsJSf
         m6y/DtA92ejR9vmCXGamIFpOu5U0DUaRLvEr3Pjt9gmfmmm+da7j3IOp2qpzq6/1vE
         xUWdNUDl7XuUezbNL2a33sDETsOlpCOD+OWxGGuUA6Y4m1/F03vHjU8VeAJdgieIrB
         N01e74Lhn748KGO89TEXIkc3a8RvC5LTDLXQo9fVNci8CDjpi5rbBcXzbSggYZ5qqG
         r9A8aqOjOoDtQ==
Date:   Sun, 23 May 2021 11:25:55 +0800
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
Subject: Re: [PATCH v3 0/2] remove different PHY fixups - dts part
Message-ID: <20210523032554.GR8194@dragon>
References: <20210511043039.20056-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511043039.20056-1-o.rempel@pengutronix.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 11, 2021 at 06:30:37AM +0200, Oleksij Rempel wrote:
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
> Oleksij Rempel (2):
>   ARM: dts: imx6: edmqmx6: set phy-mode to RGMII-ID
>   ARM: dts: imx6dl-riotboard: configure PHY clock and set proper EEE
>     value

Applied both, thanks.
