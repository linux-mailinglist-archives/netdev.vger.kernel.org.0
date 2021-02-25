Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A50D63250FC
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 14:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbhBYNyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 08:54:32 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57462 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229722AbhBYNyb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 08:54:31 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lFH5O-008Pe1-LN; Thu, 25 Feb 2021 14:53:46 +0100
Date:   Thu, 25 Feb 2021 14:53:46 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniel =?iso-8859-1?Q?Gonz=E1lez?= Cabanelas <dgcbueu@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, f.fainelli@gmail.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        noltari@gmail.com
Subject: Re: [PATCH v2] bcm63xx_enet: fix internal phy IRQ assignment
Message-ID: <YDer6iWOd8bviNxb@lunn.ch>
References: <2323124.5UR7tLNZLG@tool>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2323124.5UR7tLNZLG@tool>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 24, 2021 at 04:44:18PM +0100, Daniel González Cabanelas wrote:
> The current bcm63xx_enet driver doesn't asign the internal phy IRQ. As a
> result of this it works in polling mode.
> 
> Fix it using the phy_device structure to assign the platform IRQ.
> 
> Tested under a BCM6348 board. Kernel dmesg before the patch:
>    Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached PHY driver [Broadcom
>               BCM63XX (1)] (mii_bus:phy_addr=bcm63xx_enet-0:01, irq=POLL)
> 
> After the patch:
>    Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached PHY driver [Broadcom
>               BCM63XX (1)] (mii_bus:phy_addr=bcm63xx_enet-0:01, irq=17)
> 
> Pluging and uplugging the ethernet cable now generates interrupts and the
> PHY goes up and down as expected.
> 
> Signed-off-by: Daniel González Cabanelas <dgcbueu@gmail.com>
> ---
> changes in V2: 
>   - snippet moved after the mdiobus registration
>   - added missing brackets

Hi Daniel

It is a good idea to wait at least a day between posting versions. If
you post too frequently, people tend to review the old version, since
it is first in there mailbox.

   Andrew
