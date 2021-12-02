Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA23B4661FD
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 12:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346214AbhLBLHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 06:07:39 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:65389 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237400AbhLBLHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 06:07:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1638443056; x=1669979056;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1QzA4ro6lBny2rCEPSEYixgPWxFPaj1DtkBwvZUqONI=;
  b=AYccMY1Vf3Vaf+OFJiVY/waWVdCwFi32KLDuAkuXPY78JvsvZP0dNRKb
   fhMtIJ0gUIUadRlAydQcrJk5UkPVkfyriXRO8CGOPYIONGAWfFsX5JbZj
   UveykouhJ9r99Oqx2OVy4vjHgDUPm1MNv22EZOvjzZAVj+a1ARG84CPsi
   +f/f0bPcChtpkNoeg5QhTC/vaVTIz5miLsEK5Ti3DaEuPA3fhOwqZ+18E
   3SizYhsKGQltWXl+GHhbc/83vB5MvQo5oq9hYojemhjABMjrDoXDkCAgK
   kPVh1GVu7Uj6R8M+fOMeZDBa4AeCiyG+jps7sAS5RCaHd4rlCDPpD/V7K
   g==;
IronPort-SDR: snkDkGyryEbTByt3q2MiS/Mz5t3YLNWDFjWg63Bfn2OknbDGZAtCkcIEAwMy/ST/+pefgUdo4m
 ssLVBKUjq1Bs+q6wUSdQKSDthvZbKdPY4Q9ZXOjNm9O2p+n3Np0m07GxkXWGxhUl8mAxFuVtRJ
 a2IbCx3z7Gl2xd8GHi19A1UBKQKzfbhlat5EC+Mh6F+TJ6o2LTxELNxQ6gIIQXRxmaJpl8Xud8
 yfYyO/Vlqxs31ZWXq3G8BOLbFKD9JYGShQ68XUG9iJI2uS0DOrIQdTUS6QeDkLlT3hlWPVfZ79
 9lgZXek5kP1daPBRip8NseK8
X-IronPort-AV: E=Sophos;i="5.87,281,1631602800"; 
   d="scan'208";a="138405741"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Dec 2021 04:04:15 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 2 Dec 2021 04:04:15 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 2 Dec 2021 04:04:14 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next] dt-bindings: net: lan966x: Add additional properties for lan966x
Date:   Thu, 2 Dec 2021 12:05:04 +0100
Message-ID: <20211202110504.480220-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch updates the dt-bindings for lan966x switch.
It adds the properties 'additionalProperties' and
'unevaluatedProperties' for ethernet-ports and ports nodes. In this way
it is not possible to add more properties to these nodes.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../bindings/net/microchip,lan966x-switch.yaml      | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml b/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
index d54dc183a033..5bee665d5fcf 100644
--- a/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
+++ b/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
@@ -56,12 +56,21 @@ properties:
 
   ethernet-ports:
     type: object
+
+    properties:
+      '#address-cells':
+        const: 1
+      '#size-cells':
+        const: 0
+
+    additionalProperties: false
+
     patternProperties:
       "^port@[0-9a-f]+$":
         type: object
 
-        allOf:
-          - $ref: "http://devicetree.org/schemas/net/ethernet-controller.yaml#"
+        $ref: "/schemas/net/ethernet-controller.yaml#"
+        unevaluatedProperties: false
 
         properties:
           '#address-cells':
-- 
2.33.0

