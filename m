Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04BC910B2CA
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 16:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbfK0Pzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 10:55:38 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:32868 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbfK0Pzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 10:55:38 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id xARFtVCr071721;
        Wed, 27 Nov 2019 09:55:31 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1574870131;
        bh=K63GQIrw0Sq+EfiUZbTAW80xzjkoZlaK1Fs4iboltMg=;
        h=From:To:CC:Subject:Date;
        b=zQX7Z4UT0A8dKZvD6orrZ+/oPB5evEms9YJ3zsSzVsBHntXBAkrJLIkeY4y3doXXD
         XGYFeUuggkKX3Up/yaC4aWXlAfE1//+4z6BLYaKXef53frVWwippMjijuWdpcoKRKN
         3PPFXeBCs1LWTXWqCPuscRbMBTGONt4RTEe6+sR8=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id xARFtVkc104403;
        Wed, 27 Nov 2019 09:55:31 -0600
Received: from DFLE108.ent.ti.com (10.64.6.29) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Wed, 27
 Nov 2019 09:55:31 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Wed, 27 Nov 2019 09:55:31 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id xARFtUwu019376;
        Wed, 27 Nov 2019 09:55:30 -0600
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH] dt-bindings: net: ti: cpsw-switch: update to fix comments
Date:   Wed, 27 Nov 2019 17:55:26 +0200
Message-ID: <20191127155526.22746-1-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After original patch was merged there were additional comments/requests
provided by Rob Herring [1]. Mostly they are related to json-schema usage,
and this patch fixes them. Also SPDX-License-Identifier has been changed to
(GPL-2.0-only OR BSD-2-Clause) as requested.

[1] https://lkml.org/lkml/2019/11/21/875
Fixes: ef63fe72f698 ("dt-bindings: net: ti: add new cpsw switch driver bindings")
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 .../bindings/net/ti,cpsw-switch.yaml          | 20 +++++++------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml b/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
index 81ae8cafabc1..4e072a023f3e 100644
--- a/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
+++ b/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
@@ -1,4 +1,4 @@
-# SPDX-License-Identifier: GPL-2.0
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
 %YAML 1.2
 ---
 $id: http://devicetree.org/schemas/net/ti,cpsw-switch.yaml#
@@ -44,7 +44,6 @@ properties:
     description: CPSW functional clock
 
   clock-names:
-    maxItems: 1
     items:
       - const: fck
 
@@ -70,7 +69,6 @@ properties:
       Phandle to the system control device node which provides access to
       efuse IO range with MAC addresses
 
-
   ethernet-ports:
     type: object
     properties:
@@ -82,8 +80,6 @@ properties:
     patternProperties:
       "^port@[0-9]+$":
           type: object
-          minItems: 1
-          maxItems: 2
           description: CPSW external ports
 
           allOf:
@@ -92,21 +88,20 @@ properties:
           properties:
             reg:
               maxItems: 1
-              enum: [1, 2]
+              items:
+                - enum: [1, 2]
               description: CPSW port number
 
             phys:
-              $ref: /schemas/types.yaml#definitions/phandle-array
               maxItems: 1
               description:  phandle on phy-gmii-sel PHY
 
             label:
-              $ref: /schemas/types.yaml#/definitions/string-array
-              maxItems: 1
               description: label associated with this port
 
             ti,dual-emac-pvid:
-              $ref: /schemas/types.yaml#/definitions/uint32
+              allOf:
+                - $ref: /schemas/types.yaml#/definitions/uint32
               maxItems: 1
               minimum: 1
               maximum: 1024
@@ -136,7 +131,6 @@ properties:
         description: CPTS reference clock
 
       clock-names:
-        maxItems: 1
         items:
           - const: cpts
 
@@ -201,7 +195,7 @@ examples:
                         phys = <&phy_gmii_sel 1>;
                         phy-handle = <&ethphy0_sw>;
                         phy-mode = "rgmii";
-                        ti,dual_emac_pvid = <1>;
+                        ti,dual-emac-pvid = <1>;
                 };
 
                 cpsw_port2: port@2 {
@@ -211,7 +205,7 @@ examples:
                         phys = <&phy_gmii_sel 2>;
                         phy-handle = <&ethphy1_sw>;
                         phy-mode = "rgmii";
-                        ti,dual_emac_pvid = <2>;
+                        ti,dual-emac-pvid = <2>;
                 };
         };
 
-- 
2.17.1

