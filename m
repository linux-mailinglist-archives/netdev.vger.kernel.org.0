Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 091BD2DF122
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 19:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727446AbgLSS4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Dec 2020 13:56:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:36004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725951AbgLSS43 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Dec 2020 13:56:29 -0500
From:   Jakub Kicinski <kuba@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pv-drivers@vmware.com, doshir@vmware.com,
        UNGLinuxDriver@microchip.com, steve.glendinning@shawell.net,
        woojung.huh@microchip.com, ath9k-devel@qca.qualcomm.com,
        linux-wireless@vger.kernel.org, drivers@pensando.io,
        snelson@pensando.io, vladimir.oltean@nxp.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        bryan.whitehead@microchip.com, o.rempel@pengutronix.de,
        kernel@pengutronix.de, robin@protonic.nl, hkallweit1@gmail.com,
        nic_swsd@realtek.com, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, linux-kernel@vger.kernel.org,
        corbet@lwn.net, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] MAINTAINERS: remove names from mailing list maintainers
Date:   Sat, 19 Dec 2020 10:55:38 -0800
Message-Id: <20201219185538.750076-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When searching for inactive maintainers it's useful to filter
out mailing list addresses. Such "maintainers" will obviously
never feature in a "From:" line of an email or a review tag.

Since "L:" entries only provide the address of a mailing list
without a fancy name extend this pattern to "M:" entries.

Alternatively we could reserve M: entries for humans only
and move the fake "maintainers" to L:. While I'd personally
prefer to reserve M: for humans only, I'm not 100% that's
a great choice either, given most L: entries are in fact
open mailing lists with public archives.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 MAINTAINERS | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 28d7acdb0591..20cd4cc08dd1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -203,8 +203,8 @@ F:	include/uapi/linux/nl80211.h
 F:	net/wireless/
 
 8169 10/100/1000 GIGABIT ETHERNET DRIVER
-M:	Realtek linux nic maintainers <nic_swsd@realtek.com>
 M:	Heiner Kallweit <hkallweit1@gmail.com>
+M:	nic_swsd@realtek.com
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/realtek/r8169*
@@ -2119,7 +2119,7 @@ N:	atmel
 ARM/Microchip Sparx5 SoC support
 M:	Lars Povlsen <lars.povlsen@microchip.com>
 M:	Steen Hegelund <Steen.Hegelund@microchip.com>
-M:	Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
+M:	UNGLinuxDriver@microchip.com
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Supported
 T:	git git://github.com/microchip-ung/linux-upstream.git
@@ -3958,7 +3958,7 @@ F:	net/can/
 CAN-J1939 NETWORK LAYER
 M:	Robin van der Gracht <robin@protonic.nl>
 M:	Oleksij Rempel <o.rempel@pengutronix.de>
-R:	Pengutronix Kernel Team <kernel@pengutronix.de>
+R:	kernel@pengutronix.de
 L:	linux-can@vger.kernel.org
 S:	Maintained
 F:	Documentation/networking/j1939.rst
@@ -11651,7 +11651,7 @@ F:	drivers/media/platform/atmel/atmel-isi.h
 
 MICROCHIP KSZ SERIES ETHERNET SWITCH DRIVER
 M:	Woojung Huh <woojung.huh@microchip.com>
-M:	Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
+M:	UNGLinuxDriver@microchip.com
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
@@ -11661,7 +11661,7 @@ F:	net/dsa/tag_ksz.c
 
 MICROCHIP LAN743X ETHERNET DRIVER
 M:	Bryan Whitehead <bryan.whitehead@microchip.com>
-M:	Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
+M:	UNGLinuxDriver@microchip.com
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/microchip/lan743x_*
@@ -11755,7 +11755,7 @@ F:	drivers/net/wireless/microchip/wilc1000/
 
 MICROSEMI MIPS SOCS
 M:	Alexandre Belloni <alexandre.belloni@bootlin.com>
-M:	Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
+M:	UNGLinuxDriver@microchip.com
 L:	linux-mips@vger.kernel.org
 S:	Supported
 F:	Documentation/devicetree/bindings/mips/mscc.txt
@@ -12809,10 +12809,10 @@ F:	tools/objtool/
 F:	include/linux/objtool.h
 
 OCELOT ETHERNET SWITCH DRIVER
-M:	Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
 M:	Vladimir Oltean <vladimir.oltean@nxp.com>
 M:	Claudiu Manoil <claudiu.manoil@nxp.com>
 M:	Alexandre Belloni <alexandre.belloni@bootlin.com>
+M:	UNGLinuxDriver@microchip.com
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/dsa/ocelot/*
@@ -13874,7 +13874,7 @@ F:	drivers/platform/x86/peaq-wmi.c
 
 PENSANDO ETHERNET DRIVERS
 M:	Shannon Nelson <snelson@pensando.io>
-M:	Pensando Drivers <drivers@pensando.io>
+M:	drivers@pensando.io
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	Documentation/networking/device_drivers/ethernet/pensando/ionic.rst
@@ -14653,7 +14653,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git
 F:	drivers/net/wireless/ath/ath11k/
 
 QUALCOMM ATHEROS ATH9K WIRELESS DRIVER
-M:	QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
+M:	ath9k-devel@qca.qualcomm.com
 L:	linux-wireless@vger.kernel.org
 S:	Supported
 W:	https://wireless.wiki.kernel.org/en/users/Drivers/ath9k
@@ -18338,7 +18338,7 @@ F:	include/linux/usb/isp116x.h
 
 USB LAN78XX ETHERNET DRIVER
 M:	Woojung Huh <woojung.huh@microchip.com>
-M:	Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
+M:	UNGLinuxDriver@microchip.com
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/microchip,lan78xx.txt
@@ -18452,7 +18452,7 @@ F:	drivers/net/usb/smsc75xx.*
 
 USB SMSC95XX ETHERNET DRIVER
 M:	Steve Glendinning <steve.glendinning@shawell.net>
-M:	Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
+M:	UNGLinuxDriver@microchip.com
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/usb/smsc95xx.*
@@ -18999,7 +18999,7 @@ F:	drivers/input/mouse/vmmouse.h
 
 VMWARE VMXNET3 ETHERNET DRIVER
 M:	Ronak Doshi <doshir@vmware.com>
-M:	"VMware, Inc." <pv-drivers@vmware.com>
+M:	pv-drivers@vmware.com
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/vmxnet3/
-- 
2.26.2

