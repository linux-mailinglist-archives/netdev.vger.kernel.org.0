Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1B751A599F
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 01:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730750AbgDKXhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 19:37:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:44768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728865AbgDKXIL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 19:08:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E36D214D8;
        Sat, 11 Apr 2020 23:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646492;
        bh=i2NOkvXgQjmy1war5M2N6tiGO8fYM47xu98GEOxJYLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HqaGo1OIXfRII1MFIEBLGgEcb57BhLi97+6QXUaFpsRHok/yloH4FlidMnq0eiiif
         QAuB4dKU5NPWShnI3GHo4+1zdc+KB+2z9h72oFdPjsCP3tBoCEBN4LJYYpS7GD0lQP
         YIS5KFYY60cpjOe02Mlyf2GKdWWbj3gods5d79yo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tzu-En Huang <tehuang@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 055/121] rtw88: 8822c: update power sequence to v16
Date:   Sat, 11 Apr 2020 19:06:00 -0400
Message-Id: <20200411230706.23855-55-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230706.23855-1-sashal@kernel.org>
References: <20200411230706.23855-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tzu-En Huang <tehuang@realtek.com>

[ Upstream commit 8299adec99b29f341f0ee4269f1ce70ca8508e78 ]

Fix switching xtal mode leads to BT USB error issue.

Signed-off-by: Tzu-En Huang <tehuang@realtek.com>
Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index 1740298368334..6087d86a60cc8 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -3544,6 +3544,11 @@ static struct rtw_pwr_seq_cmd trans_cardemu_to_act_8822c[] = {
 	 RTW_PWR_INTF_ALL_MSK,
 	 RTW_PWR_ADDR_MAC,
 	 RTW_PWR_CMD_WRITE, BIT(2), BIT(2)},
+	{0x1064,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(1), BIT(1)},
 	{0xFFFF,
 	 RTW_PWR_CUT_ALL_MSK,
 	 RTW_PWR_INTF_ALL_MSK,
-- 
2.20.1

