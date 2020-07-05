Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7AA214B06
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 09:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgGEH4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 03:56:25 -0400
Received: from smtp.al2klimov.de ([78.46.175.9]:48224 "EHLO smtp.al2klimov.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725967AbgGEH4Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jul 2020 03:56:25 -0400
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        by smtp.al2klimov.de (Postfix) with ESMTPA id 08064BC127;
        Sun,  5 Jul 2020 07:56:17 +0000 (UTC)
From:   "Alexander A. Klimov" <grandmaster@al2klimov.de>
To:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, dmurphy@ti.com,
        sriram.dash@samsung.com, hpeter@gmail.com, masahiroy@kernel.org,
        leon@kernel.org, krzk@kernel.org, kvalo@codeaurora.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Subject: [PATCH] Replace HTTP links with HTTPS ones: CAN network drivers
Date:   Sun,  5 Jul 2020 09:56:06 +0200
Message-Id: <20200705075606.22802-1-grandmaster@al2klimov.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: +++++
X-Spam-Level: *****
Authentication-Results: smtp.al2klimov.de;
        auth=pass smtp.auth=aklimov@al2klimov.de smtp.mailfrom=grandmaster@al2klimov.de
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rationale:
Reduces attack surface on kernel devs opening the links for MITM
as HTTPS traffic is much harder to manipulate.

Deterministic algorithm:
For each file:
  If not .svg:
    For each line:
      If doesn't contain `\bxmlns\b`:
        For each link, `\bhttp://[^# \t\r\n]*(?:\w|/)`:
          If both the HTTP and HTTPS versions
          return 200 OK and serve the same content:
            Replace HTTP with HTTPS.

Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
---
 Continuing my work started at 93431e0607e5.

 If there are any URLs to be removed completely or at least not HTTPSified:
 Just clearly say so and I'll *undo my change*.
 See also https://lkml.org/lkml/2020/6/27/64

 If there are any valid, but yet not changed URLs:
 See https://lkml.org/lkml/2020/6/26/837

 Documentation/devicetree/bindings/net/can/grcan.txt |  2 +-
 drivers/net/can/grcan.c                             |  2 +-
 drivers/net/can/m_can/m_can.c                       |  2 +-
 drivers/net/can/m_can/m_can.h                       |  2 +-
 drivers/net/can/m_can/m_can_platform.c              |  2 +-
 drivers/net/can/m_can/tcan4x5x.c                    |  2 +-
 drivers/net/can/sja1000/Kconfig                     | 12 ++++++------
 drivers/net/can/sja1000/tscan1.c                    |  2 +-
 drivers/net/can/slcan.c                             |  2 +-
 drivers/net/can/ti_hecc.c                           |  4 ++--
 drivers/net/can/usb/Kconfig                         |  6 +++---
 11 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/can/grcan.txt b/Documentation/devicetree/bindings/net/can/grcan.txt
index 34ef3498f887..d05b5c80d2b4 100644
--- a/Documentation/devicetree/bindings/net/can/grcan.txt
+++ b/Documentation/devicetree/bindings/net/can/grcan.txt
@@ -25,4 +25,4 @@ Optional properties:
 	a bug workaround is activated.
 
 For further information look in the documentation for the GLIB IP core library:
-http://www.gaisler.com/products/grlib/grip.pdf
+https://www.gaisler.com/products/grlib/grip.pdf
diff --git a/drivers/net/can/grcan.c b/drivers/net/can/grcan.c
index 378200b682fa..c6be0ed9ae90 100644
--- a/drivers/net/can/grcan.c
+++ b/drivers/net/can/grcan.c
@@ -8,7 +8,7 @@
  * VHDL IP core library.
  *
  * Full documentation of the GRCAN core can be found here:
- * http://www.gaisler.com/products/grlib/grip.pdf
+ * https://www.gaisler.com/products/grlib/grip.pdf
  *
  * See "Documentation/devicetree/bindings/net/can/grcan.txt" for information on
  * open firmware properties.
diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 02c5795b7393..d7d6e5111e0d 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -2,7 +2,7 @@
 // CAN bus driver for Bosch M_CAN controller
 // Copyright (C) 2014 Freescale Semiconductor, Inc.
 //      Dong Aisheng <b29396@freescale.com>
-// Copyright (C) 2018-19 Texas Instruments Incorporated - http://www.ti.com/
+// Copyright (C) 2018-19 Texas Instruments Incorporated - https://www.ti.com/
 
 /* Bosch M_CAN user manual can be obtained from:
  * http://www.bosch-semiconductors.de/media/pdf_1/ipmodules_1/m_can/
diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
index 49f42b50627a..30a1a030ce17 100644
--- a/drivers/net/can/m_can/m_can.h
+++ b/drivers/net/can/m_can/m_can.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* CAN bus driver for Bosch M_CAN controller
- * Copyright (C) 2018 Texas Instruments Incorporated - http://www.ti.com/
+ * Copyright (C) 2018 Texas Instruments Incorporated - https://www.ti.com/
  */
 
 #ifndef _CAN_M_CAN_H_
diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_can/m_can_platform.c
index 38ea5e600fb8..1905b7108429 100644
--- a/drivers/net/can/m_can/m_can_platform.c
+++ b/drivers/net/can/m_can/m_can_platform.c
@@ -3,7 +3,7 @@
 // Copyright (C) 2014 Freescale Semiconductor, Inc.
 //	Dong Aisheng <b29396@freescale.com>
 //
-// Copyright (C) 2018-19 Texas Instruments Incorporated - http://www.ti.com/
+// Copyright (C) 2018-19 Texas Instruments Incorporated - https://www.ti.com/
 
 #include <linux/platform_device.h>
 
diff --git a/drivers/net/can/m_can/tcan4x5x.c b/drivers/net/can/m_can/tcan4x5x.c
index eacd428e07e9..d36ac51cde8c 100644
--- a/drivers/net/can/m_can/tcan4x5x.c
+++ b/drivers/net/can/m_can/tcan4x5x.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 // SPI to CAN driver for the Texas Instruments TCAN4x5x
-// Copyright (C) 2018-19 Texas Instruments Incorporated - http://www.ti.com/
+// Copyright (C) 2018-19 Texas Instruments Incorporated - https://www.ti.com/
 
 #include <linux/regmap.h>
 #include <linux/spi/spi.h>
diff --git a/drivers/net/can/sja1000/Kconfig b/drivers/net/can/sja1000/Kconfig
index 110071b26921..0a9558db3088 100644
--- a/drivers/net/can/sja1000/Kconfig
+++ b/drivers/net/can/sja1000/Kconfig
@@ -12,14 +12,14 @@ config CAN_EMS_PCI
 	help
 	  This driver is for the one, two or four channel CPC-PCI,
 	  CPC-PCIe and CPC-104P cards from EMS Dr. Thomas Wuensche
-	  (http://www.ems-wuensche.de).
+	  (https://www.ems-wuensche.de).
 
 config CAN_EMS_PCMCIA
 	tristate "EMS CPC-CARD Card"
 	depends on PCMCIA
 	help
 	  This driver is for the one or two channel CPC-CARD cards from
-	  EMS Dr. Thomas Wuensche (http://www.ems-wuensche.de).
+	  EMS Dr. Thomas Wuensche (https://www.ems-wuensche.de).
 
 config CAN_F81601
 	tristate "Fintek F81601 PCIE to 2 CAN Controller"
@@ -44,7 +44,7 @@ config CAN_PEAK_PCI
 	help
 	  This driver is for the PCAN-PCI/PCIe/miniPCI cards
 	  (1, 2, 3 or 4 channels) from PEAK-System Technik
-	  (http://www.peak-system.com).
+	  (https://www.peak-system.com).
 
 config CAN_PEAK_PCIEC
 	bool "PEAK PCAN-ExpressCard Cards"
@@ -63,7 +63,7 @@ config CAN_PEAK_PCMCIA
 	depends on HAS_IOPORT_MAP
 	help
 	  This driver is for the PCAN-PC Card PCMCIA adapter (1 or 2 channels)
-	  from PEAK-System (http://www.peak-system.com). To compile this
+	  from PEAK-System (https://www.peak-system.com). To compile this
 	  driver as a module, choose M here: the module will be called
 	  peak_pcmcia.
 
@@ -97,7 +97,7 @@ config CAN_SJA1000_PLATFORM
 	  This driver adds support for the SJA1000 chips connected to
 	  the "platform bus" (Linux abstraction for directly to the
 	  processor attached devices).  Which can be found on various
-	  boards from Phytec (http://www.phytec.de) like the PCM027,
+	  boards from Phytec (https://www.phytec.de) like the PCM027,
 	  PCM038. It also provides the OpenFirmware "platform bus" found
 	  on embedded systems with OpenFirmware bindings, e.g. if you
 	  have a PowerPC based system you may want to enable this option.
@@ -107,7 +107,7 @@ config CAN_TSCAN1
 	depends on ISA
 	help
 	  This driver is for Technologic Systems' TSCAN-1 PC104 boards.
-	  http://www.embeddedarm.com/products/board-detail.php?product=TS-CAN1
+	  https://www.embeddedarm.com/products/board-detail.php?product=TS-CAN1
 	  The driver supports multiple boards and automatically configures them:
 	  PLD IO base addresses are read from jumpers JP1 and JP2,
 	  IRQ numbers are read from jumpers JP4 and JP5,
diff --git a/drivers/net/can/sja1000/tscan1.c b/drivers/net/can/sja1000/tscan1.c
index 6ea802c66124..e0b7a4fd8faf 100644
--- a/drivers/net/can/sja1000/tscan1.c
+++ b/drivers/net/can/sja1000/tscan1.c
@@ -8,7 +8,7 @@
 /*
  * References:
  * - Getting started with TS-CAN1, Technologic Systems, Jun 2009
- *	http://www.embeddedarm.com/documentation/ts-can1-manual.pdf
+ *	https://www.embeddedarm.com/documentation/ts-can1-manual.pdf
  */
 
 #include <linux/init.h>
diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index 91cdc0a2b1a7..b7127d58d3e9 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -18,7 +18,7 @@
  * General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License along
- * with this program; if not, see http://www.gnu.org/licenses/gpl.html
+ * with this program; if not, see https://www.gnu.org/licenses/gpl.html
  *
  * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
  * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
diff --git a/drivers/net/can/ti_hecc.c b/drivers/net/can/ti_hecc.c
index 94b1491b569f..1c51639d2085 100644
--- a/drivers/net/can/ti_hecc.c
+++ b/drivers/net/can/ti_hecc.c
@@ -2,9 +2,9 @@
  * TI HECC (CAN) device driver
  *
  * This driver supports TI's HECC (High End CAN Controller module) and the
- * specs for the same is available at <http://www.ti.com>
+ * specs for the same is available at <https://www.ti.com>
  *
- * Copyright (C) 2009 Texas Instruments Incorporated - http://www.ti.com/
+ * Copyright (C) 2009 Texas Instruments Incorporated - https://www.ti.com/
  * Copyright (C) 2019 Jeroen Hofstee <jhofstee@victronenergy.com>
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/net/can/usb/Kconfig b/drivers/net/can/usb/Kconfig
index 77fa830fe7dd..da60ee47be19 100644
--- a/drivers/net/can/usb/Kconfig
+++ b/drivers/net/can/usb/Kconfig
@@ -6,13 +6,13 @@ config CAN_8DEV_USB
 	tristate "8 devices USB2CAN interface"
 	help
 	  This driver supports the USB2CAN interface
-	  from 8 devices (http://www.8devices.com).
+	  from 8 devices (https://www.8devices.com).
 
 config CAN_EMS_USB
 	tristate "EMS CPC-USB/ARM7 CAN/USB interface"
 	help
 	  This driver is for the one channel CPC-USB/ARM7 CAN/USB interface
-	  from EMS Dr. Thomas Wuensche (http://www.ems-wuensche.de).
+	  from EMS Dr. Thomas Wuensche (https://www.ems-wuensche.de).
 
 config CAN_ESD_USB2
 	tristate "ESD USB/2 CAN/USB interface"
@@ -100,7 +100,7 @@ config CAN_PEAK_USB
 	  PCAN-Chip USB        CAN-FD to USB stamp module
 	  PCAN-USB X6          6 CAN-FD channels USB adapter
 
-	  (see also http://www.peak-system.com).
+	  (see also https://www.peak-system.com).
 
 config CAN_UCAN
 	tristate "Theobroma Systems UCAN interface"
-- 
2.27.0

