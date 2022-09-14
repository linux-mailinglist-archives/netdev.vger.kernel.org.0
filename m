Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9955B8356
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 10:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbiINIzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 04:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiINIzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 04:55:41 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316DF2CDF1;
        Wed, 14 Sep 2022 01:55:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1663145710; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=N7z0aGEDn+0EwDA/Ajf3aOtLqdY5lJjAnszbXSoNbjDcezB8GBf5rBpa7uosirgbDyWSY3LykMOw3ELlDbgxnTb79lnhWFTrL5QuaYheaN4pHaK2bsl6vfEpf35LMlznqQ29mAQQNc205vGighBBW5+mjKkEIL320wNgG0yMqp8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1663145710; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=X/Wt+Y94rMwALGSEACdcswFA6kDWzirCzDRw4TCsfoc=; 
        b=cCcXaAgU27pO/7t3PgKvWrnmg86uyGJrOF5E8F9lHKPKGS18hZOroRgr8EkcOAfEV/kdeZsNch1hSYnZhaH4yzyRnK/wdVNdoMY0Lf/oVTPM8YvBxC+s3QmFKuIiD1APnIN5T1rPXHgWZSvygDWdKIHFeGO4LOA/F4wfetVFXPI=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1663145710;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding:Reply-To;
        bh=X/Wt+Y94rMwALGSEACdcswFA6kDWzirCzDRw4TCsfoc=;
        b=LYyKqjUsaA8jZaKODD58+cY+MUE+CWTCXZMiGnkwmEm5CQ4YxVICll0S/87yQwz1
        mC3LQ4i+p3A//oSNLTJpl5hudeOIr7tlxvY3XAEwlF3woUiPfo5z+4eY4TGeYATet6o
        yY+x4c7t8M1jMuAY/bPiLlHD7SSo9xK+UOXk6Fvk=
Received: from arinc9-PC.lan (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1663145707927783.0802898179184; Wed, 14 Sep 2022 01:55:07 -0700 (PDT)
From:   =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        erkin.bozoglu@xeront.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>
Subject: [PATCH 01/10] dt-bindings: net: drop old mediatek bindings
Date:   Wed, 14 Sep 2022 11:54:42 +0300
Message-Id: <20220914085451.11723-2-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220914085451.11723-1-arinc.unal@arinc9.com>
References: <20220914085451.11723-1-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove these old mediatek bindings which are not used.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 .../bindings/net/mediatek,mt7620-gsw.txt      | 24 --------
 .../bindings/net/ralink,rt2880-net.txt        | 59 -------------------
 .../bindings/net/ralink,rt3050-esw.txt        | 30 ----------
 3 files changed, 113 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/mediatek,mt7620-gsw.txt
 delete mode 100644 Documentation/devicetree/bindings/net/ralink,rt2880-net.txt
 delete mode 100644 Documentation/devicetree/bindings/net/ralink,rt3050-esw.txt

diff --git a/Documentation/devicetree/bindings/net/mediatek,mt7620-gsw.txt b/Documentation/devicetree/bindings/net/mediatek,mt7620-gsw.txt
deleted file mode 100644
index 358fed2fab43..000000000000
--- a/Documentation/devicetree/bindings/net/mediatek,mt7620-gsw.txt
+++ /dev/null
@@ -1,24 +0,0 @@
-Mediatek Gigabit Switch
-=======================
-
-The mediatek gigabit switch can be found on Mediatek SoCs (mt7620, mt7621).
-
-Required properties:
-- compatible: Should be "mediatek,mt7620-gsw" or "mediatek,mt7621-gsw"
-- reg: Address and length of the register set for the device
-- interrupts: Should contain the gigabit switches interrupt
-- resets: Should contain the gigabit switches resets
-- reset-names: Should contain the reset names "gsw"
-
-Example:
-
-gsw@10110000 {
-	compatible = "ralink,mt7620-gsw";
-	reg = <0x10110000 8000>;
-
-	resets = <&rstctrl 23>;
-	reset-names = "gsw";
-
-	interrupt-parent = <&intc>;
-	interrupts = <17>;
-};
diff --git a/Documentation/devicetree/bindings/net/ralink,rt2880-net.txt b/Documentation/devicetree/bindings/net/ralink,rt2880-net.txt
deleted file mode 100644
index 9fe1a0a22e44..000000000000
--- a/Documentation/devicetree/bindings/net/ralink,rt2880-net.txt
+++ /dev/null
@@ -1,59 +0,0 @@
-Ralink Frame Engine Ethernet controller
-=======================================
-
-The Ralink frame engine ethernet controller can be found on Ralink and
-Mediatek SoCs (RT288x, RT3x5x, RT366x, RT388x, rt5350, mt7620, mt7621, mt76x8).
-
-Depending on the SoC, there is a number of ports connected to the CPU port
-directly and/or via a (gigabit-)switch.
-
-* Ethernet controller node
-
-Required properties:
-- compatible: Should be one of "ralink,rt2880-eth", "ralink,rt3050-eth",
-  "ralink,rt3050-eth", "ralink,rt3883-eth", "ralink,rt5350-eth",
-  "mediatek,mt7620-eth", "mediatek,mt7621-eth"
-- reg: Address and length of the register set for the device
-- interrupts: Should contain the frame engines interrupt
-- resets: Should contain the frame engines resets
-- reset-names: Should contain the reset names "fe". If a switch is present
-  "esw" is also required.
-
-
-* Ethernet port node
-
-Required properties:
-- compatible: Should be "ralink,eth-port"
-- reg: The number of the physical port
-- phy-handle: reference to the node describing the phy
-
-Example:
-
-mdio-bus {
-	...
-	phy0: ethernet-phy@0 {
-		phy-mode = "mii";
-		reg = <0>;
-	};
-};
-
-ethernet@400000 {
-	compatible = "ralink,rt2880-eth";
-	reg = <0x00400000 10000>;
-
-	#address-cells = <1>;
-	#size-cells = <0>;
-
-	resets = <&rstctrl 18>;
-	reset-names = "fe";
-
-	interrupt-parent = <&cpuintc>;
-	interrupts = <5>;
-
-	port@0 {
-		compatible = "ralink,eth-port";
-		reg = <0>;
-		phy-handle = <&phy0>;
-	};
-
-};
diff --git a/Documentation/devicetree/bindings/net/ralink,rt3050-esw.txt b/Documentation/devicetree/bindings/net/ralink,rt3050-esw.txt
deleted file mode 100644
index 87e315856efa..000000000000
--- a/Documentation/devicetree/bindings/net/ralink,rt3050-esw.txt
+++ /dev/null
@@ -1,30 +0,0 @@
-Ralink Fast Ethernet Embedded Switch
-====================================
-
-The ralink fast ethernet embedded switch can be found on Ralink and Mediatek
-SoCs (RT3x5x, RT5350, MT76x8).
-
-Required properties:
-- compatible: Should be "ralink,rt3050-esw"
-- reg: Address and length of the register set for the device
-- interrupts: Should contain the embedded switches interrupt
-- resets: Should contain the embedded switches resets
-- reset-names: Should contain the reset names "esw"
-
-Optional properties:
-- ralink,portmap: can be used to choose if the default switch setup is
-  llllw or wllll
-- ralink,led_polarity: override the active high/low settings of the leds
-
-Example:
-
-esw@10110000 {
-	compatible = "ralink,rt3050-esw";
-	reg = <0x10110000 8000>;
-
-	resets = <&rstctrl 23>;
-	reset-names = "esw";
-
-	interrupt-parent = <&intc>;
-	interrupts = <17>;
-};
-- 
2.34.1

