Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B15B43F9700
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 11:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244855AbhH0Jax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 05:30:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:57228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244872AbhH0Jah (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 05:30:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3136C60FE6;
        Fri, 27 Aug 2021 09:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630056589;
        bh=y1f6bItLirXqw1swbUnhtpawMcPJvbXWUgpNPsGtkFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n3p1dniMaFip1Hq5/1tL2YB326i/3+hh1Cb61nF2XKwehJnMQyVLTwIl09/4B7N+k
         o9U/U9yg1D0WDRYhZedRGSMJsZQXn4Etj8QPTaEGkV4NYp0x/dQlcDYT1QEK6NHJof
         w63Pj9syM7Ux2BLAs7jyDi/Qua6aieU7T5LPWlq5dxMkM8JGUZ6QPhxUyEGHNf3sHr
         Iura9lpImApXYnOh2TNtqldiz0bzYglnvHxlwUa6UVTTBQB+si47sweWadYxhH4vRk
         QPxtdm7kRP/ao3uEigo1htFVYv1cjQnnqzoD0vjG4QQXXzOQL98hOrnp/3MJGyn7nS
         //Xr/cJbeFAoA==
Received: by pali.im (Postfix)
        id 66DF1FB1; Fri, 27 Aug 2021 11:29:47 +0200 (CEST)
From:   =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Rob Herring <robh@kernel.org>, linux-phy@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] phy: marvell: phy-mvebu-a3700-comphy: Remove unsupported modes
Date:   Fri, 27 Aug 2021 11:27:53 +0200
Message-Id: <20210827092753.2359-3-pali@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210827092753.2359-1-pali@kernel.org>
References: <20210827092753.2359-1-pali@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Armada 3700 does not support RXAUI, XFI and neither SFI. Remove unused
macros for these unsupported modes.

Signed-off-by: Pali Rohár <pali@kernel.org>
Fixes: 9695375a3f4a ("phy: add A3700 COMPHY support")
---
 drivers/phy/marvell/phy-mvebu-a3700-comphy.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/phy/marvell/phy-mvebu-a3700-comphy.c b/drivers/phy/marvell/phy-mvebu-a3700-comphy.c
index cc534a5c4b3b..6781488cfc58 100644
--- a/drivers/phy/marvell/phy-mvebu-a3700-comphy.c
+++ b/drivers/phy/marvell/phy-mvebu-a3700-comphy.c
@@ -33,18 +33,12 @@
 #define COMPHY_FW_MODE_USB3H			0x4
 #define COMPHY_FW_MODE_USB3D			0x5
 #define COMPHY_FW_MODE_PCIE			0x6
-#define COMPHY_FW_MODE_RXAUI			0x7
-#define COMPHY_FW_MODE_XFI			0x8
-#define COMPHY_FW_MODE_SFI			0x9
 #define COMPHY_FW_MODE_USB3			0xa
 
 #define COMPHY_FW_SPEED_1_25G			0 /* SGMII 1G */
 #define COMPHY_FW_SPEED_2_5G			1
 #define COMPHY_FW_SPEED_3_125G			2 /* 2500BASE-X */
 #define COMPHY_FW_SPEED_5G			3
-#define COMPHY_FW_SPEED_5_15625G		4 /* XFI 5G */
-#define COMPHY_FW_SPEED_6G			5
-#define COMPHY_FW_SPEED_10_3125G		6 /* XFI 10G */
 #define COMPHY_FW_SPEED_MAX			0x3F
 
 #define COMPHY_FW_MODE(mode)			((mode) << 12)
-- 
2.20.1

