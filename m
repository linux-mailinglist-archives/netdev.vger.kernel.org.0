Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0291C1B5588
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 09:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbgDWHVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 03:21:33 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2876 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725562AbgDWHVc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Apr 2020 03:21:32 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id E36214EA4ACBEAE2ECCD;
        Thu, 23 Apr 2020 15:21:30 +0800 (CST)
Received: from linux-lmwb.huawei.com (10.175.103.112) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Thu, 23 Apr 2020 15:21:21 +0800
From:   Zou Wei <zou_wei@huawei.com>
To:     <aelior@marvell.com>, <GR-everest-linux-l2@marvell.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Zou Wei <zou_wei@huawei.com>
Subject: [PATCH -next] qed: Make ll2_cbs static
Date:   Thu, 23 Apr 2020 15:27:40 +0800
Message-ID: <1587626860-97801-1-git-send-email-zou_wei@huawei.com>
X-Mailer: git-send-email 2.6.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.103.112]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following sparse warning:

drivers/net/ethernet/qlogic/qed/qed_ll2.c:2334:20: warning: symbol 'll2_cbs'
was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
---
 drivers/net/ethernet/qlogic/qed/qed_ll2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_ll2.c b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
index 037e597..4afd857 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_ll2.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
@@ -2331,7 +2331,7 @@ static void qed_ll2_register_cb_ops(struct qed_dev *cdev,
 	cdev->ll2->cb_cookie = cookie;
 }
 
-struct qed_ll2_cbs ll2_cbs = {
+static struct qed_ll2_cbs ll2_cbs = {
 	.rx_comp_cb = &qed_ll2b_complete_rx_packet,
 	.rx_release_cb = &qed_ll2b_release_rx_packet,
 	.tx_comp_cb = &qed_ll2b_complete_tx_packet,
-- 
2.6.2

