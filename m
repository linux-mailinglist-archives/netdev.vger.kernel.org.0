Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2B832A4932
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 16:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728458AbgKCPRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 10:17:24 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54988 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728415AbgKCPQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 10:16:10 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20201103151542euoutp02af7de30321fdb79ca413ce7362b98ad7~ECFhe77KB0580805808euoutp02b
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 15:15:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20201103151542euoutp02af7de30321fdb79ca413ce7362b98ad7~ECFhe77KB0580805808euoutp02b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1604416542;
        bh=TmlrcraEmN6nS3uE2s6DB5WImBH1BqSTgR395EFEKMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oJFSghgSaEAcQBp1BGQ4TYbov+vKT3A13EX4VcdBadTOIGZXymA7ObO0OJ2dJGcbz
         ZaZESQGbJtoubkJYYEKksb9lzbsImS5DzLJTPhJyQMbBiTkwobQv/KJBUB/bJRa+Dg
         pkltCQtiV0hdcqqdQqKGLplw4AyQuws9Yvr9PCOw=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20201103151540eucas1p1499c74af6e2cbaf96e1d72ecf00c9c30~ECFfaVImX1640316403eucas1p1J;
        Tue,  3 Nov 2020 15:15:40 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 80.0B.05997.C1471AF5; Tue,  3
        Nov 2020 15:15:40 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20201103151540eucas1p2750cffe062d6abff42ee479a218c8eb8~ECFfIkJb63053830538eucas1p22;
        Tue,  3 Nov 2020 15:15:40 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201103151540eusmtrp1a7ae73a00622cea2838e493a4723c669~ECFfH4cik0045400454eusmtrp1v;
        Tue,  3 Nov 2020 15:15:40 +0000 (GMT)
X-AuditID: cbfec7f4-65dff7000000176d-a2-5fa1741c08d8
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id C8.B9.06314.C1471AF5; Tue,  3
        Nov 2020 15:15:40 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20201103151540eusmtip1e5a5130c32387643196ff28d915de3cb~ECFe8Il2F2300123001eusmtip15;
        Tue,  3 Nov 2020 15:15:40 +0000 (GMT)
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
Subject: [PATCH v5 4/5] ARM: dts: exynos: Add Ethernet to Artik 5 board
Date:   Tue,  3 Nov 2020 16:15:35 +0100
Message-Id: <20201103151536.26472-5-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201103151536.26472-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Se0hTcRTut7u7XR+z64w8qCSsFLKyfBQ/coRK1P6IipIgoWzpRcMn27S0
        qJGWDyzzlbpGLctclvl+jZQamqXoLMFH6RRXmEuTsEIzJber5H/fd873feccOBQhNJIu1IU4
        BSOLk8aIeLbcxjcLvbvcFA/D9mi6PLFhVE/gmuIqEqsNaVz8oL2XxKWzxSQemBkhcY7pG4EN
        hmo+7mu8TeJhvRbhWtMAift1ah4uNrRxsL6wFeHK9lE+fqPZjG+0tvMDHSX9A+8JSf3TYY6k
        RTXKl9RWZPIkdY+vSVqa5ziS2/UVSDJXu+U4FWorjmBiLiQxst0HztlGdXV8QQlLdpeUDUWk
        Ev2wyUI2FND+YNR2ElnIlhLSWgTqkruIJT8RFKjSSJbMIbj3sAWtWb4WtfHYRjmCbkP5KplE
        kDm5yLeoeHQQ5JS9tdo30UYCqtLHrcEE3YagxViwMpKinOjDkNuvsBi4tAeYelJJCxbQATC3
        NMRjx7lDenmTFdvQYlAWFHJYjSO8K/nMteCNtBc8vz5oxcSKPrXhnvUioHMp+PT9CZ8NOggd
        fRkki53A3Fm/WneD7vxsrmUfoK9Bft4+1puNoFE9z2U1ATDS+4dn0RD0dqjS7WbLQVC9UMJn
        rQ4wNOPIruAAeY1FBFsWQMZNIaveBi9yXq4GusAtsxbdQSLVumNU6w5Q/Z+lQUQFcmYS5bGR
        jNw3jrnoLZfGyhPjIr3D42Nr0crXdS93/mxGur/n9YimkMheEMhowoSkNEmeHKtHQBGiTYLg
        nu6zQkGENDmFkcWHyRJjGLkeuVJckbPAr3TqjJCOlCqYaIZJYGRrXQ5l46JEV48QE8qJy0d1
        lc9O74yX/ZlUfhg85Po66pFuvKz61bRZvRisKKso8bMXh5jP9k7r6/YHhoV0jB1t3btBaBrT
        zs5HHMt2qplZuB99PFyYuGzInQ/x/H1yS5Lme/RWo485nREM2jX9qjGdqjyxf8fgR48rDhHi
        KU1AQqj4TIqv2d9dxJVHSX28CJlc+g9mE13FcQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsVy+t/xu7oyJQvjDZ69FbQ4f/cQs8XGGetZ
        Leacb2GxmH/kHKvFovczWC2uvb3DatH/+DWzxfnzG9gtLmzrY7W4eWgFo8Wmx9dYLS7vmsNm
        MeP8PiaLQ1P3MlqsPXKX3eLYAjGL1r1H2B0EPS5fu8jssWXlTSaPnbPusntsWtXJ5rF5Sb3H
        zh2fmTz6tqxi9Pi8SS6AI0rPpii/tCRVISO/uMRWKdrQwkjP0NJCz8jEUs/Q2DzWyshUSd/O
        JiU1J7MstUjfLkEv49TRp4wFf7krGrZOZ21g/MjZxcjJISFgIvFi+j62LkYuDiGBpYwShx40
        M3YxcgAlpCRWzk2HqBGW+HOtC6rmKaPE06ZeFpAEm4CjRP/SE6wgCRGBN8wSTffesoM4zAL7
        GCX2H13MDjJJWMBdYuLlEpAGFgFVicdnm1lBbF4Ba4nPf2+wQWyQl2hfvh3M5hSwkWiYMpUJ
        xBYCqtl1dAsbRL2gxMmZT1hARjILqEusnycEEuYX0JJY03Qd7B5moDHNW2czT2AUmoWkYxZC
        xywkVQsYmVcxiqSWFuem5xYb6hUn5haX5qXrJefnbmIExvW2Yz8372C8tDH4EKMAB6MSD69D
        6oJ4IdbEsuLK3EOMEhzMSiK8TmdPxwnxpiRWVqUW5ccXleakFh9iNAV6cyKzlGhyPjDl5JXE
        G5oamltYGpobmxubWSiJ83YIHIwREkhPLEnNTk0tSC2C6WPi4JRqYAxpmubmb7Dh0Y2AVXkP
        e8Nln+9odM9e+HiueKX+skB2r2OSNgzsf9bFRm+TPxJsc7xsbdr0PWzCKjaynccTg6zbYrJY
        PrG9jJhVcbtoU6CdUJ/83A0vQm4qH/oj0myXbXJLc+rE9xcb9jjEi3U5x5+Qk1EWn7pObUte
        /ttNj+uZdq7QFH33VImlOCPRUIu5qDgRAGshmBQBAwAA
X-CMS-MailID: 20201103151540eucas1p2750cffe062d6abff42ee479a218c8eb8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20201103151540eucas1p2750cffe062d6abff42ee479a218c8eb8
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201103151540eucas1p2750cffe062d6abff42ee479a218c8eb8
References: <20201103151536.26472-1-l.stelmach@samsung.com>
        <CGME20201103151540eucas1p2750cffe062d6abff42ee479a218c8eb8@eucas1p2.samsung.com>
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

