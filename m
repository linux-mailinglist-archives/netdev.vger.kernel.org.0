Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4E625EEBC
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 17:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728971AbgIFPkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 11:40:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:49214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729033AbgIFPjI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Sep 2020 11:39:08 -0400
Received: from localhost.localdomain (unknown [194.230.155.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB5A9214DB;
        Sun,  6 Sep 2020 15:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599406679;
        bh=y7UdK9SwiWPgD8tbpf2MGHg1kLY8LPM78Jur53+Y3P4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ydAGqeozq8pLrEsAwdhHGujNHIzMJS3/51NYxjemPC/OBfv/HS5xdQhiW3qVQFM8i
         FaPoaUMkievY8OPwP0EdTaVrxuPPCHAihy0NsVcYlMN7YniQoXher3u/Bx2VL4dm7a
         sSbZcCuQM5Wzr+ZjjPZFaHi7sVP5pIX4gLN28kKg=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Olof Johansson <olof@lixom.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-nfc@lists.01.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 8/9] arm64: dts: exynos: Use newer S3FWRN5 GPIO properties in Exynos5433 TM2
Date:   Sun,  6 Sep 2020 17:36:53 +0200
Message-Id: <20200906153654.2925-9-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200906153654.2925-1-krzk@kernel.org>
References: <20200906153654.2925-1-krzk@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since "s3fwrn5" is not a valid vendor prefix, use new GPIO properties
instead of the deprecated.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
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

