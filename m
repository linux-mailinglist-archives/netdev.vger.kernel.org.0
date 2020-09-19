Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB1C270A14
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 04:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbgISCgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 22:36:50 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:13710 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726054AbgISCgu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 22:36:50 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id F0781500FCD49F045492;
        Sat, 19 Sep 2020 10:36:46 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Sat, 19 Sep 2020 10:36:38 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <bryan.whitehead@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: microchip: Remove set but not used variable
Date:   Sat, 19 Sep 2020 10:37:32 +0800
Message-ID: <20200919023732.23656-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/ethernet/microchip/lan743x_main.c: In function lan743x_pm_suspend:
drivers/net/ethernet/microchip/lan743x_main.c:3041:6: warning: variable ‘ret’ set but not used [-Wunused-but-set-variable]

`ret` is never used, so remove it.

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

