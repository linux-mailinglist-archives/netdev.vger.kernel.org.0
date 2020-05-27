Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8E11E39BE
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 09:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728762AbgE0HBD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 27 May 2020 03:01:03 -0400
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:62379 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbgE0HBC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 03:01:02 -0400
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id F1F1940009;
        Wed, 27 May 2020 07:00:59 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200526170100.GM768009@lunn.ch>
References: <20200526162256.466885-1-antoine.tenart@bootlin.com> <20200526170100.GM768009@lunn.ch>
To:     Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next 0/4] net: phy: mscc-miim: reduce waiting time between MDIO transactions
From:   Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        alexandre.belloni@bootlin.com, thomas.petazzoni@bootlin.com,
        allan.nielsen@microchip.com
Message-ID: <159056285904.265465.1821646548974311512@kwain>
Date:   Wed, 27 May 2020 09:00:59 +0200
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Quoting Andrew Lunn (2020-05-26 19:01:00)
> On Tue, May 26, 2020 at 06:22:52PM +0200, Antoine Tenart wrote:
> > 
> > This series aims at reducing the waiting time between MDIO transactions
> > when using the MSCC MIIM MDIO controller.
> 
> There are a couple of other things you can look at:
> 
> Can you disable the pre-amble on the MDIO transaction. It requires
> that both the bus master and all devices on the bus support it, but
> when it is usable, you half the number of bits sent over the wire.
> 
> Can you control the frequency of MDC? 802.3 says 2.5MHz, but many
> devices support higher speeds. Again, you need all devices on the bus
> to support the speed.
> 
> When accessing raw TDR data for cable tests i also have a lot of PHY
> accesses. I implemented both of these for the FEC MDIO bus, and made
> it a lot faster.

Thanks for the tips!

Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
