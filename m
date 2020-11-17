Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F79E2B5720
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 03:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbgKQCyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 21:54:01 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59296 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725554AbgKQCyA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 21:54:00 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1ker7y-007SUp-M9; Tue, 17 Nov 2020 03:53:54 +0100
Date:   Tue, 17 Nov 2020 03:53:54 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: phy: don't duplicate driver name in
 phy_attached_print
Message-ID: <20201117025354.GL1752213@lunn.ch>
References: <8ab72586-f079-41d8-84ee-9f6a5bd97b2a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ab72586-f079-41d8-84ee-9f6a5bd97b2a@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 15, 2020 at 04:03:10PM +0100, Heiner Kallweit wrote:
> Currently we print the driver name twice in phy_attached_print():
> - phy_dev_info() prints it as part of the device info
> - and we print it as part of the info string
> 
> This is a little bit ugly, it makes the info harder to read,
> especially if the driver name is a little bit longer.
> Therefore omit the driver name (if set) in the info string.
> 
> Example from r8169 that uses phylib:
> 
> old: Generic FE-GE Realtek PHY r8169-300:00: attached PHY driver \
>    [Generic FE-GE Realtek PHY] (mii_bus:phy_addr=r8169-300:00, irq=IGNORE)
> new: Generic FE-GE Realtek PHY r8169-300:00: attached PHY driver \
>    (mii_bus:phy_addr=r8169-300:00, irq=IGNORE)
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
