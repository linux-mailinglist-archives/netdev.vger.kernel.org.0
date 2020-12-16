Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7E992DC0AC
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 14:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726120AbgLPNDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 08:03:03 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9212 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbgLPNDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 08:03:03 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CwwHX44v9zkqG2;
        Wed, 16 Dec 2020 21:01:28 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Wed, 16 Dec 2020 21:02:10 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <jlayton@kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <ceph-devel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] ceph: Delete useless kfree code
Date:   Wed, 16 Dec 2020 21:02:39 +0800
Message-ID: <20201216130239.13759-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The parameter of kfree function is NULL, so kfree code is useless, delete it.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 net/ceph/osdmap.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
index fa08c15be0c0..6e6387c6b7bf 100644
--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -285,7 +285,6 @@ static u32 *decode_array_32_alloc(void **p, void *end, u32 *plen)
 e_inval:
 	ret = -EINVAL;
 fail:
-	kfree(a);
 	return ERR_PTR(ret);
 }
 
-- 
2.22.0

