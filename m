Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9587A43529E
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 20:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbhJTS0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 14:26:48 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:17851 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231147AbhJTS0p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 14:26:45 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20211020182429euoutp024f650ec2f196da788761397c4fe8f6fd~v0FjA2mp00661606616euoutp02W
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 18:24:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20211020182429euoutp024f650ec2f196da788761397c4fe8f6fd~v0FjA2mp00661606616euoutp02W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1634754269;
        bh=Z4IBSKno7o4u2IPtq/oGi8k3geESxSGYf1l5VWz39q4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pIBLLnMl7UsA8wxiT32Z0cbIZ2DdUDgimDQrVum03Mu0OoqE+OEDsywxxOsINQr24
         f/ohA84QH8Q7IBXZWIJzjCZSrlNK4E4y0+hpQID1x+PueP8lM73sWPHQgJ7cDKYEZY
         i+xBYu2H5Z1YnHs3x67Oz9k/vkdLH25ENLNDHagA=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20211020182428eucas1p1e6643659a8d063258d835b37854d222d~v0Fh49xZT1478514785eucas1p13;
        Wed, 20 Oct 2021 18:24:28 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 83.5F.45756.BDE50716; Wed, 20
        Oct 2021 19:24:27 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20211020182427eucas1p19b59c72bedc0d7f7f0ccfdda19982635~v0FhfIj1V1476714767eucas1p19;
        Wed, 20 Oct 2021 18:24:27 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20211020182427eusmtrp1c931511ed52b5268858cb845dcb02351~v0FheZXS72102421024eusmtrp1t;
        Wed, 20 Oct 2021 18:24:27 +0000 (GMT)
X-AuditID: cbfec7f2-7d5ff7000002b2bc-37-61705edbe430
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 7A.CE.31287.BDE50716; Wed, 20
        Oct 2021 19:24:27 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20211020182427eusmtip18772478c182369fda147e9e5b83ce501~v0FhNyOZk2671726717eusmtip1p;
        Wed, 20 Oct 2021 18:24:27 +0000 (GMT)
From:   =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        jim.cromie@gmail.com, Heiner Kallweit <hkallweit1@gmail.com>,
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
Subject: [PATCH net-next v17 2/3] dt-bindings: net: Add bindings for
 AX88796C SPI Ethernet Adapter
Date:   Wed, 20 Oct 2021 20:24:21 +0200
Message-Id: <20211020182422.362647-3-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211020182422.362647-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKKsWRmVeSWpSXmKPExsWy7djP87q34woSDaY9tbI4f/cQs8XGGetZ
        Leacb2GxmH/kHKvFovczWC2uvb3DatH/+DWzxfnzG9gtLmzrY7W4eWgFo8Wmx9dYLS7vmsNm
        MeP8PiaLQ1P3MlqsPXKX3eLYAjGL1r1H2C3+79nB7iDkcfnaRWaPLStvMnnsnHWX3WPTqk42
        j81L6j127vjM5NG3ZRWjx+dNcgEcUVw2Kak5mWWpRfp2CVwZzeefsBecF644vOsucwPjFP4u
        Rk4OCQETiZ3bVrB0MXJxCAmsYJQ4cGISO0hCSOALo8SxXbEQic+MEhP+TWeE6VjV/YIdIrGc
        UWLhzVY2COc5o8TliQfA2tkEHCX6l55gBUmICNxjlvh07DhYFbPAfUaJe89XM4NUCQukSEx5
        uIkJxGYRUJWY3tIHFucVsJG4dOclE8Q+eYm26xC7OQVsJboX9ULVCEqcnPmEBcTmF9CSWNN0
        HcxmBqpv3jqbGaL3MKfE9q3JELaLxInHK1khbGGJV8e3sEPYMhKnJ/cA9XIA2fUSkyeZgdwp
        IdDDKLFtzg8WiBpriTvnfrGB1DALaEqs36UPEXaUONc2lRWilU/ixltBiAv4JCZtm84MEeaV
        6GgTgqhWkVjXvwdqoJRE76sVjBMYlWYh+WUWkvtnIexawMi8ilE8tbQ4Nz212DAvtVyvODG3
        uDQvXS85P3cTIzDlnf53/NMOxrmvPuodYmTiYDzEKMHBrCTCu7siP1GINyWxsiq1KD++qDQn
        tfgQozQHi5I476rZa+KFBNITS1KzU1MLUotgskwcnFINTEwnFkifU/4x92LyOZUZBicF99V2
        /pT971d/5duaiofethadDE1nPvZPl9VN/LyJ31GzSu+q+99ti2ZxrHjxqvHskUjzDRmTOIQT
        zkvVhh/U2mV96cfne1dmvN3Asc9YwFTRLn5d1sfeutev1CccCCs6XMS/fMMN3eJzD2Q2bJM8
        +t51ue9FW9m1STxlJnPsamPt9+hv05ox09+nq/Ttft0koz/iCX9rtvxezdWrs+aytMtJmbdF
        12oFxRe0utx28reQ4nw/q+DAPCYep7LX032eLI/58Ntmz6UbwXoRAT8iuF5OY3Nnd3nsvUTO
        pfP5GbudnS/m3Hn9bMWZO7yslxriXv5qcH58e1+CQPrsAnclluKMREMt5qLiRADgwzyb6AMA
        AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t/xu7q34woSDVovKlicv3uI2WLjjPWs
        FnPOt7BYzD9yjtVi0fsZrBbX3t5hteh//JrZ4vz5DewWF7b1sVrcPLSC0WLT42usFpd3zWGz
        mHF+H5PFoal7GS3WHrnLbnFsgZhF694j7Bb/9+xgdxDyuHztIrPHlpU3mTx2zrrL7rFpVSeb
        x+Yl9R47d3xm8ujbsorR4/MmuQCOKD2bovzSklSFjPziElulaEMLIz1DSws9IxNLPUNj81gr
        I1MlfTublNSczLLUIn27BL2M5vNP2AvOC1cc3nWXuYFxCn8XIyeHhICJxKruF+xdjFwcQgJL
        GSX6Js1m6mLkAEpISaycmw5RIyzx51oXG0TNU0aJzw++sYAk2AQcJfqXnmAFsUUE3jBL/OyV
        AiliFrjPKPHr0wtGkISwQJJE37OZYA0sAqoS01v6mEFsXgEbiUt3XjJBbJCXaLs+HayeU8BW
        ontRL1iNEFDNtV3n2SDqBSVOznzCAnIcs4C6xPp5QiBhfgEtiTVN18HGMwONad46m3kCo9As
        JB2zEDpmIalawMi8ilEktbQ4Nz232FCvODG3uDQvXS85P3cTIzDCtx37uXkH47xXH/UOMTJx
        MB5ilOBgVhLh3V2RnyjEm5JYWZValB9fVJqTWnyI0RTos4nMUqLJ+cAUk1cSb2hmYGpoYmZp
        YGppZqwkzrt17pp4IYH0xJLU7NTUgtQimD4mDk6pBqbjMRlCpWtZSvfPlHysav9Fzfq7Wth8
        5jkRT06VTjLmeVpmvEQuO77gE4dK4hupv17sV+4aaOxmK9q1LVdNVzKvVVPzGvv5OcVb+z/u
        4pvtMWFfzvbz17bN/HIk7uq57PU5Fz+V3Y8+07NEV7Wj/CjX/q1Hwly2Mber5itmH+pUMSmU
        EL01+cH1naqMuXcqH1R7PDpXMfHtkufTd/Lw1sxR6DH9EFS+3/bcu8i2xz+uVfWuaArqVt3/
        sEQuYMMdpcty16/e4OPYxTq5/uFtp82NNbyd5/Y4WHtOsL8m+P/BtNeWvA1cCw1UcltijUSd
        Vu6x0u1ekq/7aKNfasPy8/kuzZs8y97vUKm2vPNHfa4SS3FGoqEWc1FxIgBv59ageQMAAA==
X-CMS-MailID: 20211020182427eucas1p19b59c72bedc0d7f7f0ccfdda19982635
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20211020182427eucas1p19b59c72bedc0d7f7f0ccfdda19982635
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20211020182427eucas1p19b59c72bedc0d7f7f0ccfdda19982635
References: <20211020182422.362647-1-l.stelmach@samsung.com>
        <CGME20211020182427eucas1p19b59c72bedc0d7f7f0ccfdda19982635@eucas1p1.samsung.com>
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
2.30.2

