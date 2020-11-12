Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1FFB2B0458
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 12:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728244AbgKLLvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 06:51:37 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:36634 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728039AbgKLLvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 06:51:23 -0500
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20201112115110euoutp0199ea6fd2dc9d3edac40b58cce8f881c4~GwGgIPvB20058900589euoutp01i
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 11:51:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20201112115110euoutp0199ea6fd2dc9d3edac40b58cce8f881c4~GwGgIPvB20058900589euoutp01i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1605181870;
        bh=TmlrcraEmN6nS3uE2s6DB5WImBH1BqSTgR395EFEKMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fu3mff+TZd9M68qRi3uxMwdWbsC2B6TamXCpELi3Dq54bQSVjN9VuwDBc1fRitsIE
         aQx4YlKoai5r3uPRSb5wtp9j+LT4ovPTdplu52TAiO/Vds6+wSOaErHXBaFMVuQ6Iy
         J0uVVyfuYO9ey4l1tpI2y1/grBlodjBvbe1U8hMA=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20201112115109eucas1p212b1f5d5094d1afb2986373e0efd5ac1~GwGfw3JCo2193821938eucas1p2l;
        Thu, 12 Nov 2020 11:51:09 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id BC.BF.44805.DA12DAF5; Thu, 12
        Nov 2020 11:51:09 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20201112115109eucas1p2dfd5fbfd76c28ef07f637bcc40f420cd~GwGfPgR2b1221412214eucas1p2l;
        Thu, 12 Nov 2020 11:51:09 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201112115109eusmtrp2043840acf8f77b8d0c038c27ce1c77ef~GwGfO10Fq2331023310eusmtrp2j;
        Thu, 12 Nov 2020 11:51:09 +0000 (GMT)
X-AuditID: cbfec7f4-b37ff7000000af05-6d-5fad21ad9ae4
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 71.89.21957.DA12DAF5; Thu, 12
        Nov 2020 11:51:09 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20201112115109eusmtip281f72d804fdbfbe5064e4939c54c7970~GwGfCkHW11189511895eusmtip2V;
        Thu, 12 Nov 2020 11:51:09 +0000 (GMT)
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
Subject: [PATCH v6 4/5] ARM: dts: exynos: Add Ethernet to Artik 5 board
Date:   Thu, 12 Nov 2020 12:51:05 +0100
Message-Id: <20201112115106.16224-5-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201112115106.16224-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEKsWRmVeSWpSXmKPExsWy7djP87prFdfGG3ydoG9x/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2px89AKRotNj6+xWlzeNYfN
        Ysb5fUwWh6buZbRYe+Quu8WxBWIWrXuPsDsIely+dpHZY8vKm0weO2fdZffYtKqTzWPzknqP
        nTs+M3n0bVnF6PF5k1wARxSXTUpqTmZZapG+XQJXxqmjTxkL/nJXNGydztrA+JGzi5GTQ0LA
        ROLR2+nMXYxcHEICKxglJv7/zgThfGGU2PjmMSOE85lRYtXJUywwLU0TvrNCJJYzSvQ/fsoO
        4TxnlPh/dy4TSBWbgKNE/9ITYFUiAveYJda3PwCbxSywj1Fi570pzCBVwgLuEh+WdLCC2CwC
        qhJvp/5nB7F5BawlTv9pZoPYJy/Rvnw7mM0pYCOx9OZFqBpBiZMzn4DdxC+gJbGm6TqYzQxU
        37x1NthLEgLbOSW69i9nghjkInGq+RMrhC0s8er4FnYIW0bi/875QDUcQHa9xORJZhC9PYwS
        2+b8gHraWuLOuV9sIDXMApoS63fpQ4QdJR7MmMcC0conceOtIMQJfBKTtoFCFSTMK9HRJgRR
        rSKxrn8P1EApid5XKxgnMCrNQvLMLCQPzELYtYCReRWjeGppcW56arFRXmq5XnFibnFpXrpe
        cn7uJkZgsjv97/iXHYzLX33UO8TIxMF4iFGCg1lJhFfZYU28EG9KYmVValF+fFFpTmrxIUZp
        DhYlcd6kLUApgfTEktTs1NSC1CKYLBMHp1QDk/TctPzSvsjHE9sX+frmnTbKY5h/eKntFEuv
        Z7VLvwTH8L8v0Ww0fnLf5eaCSe2hb5rTfGedyDxTlvO8fe6GvrLcNytMFhgovm6aesa6f8lK
        n+m6+QWfC243sF4+HbPtfOPdR4sKfdVW3XcoCGWZmBbesuri8/ef889NKJkgv2hPFtPFaSGh
        1zyyPFcwSrVfU/U4NLFKfqsqv29v6ymb+/9vP1yxc5HRndOhoYxb+tWECvWfHWC7FB69ueOl
        69F/fbE7vF1e7Tj6K0LIfXNhobKLRUZjwmWOySazfSWPLdw1tW/f0Qqndf84n99kOy7yfWax
        jmzeswC1df5um8LjJE6yHD3QeLDk721FeSHtH0osxRmJhlrMRcWJAEwhtzXlAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t/xe7prFdfGG7w+xmtx/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2px89AKRotNj6+xWlzeNYfN
        Ysb5fUwWh6buZbRYe+Quu8WxBWIWrXuPsDsIely+dpHZY8vKm0weO2fdZffYtKqTzWPzknqP
        nTs+M3n0bVnF6PF5k1wAR5SeTVF+aUmqQkZ+cYmtUrShhZGeoaWFnpGJpZ6hsXmslZGpkr6d
        TUpqTmZZapG+XYJexqmjTxkL/nJXNGydztrA+JGzi5GTQ0LARKJpwnfWLkYuDiGBpYwSzbd2
        s3UxcgAlpCRWzk2HqBGW+HOtiw2i5imjxJ1vi1hBEmwCjhL9S0+ANYsIvGGWaLr3lh3EYRbY
        xyix/+hidpAqYQF3iQ9LOsA6WARUJd5O/Q8W5xWwljj9p5kNYoW8RPvy7WA2p4CNxNKbF8Fq
        hIBqWmd+hqoXlDg58wkLyHXMAuoS6+cJgYT5BbQk1jRdZwGxmYHGNG+dzTyBUWgWko5ZCB2z
        kFQtYGRexSiSWlqcm55bbKhXnJhbXJqXrpecn7uJERjZ24793LyDcd6rj3qHGJk4GA8xSnAw
        K4nwKjusiRfiTUmsrEotyo8vKs1JLT7EaAr02URmKdHkfGBqySuJNzQzMDU0MbM0MLU0M1YS
        5906F6hJID2xJDU7NbUgtQimj4mDU6qBqXT75TKV7UrVaq1K7alHSp+EPu6I1HusuYNpE8cO
        hVsiTiWvNrMlvffQjmq0XNVfFvnzXrS42U+uG+/q5cUWuHKnn433PL5Y7V3eqy9bHUQrM6VF
        uGszGV5zPPmsuGCvYKnfh8R/yx4Hmzeyn11m/1/tfvWklZsUJn+b4D9zRwePtsrOjKInGZFP
        CnbPjdbfJZ9jc/HpTm2/7oI3RQZNDYt6f+f4vf3VO8Hz7YGslqwTe6aLCatVb1sus663/8vW
        +5sOzlMQ2xbeF8N8kEOv6rFtl1jBvNSqOUv2cFrJ3LRcWqSkrLB37ipt+UTNIvu0+/u+xQmL
        iR5YZPA8YH/l+YfyzNOUxMK3vNDOVJuvxFKckWioxVxUnAgA2NVdaXUDAAA=
X-CMS-MailID: 20201112115109eucas1p2dfd5fbfd76c28ef07f637bcc40f420cd
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20201112115109eucas1p2dfd5fbfd76c28ef07f637bcc40f420cd
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201112115109eucas1p2dfd5fbfd76c28ef07f637bcc40f420cd
References: <20201112115106.16224-1-l.stelmach@samsung.com>
        <CGME20201112115109eucas1p2dfd5fbfd76c28ef07f637bcc40f420cd@eucas1p2.samsung.com>
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

