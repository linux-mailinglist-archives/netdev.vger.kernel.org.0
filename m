Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35700281BA3
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 21:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388522AbgJBTWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 15:22:24 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:41152 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388478AbgJBTWW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 15:22:22 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20201002192217euoutp019739385a1215c869b506a6d92c18eaf7~6QzrmWhuL0152301523euoutp01g
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 19:22:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20201002192217euoutp019739385a1215c869b506a6d92c18eaf7~6QzrmWhuL0152301523euoutp01g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1601666537;
        bh=U1UCX20HUE0JmpBPjjxqCtXiDnfNU/Fkk5/O+oz+GJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vBoqgAH2lQ6FsvuCvit0NEbnxYdCUZlglwqdH/n9HWKwDzECwokZGoz7UrFQv2m7b
         VBzxMFjlN3D8+LmAc+LceokUElh6fxLYZv0D3bjEKFyvWiT0usR5JRQ6nqNgfLWO1k
         k+NPNd6LSHKN6+q7RxPrh0zMkySUDhKezu60rUVc=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20201002192217eucas1p23d95aee31e1c228260cc43754ec2748a~6QzrGDbnC1922419224eucas1p2r;
        Fri,  2 Oct 2020 19:22:17 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 0F.BA.06456.9ED777F5; Fri,  2
        Oct 2020 20:22:17 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20201002192216eucas1p16933608dcb0fb8ceee21caa3455cbaf1~6QzqlgFp-1183211832eucas1p1K;
        Fri,  2 Oct 2020 19:22:16 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201002192216eusmtrp242840993dcaae6ceb99521d78be57204~6Qzqk4zTK3070930709eusmtrp28;
        Fri,  2 Oct 2020 19:22:16 +0000 (GMT)
X-AuditID: cbfec7f2-7efff70000001938-2e-5f777de9447c
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id D1.54.06017.8ED777F5; Fri,  2
        Oct 2020 20:22:16 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20201002192216eusmtip2e26aea81762b559d3c795ff2c3a0e124~6QzqXsZ4X2142021420eusmtip2S;
        Fri,  2 Oct 2020 19:22:16 +0000 (GMT)
From:   =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, jim.cromie@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     =?UTF-8?q?Bart=C5=82omiej=20=C5=BBolnierkiewicz?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
Subject: [PATCH v2 3/4] ARM: dts: exynos: Add Ethernet to Artik 5 board
Date:   Fri,  2 Oct 2020 21:22:09 +0200
Message-Id: <20201002192210.19967-4-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201002192210.19967-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTYRjHffeesx1Hs7Mp+maRsOqD5iUt6pRSKUHnoxUElalLType2dSl
        4IWVmqLOVqaZpJn38jZtuZGDlkzFyzTxmgZpWWpCqFFmaG7HyG//53l/z/95/vASUDSGOxIR
        MfGMNEYSJebyMY1xbcBtPkUedMQwj1GmaQOkWoqbcKrUdAejyjoHcGp0aQqnlLOLkDKZmnnU
        oCYfpyYMtYBSz47i1LCulEsVm/QcylDYAaiGzmkeZSy3pzI6OnlnSXp4dAjSbXUTHFpbMs2j
        1fXZXLq1Mo3Wtq9w6Py2ekCvqPf7E1f5PqFMVEQiI/U4HcwP143oOXE9/FvN2UY8HcwROcCa
        QOQx1LBYjecAPiEiawGqyZuDbLEKUH7lLG6mROQKQJr3fjmAsEyMKFJZpgagtTebGMt8Aeje
        d7lZc0lfpKzqtrjakRqIvrVWYOYCknqAtB8eQDNlS55HbWolz6wx8hDqerJqcRKQ3ujZRyXG
        3ueEsmpecc3amvRBOkUzj2WEqOfRJwuzm3RBLxRjFg23+NsvH1siIDKbQJ+zVnHW6BwqmFRA
        Vtuiha42Hqv3oU1tGYeNlobuq46zs7lbiUt/bR/hjaYGfnPNDCSdUZPOg237osb1dS47aoPG
        l4TsCTZIpSmCbFuA7maKWPogalS+3jZ0RHkLtaAAiEt2hCnZEaDk/65yAOuBA5Mgiw5jZJ4x
        jNxdJomWJcSEuYfERqvB1nfr3ehabgc/3t0wAJIA4l2CYC95kAiXJMqSog0AEVBsJ/Dr7w0U
        CUIlScmMNDZImhDFyAxgL4GJHQRHK+avi8gwSTwTyTBxjPTfK4ewdkwHN9czrNxSijZSZy4Y
        BfbMoC4r0nnm0uqpoZMd6faRprrFJaJQODxrNenor4G0V/n4YbmQvnalqzgOGjOG3yr6clSB
        nqqH0oDUyTO9+svJBzoK+8arW5SZT0eSQ5xOzO2R6y+67hZ62Hxtj6qKtwktd00X9AR096v/
        LG8+7839KcZk4RJPFyiVSf4CU7dzuGoDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsVy+t/xe7ovasvjDXbOVLQ4f/cQs8XGGetZ
        Leacb2GxmH/kHKvFtbd3WC36H79mtjh/fgO7xYVtfawWNw+tYLTY9Pgaq8XlXXPYLGac38dk
        cWjqXkaLtUfuslscWyBm0br3CLuDgMflaxeZPbasvMnksXPWXXaPTas62Tw2L6n32LnjM5NH
        35ZVjB6fN8kFcETp2RTll5akKmTkF5fYKkUbWhjpGVpa6BmZWOoZGpvHWhmZKunb2aSk5mSW
        pRbp2yXoZey6uo+p4CRXxYbOY6wNjM84uhg5OCQETCSuNtV1MXJxCAksZZS43/SMCSIuJbFy
        bnoXIyeQKSzx51oXG0TNU0aJI3tmsYMk2AQcJfqXnmAFSYgIHGKW+PbkDAuIwyywj1Fi/9HF
        YFXCAu4SWzb1g9ksAqoSx+d9YQGxeQWsJRY/7GeBWCEv0b58OxuIzSlgI7GraQNYvRBQzeWb
        Rxkh6gUlTs58wgJyHbOAusT6eUIgYX4BLYk1TdfBxjADjWneOpt5AqPQLCQdsxA6ZiGpWsDI
        vIpRJLW0ODc9t9hIrzgxt7g0L10vOT93EyMwmrcd+7llB2PXu+BDjAIcjEo8vBwG5fFCrIll
        xZW5hxglOJiVRHidzp6OE+JNSaysSi3Kjy8qzUktPsRoCvTmRGYp0eR8YKLJK4k3NDU0t7A0
        NDc2NzazUBLn7RA4GCMkkJ5YkpqdmlqQWgTTx8TBKdXA2HM4Mi7/vmeVff1m08hA/uUm7+8F
        3wv9s9kwV6JnzYEH8/d93ep04v/0O9OVA9ZfvBLUZK88g5VtjkLGquK93iU2xXVSxkGX/Cp/
        tEZZnTu0wMapodpq7W3tnacfdHfLN7yfMHvdhP2H/yq/fxNxYb1Fd++2eKa7r1fq3myyXpRi
        76H55/ZqeyWW4oxEQy3mouJEAKjv+XP8AgAA
X-CMS-MailID: 20201002192216eucas1p16933608dcb0fb8ceee21caa3455cbaf1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20201002192216eucas1p16933608dcb0fb8ceee21caa3455cbaf1
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201002192216eucas1p16933608dcb0fb8ceee21caa3455cbaf1
References: <20201002192210.19967-1-l.stelmach@samsung.com>
        <CGME20201002192216eucas1p16933608dcb0fb8ceee21caa3455cbaf1@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add node for ax88796c ethernet chip.

Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
---
 arch/arm/boot/dts/exynos3250-artik5-eval.dts | 21 ++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250-artik5-eval.dts b/arch/arm/boot/dts/exynos3250-artik5-eval.dts
index 20446a846a98..7f115c348a2a 100644
--- a/arch/arm/boot/dts/exynos3250-artik5-eval.dts
+++ b/arch/arm/boot/dts/exynos3250-artik5-eval.dts
@@ -37,3 +37,24 @@ &mshc_2 {
 &serial_2 {
 	status = "okay";
 };
+
+&spi_0 {
+	status = "okay";
+	cs-gpios = <&gpx3 4 GPIO_ACTIVE_LOW>, <0>;
+
+	assigned-clocks        = <&cmu CLK_MOUT_MPLL>, <&cmu CLK_DIV_MPLL_PRE>, <&cmu CLK_MOUT_SPI0>,    <&cmu CLK_DIV_SPI0>,  <&cmu CLK_DIV_SPI0_PRE>, <&cmu CLK_SCLK_SPI0>;
+	assigned-clock-parents = <&cmu CLK_FOUT_MPLL>, <&cmu CLK_MOUT_MPLL>,    <&cmu CLK_DIV_MPLL_PRE>, <&cmu CLK_MOUT_SPI0>, <&cmu CLK_DIV_SPI0>,     <&cmu CLK_DIV_SPI0_PRE>;
+
+	ax88796c@0 {
+		compatible = "asix,ax88796c";
+		local-mac-address = [00 00 00 00 00 00]; /* Filled in by a boot-loader */
+		interrupt-parent = <&gpx2>;
+		interrupts = <0 IRQ_TYPE_LEVEL_LOW>;
+		spi-max-frequency = <40000000>;
+		reg = <0x0>;
+		reset-gpios = <&gpe0 2 GPIO_ACTIVE_LOW>;
+		controller-data {
+			samsung,spi-feedback-delay = <2>;
+		};
+	};
+};
-- 
2.26.2

