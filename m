Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 192B136E82
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 10:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727197AbfFFIWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 04:22:46 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:41830 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726997AbfFFIWp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 04:22:45 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 8C0D3E5A9C41718167E7;
        Thu,  6 Jun 2019 16:22:43 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.439.0; Thu, 6 Jun 2019 16:22:35 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Zhongzhu Liu <liuzhongzhu@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 02/12] net: hns3: fix wrong size of mailbox responding data
Date:   Thu, 6 Jun 2019 16:20:57 +0800
Message-ID: <1559809267-53805-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559809267-53805-1-git-send-email-tanhuazhong@huawei.com>
References: <1559809267-53805-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhongzhu Liu <liuzhongzhu@huawei.com>

According to user manual, the maximum size of mailbox responding
data is 8 bytes, the macro HCLGE_MBX_MAX_RESP_DATA_SIZE
should be defined as 8 instead of 16.

Fixes: 9194d18b0577 ("net: hns3: fix the problem that the supported port is empty")
Signed-off-by: Zhongzhu Liu <liuzhongzhu@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
index 83e19c6..8ad5292 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
@@ -69,7 +69,7 @@ enum hclge_mbx_vlan_cfg_subcode {
 };
 
 #define HCLGE_MBX_MAX_MSG_SIZE	16
-#define HCLGE_MBX_MAX_RESP_DATA_SIZE	16
+#define HCLGE_MBX_MAX_RESP_DATA_SIZE	8
 #define HCLGE_MBX_RING_MAP_BASIC_MSG_NUM	3
 #define HCLGE_MBX_RING_NODE_VARIABLE_NUM	3
 
-- 
2.7.4

