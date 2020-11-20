Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 579C52B9EF8
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 01:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727298AbgKTAA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 19:00:59 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:40052 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727246AbgKTAA7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 19:00:59 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kftr8-0081ur-E9; Fri, 20 Nov 2020 01:00:50 +0100
Date:   Fri, 20 Nov 2020 01:00:50 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Antoine Tenart <atenart@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: net: phy: Dealing with 88e1543 dual-port mode
Message-ID: <20201120000050.GV1804098@lunn.ch>
References: <20201119152246.085514e1@bootlin.com>
 <20201119145500.GL1551@shell.armlinux.org.uk>
 <20201119162451.4c8d220d@bootlin.com>
 <87k0uh9dd0.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k0uh9dd0.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> E.g. at Westermo we make switches with M12/M12X connectors [1] that
> sometimes have a 1G PHY behind a 2-pair M12 connector (for complicated
> legacy reasons). In such cases we have to remove 1000-HD/FD from the
> advertised link modes. Being able to describe that in the DT with
> something like:
> 
> ethernet-phy@0 {
>     mdi = "2-pair";
> };

We already have a max-speed property which could be used to do this.
It will remove the 1000-HD/FD from the link mode if you set it to 100.

   Andrew
