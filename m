Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DDED2D5CB6
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 15:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389900AbgLJOCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 09:02:45 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:9865 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389750AbgLJOCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 09:02:25 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CsFvB2dNNz7C5G;
        Thu, 10 Dec 2020 22:01:10 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Thu, 10 Dec 2020 22:01:36 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <kvalo@codeaurora.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH wireless -next] wireless/ath10k: simplify the return expression of ath10k_ahb_chip_reset()
Date:   Thu, 10 Dec 2020 22:02:04 +0800
Message-ID: <20201210140204.1774-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the return expression.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/wireless/ath/ath10k/ahb.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ahb.c b/drivers/net/wireless/ath/ath10k/ahb.c
index 05a61975c83f..0ba31c0bbd24 100644
--- a/drivers/net/wireless/ath/ath10k/ahb.c
+++ b/drivers/net/wireless/ath/ath10k/ahb.c
@@ -598,16 +598,10 @@ static int ath10k_ahb_prepare_device(struct ath10k *ar)
 
 static int ath10k_ahb_chip_reset(struct ath10k *ar)
 {
-	int ret;
-
 	ath10k_ahb_halt_chip(ar);
 	ath10k_ahb_clock_disable(ar);
 
-	ret = ath10k_ahb_prepare_device(ar);
-	if (ret)
-		return ret;
-
-	return 0;
+	return ath10k_ahb_prepare_device(ar);
 }
 
 static int ath10k_ahb_wake_target_cpu(struct ath10k *ar)
-- 
2.22.0

