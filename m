Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E85B2648C6
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 17:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731248AbgIJPb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 11:31:59 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:12224 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731297AbgIJP3f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 11:29:35 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 3888F1C6039C83742592;
        Thu, 10 Sep 2020 23:12:23 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Thu, 10 Sep 2020
 23:12:19 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <jeffrey.t.kirsher@intel.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <intel-wired-lan@lists.osuosl.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 3/3] i40e: Fix a kernel-doc warning in i40e_ptp.c
Date:   Thu, 10 Sep 2020 23:09:34 +0800
Message-ID: <20200910150934.34605-4-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200910150934.34605-1-wanghai38@huawei.com>
References: <20200910150934.34605-1-wanghai38@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

drivers/net/ethernet/intel/i40e/i40e_ptp.c:270: warning: Excess function parameter 'vsi' description in 'i40e_ptp_rx_hang'

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 drivers/net/ethernet/intel/i40e/i40e_ptp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ptp.c b/drivers/net/ethernet/intel/i40e/i40e_ptp.c
index ff7b19c6bc73..7a879614ca55 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ptp.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ptp.c
@@ -259,7 +259,6 @@ static u32 i40e_ptp_get_rx_events(struct i40e_pf *pf)
 /**
  * i40e_ptp_rx_hang - Detect error case when Rx timestamp registers are hung
  * @pf: The PF private data structure
- * @vsi: The VSI with the rings relevant to 1588
  *
  * This watchdog task is scheduled to detect error case where hardware has
  * dropped an Rx packet that was timestamped when the ring is full. The
-- 
2.17.1

