Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1132C31B27F
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 21:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbhBNUoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 15:44:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbhBNUoB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 15:44:01 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3883C061574;
        Sun, 14 Feb 2021 12:43:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=8XrvPZQ0HQjAVtIcZun5iSJlbNXch34tpLZqNY5Tl9M=; b=ykLd6Ls4yzh5r8UdIKPNRMsIb
        Zvwk8SKZTEGMvmCq56QumYWpCVZz3AOdDfZYR1j+VPs88AeiVI4t4O+ETWJ11BeuOQYiJkrRWCJTQ
        eTTkOyUbxuVr1fZNiGmZzg6LhrhMkPhblgb9dixYdh/+Fh46HT+3L4GTOdx3LQ7pKRe6cBk0o/CDz
        wsxWNUZP3sdRLRbMfHFUlvTGEIXOjyQh5YzCuobo4qxtso6Ki7wsZjx7twjpr2FsIlCyRi2QCD98b
        0LAyjyzqD7x+ZAI9j4REMerEXm7GI0JPL5J3qT5PwtgWDKm4mjPjV4pep62gKjfAkqsC5JrmuYtNg
        fbY0tHH1Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43430)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lBOEY-0000ZL-TG; Sun, 14 Feb 2021 20:43:10 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lBOEU-0000yr-1p; Sun, 14 Feb 2021 20:43:06 +0000
Date:   Sun, 14 Feb 2021 20:43:06 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Andrew Lunn <andrew@lunn.ch>, Jonathan Corbet <corbet@lwn.net>,
        Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Byungho An <bh74.an@samsung.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-doc@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com
Subject: Re: [PATCH net-next] net: phy: rename PHY_IGNORE_INTERRUPT to
 PHY_MAC_INTERRUPT
Message-ID: <20210214204305.GV1463@shell.armlinux.org.uk>
References: <243316e1-1fa3-dcbb-f090-0ef504d5dec7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <243316e1-1fa3-dcbb-f090-0ef504d5dec7@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
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

Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
