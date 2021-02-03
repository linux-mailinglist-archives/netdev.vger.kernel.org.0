Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 409DB30D751
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 11:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233678AbhBCKTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 05:19:33 -0500
Received: from m12-14.163.com ([220.181.12.14]:57857 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233488AbhBCKT0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 05:19:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=OgKwUMofdoKu/7tnN0
        0hu/u8x4YRxNderZkLq1lXjs8=; b=GuOEiQJi0au7d+fxj5OKHlcHO/QJQrLta2
        wzJG8K+R2NqwDZjwRBe/G+VCygDM7OEPR46stpocLHtcRS0RCnC1x7EJ+nCiGaPG
        huEYRgVCwiREGPvl8qses9XEaPbRROpXlYdzX7FIxL/5f9qw22sItkm8yvjtywA4
        DptboA3yM=
Received: from wengjianfeng.ccdomain.com (unknown [119.137.55.230])
        by smtp10 (Coremail) with SMTP id DsCowABn_EiuPxpgsr6ljA--.2069S2;
        Wed, 03 Feb 2021 14:16:15 +0800 (CST)
From:   samirweng1979 <samirweng1979@163.com>
To:     buytenh@wantstofly.org, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: [PATCH] mwl8k: assign value when defining variables
Date:   Wed,  3 Feb 2021 14:16:25 +0800
Message-Id: <20210203061625.588-1-samirweng1979@163.com>
X-Mailer: git-send-email 2.15.0.windows.1
X-CM-TRANSID: DsCowABn_EiuPxpgsr6ljA--.2069S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtrW7KF1rJry3WFy8XrWkJFb_yoWfGFgE9r
        1IvF1agryxJr1jyr4jka13Z3sYyF15XF1ruwsFqrZxGry8Ja90vwnYkF1ftrZrCF4IvF9r
        Wrs8J3WYy3W3XjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU5VKZtUUUUU==
X-Originating-IP: [119.137.55.230]
X-CM-SenderInfo: pvdpx25zhqwiqzxzqiywtou0bp/1tbiERIusV7+2suhNQABs4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wengjianfeng <wengjianfeng@yulong.com>

define refilled and then assign value to it, which should do
that at the same time.

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


