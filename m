Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9CEC21C5DC
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 20:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728762AbgGKSpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 14:45:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58726 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728390AbgGKSpS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Jul 2020 14:45:18 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1juKUq-004eGe-99; Sat, 11 Jul 2020 20:45:12 +0200
Date:   Sat, 11 Jul 2020 20:45:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, davem@davemloft.net,
        robh@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/2] net: phy: DP83822: Add ability to
 advertise Fiber connection
Message-ID: <20200711184512.GR1014141@lunn.ch>
References: <20200710143733.30751-1-dmurphy@ti.com>
 <20200710143733.30751-3-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710143733.30751-3-dmurphy@ti.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +#define MII_DP83822_FIBER_ADVERTISE	(SUPPORTED_AUI | SUPPORTED_FIBRE | \
> +					 SUPPORTED_BNC | SUPPORTED_Pause | \
> +					 SUPPORTED_Asym_Pause | \
> +					 SUPPORTED_100baseT_Full)
> +
> +		/* Setup fiber advertisement */
> +		err = phy_modify_changed(phydev, MII_ADVERTISE,
> +					 ADVERTISE_1000XFULL |
> +					 ADVERTISE_1000XPAUSE |
> +					 ADVERTISE_1000XPSE_ASYM,
> +					 MII_DP83822_FIBER_ADVERTISE);

That looks very odd. SUPPORTED_AUI #define has nothing to do with
MII_ADVERTISE register. It is not a bit you can read/write in that
register.

	Andrew
