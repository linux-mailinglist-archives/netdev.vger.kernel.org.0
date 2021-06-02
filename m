Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B21D398152
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 08:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhFBGob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 02:44:31 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:3380 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbhFBGoa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 02:44:30 -0400
Received: from dggeme760-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Fvzrk4bqvz67lX;
        Wed,  2 Jun 2021 14:39:02 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeme760-chm.china.huawei.com (10.3.19.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 2 Jun 2021 14:42:44 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] rtnetlink: Fix spelling mistakes
Date:   Wed, 2 Jun 2021 14:56:23 +0800
Message-ID: <20210602065623.106341-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 net/core/rtnetlink.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 714d5fa38546..7bc6f48007c3 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -9,7 +9,7 @@
  * Authors:	Alexey Kuznetsov, <kuznet@ms2.inr.ac.ru>
  *
  *	Fixes:
- *	Vitaly E. Lavrov		RTA_OK arithmetics was wrong.
+ *	Vitaly E. Lavrov		RTA_OK arithmetic was wrong.
  */
 
 #include <linux/bitops.h>
@@ -234,7 +234,7 @@ static int rtnl_register_internal(struct module *owner,
  * @msgtype: rtnetlink message type
  * @doit: Function pointer called for each request message
  * @dumpit: Function pointer called for each dump request (NLM_F_DUMP) message
- * @flags: rtnl_link_flags to modifiy behaviour of doit/dumpit functions
+ * @flags: rtnl_link_flags to modify behaviour of doit/dumpit functions
  *
  * Like rtnl_register, but for use by removable modules.
  */
@@ -254,7 +254,7 @@ EXPORT_SYMBOL_GPL(rtnl_register_module);
  * @msgtype: rtnetlink message type
  * @doit: Function pointer called for each request message
  * @dumpit: Function pointer called for each dump request (NLM_F_DUMP) message
- * @flags: rtnl_link_flags to modifiy behaviour of doit/dumpit functions
+ * @flags: rtnl_link_flags to modify behaviour of doit/dumpit functions
  *
  * Registers the specified function pointers (at least one of them has
  * to be non-NULL) to be called whenever a request message for the
@@ -2574,7 +2574,7 @@ static int do_set_proto_down(struct net_device *dev,
 	if (nl_proto_down) {
 		proto_down = nla_get_u8(nl_proto_down);
 
-		/* Dont turn off protodown if there are active reasons */
+		/* Don't turn off protodown if there are active reasons */
 		if (!proto_down && dev->proto_down_reason) {
 			NL_SET_ERR_MSG(extack, "Cannot clear protodown, active reasons");
 			return -EBUSY;
-- 
2.25.1

