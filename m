Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87275263388
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 19:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731232AbgIIRFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 13:05:20 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52594 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730413AbgIIPnA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 11:43:00 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kG0V6-00DvHc-T5; Wed, 09 Sep 2020 15:51:04 +0200
Date:   Wed, 9 Sep 2020 15:51:04 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Divya Koppera <Divya.Koppera@microchip.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, marex@denx.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v1 net-next] net: phy: mchp: Add support for LAN8814 QUAD
 PHY
Message-ID: <20200909135104.GG3290129@lunn.ch>
References: <20200909093419.32102-1-Divya.Koppera@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200909093419.32102-1-Divya.Koppera@microchip.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -1314,6 +1314,21 @@ static struct phy_driver ksphy_driver[] = {
>  	.get_stats	= kszphy_get_stats,
>  	.suspend	= genphy_suspend,
>  	.resume		= kszphy_resume,
> +}, {
> +	.phy_id		= PHY_ID_LAN8814,
> +	.phy_id_mask	= MICREL_PHY_ID_MASK,
> +	.name		= "Microchip INDY Gigabit Quad PHY",
> +	.driver_data	= &ksz9021_type,
> +	.probe		= kszphy_probe,
> +	.get_features	= ksz9031_get_features,

static int ksz9031_get_features(struct phy_device *phydev)
{
	int ret;

	ret = genphy_read_abilities(phydev);
	if (ret < 0)
		return ret;

	/* Silicon Errata Sheet (DS80000691D or DS80000692D):


Hi Divya

Do these erratas apply to this PHY as well?

   Andrew
