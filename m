Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE1D38045F
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 09:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233155AbhENHfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 03:35:53 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3683 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232760AbhENHfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 03:35:50 -0400
Received: from dggems705-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FhKwX1Ry0z1BKh1;
        Fri, 14 May 2021 15:31:56 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggems705-chm.china.huawei.com (10.3.19.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 14 May 2021 15:34:37 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 14 May 2021 15:34:37 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <lipeng321@huawei.com>,
        <tanhuazhong@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 3/4] net: hns: space required before the open brace '{'
Date:   Fri, 14 May 2021 15:31:41 +0800
Message-ID: <1620977502-27236-4-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1620977502-27236-1-git-send-email-huangguangbin2@huawei.com>
References: <1620977502-27236-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

Add the space required before the open brace '{'.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c
index 4f7684a..1eaac89 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c
@@ -521,7 +521,7 @@ static phy_interface_t hns_mac_get_phy_if(struct hns_mac_cb *mac_cb)
 			reg = HNS_MAC_HILINK4_REG;
 		else
 			reg = HNS_MAC_HILINK3_REG;
-	} else{
+	} else {
 		if (!HNS_DSAF_IS_DEBUG(mac_cb->dsaf_dev) && mac_id <= 3)
 			reg = HNS_MAC_HILINK4V2_REG;
 		else
-- 
2.7.4

