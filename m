Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8A8BB591
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 15:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730714AbfIWNjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 09:39:49 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2769 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725782AbfIWNjt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Sep 2019 09:39:49 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 9187B606AAEE99F43F87;
        Mon, 23 Sep 2019 21:39:44 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.439.0; Mon, 23 Sep 2019 21:39:37 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <ath9k-devel@qca.qualcomm.com>, <kvalo@codeaurora.org>,
        <afaerber@suse.de>, <manivannan.sadhasivam@linaro.org>
CC:     YueHaibing <yuehaibing@huawei.com>,
        <linux-wireless@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH] ath9k: remove unused including <linux/version.h>
Date:   Mon, 23 Sep 2019 13:56:32 +0000
Message-ID: <20190923135632.145051-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove including <linux/version.h> that don't need it.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/ath/ath9k/ath9k_pci_owl_loader.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k_pci_owl_loader.c b/drivers/net/wireless/ath/ath9k/ath9k_pci_owl_loader.c
index 159490f5a111..956fa7828d0c 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k_pci_owl_loader.c
+++ b/drivers/net/wireless/ath/ath9k/ath9k_pci_owl_loader.c
@@ -12,7 +12,6 @@
  * initialize the chip when the user-space is ready to extract the init code.
  */
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/completion.h>
 #include <linux/etherdevice.h>
 #include <linux/firmware.h>



