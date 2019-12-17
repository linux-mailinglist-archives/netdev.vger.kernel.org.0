Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8C40122B96
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 13:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728079AbfLQMd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 07:33:57 -0500
Received: from mga18.intel.com ([134.134.136.126]:47966 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728037AbfLQMdz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 07:33:55 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2019 04:33:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,325,1571727600"; 
   d="scan'208";a="389811702"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga005.jf.intel.com with ESMTP; 17 Dec 2019 04:33:50 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 9A4473A0; Tue, 17 Dec 2019 14:33:45 +0200 (EET)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     linux-usb@vger.kernel.org
Cc:     Andreas Noever <andreas.noever@gmail.com>,
        Michael Jamet <michael.jamet@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Rajmohan Mani <rajmohan.mani@intel.com>,
        Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>,
        Lukas Wunner <lukas@wunner.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Mario.Limonciello@dell.com,
        Anthony Wong <anthony.wong@canonical.com>,
        Oliver Neukum <oneukum@suse.com>,
        Christian Kellner <ckellner@redhat.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/9] thunderbolt: Update Kconfig entries to USB4
Date:   Tue, 17 Dec 2019 15:33:41 +0300
Message-Id: <20191217123345.31850-6-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191217123345.31850-1-mika.westerberg@linux.intel.com>
References: <20191217123345.31850-1-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the driver now supports USB4 which is the standard going forward,
update the Kconfig entry to mention this and rename the entry from
CONFIG_THUNDERBOLT to CONFIG_USB4 instead to help people to find the
correct option if they want to enable USB4.

Also do the same for Thunderbolt network driver.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
---
 drivers/Makefile             |  2 +-
 drivers/net/Kconfig          | 10 +++++-----
 drivers/net/Makefile         |  2 +-
 drivers/thunderbolt/Kconfig  | 11 ++++++-----
 drivers/thunderbolt/Makefile |  2 +-
 5 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/Makefile b/drivers/Makefile
index aaef17cc6512..31cf17dee252 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -171,7 +171,7 @@ obj-$(CONFIG_POWERCAP)		+= powercap/
 obj-$(CONFIG_MCB)		+= mcb/
 obj-$(CONFIG_PERF_EVENTS)	+= perf/
 obj-$(CONFIG_RAS)		+= ras/
-obj-$(CONFIG_THUNDERBOLT)	+= thunderbolt/
+obj-$(CONFIG_USB4)		+= thunderbolt/
 obj-$(CONFIG_CORESIGHT)		+= hwtracing/coresight/
 obj-y				+= hwtracing/intel_th/
 obj-$(CONFIG_STM)		+= hwtracing/stm/
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index d02f12a5254e..d1c84d47779d 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -489,12 +489,12 @@ config FUJITSU_ES
 	  This driver provides support for Extended Socket network device
 	  on Extended Partitioning of FUJITSU PRIMEQUEST 2000 E2 series.
 
-config THUNDERBOLT_NET
-	tristate "Networking over Thunderbolt cable"
-	depends on THUNDERBOLT && INET
+config USB4_NET
+	tristate "Networking over USB4 and Thunderbolt cables"
+	depends on USB4 && INET
 	help
-	  Select this if you want to create network between two
-	  computers over a Thunderbolt cable. The driver supports Apple
+	  Select this if you want to create network between two computers
+	  over a USB4 and Thunderbolt cables. The driver supports Apple
 	  ThunderboltIP protocol and allows communication with any host
 	  supporting the same protocol including Windows and macOS.
 
diff --git a/drivers/net/Makefile b/drivers/net/Makefile
index 0d3ba056cda3..29e83e9f545e 100644
--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -76,6 +76,6 @@ obj-$(CONFIG_NTB_NETDEV) += ntb_netdev.o
 obj-$(CONFIG_FUJITSU_ES) += fjes/
 
 thunderbolt-net-y += thunderbolt.o
-obj-$(CONFIG_THUNDERBOLT_NET) += thunderbolt-net.o
+obj-$(CONFIG_USB4_NET) += thunderbolt-net.o
 obj-$(CONFIG_NETDEVSIM) += netdevsim/
 obj-$(CONFIG_NET_FAILOVER) += net_failover.o
diff --git a/drivers/thunderbolt/Kconfig b/drivers/thunderbolt/Kconfig
index fd9adca898ff..1eb757e8df3b 100644
--- a/drivers/thunderbolt/Kconfig
+++ b/drivers/thunderbolt/Kconfig
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
-menuconfig THUNDERBOLT
-	tristate "Thunderbolt support"
+menuconfig USB4
+	tristate "Unified support for USB4 and Thunderbolt"
 	depends on PCI
 	depends on X86 || COMPILE_TEST
 	select APPLE_PROPERTIES if EFI_STUB && X86
@@ -9,9 +9,10 @@ menuconfig THUNDERBOLT
 	select CRYPTO_HASH
 	select NVMEM
 	help
-	  Thunderbolt Controller driver. This driver is required if you
-	  want to hotplug Thunderbolt devices on Apple hardware or on PCs
-	  with Intel Falcon Ridge or newer.
+	  USB4 and Thunderbolt driver. USB4 is the public speficiation
+	  based on Thunderbolt 3 protocol. This driver is required if
+	  you want to hotplug Thunderbolt and USB4 compliant devices on
+	  Apple hardware or on PCs with Intel Falcon Ridge or newer.
 
 	  To compile this driver a module, choose M here. The module will be
 	  called thunderbolt.
diff --git a/drivers/thunderbolt/Makefile b/drivers/thunderbolt/Makefile
index c0b2fd73dfbd..102e9529ee66 100644
--- a/drivers/thunderbolt/Makefile
+++ b/drivers/thunderbolt/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
-obj-${CONFIG_THUNDERBOLT} := thunderbolt.o
+obj-${CONFIG_USB4} := thunderbolt.o
 thunderbolt-objs := nhi.o nhi_ops.o ctl.o tb.o switch.o cap.o path.o tunnel.o eeprom.o
 thunderbolt-objs += domain.o dma_port.o icm.o property.o xdomain.o lc.o usb4.o
-- 
2.24.0

