Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF2311048B9
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 03:49:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbfKUCtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 21:49:33 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48902 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725854AbfKUCtd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 21:49:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=X2dTZUuEhVfJVuxVb7eF/imdZcpp2QFjkGnvhLREBoc=; b=VVrASxLXl7hGmVwDURYGWD2n8b
        Vf2a2mBZECbxqWkv/8QPGb+3+LwCb/caKzl0KLTqGNxkcS1+OKsWqOzUdYnEF3yx/yb8O3FWdMlcW
        MNb6BQcihKcNuQZATdJl64geMuHysrCyd3C9qoMuGXZ6LWocWzRYYelDxplOwJU95Yy8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iXcXA-0007Aw-VN; Thu, 21 Nov 2019 03:49:28 +0100
Date:   Thu, 21 Nov 2019 03:49:28 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     netdev@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH 4/5] net: dsa: ocelot: define PTP registers for
 felix_vsc9959
Message-ID: <20191121024928.GN18325@lunn.ch>
References: <20191120082318.3909-1-yangbo.lu@nxp.com>
 <20191120082318.3909-5-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120082318.3909-5-yangbo.lu@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static const u32 vsc9959_ptp_regmap[] = {
> +	REG(PTP_PIN_CFG,                   0x000000),
> +	REG(PTP_PIN_TOD_SEC_MSB,           0x000004),
> +	REG(PTP_PIN_TOD_SEC_LSB,           0x000008),
> +	REG(PTP_PIN_TOD_NSEC,              0x00000c),
> +	REG(PTP_CFG_MISC,                  0x0000a0),
> +	REG(PTP_CLK_CFG_ADJ_CFG,           0x0000a4),
> +	REG(PTP_CLK_CFG_ADJ_FREQ,          0x0000a8),
> +};
> +

> +	[PTP] = {
> +		.start	= 0x0090000,
> +		.end	= 0x00900cb,
> +		.name	= "ptp",
> +	},

Seems like an odd end value. Is the last word used for something else?

Also, the last regmap register you defined is 0xa8. So could end
actually be 900ab?

	 Andrew
