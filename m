Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEB6C19BC5D
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 09:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387538AbgDBHQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 03:16:39 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:43198 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387509AbgDBHQj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Apr 2020 03:16:39 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 219AEE8659E24C149481;
        Thu,  2 Apr 2020 15:16:35 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Thu, 2 Apr 2020
 15:16:28 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH] net: dsa: make dsa_bridge_mtu_normalization() static
Date:   Thu, 2 Apr 2020 15:15:05 +0800
Message-ID: <20200402071505.9999-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.17.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following sparse warning:

net/dsa/slave.c:1341:6: warning: symbol 'dsa_bridge_mtu_normalization'
was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 net/dsa/slave.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 5390ff541658..e94eb1aac602 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1338,7 +1338,7 @@ static void dsa_hw_port_list_free(struct list_head *hw_port_list)
 }
 
 /* Make the hardware datapath to/from @dev limited to a common MTU */
-void dsa_bridge_mtu_normalization(struct dsa_port *dp)
+static void dsa_bridge_mtu_normalization(struct dsa_port *dp)
 {
 	struct list_head hw_port_list;
 	struct dsa_switch_tree *dst;
-- 
2.17.2

