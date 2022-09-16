Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5DAC5BB0D1
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 18:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbiIPQD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 12:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbiIPQDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 12:03:33 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD3E0B6016;
        Fri, 16 Sep 2022 09:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=06h/aLRDpzu0LJwNKp8/O+DW8AdR6QoYK87bZj9Y9rE=; b=OV7B74hkZgueUtosq2xMVJX84k
        ccK3aMa1th9/C0UDJlVXTnuFbqyT/cq6WfQU07NAOy9aMVfwf4Z0hGMqOgtAaG6NMLn7I0DqWLx9d
        eEFeU4XjzM5SxFTWptTd+Br948eosJb9Z7UT+kEGBfq2Jgdp0e2kYO1FgLdTTi953Z3ksnN9Zqpul
        XYkFLuUYbfMW4VtgKcxitEJ+DXgtFDwZFmurAwegpNCY9ah/GNZisu42yKikp+85qRskGCN64EEBM
        bVtQaWREn4TNupVNSdeFfBkmpEGsBHZSqLDqsJsi3b/THYTeuzRGJdY6k6bfPKaUGXAayc9tJCh+N
        UzRjMgGw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:33148 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1oZDoJ-0006wx-1V; Fri, 16 Sep 2022 17:03:23 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1oZDoI-0077b3-Dd; Fri, 16 Sep 2022 17:03:22 +0100
In-Reply-To: <YySd3pASZKUh4leX@shell.armlinux.org.uk>
References: <YySd3pASZKUh4leX@shell.armlinux.org.uk>
From:   Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
To:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>
Cc:     Alyssa Rosenzweig <alyssa@rosenzweig.io>, asahi@lists.linux.dev,
        brcm80211-dev-list.pdl@broadcom.com,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Hector Martin <marcan@marcan.st>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        "Rafa__ Mi__ecki" <zajec5@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        SHA-cyfmac-dev-list@infineon.com, Sven Peter <sven@svenpeter.dev>
Subject: [PATCH wireless-next v3 12/12] arm64: dts: apple: Add WiFi module and
 antenna properties
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1oZDoI-0077b3-Dd@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Fri, 16 Sep 2022 17:03:22 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hector Martin <marcan@marcan.st>

Add the new module-instance/antenna-sku properties required to select
WiFi firmwares properly to all board device trees.

Signed-off-by: Hector Martin <marcan@marcan.st>
Reviewed-by: Mark Kettenis <kettenis@openbsd.org>
Acked-by: Hector Martin <marcan@marcan.st>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 arch/arm64/boot/dts/apple/t8103-j274.dts  | 4 ++++
 arch/arm64/boot/dts/apple/t8103-j293.dts  | 4 ++++
 arch/arm64/boot/dts/apple/t8103-j313.dts  | 4 ++++
 arch/arm64/boot/dts/apple/t8103-j456.dts  | 4 ++++
 arch/arm64/boot/dts/apple/t8103-j457.dts  | 4 ++++
 arch/arm64/boot/dts/apple/t8103-jxxx.dtsi | 2 ++
 6 files changed, 22 insertions(+)

diff --git a/arch/arm64/boot/dts/apple/t8103-j274.dts b/arch/arm64/boot/dts/apple/t8103-j274.dts
index 2cd429efba5b..c1f3ba9c39f6 100644
--- a/arch/arm64/boot/dts/apple/t8103-j274.dts
+++ b/arch/arm64/boot/dts/apple/t8103-j274.dts
@@ -21,6 +21,10 @@ aliases {
 	};
 };
 
+&wifi0 {
+	brcm,board-type = "apple,atlantisb";
+};
+
 /*
  * Force the bus number assignments so that we can declare some of the
  * on-board devices and properties that are populated by the bootloader
diff --git a/arch/arm64/boot/dts/apple/t8103-j293.dts b/arch/arm64/boot/dts/apple/t8103-j293.dts
index 49cdf4b560a3..ecb10d237a05 100644
--- a/arch/arm64/boot/dts/apple/t8103-j293.dts
+++ b/arch/arm64/boot/dts/apple/t8103-j293.dts
@@ -17,6 +17,10 @@ / {
 	model = "Apple MacBook Pro (13-inch, M1, 2020)";
 };
 
+&wifi0 {
+	brcm,board-type = "apple,honshu";
+};
+
 /*
  * Remove unused PCIe ports and disable the associated DARTs.
  */
diff --git a/arch/arm64/boot/dts/apple/t8103-j313.dts b/arch/arm64/boot/dts/apple/t8103-j313.dts
index b0ebb45bdb6f..df741737b8e6 100644
--- a/arch/arm64/boot/dts/apple/t8103-j313.dts
+++ b/arch/arm64/boot/dts/apple/t8103-j313.dts
@@ -17,6 +17,10 @@ / {
 	model = "Apple MacBook Air (M1, 2020)";
 };
 
+&wifi0 {
+	brcm,board-type = "apple,shikoku";
+};
+
 /*
  * Remove unused PCIe ports and disable the associated DARTs.
  */
diff --git a/arch/arm64/boot/dts/apple/t8103-j456.dts b/arch/arm64/boot/dts/apple/t8103-j456.dts
index 884fddf7d363..8c6bf9592510 100644
--- a/arch/arm64/boot/dts/apple/t8103-j456.dts
+++ b/arch/arm64/boot/dts/apple/t8103-j456.dts
@@ -21,6 +21,10 @@ aliases {
 	};
 };
 
+&wifi0 {
+	brcm,board-type = "apple,capri";
+};
+
 &i2c0 {
 	hpm2: usb-pd@3b {
 		compatible = "apple,cd321x";
diff --git a/arch/arm64/boot/dts/apple/t8103-j457.dts b/arch/arm64/boot/dts/apple/t8103-j457.dts
index d7c622931627..fe7c0aaf7d62 100644
--- a/arch/arm64/boot/dts/apple/t8103-j457.dts
+++ b/arch/arm64/boot/dts/apple/t8103-j457.dts
@@ -21,6 +21,10 @@ aliases {
 	};
 };
 
+&wifi0 {
+	brcm,board-type = "apple,santorini";
+};
+
 /*
  * Force the bus number assignments so that we can declare some of the
  * on-board devices and properties that are populated by the bootloader
diff --git a/arch/arm64/boot/dts/apple/t8103-jxxx.dtsi b/arch/arm64/boot/dts/apple/t8103-jxxx.dtsi
index fe2ae40fa9dd..3d15b8e2a6c1 100644
--- a/arch/arm64/boot/dts/apple/t8103-jxxx.dtsi
+++ b/arch/arm64/boot/dts/apple/t8103-jxxx.dtsi
@@ -71,8 +71,10 @@ hpm1: usb-pd@3f {
 &port00 {
 	bus-range = <1 1>;
 	wifi0: network@0,0 {
+		compatible = "pci14e4,4425";
 		reg = <0x10000 0x0 0x0 0x0 0x0>;
 		/* To be filled by the loader */
 		local-mac-address = [00 00 00 00 00 00];
+		apple,antenna-sku = "XX";
 	};
 };
-- 
2.30.2

