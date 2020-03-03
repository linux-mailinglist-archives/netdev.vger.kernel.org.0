Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE32177B1C
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 16:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729577AbgCCPx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 10:53:57 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:37754 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728918AbgCCPx5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 10:53:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=uwXTPDxP4GmxDNVPwSgNfURqejK3M6t8GGa+PcjdyGs=; b=wAzodgwkrtLJkdmPVc0pXcDHU
        Tx4yocz2ZZoCaEx83Xg0XLXUgG0b+eT1suhwxfM2lkgOls8c5v5RRyj5d8iUCUeutEBWSy1i7D8N0
        4LfbFCGIpDZyOYH+u2zPJpcEbApHKVJpGV45XQMp8RCu7AKkrxEI1E9E0jwjNolbvl62rOEMrJA2p
        ls05ZYpPuM+VdzLI2lpI3EZvOVDsUUC1GV5OOVSr15E7yUeDrLF8eOGb17QfAQo7kqgIdgQT4GDsv
        psu6Y+XbSv+Xezb7tZJLL7FwuWgwO9r5DRLfaY5pkKRRMP228FpgTDgru/Nn97I1LcGcNGYPocdHz
        +VYaBNr8Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:59890)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j99rh-0000Tc-CW; Tue, 03 Mar 2020 15:53:49 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j99rg-00061u-0q; Tue, 03 Mar 2020 15:53:48 +0000
Date:   Tue, 3 Mar 2020 15:53:47 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 0/3] marvell10g tunable and power saving support
Message-ID: <20200303155347.GS25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patch series adds support for:
- mdix configuration (auto, mdi, mdix)
- energy detect power down (edpd)
- placing in edpd mode at probe

for both the 88x3310 and 88x2110 PHYs.

Antione, could you test this for the 88x2110 PHY please?

v2: fix comments from Antione.

 drivers/net/phy/marvell10g.c | 177 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 170 insertions(+), 7 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
