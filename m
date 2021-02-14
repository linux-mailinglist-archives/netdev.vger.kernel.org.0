Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9E431B145
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 17:34:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbhBNQd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 11:33:59 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:41584 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229783AbhBNQd4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Feb 2021 11:33:56 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lBKKB-006G3B-HB; Sun, 14 Feb 2021 17:32:43 +0100
Date:   Sun, 14 Feb 2021 17:32:43 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>,
        Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Byungho An <bh74.an@samsung.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-doc@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com
Subject: Re: [PATCH net-next] net: phy: rename PHY_IGNORE_INTERRUPT to
 PHY_MAC_INTERRUPT
Message-ID: <YClQqzYu89+3oJF0@lunn.ch>
References: <243316e1-1fa3-dcbb-f090-0ef504d5dec7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <243316e1-1fa3-dcbb-f090-0ef504d5dec7@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 14, 2021 at 03:16:23PM +0100, Heiner Kallweit wrote:
> Some internal PHY's have their events like link change reported by the
> MAC interrupt. We have PHY_IGNORE_INTERRUPT to deal with this scenario.
> I'm not too happy with this name. We don't ignore interrupts, typically
> there is no interrupt exposed at a PHY level. So let's rename it to
> PHY_MAC_INTERRUPT. This is in line with phy_mac_interrupt(), which is
> called from the MAC interrupt handler to handle PHY events.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
