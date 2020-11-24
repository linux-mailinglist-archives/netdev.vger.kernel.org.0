Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0442C2547
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 13:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733312AbgKXMEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 07:04:07 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:51437 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733310AbgKXMEF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 07:04:05 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20201124120345euoutp026b8bc5048a7dc305214c923534519948~KcA7BT2dQ2523225232euoutp02k
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 12:03:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20201124120345euoutp026b8bc5048a7dc305214c923534519948~KcA7BT2dQ2523225232euoutp02k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1606219425;
        bh=27homzhxtOgQquKIw/0+3LoypE6+9O9g4fIKMDgjxBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jPjCvV2PtZFL90684vHHCD96dIFZ1Ib5XA/vC2H7mzV/VKGwHW8v9pbSSz/oF1Fpn
         ma6ohTaEZYP7QX4saz0loV8+N108u7+auusSCmbhKKpAjwP+HkeYDTSeWEhTev8aTA
         xOdjoIC++jYMyA0yyFCBXStHhnPZRz0A2BL8kRHQ=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20201124120337eucas1p29094a198a22d270098d184c7991000da~KcAzDAgoz2294422944eucas1p26;
        Tue, 24 Nov 2020 12:03:37 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id FE.63.27958.996FCBF5; Tue, 24
        Nov 2020 12:03:37 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20201124120336eucas1p2982f8a4e16a9357e1354cde77333f695~KcAyu1o9t2505525055eucas1p2S;
        Tue, 24 Nov 2020 12:03:36 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201124120336eusmtrp1e542686081fcdd96904d3537bf9c4332~KcAytiKXU0982309823eusmtrp1D;
        Tue, 24 Nov 2020 12:03:36 +0000 (GMT)
X-AuditID: cbfec7f2-efdff70000006d36-5f-5fbcf699b4d4
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 8A.2E.21957.896FCBF5; Tue, 24
        Nov 2020 12:03:36 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20201124120336eusmtip1363eec52f06f74f191989e323c1b7a91~KcAyg0iC-0406404064eusmtip11;
        Tue, 24 Nov 2020 12:03:36 +0000 (GMT)
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
Subject: [PATCH v7 2/3] dt-bindings: net: Add bindings for AX88796C SPI
 Ethernet Adapter
Date:   Tue, 24 Nov 2020 13:03:29 +0100
Message-Id: <20201124120330.32445-3-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201124120330.32445-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01SbUxTZxjNez96L82KlwuOd4zh6CRmOCvVhb0DxkacpvtjdPGX+9E1eoMd
        LWALopANM0dBAgJFZ0GW4vzqCtKJbaUIkpUOYWCLY3aglH10kQkBhlVAZmBcrmb+O895znnO
        eZOXxtnbZAytzs7jdNkqjVQkJpw9T7yb6uY6lEkXf6CQL+DG0RWTjUQNvq8IZPZ4SfTtjIlE
        /qlRElUFJ3Hk831PoUHnCRKNuC0AtQb9JBpqbxAhk+8GhtynOgG67AlQqKfxZVTS6aHQckcb
        9QGrGPLfxhX270Ywhas+QClarcdFiqvnixWuthCmOGG3AkWoNW4XvVectp/TqA9xus3pn4oP
        3OlJzvVFHm6sfIIdBSfXlAOahszbsO8XdTkQ0yxjAbArMImXg7CV4RGAE91HhEUIwMeDj8jn
        BsNAhMBfArB0+gEmDOMAhhxfY7xbxGTAqgu9JL+IYsZwaCv9HfADzvwG4Nh402pGJLMXGu4M
        AR4TTAL8seQGxkdImFQ4Zt7K05BZB0svXRPxOIxJgwbPvVWrhImAfXV/ETxewyTC5i9/XcX4
        iv6Y4wzOZ0GmOwyO3wo9q/0hHO3NF25GwombdkrAsbC/toIQJMWw1pgsWCsAdDYsEIImFY56
        F0W8BmfehLb2zQKdAefNViBYw+HwVITQIBwanadxgZbAMgMrqNfDlqqOZwdjYOWEBVQDaf0L
        b6l/oX/9/1mNALeCaC5fr83k9PJsrkCmV2n1+dmZsn052law8uv6l24+bAPfTMzK3ACjgRtA
        GpdGSUriXEpWsl91pJDT5Sh1+RpO7wav0oQ0WmI906xkmUxVHpfFcbmc7vkWo8NijmK7Tj+u
        oQuV852+ty7ajANPu2T4R9fSzW9or2z9d3rTnj/OuyvODXtPul2vtMRtqe5tnrXNJy5C49nP
        8r7QGJamDcfjtc4d8XeprqJzo+aNr7cvlOc6N4SLdnZXRm156Z93klzpC9595hmH2HX1rvE6
        PLT+qbzAVXbP3rc7I/a1DVnDwffuf3K/ctCisazNKzx8TNp/8P1J9vPqlNqHdlmCJxBsrvvJ
        XzZytlgjJuZ3dwULArPrwneuVaMdB5umWepjmdykXn6QhXWnRt/6e+bCqZqaJLmuaHkqdiFr
        W1Htu3/qE7Ypewei5xwpc4stTY6cmvi0hOSh9u2mJW2KIeVnPysl9AdU8kRcp1f9B+mDR/Pk
        AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t/xu7ozvu2JN/gyx9Di/N1DzBYbZ6xn
        tZhzvoXFYv6Rc6wWi97PYLW49vYOq0X/49fMFufPb2C3uLCtj9Xi5qEVjBabHl9jtbi8aw6b
        xYzz+5gsDk3dy2ix9shddotjC8QsWvceYbf4v2cHu4OQx+VrF5k9tqy8yeSxc9Zddo9NqzrZ
        PDYvqffYueMzk0ffllWMHp83yQVwROnZFOWXlqQqZOQXl9gqRRtaGOkZWlroGZlY6hkam8da
        GZkq6dvZpKTmZJalFunbJehlXD1mVnBeuGJB70+mBsYp/F2MHBwSAiYSbWcEuxi5OIQEljJK
        bDvzghUiLiWxcm56FyMnkCks8edaFxtEzVNGifkNx9lAEmwCjhL9S0+wgiREBN4wSzTde8sO
        4jAL3GeU+PXpBSNIlbBAhMSmx8+YQWwWAVWJo637mEA28ApYS9ybbwyxQV6iffl2sKGcAjYS
        bUdug5ULAZVsm32IBcTmFRCUODnzCQtIK7OAusT6eUIgYX4BLYk1TdfBSpiBxjRvnc08gVFo
        FpKOWQgds5BULWBkXsUoklpanJueW2yoV5yYW1yal66XnJ+7iREY3duO/dy8g3Heq496hxiZ
        OBgPMUpwMCuJ8LbK7YwX4k1JrKxKLcqPLyrNSS0+xGgK9NhEZinR5HxgeskriTc0MzA1NDGz
        NDC1NDNWEufdOndNvJBAemJJanZqakFqEUwfEwenVANT9KvMkh9cgRl3rG13Km+MzK/tOf2Y
        cYbBJ0599kZ/H4kAPsMT+qdfzeA2/L5kt9nvRf5Mxt8+23O/vmAidiLzYWnE/63RN+KT/pX1
        nt7yPsdg4bfuRZvi9zvqJcfz6i+c8HwBa0hca2BjwNt/Z73mh3gpzNi33OT0h6aoYqX/ugpu
        PQyVZ1/0Wh77esBENHOlMc+8M1JzdaSiO1eFti84KWGak9Q3zyrSQvTi/Q2ejRs2rmXz9Glb
        2/I+W+hw1I/UfcdfrJ0kczYla+mkjT1lWgdrEo7k37y67E7tmf2C/J9YOtVu9k16uNWMnyv6
        x+KvUi61jMVX0uy+C62qKy1/2nv1ttuecwcvzlq69PQDJZbijERDLeai4kQALujP7HcDAAA=
X-CMS-MailID: 20201124120336eucas1p2982f8a4e16a9357e1354cde77333f695
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20201124120336eucas1p2982f8a4e16a9357e1354cde77333f695
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201124120336eucas1p2982f8a4e16a9357e1354cde77333f695
References: <20201124120330.32445-1-l.stelmach@samsung.com>
        <CGME20201124120336eucas1p2982f8a4e16a9357e1354cde77333f695@eucas1p2.samsung.com>
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

