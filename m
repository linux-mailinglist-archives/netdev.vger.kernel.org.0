Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8BC729E1E6
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 03:04:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbgJ2CEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 22:04:37 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:34166 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726242AbgJ1Vkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:40:37 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20201028214025euoutp017d07469099923262281edc06cc832adf~CRdtH2JVw3240832408euoutp01k
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 21:40:25 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20201028214025euoutp017d07469099923262281edc06cc832adf~CRdtH2JVw3240832408euoutp01k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1603921225;
        bh=TmlrcraEmN6nS3uE2s6DB5WImBH1BqSTgR395EFEKMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e1HIJSAY7yqpkm1kM0Lg1AIpH5wpbl11bfrTWZxEt2US9JrzHRt7GO4Yn7O7zobh1
         4nl2N1xnr5niAwXk/6AqdSM4NfSjmgy4/gaITKRcaRiMiTURMsmDZMlba3Yy2d5VsU
         mDrPeSLdLUWsfvg/yUetxS+7bk9vaR/p3/AVV3kw=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20201028214018eucas1p224887582acb4c30bfe129ccb21bd8e5a~CRdm8Pd-G2483124831eucas1p2Y;
        Wed, 28 Oct 2020 21:40:18 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id D2.5C.06318.245E99F5; Wed, 28
        Oct 2020 21:40:18 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20201028214017eucas1p193f14480d56dfc49f07f27e4e7933ca5~CRdl4ohZY0399203992eucas1p1T;
        Wed, 28 Oct 2020 21:40:17 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201028214017eusmtrp28f7e5a5ab017d807595702d59f77334e~CRdl3bGWO3218532185eusmtrp2j;
        Wed, 28 Oct 2020 21:40:17 +0000 (GMT)
X-AuditID: cbfec7f5-371ff700000018ae-02-5f99e542c663
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 6F.8E.06314.145E99F5; Wed, 28
        Oct 2020 21:40:17 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20201028214017eusmtip220bc1e266920f0410cfa4de1a963739b~CRdlYqQ0d1054810548eusmtip2h;
        Wed, 28 Oct 2020 21:40:17 +0000 (GMT)
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
Subject: [PATCH v4 4/5] ARM: dts: exynos: Add Ethernet to Artik 5 board
Date:   Wed, 28 Oct 2020 22:40:11 +0100
Message-Id: <20201028214012.9712-5-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201028214012.9712-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTYRiA+XZ2tqM1O06pF7syjChQEyU+vJEmdaJ+KIlEWLbyYJLO2HFe
        +tPQvJemedsaaFJoUqnzUiu3YN664GaIlqmjmCIp3XBChVZuZ5L/nvd7n/cGH0VIbaQflabI
        YpUKebpM5CnsHfplDYiZ0yQfHCgLwNYZM4E7G9pJrLNeF+LGAQuJm781kHjiyzSJK+2LBLZa
        O8R4tLeCxJPmVoT19gkSjz3TiXCD1STA5lojwo8GZsR4qGkrLjQOiA97M2MTbwmm+8GkgDFo
        Z8SMvq1UxHTdu8YYni4JmIruNsQs6XfFUWc8I1LY9LRsVhkUdd7z0uvBOXRldVOuuqeeVKMf
        HmXIgwI6FL4/N6Ay5ElJ6VYE7T/qSD5wINAVlgj4YAnB6kyZcL1kpN9O8IkWBB2aArc1j+DF
        o3HktER0NFTef+nq5UvbCGgv/uiaQtAmBAZbDeG0fOhjUDU17uorpPeCxTjkYgkdBs1LgyQ/
        bzcUtzwROdmDDodZx3OSd7zhlWbW5W+hD8DD/HcuJtb8gp47BF9bS0G5ScBzLHysrxLz7AML
        w91u3gF/DY1rDrXG1+B29SHnnkDfQNCr++m+ORymLb9FToeg90P7syD+ORryFxwEX+oF7794
        8xt4QXVvvftZAiVFUt72h8eVfe6GfnBzoRXdQjLthlu0G/bX/p/VhIg2tI1VcRmpLBeiYHMC
        OXkGp1KkBl7MzNCjtV/35s/w8lNkWrlgRjSFZJslo1OaZCkpz+byMswIKELmK4kZeXNOKkmR
        511llZnJSlU6y5nRdkoo2yYJaf58VkqnyrPYyyx7hVWuZwWUh58aJd2Vvw2Wch9G5le99qg/
        jZlCT9f5pp8+UhSZmqhdWBkpX04LG8q1ereEX6g503WiSfPB4uvft9o5quo01dZbLTZZbIQ+
        0dGgPPnVpsrPVStE8YTdcTRpMS4vi4qPDM/dYmwtYYKz8o4nlJKBMVGT++wJOkPOKeNeYX/V
        zupXMiF3SR58gFBy8n/0Cf9acQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPIsWRmVeSWpSXmKPExsVy+t/xe7qOT2fGG9yaoGhx/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2px89AKRotNj6+xWlzeNYfN
        Ysb5fUwWh6buZbRYe+Quu8WxBWIWrXuPsDsIely+dpHZY8vKm0weO2fdZffYtKqTzWPzknqP
        nTs+M3n0bVnF6PF5k1wAR5SeTVF+aUmqQkZ+cYmtUrShhZGeoaWFnpGJpZ6hsXmslZGpkr6d
        TUpqTmZZapG+XYJexqmjTxkL/nJXNGydztrA+JGzi5GTQ0LAROLs4cfMXYxcHEICSxklXs35
        w9TFyAGUkJJYOTcdokZY4s+1LjaImqeMEr8vTGQESbAJOEr0Lz3BCpIQEXjDLNF07y07iMMs
        sI9RYv/RxewgVcIC7hITb19lAbFZBFQlzu09BmbzClhJLPp8lBVihbxE+/LtbCA2p4C1xJMv
        u8HiQkA1P7+1sUPUC0qcnPmEBeQ6ZgF1ifXzhEDC/AJaEmuaroONZAYa07x1NvMERqFZSDpm
        IXTMQlK1gJF5FaNIamlxbnpusaFecWJucWleul5yfu4mRmBkbzv2c/MOxksbgw8xCnAwKvHw
        Xrg9M16INbGsuDL3EKMEB7OSCK/T2dNxQrwpiZVVqUX58UWlOanFhxhNgd6cyCwlmpwPTDp5
        JfGGpobmFpaG5sbmxmYWSuK8HQIHY4QE0hNLUrNTUwtSi2D6mDg4pRoY80QfBdv9uZund3Df
        Ap4jGSYfy7eeE/Xfx5V65uCvzQGrnCYZWzXLBxyw6eWO5Urh61q++sye/W2hKUeb+D0Krtx7
        UiX1Jl/0en7w3fushj1iz7MVxTbfKN2+/p8T3wGdd9fuqUyPEfoeFTR5yeQ1P+NvaT4P5v+1
        xP+ZYtOhE5t8I56LCOenKbEUZyQaajEXFScCAHRNC7QCAwAA
X-CMS-MailID: 20201028214017eucas1p193f14480d56dfc49f07f27e4e7933ca5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20201028214017eucas1p193f14480d56dfc49f07f27e4e7933ca5
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201028214017eucas1p193f14480d56dfc49f07f27e4e7933ca5
References: <20201028214012.9712-1-l.stelmach@samsung.com>
        <CGME20201028214017eucas1p193f14480d56dfc49f07f27e4e7933ca5@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add node for ax88796c ethernet chip.

Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
---
 arch/arm/boot/dts/exynos3250-artik5-eval.dts | 29 ++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250-artik5-eval.dts b/arch/arm/boot/dts/exynos3250-artik5-eval.dts
index 20446a846a98..a91e09a7d3fa 100644
--- a/arch/arm/boot/dts/exynos3250-artik5-eval.dts
+++ b/arch/arm/boot/dts/exynos3250-artik5-eval.dts
@@ -37,3 +37,32 @@ &mshc_2 {
 &serial_2 {
 	status = "okay";
 };
+
+&spi_0 {
+	status = "okay";
+	cs-gpios = <&gpx3 4 GPIO_ACTIVE_LOW>, <0>;
+
+	assigned-clocks = <&cmu CLK_MOUT_MPLL>, <&cmu CLK_DIV_MPLL_PRE>,
+		<&cmu CLK_MOUT_SPI0>, <&cmu CLK_DIV_SPI0>,
+		<&cmu CLK_DIV_SPI0_PRE>, <&cmu CLK_SCLK_SPI0>;
+	assigned-clock-parents =
+		<&cmu CLK_FOUT_MPLL>,    /* for: CLK_MOUT_MPLL */
+		<&cmu CLK_MOUT_MPLL>,	 /* for: CLK_DIV_MPLL_PRE */
+		<&cmu CLK_DIV_MPLL_PRE>, /* for: CLK_MOUT_SPI0 */
+		<&cmu CLK_MOUT_SPI0>,    /* for: CLK_DIV_SPI0 */
+		<&cmu CLK_DIV_SPI0>,     /* for: CLK_DIV_SPI0_PRE */
+		<&cmu CLK_DIV_SPI0_PRE>; /* for: CLK_SCLK_SPI0 */
+
+	ethernet@0 {
+		compatible = "asix,ax88796c";
+		reg = <0x0>;
+		local-mac-address = [00 00 00 00 00 00]; /* Filled in by a boot-loader */
+		interrupt-parent = <&gpx2>;
+		interrupts = <0 IRQ_TYPE_LEVEL_LOW>;
+		spi-max-frequency = <40000000>;
+		reset-gpios = <&gpe0 2 GPIO_ACTIVE_LOW>;
+		controller-data {
+			samsung,spi-feedback-delay = <2>;
+		};
+	};
+};
-- 
2.26.2

