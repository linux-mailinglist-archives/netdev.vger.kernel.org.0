Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A217125684A
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 16:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728298AbgH2OaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Aug 2020 10:30:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:56432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728276AbgH2OaJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Aug 2020 10:30:09 -0400
Received: from localhost.localdomain (unknown [194.230.155.216])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15BED20791;
        Sat, 29 Aug 2020 14:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598711408;
        bh=CP8KqP43wOtJ8WcHsmx6axWh4HzD/Tid44BJ/kee/5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nwBwyz80yplEZECMeZEv+mE9/bwYZaDZvhvIGUEh3Vlzdyxlg9QCDBbpHbse+7dCV
         +6An3jubPj37vyZnEeHzZamA76+vqIdAwtenB6WHgn1PnSLlGgCoH+cY9HRsYzoxLx
         ITu9WK2q2bie7ZBh8IIR0PHlFt1xylM44H6byLZQ=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nfc@lists.01.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Inki Dae <inki.dae@samsung.com>
Subject: [PATCH 4/4] arm64: dts: exynos: Use newer S3FWRN5 GPIO properties in Exynos5433 TM2
Date:   Sat, 29 Aug 2020 16:29:48 +0200
Message-Id: <20200829142948.32365-4-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200829142948.32365-1-krzk@kernel.org>
References: <20200829142948.32365-1-krzk@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since "s3fwrn5" is not a valid vendor prefix, use new GPIO properties
instead of the deprecated.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 arch/arm64/boot/dts/exynos/exynos5433-tm2-common.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/exynos/exynos5433-tm2-common.dtsi b/arch/arm64/boot/dts/exynos/exynos5433-tm2-common.dtsi
index 250fc01de78d..24aab3ea3f52 100644
--- a/arch/arm64/boot/dts/exynos/exynos5433-tm2-common.dtsi
+++ b/arch/arm64/boot/dts/exynos/exynos5433-tm2-common.dtsi
@@ -795,8 +795,8 @@
 		reg = <0x27>;
 		interrupt-parent = <&gpa1>;
 		interrupts = <3 IRQ_TYPE_LEVEL_HIGH>;
-		s3fwrn5,en-gpios = <&gpf1 4 GPIO_ACTIVE_HIGH>;
-		s3fwrn5,fw-gpios = <&gpj0 2 GPIO_ACTIVE_HIGH>;
+		en-gpios = <&gpf1 4 GPIO_ACTIVE_HIGH>;
+		wake-gpios = <&gpj0 2 GPIO_ACTIVE_HIGH>;
 	};
 };
 
-- 
2.17.1

