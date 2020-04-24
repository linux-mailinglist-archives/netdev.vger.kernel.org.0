Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2CF1B75C7
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 14:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727944AbgDXMrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 08:47:01 -0400
Received: from mail-am6eur05on2053.outbound.protection.outlook.com ([40.107.22.53]:26784
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727809AbgDXMq7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 08:46:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rp5SL4liSWfRCqPlYGUHArxknLRn+10/9vseV5MCjKN1ogPSBkppEyW/HSSaqdmhTWQwZx4e93tHNG3MQ3f0X5HDlijtPiuHZZSHyMVSh9IQ8iDO+zeANockXeHeBIQYCTZsIigbKhBjwCQg1I7ONFz1V9SusPvDDkoR/l2PAVDeSpxcOhequ05e54iKtmrrzp9scAAhQ4SvgQ3ifHEITFXMm6M2Ti2pU26LwKHMBpl5Ss+dcw7HrU6aJlG/2KIO+bshAlmjMJW1N6ouqoB6q3V6TuwNKum3gkxDJXRzIk+ku+s2UWjv3lNYMjxDkLInFU3zPPVpX4M7G+aHMSwJWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UX8Twwppfp6yTjpSjczvLtfF3GRdnklEpx/taHdFD2E=;
 b=b1Td7StfHdk4VxUZN7Lgkawrs/mfsINfiojzroOUNOGe4OfgCsqr8V+pUD+zTiRAQwlxezKDUd13QGicmW2k2dGF3cTw05XRW7oXe60Le4bHjA6FhYtOpPyCFjrk9/UjUQKhZ/HjtfOQLuS/J4F8gmf5YEQXTQNky5ORaqEj83YQV7H1ZL+Jx5z1ecjFsaeB85o3pnMslhaqmf0POBZvBeyekFgaDg72v7NjJ5YUy7WBt/vMZEFzgPGWP3BLyzrmZ7JNG+GEIlOt4NXoH2cyMaFgoe3KKua53cq2S1Yx+EtaLgZhcKIHuBgHL1KvAxtFalwPXoniEIRJf63cEnGz/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UX8Twwppfp6yTjpSjczvLtfF3GRdnklEpx/taHdFD2E=;
 b=kgh3IdKsF8bnH6GFNICMCnCKDsOhiSAyr+UGDqesfaFD0/0K0I/9AhArVkfb9Ql5djxSBh0ru0OZdP5V1kdbRKwFpxlB7cChYp314YKsz2SP5FzSj46ZrqBoe9tVRsFTFB9kNNwSRPu1I1W2hLJjWWa5pDPFzw3oBSJHHKyK5s8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=florinel.iordache@nxp.com; 
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com (2603:10a6:208:119::33)
 by AM0PR04MB5937.eurprd04.prod.outlook.com (2603:10a6:208:119::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Fri, 24 Apr
 2020 12:46:46 +0000
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::8cc9:252:1c77:5860]) by AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::8cc9:252:1c77:5860%2]) with mapi id 15.20.2937.012; Fri, 24 Apr 2020
 12:46:46 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk
Cc:     devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, kuba@kernel.org,
        corbet@lwn.net, shawnguo@kernel.org, leoyang.li@nxp.com,
        madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        linux-kernel@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: [PATCH net-next v2 3/9] net: phy: add kr phy connection type
Date:   Fri, 24 Apr 2020 15:46:25 +0300
Message-Id: <1587732391-3374-4-git-send-email-florinel.iordache@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1587732391-3374-1-git-send-email-florinel.iordache@nxp.com>
References: <1587732391-3374-1-git-send-email-florinel.iordache@nxp.com>
Reply-to: florinel.iordache@nxp.com
Content-Type: text/plain
X-ClientProxiedBy: AM0P190CA0025.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::35) To AM0PR04MB5443.eurprd04.prod.outlook.com
 (2603:10a6:208:119::33)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fsr-ub1464-128.ea.freescale.net (83.217.231.2) by AM0P190CA0025.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:190::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.2937.13 via Frontend Transport; Fri, 24 Apr 2020 12:46:45 +0000
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2ff6e1a1-5a3f-4a5f-aa95-08d7e84d8c56
X-MS-TrafficTypeDiagnostic: AM0PR04MB5937:|AM0PR04MB5937:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB593750B037737C97B2C180B4FBD00@AM0PR04MB5937.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 03838E948C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5443.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(39860400002)(346002)(376002)(366004)(52116002)(2616005)(86362001)(44832011)(6486002)(2906002)(8676002)(4326008)(66476007)(66946007)(6666004)(66556008)(8936002)(5660300002)(81156014)(6512007)(3450700001)(16526019)(956004)(186003)(6506007)(36756003)(316002)(26005)(7416002)(478600001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xXDxYgrTvjfib0DY6XXgABFQwSwWslU8M1W+vftbLxSsM5ke4sFB9z9cdSA0VMVC+38IZujDXizeZzal9zBtbGzQYY6lHH94qfecZsuSDba6C/4nMJx3HrGX1Stp2A5EQSB1C68O1ST5gidmVUYZTcu7H0D2C3nx6s6eay4oqJkUAXzN5TZ6RWEg778s+rOrIrkt8JSanWQEfW61sJ5/PGIB4ddeW7TpGiapw3vW0eWoYZPhALlU5erJk19AgfbYFLOm4GwSep3LhX8jMQwwM9HqsI4IhTwg85mRs3kJXciV2eRkKZKeCyIuaePfWAM1YtFL6fhgYFfSlvZ2a6oq0J0kN/lqojzmxcvPhAORJjqNEJWfYhSbX+JbZ9O9GE7rN2X8i8vlpfM9k1cY7fzUOZ3iCYnmKtyA0ZYTQIsp2cYZnN7CvqjpxOvetHJdYQkq
X-MS-Exchange-AntiSpam-MessageData: 0rSDAnlRmUmYlFMSTm4zPDQ7iXV/Z4WGgAFDOTzB2mm2qxOeCM//DOon84e6HGRzoBSrm/AcIPqARL6swoeAQWMn+X7O6Pe/fnOAa660LFcywr0icqnxdTCJXXQ+JcP8E7Ch65WronjBH33dKl12KA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ff6e1a1-5a3f-4a5f-aa95-08d7e84d8c56
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2020 12:46:46.2619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vljVO1HGVHb4fLUPg2IbFX0+wHjiyu4m6ZkruKfoD8CS4VbjiyKBNUoBvtdz8yciPsy1aoZU44uXlOqDBWRrszOyKvhUc9O8tjZSszzaPaE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5937
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for backplane kr phy connection types currently available
(10gbase-kr, 40gbase-kr4) and the required phylink updates (cover all
the cases for KR modes which are clause 45 compatible to correctly assign
phy_interface and phylink#supported)

Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>
---
 drivers/net/phy/phylink.c | 15 ++++++++++++---
 include/linux/phy.h       |  6 +++++-
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 34ca12a..9a31f68 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -4,6 +4,7 @@
  * technologies such as SFP cages where the PHY is hot-pluggable.
  *
  * Copyright (C) 2015 Russell King
+ * Copyright 2020 NXP
  */
 #include <linux/ethtool.h>
 #include <linux/export.h>
@@ -304,7 +305,6 @@ static int phylink_parse_mode(struct phylink *pl, struct fwnode_handle *fwnode)
 			break;
 
 		case PHY_INTERFACE_MODE_USXGMII:
-		case PHY_INTERFACE_MODE_10GKR:
 		case PHY_INTERFACE_MODE_10GBASER:
 			phylink_set(pl->supported, 10baseT_Half);
 			phylink_set(pl->supported, 10baseT_Full);
@@ -318,7 +318,6 @@ static int phylink_parse_mode(struct phylink *pl, struct fwnode_handle *fwnode)
 			phylink_set(pl->supported, 2500baseX_Full);
 			phylink_set(pl->supported, 5000baseT_Full);
 			phylink_set(pl->supported, 10000baseT_Full);
-			phylink_set(pl->supported, 10000baseKR_Full);
 			phylink_set(pl->supported, 10000baseKX4_Full);
 			phylink_set(pl->supported, 10000baseCR_Full);
 			phylink_set(pl->supported, 10000baseSR_Full);
@@ -327,6 +326,14 @@ static int phylink_parse_mode(struct phylink *pl, struct fwnode_handle *fwnode)
 			phylink_set(pl->supported, 10000baseER_Full);
 			break;
 
+		case PHY_INTERFACE_MODE_10GKR:
+			phylink_set(pl->supported, 10000baseKR_Full);
+			break;
+
+		case PHY_INTERFACE_MODE_40GKR4:
+			phylink_set(pl->supported, 40000baseKR4_Full);
+			break;
+
 		case PHY_INTERFACE_MODE_XLGMII:
 			phylink_set(pl->supported, 25000baseCR_Full);
 			phylink_set(pl->supported, 25000baseKR_Full);
@@ -860,7 +867,9 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
 	if (phy->is_c45 &&
 	    interface != PHY_INTERFACE_MODE_RXAUI &&
 	    interface != PHY_INTERFACE_MODE_XAUI &&
-	    interface != PHY_INTERFACE_MODE_USXGMII)
+	    interface != PHY_INTERFACE_MODE_USXGMII &&
+	    interface != PHY_INTERFACE_MODE_10GKR &&
+	    interface != PHY_INTERFACE_MODE_40GKR4)
 		config.interface = PHY_INTERFACE_MODE_NA;
 	else
 		config.interface = interface;
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 2432ca4..d7cca4b 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -6,6 +6,7 @@
  * Author: Andy Fleming
  *
  * Copyright (c) 2004 Freescale Semiconductor, Inc.
+ * Copyright 2020 NXP
  */
 
 #ifndef __PHY_H
@@ -107,8 +108,9 @@
 	/* 10GBASE-R, XFI, SFI - single lane 10G Serdes */
 	PHY_INTERFACE_MODE_10GBASER,
 	PHY_INTERFACE_MODE_USXGMII,
-	/* 10GBASE-KR - with Clause 73 AN */
+	/* Backplane KR */
 	PHY_INTERFACE_MODE_10GKR,
+	PHY_INTERFACE_MODE_40GKR4,
 	PHY_INTERFACE_MODE_MAX,
 } phy_interface_t;
 
@@ -190,6 +192,8 @@ static inline const char *phy_modes(phy_interface_t interface)
 		return "usxgmii";
 	case PHY_INTERFACE_MODE_10GKR:
 		return "10gbase-kr";
+	case PHY_INTERFACE_MODE_40GKR4:
+		return "40gbase-kr4";
 	default:
 		return "unknown";
 	}
-- 
1.9.1

