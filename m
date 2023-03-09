Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 460466B1C7D
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 08:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbjCIHgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 02:36:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbjCIHgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 02:36:40 -0500
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF85E6A2C1;
        Wed,  8 Mar 2023 23:36:34 -0800 (PST)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 3297aMt9015489;
        Thu, 9 Mar 2023 01:36:22 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1678347382;
        bh=v4hhvTglBM3fp75MRndxC28/HexEkX2FRwpOWPqrO/8=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=ZjMjxVBKOIQ0itSnfQBft3I0oFPxLw+XIEvbvqd8d15HQHdUJOXyYxNoB97FilSX2
         lj6oJRC6P/lGc1DzBfpQstxGiM7XTX4FIEIHPMwSDbgpCXllub5vzzuZ16qpwm7RYR
         5E2FdTockVwjdtMJOzG2C43dHg0PuUaQ/CdlWOyY=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 3297aMgg013675
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 9 Mar 2023 01:36:22 -0600
Received: from DLEE106.ent.ti.com (157.170.170.36) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Thu, 9
 Mar 2023 01:36:22 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Thu, 9 Mar 2023 01:36:22 -0600
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 3297aDWw019672;
        Thu, 9 Mar 2023 01:36:18 -0600
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <linux@armlinux.org.uk>, <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski@linaro.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <nsekhar@ti.com>,
        <rogerq@kernel.org>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: [PATCH net-next v3 1/2] dt-bindings: net: ti: k3-am654-cpsw-nuss: Document Serdes PHY
Date:   Thu, 9 Mar 2023 13:06:11 +0530
Message-ID: <20230309073612.431287-2-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230309073612.431287-1-s-vadapalli@ti.com>
References: <20230309073612.431287-1-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update bindings to include Serdes PHY as an optional PHY, in addition to
the existing CPSW MAC's PHY. The CPSW MAC's PHY is required while the
Serdes PHY is optional. The Serdes PHY handle has to be provided only
when the Serdes is being configured in a Single-Link protocol. Using the
name "serdes-phy" to represent the Serdes PHY handle, the am65-cpsw-nuss
driver can obtain the Serdes PHY and request the Serdes to be
configured.

Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---
 .../bindings/net/ti,k3-am654-cpsw-nuss.yaml        | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
index 900063411a20..628d63e1eb1f 100644
--- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
+++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
@@ -126,8 +126,18 @@ properties:
             description: CPSW port number
 
           phys:
-            maxItems: 1
-            description: phandle on phy-gmii-sel PHY
+            minItems: 1
+            items:
+              - description: CPSW MAC's PHY.
+              - description: Serdes PHY. Serdes PHY is required only if
+                             the Serdes has to be configured in the
+                             Single-Link configuration.
+
+          phy-names:
+            minItems: 1
+            items:
+              - const: mac
+              - const: serdes
 
           label:
             description: label associated with this port
-- 
2.25.1

