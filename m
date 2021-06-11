Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 549853A427A
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 14:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbhFKM5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 08:57:10 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:36544 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231614AbhFKM5G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 08:57:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1623416109; x=1654952109;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=O16s45fodtBhmTEluLReNjsavw6a6lLyxUkLSsd4V0s=;
  b=EdWhsnh3CZQXsVv03URngeDpClRvj+HIyB2QhPjW5dM/5s9tvqHB7UbT
   ki3KGjcHcbSk1NF2NIOQsXCb4X++0VR/2aylCA6v1nH0XlqzqBq01Xdc7
   NfJhmbP5kEjWh6vAYvfgwZtnb058hk8QoO/ypGI/9v0a5LJFuEKrREM0B
   F1xuYffbUd8mt/SZNS2xBww+oIND7lfRqGNy8BY8GRNy+sJ8zi/1Gpt8Q
   28tqu7tUBi6gOGv7saUjQQWrtKg8rbdA68XFNvK5mXPFzS78aO5N5a83U
   e7RdfcJPAhIbLLxA/WGeOwGJvlzfUmajXYgZiPVyXe3UN9lvYcCPvaHQh
   w==;
IronPort-SDR: EnsiYOCgl4niRH8CDE9gAsz5S7WE28TM5e9xnTAtv8QyyUEYab8IqxRx38go8l3DPQQq1Vepuw
 eOICtjFlF9aU0NVpwh6Qi24ezHJemasW5SLx5aM+M+J0MoR332bV06XD7TuDoHF+Z/jEYtTJzY
 NPpCeS6liWTvPkl5av6pQyFrx1WwnV3ZHfK1ymVzctor350IGtxdS5KGwDPwYvwQDb5rS+zx6Q
 JAnaxSRrh66SZHlzrkpSkxnQhLf+YUXUN8+cKECv7i557I1nw/mcQCv/Aq61Fj2lVF5jCvj7Pz
 9f8=
X-IronPort-AV: E=Sophos;i="5.83,265,1616482800"; 
   d="scan'208";a="131631333"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Jun 2021 05:55:09 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 11 Jun 2021 05:55:08 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Fri, 11 Jun 2021 05:55:06 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        "Heiner Kallweit" <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        <linux-doc@vger.kernel.org>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>
Subject: [PATCH net-next 2/4] net: phy: Add 25G BASE-R interface mode
Date:   Fri, 11 Jun 2021 14:54:51 +0200
Message-ID: <20210611125453.313308-3-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210611125453.313308-1-steen.hegelund@microchip.com>
References: <20210611125453.313308-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add 25gbase-r phy interface mode

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>
---
 Documentation/networking/phy.rst | 6 ++++++
 include/linux/phy.h              | 4 ++++
 2 files changed, 10 insertions(+)

diff --git a/Documentation/networking/phy.rst b/Documentation/networking/phy.rst
index 3f05d50ecd6e..571ba08386e7 100644
--- a/Documentation/networking/phy.rst
+++ b/Documentation/networking/phy.rst
@@ -292,6 +292,12 @@ Some of the interface modes are described below:
     Note: due to legacy usage, some 10GBASE-R usage incorrectly makes
     use of this definition.
 
+``PHY_INTERFACE_MODE_25GBASER``
+    This is the IEEE 802.3 PCS Clause 107 defined 25GBASE-R protocol.
+    The PCS is identical to 10GBASE-R, i.e. 64B/66B encoded
+    running 2.5 as fast, giving a fixed bit rate of 25.78125 Gbaud.
+    Please refer to the IEEE standard for further information.
+
 ``PHY_INTERFACE_MODE_100BASEX``
     This defines IEEE 802.3 Clause 24.  The link operates at a fixed data
     rate of 125Mpbs using a 4B/5B encoding scheme, resulting in an underlying
diff --git a/include/linux/phy.h b/include/linux/phy.h
index ed332ac92e25..70a1399ff454 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -112,6 +112,7 @@ extern const int phy_10gbit_features_array[1];
  * @PHY_INTERFACE_MODE_RXAUI: Reduced XAUI
  * @PHY_INTERFACE_MODE_XAUI: 10 Gigabit Attachment Unit Interface
  * @PHY_INTERFACE_MODE_10GBASER: 10G BaseR
+ * @PHY_INTERFACE_MODE_25GBASER: 25G BaseR
  * @PHY_INTERFACE_MODE_USXGMII:  Universal Serial 10GE MII
  * @PHY_INTERFACE_MODE_10GKR: 10GBASE-KR - with Clause 73 AN
  * @PHY_INTERFACE_MODE_MAX: Book keeping
@@ -147,6 +148,7 @@ typedef enum {
 	PHY_INTERFACE_MODE_XAUI,
 	/* 10GBASE-R, XFI, SFI - single lane 10G Serdes */
 	PHY_INTERFACE_MODE_10GBASER,
+	PHY_INTERFACE_MODE_25GBASER,
 	PHY_INTERFACE_MODE_USXGMII,
 	/* 10GBASE-KR - with Clause 73 AN */
 	PHY_INTERFACE_MODE_10GKR,
@@ -223,6 +225,8 @@ static inline const char *phy_modes(phy_interface_t interface)
 		return "xaui";
 	case PHY_INTERFACE_MODE_10GBASER:
 		return "10gbase-r";
+	case PHY_INTERFACE_MODE_25GBASER:
+		return "25gbase-r";
 	case PHY_INTERFACE_MODE_USXGMII:
 		return "usxgmii";
 	case PHY_INTERFACE_MODE_10GKR:
-- 
2.32.0

