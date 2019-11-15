Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9172FE60E
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 20:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbfKOTxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 14:53:55 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:49922 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbfKOTxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 14:53:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=i9GS39cGaOlOLMWEwVz2GSR98HyYKXh6AyHjx+cBGLM=; b=mcXml+82Zv+Dt81fSQGJW5ZU2
        RdKGInRwthpteM1fwfCjueOw2Ynpv8xTIwgyieFjrJeeMMfGoYYXdjnaa19nUvTXIj7bRHcqZWC+W
        sL5IggVJRWVhdX9A6ntVJb3G3neZp+PQr3BFBxhajRVHPfc2usOB3vNau629qcAseUy9r52isacpL
        xaFFr0A1M0HIETPu/Um4JYwOTCR4C3zEYkT1UU9HomfijkREwTyyNrkhegLgt3gVtgaUia9rI65pB
        +DejdNZZ5c+aO5cAxv4T8lXWl4bzNGr6NnubEtyrA2USqDEj/u0t9rtoThLPD9TuligwbJQqIkX/D
        E7aYSRd3Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:40078)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iVhf4-00035s-Az; Fri, 15 Nov 2019 19:53:42 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iVhf1-0004lP-Cv; Fri, 15 Nov 2019 19:53:39 +0000
Date:   Fri, 15 Nov 2019 19:53:39 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 0/3] Add support for SFPs behind PHYs
Message-ID: <20191115195339.GR25745@shell.armlinux.org.uk>
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

v2: add yaml binding patch

 .../bindings/net/ethernet-controller.yaml          |  5 ++
 .../devicetree/bindings/net/ethernet-phy.yaml      |  5 ++
 drivers/net/phy/marvell10g.c                       | 25 +++++++-
 drivers/net/phy/phy.c                              |  7 +++
 drivers/net/phy/phy_device.c                       | 66 ++++++++++++++++++++++
 include/linux/phy.h                                | 11 ++++
 6 files changed, 118 insertions(+), 1 deletion(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
