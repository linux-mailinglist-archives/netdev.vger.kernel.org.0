Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 177EE3CEDC5
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 22:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386996AbhGSTpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 15:45:19 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:51314 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385216AbhGSSwF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 14:52:05 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20210719192915euoutp01e219a3c89a412f94274f475482b3f66e~TR_jcX8i_2828328283euoutp01H
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 19:29:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20210719192915euoutp01e219a3c89a412f94274f475482b3f66e~TR_jcX8i_2828328283euoutp01H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1626722955;
        bh=27homzhxtOgQquKIw/0+3LoypE6+9O9g4fIKMDgjxBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iD1REVptyDUZ/Zjs6dOS56FtvF2BUb2OZ6wxaSPG0oH7UILBu3rIz79G1IQsqBHG0
         NXIKKtQ6guApCvm/7Uy8MJm3zdxqyMpemeRQTxa+529n+IMtU+xtGG8NLLP1ZnbcXN
         2BOPNXtm33dUaEVmjPtvw/BWHxh6nvG8ZhCYevQA=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210719192914eucas1p10bc584d300209c1063fe205a5b30061a~TR_iPnZb02583725837eucas1p1K;
        Mon, 19 Jul 2021 19:29:14 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id BF.0C.56448.A82D5F06; Mon, 19
        Jul 2021 20:29:14 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20210719192913eucas1p22ebe775ac3f40af0184a6569e6e869f3~TR_hP3Rz12864628646eucas1p2J;
        Mon, 19 Jul 2021 19:29:13 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210719192913eusmtrp21cdfa6e7305cdfc6be1d469ac4f90199~TR_hPF1n52699226992eusmtrp2b;
        Mon, 19 Jul 2021 19:29:13 +0000 (GMT)
X-AuditID: cbfec7f5-d3bff7000002dc80-82-60f5d28a6288
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id FC.DC.20981.982D5F06; Mon, 19
        Jul 2021 20:29:13 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210719192913eusmtip2a81ef80b5e8c795df594d2f46bed8c02~TR_hBT65D1148611486eusmtip2-;
        Mon, 19 Jul 2021 19:29:13 +0000 (GMT)
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
Subject: [PATCH net-next v14 2/3] dt-bindings: net: Add bindings for
 AX88796C SPI Ethernet Adapter
Date:   Mon, 19 Jul 2021 21:28:51 +0200
Message-Id: <20210719192852.27404-3-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210719192852.27404-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKKsWRmVeSWpSXmKPExsWy7djPc7pdl74mGLx5LW1x/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2px89AKRotNj6+xWlzeNYfN
        Ysb5fUwWh6buZbRYe+Quu8WxBWIWrXuPsFv837OD3UHI4/K1i8weW1beZPLYOesuu8emVZ1s
        HpuX1Hvs3PGZyaNvyypGj8+b5AI4orhsUlJzMstSi/TtErgyrh4zKzgvXLGg9ydTA+MU/i5G
        Tg4JAROJp2tmsnQxcnEICaxglPj25h87hPOFUWLtk/tMEM5nRom901cywrSsvPiGGSKxnFFi
        avcqVgjnOaPEiuanzCBVbAKOEv1LT4AlRATuMUusb3/ACOIwC9xnlLj3fDVQFQeHsECKxJF7
        jiANLAKqEle+rGIBsXkFrCV+Tm9hhlgnL9G+fDsbiM0pYCMx98MTNogaQYmTM5+A1fMLaEms
        aboOZjMD1TdvnQ12noTAKU6JFx/mM0EMcpE4/ukeC4QtLPHq+BZ2CFtG4v9OkBoOILteYvIk
        M4jeHkaJbXN+QNVbS9w594sNpIZZQFNi/S59iLCjxMKjk6Ba+SRuvBWEOIFPYtK26cwQYV6J
        jjYhiGoViXX9e6AGSkn0vlrBOIFRaRaSZ2YheWAWwq4FjMyrGMVTS4tz01OLjfNSy/WKE3OL
        S/PS9ZLzczcxAlPe6X/Hv+5gXPHqo94hRiYOxkOMEhzMSiK8KkVfE4R4UxIrq1KL8uOLSnNS
        iw8xSnOwKInz7tq6Jl5IID2xJDU7NbUgtQgmy8TBKdXANFH96sloHn3uy3EtG071+lj+540X
        ZfoQ7lm9K+Ebp2RqyBqBHyuUGY3D9+/V/R7c1fVjum+8zp+9P2+9jPwq8/QC041VU65c6o88
        lpIdtN8vl5fB6NzXiOQX75gFbR5vizx/46ZOwt+NVZc62ectK1O/U50YflxDupU///ENkd6l
        qZHOAVc2lk44miaWImgv6PD90p1JJyr3+Z6638N3R+1hvuX7f9+WBpuzTrtSp6XDFx33yDKo
        LjonlrNSJL9gbeKcrr/BntyxP2cLR+5p3zP/53H5tym+fk9vbPX4L7pFKdPy/qlU+/8yTidr
        F/7Kt2KdLchc/DNaOHdC6b750nWSIXud9/Kv+7x/RrCXEktxRqKhFnNRcSIAqljNY+gDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsVy+t/xe7qdl74mGHzYL2lx/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2px89AKRotNj6+xWlzeNYfN
        Ysb5fUwWh6buZbRYe+Quu8WxBWIWrXuPsFv837OD3UHI4/K1i8weW1beZPLYOesuu8emVZ1s
        HpuX1Hvs3PGZyaNvyypGj8+b5AI4ovRsivJLS1IVMvKLS2yVog0tjPQMLS30jEws9QyNzWOt
        jEyV9O1sUlJzMstSi/TtEvQyrh4zKzgvXLGg9ydTA+MU/i5GTg4JAROJlRffMHcxcnEICSxl
        lNhxrp+xi5EDKCElsXJuOkSNsMSfa11sEDVPGSU+bVrJCpJgE3CU6F96ghUkISLwhlmi6d5b
        dhCHWeA+o8SvTy8YQaqEBZIkNr5+zwRiswioSlz5sooFxOYVsJb4Ob2FGWKFvET78u1sIDan
        gI3E3A9P2ECuEAKqWb07AKJcUOLkzCcsIGFmAXWJ9fOEQML8AloSa5qug01kBprSvHU28wRG
        oVlIOmYhdMxCUrWAkXkVo0hqaXFuem6xkV5xYm5xaV66XnJ+7iZGYHxvO/Zzyw7Gla8+6h1i
        ZOJgPMQowcGsJMKrUvQ1QYg3JbGyKrUoP76oNCe1+BCjKdBjE5mlRJPzgQkmryTe0MzA1NDE
        zNLA1NLMWEmc1+TImnghgfTEktTs1NSC1CKYPiYOTqkGpn41TrM1e22DFuwqlXxyfIuX9c8b
        H6t8/dZ518iF7y7cfexVueqnr6b6IuorPA7bi2w2Fg97djVox6q3anFL+Pl/5fWask9hMK3M
        2Lll54XJ7kuZvm0+r/R+8teCyP8vzs/z6aoMO/dltuKMnffKNBVD2nq3SkROMo2d9M126vGu
        d1cMJm8ouW58Z/ep90f63z9lrf123MXedy9fdMX/uE8inddn1T15s3V/1OEs392Oop++LuJn
        eSax5M2xZwo5D5QrPqQXvJVKXtspOuNbjNvzBVH5W2rConmvnkzlm/zL0feE6sFzX39PuNn3
        UPJRu8okx6p/Ly28rkSw1LzbfkLwx9wcO7lcca7mEMvZK34psRRnJBpqMRcVJwIAwEC+fHgD
        AAA=
X-CMS-MailID: 20210719192913eucas1p22ebe775ac3f40af0184a6569e6e869f3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20210719192913eucas1p22ebe775ac3f40af0184a6569e6e869f3
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210719192913eucas1p22ebe775ac3f40af0184a6569e6e869f3
References: <20210719192852.27404-1-l.stelmach@samsung.com>
        <CGME20210719192913eucas1p22ebe775ac3f40af0184a6569e6e869f3@eucas1p2.samsung.com>
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

