Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C27EB37F310
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 08:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbhEMGbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 02:31:11 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:2468 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbhEMGbC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 02:31:02 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FghXD4gRjzBv02;
        Thu, 13 May 2021 14:27:08 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Thu, 13 May 2021 14:29:48 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <luobin9@huawei.com>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 4/4] net: hinic: fix misspelled "acessing"
Date:   Thu, 13 May 2021 14:26:53 +0800
Message-ID: <1620887213-49364-5-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1620887213-49364-1-git-send-email-huangguangbin2@huawei.com>
References: <1620887213-49364-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The word "acessing" is misspelled, so fix it.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_hw_if.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_if.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_if.c
index cab38ff0713c..55b327eebe64 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_if.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_if.c
@@ -395,7 +395,7 @@ static void __print_selftest_reg(struct hinic_hwif *hwif)
 /**
  * hinic_init_hwif - initialize the hw interface
  * @hwif: the HW interface of a pci function device
- * @pdev: the pci device for acessing PCI resources
+ * @pdev: the pci device for accessing PCI resources
  *
  * Return 0 - Success, negative - Failure
  **/
-- 
2.8.1

