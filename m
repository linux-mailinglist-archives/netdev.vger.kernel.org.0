Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6617B362E3E
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 09:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbhDQHKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 03:10:08 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:17008 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbhDQHKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 03:10:00 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FMkdV1jBVzPrFx;
        Sat, 17 Apr 2021 15:06:22 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Sat, 17 Apr 2021 15:09:10 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 3/3] net: hns3: change the value of the SEPARATOR_VALUE macro in hclgevf_main.c
Date:   Sat, 17 Apr 2021 15:09:24 +0800
Message-ID: <1618643364-64872-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1618643364-64872-1-git-send-email-tanhuazhong@huawei.com>
References: <1618643364-64872-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The SEPARATOR_VALUE macro is used as separator when getting
the register value, but the value of this macro is different
between pf and vf, it is a bit confusing for the user, so
synchronize the value of vf with pf.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 07066c4..0db51ef1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -3646,7 +3646,7 @@ static void hclgevf_get_link_mode(struct hnae3_handle *handle,
 }
 
 #define MAX_SEPARATE_NUM	4
-#define SEPARATOR_VALUE		0xFFFFFFFF
+#define SEPARATOR_VALUE		0xFDFCFBFA
 #define REG_NUM_PER_LINE	4
 #define REG_LEN_PER_LINE	(REG_NUM_PER_LINE * sizeof(u32))
 
-- 
2.7.4

