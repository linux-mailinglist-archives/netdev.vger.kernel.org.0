Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFD0F1B75C0
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 14:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbgDXMqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 08:46:52 -0400
Received: from mail-am6eur05on2078.outbound.protection.outlook.com ([40.107.22.78]:39617
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726698AbgDXMqu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 08:46:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dEUqYq0PwJ03kQZL+oCq3PsZawKaYeF73aVqMMDDt2ID0PWWk6VuH+jDv8Hp7hpWVLtkCUbJrCpqu4pcKBL18mAjwVhS3YOw9MxzolYDOsRYrIYaT5UCCuWMGQvTDK9V3SZeUuBMxsgt499iDRgA1EVGl7aVWf0cEb0WEqF+o1SUHB6LagGQfwZ1NZTb2p1FlabnO1tsvikrAOy93OdPWQxylaCEHo4w1Yqz95tCVSpI5NwLlzOM2r8vwrevvp2AAqVdPK5S4eATUUpaY1VG/Hn36r/KDkchmPXoKjrBvRBWYMht+nRvid55SdeVVq0dZjpeXvMrV+n6gqO3syx92w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H/OAQvZonakXm5RAuQOBSKZZv1FqplaVORmgNBAuKvw=;
 b=Gig5G5ENkvnOIg/wZIVOCGQsHE2HM9kzDkFaChedZ1zPrlSEe9hTpnUSSOglqi9EAME6mk7VP0QmW0rl2A3mhjpG+37Rv4AJGtgM3WGo6+bYJduVXfc1eeOEAnf4fqFxzEPd20aMQZfZCGo17dZMDR3j+J7H0Yd/ru67Ye+yBrLx19aSiD2J6mBYBXIppdMqpARQJDMQ2auwpJyvN/EQQw5tWFOqrAjr3U11U/PNqlbHhd3bvK0I/7shvKhhcxihbkkkb0jNkcx/ME8tVrj34fiLoRnd/4ZyxO6/iQKVdqx/CWMQgRcMsdnEXOMAvlGRsKtHTO3yRPVVLNBqiP2G4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H/OAQvZonakXm5RAuQOBSKZZv1FqplaVORmgNBAuKvw=;
 b=Aa1HAS8lch/8oZdHrylus07qSq7376WymS8Lg/KXABtPcI9XlUp79HBjdWVU+unBbLSWAC9ThX+aULxXD7KImdyM/vc7qA0zwLxVtQ3tXxHE0WD658yhtW5jxi3KqRs6NhAcVDjE1fbWWF4Lez+wIa9AzHRz2NdwHHBWiIyom6Q=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=florinel.iordache@nxp.com; 
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com (2603:10a6:208:119::33)
 by AM0PR04MB5937.eurprd04.prod.outlook.com (2603:10a6:208:119::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Fri, 24 Apr
 2020 12:46:43 +0000
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::8cc9:252:1c77:5860]) by AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::8cc9:252:1c77:5860%2]) with mapi id 15.20.2937.012; Fri, 24 Apr 2020
 12:46:43 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk
Cc:     devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, kuba@kernel.org,
        corbet@lwn.net, shawnguo@kernel.org, leoyang.li@nxp.com,
        madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        linux-kernel@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: [PATCH net-next v2 1/9] doc: net: add backplane documentation
Date:   Fri, 24 Apr 2020 15:46:23 +0300
Message-Id: <1587732391-3374-2-git-send-email-florinel.iordache@nxp.com>
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
Received: from fsr-ub1464-128.ea.freescale.net (83.217.231.2) by AM0P190CA0025.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:190::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.2937.13 via Frontend Transport; Fri, 24 Apr 2020 12:46:42 +0000
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2b9d51b4-7380-44bf-2834-08d7e84d8ab1
X-MS-TrafficTypeDiagnostic: AM0PR04MB5937:|AM0PR04MB5937:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB5937439CB7F6B4B89A74E334FBD00@AM0PR04MB5937.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 03838E948C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5443.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(39860400002)(346002)(376002)(366004)(52116002)(2616005)(86362001)(44832011)(6486002)(2906002)(8676002)(4326008)(66476007)(66946007)(6666004)(66556008)(8936002)(5660300002)(81156014)(6512007)(3450700001)(16526019)(956004)(186003)(6506007)(36756003)(316002)(26005)(7416002)(478600001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k3lTPSlAmz13SvDJWju5yJIF3DlEr5BOdezIKVUrTb4Xz3s0OwXhbxyJo81vb3p3NKZehwvEmheuKRN3kqg0UTbPKeAOnC2EO4Eg2zNMVyRicUPAGog6aiNVuK1Ma+0EJq/oNnjwMxACVpTNfG+pB+M+71mNHEdfVDE9o96ZObDNOEiNIWUTamt8qg+I0GU3rNrKe2ON5kDafhklC3X1Bl+1g2QDr4m4fYg+35L/Rrh4nJS3XxlF880CnGWGizxEI7q0fy8RTMOy8O6M/mRjvsPo0thPRQkOydfBTmYe0tKzNZlQVCbb/HjDIyaTKHBuoTVUr27RIX8w2mlbqXLbP2jsQUhNJxaG7i0bS+NO2GpqfQXk6KkJaUA5GCdSZgkqsO/4tbIqlb2s2Fk6P8faQsjYEXP67/KYadRukenmN0rhhY528HOhLL5TDK5ap527
X-MS-Exchange-AntiSpam-MessageData: oAn+CqmTKtL+o+wWy5jZll6+g6832oLA921Nh9Fdn9BpbcZwRtoc4RgKRZyHcbIgTlHfOaDnPt1jhNnnSEkL3mVaTR2i6wiMBTtYD48TG+rgc5t8EoYKA4QMBwFSmJRBkoiAmTYbyAc91/9//eu6Ng==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b9d51b4-7380-44bf-2834-08d7e84d8ab1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2020 12:46:43.5145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DRmbTAcc+jNpao5eFPsKDVjgZVOJa3udBFAJ/YX/ntjR++AAWoQ/FfbPv7kxzMp+3NbXlH05kp8ci2xha+Bvy0ebSnTZIY1F+q03dguzDL8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5937
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ethernet backplane documentation

Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>
---
 Documentation/ABI/testing/sysfs-class-net-phydev |   2 +-
 Documentation/networking/backplane.rst           | 165 +++++++++++++++++++++++
 Documentation/networking/phy.rst                 |  15 ++-
 3 files changed, 178 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/networking/backplane.rst

diff --git a/Documentation/ABI/testing/sysfs-class-net-phydev b/Documentation/ABI/testing/sysfs-class-net-phydev
index 206cbf5..69dbd36 100644
--- a/Documentation/ABI/testing/sysfs-class-net-phydev
+++ b/Documentation/ABI/testing/sysfs-class-net-phydev
@@ -39,7 +39,7 @@ Description:
 		<empty> (not available), mii, gmii, sgmii, tbi, rev-mii,
 		rmii, rgmii, rgmii-id, rgmii-rxid, rgmii-txid, rtbi, smii
 		xgmii, moca, qsgmii, trgmii, 1000base-x, 2500base-x, rxaui,
-		xaui, 10gbase-kr, unknown
+		xaui, 10gbase-kr, 40gbase-kr4, unknown
 
 What:		/sys/class/mdio_bus/<bus>/<device>/phy_standalone
 Date:		May 2019
diff --git a/Documentation/networking/backplane.rst b/Documentation/networking/backplane.rst
new file mode 100644
index 0000000..951c17e
--- /dev/null
+++ b/Documentation/networking/backplane.rst
@@ -0,0 +1,165 @@
+.. SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
+
+=========================
+Ethernet Backplane Driver
+=========================
+
+Author:
+Florinel Iordache <florinel.iordache@nxp.com>
+
+Contents
+========
+
+	- Ethernet Backplane Overview
+	- Equalization
+	- Auto-negotiation
+	- Link training
+	- Enable backplane support in Linux kernel
+	- Ethernet Backplane support architecture
+	- Supported equalization algorithms
+	- Supported backplane protocols
+	- Supported platforms
+
+Ethernet Backplane Overview
+===========================
+
+Ethernet operation over electrical backplanes, also referred to as Ethernet
+Backplane, combines the IEEE 802.3 Media Access Control (MAC) and MAC
+Control sublayers with a family of Physical Layers defined to support
+operation over a modular chassis backplane.
+The main standard specification for Ethernet Backplane is: IEEE802.3ap-2007
+Amendment 4: Ethernet Operation over Electrical Backplanes
+which includes the new Clause 69 through Clause 74.
+Additional specifications define support for various speeds and 4-lanes:
+IEEE802.3ba-2010.
+Signal equalization is required based on the link quality. The standard
+specifies that a start-up algorithm should be in place in order to get the
+link up.
+
+Equalization
+============
+
+Equalization represents the procedure required to minimize the effects of signal
+distortion, noise, interference occurred in high-speed communication channels.
+The equalizer purpose is to improve signal integrity in terms of bit error rate
+(BER) in order to allow accurate recovery of the transmitted symbols.
+
+A simplified view of channel equalization:
+
+            LD       <======== channel =========>      LP
+       Local Device                                Link Partner
+
+         |-----|                                         ___
+         |     |     <======== channel =========>       /   |
+         |     |      witout signal Equalization       /     \
+         |     |                                      /      |
+     ____|     |____                              ___/        \___
+
+         |\   _                                        |-----|
+         | \_/ |     <======== channel =========>      |     |
+         |     |       with signal Equalization        |     |
+         |     |                                       |     |
+     ____|     |____                               ____|     |____
+
+      LD Tx waveform                                LP Rx waveform
+
+Auto-negotiation
+================
+
+Auto-negotiation allows the devices at both ends of a link segment to advertise
+abilities, acknowledge receipt, and discover the common modes of operation that
+both devices share. It also rejects the use of operational modes not shared by
+both devices. Auto-negotiation does not test link segment characteristics.
+
+Link training
+=============
+
+Link training occurs after auto-negotiation has determined the link to be a
+Base-KR, but before auto-negotiation is done. It continuously exchanges messages
+(training frames) between the local and the remote device as part of the
+start-up phase. Link training tunes the equalization parameters of the remote and
+local transmitter to improve the link quality in terms of bit error rate.
+Both LP (link partner/remote device) and LD (local device) perform link training
+in parallel. Link training is finished when both sides decide that the channel is
+equalized and then the link is considered up.
+
+Enable backplane support in Linux kernel
+========================================
+
+To enable the Ethernet Backplane, the following Kconfig options are available:
+
+# enable generic Ethernet Backplane support:
+CONFIG_ETH_BACKPLANE=y
+# enable Fixed (No Equalization) algorithm:
+CONFIG_ETH_BACKPLANE_FIXED=y
+# enable 3-Taps Bit Edge Equalization (BEE) algorithm:
+CONFIG_ETH_BACKPLANE_BEE=y
+# enable QorIQ Ethernet Backplane driver:
+CONFIG_ETH_BACKPLANE_QORIQ=y
+
+Ethernet Backplane support architecture
+=======================================
+
+Ethernet Backplane support in Linux kernel complies with the following standard
+design concepts:
+* Modularity:
+    # internal components are separated in well defined functional modules
+* Reusability:
+    # lower layer components provide basic functionalities which are reused by
+    the upper layer modules
+* Extensibility:
+    # architecture can be easily extended with support for new:
+    	- backplane protocols
+    	- equalization algorithms
+    	- supported devices
+It is designed as a loosely coupled architecture in order to allow the
+possibility to easily create desired backplane system configurations according
+to user needs by specifying different components and initialization parameters
+without recompiling the kernel.
+
+       ------------------            ------------------------------------
+       |  EQ Algorithms |            |    Specific device drivers       |
+       |  ------------  |            |       Backplane support          |
+       |  |  Fixed   |  |            | ------------------   ----------- |
+       |  ------------  |            | |     QorIQ      |   |         | |
+       |  |   BEE    |  |            | |    devices     |   |         | |
+       |  ------------  |            | | -------------- |   |  other  | |
+       |  |  others  |  |            | | | Serdes 10G | |   | devices | |
+  ----------------------------       | | -------------- |   | support | |
+  |      Link Training       |       | | | Serdes 28G | |   |         | |
+  |   and Auto-negotiation   |       | | -------------- |   |         | |
+  |    (IEEE 802.3-ap/ba)    |       | |----------------|   |---------| |
+  ---------------------------------------------------------------------------
+  |                   Ethernet Backplane Generic Driver                     |
+  ---------------------------------------------------------------------------
+  |                         PHY Abstraction Layer                           |
+  ---------------------------------------------------------------------------
+
+Supported equalization algorithms
+=================================
+
+Ethernet Backplane supports the following equalization algorithms:
+
+- Fixed setup (No Equalization algorithm)
+- 3-Taps Bit Edge Equalization (BEE) algorithm
+
+Supported backplane protocols
+=============================
+
+Ethernet Backplane supports the following protocols:
+
+- Single-lane:
+10GBase-KR
+
+- Multi-lane:
+40GBase-KR4
+
+Supported platforms
+===================
+
+Ethernet Backplane is enabled on the following platforms:
+
+LS1046A
+LS1088A
+LS2088A
+LX2160A
\ No newline at end of file
diff --git a/Documentation/networking/phy.rst b/Documentation/networking/phy.rst
index 2561060..1f1ebf2 100644
--- a/Documentation/networking/phy.rst
+++ b/Documentation/networking/phy.rst
@@ -279,13 +279,22 @@ Some of the interface modes are described below:
     XFI and SFI are not PHY interface types in their own right.
 
 ``PHY_INTERFACE_MODE_10GKR``
-    This is the IEEE 802.3 Clause 49 defined 10GBASE-R with Clause 73
-    autonegotiation. Please refer to the IEEE standard for further
-    information.
+    This is 10G Ethernet Backplane over single lane specified in
+    IEEE802.3ap-2007 Amendment 4: Ethernet Operation over Electrical
+    Backplanes which includes the new Clause 69 through Clause 74
+    including autonegotiation. 10GKR uses the same physical layer
+    encoding as 10GBASE-R defined in IEEE802.3 Clause 49. Please refer
+    to the IEEE standard for further information.
 
     Note: due to legacy usage, some 10GBASE-R usage incorrectly makes
     use of this definition.
 
+``PHY_INTERFACE_MODE_40GKR4``
+    This is 40G Ethernet Backplane over 4-lanes using the same main
+    standard used for Ethernet Operation over Electrical Backplanes
+    and additional specifications that define support for Ethernet
+    Backplane over 4-lanes specified in IEEE802.3ba-2010.
+
 Pause frames / flow control
 ===========================
 
-- 
1.9.1

