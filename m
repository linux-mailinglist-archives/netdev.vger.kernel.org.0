Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D374C3D7246
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 11:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236192AbhG0Jnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 05:43:46 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:59641 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236043AbhG0Jnc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 05:43:32 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20210727094332euoutp01cff2767a560c45d8bdc20364cefbe8fd~VnJbha0KL1691816918euoutp01A
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 09:43:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20210727094332euoutp01cff2767a560c45d8bdc20364cefbe8fd~VnJbha0KL1691816918euoutp01A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1627379012;
        bh=27homzhxtOgQquKIw/0+3LoypE6+9O9g4fIKMDgjxBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fvnBfsrMQWpRpjOG8iCaog0jz7r5E2VE8FBOHbDQbkWHPIx8+AGhEx83c11KyP3bE
         ipYte80OLbgrAfdRR/2d4/uACMqljKvate+Li2jcxA1Owmgj0CxkAAHJLP8/QBzEzP
         AnlY9Y1rLGOatHZdfpTVzPgLb03SQR7EXO+z8DNg=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210727094331eucas1p29dae5e733a06f69aabb4591d54b71986~VnJavmidX3249732497eucas1p2K;
        Tue, 27 Jul 2021 09:43:31 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 41.70.56448.345DFF06; Tue, 27
        Jul 2021 10:43:31 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210727094330eucas1p1ff05293382ad818fd3127936aac53ca2~VnJaRbXY_1958219582eucas1p1W;
        Tue, 27 Jul 2021 09:43:30 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210727094330eusmtrp26793ed6c59466e4850ab6e8b4f1cdb0b~VnJaQbd3r2985529855eusmtrp2E;
        Tue, 27 Jul 2021 09:43:30 +0000 (GMT)
X-AuditID: cbfec7f5-d53ff7000002dc80-31-60ffd5438101
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id D8.05.20981.245DFF06; Tue, 27
        Jul 2021 10:43:30 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210727094330eusmtip13f1c918e40a68d75da3ba72f944d3f6a~VnJaBJOO_2286222862eusmtip1y;
        Tue, 27 Jul 2021 09:43:30 +0000 (GMT)
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
Subject: [PATCH net-next v15 2/3] dt-bindings: net: Add bindings for
 AX88796C SPI Ethernet Adapter
Date:   Tue, 27 Jul 2021 11:43:24 +0200
Message-Id: <20210727094325.9189-3-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210727094325.9189-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKKsWRmVeSWpSXmKPExsWy7djP87rOV/8nGHzaLmhx/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2px89AKRotNj6+xWlzeNYfN
        Ysb5fUwWh6buZbRYe+Quu8WxBWIWrXuPsFv837OD3UHI4/K1i8weW1beZPLYOesuu8emVZ1s
        HpuX1Hvs3PGZyaNvyypGj8+b5AI4orhsUlJzMstSi/TtErgyrh4zKzgvXLGg9ydTA+MU/i5G
        Tg4JAROJL89/sXQxcnEICaxglLi3bBszhPOFUaKpow0q85lR4uDu+cwwLYemXWQHsYUEljNK
        PJjNDVH0nFFiQ98tJpAEm4CjRP/SE6wgCRGBe8wS69sfMII4zAL3gZY8Xw02SlggRWLFl21g
        HSwCqhLLV0wAG8srYCUxvf0bC8Q6eYn25dvZQGxOAWuJpq5WqBpBiZMzn4DV8AtoSaxpug5m
        MwPVN2+dDfaEhMBhTolnC99CDXKRWHh7L9QPwhKvjm9hh7BlJP7vnA90BAeQXS8xeZIZRG8P
        o8S2OT+geq0l7pz7xQZSwyygKbF+lz5E2FHiTstBVohWPokbbwUhTuCTmLRtOjNEmFeio00I
        olpFYl3/HqiBUhK9r1YwTmBUmoXkmVlIHpiFsGsBI/MqRvHU0uLc9NRi47zUcr3ixNzi0rx0
        veT83E2MwJR3+t/xrzsYV7z6qHeIkYmD8RCjBAezkgivw4rfCUK8KYmVValF+fFFpTmpxYcY
        pTlYlMR5d21dEy8kkJ5YkpqdmlqQWgSTZeLglGpgmqLyse3IdIMc5s2L3G+5zw1smXFlm8O0
        mJRf7z7vzVSf8+St1HzW65Hn/TaddQk0U7mSm9t7T7XOYcXSR68ddRduECs7qyrYqdtx5dGv
        Z43L0hnTp3bP+cj093DXvOJDYSmdSmKmATL7P3ictt7zSywxJMnR8U3Hj8KNCzdUHvZ/qnOg
        gts2fdHxu0237DgkY6o9DI3rZhouXsUqruNy3m5OzwOJxzsEPBxWzTkw/XipTLPAfLfg/pPs
        yklzGqw4192qsti18eXDWTcc+sOOvzgksfPozYtyH+cefn/2yOSVHApTkpNS47lesqpt0Shf
        +L8yc3PYv/9Oa5+Vs+rNff/706KsZ5cTDurYevwsN1RiKc5INNRiLipOBADSidcp6AMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t/xu7pOV/8nGGycpWtx/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2px89AKRotNj6+xWlzeNYfN
        Ysb5fUwWh6buZbRYe+Quu8WxBWIWrXuPsFv837OD3UHI4/K1i8weW1beZPLYOesuu8emVZ1s
        HpuX1Hvs3PGZyaNvyypGj8+b5AI4ovRsivJLS1IVMvKLS2yVog0tjPQMLS30jEws9QyNzWOt
        jEyV9O1sUlJzMstSi/TtEvQyrh4zKzgvXLGg9ydTA+MU/i5GTg4JAROJQ9MusncxcnEICSxl
        lJg2eRVbFyMHUEJKYuXcdIgaYYk/17rYIGqeMkrcPDWTHSTBJuAo0b/0BCtIQkTgDbNE0723
        YJOYBe4zSvz69IIRpEpYIEniw8n/YDaLgKrE8hUTwLp5Bawkprd/Y4FYIS/Rvnw7G4jNKWAt
        0dTVClYjBFTT0XWZBaJeUOLkzCcsINcxC6hLrJ8nBBLmF9CSWNN0HayEGWhM89bZzBMYhWYh
        6ZiF0DELSdUCRuZVjCKppcW56bnFRnrFibnFpXnpesn5uZsYgRG+7djPLTsYV776qHeIkYmD
        8RCjBAezkgivw4rfCUK8KYmVValF+fFFpTmpxYcYTYE+m8gsJZqcD0wxeSXxhmYGpoYmZpYG
        ppZmxkrivCZH1sQLCaQnlqRmp6YWpBbB9DFxcEo1MM2+kF1y9oXj6iSTM7Z5v00PWV+6u4Nn
        blCzg7D8vGNnV+f6R+eJPDjzcFO9kvTcl59l+C2WJOcoG3ttVn50XPNnv/2dFCF77a+pDK9u
        971dMVEjW/UiY+dO1qtrBNZ8kl2xaeFrgQxNrhrv6V0Ldmb9Z9h6XLG7dF/SX2GZRy4yWdbT
        MzPNVHniV9n1npYpX6M4uW2DTyjjmsqLk7zfJF+3fVEfM+ex7V8x9S9P9y46sFNywveGPiZD
        wwKBm4brqlYfUrn/TMLC85fgq9v2j3Zdsl+ua1fH/tckcone2fiDC5d8KTZ1OnMp2/jO5uYq
        Txm2gJY9FtezFPextdXaVZxNOOe+3bnr4uXZ/V82mimxFGckGmoxFxUnAgCFOtITeQMAAA==
X-CMS-MailID: 20210727094330eucas1p1ff05293382ad818fd3127936aac53ca2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20210727094330eucas1p1ff05293382ad818fd3127936aac53ca2
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210727094330eucas1p1ff05293382ad818fd3127936aac53ca2
References: <20210727094325.9189-1-l.stelmach@samsung.com>
        <CGME20210727094330eucas1p1ff05293382ad818fd3127936aac53ca2@eucas1p1.samsung.com>
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

