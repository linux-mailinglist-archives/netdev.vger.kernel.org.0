Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBEBD34A54F
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 11:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbhCZKK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 06:10:56 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:14915 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbhCZKKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 06:10:30 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4F6Hk72gFSzkgX3;
        Fri, 26 Mar 2021 18:08:47 +0800 (CST)
Received: from huawei.com (10.175.103.91) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.498.0; Fri, 26 Mar 2021
 18:10:24 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>
Subject: [PATCH -next 2/3] net: llc: Correct function name llc_sap_action_unitdata_ind() in header
Date:   Fri, 26 Mar 2021 18:13:49 +0800
Message-ID: <20210326101350.2519614-3-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210326101350.2519614-1-yangyingliang@huawei.com>
References: <20210326101350.2519614-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following make W=1 kernel build warning:

  net/llc/llc_s_ac.c:38: warning: expecting prototype for llc_sap_action_unit_data_ind(). Prototype was for llc_sap_action_unitdata_ind() instead

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 net/llc/llc_s_ac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/llc/llc_s_ac.c b/net/llc/llc_s_ac.c
index 7ae4cc684d3a..b554f26c68ee 100644
--- a/net/llc/llc_s_ac.c
+++ b/net/llc/llc_s_ac.c
@@ -27,7 +27,7 @@
 
 
 /**
- *	llc_sap_action_unit_data_ind - forward UI PDU to network layer
+ *	llc_sap_action_unitdata_ind - forward UI PDU to network layer
  *	@sap: SAP
  *	@skb: the event to forward
  *
-- 
2.25.1

