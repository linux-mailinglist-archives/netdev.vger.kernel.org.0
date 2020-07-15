Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7322214C9
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 21:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgGOTBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 15:01:21 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37422 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726086AbgGOTBV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 15:01:21 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jvmea-005Hc5-GS; Wed, 15 Jul 2020 21:01:16 +0200
Date:   Wed, 15 Jul 2020 21:01:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Helmut Grohne <helmut.grohne@intenta.de>,
        David Miller <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "woojung.huh@microchip.com" <woojung.huh@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>
Subject: Re: [PATCH] net: phy: phy_remove_link_mode should not advertise new
 modes
Message-ID: <20200715190116.GC1256692@lunn.ch>
References: <20200714082540.GA31028@laureti-dev>
 <20200714.140710.213288407914809619.davem@davemloft.net>
 <20200715070345.GA3452@laureti-dev>
 <20200715112031.24c2d8ad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715112031.24c2d8ad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Is 
> 
> Case C: driver does not initialize advertised at all and depends on
>         phy_remove_link_mode() to do it
> 
> possible?

No. phylib initializes advertise to supported as part of probing the
PHY. So the PHY by default advertises everything it supports, except
the oddities of Pause.

    Andrew
