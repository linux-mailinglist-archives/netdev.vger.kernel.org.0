Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE0C34E22D
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 09:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbhC3H2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 03:28:11 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:15393 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231329AbhC3H1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 03:27:45 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4F8gwV1jTdzqSKY;
        Tue, 30 Mar 2021 15:26:02 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Tue, 30 Mar 2021 15:27:37 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <jesse.brandeburg@intel.com>, <j.vosburgh@gmail.com>,
        <vfalico@gmail.com>, <andrew@lunn.ch>, <elder@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [RESEND net-next 1/4] net: i40e: remove repeated words
Date:   Tue, 30 Mar 2021 15:27:53 +0800
Message-ID: <1617089276-30268-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1617089276-30268-1-git-send-email-tanhuazhong@huawei.com>
References: <1617089276-30268-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

Remove repeated words "to" and "try".

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 0f84ed0..1555d60 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -7339,7 +7339,7 @@ static void i40e_vsi_set_default_tc_config(struct i40e_vsi *vsi)
 	qcount = min_t(int, vsi->alloc_queue_pairs,
 		       i40e_pf_get_max_q_per_tc(vsi->back));
 	for (i = 0; i < I40E_MAX_TRAFFIC_CLASS; i++) {
-		/* For the TC that is not enabled set the offset to to default
+		/* For the TC that is not enabled set the offset to default
 		 * queue and allocate one queue for the given TC.
 		 */
 		vsi->tc_config.tc_info[i].qoffset = 0;
@@ -10625,7 +10625,7 @@ static void i40e_rebuild(struct i40e_pf *pf, bool reinit, bool lock_acquired)
 	 * need to rebuild the switch model in the HW.
 	 *
 	 * If there were VEBs but the reconstitution failed, we'll try
-	 * try to recover minimal use by getting the basic PF VSI working.
+	 * to recover minimal use by getting the basic PF VSI working.
 	 */
 	if (vsi->uplink_seid != pf->mac_seid) {
 		dev_dbg(&pf->pdev->dev, "attempting to rebuild switch\n");
-- 
2.7.4

