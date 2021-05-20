Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 109D438AD0B
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 13:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236450AbhETLw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 07:52:28 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3604 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243052AbhETLtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 07:49:00 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fm7Dh1QDJzQp6W;
        Thu, 20 May 2021 19:44:04 +0800 (CST)
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 19:47:35 +0800
Received: from huawei.com (10.67.165.24) by dggpeml500012.china.huawei.com
 (7.185.36.15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 20 May
 2021 19:47:35 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <yekai13@huawei.com>
Subject: [PATCH 10/12] net/Bluetooth/msft - use the correct print format
Date:   Thu, 20 May 2021 19:44:31 +0800
Message-ID: <1621511073-47766-11-git-send-email-yekai13@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621511073-47766-1-git-send-email-yekai13@huawei.com>
References: <1621511073-47766-1-git-send-email-yekai13@huawei.com>
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

