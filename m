Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6689D389AB1
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 02:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbhETBA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 21:00:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48334 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229498AbhETBA5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 21:00:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=x1FNX0sAiQIZUVXxQspUMNUpkt0RpICL5Fv/PRybBDM=; b=K5ONPXI5zpIYe16pjqMtnbj9lb
        RuDK6/Hk0MAO4x1JyyFFMk4/O7xxbYINyuD9h2mEeVLStv7aS08lvMGdSEUM+CF9Tc5CPJP+dCnl+
        ijrADNVnaIq1JSxufasy95Q5KzuBma9hX2cDTn2640DGAalQJAlEOz/0TKto3UJpxyTY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ljX21-0050dM-BI; Thu, 20 May 2021 02:59:21 +0200
Date:   Thu, 20 May 2021 02:59:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-staging@lists.linux.dev, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, Weijie Gao <weijie.gao@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH net-next v2 1/4] net: phy: add MediaTek Gigabit Ethernet
 PHY driver
Message-ID: <YKW0acoyM+5rVp0X@lunn.ch>
References: <20210519033202.3245667-1-dqfext@gmail.com>
 <20210519033202.3245667-2-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519033202.3245667-2-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static void mtk_gephy_config_init(struct phy_device *phydev)
> +{
> +	/* Disable EEE */
> +	phy_write_mmd(phydev, MDIO_MMD_AN, MDIO_AN_EEE_ADV, 0);

Is EEE broken on this PHY? Or is this just to get it into a defined
state?

Otherwise

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
