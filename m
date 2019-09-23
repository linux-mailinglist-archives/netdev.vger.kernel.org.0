Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA3FBB89D
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 17:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732830AbfIWPxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 11:53:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:45804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728464AbfIWPxF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Sep 2019 11:53:05 -0400
Received: from localhost.localdomain (unknown [194.230.155.145])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96BB4205F4;
        Mon, 23 Sep 2019 15:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569253982;
        bh=RRBpQ19XUCFxxI3LmeU3oOcF9h1Jo56Mq/DBqYLN3jU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=02aF6aGfgKjqnrWZVGD6FzNlmy0/3HZi1KhUi+KFfLYvFwg+4CFfX94mHndkr/7O/
         BOqIJaqHx1+lcnWVxXnbo52GVpcAjbTrtROXaEO4PZAs7RpAu8OQqfEypQmk62bL9a
         ttOFW2pdOsWZaqKLBrsrXu0khszJTivBnQWtzwGI=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jiri Kosina <trivial@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-can@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-wireless@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, lvs-devel@vger.kernel.org,
        rds-devel@oss.oracle.com
Cc:     Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH trivial 2/2] drivers: net: Fix Kconfig indentation
Date:   Mon, 23 Sep 2019 17:52:43 +0200
Message-Id: <20190923155243.6997-2-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190923155243.6997-1-krzk@kernel.org>
References: <20190923155243.6997-1-krzk@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adjust indentation from spaces to tab (+optional two spaces) as in
coding style with command like:
    $ sed -e 's/^        /\t/' -i */Kconfig

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 drivers/net/Kconfig                           |   2 +-
 drivers/net/arcnet/Kconfig                    |  26 ++--
 drivers/net/can/usb/Kconfig                   |   8 +-
 drivers/net/ethernet/allwinner/Kconfig        |  10 +-
 drivers/net/ethernet/emulex/benet/Kconfig     |   2 +-
 .../net/ethernet/mellanox/mlx5/core/Kconfig   |  36 +++---
 drivers/net/ethernet/nxp/Kconfig              |   8 +-
 drivers/net/ethernet/pensando/Kconfig         |   4 +-
 drivers/net/phy/Kconfig                       |   6 +-
 drivers/net/wireless/ath/Kconfig              |   2 +-
 drivers/net/wireless/ath/ar5523/Kconfig       |   4 +-
 drivers/net/wireless/ath/ath6kl/Kconfig       |   2 +-
 drivers/net/wireless/ath/ath9k/Kconfig        |   2 +-
 drivers/net/wireless/ath/carl9170/Kconfig     |   6 +-
 drivers/net/wireless/atmel/Kconfig            |  32 ++---
 drivers/net/wireless/intel/ipw2x00/Kconfig    | 116 +++++++++---------
 drivers/net/wireless/intel/iwlegacy/Kconfig   |   6 +-
 drivers/net/wireless/intel/iwlwifi/Kconfig    |   6 +-
 drivers/net/wireless/ralink/rt2x00/Kconfig    |  24 ++--
 19 files changed, 151 insertions(+), 151 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 48e209e55843..df1c7989e13d 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -487,7 +487,7 @@ config FUJITSU_ES
 	depends on ACPI
 	help
 	  This driver provides support for Extended Socket network device
-          on Extended Partitioning of FUJITSU PRIMEQUEST 2000 E2 series.
+	  on Extended Partitioning of FUJITSU PRIMEQUEST 2000 E2 series.
 
 config THUNDERBOLT_NET
 	tristate "Networking over Thunderbolt cable"
diff --git a/drivers/net/arcnet/Kconfig b/drivers/net/arcnet/Kconfig
index faeb4419b205..27551bf3d7e4 100644
--- a/drivers/net/arcnet/Kconfig
+++ b/drivers/net/arcnet/Kconfig
@@ -56,19 +56,19 @@ config ARCNET_CAP
 	tristate "Enable CAP mode packet interface"
 	help
 	  ARCnet "cap mode" packet encapsulation. Used to get the hardware
-          acknowledge back to userspace. After the initial protocol byte every
-          packet is stuffed with an extra 4 byte "cookie" which doesn't
-          actually appear on the network. After transmit the driver will send
-          back a packet with protocol byte 0 containing the status of the
-          transmission:
-             0=no hardware acknowledge
-             1=excessive nak
-             2=transmission accepted by the receiver hardware
-
-          Received packets are also stuffed with the extra 4 bytes but it will
-          be random data.
-
-          Cap only listens to protocol 1-8.
+	  acknowledge back to userspace. After the initial protocol byte every
+	  packet is stuffed with an extra 4 byte "cookie" which doesn't
+	  actually appear on the network. After transmit the driver will send
+	  back a packet with protocol byte 0 containing the status of the
+	  transmission:
+	     0=no hardware acknowledge
+	     1=excessive nak
+	     2=transmission accepted by the receiver hardware
+
+	  Received packets are also stuffed with the extra 4 bytes but it will
+	  be random data.
+
+	  Cap only listens to protocol 1-8.
 
 config ARCNET_COM90xx
 	tristate "ARCnet COM90xx (normal) chipset driver"
diff --git a/drivers/net/can/usb/Kconfig b/drivers/net/can/usb/Kconfig
index 4b3d0ddcda79..b412f7ba4f89 100644
--- a/drivers/net/can/usb/Kconfig
+++ b/drivers/net/can/usb/Kconfig
@@ -15,10 +15,10 @@ config CAN_EMS_USB
 	  from EMS Dr. Thomas Wuensche (http://www.ems-wuensche.de).
 
 config CAN_ESD_USB2
-        tristate "ESD USB/2 CAN/USB interface"
-        ---help---
-          This driver supports the CAN-USB/2 interface
-          from esd electronic system design gmbh (http://www.esd.eu).
+	tristate "ESD USB/2 CAN/USB interface"
+	---help---
+	  This driver supports the CAN-USB/2 interface
+	  from esd electronic system design gmbh (http://www.esd.eu).
 
 config CAN_GS_USB
 	tristate "Geschwister Schneider UG interfaces"
diff --git a/drivers/net/ethernet/allwinner/Kconfig b/drivers/net/ethernet/allwinner/Kconfig
index a5e2bcbf2722..264a482ec31d 100644
--- a/drivers/net/ethernet/allwinner/Kconfig
+++ b/drivers/net/ethernet/allwinner/Kconfig
@@ -21,17 +21,17 @@ config NET_VENDOR_ALLWINNER
 if NET_VENDOR_ALLWINNER
 
 config SUN4I_EMAC
-        tristate "Allwinner A10 EMAC support"
+	tristate "Allwinner A10 EMAC support"
 	depends on ARCH_SUNXI
 	depends on OF
 	select CRC32
 	select MII
 	select PHYLIB
 	select MDIO_SUN4I
-        ---help---
-          Support for Allwinner A10 EMAC ethernet driver.
+	---help---
+	  Support for Allwinner A10 EMAC ethernet driver.
 
-          To compile this driver as a module, choose M here.  The module
-          will be called sun4i-emac.
+	  To compile this driver as a module, choose M here.  The module
+	  will be called sun4i-emac.
 
 endif # NET_VENDOR_ALLWINNER
diff --git a/drivers/net/ethernet/emulex/benet/Kconfig b/drivers/net/ethernet/emulex/benet/Kconfig
index e8c7eb842dbe..17d300ea9955 100644
--- a/drivers/net/ethernet/emulex/benet/Kconfig
+++ b/drivers/net/ethernet/emulex/benet/Kconfig
@@ -48,5 +48,5 @@ config BE2NET_SKYHAWK
 	  chipsets. (e.g. OneConnect OCe14xxx)
 
 comment "WARNING: be2net is useless without any enabled chip"
-        depends on BE2NET_BE2=n && BE2NET_BE3=n && BE2NET_LANCER=n && \
+	depends on BE2NET_BE2=n && BE2NET_BE3=n && BE2NET_LANCER=n && \
 	BE2NET_SKYHAWK=n && BE2NET
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
index 0dba272a5b2f..a1f20b205299 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -20,15 +20,15 @@ config MLX5_ACCEL
 	bool
 
 config MLX5_FPGA
-        bool "Mellanox Technologies Innova support"
-        depends on MLX5_CORE
+	bool "Mellanox Technologies Innova support"
+	depends on MLX5_CORE
 	select MLX5_ACCEL
-        ---help---
-          Build support for the Innova family of network cards by Mellanox
-          Technologies. Innova network cards are comprised of a ConnectX chip
-          and an FPGA chip on one board. If you select this option, the
-          mlx5_core driver will include the Innova FPGA core and allow building
-          sandbox-specific client drivers.
+	---help---
+	  Build support for the Innova family of network cards by Mellanox
+	  Technologies. Innova network cards are comprised of a ConnectX chip
+	  and an FPGA chip on one board. If you select this option, the
+	  mlx5_core driver will include the Innova FPGA core and allow building
+	  sandbox-specific client drivers.
 
 config MLX5_CORE_EN
 	bool "Mellanox 5th generation network adapters (ConnectX series) Ethernet support"
@@ -58,14 +58,14 @@ config MLX5_EN_RXNFC
 	  API.
 
 config MLX5_MPFS
-        bool "Mellanox Technologies MLX5 MPFS support"
-        depends on MLX5_CORE_EN
+	bool "Mellanox Technologies MLX5 MPFS support"
+	depends on MLX5_CORE_EN
 	default y
-        ---help---
+	---help---
 	  Mellanox Technologies Ethernet Multi-Physical Function Switch (MPFS)
-          support in ConnectX NIC. MPFs is required for when multi-PF configuration
-          is enabled to allow passing user configured unicast MAC addresses to the
-          requesting PF.
+	  support in ConnectX NIC. MPFs is required for when multi-PF configuration
+	  is enabled to allow passing user configured unicast MAC addresses to the
+	  requesting PF.
 
 config MLX5_ESWITCH
 	bool "Mellanox Technologies MLX5 SRIOV E-Switch support"
@@ -73,10 +73,10 @@ config MLX5_ESWITCH
 	default y
 	---help---
 	  Mellanox Technologies Ethernet SRIOV E-Switch support in ConnectX NIC.
-          E-Switch provides internal SRIOV packet steering and switching for the
-          enabled VFs and PF in two available modes:
-                Legacy SRIOV mode (L2 mac vlan steering based).
-                Switchdev mode (eswitch offloads).
+	  E-Switch provides internal SRIOV packet steering and switching for the
+	  enabled VFs and PF in two available modes:
+	        Legacy SRIOV mode (L2 mac vlan steering based).
+	        Switchdev mode (eswitch offloads).
 
 config MLX5_CORE_EN_DCB
 	bool "Data Center Bridging (DCB) Support"
diff --git a/drivers/net/ethernet/nxp/Kconfig b/drivers/net/ethernet/nxp/Kconfig
index 418afb84c84b..ee83a71c2509 100644
--- a/drivers/net/ethernet/nxp/Kconfig
+++ b/drivers/net/ethernet/nxp/Kconfig
@@ -1,9 +1,9 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config LPC_ENET
-        tristate "NXP ethernet MAC on LPC devices"
-        depends on ARCH_LPC32XX || COMPILE_TEST
-        select PHYLIB
-        help
+	tristate "NXP ethernet MAC on LPC devices"
+	depends on ARCH_LPC32XX || COMPILE_TEST
+	select PHYLIB
+	help
 	  Say Y or M here if you want to use the NXP ethernet MAC included on
 	  some NXP LPC devices. You can safely enable this option for LPC32xx
 	  SoC. Also available as a module.
diff --git a/drivers/net/ethernet/pensando/Kconfig b/drivers/net/ethernet/pensando/Kconfig
index 5ea570be8379..bd0583e409df 100644
--- a/drivers/net/ethernet/pensando/Kconfig
+++ b/drivers/net/ethernet/pensando/Kconfig
@@ -26,7 +26,7 @@ config IONIC
 	  found in
 	  <file:Documentation/networking/device_drivers/pensando/ionic.rst>.
 
-          To compile this driver as a module, choose M here. The module
-          will be called ionic.
+	  To compile this driver as a module, choose M here. The module
+	  will be called ionic.
 
 endif # NET_VENDOR_PENSANDO
diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 03be30cde552..fe602648b99f 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -460,9 +460,9 @@ config RENESAS_PHY
 	  Supports the Renesas PHYs uPD60620 and uPD60620A.
 
 config ROCKCHIP_PHY
-        tristate "Driver for Rockchip Ethernet PHYs"
-        ---help---
-          Currently supports the integrated Ethernet PHY.
+	tristate "Driver for Rockchip Ethernet PHYs"
+	---help---
+	  Currently supports the integrated Ethernet PHY.
 
 config SMSC_PHY
 	tristate "SMSC PHYs"
diff --git a/drivers/net/wireless/ath/Kconfig b/drivers/net/wireless/ath/Kconfig
index d98d6ac90f3d..56616d988c96 100644
--- a/drivers/net/wireless/ath/Kconfig
+++ b/drivers/net/wireless/ath/Kconfig
@@ -34,7 +34,7 @@ config ATH_TRACEPOINTS
        depends on ATH_DEBUG
        depends on EVENT_TRACING
        ---help---
-         This option enables tracepoints for atheros wireless drivers.
+	 This option enables tracepoints for atheros wireless drivers.
 	 Currently, ath9k makes use of this facility.
 
 config ATH_REG_DYNAMIC_USER_REG_HINTS
diff --git a/drivers/net/wireless/ath/ar5523/Kconfig b/drivers/net/wireless/ath/ar5523/Kconfig
index 41d3c9a48b08..65b39c7d035d 100644
--- a/drivers/net/wireless/ath/ar5523/Kconfig
+++ b/drivers/net/wireless/ath/ar5523/Kconfig
@@ -5,5 +5,5 @@ config AR5523
        select ATH_COMMON
        select FW_LOADER
        ---help---
-         This module add support for AR5523 based USB dongles such as D-Link
-         DWL-G132, Netgear WPN111 and many more.
+	 This module add support for AR5523 based USB dongles such as D-Link
+	 DWL-G132, Netgear WPN111 and many more.
diff --git a/drivers/net/wireless/ath/ath6kl/Kconfig b/drivers/net/wireless/ath/ath6kl/Kconfig
index dcf8ca0dcc52..62c22fdcca38 100644
--- a/drivers/net/wireless/ath/ath6kl/Kconfig
+++ b/drivers/net/wireless/ath/ath6kl/Kconfig
@@ -2,7 +2,7 @@
 config ATH6KL
 	tristate "Atheros mobile chipsets support"
 	depends on CFG80211
-        ---help---
+	---help---
 	  This module adds core support for wireless adapters based on
 	  Atheros AR6003 and AR6004 chipsets. You still need separate
 	  bus drivers for USB and SDIO to be able to use real devices.
diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index 2d1247f61297..c99f42284465 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -148,7 +148,7 @@ config ATH9K_CHANNEL_CONTEXT
        depends on ATH9K
        default n
        ---help---
-         This option enables channel context support in ath9k, which is needed
+	 This option enables channel context support in ath9k, which is needed
 	 for multi-channel concurrency. Enable this if P2P PowerSave support
 	 is required.
 
diff --git a/drivers/net/wireless/ath/carl9170/Kconfig b/drivers/net/wireless/ath/carl9170/Kconfig
index 757eb765e17c..b1bce7aad399 100644
--- a/drivers/net/wireless/ath/carl9170/Kconfig
+++ b/drivers/net/wireless/ath/carl9170/Kconfig
@@ -41,9 +41,9 @@ config CARL9170_WPC
 	default y
 
 config CARL9170_HWRNG
-        bool "Random number generator"
-        depends on CARL9170 && (HW_RANDOM = y || HW_RANDOM = CARL9170)
-        default n
+	bool "Random number generator"
+	depends on CARL9170 && (HW_RANDOM = y || HW_RANDOM = CARL9170)
+	default n
 	help
 	  Provides a hardware random number generator to the kernel.
 
diff --git a/drivers/net/wireless/atmel/Kconfig b/drivers/net/wireless/atmel/Kconfig
index 809bdf331848..4c0556b3a5ba 100644
--- a/drivers/net/wireless/atmel/Kconfig
+++ b/drivers/net/wireless/atmel/Kconfig
@@ -20,22 +20,22 @@ config ATMEL
       select FW_LOADER
       select CRC32
        ---help---
-        A driver 802.11b wireless cards based on the Atmel fast-vnet
-        chips. This driver supports standard Linux wireless extensions.
+	A driver 802.11b wireless cards based on the Atmel fast-vnet
+	chips. This driver supports standard Linux wireless extensions.
 
-        Many  cards based on this chipset do not have flash memory
-        and need their firmware loaded at start-up. If yours is
-        one of these, you will need to provide a firmware image
-        to be loaded into the card by the driver. The Atmel
-        firmware package can be downloaded from
-        <http://www.thekelleys.org.uk/atmel>
+	Many  cards based on this chipset do not have flash memory
+	and need their firmware loaded at start-up. If yours is
+	one of these, you will need to provide a firmware image
+	to be loaded into the card by the driver. The Atmel
+	firmware package can be downloaded from
+	<http://www.thekelleys.org.uk/atmel>
 
 config PCI_ATMEL
       tristate "Atmel at76c506 PCI cards"
       depends on ATMEL && PCI
        ---help---
-        Enable support for PCI and mini-PCI cards containing the
-        Atmel at76c506 chip.
+	Enable support for PCI and mini-PCI cards containing the
+	Atmel at76c506 chip.
 
 config PCMCIA_ATMEL
 	tristate "Atmel at76c502/at76c504 PCMCIA cards"
@@ -48,11 +48,11 @@ config PCMCIA_ATMEL
 	  Atmel at76c502 and at76c504 chips.
 
 config AT76C50X_USB
-        tristate "Atmel at76c503/at76c505/at76c505a USB cards"
-        depends on MAC80211 && USB
-        select FW_LOADER
-        ---help---
-          Enable support for USB Wireless devices using Atmel at76c503,
-          at76c505 or at76c505a chips.
+	tristate "Atmel at76c503/at76c505/at76c505a USB cards"
+	depends on MAC80211 && USB
+	select FW_LOADER
+	---help---
+	  Enable support for USB Wireless devices using Atmel at76c503,
+	  at76c505 or at76c505a chips.
 
 endif # WLAN_VENDOR_ATMEL
diff --git a/drivers/net/wireless/intel/ipw2x00/Kconfig b/drivers/net/wireless/intel/ipw2x00/Kconfig
index 5d2878a73732..ab17903ba9f8 100644
--- a/drivers/net/wireless/intel/ipw2x00/Kconfig
+++ b/drivers/net/wireless/intel/ipw2x00/Kconfig
@@ -13,37 +13,37 @@ config IPW2100
 	select LIB80211
 	select LIBIPW
 	---help---
-          A driver for the Intel PRO/Wireless 2100 Network 
+	  A driver for the Intel PRO/Wireless 2100 Network
 	  Connection 802.11b wireless network adapter.
 
-          See <file:Documentation/networking/device_drivers/intel/ipw2100.txt>
+	  See <file:Documentation/networking/device_drivers/intel/ipw2100.txt>
 	  for information on the capabilities currently enabled in this driver
 	  and for tips for debugging issues and problems.
 
 	  In order to use this driver, you will need a firmware image for it.
-          You can obtain the firmware from
-	  <http://ipw2100.sf.net/>.  Once you have the firmware image, you 
+	  You can obtain the firmware from
+	  <http://ipw2100.sf.net/>.  Once you have the firmware image, you
 	  will need to place it in /lib/firmware.
 
-          You will also very likely need the Wireless Tools in order to
-          configure your card:
+	  You will also very likely need the Wireless Tools in order to
+	  configure your card:
 
-          <http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Tools.html>.
+	  <http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Tools.html>.
+
+	  It is recommended that you compile this driver as a module (M)
+	  rather than built-in (Y). This driver requires firmware at device
+	  initialization time, and when built-in this typically happens
+	  before the filesystem is accessible (hence firmware will be
+	  unavailable and initialization will fail). If you do choose to build
+	  this driver into your kernel image, you can avoid this problem by
+	  including the firmware and a firmware loader in an initramfs.
 
-          It is recommended that you compile this driver as a module (M)
-          rather than built-in (Y). This driver requires firmware at device
-          initialization time, and when built-in this typically happens
-          before the filesystem is accessible (hence firmware will be
-          unavailable and initialization will fail). If you do choose to build
-          this driver into your kernel image, you can avoid this problem by
-          including the firmware and a firmware loader in an initramfs.
- 
 config IPW2100_MONITOR
-        bool "Enable promiscuous mode"
-        depends on IPW2100
-        ---help---
+	bool "Enable promiscuous mode"
+	depends on IPW2100
+	---help---
 	  Enables promiscuous/monitor mode support for the ipw2100 driver.
-	  With this feature compiled into the driver, you can switch to 
+	  With this feature compiled into the driver, you can switch to
 	  promiscuous mode via the Wireless Tool's Monitor mode.  While in this
 	  mode, no packets can be sent.
 
@@ -51,17 +51,17 @@ config IPW2100_DEBUG
 	bool "Enable full debugging output in IPW2100 module."
 	depends on IPW2100
 	---help---
-	  This option will enable debug tracing output for the IPW2100.  
+	  This option will enable debug tracing output for the IPW2100.
 
-	  This will result in the kernel module being ~60k larger.  You can 
-	  control which debug output is sent to the kernel log by setting the 
-	  value in 
+	  This will result in the kernel module being ~60k larger.  You can
+	  control which debug output is sent to the kernel log by setting the
+	  value in
 
 	  /sys/bus/pci/drivers/ipw2100/debug_level
 
 	  This entry will only exist if this option is enabled.
 
-	  If you are not trying to debug or develop the IPW2100 driver, you 
+	  If you are not trying to debug or develop the IPW2100 driver, you
 	  most likely want to say N here.
 
 config IPW2200
@@ -75,37 +75,37 @@ config IPW2200
 	select LIB80211
 	select LIBIPW
 	---help---
-          A driver for the Intel PRO/Wireless 2200BG and 2915ABG Network
-	  Connection adapters. 
+	  A driver for the Intel PRO/Wireless 2200BG and 2915ABG Network
+	  Connection adapters.
 
-          See <file:Documentation/networking/device_drivers/intel/ipw2200.txt>
+	  See <file:Documentation/networking/device_drivers/intel/ipw2200.txt>
 	  for information on the capabilities currently enabled in this
 	  driver and for tips for debugging issues and problems.
 
 	  In order to use this driver, you will need a firmware image for it.
-          You can obtain the firmware from
-	  <http://ipw2200.sf.net/>.  See the above referenced README.ipw2200 
+	  You can obtain the firmware from
+	  <http://ipw2200.sf.net/>.  See the above referenced README.ipw2200
 	  for information on where to install the firmware images.
 
-          You will also very likely need the Wireless Tools in order to
-          configure your card:
+	  You will also very likely need the Wireless Tools in order to
+	  configure your card:
 
-          <http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Tools.html>.
+	  <http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Tools.html>.
 
-          It is recommended that you compile this driver as a module (M)
-          rather than built-in (Y). This driver requires firmware at device
-          initialization time, and when built-in this typically happens
-          before the filesystem is accessible (hence firmware will be
-          unavailable and initialization will fail). If you do choose to build
-          this driver into your kernel image, you can avoid this problem by
-          including the firmware and a firmware loader in an initramfs.
+	  It is recommended that you compile this driver as a module (M)
+	  rather than built-in (Y). This driver requires firmware at device
+	  initialization time, and when built-in this typically happens
+	  before the filesystem is accessible (hence firmware will be
+	  unavailable and initialization will fail). If you do choose to build
+	  this driver into your kernel image, you can avoid this problem by
+	  including the firmware and a firmware loader in an initramfs.
 
 config IPW2200_MONITOR
-        bool "Enable promiscuous mode"
-        depends on IPW2200
-        ---help---
+	bool "Enable promiscuous mode"
+	depends on IPW2200
+	---help---
 	  Enables promiscuous/monitor mode support for the ipw2200 driver.
-	  With this feature compiled into the driver, you can switch to 
+	  With this feature compiled into the driver, you can switch to
 	  promiscuous mode via the Wireless Tool's Monitor mode.  While in this
 	  mode, no packets can be sent.
 
@@ -118,28 +118,28 @@ config IPW2200_PROMISCUOUS
 	depends on IPW2200_MONITOR
 	select IPW2200_RADIOTAP
 	---help---
-          Enables the creation of a second interface prefixed 'rtap'. 
-          This second interface will provide every received in radiotap
+	  Enables the creation of a second interface prefixed 'rtap'.
+	  This second interface will provide every received in radiotap
 	  format.
 
-          This is useful for performing wireless network analysis while
-          maintaining an active association.
+	  This is useful for performing wireless network analysis while
+	  maintaining an active association.
+
+	  Example usage:
 
-          Example usage:
+	    % modprobe ipw2200 rtap_iface=1
+	    % ifconfig rtap0 up
+	    % tethereal -i rtap0
 
-            % modprobe ipw2200 rtap_iface=1
-            % ifconfig rtap0 up
-            % tethereal -i rtap0
+	  If you do not specify 'rtap_iface=1' as a module parameter then
+	  the rtap interface will not be created and you will need to turn
+	  it on via sysfs:
 
-          If you do not specify 'rtap_iface=1' as a module parameter then 
-          the rtap interface will not be created and you will need to turn 
-          it on via sysfs:
-	
-            % echo 1 > /sys/bus/pci/drivers/ipw2200/*/rtap_iface
+	    % echo 1 > /sys/bus/pci/drivers/ipw2200/*/rtap_iface
 
 config IPW2200_QOS
-        bool "Enable QoS support"
-        depends on IPW2200
+	bool "Enable QoS support"
+	depends on IPW2200
 
 config IPW2200_DEBUG
 	bool "Enable full debugging output in IPW2200 module."
diff --git a/drivers/net/wireless/intel/iwlegacy/Kconfig b/drivers/net/wireless/intel/iwlegacy/Kconfig
index e329fd7b09c0..100f55858b13 100644
--- a/drivers/net/wireless/intel/iwlegacy/Kconfig
+++ b/drivers/net/wireless/intel/iwlegacy/Kconfig
@@ -91,9 +91,9 @@ config IWLEGACY_DEBUG
 	  any problems you may encounter.
 
 config IWLEGACY_DEBUGFS
-        bool "iwlegacy (iwl 3945/4965) debugfs support"
-        depends on IWLEGACY && MAC80211_DEBUGFS
-        ---help---
+	bool "iwlegacy (iwl 3945/4965) debugfs support"
+	depends on IWLEGACY && MAC80211_DEBUGFS
+	---help---
 	  Enable creation of debugfs files for the iwlegacy drivers. This
 	  is a low-impact option that allows getting insight into the
 	  driver's state at runtime.
diff --git a/drivers/net/wireless/intel/iwlwifi/Kconfig b/drivers/net/wireless/intel/iwlwifi/Kconfig
index 7dbc0d38bb3b..091d621ad25f 100644
--- a/drivers/net/wireless/intel/iwlwifi/Kconfig
+++ b/drivers/net/wireless/intel/iwlwifi/Kconfig
@@ -119,9 +119,9 @@ config IWLWIFI_DEBUG
 	  any problems you may encounter.
 
 config IWLWIFI_DEBUGFS
-        bool "iwlwifi debugfs support"
-        depends on MAC80211_DEBUGFS
-        ---help---
+	bool "iwlwifi debugfs support"
+	depends on MAC80211_DEBUGFS
+	---help---
 	  Enable creation of debugfs files for the iwlwifi drivers. This
 	  is a low-impact option that allows getting insight into the
 	  driver's state at runtime.
diff --git a/drivers/net/wireless/ralink/rt2x00/Kconfig b/drivers/net/wireless/ralink/rt2x00/Kconfig
index 858f8aa3e616..f8a9244ce012 100644
--- a/drivers/net/wireless/ralink/rt2x00/Kconfig
+++ b/drivers/net/wireless/ralink/rt2x00/Kconfig
@@ -98,17 +98,17 @@ config RT2800PCI_RT53XX
        bool "rt2800pci - Include support for rt53xx devices (EXPERIMENTAL)"
        default y
        ---help---
-         This adds support for rt53xx wireless chipset family to the
-         rt2800pci driver.
-         Supported chips: RT5390
+	 This adds support for rt53xx wireless chipset family to the
+	 rt2800pci driver.
+	 Supported chips: RT5390
 
 config RT2800PCI_RT3290
        bool "rt2800pci - Include support for rt3290 devices (EXPERIMENTAL)"
        default y
        ---help---
-         This adds support for rt3290 wireless chipset family to the
-         rt2800pci driver.
-         Supported chips: RT3290
+	 This adds support for rt3290 wireless chipset family to the
+	 rt2800pci driver.
+	 Supported chips: RT3290
 endif
 
 config RT2500USB
@@ -176,16 +176,16 @@ config RT2800USB_RT3573
 config RT2800USB_RT53XX
        bool "rt2800usb - Include support for rt53xx devices (EXPERIMENTAL)"
        ---help---
-         This adds support for rt53xx wireless chipset family to the
-         rt2800usb driver.
-         Supported chips: RT5370
+	 This adds support for rt53xx wireless chipset family to the
+	 rt2800usb driver.
+	 Supported chips: RT5370
 
 config RT2800USB_RT55XX
        bool "rt2800usb - Include support for rt55xx devices (EXPERIMENTAL)"
        ---help---
-         This adds support for rt55xx wireless chipset family to the
-         rt2800usb driver.
-         Supported chips: RT5572
+	 This adds support for rt55xx wireless chipset family to the
+	 rt2800usb driver.
+	 Supported chips: RT5572
 
 config RT2800USB_UNKNOWN
 	bool "rt2800usb - Include support for unknown (USB) devices"
-- 
2.17.1

