Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4B632B391
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449739AbhCCECv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:02:51 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:48550 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1578715AbhCBP0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 10:26:52 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20210302152253euoutp01f33972c90adbb41c8f00f0333b7ae3ce~oj8w0VdAt0911909119euoutp01r
        for <netdev@vger.kernel.org>; Tue,  2 Mar 2021 15:22:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20210302152253euoutp01f33972c90adbb41c8f00f0333b7ae3ce~oj8w0VdAt0911909119euoutp01r
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1614698573;
        bh=27homzhxtOgQquKIw/0+3LoypE6+9O9g4fIKMDgjxBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kKrASF8mr7FyME5BukZRfEkUN1h6Nb3AbNnBKFX3nUiVvt8EMvAybkZ6sa5961S/2
         HokxsR1ruLvtBB4zIRLAKfu7MEGoJkL1h3EoFDgIddJBhjkjWkj7KbeXF6SsrcyaP2
         h74ja/ZoDLi9Yffq5P8Pawrf9NuVFtBoMFEGrKoA=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210302152253eucas1p28c187f3999b16bcc2632fdd687320b84~oj8wRkgUT0597105971eucas1p2E;
        Tue,  2 Mar 2021 15:22:53 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id A3.DE.27958.C485E306; Tue,  2
        Mar 2021 15:22:52 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20210302152252eucas1p2cebd13f124e03ccd69f5d150fe144a64~oj8v1cbfr0565805658eucas1p2i;
        Tue,  2 Mar 2021 15:22:52 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210302152252eusmtrp1f512ea88fa8a07e859d530ebed1e74d2~oj8v0oPor1781617816eusmtrp17;
        Tue,  2 Mar 2021 15:22:52 +0000 (GMT)
X-AuditID: cbfec7f2-efdff70000006d36-12-603e584ccfef
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 9A.25.16282.C485E306; Tue,  2
        Mar 2021 15:22:52 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210302152252eusmtip11cf14f6772e85ba51f862133eaa7fe9c~oj8vlaIJp1399713997eusmtip18;
        Tue,  2 Mar 2021 15:22:52 +0000 (GMT)
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
Subject: [RESEND PATCH v11 2/3] dt-bindings: net: Add bindings for AX88796C
 SPI Ethernet Adapter
Date:   Tue,  2 Mar 2021 16:22:49 +0100
Message-Id: <20210302152250.27113-3-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210302152250.27113-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKKsWRmVeSWpSXmKPExsWy7djPc7o+EXYJBnNOWVmcv3uI2WLjjPWs
        FnPOt7BYzD9yjtVi0fsZrBbX3t5hteh//JrZ4vz5DewWF7b1sVrcPLSC0WLT42usFpd3zWGz
        mHF+H5PFoal7GS3WHrnLbnFsgZhF694j7Bb/9+xgdxDyuHztIrPHlpU3mTx2zrrL7rFpVSeb
        x+Yl9R47d3xm8ujbsorR4/MmuQCOKC6blNSczLLUIn27BK6Mq8fMCs4LVyzo/cnUwDiFv4uR
        k0NCwESi484sZhBbSGAFo8TJh4pdjFxA9hdGiQt939kgnM+MEtNfLGeE6fix/h8zRGI5o8TK
        ngdMEM5zRol5S6+CzWITcJToX3qCFSQhInCPWWJ9+wNGEIdZ4D6jxL3nq8GqhAWSJJ4un8wC
        YrMIqEpcWbyWDcTmFbCWONT8hglin7xE+/LtYHFOARuJDSfXsUDUCEqcnPkEzOYX0JJY03Qd
        zGYGqm/eOhvsPgmBw5wSs5YfYocY5CKx7H4jK4QtLPHq+BaouIzE6ck9QM0cQHa9xORJZhC9
        PYwS2+b8YIGosZa4c+4XG0gNs4CmxPpd+hBhR4kvpyewQbTySdx4KwhxAp/EpG3TmSHCvBId
        bUIQ1SoS6/r3QA2Ukuh9tYJxAqPSLCTPzELywCyEXQsYmVcxiqeWFuempxYb5qWW6xUn5haX
        5qXrJefnbmIEprzT/45/2sE499VHvUOMTByMhxglOJiVRHjFX9omCPGmJFZWpRblxxeV5qQW
        H2KU5mBREuddNXtNvJBAemJJanZqakFqEUyWiYNTqoEpu0rp/LsLE/8tjbrjJq6W8bvww6nJ
        +dtD2BhLon4e0Uw+ZnaxSEllRenaz/YqX7aYTntbmrHYq15kqwH/jhsb9fwep1hH937lPdnb
        IaZaq3WxOPRa1x6TsIs7BQTYtB9ovrzObOH76a7jF+8JQZN6dSfnSN52rJ6g3zYnbReHlPmC
        nE1Zc92+Z6gVLXztL3vX9FG61XyHQmV7RQ/t1U4SRRzRvAyytYbckWZJT3atvqtq/MFwzp49
        r09kz86exLRJuO7jG8dM3viT61VSCmUZQuYlCU4GJmle62c7U7fwfav/v3piw03pQIYpt4w6
        FmizrI2+IqudmmxyUs7sqeq9hMZcHu6vvE92P3nySImlOCPRUIu5qDgRAEjbxc/oAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t/xu7o+EXYJBit7pS3O3z3EbLFxxnpW
        iznnW1gs5h85x2qx6P0MVotrb++wWvQ/fs1scf78BnaLC9v6WC1uHlrBaLHp8TVWi8u75rBZ
        zDi/j8ni0NS9jBZrj9xltzi2QMyide8Rdov/e3awOwh5XL52kdljy8qbTB47Z91l99i0qpPN
        Y/OSeo+dOz4zefRtWcXo8XmTXABHlJ5NUX5pSapCRn5xia1StKGFkZ6hpYWekYmlnqGxeayV
        kamSvp1NSmpOZllqkb5dgl7G1WNmBeeFKxb0/mRqYJzC38XIySEhYCLxY/0/5i5GLg4hgaWM
        Ent2vWHsYuQASkhJrJybDlEjLPHnWhcbRM1TRonZa+YwgSTYBBwl+peeYAVJiAi8YZZouveW
        HcRhFrjPKPHr0wtGkCphgQSJ04vPg3WwCKhKXFm8lg3E5hWwljjU/IYJYoW8RPvy7WBxTgEb
        iQ0n17GA2EJANYvur2SHqBeUODnzCQvIdcwC6hLr5wmBhPkFtCTWNF0HK2cGGtO8dTbzBEah
        WUg6ZiF0zEJStYCReRWjSGppcW56brGRXnFibnFpXrpecn7uJkZghG879nPLDsaVrz7qHWJk
        4mA8xCjBwawkwiv+0jZBiDclsbIqtSg/vqg0J7X4EKMp0GcTmaVEk/OBKSavJN7QzMDU0MTM
        0sDU0sxYSZzX5MiaeCGB9MSS1OzU1ILUIpg+Jg5OqQamqJAwcR/HgMoXCn0ztKKbUmaueviI
        sSDpwuL9q86/2/uLd+rxpJ0v2FcWLj5xhTvqa8vTi7vN1iXuNpSIiF30SE7suoK8V0JY6POl
        1zzVNh+Q4C0sf6Cntr3Ate8++xab5oNWSfNV5P8cXbWl/aNkhJO8nqHvSQfmt9uXJFwzi5J9
        UF7Ar674cn7X3/L//+XO3d+8tNfoTtHT3l3ND7fvcuSSu5J07Sf7Fbt+l/sv7/jJbwi9f+b0
        LicX1Ydyu7i3JTOtbRJ0EjkeF/ebY9ekc7eBaZ39qIz7Ns4Q7beSrn/yJDbw+/lNXPtCPifh
        xX+rtZe/ezPtFguet7fz9rvc1Qvy3IyuurEkMp8R3PFGiaU4I9FQi7moOBEAnviY5HkDAAA=
X-CMS-MailID: 20210302152252eucas1p2cebd13f124e03ccd69f5d150fe144a64
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20210302152252eucas1p2cebd13f124e03ccd69f5d150fe144a64
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210302152252eucas1p2cebd13f124e03ccd69f5d150fe144a64
References: <20210302152250.27113-1-l.stelmach@samsung.com>
        <CGME20210302152252eucas1p2cebd13f124e03ccd69f5d150fe144a64@eucas1p2.samsung.com>
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

