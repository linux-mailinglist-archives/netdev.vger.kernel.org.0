Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3485355E95
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 00:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243670AbhDFWMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 18:12:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:52520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243643AbhDFWMD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 18:12:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB2AC613CF;
        Tue,  6 Apr 2021 22:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617747115;
        bh=I4nxHoJrkAa+c0GD2PcJsIKsqldCGduF2pxnr5ItC2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XftRFH48hYSkepWOYi14ORhUTc+SBFB1TQOraldzfPMahxAa5Yq70jmLENjhCqXOx
         cypFM3QC84lnPjiYd/lcbdlxRVlBbjy4jwSn0NhQ77HqGEYWq6XRvU0tYFgeVodaTn
         YY/fzv8v+lnQ1x28aJcGxJHC+8dYVqBWBXlZz4Clg99UbXNkqEQlMMJkmMruLDM+Zy
         Q7oJKQvEQl1DMDjqH2X7bkLggGuCgngvpiKhZET/ipuazeUTVnQpdV6XXHqOo0xEZZ
         A//CYpncjW7WmsN8NeFlJUmSGcwTa0wAZHx/EXw+ergNq+5jIphT48py73Fg329qHB
         ZtIzd/jMCRziQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kuba@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v3 06/18] net: phy: marvell10g: add MACTYPE definitions for 88E21xx
Date:   Wed,  7 Apr 2021 00:10:55 +0200
Message-Id: <20210406221107.1004-7-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210406221107.1004-1-kabel@kernel.org>
References: <20210406221107.1004-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add all MACTYPE definitions for 88E2110, 88E2180, 88E2111 and 88E2181.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/marvell10g.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 7d9a45437b69..556c9b43860e 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -35,6 +35,15 @@
 enum {
 	MV_PMA_FW_VER0		= 0xc011,
 	MV_PMA_FW_VER1		= 0xc012,
+	MV_PMA_21X0_PORT_CTRL	= 0xc04a,
+	MV_PMA_21X0_PORT_CTRL_SWRST				= BIT(15),
+	MV_PMA_21X0_PORT_CTRL_MACTYPE_MASK			= 0x7,
+	MV_PMA_21X0_PORT_CTRL_MACTYPE_USXGMII			= 0x0,
+	MV_PMA_2180_PORT_CTRL_MACTYPE_DXGMII			= 0x1,
+	MV_PMA_2180_PORT_CTRL_MACTYPE_QXGMII			= 0x2,
+	MV_PMA_21X0_PORT_CTRL_MACTYPE_5GBASER			= 0x4,
+	MV_PMA_21X0_PORT_CTRL_MACTYPE_5GBASER_NO_SGMII_AN	= 0x5,
+	MV_PMA_21X0_PORT_CTRL_MACTYPE_10GBASER_RATE_MATCH	= 0x6,
 	MV_PMA_BOOT		= 0xc050,
 	MV_PMA_BOOT_FATAL	= BIT(0),
 
-- 
2.26.2

