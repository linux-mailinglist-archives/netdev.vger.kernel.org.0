Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7413817FD
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 12:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232883AbhEOK60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 06:58:26 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3552 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233202AbhEOKz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 06:55:57 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fj2Jn73GdzsRJc;
        Sat, 15 May 2021 18:51:53 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Sat, 15 May 2021 18:54:28 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Shen <shenyang39@huawei.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 24/34] net: ath: ath5k: Fix wrong function name in comments
Date:   Sat, 15 May 2021 18:53:49 +0800
Message-ID: <1621076039-53986-25-git-send-email-shenyang39@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1621076039-53986-1-git-send-email-shenyang39@huawei.com>
References: <1621076039-53986-1-git-send-email-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/ath/ath5k/pcu.c:865: warning: expecting prototype for at5k_hw_stop_rx_pcu(). Prototype was for ath5k_hw_stop_rx_pcu() instead

Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Nick Kossifidis <mickflemm@gmail.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Yang Shen <shenyang39@huawei.com>
---
 drivers/net/wireless/ath/ath5k/pcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index f2db7cf..3f4ce4e 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -855,7 +855,7 @@ ath5k_hw_start_rx_pcu(struct ath5k_hw *ah)
 }
 
 /**
- * at5k_hw_stop_rx_pcu() - Stop RX engine
+ * ath5k_hw_stop_rx_pcu() - Stop RX engine
  * @ah: The &struct ath5k_hw
  *
  * Stops RX engine on PCU
-- 
2.7.4

