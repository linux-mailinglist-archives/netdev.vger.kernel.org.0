Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC5CB40BA27
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 23:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235132AbhINVWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 17:22:48 -0400
Received: from mx3.wp.pl ([212.77.101.9]:19311 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235014AbhINVWl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 17:22:41 -0400
Received: (wp-smtpd smtp.wp.pl 14557 invoked from network); 14 Sep 2021 23:21:22 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1631654482; bh=JtFVFUNwiTKJSIDVg4gd3K3bXMV5gRNQIbwA0HclFeI=;
          h=From:To:Subject;
          b=Dnj3uTR5/fc5LSf3AHSqcj/OzIMJo62wIOZaFh8zrL9YMdRCIiyhQaB4F0x7BSBjG
           OXa+c3yiwjbupTtMw+86MntSB8vDyeHcOhTW0RXp4eoWPyJboSTvI2WDiQOOwyNHlE
           3FTScXe2FWg1gjI2I+2D81Y7hMaWzV5WeFYF9ijA=
Received: from 46.204.52.243.nat.umts.dynamic.t-mobile.pl (HELO LAPTOP-OLEK.Free) (olek2@wp.pl@[46.204.52.243])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <john@phrozen.org>; 14 Sep 2021 23:21:22 +0200
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     john@phrozen.org, tsbogend@alpha.franken.de, olek2@wp.pl,
        maz@kernel.org, ralf@linux-mips.org, ralph.hempel@lantiq.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        hauke@hauke-m.de, dev@kresin.me, arnd@arndb.de, jgg@ziepe.ca,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 7/8] dt-bindings: net: lantiq,etop-xway: Document Lantiq Xway ETOP bindings
Date:   Tue, 14 Sep 2021 23:21:04 +0200
Message-Id: <20210914212105.76186-7-olek2@wp.pl>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210914212105.76186-1-olek2@wp.pl>
References: <20210914212105.76186-1-olek2@wp.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: ddb62316da53fdab6eaf4a0ee8f80a50
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [cfOR]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document the Lantiq Xway SoC series External Bus Unit (ETOP) bindings.

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 .../bindings/net/lantiq,etop-xway.yaml        | 53 +++++++++++++++++++
 1 file changed, 53 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/lantiq,etop-xway.yaml

diff --git a/Documentation/devicetree/bindings/net/lantiq,etop-xway.yaml b/Documentation/devicetree/bindings/net/lantiq,etop-xway.yaml
new file mode 100644
index 000000000000..4412abfb4987
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/lantiq,etop-xway.yaml
@@ -0,0 +1,53 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/lantiq,etop-xway.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Lantiq Xway ETOP Ethernet driver
+
+maintainers:
+  - John Crispin <john@phrozen.org>
+
+properties:
+  $nodename:
+    pattern: "^ethernet@[0-9a-f]+$"
+
+  compatible:
+    const: lantiq,etop-xway
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    items:
+      - description: TX interrupt
+      - description: RX interrupt
+
+  interrupt-names:
+    items:
+      - const: tx
+      - const: rx
+
+  phy-mode: true
+
+required:
+  - compatible
+  - reg
+  - interrupt-parent
+  - interrupts
+  - interrupt-names
+  - phy-mode
+
+additionalProperties: false
+
+examples:
+  - |
+    ethernet@e180000 {
+        compatible = "lantiq,etop-xway";
+        reg = <0xe180000 0x40000>;
+        interrupt-parent = <&icu0>;
+        interrupts = <73>, <78>;
+        interrupt-names = "tx", "rx";
+        phy-mode = "rmii";
+    };
-- 
2.30.2

