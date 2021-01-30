Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3E94309400
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 11:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbhA3KGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 05:06:50 -0500
Received: from m12-11.163.com ([220.181.12.11]:58896 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232138AbhA3KGG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Jan 2021 05:06:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=xiuAmuPFP+fXOtCnvS
        Laeyxr7GySFEfy9hd9zq0av8g=; b=IwFIzbbVr3kwmRREuFvbtvx5o3T8VgLA4E
        pCqTHp8EW8FclPxe8GBPP8yfTbhCpSlFWBs2iWfhkeferURW+owzrCIbAK6diskm
        rpvUa/yemmyNBDA0AX2Mea4ruc7oKhbt5ClZFeffMl/FC4bzmyOiSXbf1GP86NSu
        3HPZjUdfw=
Received: from wengjianfeng.ccdomain.com (unknown [119.137.55.243])
        by smtp7 (Coremail) with SMTP id C8CowAC3rpZCChVgH7E8LQ--.28897S2;
        Sat, 30 Jan 2021 15:26:59 +0800 (CST)
From:   samirweng1979 <samirweng1979@163.com>
To:     buytenh@wantstofly.org, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: [PATCH] mwl8k: assign value when defining variables
Date:   Sat, 30 Jan 2021 15:27:08 +0800
Message-Id: <20210130072708.12592-1-samirweng1979@163.com>
X-Mailer: git-send-email 2.15.0.windows.1
X-CM-TRANSID: C8CowAC3rpZCChVgH7E8LQ--.28897S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtrW7KF48tr1rJrWUXw1fWFg_yoWfGrgE9r
        1IvF1agryxJr1jyr4jka13Z3sYyF15XF1ruwsFqrZxGry8Ja90v3ZYkF1ftrZrCF1IvF9r
        Wrs8J3WYy3W3XjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU5yGQDUUUUU==
X-Originating-IP: [119.137.55.243]
X-CM-SenderInfo: pvdpx25zhqwiqzxzqiywtou0bp/1tbiLwMqsVUMW-1YogAAsy
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wengjianfeng <wengjianfeng@yulong.com>

define refilled and then assign value to it, which should do
at the same time.

Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
---
 drivers/net/wireless/marvell/mwl8k.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwl8k.c b/drivers/net/wireless/marvell/mwl8k.c
index abf3b02..435ef77 100644
--- a/drivers/net/wireless/marvell/mwl8k.c
+++ b/drivers/net/wireless/marvell/mwl8k.c
@@ -1208,9 +1208,8 @@ static int rxq_refill(struct ieee80211_hw *hw, int index, int limit)
 {
 	struct mwl8k_priv *priv = hw->priv;
 	struct mwl8k_rx_queue *rxq = priv->rxq + index;
-	int refilled;
+	int refilled = 0;
 
-	refilled = 0;
 	while (rxq->rxd_count < MWL8K_RX_DESCS && limit--) {
 		struct sk_buff *skb;
 		dma_addr_t addr;
-- 
1.9.1

