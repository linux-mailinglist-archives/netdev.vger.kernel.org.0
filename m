Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0967326EA9D
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 03:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgIRBqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 21:46:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41916 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbgIRBqT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 21:46:19 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kJ5TY-00FA8d-Qm; Fri, 18 Sep 2020 03:46:12 +0200
Date:   Fri, 18 Sep 2020 03:46:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, opendmb@gmail.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:BROADCOM ETHERNET PHY DRIVERS" 
        <bcm-kernel-feedback-list@broadcom.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2] net: phy: bcm7xxx: request and manage GPHY
 clock
Message-ID: <20200918014612.GA3613618@lunn.ch>
References: <20200917020413.2313461-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917020413.2313461-1-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 16, 2020 at 07:04:13PM -0700, Florian Fainelli wrote:
> The internal Gigabit PHY on Broadcom STB chips has a digital clock which
> drives its MDIO interface among other things, the driver now requests
> and manage that clock during .probe() and .remove() accordingly.
> 
> Because the PHY driver can be probed with the clocks turned off we need
> to apply the dummy BMSR workaround during the driver probe function to
> ensure subsequent MDIO read or write towards the PHY will succeed.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
