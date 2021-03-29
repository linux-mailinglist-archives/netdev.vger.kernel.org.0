Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1055334D041
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 14:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbhC2MkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 08:40:19 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14948 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230525AbhC2Mjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 08:39:52 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F8Btd5WrXzyNCX;
        Mon, 29 Mar 2021 20:37:45 +0800 (CST)
Received: from huawei.com (10.175.103.91) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.498.0; Mon, 29 Mar 2021
 20:39:45 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>
Subject: [PATCH -next] net: bonding: Correct function name bond_change_active_slave() in comment
Date:   Mon, 29 Mar 2021 20:42:57 +0800
Message-ID: <20210329124257.3273074-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following make W=1 kernel build warning:

 drivers/net/bonding/bond_main.c:982: warning: expecting prototype for change_active_interface(). Prototype was for bond_change_active_slave() instead

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/bonding/bond_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 74cbbb22470b..d5ca38aa8aa9 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -964,7 +964,7 @@ static bool bond_should_notify_peers(struct bonding *bond)
 }
 
 /**
- * change_active_interface - change the active slave into the specified one
+ * bond_change_active_slave - change the active slave into the specified one
  * @bond: our bonding struct
  * @new_active: the new slave to make the active one
  *
-- 
2.25.1

