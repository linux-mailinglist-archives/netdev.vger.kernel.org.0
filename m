Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56BEC388774
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 08:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237896AbhESGTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 02:19:07 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:3420 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235309AbhESGTD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 02:19:03 -0400
Received: from dggems704-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FlMzM2Fr8zCtV1;
        Wed, 19 May 2021 14:14:55 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggems704-chm.china.huawei.com (10.3.19.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 14:17:41 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 19 May 2021 14:17:41 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <intel-wired-lan@lists.osuosl.org>, <lipeng321@huawei.com>,
        <tanhuazhong@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 1/5] net: e1000: remove repeated word "slot" for e1000_main.c
Date:   Wed, 19 May 2021 14:14:41 +0800
Message-ID: <1621404885-20075-2-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621404885-20075-1-git-send-email-huangguangbin2@huawei.com>
References: <1621404885-20075-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hao Chen <chenhao288@hisilicon.com>

There are double "slot" in comment, so remove the redundant one.

Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/intel/e1000/e1000_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index 042de276e632..c2a109126c27 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -5245,7 +5245,7 @@ static pci_ers_result_t e1000_io_error_detected(struct pci_dev *pdev,
 	if (!test_and_set_bit(__E1000_DISABLED, &adapter->flags))
 		pci_disable_device(pdev);
 
-	/* Request a slot slot reset. */
+	/* Request a slot reset. */
 	return PCI_ERS_RESULT_NEED_RESET;
 }
 
-- 
2.8.1

