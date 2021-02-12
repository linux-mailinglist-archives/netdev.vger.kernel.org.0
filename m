Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B820131A733
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 23:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbhBLWAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 17:00:24 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:38060 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229660AbhBLWAW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 17:00:22 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lAgTK-005uvn-L1; Fri, 12 Feb 2021 22:59:30 +0100
Date:   Fri, 12 Feb 2021 22:59:30 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <mchan@broadcom.com>,
        "open list:BROADCOM ETHERNET PHY DRIVERS" 
        <bcm-kernel-feedback-list@broadcom.com>,
        open list <linux-kernel@vger.kernel.org>, olteanv@gmail.com,
        michael@walle.cc
Subject: Re: [PATCH net-next 0/3] net: phy: broadcom: APD improvements
Message-ID: <YCb6Qj6+j/Mhp2PA@lunn.ch>
References: <20210212205721.2406849-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210212205721.2406849-1-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 12:57:18PM -0800, Florian Fainelli wrote:
> This patch series cleans up the brcmphy.h header and its numerous unused
> phydev->dev_flags, fixes the RXC/TXC clock disabling bit and allows the
> BCM54210E PHY to utilize APD.
> 
> Thanks!

Hi Florian

I don't know the hardware, but the descriptions seem to fit the code,
and i did not spot anything odd.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
