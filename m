Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 777C81791A6
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 14:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729543AbgCDNo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 08:44:56 -0500
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:52389 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgCDNoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 08:44:55 -0500
X-Originating-IP: 90.89.41.158
Received: from localhost (lfbn-tou-1-1473-158.w90-89.abo.wanadoo.fr [90.89.41.158])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 5FAA9FF805;
        Wed,  4 Mar 2020 13:44:52 +0000 (UTC)
Date:   Wed, 4 Mar 2020 14:44:51 +0100
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/3] marvell10g tunable and power saving
 support
Message-ID: <20200304134451.GK3179@kwain>
References: <20200303180747.GT25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200303180747.GT25745@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Russell,

On Tue, Mar 03, 2020 at 06:07:47PM +0000, Russell King - ARM Linux admin wrote:
> 
> This patch series adds support for:
> - mdix configuration (auto, mdi, mdix)
> - energy detect power down (edpd)
> - placing in edpd mode at probe
> 
> for both the 88x3310 and 88x2110 PHYs.
> 
> Antione, could you test this for the 88x2110 PHY please?

Tested-by: Antoine Tenart <antoine.tenart@bootlin.com>

Thanks!
Antoine

> v3: fix return code in get_tunable/set_tunable
> v2: fix comments from Antione.
> 
>  drivers/net/phy/marvell10g.c | 177 +++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 170 insertions(+), 7 deletions(-)
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> According to speedtest.net: 11.9Mbps down 500kbps up

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
