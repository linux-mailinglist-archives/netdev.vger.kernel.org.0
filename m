Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E56B427DDC7
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 03:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729516AbgI3BaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 21:30:17 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:51166 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726689AbgI3BaR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 21:30:17 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id E8A7A46749E585AF801D;
        Wed, 30 Sep 2020 09:30:14 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Wed, 30 Sep 2020 09:30:09 +0800
From:   Jing Xiangfeng <jingxiangfeng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <luc.vanoostenryck@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jingxiangfeng@huawei.com>
Subject: [PATCH] caif_virtio: Remove redundant initialization of variable err
Date:   Wed, 30 Sep 2020 09:29:54 +0800
Message-ID: <20200930012954.1355-1-jingxiangfeng@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit a8c7687bf216 ("caif_virtio: Check that vringh_config is not
null"), the variable err is being initialized with '-EINVAL' that is
meaningless. So remove it.

Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
---
 drivers/net/caif/caif_virtio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/caif/caif_virtio.c b/drivers/net/caif/caif_virtio.c
index 80ea2e913c2b..47a6d62b7511 100644
--- a/drivers/net/caif/caif_virtio.c
+++ b/drivers/net/caif/caif_virtio.c
@@ -652,7 +652,7 @@ static int cfv_probe(struct virtio_device *vdev)
 	const char *cfv_netdev_name = "cfvrt";
 	struct net_device *netdev;
 	struct cfv_info *cfv;
-	int err = -EINVAL;
+	int err;
 
 	netdev = alloc_netdev(sizeof(struct cfv_info), cfv_netdev_name,
 			      NET_NAME_UNKNOWN, cfv_netdev_setup);
-- 
2.17.1

