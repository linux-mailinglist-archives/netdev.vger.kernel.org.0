Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FADC36506E
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 04:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbhDTCnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 22:43:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbhDTCm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 22:42:59 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD2CC06174A;
        Mon, 19 Apr 2021 19:42:28 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id u15so10297156plf.10;
        Mon, 19 Apr 2021 19:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vgiP4tU1wMC+CJHD44H3YeER60YK9xQvr6oaVCV9rsk=;
        b=QtuEPPD86//F655qiNYQxqN77KSntpKAIoqm+zg7u8dEv59YucwUoWk50Ycz9UEOIU
         35qPSGeWHH20Wi9d7+zUVBzXypizz061qNme/S0Xq1AFJYbnck8Zm/yTzXYnPNny+Q3e
         DwNy6oK+gTWVt35aPEaGxhrYGHrCC5VApEuxlca0RBK7WUmsPytYN7EDJ9s4quA06rYm
         W1pHE3bFU3KqpuzgnsT2TyH6fbu+3wbPNGRh98lsVBEWkIp8bNnypiOwbtaO46qXfUPQ
         exgB6eMBvn7+P7vk3U0K3t4idUUwL2Lve3/4NW8JSRzDswwzCJEVeLb/iz5DhfDJe0um
         WdFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vgiP4tU1wMC+CJHD44H3YeER60YK9xQvr6oaVCV9rsk=;
        b=mQBGkoULsnySTB2tVCgenlHiGywQFbsKkIpd+tsTMMyl91np2Hwkir537IIfd9eYbk
         9TujV7Necnw6EBLXXIJ6Y1elR93ZHH3oCgsltM8vvO4VOUrW2XtIvzK43UfKh2xV949M
         q4QbDMREwhoqTkjWfjm280mwtmfKbW4XPiVlVBMH0Lin6P+IeKiNAZ6dbtK/VhbU72Y6
         kai1La/A6oM7OUQHGboJUnY/dDLI4V/F9382vKjbQ5dk/B/dhp9op2AP19X4E0BXCOrC
         CPM4sdzAO4oh0Hv2kiERjvppVtRkAdOQXlILgXpxa23n/ZwfvAUg8/DD9mTD1bN/aOm2
         mMRA==
X-Gm-Message-State: AOAM531SkPA0cM/qVc5aW4hxZZmknWIUOdjzKL+rk7rICsDS+YgzmjvX
        9H1EONCO8evyS7GUGnbFsgw=
X-Google-Smtp-Source: ABdhPJynt95tAQkz/zKdCFlqeduCsz1O5bigcmXEvuBhGdtCg+rJ3gupItvL6kCVf0/q8AYmGmPNrA==
X-Received: by 2002:a17:90a:b398:: with SMTP id e24mr2417117pjr.141.1618886547546;
        Mon, 19 Apr 2021 19:42:27 -0700 (PDT)
Received: from z640-arch.lan ([2602:61:7344:f100::678])
        by smtp.gmail.com with ESMTPSA id 14sm13524425pfi.145.2021.04.19.19.42.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 19:42:27 -0700 (PDT)
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        John Crispin <john@phrozen.org>
Subject: [PATCH] dt-bindings: net: mediatek/ralink: remove unused bindings
Date:   Mon, 19 Apr 2021 19:42:22 -0700
Message-Id: <20210420024222.101615-1-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Revert commit 663148e48a66 ("Documentation: DT: net: add docs for
ralink/mediatek SoC ethernet binding")

No in-tree drivers use the compatible strings present in these bindings,
and some have been superseded by DSA-capable mtk_eth_soc driver, so
remove these obsolete bindings.

Cc: John Crispin <john@phrozen.org>
Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
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
2.31.1

