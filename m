Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B62529781B
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 22:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1755867AbgJWUK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 16:10:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42272 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755859AbgJWUK5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 16:10:57 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kW3Og-003AhL-PB; Fri, 23 Oct 2020 22:10:46 +0200
Date:   Fri, 23 Oct 2020 22:10:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sekhar Nori <nsekhar@ti.com>, linux-kernel@vger.kernel.org,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Roger Quadros <rogerq@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH] RFC: net: phy: of phys probe/reset issue
Message-ID: <20201023201046.GB752111@lunn.ch>
References: <20201023174750.21356-1-grygorii.strashko@ti.com>
 <450d262e-242c-77f1-9f06-e25943cc595c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <450d262e-242c-77f1-9f06-e25943cc595c@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Yes there is: have your Ethernet PHY compatible string be of the form
> "ethernetAAAA.BBBB" and then there is no need for such hacking.
> of_get_phy_id() will parse that compatible and that will trigger
> of_mdiobus_register_phy() to take the phy_device_create() path.

Yep. That does seem like the cleanest way to do this. Let the PHY
driver deal with the resources it needs.

       Andrew
