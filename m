Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 666AD2B0465
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 12:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728265AbgKLLxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 06:53:34 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:36860 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728264AbgKLLv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 06:51:57 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20201112115124euoutp01f80e55273c7597eca2969a52e0b4c39e~GwGtG-kpn0058900589euoutp01t
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 11:51:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20201112115124euoutp01f80e55273c7597eca2969a52e0b4c39e~GwGtG-kpn0058900589euoutp01t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1605181884;
        bh=27homzhxtOgQquKIw/0+3LoypE6+9O9g4fIKMDgjxBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hc4CQ5a/2lLRf052FxdMavEYpXKYbABjQw6bcVV7AkKAuEZAOxNOWR3gjq2Vrn0Io
         IMlFRh0zSQoy5ugU2Zb/LOCCUHSYnVv2hsm/DsCqojpaibWTILHwSVj0qJyvpme7r3
         kaV4xfo9MMCxMJqA3aLdjv9tk8AgMXmc/b3iycS4=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20201112115109eucas1p2dc635c026c006506cdc22566bb14cee6~GwGe_xc6_1206312063eucas1p2L;
        Thu, 12 Nov 2020 11:51:09 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 99.E6.27958.CA12DAF5; Thu, 12
        Nov 2020 11:51:08 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20201112115108eucas1p1857507fc2d994eca6ee6b1b86b87cfd5~GwGel0XNc2257422574eucas1p1H;
        Thu, 12 Nov 2020 11:51:08 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201112115108eusmtrp1103fbf46d81bfc864eecb8c66c8a0af5~GwGelH8GO1853418534eusmtrp1L;
        Thu, 12 Nov 2020 11:51:08 +0000 (GMT)
X-AuditID: cbfec7f2-efdff70000006d36-4a-5fad21accf28
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 72.B7.16282.CA12DAF5; Thu, 12
        Nov 2020 11:51:08 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20201112115108eusmtip1b00bf6d5b326733b1395254e927e2ea0~GwGeTksqq2747927479eusmtip1Y;
        Thu, 12 Nov 2020 11:51:08 +0000 (GMT)
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
Subject: [PATCH v6 2/5] dt-bindings: net: Add bindings for AX88796C SPI
 Ethernet Adapter
Date:   Thu, 12 Nov 2020 12:51:03 +0100
Message-Id: <20201112115106.16224-3-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201112115106.16224-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMKsWRmVeSWpSXmKPExsWy7djP87prFNfGG6y5YGpx/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2px89AKRotNj6+xWlzeNYfN
        Ysb5fUwWh6buZbRYe+Quu8WxBWIWrXuPsFv837OD3UHI4/K1i8weW1beZPLYOesuu8emVZ1s
        HpuX1Hvs3PGZyaNvyypGj8+b5AI4orhsUlJzMstSi/TtErgyrh4zKzgvXLGg9ydTA+MU/i5G
        Tg4JAROJmWc3snUxcnEICaxglPh35DQjSEJI4AujxPOj0hCJz4wS2yetBqriAOvY/JYZIr6c
        UeLhzJMsEM5zRokFK18zgXSzCThK9C89wQqSEBG4xyyxvv0BI4jDLHCfUeLe89XMIKOEBaIk
        fs8IB2lgEVCVeLDwJCuIzStgLfHt1h42iPvkJdqXbwezOQVsJJbevMgOUSMocXLmExYQm19A
        S2JN03UwmxmovnnrbLDzJAT2c0rMfnmTCWKQi8Ss01cYIWxhiVfHt7BD2DISpyf3sEC8Vi8x
        eZIZRG8Po8S2OT9YIGqsJe6c+wX2PrOApsT6XfoQYUeJN90bGCFa+SRuvBWEOIFPYtK26cwQ
        YV6JjjYhiGoViXX9e6AGSkn0vlrBOIFRaRaSZ2YheWAWwq4FjMyrGMVTS4tz01OLDfNSy/WK
        E3OLS/PS9ZLzczcxAtPd6X/HP+1gnPvqo94hRiYOxkOMEhzMSiK8yg5r4oV4UxIrq1KL8uOL
        SnNSiw8xSnOwKInzrpoNlBJITyxJzU5NLUgtgskycXBKNTDF5PCGVuY/6Vo30YpF1XnrlaWL
        Py2uvPbc8MSOw6djfu13Fk3J7PwS75b3MtngiNPG50e3ffi8eXHaf8cJklMEpGQz9fsWLXE8
        1MNYajx1gv0Dvfsbq/RcKhbeOXNkh/hdz5XGzQ1zt37taowXeWMdslHPPKh3l8LSV/w3+z/l
        WnF71GyO9HjwKiZu7tu5XD1uevdt+JsXOK2tV8+bYp2QZqwqqnViWv6M9i7myO0+wsddt7a7
        dPjb+dhv1zlx5CTDU/dTZ/pemt7b+j5580tW79+BXpMUD72aydv47lzvoUX/J+ht3+dWlnnw
        0rKcs/MaZok47dojIrXqvdiO3jX/Epf/LlseN2N6387uB7kpSizFGYmGWsxFxYkArTbdi+YD
        AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t/xu7prFNfGG/Rdl7I4f/cQs8XGGetZ
        Leacb2GxmH/kHKvFovczWC2uvb3DatH/+DWzxfnzG9gtLmzrY7W4eWgFo8Wmx9dYLS7vmsNm
        MeP8PiaLQ1P3MlqsPXKX3eLYAjGL1r1H2C3+79nB7iDkcfnaRWaPLStvMnnsnHWX3WPTqk42
        j81L6j127vjM5NG3ZRWjx+dNcgEcUXo2RfmlJakKGfnFJbZK0YYWRnqGlhZ6RiaWeobG5rFW
        RqZK+nY2Kak5mWWpRfp2CXoZV4+ZFZwXrljQ+5OpgXEKfxcjB4eEgInE5rfMXYxcHEICSxkl
        Jq3dxgYRl5JYOTe9i5ETyBSW+HOtiw3EFhJ4yiix9JMaiM0m4CjRv/QEK0iviMAbZomme2/Z
        QRxmgfuMEr8+vWAEqRIWiJB4M/U9mM0ioCrxYOFJVhCbV8Ba4tutPWwQG+Ql2pdvB7M5BWwk
        lt68yA6xzVqideZndoh6QYmTM5+wgBzHLKAusX6eEEiYX0BLYk3TdRYQmxloTPPW2cwTGIVm
        IemYhdAxC0nVAkbmVYwiqaXFuem5xUZ6xYm5xaV56XrJ+bmbGIHRve3Yzy07GFe++qh3iJGJ
        g/EQowQHs5IIr7LDmngh3pTEyqrUovz4otKc1OJDjKZAn01klhJNzgeml7ySeEMzA1NDEzNL
        A1NLM2MlcV6TI0BNAumJJanZqakFqUUwfUwcnFINTEVh/kfWTuSqWbL11H1xPcd5nOeOaMZe
        rBPN9zRefvV1b+2tGf08e8McO2Y8l31j2HMj1tc6NuBvMq9KjVCD/HMT/61ufqfOfd4ZUXSn
        T/4p61ohCYOve9hvO/FmBxqJ+M0XrXCZaFGgXzgzYN7xPXq9y8WzSntUw5esVWw8eroh67Cb
        qLbXD7nZ/luWZz7W/nfbdWJcn4OLiLl6xROB5SZ33wVeNQhm/Lu/zGKzuMTiDx/83QS9/5/O
        O1e1sbv/6cMX/F3Ft1a8tJFw5pBc6+V+efLrrdputzZN3+a0f7PCk94mu30vWv8c2Tvvyi3x
        O8dXR7U+fieptetMosU3f4sj2rGz+H6qWOu9SLj3XomlOCPRUIu5qDgRAA5PaRR3AwAA
X-CMS-MailID: 20201112115108eucas1p1857507fc2d994eca6ee6b1b86b87cfd5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20201112115108eucas1p1857507fc2d994eca6ee6b1b86b87cfd5
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201112115108eucas1p1857507fc2d994eca6ee6b1b86b87cfd5
References: <20201112115106.16224-1-l.stelmach@samsung.com>
        <CGME20201112115108eucas1p1857507fc2d994eca6ee6b1b86b87cfd5@eucas1p1.samsung.com>
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

