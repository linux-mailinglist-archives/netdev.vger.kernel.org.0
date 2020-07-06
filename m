Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0743D215DF1
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 20:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729704AbgGFSGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 14:06:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:59282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729589AbgGFSGg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jul 2020 14:06:36 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72D81206E2;
        Mon,  6 Jul 2020 18:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594058795;
        bh=k0rnAVgFoi5BlqTKo2TR58c7OZEdJPnSiojinDim6Tc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IUDbNPFfT7g57nbovI7b2nVV8uTvm3HFTpedO2XlXQNgc2LLEKJQ5pWSX1TuJ7UyK
         RYxxdcsNeLrEH0GaNEtv2MzYQWBPwy9w2u7l8UZJ/SP026LVG71Cb+Mw1pUosGUpEL
         NZ5/Z8uYBQsFNkfiJNG7r0lGZgQFk9+gzPHO7GsU=
Date:   Mon, 6 Jul 2020 11:06:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next 1/7] net: phy: at803x: Avoid comparison is
 always false warning
Message-ID: <20200706110633.5961fdc5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200705182921.887441-2-andrew@lunn.ch>
References: <20200705182921.887441-1-andrew@lunn.ch>
        <20200705182921.887441-2-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  5 Jul 2020 20:29:15 +0200 Andrew Lunn wrote:
> diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
> index 97cbe593f0ea..bdd84f6f0214 100644
> --- a/drivers/net/phy/at803x.c
> +++ b/drivers/net/phy/at803x.c
> @@ -400,7 +400,7 @@ static int at803x_parse_dt(struct phy_device *phydev)
>  {
>  	struct device_node *node = phydev->mdio.dev.of_node;
>  	struct at803x_priv *priv = phydev->priv;
> -	unsigned int sel, mask;
> +	unsigned int sel;

nit: ordering, otherwise feel free to add my rb on the series, thanks!

>  	u32 freq, strength;
