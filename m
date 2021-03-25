Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B18C3492E4
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 14:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbhCYNOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 09:14:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:52622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230358AbhCYNNf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 09:13:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0786619EE;
        Thu, 25 Mar 2021 13:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616678015;
        bh=I4nxHoJrkAa+c0GD2PcJsIKsqldCGduF2pxnr5ItC2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vQ8M48xkhJEEGScggkhOB7naUmBtJ+xUGYk7D3NIedVBuLLynVKp1/cUtCDt5mlbo
         s1VCQP+tzSIZlXYHiWqRGl/omjGaq7T5sM92ivVFrZ0cXejXwdhkt6MkqulHMrtR5I
         dsJNw03n5GO+7adXm32m3BPhmQtobn77hcv+il4STaiDCl8mGhsDcAG1Z8TTTp9TPc
         15vNgx4g4P19reTnwddm3GU1xv/CiUoX7X9BJmalXBJfoiIbRZfYZ2ykZoi/uLNuaM
         e44c/jVFI1NUjpP81LPcaaXp5lr5/7kQw8TpY2lbmc0nEPJq/bTPvPbi2gwbH2OBqV
         JMF0Dtr4iMQeg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>, kuba@kernel.org
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v2 06/12] net: phy: marvell10g: add MACTYPE definitions for 88E21XX
Date:   Thu, 25 Mar 2021 14:12:44 +0100
Message-Id: <20210325131250.15901-7-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210325131250.15901-1-kabel@kernel.org>
References: <20210325131250.15901-1-kabel@kernel.org>
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

