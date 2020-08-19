Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5BC524A33E
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 17:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728692AbgHSPiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 11:38:19 -0400
Received: from lists.nic.cz ([217.31.204.67]:52266 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726632AbgHSPiS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 11:38:18 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:8982:ed8c:62b1:c0c8])
        by mail.nic.cz (Postfix) with ESMTP id 6952F140A90;
        Wed, 19 Aug 2020 17:38:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1597851497; bh=kWK3OUoqmBmayQnEWbb9NlnYXxkPs4Ii3zCs8VvuC7c=;
        h=From:To:Date;
        b=jO+UnoZ6oogosVzZ84rzZ9R+RtxdpAsKpA49upbZa165NbS5NlaBjSUaZuq3HKuKn
         xG4YpmaytwjRSEg6Az8bvdH1Hj/YB0JOK5g4Ar+5pfy142AjPO2SbMoNlkQhKHPyUB
         naANZDHZblO2u8z/FukQY54bDP8tN8jBfl6u733s=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH net-next 1/3] net: phy: add interface mode PHY_INTERFACE_MODE_5GBASER.
Date:   Wed, 19 Aug 2020 17:38:14 +0200
Message-Id: <20200819153816.30834-2-marek.behun@nic.cz>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200819153816.30834-1-marek.behun@nic.cz>
References: <20200819153816.30834-1-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Spam-Status: No, score=0.00
X-Spamd-Bar: /
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for interface mode PHY_INTERFACE_MODE_5GBASER.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
---
 include/linux/phy.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index 3a09d2bf69ea4..0214d70e12a69 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -105,6 +105,7 @@ typedef enum {
 	PHY_INTERFACE_MODE_TRGMII,
 	PHY_INTERFACE_MODE_1000BASEX,
 	PHY_INTERFACE_MODE_2500BASEX,
+	PHY_INTERFACE_MODE_5GBASER,
 	PHY_INTERFACE_MODE_RXAUI,
 	PHY_INTERFACE_MODE_XAUI,
 	/* 10GBASE-R, XFI, SFI - single lane 10G Serdes */
@@ -183,6 +184,8 @@ static inline const char *phy_modes(phy_interface_t interface)
 		return "1000base-x";
 	case PHY_INTERFACE_MODE_2500BASEX:
 		return "2500base-x";
+	case PHY_INTERFACE_MODE_5GBASER:
+		return "5gbase-r";
 	case PHY_INTERFACE_MODE_RXAUI:
 		return "rxaui";
 	case PHY_INTERFACE_MODE_XAUI:
-- 
2.26.2

