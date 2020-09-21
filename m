Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2572272359
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 14:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgIUMHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 08:07:32 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:13749 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726341AbgIUMHb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 08:07:31 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 7CC57E8B38E3370D9808;
        Mon, 21 Sep 2020 20:07:29 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Mon, 21 Sep 2020 20:07:23 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <bryan.whitehead@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: microchip: Make `lan743x_pm_suspend` function return right value
Date:   Mon, 21 Sep 2020 20:08:18 +0800
Message-ID: <20200921120818.31182-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

drivers/net/ethernet/microchip/lan743x_main.c: In function lan743x_pm_suspend:

`ret` is set but not used. In fact, `ret` should be the right value of `lan743x_pm_suspend`
function, therefore, fix it.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/ethernet/microchip/lan743x_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index de93cc6ebc1a..56a1b5928f9a 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -3053,7 +3053,7 @@ static int lan743x_pm_suspend(struct device *dev)
 	/* Host sets PME_En, put D3hot */
 	ret = pci_prepare_to_sleep(pdev);
 
-	return 0;
+	return ret;
 }
 
 static int lan743x_pm_resume(struct device *dev)
-- 
2.17.1

