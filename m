Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2995AFDEC
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 09:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbiIGHsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 03:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbiIGHsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 03:48:07 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63944A59BA;
        Wed,  7 Sep 2022 00:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=kGSS7KMdkgzUrS0FpH9oDCCiJv7Qd/c3VizW/i5Ke1U=; b=KGbkpyCfuG52VkIam8txkhCYNN
        upaPfHDTEyijIyBKxSMl76lHsXlr8aACleQvPxj3us6YJrr7mLT0TvenadPG5jwZAxNXLaKPzevgI
        yVcA7tRaj3y5zlfJzrZAdTrmeHlb/J4zD5GWKeuxqA72s4SXGLixFDVp4YngJ4p2XkB/9rHeyf6qy
        02Cvq77j0PcAxc5MJy9zd3xYY2w8VDSexJA7CHViaK1oHtk+EmBimrdmLyCcwJuxV1i3ssLqaURTX
        vIt99ePR0io9gD6jCdfgqxyf+9ZrUz1Uu6wXPtSApQkLMtXj8g/sht9g9ZuAzC3/30HuNgSIwmDjs
        Y8JEbb4w==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:45694 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1oVpml-0004uL-0P; Wed, 07 Sep 2022 08:47:47 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1oVpmk-005LBL-5U; Wed, 07 Sep 2022 08:47:46 +0100
In-Reply-To: <YxhMaYOfnM+7FG+W@shell.armlinux.org.uk>
References: <YxhMaYOfnM+7FG+W@shell.armlinux.org.uk>
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
        SHA-cyfmac-dev-list@infineon.com, Sven Peter <sven@svenpeter.dev>,
        van Spriel <arend@broadcom.com>
Subject: [PATCH net-next 01/12] dt-bindings: net: bcm4329-fmac: Add Apple
 properties & chips
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1oVpmk-005LBL-5U@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 07 Sep 2022 08:47:46 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hector Martin <marcan@marcan.st>

This binding is currently used for SDIO devices, but these chips are
also used as PCIe devices on DT platforms and may be represented in the
DT. Re-use the existing binding and add chip compatibles used by Apple
T2 and M1 platforms (the T2 ones are not known to be used in DT
platforms, but we might as well document them).

Then, add properties required for firmware selection and calibration on
M1 machines.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Hector Martin <marcan@marcan.st>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 .../net/wireless/brcm,bcm4329-fmac.yaml       | 37 +++++++++++++++++--
 1 file changed, 34 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml b/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
index 53b4153d9bfc..53ded82b273a 100644
--- a/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
+++ b/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/net/wireless/brcm,bcm4329-fmac.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Broadcom BCM4329 family fullmac wireless SDIO devices
+title: Broadcom BCM4329 family fullmac wireless SDIO/PCIE devices
 
 maintainers:
   - Arend van Spriel <arend@broadcom.com>
@@ -42,10 +42,16 @@ title: Broadcom BCM4329 family fullmac wireless SDIO devices
               - cypress,cyw43012-fmac
           - const: brcm,bcm4329-fmac
       - const: brcm,bcm4329-fmac
+      - enum:
+          - pci14e4,43dc  # BCM4355
+          - pci14e4,4464  # BCM4364
+          - pci14e4,4488  # BCM4377
+          - pci14e4,4425  # BCM4378
+          - pci14e4,4433  # BCM4387
 
   reg:
-    description: SDIO function number for the device, for most cases
-      this will be 1.
+    description: SDIO function number for the device (for most cases
+      this will be 1) or PCI device identifier.
 
   interrupts:
     maxItems: 1
@@ -85,6 +91,31 @@ title: Broadcom BCM4329 family fullmac wireless SDIO devices
       takes precedence.
     type: boolean
 
+  brcm,cal-blob:
+    $ref: /schemas/types.yaml#/definitions/uint8-array
+    description: A per-device calibration blob for the Wi-Fi radio. This
+      should be filled in by the bootloader from platform configuration
+      data, if necessary, and will be uploaded to the device if present.
+
+  brcm,board-type:
+    $ref: /schemas/types.yaml#/definitions/string
+    description: Overrides the board type, which is normally the compatible of
+      the root node. This can be used to decouple the overall system board or
+      device name from the board type for WiFi purposes, which is used to
+      construct firmware and NVRAM configuration filenames, allowing for
+      multiple devices that share the same module or characteristics for the
+      WiFi subsystem to share the same firmware/NVRAM files. On Apple platforms,
+      this should be the Apple module-instance codename prefixed by "apple,",
+      e.g. "apple,honshu".
+
+  apple,antenna-sku:
+    $ref: /schemas/types.yaml#/definitions/string
+    description: Antenna SKU used to identify a specific antenna configuration
+      on Apple platforms. This is use to build firmware filenames, to allow
+      platforms with different antenna configs to have different firmware and/or
+      NVRAM. This would normally be filled in by the bootloader from platform
+      configuration data.
+
 required:
   - compatible
   - reg
-- 
2.30.2

