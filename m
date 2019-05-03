Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A84412931
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 09:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbfECH4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 03:56:44 -0400
Received: from smtp-out.xnet.cz ([178.217.244.18]:44294 "EHLO smtp-out.xnet.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727144AbfECH4m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 May 2019 03:56:42 -0400
Received: from meh.true.cz (meh.true.cz [108.61.167.218])
        (Authenticated sender: petr@true.cz)
        by smtp-out.xnet.cz (Postfix) with ESMTPSA id 4BE78357B;
        Fri,  3 May 2019 09:56:35 +0200 (CEST)
Received: by meh.true.cz (OpenSMTPD) with ESMTP id 7a9904cf;
        Fri, 3 May 2019 09:56:34 +0200 (CEST)
From:   =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>
To:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org
Subject: [PATCH v3 02/10] dt-bindings: doc: reflect new NVMEM of_get_mac_address behaviour
Date:   Fri,  3 May 2019 09:55:59 +0200
Message-Id: <1556870168-26864-3-git-send-email-ynezz@true.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1556870168-26864-1-git-send-email-ynezz@true.cz>
References: <1556870168-26864-1-git-send-email-ynezz@true.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As of_get_mac_address now supports NVMEM under the hood, we need to update
the bindings documentation with the new nvmem-cell* properties, which would
mean copy&pasting a lot of redundant information to every binding
documentation currently referencing some of the MAC address properties.

So I've just removed all the references to the optional MAC address
properties and replaced them with the small note referencing
net/ethernet.txt file.

Signed-off-by: Petr Štetiar <ynezz@true.cz>
---

 Changes since v2:

 * replaced only MAC address related optional properties with a text
   referencing ethernet.txt

 Documentation/devicetree/bindings/net/altera_tse.txt           |  5 ++---
 Documentation/devicetree/bindings/net/amd-xgbe.txt             |  5 +++--
 Documentation/devicetree/bindings/net/brcm,amac.txt            |  4 ++--
 Documentation/devicetree/bindings/net/cpsw.txt                 |  4 +++-
 Documentation/devicetree/bindings/net/davinci_emac.txt         |  5 +++--
 Documentation/devicetree/bindings/net/dsa/dsa.txt              |  5 ++---
 Documentation/devicetree/bindings/net/ethernet.txt             |  6 ++++--
 Documentation/devicetree/bindings/net/hisilicon-femac.txt      |  4 +++-
 .../devicetree/bindings/net/hisilicon-hix5hd2-gmac.txt         |  4 +++-
 Documentation/devicetree/bindings/net/keystone-netcp.txt       | 10 +++++-----
 Documentation/devicetree/bindings/net/macb.txt                 |  5 ++---
 Documentation/devicetree/bindings/net/marvell-pxa168.txt       |  4 +++-
 Documentation/devicetree/bindings/net/microchip,enc28j60.txt   |  3 ++-
 Documentation/devicetree/bindings/net/microchip,lan78xx.txt    |  5 ++---
 Documentation/devicetree/bindings/net/qca,qca7000.txt          |  4 +++-
 Documentation/devicetree/bindings/net/samsung-sxgbe.txt        |  4 +++-
 .../devicetree/bindings/net/snps,dwc-qos-ethernet.txt          |  5 +++--
 .../devicetree/bindings/net/socionext,uniphier-ave4.txt        |  4 ++--
 Documentation/devicetree/bindings/net/socionext-netsec.txt     |  5 +++--
 .../devicetree/bindings/net/wireless/mediatek,mt76.txt         |  5 +++--
 Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt   |  4 ++--
 21 files changed, 58 insertions(+), 42 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/altera_tse.txt b/Documentation/devicetree/bindings/net/altera_tse.txt
index 0e21df9..0b7d4d3 100644
--- a/Documentation/devicetree/bindings/net/altera_tse.txt
+++ b/Documentation/devicetree/bindings/net/altera_tse.txt
@@ -46,9 +46,8 @@ Required properties:
 	- reg: phy id used to communicate to phy.
 	- device_type: Must be "ethernet-phy".
 
-Optional properties:
-- local-mac-address: See ethernet.txt in the same directory.
-- max-frame-size: See ethernet.txt in the same directory.
+The MAC address will be determined using the optional properties defined in
+ethernet.txt.
 
 Example:
 
diff --git a/Documentation/devicetree/bindings/net/amd-xgbe.txt b/Documentation/devicetree/bindings/net/amd-xgbe.txt
index 93dcb79..9c27dfc 100644
--- a/Documentation/devicetree/bindings/net/amd-xgbe.txt
+++ b/Documentation/devicetree/bindings/net/amd-xgbe.txt
@@ -24,8 +24,6 @@ Required properties:
 - phy-mode: See ethernet.txt file in the same directory
 
 Optional properties:
-- mac-address: mac address to be assigned to the device. Can be overridden
-  by UEFI.
 - dma-coherent: Present if dma operations are coherent
 - amd,per-channel-interrupt: Indicates that Rx and Tx complete will generate
   a unique interrupt for each DMA channel - this requires an additional
@@ -34,6 +32,9 @@ Optional properties:
     0 - 1GbE and 10GbE (default)
     1 - 2.5GbE and 10GbE
 
+The MAC address will be determined using the optional properties defined in
+ethernet.txt.
+
 The following optional properties are represented by an array with each
 value corresponding to a particular speed. The first array value represents
 the setting for the 1GbE speed, the second value for the 2.5GbE speed and
diff --git a/Documentation/devicetree/bindings/net/brcm,amac.txt b/Documentation/devicetree/bindings/net/brcm,amac.txt
index 0bfad65..0120ebe 100644
--- a/Documentation/devicetree/bindings/net/brcm,amac.txt
+++ b/Documentation/devicetree/bindings/net/brcm,amac.txt
@@ -16,8 +16,8 @@ Required properties:
 				registers (required for Northstar2)
  - interrupts:	Interrupt number
 
-Optional properties:
-- mac-address:	See ethernet.txt file in the same directory
+The MAC address will be determined using the optional properties
+defined in ethernet.txt.
 
 Examples:
 
diff --git a/Documentation/devicetree/bindings/net/cpsw.txt b/Documentation/devicetree/bindings/net/cpsw.txt
index 3264e19..7c7ac5e 100644
--- a/Documentation/devicetree/bindings/net/cpsw.txt
+++ b/Documentation/devicetree/bindings/net/cpsw.txt
@@ -49,10 +49,12 @@ Required properties:
 
 Optional properties:
 - dual_emac_res_vlan	: Specifies VID to be used to segregate the ports
-- mac-address		: See ethernet.txt file in the same directory
 - phy_id		: Specifies slave phy id (deprecated, use phy-handle)
 - phy-handle		: See ethernet.txt file in the same directory
 
+The MAC address will be determined using the optional properties
+defined in ethernet.txt.
+
 Slave sub-nodes:
 - fixed-link		: See fixed-link.txt file in the same directory
 
diff --git a/Documentation/devicetree/bindings/net/davinci_emac.txt b/Documentation/devicetree/bindings/net/davinci_emac.txt
index ca83dcc..5e3579e 100644
--- a/Documentation/devicetree/bindings/net/davinci_emac.txt
+++ b/Documentation/devicetree/bindings/net/davinci_emac.txt
@@ -20,11 +20,12 @@ Required properties:
 Optional properties:
 - phy-handle: See ethernet.txt file in the same directory.
               If absent, davinci_emac driver defaults to 100/FULL.
-- nvmem-cells: phandle, reference to an nvmem node for the MAC address
-- nvmem-cell-names: string, should be "mac-address" if nvmem is to be used
 - ti,davinci-rmii-en: 1 byte, 1 means use RMII
 - ti,davinci-no-bd-ram: boolean, does EMAC have BD RAM?
 
+The MAC address will be determined using the optional properties
+defined in ethernet.txt.
+
 Example (enbw_cmc board):
 	eth0: emac@1e20000 {
 		compatible = "ti,davinci-dm6467-emac";
diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.txt b/Documentation/devicetree/bindings/net/dsa/dsa.txt
index d66a529..a237567 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa.txt
+++ b/Documentation/devicetree/bindings/net/dsa/dsa.txt
@@ -71,9 +71,8 @@ properties, described in binding documents:
 			  Documentation/devicetree/bindings/net/fixed-link.txt
 			  for details.
 
-- local-mac-address	: See
-			  Documentation/devicetree/bindings/net/ethernet.txt
-			  for details.
+The MAC address will be determined using the optional properties
+defined in ethernet.txt.
 
 Example
 
diff --git a/Documentation/devicetree/bindings/net/ethernet.txt b/Documentation/devicetree/bindings/net/ethernet.txt
index a686215..6992444 100644
--- a/Documentation/devicetree/bindings/net/ethernet.txt
+++ b/Documentation/devicetree/bindings/net/ethernet.txt
@@ -4,12 +4,14 @@ NOTE: All 'phy*' properties documented below are Ethernet specific. For the
 generic PHY 'phys' property, see
 Documentation/devicetree/bindings/phy/phy-bindings.txt.
 
-- local-mac-address: array of 6 bytes, specifies the MAC address that was
-  assigned to the network device;
 - mac-address: array of 6 bytes, specifies the MAC address that was last used by
   the boot program; should be used in cases where the MAC address assigned to
   the device by the boot program is different from the "local-mac-address"
   property;
+- local-mac-address: array of 6 bytes, specifies the MAC address that was
+  assigned to the network device;
+- nvmem-cells: phandle, reference to an nvmem node for the MAC address
+- nvmem-cell-names: string, should be "mac-address" if nvmem is to be used
 - max-speed: number, specifies maximum speed in Mbit/s supported by the device;
 - max-frame-size: number, maximum transfer unit (IEEE defined MTU), rather than
   the maximum frame size (there's contradiction in the Devicetree
diff --git a/Documentation/devicetree/bindings/net/hisilicon-femac.txt b/Documentation/devicetree/bindings/net/hisilicon-femac.txt
index d11af5e..5f96976 100644
--- a/Documentation/devicetree/bindings/net/hisilicon-femac.txt
+++ b/Documentation/devicetree/bindings/net/hisilicon-femac.txt
@@ -14,7 +14,6 @@ Required properties:
 	the PHY reset signal(optional).
 - reset-names: should contain the reset signal name "mac"(required)
 	and "phy"(optional).
-- mac-address: see ethernet.txt [1].
 - phy-mode: see ethernet.txt [1].
 - phy-handle: see ethernet.txt [1].
 - hisilicon,phy-reset-delays-us: triplet of delays if PHY reset signal given.
@@ -22,6 +21,9 @@ Required properties:
 	The 2nd cell is reset pulse in micro seconds.
 	The 3rd cell is reset post-delay in micro seconds.
 
+The MAC address will be determined using the optional properties
+defined in ethernet.txt[1].
+
 [1] Documentation/devicetree/bindings/net/ethernet.txt
 
 Example:
diff --git a/Documentation/devicetree/bindings/net/hisilicon-hix5hd2-gmac.txt b/Documentation/devicetree/bindings/net/hisilicon-hix5hd2-gmac.txt
index eea73ad..cddf46b 100644
--- a/Documentation/devicetree/bindings/net/hisilicon-hix5hd2-gmac.txt
+++ b/Documentation/devicetree/bindings/net/hisilicon-hix5hd2-gmac.txt
@@ -18,7 +18,6 @@ Required properties:
 - #size-cells: must be <0>.
 - phy-mode: see ethernet.txt [1].
 - phy-handle: see ethernet.txt [1].
-- mac-address: see ethernet.txt [1].
 - clocks: clock phandle and specifier pair.
 - clock-names: contain the clock name "mac_core"(required) and "mac_ifc"(optional).
 - resets: should contain the phandle to the MAC core reset signal(optional),
@@ -31,6 +30,9 @@ Required properties:
 	The 2nd cell is reset pulse in micro seconds.
 	The 3rd cell is reset post-delay in micro seconds.
 
+The MAC address will be determined using the properties defined in
+ethernet.txt[1].
+
 - PHY subnode: inherits from phy binding [2]
 
 [1] Documentation/devicetree/bindings/net/ethernet.txt
diff --git a/Documentation/devicetree/bindings/net/keystone-netcp.txt b/Documentation/devicetree/bindings/net/keystone-netcp.txt
index 04ba1dc..3a65aab 100644
--- a/Documentation/devicetree/bindings/net/keystone-netcp.txt
+++ b/Documentation/devicetree/bindings/net/keystone-netcp.txt
@@ -135,14 +135,14 @@ Optional properties:
 		are swapped.  The netcp driver will swap the two DWORDs
 		back to the proper order when this property is set to 2
 		when it obtains the mac address from efuse.
-- local-mac-address:	the driver is designed to use the of_get_mac_address api
-			only if efuse-mac is 0. When efuse-mac is 0, the MAC
-			address is obtained from local-mac-address. If this
-			attribute is not present, then the driver will use a
-			random MAC address.
 - "netcp-device label":	phandle to the device specification for each of NetCP
 			sub-module attached to this interface.
 
+The MAC address will be determined using the optional properties defined in
+ethernet.txt, as provided by the of_get_mac_address API and only if efuse-mac
+is set to 0. If any of the optional MAC address properties are not present,
+then the driver will use random MAC address.
+
 Example binding:
 
 netcp: netcp@2000000 {
diff --git a/Documentation/devicetree/bindings/net/macb.txt b/Documentation/devicetree/bindings/net/macb.txt
index 8b80515..9c5e944 100644
--- a/Documentation/devicetree/bindings/net/macb.txt
+++ b/Documentation/devicetree/bindings/net/macb.txt
@@ -26,9 +26,8 @@ Required properties:
 	Optional elements: 'tsu_clk'
 - clocks: Phandles to input clocks.
 
-Optional properties:
-- nvmem-cells: phandle, reference to an nvmem node for the MAC address
-- nvmem-cell-names: string, should be "mac-address" if nvmem is to be used
+The MAC address will be determined using the optional properties
+defined in ethernet.txt.
 
 Optional properties for PHY child node:
 - reset-gpios : Should specify the gpio for phy reset
diff --git a/Documentation/devicetree/bindings/net/marvell-pxa168.txt b/Documentation/devicetree/bindings/net/marvell-pxa168.txt
index 845a148..5574af3 100644
--- a/Documentation/devicetree/bindings/net/marvell-pxa168.txt
+++ b/Documentation/devicetree/bindings/net/marvell-pxa168.txt
@@ -11,7 +11,9 @@ Optional properties:
 - #address-cells: must be 1 when using sub-nodes.
 - #size-cells: must be 0 when using sub-nodes.
 - phy-handle: see ethernet.txt file in the same directory.
-- local-mac-address: see ethernet.txt file in the same directory.
+
+The MAC address will be determined using the optional properties
+defined in ethernet.txt.
 
 Sub-nodes:
 Each PHY can be represented as a sub-node. This is not mandatory.
diff --git a/Documentation/devicetree/bindings/net/microchip,enc28j60.txt b/Documentation/devicetree/bindings/net/microchip,enc28j60.txt
index 24626e0..a827592 100644
--- a/Documentation/devicetree/bindings/net/microchip,enc28j60.txt
+++ b/Documentation/devicetree/bindings/net/microchip,enc28j60.txt
@@ -21,8 +21,9 @@ Optional properties:
 - spi-max-frequency: Maximum frequency of the SPI bus when accessing the ENC28J60.
   According to the ENC28J80 datasheet, the chip allows a maximum of 20 MHz, however,
   board designs may need to limit this value.
-- local-mac-address: See ethernet.txt in the same directory.
 
+The MAC address will be determined using the optional properties
+defined in ethernet.txt.
 
 Example (for NXP i.MX28 with pin control stuff for GPIO irq):
 
diff --git a/Documentation/devicetree/bindings/net/microchip,lan78xx.txt b/Documentation/devicetree/bindings/net/microchip,lan78xx.txt
index 76786a0..11a6795 100644
--- a/Documentation/devicetree/bindings/net/microchip,lan78xx.txt
+++ b/Documentation/devicetree/bindings/net/microchip,lan78xx.txt
@@ -7,9 +7,8 @@ The Device Tree properties, if present, override the OTP and EEPROM.
 Required properties:
 - compatible: Should be one of "usb424,7800", "usb424,7801" or "usb424,7850".
 
-Optional properties:
-- local-mac-address:   see ethernet.txt
-- mac-address:         see ethernet.txt
+The MAC address will be determined using the optional properties
+defined in ethernet.txt.
 
 Optional properties of the embedded PHY:
 - microchip,led-modes: a 0..4 element vector, with each element configuring
diff --git a/Documentation/devicetree/bindings/net/qca,qca7000.txt b/Documentation/devicetree/bindings/net/qca,qca7000.txt
index e4a8a51..21c36e5 100644
--- a/Documentation/devicetree/bindings/net/qca,qca7000.txt
+++ b/Documentation/devicetree/bindings/net/qca,qca7000.txt
@@ -23,7 +23,6 @@ Optional properties:
 		      Numbers smaller than 1000000 or greater than 16000000
 		      are invalid. Missing the property will set the SPI
 		      frequency to 8000000 Hertz.
-- local-mac-address : see ./ethernet.txt
 - qca,legacy-mode   : Set the SPI data transfer of the QCA7000 to legacy mode.
 		      In this mode the SPI master must toggle the chip select
 		      between each data word. In burst mode these gaps aren't
@@ -31,6 +30,9 @@ Optional properties:
 		      the QCA7000 is setup via GPIO pin strapping. If the
 		      property is missing the driver defaults to burst mode.
 
+The MAC address will be determined using the optional properties
+defined in ethernet.txt.
+
 SPI Example:
 
 /* Freescale i.MX28 SPI master*/
diff --git a/Documentation/devicetree/bindings/net/samsung-sxgbe.txt b/Documentation/devicetree/bindings/net/samsung-sxgbe.txt
index 46e5911..2cff6d8 100644
--- a/Documentation/devicetree/bindings/net/samsung-sxgbe.txt
+++ b/Documentation/devicetree/bindings/net/samsung-sxgbe.txt
@@ -21,10 +21,12 @@ Required properties:
   range.
 
 Optional properties:
-- mac-address: 6 bytes, mac address
 - max-frame-size: Maximum Transfer Unit (IEEE defined MTU), rather
 		  than the maximum frame size.
 
+The MAC address will be determined using the optional properties
+defined in ethernet.txt.
+
 Example:
 
 	aliases {
diff --git a/Documentation/devicetree/bindings/net/snps,dwc-qos-ethernet.txt b/Documentation/devicetree/bindings/net/snps,dwc-qos-ethernet.txt
index 36f1aef..ad3c6e1 100644
--- a/Documentation/devicetree/bindings/net/snps,dwc-qos-ethernet.txt
+++ b/Documentation/devicetree/bindings/net/snps,dwc-qos-ethernet.txt
@@ -103,8 +103,6 @@ Required properties:
 
 Optional properties:
 - dma-coherent: Present if dma operations are coherent
-- mac-address: See ethernet.txt in the same directory
-- local-mac-address: See ethernet.txt in the same directory
 - phy-reset-gpios: Phandle and specifier for any GPIO used to reset the PHY.
   See ../gpio/gpio.txt.
 - snps,en-lpi: If present it enables use of the AXI low-power interface
@@ -133,6 +131,9 @@ Optional properties:
     - device_type: Must be "ethernet-phy".
     - fixed-mode device tree subnode: see fixed-link.txt in the same directory
 
+The MAC address will be determined using the optional properties
+defined in ethernet.txt.
+
 Examples:
 ethernet2@40010000 {
 	clock-names = "phy_ref_clk", "apb_pclk";
diff --git a/Documentation/devicetree/bindings/net/socionext,uniphier-ave4.txt b/Documentation/devicetree/bindings/net/socionext,uniphier-ave4.txt
index fc8f017..4e85fc4 100644
--- a/Documentation/devicetree/bindings/net/socionext,uniphier-ave4.txt
+++ b/Documentation/devicetree/bindings/net/socionext,uniphier-ave4.txt
@@ -31,8 +31,8 @@ Required properties:
  - socionext,syscon-phy-mode: A phandle to syscon with one argument
 	that configures phy mode. The argument is the ID of MAC instance.
 
-Optional properties:
- - local-mac-address: See ethernet.txt in the same directory.
+The MAC address will be determined using the optional properties
+defined in ethernet.txt.
 
 Required subnode:
  - mdio: A container for child nodes representing phy nodes.
diff --git a/Documentation/devicetree/bindings/net/socionext-netsec.txt b/Documentation/devicetree/bindings/net/socionext-netsec.txt
index 0cff94f..9d6c9feb 100644
--- a/Documentation/devicetree/bindings/net/socionext-netsec.txt
+++ b/Documentation/devicetree/bindings/net/socionext-netsec.txt
@@ -26,11 +26,12 @@ Required properties:
 Optional properties: (See ethernet.txt file in the same directory)
 - dma-coherent: Boolean property, must only be present if memory
 	accesses performed by the device are cache coherent.
-- local-mac-address: See ethernet.txt in the same directory.
-- mac-address: See ethernet.txt in the same directory.
 - max-speed: See ethernet.txt in the same directory.
 - max-frame-size: See ethernet.txt in the same directory.
 
+The MAC address will be determined using the optional properties
+defined in ethernet.txt.
+
 Example:
 	eth0: ethernet@522d0000 {
 		compatible = "socionext,synquacer-netsec";
diff --git a/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt
index 7b9a776..7466550 100644
--- a/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt
+++ b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt
@@ -13,11 +13,12 @@ properties:
 
 Optional properties:
 
-- mac-address: See ethernet.txt in the parent directory
-- local-mac-address: See ethernet.txt in the parent directory
 - ieee80211-freq-limit: See ieee80211.txt
 - mediatek,mtd-eeprom: Specify a MTD partition + offset containing EEPROM data
 
+The driver is using of_get_mac_address API, so the MAC address can be as well
+be set with corresponding optional properties defined in net/ethernet.txt.
+
 Optional nodes:
 - led: Properties for a connected LED
   Optional properties:
diff --git a/Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt b/Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt
index b7396c8..aaaeeb5 100644
--- a/Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt
+++ b/Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt
@@ -34,9 +34,9 @@ Optional properties:
 			ath9k wireless chip (in this case the calibration /
 			EEPROM data will be loaded from userspace using the
 			kernel firmware loader).
-- mac-address: See ethernet.txt in the parent directory
-- local-mac-address: See ethernet.txt in the parent directory
 
+The MAC address will be determined using the optional properties defined in
+net/ethernet.txt.
 
 In this example, the node is defined as child node of the PCI controller:
 &pci0 {
-- 
1.9.1

