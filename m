Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFEC8270B86
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 09:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbgISHom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 03:44:42 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:44082 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726041AbgISHom (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Sep 2020 03:44:42 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 0F4FC1C02B6EC98A76E9;
        Sat, 19 Sep 2020 15:44:38 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Sat, 19 Sep 2020
 15:44:30 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <aelior@marvell.com>, <GR-everest-linux-l2@marvell.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <ybason@marvell.com>,
        <alobakin@pm.me>, <netdev@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH net-next] net: qed: use true,false for bool variables
Date:   Sat, 19 Sep 2020 15:45:43 +0800
Message-ID: <20200919074543.3460008-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This addresses the following coccinelle warning:

drivers/net/ethernet/qlogic/qed/qed_rdma.c:1465:2-13: WARNING:
Assignment of 0/1 to bool variable
drivers/net/ethernet/qlogic/qed/qed_rdma.c:1468:2-14: WARNING:
Assignment of 0/1 to bool variable
drivers/net/ethernet/qlogic/qed/qed_rdma.c:1471:2-13: WARNING:
Assignment of 0/1 to bool variable
drivers/net/ethernet/qlogic/qed/qed_rdma.c:1472:2-14: WARNING:
Assignment of 0/1 to bool variable

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/ethernet/qlogic/qed/qed_rdma.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
index 7a1a41791f52..da864d12916b 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
@@ -1463,14 +1463,14 @@ static int qed_rdma_modify_qp(void *rdma_cxt,
 
 	switch (qp->qp_type) {
 	case QED_RDMA_QP_TYPE_XRC_INI:
-		qp->has_req = 1;
+		qp->has_req = true;
 		break;
 	case QED_RDMA_QP_TYPE_XRC_TGT:
-		qp->has_resp = 1;
+		qp->has_resp = true;
 		break;
 	default:
-		qp->has_req = 1;
-		qp->has_resp = 1;
+		qp->has_req  = true;
+		qp->has_resp = true;
 	}
 
 	if (QED_IS_IWARP_PERSONALITY(p_hwfn)) {
-- 
2.25.4

