Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C86B1340F5E
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 21:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233092AbhCRUpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 16:45:21 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35470 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230220AbhCRUpM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 16:45:12 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lMzVs-00Bk7G-NL; Thu, 18 Mar 2021 21:45:00 +0100
Date:   Thu, 18 Mar 2021 21:45:00 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Bjarni Jonasson <bjarni.jonasson@microchip.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Quentin Schulz <quentin.schulz@bootlin.com>,
        Michael Walle <michael@walle.cc>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        UNGLinuxDriver <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next v1 2/3] net: phy: mscc: improved serdes
 calibration applied to VSC8584
Message-ID: <YFO7zN9iUMelyCdD@lunn.ch>
References: <20210318123851.10324-1-bjarni.jonasson@microchip.com>
 <20210318123851.10324-3-bjarni.jonasson@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210318123851.10324-3-bjarni.jonasson@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 18, 2021 at 01:38:50PM +0100, Bjarni Jonasson wrote:
> -static int vsc8584_config_init(struct phy_device *phydev)
> +static int vsc8584_config_host_serdes(struct phy_device *phydev)
>  {
> -	struct vsc8531_private *vsc8531 = phydev->priv;
> -	int ret, i;
> +	int ret;
>  	u16 val;
> +	struct vsc8531_private *vsc8531 = phydev->priv;

Reverse christmass tree. 

> +static int vsc8574_config_host_serdes(struct phy_device *phydev)
> +{
> +	int ret;
> +	u16 val;
> +	struct vsc8531_private *vsc8531 = phydev->priv;

Here as well

     Andrew
