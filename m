Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18760398155
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 08:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbhFBGon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 02:44:43 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2841 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbhFBGol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 02:44:41 -0400
Received: from dggeme760-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Fvzqp2VshzWqsg;
        Wed,  2 Jun 2021 14:38:14 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeme760-chm.china.huawei.com (10.3.19.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 2 Jun 2021 14:42:55 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <ceph-devel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <idryomov@gmail.com>, <jlayton@kernel.org>,
        Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] libceph: Fix spelling mistakes
Date:   Wed, 2 Jun 2021 14:56:35 +0800
Message-ID: <20210602065635.106561-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix some spelling mistakes in comments:
enconding  ==> encoding
ambigous  ==> ambiguous
orignal  ==> original
encyption  ==> encryption

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 net/ceph/auth_x_protocol.h | 2 +-
 net/ceph/mon_client.c      | 2 +-
 net/ceph/osdmap.c          | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ceph/auth_x_protocol.h b/net/ceph/auth_x_protocol.h
index 792fcb974dc3..9c60feeb1bcb 100644
--- a/net/ceph/auth_x_protocol.h
+++ b/net/ceph/auth_x_protocol.h
@@ -87,7 +87,7 @@ struct ceph_x_authorize_reply {
 
 
 /*
- * encyption bundle
+ * encryption bundle
  */
 #define CEPHX_ENC_MAGIC 0xff009cad8826aa55ull
 
diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
index 195ceb8afb06..013cbdb6cfe2 100644
--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -1508,7 +1508,7 @@ static struct ceph_msg *mon_alloc_msg(struct ceph_connection *con,
 			return get_generic_reply(con, hdr, skip);
 
 		/*
-		 * Older OSDs don't set reply tid even if the orignal
+		 * Older OSDs don't set reply tid even if the original
 		 * request had a non-zero tid.  Work around this weirdness
 		 * by allocating a new message.
 		 */
diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
index c959320c4775..75b738083523 100644
--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -1309,7 +1309,7 @@ static int get_osdmap_client_data_v(void **p, void *end,
 			return -EINVAL;
 		}
 
-		/* old osdmap enconding */
+		/* old osdmap encoding */
 		struct_v = 0;
 	}
 
@@ -3010,7 +3010,7 @@ static bool is_valid_crush_name(const char *name)
  * parent, returns 0.
  *
  * Does a linear search, as there are no parent pointers of any
- * kind.  Note that the result is ambigous for items that occur
+ * kind.  Note that the result is ambiguous for items that occur
  * multiple times in the map.
  */
 static int get_immediate_parent(struct crush_map *c, int id,
-- 
2.25.1

