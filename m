Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE76CEB18B
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 14:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727714AbfJaNuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 09:50:24 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:59574 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727605AbfJaNuX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 09:50:23 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 2045C2AA6CE676CDE106;
        Thu, 31 Oct 2019 21:50:21 +0800 (CST)
Received: from linux-ibm.site (10.175.102.37) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Thu, 31 Oct 2019 21:50:13 +0800
From:   zhong jiang <zhongjiang@huawei.com>
To:     <kvalo@codeaurora.org>, <stas.yakovlev@gmail.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <zhongjiang@huawei.com>
Subject: [PATCH 1/3] ipw2x00: Remove redundant variable "rc"
Date:   Thu, 31 Oct 2019 21:46:18 +0800
Message-ID: <1572529580-26594-2-git-send-email-zhongjiang@huawei.com>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1572529580-26594-1-git-send-email-zhongjiang@huawei.com>
References: <1572529580-26594-1-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

local variable "rc" is not used. hence it is safe to remove and
just return 0.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 drivers/net/wireless/intel/ipw2x00/libipw_rx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/libipw_rx.c b/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
index 34cfd81..df0f37e4 100644
--- a/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
+++ b/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
@@ -1005,7 +1005,6 @@ static int libipw_qos_convert_ac_to_parameters(struct
 						  libipw_qos_parameters
 						  *qos_param)
 {
-	int rc = 0;
 	int i;
 	struct libipw_qos_ac_parameter *ac_params;
 	u32 txop;
@@ -1030,7 +1029,8 @@ static int libipw_qos_convert_ac_to_parameters(struct
 		txop = le16_to_cpu(ac_params->tx_op_limit) * 32;
 		qos_param->tx_op_limit[i] = cpu_to_le16(txop);
 	}
-	return rc;
+
+	return 0;
 }
 
 /*
-- 
1.7.12.4

