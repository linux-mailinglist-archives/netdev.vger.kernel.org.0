Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA3CD3D5211
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 06:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbhGZDVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 23:21:32 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:35836 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbhGZDVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Jul 2021 23:21:31 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 16Q41tbJ6018633, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36502.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 16Q41tbJ6018633
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 26 Jul 2021 12:01:55 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36502.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 26 Jul 2021 12:01:53 +0800
Received: from fc34.localdomain (172.21.177.102) by RTEXMBS04.realtek.com.tw
 (172.21.6.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Mon, 26 Jul
 2021 12:01:53 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <nic_swsd@realtek.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next RESEND 1/2] r8152: group the usb ethernet of realtek
Date:   Mon, 26 Jul 2021 12:01:08 +0800
Message-ID: <1394712342-15778-372-Taiwan-albertk@realtek.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <1394712342-15778-371-Taiwan-albertk@realtek.com>
References: <1394712342-15778-368-Taiwan-albertk@realtek.com>
 <1394712342-15778-371-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.102]
X-ClientProxiedBy: RTEXMBS01.realtek.com.tw (172.21.6.94) To
 RTEXMBS04.realtek.com.tw (172.21.6.97)
X-KSE-ServerInfo: RTEXMBS04.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: trusted connection
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 07/23/2021 16:12:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: =?big5?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzcvMjMgpFWkyCAwMjowNTowMA==?=
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-ServerInfo: RTEXH36502.realtek.com.tw, 9
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: =?big5?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzcvMjYgpFekyCAwMjo1MjowMA==?=
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 07/26/2021 03:51:53
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 165230 [Jul 25 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: hayeswang@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 449 449 5db59deca4a4f5e6ea34a93b13bc730e229092f4
X-KSE-AntiSpam-Info: {Tracking_uf_ne_domains}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: pegasus2.sourceforge.net:7.1.1;realtek.com:7.1.1;github.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: {Track_Chinese_Simplified, headers_charset}
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 07/26/2021 03:54:00
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move r8152.c, rtl8150.c, and r8153_ecm.c from drivers/net/usb to
drivers/net/usb/realtek.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 MAINTAINERS                               | 11 +++++++-
 drivers/net/usb/Kconfig                   | 30 +--------------------
 drivers/net/usb/Makefile                  |  4 +--
 drivers/net/usb/realtek/Kconfig           | 33 +++++++++++++++++++++++
 drivers/net/usb/realtek/Makefile          |  8 ++++++
 drivers/net/usb/{ => realtek}/r8152.c     |  0
 drivers/net/usb/{ => realtek}/r8153_ecm.c |  0
 drivers/net/usb/{ => realtek}/rtl8150.c   |  0
 8 files changed, 53 insertions(+), 33 deletions(-)
 create mode 100644 drivers/net/usb/realtek/Kconfig
 create mode 100644 drivers/net/usb/realtek/Makefile
 rename drivers/net/usb/{ => realtek}/r8152.c (100%)
 rename drivers/net/usb/{ => realtek}/r8153_ecm.c (100%)
 rename drivers/net/usb/{ => realtek}/rtl8150.c (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 34531ee3e4af..4e025ef7144c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -19243,7 +19243,16 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 W:	https://github.com/petkan/rtl8150
 T:	git git://github.com/petkan/rtl8150.git
-F:	drivers/net/usb/rtl8150.c
+F:	drivers/net/usb/realtek/rtl8150.c
+
+USB RTL8152 DRIVER
+L:	nic_swsd@realtek.com
+L:	linux-usb@vger.kernel.org
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	drivers/net/usb/realtek/*
+F:	include/linux/usb/r8152.h
+X:	drivers/net/usb/realtek/rtl8150.c
 
 USB SERIAL SUBSYSTEM
 M:	Johan Hovold <johan@kernel.org>
diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
index 4c5d69732a7e..b15d0530c74a 100644
--- a/drivers/net/usb/Kconfig
+++ b/drivers/net/usb/Kconfig
@@ -85,27 +85,7 @@ config USB_PEGASUS
 	  To compile this driver as a module, choose M here: the
 	  module will be called pegasus.
 
-config USB_RTL8150
-	tristate "USB RTL8150 based ethernet device support"
-	select MII
-	help
-	  Say Y here if you have RTL8150 based usb-ethernet adapter.
-	  Send me <petkan@users.sourceforge.net> any comments you may have.
-	  You can also check for updates at <http://pegasus2.sourceforge.net/>.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called rtl8150.
-
-config USB_RTL8152
-	tristate "Realtek RTL8152/RTL8153 Based USB Ethernet Adapters"
-	select MII
-	help
-	  This option adds support for Realtek RTL8152 based USB 2.0
-	  10/100 Ethernet adapters and RTL8153 based USB 3.0 10/100/1000
-	  Ethernet adapters.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called r8152.
+source "drivers/net/usb/realtek/Kconfig"
 
 config USB_LAN78XX
 	tristate "Microchip LAN78XX Based USB Ethernet Adapters"
@@ -630,12 +610,4 @@ config USB_NET_AQC111
 	  This driver should work with at least the following devices:
 	  * Aquantia AQtion USB to 5GbE
 
-config USB_RTL8153_ECM
-	tristate "RTL8153 ECM support"
-	depends on USB_NET_CDCETHER && (USB_RTL8152 || USB_RTL8152=n)
-	help
-	  This option supports ECM mode for RTL8153 ethernet adapter, when
-	  CONFIG_USB_RTL8152 is not set, or the RTL8153 device is not
-	  supported by r8152 driver.
-
 endif # USB_NET_DRIVERS
diff --git a/drivers/net/usb/Makefile b/drivers/net/usb/Makefile
index 4964f7b326fb..2767d8089f25 100644
--- a/drivers/net/usb/Makefile
+++ b/drivers/net/usb/Makefile
@@ -6,8 +6,7 @@
 obj-$(CONFIG_USB_CATC)		+= catc.o
 obj-$(CONFIG_USB_KAWETH)	+= kaweth.o
 obj-$(CONFIG_USB_PEGASUS)	+= pegasus.o
-obj-$(CONFIG_USB_RTL8150)	+= rtl8150.o
-obj-$(CONFIG_USB_RTL8152)	+= r8152.o
+obj-y				+= realtek/
 obj-$(CONFIG_USB_HSO)		+= hso.o
 obj-$(CONFIG_USB_LAN78XX)	+= lan78xx.o
 obj-$(CONFIG_USB_NET_AX8817X)	+= asix.o
@@ -41,4 +40,3 @@ obj-$(CONFIG_USB_NET_QMI_WWAN)	+= qmi_wwan.o
 obj-$(CONFIG_USB_NET_CDC_MBIM)	+= cdc_mbim.o
 obj-$(CONFIG_USB_NET_CH9200)	+= ch9200.o
 obj-$(CONFIG_USB_NET_AQC111)	+= aqc111.o
-obj-$(CONFIG_USB_RTL8153_ECM)	+= r8153_ecm.o
diff --git a/drivers/net/usb/realtek/Kconfig b/drivers/net/usb/realtek/Kconfig
new file mode 100644
index 000000000000..1afa85480b8f
--- /dev/null
+++ b/drivers/net/usb/realtek/Kconfig
@@ -0,0 +1,33 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Reatlek USB Network devices configuration
+#
+config USB_RTL8150
+	tristate "USB RTL8150 based ethernet device support"
+	select MII
+	help
+	  Say Y here if you have RTL8150 based usb-ethernet adapter.
+	  Send me <petkan@users.sourceforge.net> any comments you may have.
+	  You can also check for updates at <http://pegasus2.sourceforge.net/>.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called rtl8150.
+
+config USB_RTL8152
+	tristate "Realtek RTL8152/RTL8153 Based USB Ethernet Adapters"
+	select MII
+	help
+	  This option adds support for Realtek RTL8152 based USB 2.0
+	  10/100 Ethernet adapters and RTL8153 based USB 3.0 10/100/1000
+	  Ethernet adapters.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called r8152.
+
+config USB_RTL8153_ECM
+	tristate "RTL8153 ECM support"
+	depends on USB_NET_CDCETHER && (USB_RTL8152 || USB_RTL8152=n)
+	help
+	  This option supports ECM mode for RTL8153 ethernet adapter, when
+	  CONFIG_USB_RTL8152 is not set, or the RTL8153 device is not
+	  supported by r8152 driver.
diff --git a/drivers/net/usb/realtek/Makefile b/drivers/net/usb/realtek/Makefile
new file mode 100644
index 000000000000..6f89910a8f76
--- /dev/null
+++ b/drivers/net/usb/realtek/Makefile
@@ -0,0 +1,8 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Makefile for the Realtek USB network device drivers.
+#
+
+obj-$(CONFIG_USB_RTL8150)	+= rtl8150.o
+obj-$(CONFIG_USB_RTL8152)	+= r8152.o
+obj-$(CONFIG_USB_RTL8153_ECM)	+= r8153_ecm.o
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/realtek/r8152.c
similarity index 100%
rename from drivers/net/usb/r8152.c
rename to drivers/net/usb/realtek/r8152.c
diff --git a/drivers/net/usb/r8153_ecm.c b/drivers/net/usb/realtek/r8153_ecm.c
similarity index 100%
rename from drivers/net/usb/r8153_ecm.c
rename to drivers/net/usb/realtek/r8153_ecm.c
diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/realtek/rtl8150.c
similarity index 100%
rename from drivers/net/usb/rtl8150.c
rename to drivers/net/usb/realtek/rtl8150.c
-- 
2.31.1

