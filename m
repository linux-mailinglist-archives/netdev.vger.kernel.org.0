Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBFD2295486
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 23:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506511AbgJUVuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 17:50:22 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:58164 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2506498AbgJUVuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 17:50:20 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20201021214949euoutp01689891b2db1fc8017071632fc4150ebf~AIE6xy9Ug1708217082euoutp01L
        for <netdev@vger.kernel.org>; Wed, 21 Oct 2020 21:49:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20201021214949euoutp01689891b2db1fc8017071632fc4150ebf~AIE6xy9Ug1708217082euoutp01L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1603316989;
        bh=mTsGxAzRRmkrxqoK+yjwAwQX/CZllg6Kpimdvem06c0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P2Bnb5E6hFrVUywzdBExfHVtVG9mqM0Nuo+sY8T77dpfVDqeUBOdJ5mg+kI0iLHfD
         DthIkZ+6GUtmaJjZBdPhwZi/9jQcYUD4qM34PNQrhpi5F8gmbRaDi+b5YT2OulFscs
         NK1NRcxjO+08mQw5JqO2leNpL9WGHXdkaE+PY2Bs=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20201021214933eucas1p14eede2f86ff6bd0f210ed4d89ab21f76~AIEsIh6581896518965eucas1p1m;
        Wed, 21 Oct 2020 21:49:33 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id FF.8C.06318.DECA09F5; Wed, 21
        Oct 2020 22:49:33 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20201021214933eucas1p152c8fc594793aca56a1cbf008f8415a4~AIErmcSgf1894818948eucas1p1o;
        Wed, 21 Oct 2020 21:49:33 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201021214933eusmtrp2d46d0b3fc357575eed218d77f2067332~AIErlyhUV0512505125eusmtrp2a;
        Wed, 21 Oct 2020 21:49:33 +0000 (GMT)
X-AuditID: cbfec7f5-371ff700000018ae-c6-5f90aceda1e6
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 55.69.06314.DECA09F5; Wed, 21
        Oct 2020 22:49:33 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20201021214933eusmtip2c063ebf98af7a720e9f3667d0f719d73~AIErbeReF1471314713eusmtip28;
        Wed, 21 Oct 2020 21:49:33 +0000 (GMT)
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
        =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
Subject: [PATCH v3 2/5] dt-bindings: net: Add bindings for AX88796C SPI
 Ethernet Adapter
Date:   Wed, 21 Oct 2020 23:49:07 +0200
Message-Id: <20201021214910.20001-3-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201021214910.20001-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTYRjHe3d2zo7S7GxpPlgkzK5Kahn1UlLaBfchyL4KZSc9meRMtlwa
        hNdukhe81JrrQmjeZuoydZVDx9JK3JSVOdrsolApy0K7EpXbMfLb//8+v+f5Pw+8NCF1kUF0
        avpJTpnOpskoX2FH3w/bBre+LDGyoGcbtrnMBG7TtJBYZysU4hsWK4lvTWtIPOJ2krh0fIrA
        NlurCA91lJDYYa5H2DA+QmL7fR2FNTaTAJuruhFutrhEuO/mMny22yKKkcjtI8OEvL3BIZAb
        tS6R3NB4kZLfrcmRG7tmBPKS9kYknzGsjKcTfKOTubRUNaeM2HHY95j99tGMGmnWxfo8KhcZ
        /YqQDw3MZpj+2SkoQr60lKlH0FBeSPFmFkFTwwDBmxkEzr63wn8tPS7NfKEOwXPzUxFv3iF4
        oC33UhQTC6W1j0lPwZ8ZI6Dl/GvkMQRjQmAcqyQ81FImAcrM30iPFjKr4WXe0BxE02JmO5Q4
        d/NxwXC+rpPyaB8mGuwfW724mJHAk6sT3rAlTCjo8194NTHHF9yr9q4HTBUNVxt6ET9oD1yr
        yZu/YSlM9reLeL0C/hhvCDy5wORARfkWvvcSgg7d93l+OzitPykPQzDroeV+BP8cC81NXUK+
        1Q9G3RJ+BT8o77hC8M9iuHBOytOr4E7pw/mBQVA8WY/KkEy74BjtggO0/7NuIqIRBXKZKkUK
        p4pK506Fq1iFKjM9JTzphMKA5j7dwO/+L13I9OuIGTE0ki0Wf9pXliglWbUqW2FGQBMyf/Gu
        wYFDUnEym32aU55IVGamcSozWk4LZYHiqFsfDkqZFPYkd5zjMjjlv6qA9gnKRYEBS2I0vWNH
        qIgsdnrNozeCFVnjnPXx3u5zBQdk9s+V6jhdpH/S2nyDKWKR5NFs72WycLi6e6t+wvHe0j+b
        XxvSFvq9OHuDNvUzOVgUkNu1nrumu/6swtEcf+pZyG39qOBM1JQ1Ur//zwPTzrBNr6LDrq/L
        FLIZ6gp33NPgr8m1MqHqGLsxlFCq2L9ZQJu6cAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLIsWRmVeSWpSXmKPExsVy+t/xe7pv10yIN/h5WNTi/N1DzBYbZ6xn
        tZhzvoXFYv6Rc6wWi97PYLW49vYOq0X/49fMFufPb2C3uLCtj9Xi5qEVjBabHl9jtbi8aw6b
        xYzz+5gsDk3dy2ix9shddotjC8QsWvceYXcQ9Lh87SKzx5aVN5k8ds66y+6xaVUnm8fmJfUe
        O3d8ZvLo27KK0ePzJrkAjig9m6L80pJUhYz84hJbpWhDCyM9Q0sLPSMTSz1DY/NYKyNTJX07
        m5TUnMyy1CJ9uwS9jMvL0gqWCFV0rmhka2DcydfFyMkhIWAiceDuDOYuRi4OIYGljBIHTl5l
        6WLkAEpISaycmw5RIyzx51oXG0TNU0aJ04t/sIMk2AQcJfqXnmAFSYgIvGGWaLr3lh3EYRbY
        xyix/+hisCphgQiJzq4zTCA2i4CqxO3GC4wgG3gFrCX67jhDbJCXaF++nQ3E5hSwkbj8bgMr
        iC0EVHLp3WRGEJtXQFDi5MwnYMcxC6hLrJ8nBBLmF9CSWNN0nQXEZgYa07x1NvMERqFZSDpm
        IXTMQlK1gJF5FaNIamlxbnpusaFecWJucWleul5yfu4mRmBUbzv2c/MOxksbgw8xCnAwKvHw
        fvCZEC/EmlhWXJl7iFGCg1lJhNfp7Ok4Id6UxMqq1KL8+KLSnNTiQ4ymQF9OZJYSTc4HJpy8
        knhDU0NzC0tDc2NzYzMLJXHeDoGDMUIC6YklqdmpqQWpRTB9TBycUg2Mcc5RQUfsH1txMq9o
        dRE3zJz56fXkaQ2c52tWZ7JJPnMwO/GfW/uaSmisRYPrp7T77yv3mD7lOVoWpnKn62OqM8e0
        SSbiHI3rqiKMxX47rtdW+Ob9dX3721cLLSRK+o7E3+iS8JvkaJ0heuS0vpbuRGONT1MfC3Jw
        bH+7xv/LWwXXhPaGw6FKLMUZiYZazEXFiQCHyQLZAAMAAA==
X-CMS-MailID: 20201021214933eucas1p152c8fc594793aca56a1cbf008f8415a4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20201021214933eucas1p152c8fc594793aca56a1cbf008f8415a4
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201021214933eucas1p152c8fc594793aca56a1cbf008f8415a4
References: <20201021214910.20001-1-l.stelmach@samsung.com>
        <CGME20201021214933eucas1p152c8fc594793aca56a1cbf008f8415a4@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bindings for AX88796C SPI Ethernet Adapter.

Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
---
 .../bindings/net/asix,ax88796c.yaml           | 69 +++++++++++++++++++
 1 file changed, 69 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/asix,ax88796c.yaml

diff --git a/Documentation/devicetree/bindings/net/asix,ax88796c.yaml b/Documentation/devicetree/bindings/net/asix,ax88796c.yaml
new file mode 100644
index 000000000000..6c4c49fcad66
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/asix,ax88796c.yaml
@@ -0,0 +1,69 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/asix,ax88796c-spi.yaml#
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
+  - interrupt-parrent
+  - reset-gpios
+
+additionalProperties: false
+
+examples:
+  # Artik5 eval board
+  - |
+    #include <dt-bindings/interrupt-controller/irq.h>
+    #include <dt-bindings/interrupt-controller/gpio.h>
+    ethernet@0 {
+        compatible = "asix,ax88796c";
+        reg = <0x0>;
+        local-mac-address = [00 00 00 00 00 00]; /* Filled in by a bootloader */
+        interrupt-parent = <&gpx2>;
+        interrupts = <0 IRQ_TYPE_LEVEL_LOW>;
+        spi-max-frequency = <40000000>;
+        reset-gpios = <&gpe0 2 GPIO_ACTIVE_LOW>;
+    };
-- 
2.26.2

