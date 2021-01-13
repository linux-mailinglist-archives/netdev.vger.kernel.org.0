Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDDDD2F528E
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 19:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728621AbhAMSmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 13:42:07 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:37698 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728414AbhAMSmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 13:42:06 -0500
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20210113184043euoutp01d8a599547267e3d2b7eff1875a22957d~Z3ry6Pwd-1155811558euoutp01F
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 18:40:43 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20210113184043euoutp01d8a599547267e3d2b7eff1875a22957d~Z3ry6Pwd-1155811558euoutp01F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1610563243;
        bh=27homzhxtOgQquKIw/0+3LoypE6+9O9g4fIKMDgjxBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ko1JUPEZPsd8B+JLil60ASTqGJsEfRmpqR78AndhhxdjVw8shN4qsOxkMjg2xUbaX
         vv+K6NmTjlXZq8rpq+iL3AclBIazax0VytTMuvQnQC8gj670RoLvswon75KVJdIxDD
         WxCRRsKYwDYVR4iC6Tdj+Ml/mUpqUBKcS8ChRqhY=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210113184043eucas1p1e5175f0b03aca040bef9c415db3eecae~Z3ryTYQkH2348823488eucas1p1K;
        Wed, 13 Jan 2021 18:40:43 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 97.46.45488.BAE3FFF5; Wed, 13
        Jan 2021 18:40:43 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210113184042eucas1p12ea6088ceba57a07b7353cdf0e479013~Z3rxnK6_z1612916129eucas1p1K;
        Wed, 13 Jan 2021 18:40:42 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210113184042eusmtrp2479158e3c44a70fd5c16bc9da9803264~Z3rxmTmxN2705627056eusmtrp2a;
        Wed, 13 Jan 2021 18:40:42 +0000 (GMT)
X-AuditID: cbfec7f5-c77ff7000000b1b0-9b-5fff3eab4a87
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 89.89.21957.AAE3FFF5; Wed, 13
        Jan 2021 18:40:42 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210113184042eusmtip1cfb209d5d8dbc35ea9bf8a02dd5e0667~Z3rxXwz_X1392913929eusmtip16;
        Wed, 13 Jan 2021 18:40:42 +0000 (GMT)
From:   =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
To:     Andrew Lunn <andrew@lunn.ch>, jim.cromie@gmail.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc:     =?UTF-8?q?Bart=C5=82omiej=20=C5=BBolnierkiewicz?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v10 2/3] dt-bindings: net: Add bindings for AX88796C SPI
 Ethernet Adapter
Date:   Wed, 13 Jan 2021 19:40:27 +0100
Message-Id: <20210113184028.4433-3-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210113184028.4433-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGKsWRmVeSWpSXmKPExsWy7djPc7qr7f7HGzx6zGpx/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2px89AKRotNj6+xWlzeNYfN
        Ysb5fUwWh6buZbRYe+Quu8WxBWIWrXuPsFv837OD3UHI4/K1i8weW1beZPLYOesuu8emVZ1s
        HpuX1Hvs3PGZyaNvyypGj8+b5AI4orhsUlJzMstSi/TtErgyrh4zKzgvXLGg9ydTA+MU/i5G
        Tg4JAROJ5zsesHUxcnEICaxglLi94A0ThPOFUeL6hwtQzmdGiQ1Ni1hgWjqfH2CFSCxnlDjT
        Mp8FwnnOKLGt9T0TSBWbgKNE/9ITYFUiAveYJda3P2AEcZgF7jNK3Hu+mhmkSlggWqJ/4yZW
        EJtFQFXiw6tJbCA2r4CVRMPd4+wQ++Ql2pdvB4tzClhLrPnRywRRIyhxcuYTsJv4BbQk1jRd
        B7OZgeqbt85mBlkmIbCfU2JS41s2iEEuEm8uz2SCsIUlXh3fArVARuL/zvlAcQ4gu15i8iQz
        iN4eoHfm/IB62lrizrlfbCA1zAKaEut36UOEHSWerLvEAtHKJ3HjrSDECXwSk7ZNZ4YI80p0
        tAlBVKtIrOvfAzVQSqL31QrGCYxKs5A8MwvJA7MQdi1gZF7FKJ5aWpybnlpsnJdarlecmFtc
        mpeul5yfu4kRmPRO/zv+dQfjilcf9Q4xMnEwHmKU4GBWEuEt6v4bL8SbklhZlVqUH19UmpNa
        fIhRmoNFSZx319Y18UIC6YklqdmpqQWpRTBZJg5OqQamVtfUBHHrvYyi56fcm+HQdO7n5eJX
        fxavbb/Dm7pLM6NxcsFllw1PohfxvLovKX7Geb+QdOBnj/I7Jl7fb689d/fI4s7IQ2+ZJ6gt
        t/96x3OJK78f04YNDVwvDggvmqk12bTT7v58jbbNd/obZ5jcnyN3U//x6cvd3h9vT7tt/qCC
        /YjZf/eER+677/zvdRCaNo9nYbeH1yL1yAB5D0n53jehb4JFXrzKmP6je+2bgDrFoi+F67ap
        Htr5929C5wrLhLPPF/CeXW/OyvtsSmV9fZD0wyVG+9n3vKjQbQtXMW06tMelnEWZ3bjRlKEk
        WfydQcXsLxXv+AvdDv9/PKv0tWND64EzomsqDCUZdV8xKrEUZyQaajEXFScCAEdnkDfpAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsVy+t/xu7qr7P7HG0x7LWFx/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2px89AKRotNj6+xWlzeNYfN
        Ysb5fUwWh6buZbRYe+Quu8WxBWIWrXuPsFv837OD3UHI4/K1i8weW1beZPLYOesuu8emVZ1s
        HpuX1Hvs3PGZyaNvyypGj8+b5AI4ovRsivJLS1IVMvKLS2yVog0tjPQMLS30jEws9QyNzWOt
        jEyV9O1sUlJzMstSi/TtEvQyrh4zKzgvXLGg9ydTA+MU/i5GTg4JAROJzucHWEFsIYGljBKT
        5rB0MXIAxaUkVs5NhygRlvhzrYuti5ELqOQpo8TXd1/ZQBJsAo4S/UtPsIIkRATeMEs03XvL
        DuIwC9xnlPj16QUjSJWwQKTEgo+XwGwWAVWJD68mgXXzClhJNNw9zg6xQl6iffl2sDingLXE
        mh+9TBAXWUm8WdjCAlEvKHFy5hOw65gF1CXWzxMCCfMLaEmsaboOVsIMNKZ562zmCYxCs5B0
        zELomIWkagEj8ypGkdTS4tz03GJDveLE3OLSvHS95PzcTYzA+N527OfmHYzzXn3UO8TIxMF4
        iFGCg1lJhLeo+2+8EG9KYmVValF+fFFpTmrxIUZToM8mMkuJJucDE0xeSbyhmYGpoYmZpYGp
        pZmxkjjv1rlr4oUE0hNLUrNTUwtSi2D6mDg4pRqYLJJsdI7c9S7qapGZEusXPOHO18f7fkfl
        vrKf/WMi9/IDpi5dybXZCrG3/3Z/zOVQ/Nl+zMEi44aoC6OiraGx8jOXG71/p1RFqn2Y9fe/
        pPe8d5f5HFSso6IecC2eoVcTYSXULL+aezPrQq6oF/deKGzbZvJtm8Xjac63mE/Uemn+jCqe
        Nq/L9VI/25Rw6yN3ljwuv2nKt4Vx1cQnfh4TvGYesvyx1vdv64dnHm0NKio96r/5hCfvkH6i
        I+z3+ms1++sn29YoROSuu5KSpbpD4bXqtlD7mlSJ5DM7pEy4W2ecFmzd4r/p9IozBce65ggv
        WZPic8lcbkpq36Ysfa31k6/4xloI/2fQkVh62a9DiaU4I9FQi7moOBEAkP7q/XgDAAA=
X-CMS-MailID: 20210113184042eucas1p12ea6088ceba57a07b7353cdf0e479013
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20210113184042eucas1p12ea6088ceba57a07b7353cdf0e479013
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210113184042eucas1p12ea6088ceba57a07b7353cdf0e479013
References: <20210113184028.4433-1-l.stelmach@samsung.com>
        <CGME20210113184042eucas1p12ea6088ceba57a07b7353cdf0e479013@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bindings for AX88796C SPI Ethernet Adapter.

Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Acked-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 .../bindings/net/asix,ax88796c.yaml           | 73 +++++++++++++++++++
 1 file changed, 73 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/asix,ax88796c.yaml

diff --git a/Documentation/devicetree/bindings/net/asix,ax88796c.yaml b/Documentation/devicetree/bindings/net/asix,ax88796c.yaml
new file mode 100644
index 000000000000..699ebf452479
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/asix,ax88796c.yaml
@@ -0,0 +1,73 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/asix,ax88796c.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: ASIX AX88796C SPI Ethernet Adapter
+
+maintainers:
+  - Łukasz Stelmach <l.stelmach@samsung.com>
+
+description: |
+  ASIX AX88796C is an Ethernet controller with a built in PHY. This
+  describes SPI mode of the chip.
+
+  The node for this driver must be a child node of an SPI controller,
+  hence all mandatory properties described in
+  ../spi/spi-controller.yaml must be specified.
+
+allOf:
+  - $ref: ethernet-controller.yaml#
+
+properties:
+  compatible:
+    const: asix,ax88796c
+
+  reg:
+    maxItems: 1
+
+  spi-max-frequency:
+    maximum: 40000000
+
+  interrupts:
+    maxItems: 1
+
+  reset-gpios:
+    description:
+      A GPIO line handling reset of the chip. As the line is active low,
+      it should be marked GPIO_ACTIVE_LOW.
+    maxItems: 1
+
+  local-mac-address: true
+
+  mac-address: true
+
+required:
+  - compatible
+  - reg
+  - spi-max-frequency
+  - interrupts
+  - reset-gpios
+
+additionalProperties: false
+
+examples:
+  # Artik5 eval board
+  - |
+    #include <dt-bindings/interrupt-controller/irq.h>
+    #include <dt-bindings/gpio/gpio.h>
+    spi0 {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        ethernet@0 {
+            compatible = "asix,ax88796c";
+            reg = <0x0>;
+            local-mac-address = [00 00 00 00 00 00]; /* Filled in by a bootloader */
+            interrupt-parent = <&gpx2>;
+            interrupts = <0 IRQ_TYPE_LEVEL_LOW>;
+            spi-max-frequency = <40000000>;
+            reset-gpios = <&gpe0 2 GPIO_ACTIVE_LOW>;
+        };
+    };
-- 
2.26.2

