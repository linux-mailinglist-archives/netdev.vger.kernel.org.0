Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7843255A236
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 21:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbiFXTwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 15:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbiFXTwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 15:52:15 -0400
Received: from mx0a-00128a01.pphosted.com (mx0a-00128a01.pphosted.com [148.163.135.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65463826AC;
        Fri, 24 Jun 2022 12:52:14 -0700 (PDT)
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25OJgSEs024142;
        Fri, 24 Jun 2022 15:51:49 -0400
Received: from nwd2mta3.analog.com ([137.71.173.56])
        by mx0a-00128a01.pphosted.com (PPS) with ESMTPS id 3gvemnmxjf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jun 2022 15:51:49 -0400
Received: from ASHBMBX8.ad.analog.com (ASHBMBX8.ad.analog.com [10.64.17.5])
        by nwd2mta3.analog.com (8.14.7/8.14.7) with ESMTP id 25OJpmUr023676
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 24 Jun 2022 15:51:48 -0400
Received: from ASHBCASHYB5.ad.analog.com (10.64.17.133) by
 ASHBMBX8.ad.analog.com (10.64.17.5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.14; Fri, 24 Jun 2022 15:51:47 -0400
Received: from ASHBMBX9.ad.analog.com (10.64.17.10) by
 ASHBCASHYB5.ad.analog.com (10.64.17.133) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.14; Fri, 24 Jun 2022 15:51:47 -0400
Received: from zeus.spd.analog.com (10.66.68.11) by ashbmbx9.ad.analog.com
 (10.64.17.10) with Microsoft SMTP Server id 15.2.986.14 via Frontend
 Transport; Fri, 24 Jun 2022 15:51:47 -0400
Received: from localhost.localdomain ([10.48.65.12])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 25OJpKRE017522;
        Fri, 24 Jun 2022 15:51:43 -0400
From:   <alexandru.tachici@analog.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <devicetree@vger.kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <gerhard@engleder-embedded.com>, <geert+renesas@glider.be>,
        <joel@jms.id.au>, <stefan.wahren@i2se.com>, <wellslutw@gmail.com>,
        <geert@linux-m68k.org>, <robh+dt@kernel.org>,
        <d.michailidis@fungible.com>, <stephen@networkplumber.org>,
        <l.stelmach@samsung.com>, <linux-kernel@vger.kernel.org>
Subject: [net-next 2/2] dt-bindings: net: adin1110: Add docs
Date:   Fri, 24 Jun 2022 23:06:28 +0300
Message-ID: <20220624200628.77047-3-alexandru.tachici@analog.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220624200628.77047-1-alexandru.tachici@analog.com>
References: <20220624200628.77047-1-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-ORIG-GUID: 7wOzDBTk15SybEUdADzfZCrnyubKJe9I
X-Proofpoint-GUID: 7wOzDBTk15SybEUdADzfZCrnyubKJe9I
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-24_09,2022-06-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 malwarescore=0 impostorscore=0 lowpriorityscore=0
 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0 mlxscore=0
 spamscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206240076
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandru Tachici <alexandru.tachici@analog.com>

Add bindings for the ADIN1110/2111 MAC-PHY/SWITCH.

Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
---
 .../devicetree/bindings/net/adi,adin1110.yaml | 127 ++++++++++++++++++
 1 file changed, 127 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/adi,adin1110.yaml

diff --git a/Documentation/devicetree/bindings/net/adi,adin1110.yaml b/Documentation/devicetree/bindings/net/adi,adin1110.yaml
new file mode 100644
index 000000000000..0ac18dd62e5a
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/adi,adin1110.yaml
@@ -0,0 +1,127 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: "http://devicetree.org/schemas/net/adi,adin1110.yaml#"
+$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+
+title: ADI ADIN1110 MAC-PHY
+
+allOf:
+  - $ref: ethernet-controller.yaml#
+  - $ref: spi-controller.yaml#
+
+maintainers:
+  - Alexandru Tachici <alexandru.tachici@analog.com>
+
+description: |
+  The ADIN1110 is a low power single port 10BASE-T1L MAC-
+  PHY designed for industrial Ethernet applications. It integrates
+  an Ethernet PHY core with a MAC and all the associated analog
+  circuitry, input and output clock buffering.
+
+  The ADIN2111 is a low power, low complexity, two-Ethernet ports
+  switch with integrated 10BASE-T1L PHYs and one serial peripheral
+  interface (SPI) port. The device is designed for industrial Ethernet
+  applications using low power constrained nodes and is compliant
+  with the IEEE 802.3cg-2019 Ethernet standard for long reach
+  10 Mbps single pair Ethernet (SPE).
+
+  The device has a 4-wire SPI interface for communication
+  between the MAC and host processor.
+
+properties:
+  compatible:
+    enum:
+      - adi,adin1110
+      - adi,adin2111
+
+  '#address-cells':
+    const: 1
+
+  '#size-cells':
+    const: 0
+
+  reg:
+    maxItems: 1
+
+  adi,spi-crc:
+    description: |
+      Enable CRC8 checks on SPI read/writes.
+    type: boolean
+
+  interrupts:
+    maxItems: 1
+
+patternProperties:
+  "^phy@[0-1]$":
+    description: |
+      ADIN1100 PHY that is present on the same chip as the MAC.
+    type: object
+
+    properties:
+      reg:
+        items:
+          maximum: 1
+
+    allOf:
+      - if:
+          properties:
+            compatible:
+              contains:
+                const: adi,adin1110
+        then:
+          properties:
+            compatible:
+              const: ethernet-phy-id0283.bc91
+        else:
+          properties:
+            compatible:
+              const: ethernet-phy-id0283.bca1
+
+    required:
+      - compatible
+      - reg
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - phy@0
+
+unevaluatedProperties: false
+
+examples:
+  - |
+        spi0 {
+                #address-cells = <1>;
+                #size-cells = <0>;
+                status = "okay";
+
+                ethernet@0 {
+                        compatible = "adi,adin2111";
+                        reg = <0>;
+                        spi-max-frequency = <24500000>;
+
+                        adi,spi-crc;
+
+                        #address-cells = <1>;
+                        #size-cells = <0>;
+
+                        interrupt-parent = <&gpio>;
+                        interrupts = <25 2>;
+
+                        mac-address = [ ca 2f b7 10 23 63 ];
+
+                        phy@0 {
+                                #phy-cells = <0>;
+                                compatible = "ethernet-phy-id0283.bca1";
+                                reg = <0>;
+                        };
+
+                        phy@1 {
+                                #phy-cells = <0>;
+                                compatible = "ethernet-phy-id0283.bca1";
+                                reg = <1>;
+                        };
+                };
+        };
-- 
2.25.1

