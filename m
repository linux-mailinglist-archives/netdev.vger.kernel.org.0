Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78C0D341610
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 07:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234074AbhCSGlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 02:41:02 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:14382 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233909AbhCSGk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 02:40:29 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4F1vNm2Vqxz90Qm;
        Fri, 19 Mar 2021 14:38:32 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Fri, 19 Mar 2021 14:40:21 +0800
From:   Daode Huang <huangdaode@huawei.com>
To:     <luobin9@huawei.com>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 2/4] net: hinic: add a blank line after declarations
Date:   Fri, 19 Mar 2021 14:36:23 +0800
Message-ID: <1616135785-122085-3-git-send-email-huangdaode@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1616135785-122085-1-git-send-email-huangdaode@huawei.com>
References: <1616135785-122085-1-git-send-email-huangdaode@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There should be a blank line after declarations, so just add it.

Signed-off-by: Daode Huang <huangdaode@huawei.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_tx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_tx.c b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
index 8da7d46..710c4ff 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_tx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
@@ -377,6 +377,7 @@ static int offload_csum(struct hinic_sq_task *task, u32 *queue_info,
 		} else if (ip.v4->version == 6) {
 			unsigned char *exthdr;
 			__be16 frag_off;
+
 			l3_type = IPV6_PKT;
 			tunnel_type = TUNNEL_UDP_CSUM;
 			exthdr = ip.hdr + sizeof(*ip.v6);
-- 
2.8.1

