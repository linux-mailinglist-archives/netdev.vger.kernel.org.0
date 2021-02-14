Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9344331B097
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 14:41:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbhBNNkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 08:40:43 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:26662 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229848AbhBNNkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 08:40:37 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11EDYYS3024335;
        Sun, 14 Feb 2021 05:39:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=+cRtAy+uhShuXYm1fdsJ8l7XaHcTDv8qvLWvvDgplXk=;
 b=LZ2vXbimi+Bi9da5yR9et0/Df1ekX9BeaOu2Tk8RzkTjIFBGdf4/EibIy0vVp3Atwh7T
 Sxp5xDHzPePmWZ5cjbiEfgGiXHmGYc5Y0m0RxEugNn/lvQ5lH8fkpUYwdPEGagYvNoK5
 6EJKi/7ExZ1mjKp/1otKei3epUdFG4QxUpfhWiODGJLFTrHF9IjGMj0JMpeTcMgptrDU
 akpd+I0rCGZCZyntrwiDk8xcGqo7ldNVTkr2Ew+vZAQ7HGhMnsb14wuCt0zjxVeeMAaU
 jVmgxK1qJ54C61H7OOjRQELDo6G8p+kBes0abaMW+ZK3mdPKxVm3b/vcdtFjYl1cU6uj sg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 36pd0vhyxp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 14 Feb 2021 05:39:49 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 14 Feb
 2021 05:39:48 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 14 Feb
 2021 05:39:48 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 14 Feb 2021 05:39:48 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 17C9A3F703F;
        Sun, 14 Feb 2021 05:39:44 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [net-next 4/4] net: mvpp2: improve Networking Complex Control register naming
Date:   Sun, 14 Feb 2021 15:38:37 +0200
Message-ID: <1613309917-17569-5-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1613309917-17569-1-git-send-email-stefanc@marvell.com>
References: <1613309917-17569-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-14_03:2021-02-12,2021-02-14 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

GENCONF_CTRL0_PORTX naming improved.
Non functional change.

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      | 6 +++---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index da87152..373ede3 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -673,9 +673,9 @@
 #define     GENCONF_PORT_CTRL1_EN(p)			BIT(p)
 #define     GENCONF_PORT_CTRL1_RESET(p)			(BIT(p) << 28)
 #define GENCONF_CTRL0					0x1120
-#define     GENCONF_CTRL0_PORT0_RGMII			BIT(0)
-#define     GENCONF_CTRL0_PORT1_RGMII_MII		BIT(1)
-#define     GENCONF_CTRL0_PORT1_RGMII			BIT(2)
+#define     GENCONF_CTRL0_PORT2_RGMII			BIT(0)
+#define     GENCONF_CTRL0_PORT3_RGMII_MII		BIT(1)
+#define     GENCONF_CTRL0_PORT3_RGMII			BIT(2)
 
 /* Various constants */
 
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index bc98f52..d167cfd 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -1494,9 +1494,9 @@ static void mvpp22_gop_init_rgmii(struct mvpp2_port *port)
 
 	regmap_read(priv->sysctrl_base, GENCONF_CTRL0, &val);
 	if (port->gop_id == 2)
-		val |= GENCONF_CTRL0_PORT0_RGMII;
+		val |= GENCONF_CTRL0_PORT2_RGMII;
 	else if (port->gop_id == 3)
-		val |= GENCONF_CTRL0_PORT1_RGMII_MII;
+		val |= GENCONF_CTRL0_PORT3_RGMII_MII;
 	regmap_write(priv->sysctrl_base, GENCONF_CTRL0, val);
 }
 
@@ -1513,9 +1513,9 @@ static void mvpp22_gop_init_sgmii(struct mvpp2_port *port)
 	if (port->gop_id > 1) {
 		regmap_read(priv->sysctrl_base, GENCONF_CTRL0, &val);
 		if (port->gop_id == 2)
-			val &= ~GENCONF_CTRL0_PORT0_RGMII;
+			val &= ~GENCONF_CTRL0_PORT2_RGMII;
 		else if (port->gop_id == 3)
-			val &= ~GENCONF_CTRL0_PORT1_RGMII_MII;
+			val &= ~GENCONF_CTRL0_PORT3_RGMII_MII;
 		regmap_write(priv->sysctrl_base, GENCONF_CTRL0, val);
 	}
 }
-- 
1.9.1

