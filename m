Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 147E71372D
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 05:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbfEDDy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 23:54:27 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:34190 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726149AbfEDDy0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 May 2019 23:54:26 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 63757C7C4594CA4E31A4;
        Sat,  4 May 2019 11:54:24 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.439.0; Sat, 4 May 2019 11:54:17 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
CC:     YueHaibing <yuehaibing@huawei.com>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH net-next] net: mvpp2: cls: Remove set but not used variable 'act'
Date:   Sat, 4 May 2019 04:04:05 +0000
Message-ID: <20190504040405.13004-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c: In function 'mvpp2_cls_c2_build_match':
drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c:1159:28: warning:
 variable 'act' set but not used [-Wunused-but-set-variable]

It is never used since introduction in
commit 90b509b39ac9 ("net: mvpp2: cls: Add Classification offload support")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
index 4989fb13244f..f9623f928915 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
@@ -1156,11 +1156,8 @@ static int mvpp2_port_flt_rfs_rule_insert(struct mvpp2_port *port,
 static int mvpp2_cls_c2_build_match(struct mvpp2_rfs_rule *rule)
 {
 	struct flow_rule *flow = rule->flow;
-	struct flow_action_entry *act;
 	int offs = 64;
 
-	act = &flow->action.entries[0];
-
 	if (flow_rule_match_key(flow, FLOW_DISSECTOR_KEY_PORTS)) {
 		struct flow_match_ports match;



