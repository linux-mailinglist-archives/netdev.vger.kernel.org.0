Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1544244BB67
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 06:48:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbhKJFvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 00:51:33 -0500
Received: from inva021.nxp.com ([92.121.34.21]:36630 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229731AbhKJFvc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 00:51:32 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 5FD1F200AAA;
        Wed, 10 Nov 2021 06:48:44 +0100 (CET)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 2718C200A95;
        Wed, 10 Nov 2021 06:48:44 +0100 (CET)
Received: from lsv03186.swis.in-blr01.nxp.com (lsv03186.swis.in-blr01.nxp.com [92.120.146.182])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id E951B183AC8B;
        Wed, 10 Nov 2021 13:48:42 +0800 (+08)
From:   Apeksha Gupta <apeksha.gupta@nxp.com>
To:     qiangqing.zhang@nxp.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-devel@linux.nxdi.nxp.com, LnxRevLi@nxp.com,
        sachin.saxena@nxp.com, hemant.agrawal@nxp.com, nipun.gupta@nxp.com,
        Apeksha Gupta <apeksha.gupta@nxp.com>
Subject: [PATCH 1/5] dt-bindings: add binding for fec-uio
Date:   Wed, 10 Nov 2021 11:18:34 +0530
Message-Id: <20211110054838.27907-2-apeksha.gupta@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211110054838.27907-1-apeksha.gupta@nxp.com>
References: <20211110054838.27907-1-apeksha.gupta@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

binding 'fsl,fec-uio.yaml' represents the basic hardware
initialization which is performed in fec-uio via userspace
input/output to support FEC ethernet device detection in
user space.

Signed-off-by: Sachin Saxena <sachin.saxena@nxp.com>
Signed-off-by: Apeksha Gupta <apeksha.gupta@nxp.com>
---
 .../devicetree/bindings/net/fsl,fec-uio.yaml  | 32 +++++++++++++++++++
 1 file changed, 32 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/fsl,fec-uio.yaml

diff --git a/Documentation/devicetree/bindings/net/fsl,fec-uio.yaml b/Documentation/devicetree/bindings/net/fsl,fec-uio.yaml
new file mode 100644
index 000000000000..dd7477c0d213
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/fsl,fec-uio.yaml
@@ -0,0 +1,32 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/fsl,fec-uio.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: NXP Fast Ethernet Controller (FEC) with UIO
+
+maintainers:
+  - Apeksha Gupta <apeksha.gupta@nxp.com>
+  - Sachin Saxena <sachin.saxena@nxp.com>
+
+description:
+  This binding represents the basic hardware initialization which is
+  performed in fec-uio via userspace input/output, to support fec
+  ethernet device detection in user space.
+
+allOf:
+  - $ref: "fsl,fec.yaml#"
+
+properties:
+  compatible:
+    const: fsl,imx8mm-fec-uio
+
+  reg:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+
+additionalProperties: false
-- 
2.17.1

