Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB6CD264F93
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbgIJTqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:46:54 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:12226 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730920AbgIJP3e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 11:29:34 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 42A4D83AE29647AE89B5;
        Thu, 10 Sep 2020 23:12:23 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Thu, 10 Sep 2020
 23:12:18 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <jeffrey.t.kirsher@intel.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <intel-wired-lan@lists.osuosl.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 2/3] i40e: Fix some kernel-doc warnings in i40e_common.c
Date:   Thu, 10 Sep 2020 23:09:33 +0800
Message-ID: <20200910150934.34605-3-wanghai38@huawei.com>
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

drivers/net/ethernet/intel/i40e/i40e_common.c:3778: warning: Excess function parameter 'buff' description in 'i40e_aq_start_lldp'
drivers/net/ethernet/intel/i40e/i40e_common.c:3778: warning: Excess function parameter 'buff_size' description in 'i40e_aq_start_lldp'

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 drivers/net/ethernet/intel/i40e/i40e_common.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_common.c b/drivers/net/ethernet/intel/i40e/i40e_common.c
index 6ab52cbd697a..361329874d98 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_common.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_common.c
@@ -3766,9 +3766,7 @@ i40e_status i40e_aq_stop_lldp(struct i40e_hw *hw, bool shutdown_agent,
 /**
  * i40e_aq_start_lldp
  * @hw: pointer to the hw struct
- * @buff: buffer for result
  * @persist: True if start of LLDP should be persistent across power cycles
- * @buff_size: buffer size
  * @cmd_details: pointer to command details structure or NULL
  *
  * Start the embedded LLDP Agent on all ports.
-- 
2.17.1

