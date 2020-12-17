Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7D42DD0E1
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 12:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbgLQLyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 06:54:37 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:36724 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727946AbgLQLyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 06:54:35 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20201217115343euoutp01a9f5ea71889d87352f7bfe41618c120e~RftuOHvGv0517905179euoutp01I
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 11:53:43 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20201217115343euoutp01a9f5ea71889d87352f7bfe41618c120e~RftuOHvGv0517905179euoutp01I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608206023;
        bh=27homzhxtOgQquKIw/0+3LoypE6+9O9g4fIKMDgjxBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nfK5oSgikG35wtGI9EMzsY/WvzKI+mUIOMztVGqbhQGX5I4ydzdkI7vc/cnFFPWCP
         px/sKaET0u9gKAbdM7yyys5KbeAzcVLyBp8iSE+5gm9xfhQ+O9w+MiI0s90gMNNgSk
         p11HWvzzshACHY/GXHpR7rChe7XFN2ryDwnuAUaQ=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20201217115342eucas1p16834b1445ff478f20cf1047959f4e418~Rfttyz-dG2279122791eucas1p1_;
        Thu, 17 Dec 2020 11:53:42 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id D6.9D.45488.6C64BDF5; Thu, 17
        Dec 2020 11:53:42 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20201217115342eucas1p2360bc06a60795f2ee421698a10c060b3~RfttZOoud0292602926eucas1p2s;
        Thu, 17 Dec 2020 11:53:42 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201217115342eusmtrp18ab57a9708fecf57197bf33aa6bb82f1~RfttYdrgN2027720277eusmtrp1e;
        Thu, 17 Dec 2020 11:53:42 +0000 (GMT)
X-AuditID: cbfec7f5-c77ff7000000b1b0-be-5fdb46c6fa92
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 7A.A7.21957.6C64BDF5; Thu, 17
        Dec 2020 11:53:42 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20201217115342eusmtip2ee37e3b677052d9e399289181668212e~RfttL_Lkl1290712907eusmtip2u;
        Thu, 17 Dec 2020 11:53:42 +0000 (GMT)
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
Subject: [PATCH v9 2/3] dt-bindings: net: Add bindings for AX88796C SPI
 Ethernet Adapter
Date:   Thu, 17 Dec 2020 12:53:29 +0100
Message-Id: <20201217115330.28431-3-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201217115330.28431-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUxTVxjHOb2v7VK4FqZPEAY26sAovsywk+AcZIzdLZqYzETlg9DIFQyl
        kFYmbDECDhgdgoIMrCwSAqMyBlrbilXc7Ehx6qivVQItZhAMEIaKTECLo70s89vvOf//85rD
        Eor7VCh7QHNQ0GpUaiUtI62OWec6R1J/yoY7k5ux020n8Pm6DgrXO78l8ZnuXgo3TtZR2DUx
        QOHKoXECO53nGHzbWkHhPrsRYdOQi8L3bPU0rnNelWB7TRfCv3S7GexoWIqLu7oZ/OZKJxOv
        4O+57hC8+WyfhL9kcDO8qbWM5i80HeEvdU5J+ApzK+KnTO/tYJNlW9IE9YGvBO36ramyjAeO
        2BxncF7DsVlJAToZpEcsC9xmuF5D6JGMVXBGBDWjtxeDFwgsN9poMZhC0Hh0dEGR+jOG/+lH
        otCCYFr/mhSDJwheNTZRPhfNJUBl83XKJ4RwHgI6Sh/7UwhuEIHnyc/+WsFcMkw8n/Izya2C
        voFp5GM5Fwc9N4qR2C8CSlsu0j6WclugpPkvSvQsgT9ODZM+DuLWQFvRQz8TC/6jltP+LYD7
        XQpV8xcWB08Ek/EHWuRgGOsxMyKHwc3qclI8xxGorooVc8sRWOtnSNETBwO9c7TPQ3DR0GFb
        L9oTwK3XiBgIjyaWiBMEQpW1lhCf5fBdiUKssRLaK68s1guFY2NGdBwpDW/tYnhrfsP/rRoQ
        0YqWCbm6rHRB94FGOBSjU2XpcjXpMfuys0xo4ePdnO+Z7kTGsWcxdiRhkR0BSyhD5Km/9aUo
        5Gmq/K8FbXaKNlct6OxoOUsql8ltlrYUBZeuOihkCkKOoP1PlbDS0AJJZs7qp5FN+eVBReEQ
        Ftqs18ytW/FO9r6oy1Hl6rz+9nMBP2ZWudiNifo5R7YXYRw/sqowZGz7tZVfthPM6yh6+9ru
        MpqYPEG/GGl87H2ZFP5NUVdT0da60ffjWiyWE7X0zoDEnz7JSO2V7RzJOx456Jq3PfM8Nc8k
        Xvu+/8xuleWLZLfEUxLZG1089NnJ8fHDGbd01ZZbD/OM9s+96lI6Rr57cDbaEMEsHd5QuMtD
        pD2Kbnk18enwjG3/x1a79PBHxeFWPr6wIyH/zaa7IwVJH05Tte5f37Vse25eXRMwo9qh/jti
        W9ryam/Zij17mIsVZyP2Bh4a8O56GZss8H+G4VQlqctQbVxDaHWqfwHIIJf05wMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t/xe7rH3G7HG/TdlrQ4f/cQs8XGGetZ
        Leacb2GxmH/kHKvFovczWC2uvb3DatH/+DWzxfnzG9gtLmzrY7W4eWgFo8Wmx9dYLS7vmsNm
        MeP8PiaLQ1P3MlqsPXKX3eLYAjGL1r1H2C3+79nB7iDkcfnaRWaPLStvMnnsnHWX3WPTqk42
        j81L6j127vjM5NG3ZRWjx+dNcgEcUXo2RfmlJakKGfnFJbZK0YYWRnqGlhZ6RiaWeobG5rFW
        RqZK+nY2Kak5mWWpRfp2CXoZV4+ZFZwXrljQ+5OpgXEKfxcjJ4eEgInEk2+3GbsYuTiEBJYy
        Skx7NIu9i5EDKCElsXJuOkSNsMSfa11sEDVPGSXWXVvCBpJgE3CU6F96ghUkISLwhlmi6d5b
        dhCHWeA+o8SvTy8YQaqEBSIkrhz4ygJiswioSty88xUszitgLXH8VCsjxAp5ifbl28GmcgrY
        SLQtfcQKYgsB1aydfxiqXlDi5MwnLCDXMQuoS6yfJwQS5hfQkljTdB1sPDPQmOats5knMArN
        QtIxC6FjFpKqBYzMqxhFUkuLc9Nziw31ihNzi0vz0vWS83M3MQIjfNuxn5t3MM579VHvECMT
        B+MhRgkOZiUR3oQDN+OFeFMSK6tSi/Lji0pzUosPMZoCfTaRWUo0OR+YYvJK4g3NDEwNTcws
        DUwtzYyVxHm3zl0TLySQnliSmp2aWpBaBNPHxMEp1cCkvezF17ezpaseThZKMDktdVYgsuH5
        cf6r+iUJE2VZ10g+6tffxrsn9YGuK3fUK8/m4j9XwxLe2L2LfVva/fN72kLdxTdCQgRu1ZRv
        ys1STgxLC5Dk/K+TN0VzkfVeheSbeyZxrHut93mThu7WiDbxLfeeRu1Xuf9RbdqraYsVDv7X
        OPJp+9eH4gWrr+U0efwWu7idOezjBYWYNkMV9fUnN57qK/wQt6LiSbJLuLSGSw9/b0pM/rzW
        tbk/zjus03m2fEV8T/ya71cjrup9XncwfUMZh+KhP67xmlJZE8U33eTYsT9y425/YfWoTzuO
        zfleaWHOf8++pdJrYZlxb9e979OMpA/et1slsFrG7c1sJZbijERDLeai4kQA2C/ZBXkDAAA=
X-CMS-MailID: 20201217115342eucas1p2360bc06a60795f2ee421698a10c060b3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20201217115342eucas1p2360bc06a60795f2ee421698a10c060b3
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201217115342eucas1p2360bc06a60795f2ee421698a10c060b3
References: <20201217115330.28431-1-l.stelmach@samsung.com>
        <CGME20201217115342eucas1p2360bc06a60795f2ee421698a10c060b3@eucas1p2.samsung.com>
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

