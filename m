Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DFCF18DE57
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 07:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728118AbgCUG6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 02:58:36 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:33140 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728005AbgCUG6g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Mar 2020 02:58:36 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 928C2BBD596AE1935CE6;
        Sat, 21 Mar 2020 14:58:20 +0800 (CST)
Received: from localhost.localdomain (10.175.34.53) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Sat, 21 Mar 2020 14:57:24 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <luobin9@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>
Subject: [PATCH net 5/5] hinic: fix wrong value of MIN_SKB_LEN
Date:   Fri, 20 Mar 2020 23:13:20 +0000
Message-ID: <20200320231320.1001-6-luobin9@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200320231320.1001-1-luobin9@huawei.com>
References: <20200320231320.1001-1-luobin9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.34.53]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

the minimum value of skb len that hw supports is 32 rather than 17

Signed-off-by: Luo bin <luobin9@huawei.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_tx.c b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
index cabcc9019ee4..8993f5b07059 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_tx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
@@ -45,7 +45,7 @@
 
 #define HW_CONS_IDX(sq)                 be16_to_cpu(*(u16 *)((sq)->hw_ci_addr))
 
-#define MIN_SKB_LEN			17
+#define MIN_SKB_LEN			32
 #define HINIC_GSO_MAX_SIZE		65536
 
 #define	MAX_PAYLOAD_OFFSET		221
-- 
2.17.1

