Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFD0D26FDDE
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 15:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbgIRNJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 09:09:58 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:59950 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726406AbgIRNJ6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 09:09:58 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 6A92C99AE582B3C564F1;
        Fri, 18 Sep 2020 21:09:54 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Fri, 18 Sep 2020
 21:09:46 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <tanhuazhong@huawei.com>,
        <liaoguojia@huawei.com>, <liuyonglong@huawei.com>,
        <linyunsheng@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] net: hns3: Supply missing hclge_dcb.h include file
Date:   Fri, 18 Sep 2020 21:06:53 +0800
Message-ID: <20200918130653.20064-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the header file containing a function's prototype isn't included by
the sourcefile containing the associated function, the build system
complains of missing prototypes.

Fixes the following W=1 kernel build warning(s):

drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c:453:6: warning: no previous prototype for ‘hclge_dcb_ops_set’ [-Wmissing-prototypes]

Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
index d6c3952aba04..f990f6915226 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
@@ -2,6 +2,7 @@
 // Copyright (c) 2016-2017 Hisilicon Limited.
 
 #include "hclge_main.h"
+#include "hclge_dcb.h"
 #include "hclge_tm.h"
 #include "hnae3.h"
 
-- 
2.17.1

