Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C13BA171462
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 10:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728698AbgB0JwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 04:52:12 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34860 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728454AbgB0JwM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 04:52:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=z5m6tXTkAlYXzgJ0FVS+LQjBt3YsmaLrgFprtN/HLGU=; b=co9MkkZO2CvSkAY7CttBdobQ+
        MjldDFkFeKU5971bjJoiCEi5snDcuHNNWr+IZVNJfTXZx2Ne522Ob7Bhe2mGv7IyuXf95HFJBR1X/
        8zHJAU/adyXtncWo/J/rTRrvOjhRxrojgbXNvmaw/FA4vmpRl4UnP991Vs91Y47NNoISczUTAcWy4
        iORstvGRZgfErvbT+VbS3QMjTl6JCEDTaG/jIwU/bSZKTRl1Y//FWdmZ9T/v/ZD854N5xXsbj1s3U
        9GBu0tdVZQNOT1BiHd6AYNyIHMfIwPH/Pk6pGbMN9tGjuGNIGxMY6CgxE/D33vruDRRHQ641djYMH
        wqGa4xQEA==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:45908)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j7Fpr-0004jk-Bx; Thu, 27 Feb 2020 09:52:03 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j7Fpn-0000st-EX; Thu, 27 Feb 2020 09:51:59 +0000
Date:   Thu, 27 Feb 2020 09:51:59 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        linux-arm-kernel@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: [PATCH net-next 0/3] Add support for configuring Marvell 10G PHY LEDs
Message-ID: <20200227095159.GJ25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series makes it possible to configure the PHY LEDs on the Marvell
88x3310 and similar PHYs.

We introduce a new DT property called "marvell,led-mode" which allows
the register values (up to four) for the LEDs to be given and programmed
into the PHY by the driver.

 .../devicetree/bindings/net/marvell,10g.yaml       | 31 +++++++++++
 arch/arm64/boot/dts/marvell/armada-8040-mcbin.dts  |  2 +
 drivers/net/phy/marvell10g.c                       | 62 +++++++++++++++++++---
 3 files changed, 88 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/marvell,10g.yaml

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
