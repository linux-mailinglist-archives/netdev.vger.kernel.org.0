Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 884493C5CDF
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 15:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234585AbhGLNBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 09:01:34 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:62830 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234550AbhGLNBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 09:01:14 -0400
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16CCoO85014719;
        Mon, 12 Jul 2021 08:58:20 -0400
Received: from nwd2mta3.analog.com ([137.71.173.56])
        by mx0a-00128a01.pphosted.com with ESMTP id 39rj8dgs3s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Jul 2021 08:58:20 -0400
Received: from SCSQMBX11.ad.analog.com (SCSQMBX11.ad.analog.com [10.77.17.10])
        by nwd2mta3.analog.com (8.14.7/8.14.7) with ESMTP id 16CCwI4k040636
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 12 Jul 2021 08:58:18 -0400
Received: from SCSQMBX10.ad.analog.com (10.77.17.5) by SCSQMBX11.ad.analog.com
 (10.77.17.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.858.5; Mon, 12 Jul 2021
 05:58:17 -0700
Received: from zeus.spd.analog.com (10.66.68.11) by scsqmbx10.ad.analog.com
 (10.77.17.5) with Microsoft SMTP Server id 15.2.858.5 via Frontend Transport;
 Mon, 12 Jul 2021 05:58:16 -0700
Received: from localhost.localdomain ([10.48.65.12])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 16CCvx0G018858;
        Mon, 12 Jul 2021 08:58:13 -0400
From:   <alexandru.tachici@analog.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
CC:     <robh+dt@kernel.org>, <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>, <kuba@kernel.org>,
        Alexandru Tachici <alexandru.tachici@analog.com>
Subject: [PATCH v2 7/7] dt-bindings: adin1100: Add binding for ADIN1100 Ethernet PHY
Date:   Mon, 12 Jul 2021 16:06:31 +0300
Message-ID: <20210712130631.38153-8-alexandru.tachici@analog.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210712130631.38153-1-alexandru.tachici@analog.com>
References: <20210712130631.38153-1-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-GUID: u-zYUGiB3o2ZO4DbjcY3LibqHfCx1aUy
X-Proofpoint-ORIG-GUID: u-zYUGiB3o2ZO4DbjcY3LibqHfCx1aUy
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-12_07:2021-07-12,2021-07-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 impostorscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 bulkscore=0 priorityscore=1501 mlxscore=0 spamscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107120101
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandru Tachici <alexandru.tachici@analog.com>

DT bindings for the ADIN1100 10BASE-T1L Ethernet PHY.

Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
---
 .../devicetree/bindings/net/adi,adin1100.yaml | 45 +++++++++++++++++++
 1 file changed, 45 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/adi,adin1100.yaml

diff --git a/Documentation/devicetree/bindings/net/adi,adin1100.yaml b/Documentation/devicetree/bindings/net/adi,adin1100.yaml
new file mode 100644
index 000000000000..14943164da7a
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/adi,adin1100.yaml
@@ -0,0 +1,45 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/adi,adin1100.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Analog Devices ADIN1100 PHY
+
+maintainers:
+  - Alexandru Tachici <alexandru.tachici@analog.com>
+
+description:
+  Bindings for Analog Devices Industrial Low Power 10BASE-T1L Ethernet PHY
+
+allOf:
+  - $ref: ethernet-phy.yaml#
+
+properties:
+  adi,disable-2400mv-tx-level:
+    description:
+      Prevent ADIN1100 from using the 2.4 V pk-pk transmit level.
+    type: boolean
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    ethernet@e000c000 {
+            compatible = "cdns,zynq-gem", "cdns,gem";
+            reg = <0xe000c000 0x1000>;
+            status = "okay";
+            phy-mode = "mii";
+            interrupts = <0 45 4>;
+            clocks = <&clkc 31>, <&clkc 31>, <&clkc 14>;
+            clock-names = "pclk", "hclk", "tx_clk";
+            #address-cells = <1>;
+            #size-cells = <0>;
+
+            ethernet-phy@0 {
+                    reg = <0>;
+                    device_type = "ethernet-phy";
+                    adi,disable-2400mv-tx-level;
+            };
+
+    };
-- 
2.25.1

