Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98B274E7963
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 17:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377057AbiCYQzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 12:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377048AbiCYQzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 12:55:45 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F7B23ED0F;
        Fri, 25 Mar 2022 09:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1648227250; x=1679763250;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uc/QWrMsi4Y5CzoHRYB83/Fr2NHNaFlU0o76Li4FnTM=;
  b=z89mNJvuksqYRARNa1zVv5kZfS1Dd5WMYARts+yGgtbl9Ia1Pj/JcFUn
   wqIZyt/xmqTh+ZfsxrMGg+6k8Vi3GJFsyLGmp4UainzD1Jgd3Rc3axWZ1
   HTY1j/NyC2B0VIBLyWqQBaUOYIe4pTYB1kvC19k8tuxXdlxlPsweY4IzJ
   ie1pKCjJvuX58K913PutiNcwDmIkzA0PSJSV7Wn3/Tgqyg9q/gDxOxxce
   rPTj57sJ6YX1QwqT2GljreHXYy47dShgjGcHJQSHb1HkTWXUZ8SWkgdwG
   LSRPtYs1adU1ilfq1CxLHuEIDSDoPn+OhRtC0fApi0FwzsnWErHG5p8p6
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,209,1643698800"; 
   d="scan'208";a="153289847"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Mar 2022 09:54:09 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 25 Mar 2022 09:53:57 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 25 Mar 2022 09:53:52 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <woojung.huh@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>,
        <pabeni@redhat.com>
Subject: [RFC PATCH v11 net-next 01/10] dt-bindings: net: make internal-delay-ps based on phy-mode
Date:   Fri, 25 Mar 2022 22:23:32 +0530
Message-ID: <20220325165341.791013-2-prasanna.vengateshan@microchip.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220325165341.791013-1-prasanna.vengateshan@microchip.com>
References: <20220325165341.791013-1-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

*-internal-delay-ps properties would be applicable only for RGMII interface
modes.

It is changed as per the request,
https://lore.kernel.org/netdev/d8e5f6a8-a7e1-dabd-f4b4-ea8ea21d0a1d@gmail.com/

Ran dt_binding_check to confirm nothing is broken.

Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 .../bindings/net/ethernet-controller.yaml     | 37 +++++++++++++------
 1 file changed, 25 insertions(+), 12 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index 34c5463abcec..dc86a6479a86 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -123,12 +123,6 @@ properties:
       and is useful for determining certain configuration settings
       such as flow control thresholds.
 
-  rx-internal-delay-ps:
-    description: |
-      RGMII Receive Clock Delay defined in pico seconds.
-      This is used for controllers that have configurable RX internal delays.
-      If this property is present then the MAC applies the RX delay.
-
   sfp:
     $ref: /schemas/types.yaml#/definitions/phandle
     description:
@@ -140,12 +134,6 @@ properties:
       The size of the controller\'s transmit fifo in bytes. This
       is used for components that can have configurable fifo sizes.
 
-  tx-internal-delay-ps:
-    description: |
-      RGMII Transmit Clock Delay defined in pico seconds.
-      This is used for controllers that have configurable TX internal delays.
-      If this property is present then the MAC applies the TX delay.
-
   managed:
     description:
       Specifies the PHY management type. If auto is set and fixed-link
@@ -222,6 +210,31 @@ properties:
           required:
             - speed
 
+allOf:
+  - if:
+      properties:
+        phy-mode:
+          contains:
+            enum:
+              - rgmii
+              - rgmii-rxid
+              - rgmii-txid
+              - rgmii-id
+            then:
+              properties:
+                rx-internal-delay-ps:
+                  description:
+                    RGMII Receive Clock Delay defined in pico seconds.This is
+                    used for controllers that have configurable RX internal
+                    delays. If this property is present then the MAC applies
+                    the RX delay.
+                tx-internal-delay-ps:
+                  description:
+                    RGMII Transmit Clock Delay defined in pico seconds.This is
+                    used for controllers that have configurable TX internal
+                    delays. If this property is present then the MAC applies
+                    the TX delay.
+
 additionalProperties: true
 
 ...
-- 
2.30.2

