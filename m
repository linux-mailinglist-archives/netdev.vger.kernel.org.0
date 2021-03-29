Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA1534D042
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 14:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbhC2MlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 08:41:21 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14185 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbhC2MlS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 08:41:18 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F8Bvh5Pz1zmbJJ;
        Mon, 29 Mar 2021 20:38:40 +0800 (CST)
Received: from huawei.com (10.175.103.91) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.498.0; Mon, 29 Mar 2021
 20:41:14 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>
Subject: [PATCH -next] net: mdio: Correct function name mdio45_links_ok() in comment
Date:   Mon, 29 Mar 2021 20:44:27 +0800
Message-ID: <20210329124427.3274071-1-yangyingliang@huawei.com>
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

 drivers/net/mdio.c:95: warning: expecting prototype for mdio_link_ok(). Prototype was for mdio45_links_ok() instead

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/mdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/mdio.c b/drivers/net/mdio.c
index 5e72cc55afbd..e08c90ac0c6e 100644
--- a/drivers/net/mdio.c
+++ b/drivers/net/mdio.c
@@ -83,7 +83,7 @@ int mdio_set_flag(const struct mdio_if_info *mdio,
 EXPORT_SYMBOL(mdio_set_flag);
 
 /**
- * mdio_link_ok - is link status up/OK
+ * mdio45_links_ok - is link status up/OK
  * @mdio: MDIO interface
  * @mmd_mask: Mask for MMDs to check
  *
-- 
2.25.1

