Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35CF9F696F
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 15:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbfKJOWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 09:22:36 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:45986 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726402AbfKJOWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 09:22:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=99vSYCtYCy/B2vR4UX41iu3KE9Bt04cl59YLGno20nQ=; b=LQb0LwCwznohpm0Qa7BTddrUV
        3k7BNl22mbICSrFox++3wAWF82tXzbbe4VK5YDNuJkUnLn3T2Wwh7glvt+d1oMnUkManeDIsz0ky3
        y0JrOQ6SHX0el60VrmAjoshchw/3qP6b4nc3nky0+aRL14gszzxWI73kq07DgTgRRE1qhjaGi7TaU
        NX7eel8RLTCZEJdexzDWBia4ZFzJAuJkXO/FP0Ud+cHa9k7+jVrr7Vq0fYR+uiONdir4+b2gPhoiv
        UMBsUxAHIUTByLtyJPh4omyaWNQ1rbDJNfnc26QdJFO4mHDBtWXja2BUAQEaZZucZgUboG9mDEQPE
        qX1IBy7Rg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:37782)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iTo6m-0007jy-OD; Sun, 10 Nov 2019 14:22:28 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iTo6k-00080V-Vc; Sun, 10 Nov 2019 14:22:26 +0000
Date:   Sun, 10 Nov 2019 14:22:26 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/2] Add support for SFPs behind PHYs
Message-ID: <20191110142226.GB25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds partial support for SFP cages connected to PHYs,
specifically optical SFPs.

We add core infrastructure to phylib for this, and arrange for
minimal code in the PHY driver - currently, this is code to verify
that the module is one that we can support for Marvell 10G PHYs.

 drivers/net/phy/marvell10g.c | 25 ++++++++++++++++-
 drivers/net/phy/phy.c        |  7 +++++
 drivers/net/phy/phy_device.c | 66 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/phy.h          | 11 ++++++++
 4 files changed, 108 insertions(+), 1 deletion(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
