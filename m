Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED9783ED757
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 15:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240918AbhHPNbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 09:31:45 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:33451 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241488AbhHPN3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 09:29:43 -0400
Received: (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id F3464E0009;
        Mon, 16 Aug 2021 13:29:07 +0000 (UTC)
Date:   Mon, 16 Aug 2021 15:29:07 +0200
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v2 net-next 0/2] Convert ocelot to phylink
Message-ID: <YRpoI2UOKXCG0gRx@piout.net>
References: <20210815014748.1262458-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210815014748.1262458-1-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 15/08/2021 04:47:46+0300, Vladimir Oltean wrote:
> The ocelot switchdev and felix dsa drivers are interesting because they
> target the same class of hardware switches but used in different modes.
> 
> Colin has an interesting use case where he wants to use a hardware
> switch supported by the ocelot switchdev driver with the felix dsa
> driver.
> 
> So far, the existing hardware revisions were similar between the ocelot
> and felix drivers, but not completely identical. With identical hardware,
> it is absurd that the felix driver uses phylink while the ocelot driver
> uses phylib - this should not be one of the differences between the
> switchdev and dsa driver, and we could eliminate it.
> 
> Colin will need the common phylink support in ocelot and felix when
> adding a phylink_pcs driver for the PCS1G block inside VSC7514, which
> will make the felix driver work with either the NXP or the Microchip PCS.
> 
> As usual, Alex, Horatiu, sorry for bugging you, but it would be
> appreciated if you could give this a quick run on actual VSC7514
> hardware (which I don't have) to make sure I'm not introducing any
> breakage.
> 

No worries, if there is any breakage, we'll fix it up.


-- 
Alexandre Belloni, co-owner and COO, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
