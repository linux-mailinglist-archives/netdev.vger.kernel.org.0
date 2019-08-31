Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8381DA446E
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 14:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727811AbfHaM0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 08:26:04 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:33364 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726685AbfHaM0E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Aug 2019 08:26:04 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 77593A11E28F8FD4BA47;
        Sat, 31 Aug 2019 20:25:59 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.439.0; Sat, 31 Aug 2019 20:25:53 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Salil Mehta <salil.mehta@huawei.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Zhongzhu Liu <liuzhongzhu@huawei.com>,
        "Guangbin Huang" <huangguangbin2@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        "Huazhong Tan" <tanhuazhong@huawei.com>,
        Jian Shen <shenjian15@huawei.com>
CC:     YueHaibing <yuehaibing@huawei.com>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH net-next] net: hns3: remove set but not used variable 'qos'
Date:   Sat, 31 Aug 2019 12:29:11 +0000
Message-ID: <20190831122911.181336-1-yuehaibing@huawei.com>
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

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c: In function 'hclge_restore_vlan_table':
drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c:8016:18: warning:
 variable 'qos' set but not used [-Wunused-but-set-variable]

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: 70a214903da9 ("net: hns3: reduce the parameters of some functions")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index ce4b2280a8b0..2b65f2799846 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -8013,7 +8013,7 @@ static void hclge_restore_vlan_table(struct hnae3_handle *handle)
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_vport_vlan_cfg *vlan, *tmp;
 	struct hclge_dev *hdev = vport->back;
-	u16 vlan_proto, qos;
+	u16 vlan_proto;
 	u16 state, vlan_id;
 	int i;
 
@@ -8022,7 +8022,6 @@ static void hclge_restore_vlan_table(struct hnae3_handle *handle)
 		vport = &hdev->vport[i];
 		vlan_proto = vport->port_base_vlan_cfg.vlan_info.vlan_proto;
 		vlan_id = vport->port_base_vlan_cfg.vlan_info.vlan_tag;
-		qos = vport->port_base_vlan_cfg.vlan_info.qos;
 		state = vport->port_base_vlan_cfg.state;
 
 		if (state != HNAE3_PORT_BASE_VLAN_DISABLE) {



