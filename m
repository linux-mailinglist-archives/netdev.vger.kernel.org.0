Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8313F6A3C
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 17:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbfKJQkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 11:40:17 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:47518 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbfKJQkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 11:40:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=WamrtfUDz2ydB4mF1uDVXflaNcDwQlrAemu6RIfC1W4=; b=qnhEauNXhS2bVe6a6x9RUtjDs
        VkVrIfpoy9deurBIQn2VafQOBjJHUBGDzHjRALEv/PwywnwaOULxsdXYl1ZR7D5la6mDQ0zlmzn3w
        VwrN/SSTOG6Zwd7d3uw894oDMBAAv2rtihRdhcWJfzoKU2LVsGrtfnNMMfutWrUmFkqxCiDBKj5M8
        HI5sd6X5ZXS9YjnYZccRRh48X2JZyxz0Bfw6HOYy/vxw7ZxsGVnCbL5roKHVAdYNT3zEm16dzjVHB
        +RjyJfJCODLRaFU290kbHEgpbS9J+FxHQbxOiMIJMfQJs79rxGMXoa6ccP04778ktF4PodkoElHJu
        wxdOBvl9Q==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:33688)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iTqG2-0008QT-4E; Sun, 10 Nov 2019 16:40:10 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iTqFz-00085l-Pl; Sun, 10 Nov 2019 16:40:07 +0000
Date:   Sun, 10 Nov 2019 16:40:07 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: phy: add core phylib sfp support
Message-ID: <20191110164007.GC25745@shell.armlinux.org.uk>
References: <20191110142226.GB25745@shell.armlinux.org.uk>
 <E1iTo7N-0005Sj-Nk@rmk-PC.armlinux.org.uk>
 <20191110161307.GC25889@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191110161307.GC25889@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 10, 2019 at 05:13:07PM +0100, Andrew Lunn wrote:
> On Sun, Nov 10, 2019 at 02:23:05PM +0000, Russell King wrote:
> > Add core phylib help for supporting SFP sockets on PHYs.  This provides
> > a mechanism to inform the SFP layer about PHY up/down events, and also
> > unregister the SFP bus when the PHY is going away.
> 
> Hi Russell
> 
> What does the device tree binding look like? I think you have SFP
> proprieties in the PHYs node?

Correct, just the same as network devices.  Hmm, however, neither are
documented... oh dear, it looks like I need to figure out how this
yaml stuff works. :(

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
