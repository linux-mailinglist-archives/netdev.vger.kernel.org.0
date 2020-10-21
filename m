Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C523295490
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 23:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506544AbgJUVui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 17:50:38 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:57563 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2506494AbgJUVuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 17:50:20 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20201021214950euoutp02c5a3d43e5251db936606e707a58d2eae~AIE7EhrMv1593215932euoutp02W
        for <netdev@vger.kernel.org>; Wed, 21 Oct 2020 21:49:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20201021214950euoutp02c5a3d43e5251db936606e707a58d2eae~AIE7EhrMv1593215932euoutp02W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1603316990;
        bh=TmlrcraEmN6nS3uE2s6DB5WImBH1BqSTgR395EFEKMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LecW9aaXKC0/sUFA7eUMcCH30dLerEMILDdcHOP5WsbOK253cFPkl9t/cjRJ6dZR/
         Z+Kk1ublUXdSjFJ/rAAmkhmDA6eFLNrNokWTBxM+OHv6SGFfqeiw7+oLRgMZtirn0Q
         L1LS13jjEIM2L19PsijV+zWfSkACgFcxSrJdST54=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20201021214935eucas1p27a7e85fa750c392fb73107b21860812c~AIEtV-L_62056620566eucas1p2-;
        Wed, 21 Oct 2020 21:49:35 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 60.FD.06456.FECA09F5; Wed, 21
        Oct 2020 22:49:35 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20201021214934eucas1p273214a19e3a775512ab3090d243260db~AIEsWzrNo1834818348eucas1p2q;
        Wed, 21 Oct 2020 21:49:34 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201021214934eusmtrp2af4b03de3f2bb36e18910f57cdefb79b~AIEsVi51v0512505125eusmtrp2b;
        Wed, 21 Oct 2020 21:49:34 +0000 (GMT)
X-AuditID: cbfec7f2-809ff70000001938-3d-5f90acefe1e9
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 76.69.06314.EECA09F5; Wed, 21
        Oct 2020 22:49:34 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20201021214933eusmtip2ad0c643e91e2ce1762678da6757ad1a0~AIEsJBecX2342923429eusmtip28;
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
Subject: [PATCH v3 4/5] ARM: dts: exynos: Add Ethernet to Artik 5 board
Date:   Wed, 21 Oct 2020 23:49:09 +0200
Message-Id: <20201021214910.20001-5-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201021214910.20001-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0hTcRTH+e3ubnfL6XVKnuzJJf8oUJNEfpBZStSIoCL6oyjnajeV9ojN
        RwqlpGaZ6dBE2xaKFFuW+Zy5bAZrag9ypWRZTgx7WmZq2QPMnFfJ/z7nnO/5nnPgUIR0kAym
        kjUprE6jUDECMb+l83d36NhNg3xDZ5sIuz1OAjdU1JHY7M7l40pXN4mrxypI3Dc6QOLi4c8E
        drvrhfhpSxGJ+51WhBuH+0jce8cswBXudh52ljkQrnV5hLizainOc7iEW/1lvX3PCFnz9X6e
        zG70CGWNNecFsqarWTJ76yRPVtRcg2STjav2UAfF0UpWlZzG6sJjEsRJjzreoRPTS05m28rJ
        bDQuKkAiCuhI8LxyCgqQmJLSVgTNP38QXPAdQfGXJh4XTCK41TFELLTk5rYKuYIFQYP7+bzq
        A4J+Rz3yqgR0LBRfe0B6C4H0IAF1+UPIGxB0OwL74KU5rwB6B9ROdfO9zKdDYOCqS+hlCb0J
        bAbr/LzVkG+5LfCyiI6G3q/1JKfxh4eX3871+tHr4eaZF3NMzOpzbKa5K4Auo2Cq6sK80Tb4
        O17I4zgARrqahRyvgBl75WyemuUsKC2J4noLEbSYf/E5zSYY6P4j8GoIeh3U3Qnn5LFg+ijm
        0BdejvpzG/hCSUs5waUlcO6slPNYC7eK7877BcPFESsyIMa46Bbjov2N/0dVIaIGBbGpenUi
        q4/QsOlheoVan6pJDDuqVTei2a97/LdrohX96DniRDSFGB/Jt10GuZRUpOkz1E4EFMEESuKe
        PI6XSpSKjExWp5XrUlWs3omWU3wmSLKx+tNhKZ2oSGGPs+wJVrdQ5VGi4Gy0e0vktXzGcSr9
        vUl0Q3klb2Ln6cyE/fG05Zh4av8yw8OkzaYbHa+VGfKQmLqoadW0tlKTowoK6/Fr29fb5qc+
        eaDHElKgWXO5zCdZG14rLbTtPRSI4/iWe6WS7TPU1E+PGWe7bPK959JWMqFKnxIqqJx46tee
        PtRzYeTN/dAZhq9PUkSsJ3R6xT/baeWBcQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsVy+t/xe7rv1kyINzjRxm5x/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2px89AKRotNj6+xWlzeNYfN
        Ysb5fUwWh6buZbRYe+Quu8WxBWIWrXuPsDsIely+dpHZY8vKm0weO2fdZffYtKqTzWPzknqP
        nTs+M3n0bVnF6PF5k1wAR5SeTVF+aUmqQkZ+cYmtUrShhZGeoaWFnpGJpZ6hsXmslZGpkr6d
        TUpqTmZZapG+XYJexqmjTxkL/nJXNGydztrA+JGzi5GTQ0LARKKlZQd7FyMXh5DAUkaJqcv7
        mbsYOYASUhIr56ZD1AhL/LnWxQZiCwk8ZZSYvSAWxGYTcJToX3qCFaRXROANs0TTvbdgg5gF
        9jFK7D+6mB2kSljAXWLtt3MsIDaLgKrEnSVHwOK8AtYSWyesYIbYIC/Rvnw72AZOARuJy+82
        sEJss5a49G4yI0S9oMTJmU9YQI5jFlCXWD9PCCTML6AlsabpOth4ZqAxzVtnM09gFJqFpGMW
        QscsJFULGJlXMYqklhbnpucWG+oVJ+YWl+al6yXn525iBMb1tmM/N+9gvLQx+BCjAAejEg/v
        B58J8UKsiWXFlbmHGCU4mJVEeJ3Ono4T4k1JrKxKLcqPLyrNSS0+xGgK9OZEZinR5Hxgyskr
        iTc0NTS3sDQ0NzY3NrNQEuftEDgYIySQnliSmp2aWpBaBNPHxMEp1cDosDanbltmwopfT92E
        c5uv5gYGuq261Xbr5kWrg1uW7rDXPD51//n5Gg95D0pdLys/7bjGcdK83bFP0r4pNj2p+PHz
        /J4nf6UF/nTHP87Kuueo8klTuK1NukJGa6mVnFeRneHckEiLleZ2Zxfcv+10Q6v09aX0Fz7b
        W15cOsFjcbAk+z6TYF+KEktxRqKhFnNRcSIAKcUIrQEDAAA=
X-CMS-MailID: 20201021214934eucas1p273214a19e3a775512ab3090d243260db
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20201021214934eucas1p273214a19e3a775512ab3090d243260db
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201021214934eucas1p273214a19e3a775512ab3090d243260db
References: <20201021214910.20001-1-l.stelmach@samsung.com>
        <CGME20201021214934eucas1p273214a19e3a775512ab3090d243260db@eucas1p2.samsung.com>
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

