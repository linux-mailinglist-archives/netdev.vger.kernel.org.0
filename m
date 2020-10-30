Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 560542A1168
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 00:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726031AbgJ3XDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 19:03:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:54374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725850AbgJ3XDc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 19:03:32 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA28322245;
        Fri, 30 Oct 2020 23:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604099011;
        bh=UBjluLfEoT4WAp3Vu3/cJxKe96PA+xboNdiLR61vTeY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fNRlNrr/icuHAtbaluL7mfEoBqe1f+Pg7K0YP1nWh4tgxzK5a1cOQZuAnRX37IFqX
         YwfI68EBQDMYF/7YCjjz/t0/uuk9HzKrUItf+yr2eNlEb7XoqzVFu0tWaOEFBpakgW
         jd9k5dN2o392Iqs52tMcnRuDeqavbdx2JubVhFQ4=
Date:   Fri, 30 Oct 2020 16:03:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     <davem@davemloft.net>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <robh@kernel.org>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v3 4/4] net: phy: dp83td510: Add support for
 the DP83TD510 Ethernet PHY
Message-ID: <20201030160330.622c55a7@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201030172950.12767-5-dmurphy@ti.com>
References: <20201030172950.12767-1-dmurphy@ti.com>
        <20201030172950.12767-5-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Oct 2020 12:29:50 -0500 Dan Murphy wrote:
> The DP83TD510E is an ultra-low power Ethernet physical layer transceiver
> that supports 10M single pair cable.
> 
> The device supports both 2.4-V p2p and 1-V p2p output voltage as defined
> by IEEE 802.3cg 10Base-T1L specfications. These modes can be forced via
> the device tree or the device is defaulted to auto negotiation to
> determine the proper p2p voltage.
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>

drivers/net/phy/dp83td510.c:70:11: warning: symbol 'dp83td510_feature_array' was not declared. Should it be static?


Also this:

WARNING: ENOTSUPP is not a SUSV4 error code, prefer EOPNOTSUPP
#429: FILE: drivers/net/phy/dp83td510.c:371:
+		return -ENOTSUPP;

WARNING: ENOTSUPP is not a SUSV4 error code, prefer EOPNOTSUPP
#524: FILE: drivers/net/phy/dp83td510.c:466:
+		return -ENOTSUPP;

ERROR: space required before the open parenthesis '('
#580: FILE: drivers/net/phy/dp83td510.c:522:
+		if(phydev->autoneg) {

ERROR: space required before the open parenthesis '('
#588: FILE: drivers/net/phy/dp83td510.c:530:
+		if(phydev->autoneg) {


And please try to wrap the code on 80 chars on the non trivial lines:

WARNING: line length of 88 exceeds 80 columns
#458: FILE: drivers/net/phy/dp83td510.c:400:
+	mst_slave_cfg = phy_read_mmd(phydev, DP83TD510_PMD_DEVADDR, DP83TD510_PMD_CTRL);


WARNING: line length of 91 exceeds 80 columns
#505: FILE: drivers/net/phy/dp83td510.c:447:
+			linkmode_set_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, phydev->supported);

WARNING: line length of 93 exceeds 80 columns
#507: FILE: drivers/net/phy/dp83td510.c:449:
+			linkmode_clear_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, phydev->supported);

WARNING: line length of 91 exceeds 80 columns
#514: FILE: drivers/net/phy/dp83td510.c:456:
+			linkmode_set_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, phydev->supported);

WARNING: line length of 93 exceeds 80 columns
#516: FILE: drivers/net/phy/dp83td510.c:458:
+			linkmode_clear_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, phydev->supported);


WARNING: line length of 92 exceeds 80 columns
#560: FILE: drivers/net/phy/dp83td510.c:502:
+					       DP83TD510_MAC_CFG_1, dp83td510->rgmii_delay);

WARNING: line length of 88 exceeds 80 columns
#574: FILE: drivers/net/phy/dp83td510.c:516:
+	mst_slave_cfg = phy_read_mmd(phydev, DP83TD510_PMD_DEVADDR, DP83TD510_PMD_CTRL);

WARNING: line length of 84 exceeds 80 columns
#695: FILE: drivers/net/phy/dp83td510.c:637:
+	dp83td510 = devm_kzalloc(&phydev->mdio.dev, sizeof(*dp83td510), GFP_KERNEL);

