Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8D3525EEC0
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 17:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729075AbgIFPmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 11:42:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:49280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729039AbgIFPjI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Sep 2020 11:39:08 -0400
Received: from localhost.localdomain (unknown [194.230.155.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC6932145D;
        Sun,  6 Sep 2020 15:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599406683;
        bh=riEwVeVBIORWfwWar/cs3TjEW/xzLOlUM/PuZjLHNds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cp2jKXbMKdKR9Ttiv9ZPUR9LeIjOpqALidfU69eMvTRXTPOe3l1KKWIKYnIQgKFdp
         BVL+6DbBuhmuVJ687CTnLoJqLzIbh6r8hXYmV5ffV3v5QOskKctwcZkJv+C7rJ19G7
         DUYcftK3GJysPy0Cg494DFmscESZwsZUDOHNfYcI=
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
Subject: [PATCH v2 9/9] arm64: defconfig: Enable Samsung S3FWRN5 NFC driver
Date:   Sun,  6 Sep 2020 17:36:54 +0200
Message-Id: <20200906153654.2925-10-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200906153654.2925-1-krzk@kernel.org>
References: <20200906153654.2925-1-krzk@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable the Samsung S3FWRN5 NFC driver present in Exynos5433-based
TM2/TM2E boards.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 arch/arm64/configs/defconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index a03cefd58799..b78a14d43f3f 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -199,6 +199,9 @@ CONFIG_MAC80211_LEDS=y
 CONFIG_RFKILL=m
 CONFIG_NET_9P=y
 CONFIG_NET_9P_VIRTIO=y
+CONFIG_NFC=m
+CONFIG_NFC_NCI=m
+CONFIG_NFC_S3FWRN5_I2C=m
 CONFIG_PCI=y
 CONFIG_PCIEPORTBUS=y
 CONFIG_PCI_IOV=y
-- 
2.17.1

