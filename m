Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCB2226E393
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 20:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgIQR3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 13:29:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40972 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726574AbgIQR2q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 13:28:46 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kIxhm-00F6fZ-6y; Thu, 17 Sep 2020 19:28:22 +0200
Date:   Thu, 17 Sep 2020 19:28:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, hkallweit1@gmail.com, kuba@kernel.org,
        davem@davemloft.net
Subject: Re: [PATCH net 1/2] net: phy: Avoid NPD upon phy_detach() when
 driver is unbound
Message-ID: <20200917172822.GA3598897@lunn.ch>
References: <20200917034310.2360488-1-f.fainelli@gmail.com>
 <20200917034310.2360488-2-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917034310.2360488-2-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 16, 2020 at 08:43:09PM -0700, Florian Fainelli wrote:
> If we have unbound the PHY driver prior to calling phy_detach() (often
> via phy_disconnect()) then we can cause a NULL pointer de-reference
> accessing the driver owner member. The steps to reproduce are:
> 
> echo unimac-mdio-0:01 > /sys/class/net/eth0/phydev/driver/unbind
> ip link set eth0 down
> 
> Fixes: cafe8df8b9bc ("net: phy: Fix lack of reference count on PHY driver")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
