Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E308291A17
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 21:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729436AbgJRTV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 15:21:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:33556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729400AbgJRTV2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 15:21:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3B3D222EA;
        Sun, 18 Oct 2020 19:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048887;
        bh=W7djoAKVSL07Q8YxcMiprpi1nhnt1rRDRNxZOdBdfkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WmFPeV8BbuRbYpEgvg4HN661eWaqrEm0AV/B8YZaevv1SMvl1r8Vwcu1VU2YIEMbb
         JNLN20ZatvK5jByTUPtVsGa7gQ+Y2t3BxdpmRdNpJA35ykk7Fuw16qOfoZuMwBOVd8
         9akXmyKt44fk6LwT3bbG5dZP2IhM2OIPlNCv4iW0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tzu-En Huang <tehuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 050/101] rtw88: increse the size of rx buffer size
Date:   Sun, 18 Oct 2020 15:19:35 -0400
Message-Id: <20201018192026.4053674-50-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192026.4053674-1-sashal@kernel.org>
References: <20201018192026.4053674-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tzu-En Huang <tehuang@realtek.com>

[ Upstream commit ee755732b7a16af018daa77d9562d2493fb7092f ]

The vht capability of MAX_MPDU_LENGTH is 11454 in rtw88; however, the rx
buffer size for each packet is 8192. When receiving packets that are
larger than rx buffer size, it will leads to rx buffer ring overflow.

Signed-off-by: Tzu-En Huang <tehuang@realtek.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200925061219.23754-2-tehuang@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/pci.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.h b/drivers/net/wireless/realtek/rtw88/pci.h
index 024c2bc275cbe..ca17aa9cf7dc7 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.h
+++ b/drivers/net/wireless/realtek/rtw88/pci.h
@@ -9,8 +9,8 @@
 #define RTK_BEQ_TX_DESC_NUM	256
 
 #define RTK_MAX_RX_DESC_NUM	512
-/* 8K + rx desc size */
-#define RTK_PCI_RX_BUF_SIZE	(8192 + 24)
+/* 11K + rx desc size */
+#define RTK_PCI_RX_BUF_SIZE	(11454 + 24)
 
 #define RTK_PCI_CTRL		0x300
 #define BIT_RST_TRXDMA_INTF	BIT(20)
-- 
2.25.1

