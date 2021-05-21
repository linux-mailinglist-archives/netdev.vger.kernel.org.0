Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1AEC38BEE6
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 08:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237048AbhEUGEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 02:04:34 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:3641 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231280AbhEUGEU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 02:04:20 -0400
Received: from dggems701-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FmbYw4T0VzmXpH;
        Fri, 21 May 2021 14:00:36 +0800 (CST)
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggems701-chm.china.huawei.com (10.3.19.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 21 May 2021 14:02:52 +0800
Received: from huawei.com (10.67.165.24) by dggpeml500012.china.huawei.com
 (7.185.36.15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 21 May
 2021 14:02:52 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <yekai13@huawei.com>
Subject: [PATCH v2 10/12] net/Bluetooth/msft - use the correct print format
Date:   Fri, 21 May 2021 13:59:46 +0800
Message-ID: <1621576788-48092-11-git-send-email-yekai13@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621576788-48092-1-git-send-email-yekai13@huawei.com>
References: <1621576788-48092-1-git-send-email-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500012.china.huawei.com (7.185.36.15)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to Documentation/core-api/printk-formats.rst,
Use the correct print format. Printing an unsigned int value should use %u
instead of %d. Otherwise printk() might end up displaying negative numbers.

Signed-off-by: Kai Ye <yekai13@huawei.com>
---
 net/bluetooth/msft.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
index 47b104f..8d2310e 100644
--- a/net/bluetooth/msft.c
+++ b/net/bluetooth/msft.c
@@ -308,7 +308,7 @@ static void msft_le_monitor_advertisement_cb(struct hci_dev *hdev,
 
 	monitor = idr_find(&hdev->adv_monitors_idr, msft->pending_add_handle);
 	if (!monitor) {
-		bt_dev_err(hdev, "msft add advmon: monitor %d is not found!",
+		bt_dev_err(hdev, "msft add advmon: monitor %u is not found!",
 			   msft->pending_add_handle);
 		status = HCI_ERROR_UNSPECIFIED;
 		goto unlock;
-- 
2.8.1

