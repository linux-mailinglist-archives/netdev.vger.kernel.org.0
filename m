Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE4C01299D1
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 19:23:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbfLWSXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 13:23:24 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:16352 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726756AbfLWSXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 13:23:23 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBNIKp2s017902;
        Mon, 23 Dec 2019 10:23:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=YQSsCillRo4bL3xzy3Be6sNMMOsbDuMtZwfk5UYGc78=;
 b=lAzctSp79Wu8NpH+g5qhf4To+Z7m11u6GXtWxLEg6fRRvqOgGr+iYJxq85kUzB/lJ3pt
 hLqPD/JJ1AzEjp1MQp2OOWoxhzcwq24RgFFsFzHy+Axfzp9PfqlSMaIDtneL6DedGUpW
 0m9wfrbp3BSMHMUYLb+59iNA8MzU2KnpI5QZmhqCUvKz2dFH+TXFT1mltiugmGY2EKil
 /bgnE8MBK+deejs25qMhgwkMcaKIQbf5ZC4mO+n51H6vbNshpSULfkTxSqlCRp5xluWN
 ubm9NFXv/sXlKvJHbf+kW0DdVFWjSwp2oaUNfxIw/0olWEjgZRwWRe9/G1A1AU9gJVNX hA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2x1kssdmr9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 23 Dec 2019 10:23:21 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Dec
 2019 10:23:19 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 23 Dec 2019 10:23:19 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 117263F703F;
        Mon, 23 Dec 2019 10:23:20 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id xBNINJcA003968;
        Mon, 23 Dec 2019 10:23:19 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id xBNINJvr003959;
        Mon, 23 Dec 2019 10:23:19 -0800
From:   Manish Chopra <manishc@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <skalluru@marvell.com>
Subject: [PATCH net 1/2] bnx2x: Use appropriate define for vlan credit
Date:   Mon, 23 Dec 2019 10:23:08 -0800
Message-ID: <20191223182309.3919-2-manishc@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20191223182309.3919-1-manishc@marvell.com>
References: <20191223182309.3919-1-manishc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-23_07:2019-12-23,2019-12-23 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Although it has same value as MAX_MAC_CREDIT_E2,
use MAX_VLAN_CREDIT_E2 appropriately.

Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.h
index 7a6e82db4231..ed237854939a 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.h
@@ -1537,7 +1537,7 @@ void bnx2x_get_rss_ind_table(struct bnx2x_rss_config_obj *rss_obj,
 	 func_num + GET_NUM_VFS_PER_PF(bp) * VF_MAC_CREDIT_CNT)
 
 #define PF_VLAN_CREDIT_E2(bp, func_num)					 \
-	((MAX_MAC_CREDIT_E2 - GET_NUM_VFS_PER_PATH(bp) * VF_VLAN_CREDIT_CNT) / \
+	((MAX_VLAN_CREDIT_E2 - GET_NUM_VFS_PER_PATH(bp) * VF_VLAN_CREDIT_CNT) /\
 	 func_num + GET_NUM_VFS_PER_PF(bp) * VF_VLAN_CREDIT_CNT)
 
 #endif /* BNX2X_SP_VERBS */
-- 
2.18.1

