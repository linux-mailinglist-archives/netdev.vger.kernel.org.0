Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12678251DC4
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 19:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgHYRDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 13:03:37 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:59727 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726374AbgHYRDZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 13:03:25 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200825170323euoutp019ca0e6fcd23b15bd59a2fdc09e9bf441~ukZj4lEaW1623416234euoutp01B
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 17:03:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200825170323euoutp019ca0e6fcd23b15bd59a2fdc09e9bf441~ukZj4lEaW1623416234euoutp01B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1598375003;
        bh=c1xNb/pFGdxwXKnqMPpA0fdme2+4v6JpY615L+uXNW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TLuTPamPHInGpe3v9TmdQFWPZzH5Hz0yFjkKUsM9Wwvc70L5sTbtenke0kpF4EqO2
         bQL/y64OrekAdnkxkcTH7OPtgFNYJaN5xul7nXeIYgB+1ngoMKodEHNvkur/ixhXJN
         hwzmKrZuTmhRmjaHM7ywjESCqocb0GPDHFSaSmU8=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200825170323eucas1p2959dc55b067a1c10dc9ac36359f56899~ukZjpZVm_0940209402eucas1p2C;
        Tue, 25 Aug 2020 17:03:23 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 76.D9.05997.B54454F5; Tue, 25
        Aug 2020 18:03:23 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200825170323eucas1p2d299a6ac365e6a70d802757d439bc77c~ukZjQBgQN2587825878eucas1p2B;
        Tue, 25 Aug 2020 17:03:23 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200825170323eusmtrp1ec4bacb6a7f406b1a4dd9451bbb927cf~ukZjN9-UC0199301993eusmtrp1D;
        Tue, 25 Aug 2020 17:03:23 +0000 (GMT)
X-AuditID: cbfec7f4-677ff7000000176d-fa-5f45445b4e27
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 02.31.06314.B54454F5; Tue, 25
        Aug 2020 18:03:23 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200825170323eusmtip26e36ae4d86941194908096ef94cdf481~ukZjDv7eW2265922659eusmtip2v;
        Tue, 25 Aug 2020 17:03:23 +0000 (GMT)
From:   =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     m.szyprowski@samsung.com, b.zolnierkie@samsung.com,
        =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
Subject: [PATCH 2/3] ARM: dts: Add ethernet
Date:   Tue, 25 Aug 2020 19:03:10 +0200
Message-Id: <20200825170311.24886-2-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200825170311.24886-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0iTYRTHefZe9m45e5ySJyuFZURW2o14QSktpX2SKPKDXWzlm0pOZVNL
        IxXNvOZEqbyRZpqXzHuzhmat5YXhZgqmUVJpZpaCaKQSlfOd5Lf/ec7v/z/nwMMQ0teUExMW
        Ec2pIhThMlpMarsWTbtP+/oF7XlZvpVtKmig2BLzDZItNZgoVjP2nWDN5kYh26/NodgRfTVi
        m8eGKHZQV0KzBebnAlZ/uwOxjw0fhGxX2QY2tcMg9LaVDw69IeStNSMCeXNtBi1vqUiU57TW
        Ivlcs/NxOlDsFcyFh8VyKo9D58WhmS+W6Kg68dVeUxqVhHqYTCRiAB+AB4upKBOJGSmuRnDn
        jYngi3kEne0aIV/MIej91CZYteQ/arJSVQgWRkqtxVcEf5sMKxSNfUBT2UNZGg44iYCJLCOy
        NAgcA9nP9LRF2+OdMFOfRVk0ibeBrraFtGgJ9gSzqV/Ij3OBtKq2FV6EveCH4QnBM3bQWzi+
        wq/HblCX/Jbk810g5UnxykaAZ4XQMlFM8kG+sJBSaQ21h6nuVqveDMb87GWGWdaJkJ93kPdm
        I9CWLFi9nvDetERbGALvgAadB//sA9OdkwLeagvD03b8CraQp71L8M8SSL8p5WlXqNe0WwOd
        4NZUNcpFsqI1xxStOaDo/6wyRNQiRy5GrQzh1PsiuCvuaoVSHRMR4n4xUtmMlj+X8U/3/FOk
        +31BjzCDZDaSMtovSEopYtVxSj0ChpA5SI70Gc9JJcGKuHhOFRmkignn1Hq0iSFljpL95d/O
        SnGIIpq7zHFRnGq1K2BETkko2OfjniF/t1Sbzsh10oe4RnR08Gf4YX+ibOjkZ7sXFcli5cDi
        Rro6Y7ZhegaT1xJyWweyieEzXxLw9fvMbIbC6dSlJbdjje98sjSq8V1t6eOL508IXFO3/JqK
        b+9yHjg+Sk0GuGu9S0XbM+v6AtimR5dejY7rzpmNgvl7hQV9gTJSHarY60ao1Ip/GXAlYFgD
        AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t/xe7rRLq7xBtMaeSw2zljPajHnfAuL
        xfwj51gt+h+/ZrY4f34Du8WFbX2sFjcPrWC02PT4GqvF5V1z2CxmnN/HZHFo6l5Gi7VH7rJb
        HFsgZtG69wi7A5/H5WsXmT22rLzJ5LFpVSebx+Yl9R59W1YxenzeJBfAFqVnU5RfWpKqkJFf
        XGKrFG1oYaRnaGmhZ2RiqWdobB5rZWSqpG9nk5Kak1mWWqRvl6CX0XXgF1vBGq6Kk+faWRsY
        T3B0MXJySAiYSExevZG5i5GLQ0hgKaPE7I9tbF2MHEAJKYmVc9MhaoQl/lzrYoOoecoo8aR5
        HjtIgk3AUaJ/6QlWkISIQBezxJGLP9lAEswC5RKXZj0HKxIW0JZ4t66bFcRmEVCV2LVqMwuI
        zStgLXH+3AV2iA3yEu3Lt4P1cgrYSLw5spUZxBYCquk5eI0Jol5Q4uTMJywgxzELqEusnycE
        EuYX0JJY03SdBWKtvETz1tnMExiFZiHpmIXQMQtJ1QJG5lWMIqmlxbnpucWGesWJucWleel6
        yfm5mxiBUbrt2M/NOxgvbQw+xCjAwajEw7uAzTVeiDWxrLgy9xCjBAezkgiv09nTcUK8KYmV
        ValF+fFFpTmpxYcYTYHenMgsJZqcD0wgeSXxhqaG5haWhubG5sZmFkrivB0CB2OEBNITS1Kz
        U1MLUotg+pg4OKUaGG2dns58t3vS/Wy/H79/vr83kz2p8+PG8y8WvutuFnS0WXriUtPii44L
        M4+KZm1p84uqzGv74yFi2+h+plpBJ5/vzYudNg2zVa4/vPo4uWLLKsufqsrJwoduT3f3nXEo
        613kufhvC1WfpG2OF1wZJM0zu+Hz8TTzyH05lxX7Z5Tv4md0fKTsdEqJpTgj0VCLuag4EQDe
        Hznh6AIAAA==
X-CMS-MailID: 20200825170323eucas1p2d299a6ac365e6a70d802757d439bc77c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200825170323eucas1p2d299a6ac365e6a70d802757d439bc77c
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200825170323eucas1p2d299a6ac365e6a70d802757d439bc77c
References: <20200825170311.24886-1-l.stelmach@samsung.com>
        <CGME20200825170323eucas1p2d299a6ac365e6a70d802757d439bc77c@eucas1p2.samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add node for ax88796c ethernet chip.

Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
---
 arch/arm/boot/dts/exynos3250-artik5-eval.dts | 21 ++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250-artik5-eval.dts b/arch/arm/boot/dts/exynos3250-artik5-eval.dts
index 20446a846a98..44151a2cb35d 100644
--- a/arch/arm/boot/dts/exynos3250-artik5-eval.dts
+++ b/arch/arm/boot/dts/exynos3250-artik5-eval.dts
@@ -37,3 +37,24 @@ &mshc_2 {
 &serial_2 {
 	status = "okay";
 };
+
+&spi_0 {
+		status = "okay";
+		cs-gpios = <&gpx3 4 GPIO_ACTIVE_LOW>, <0>;
+
+		assigned-clocks        = <&cmu CLK_MOUT_MPLL>, <&cmu CLK_DIV_MPLL_PRE>, <&cmu CLK_MOUT_SPI0>,    <&cmu CLK_DIV_SPI0>,  <&cmu CLK_DIV_SPI0_PRE>, <&cmu CLK_SCLK_SPI0>;
+		assigned-clock-parents = <&cmu CLK_FOUT_MPLL>, <&cmu CLK_MOUT_MPLL>,    <&cmu CLK_DIV_MPLL_PRE>, <&cmu CLK_MOUT_SPI0>, <&cmu CLK_DIV_SPI0>,     <&cmu CLK_DIV_SPI0_PRE>;
+
+		ax88796c@0 {
+			compatible = "asix,ax88796c";
+			interrupt-parent = <&gpx2>;
+			interrupts = <0 IRQ_TYPE_LEVEL_LOW>;
+			spi-max-frequency = <40000000>;
+			reg = <0x0>;
+			reset-gpios = <&gpe0 2 GPIO_ACTIVE_LOW>;
+			controller-data {
+				samsung,spi-feedback-delay = <2>;
+				samsung,spi-chip-select-mode;
+		};
+	};
+};
-- 
2.26.2

