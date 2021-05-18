Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2D86387481
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 11:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347641AbhERJB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 05:01:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:33974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346873AbhERJBV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 May 2021 05:01:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68A2061209;
        Tue, 18 May 2021 08:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621328372;
        bh=UgRUbJBBnzpQLR7EDO5qOM4DnpZGVxZ1RG6udzAgiSI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cgIBNr/pGVp/2pKxnCVr3/1dfbYoIilVzSYhr8SiMXo35yUdwOvOqcGNOC6paBu5j
         VUhb4VSaRcSiLLutDH0ZifW8KQyhfEQYIDVfdj+Rbu07DOd9irFFpLhe8Fr1J4H2SG
         3RFRqbqyByyQw9Z49WATQFDdvf9vGS9m5RhYHfayhwyeKzJg/OTgmMLESJvzp4Y0LZ
         ZGnCr632Km3OG02yjd4k5lW6MzXDTieI44HgoOff0oX/mApS5Fy22ADiV56qBD11dz
         gZIOw33NJewTZLKIzlzlhpLLSpSYD0xs6aVfQQFt0FeCjM+4Uv0aO33sMGVP97gXEv
         xeKXASFC/tZxw==
Date:   Tue, 18 May 2021 11:59:27 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Peter Geis <pgwipeout@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-rockchip@lists.infradead.org
Subject: Re: [PATCH] net: phy: add driver for Motorcomm yt8511 phy
Message-ID: <YKOB7y/9IptUvo4k@unreal>
References: <20210511214605.2937099-1-pgwipeout@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511214605.2937099-1-pgwipeout@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 11, 2021 at 05:46:06PM -0400, Peter Geis wrote:
> Add a driver for the Motorcomm yt8511 phy that will be used in the
> production Pine64 rk3566-quartz64 development board.
> It supports gigabit transfer speeds, rgmii, and 125mhz clk output.
> 
> Signed-off-by: Peter Geis <pgwipeout@gmail.com>
> ---
>  MAINTAINERS                 |  6 +++
>  drivers/net/phy/Kconfig     |  6 +++
>  drivers/net/phy/Makefile    |  1 +
>  drivers/net/phy/motorcomm.c | 85 +++++++++++++++++++++++++++++++++++++
>  4 files changed, 98 insertions(+)
>  create mode 100644 drivers/net/phy/motorcomm.c

<...>

> +static const struct mdio_device_id __maybe_unused motorcomm_tbl[] = {
> +	{ PHY_ID_MATCH_EXACT(PHY_ID_YT8511) },
> +	{ /* sentinal */ }
> +}

Why is this "__maybe_unused"? This *.c file doesn't have any compilation option
to compile part of it.

The "__maybe_unused" is not needed in this case.

Thanks
