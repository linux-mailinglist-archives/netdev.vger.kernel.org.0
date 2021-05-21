Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 283F338BCE6
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 05:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238854AbhEUDPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 23:15:53 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4707 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233224AbhEUDPu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 23:15:50 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FmWpy4F0mz16QGQ;
        Fri, 21 May 2021 11:11:38 +0800 (CST)
Received: from dggeme766-chm.china.huawei.com (10.3.19.112) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 21 May 2021 11:14:25 +0800
Received: from huawei.com (10.175.113.133) by dggeme766-chm.china.huawei.com
 (10.3.19.112) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Fri, 21
 May 2021 11:14:25 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <jingxiangfeng@huawei.com>, <luc.vanoostenryck@gmail.com>,
        <kernel@esmil.dk>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] caif_virtio: Fix some typos in caif_virtio.c
Date:   Fri, 21 May 2021 11:24:55 +0800
Message-ID: <20210521032455.28815-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggeme766-chm.china.huawei.com (10.3.19.112)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/patckets/packets/
s/avilable/available/
s/tbe/the/

Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 drivers/net/caif/caif_virtio.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/caif/caif_virtio.c b/drivers/net/caif/caif_virtio.c
index 106f089eb2a8..91230894692d 100644
--- a/drivers/net/caif/caif_virtio.c
+++ b/drivers/net/caif/caif_virtio.c
@@ -315,7 +315,7 @@ static int cfv_rx_poll(struct napi_struct *napi, int quota)
 	case 0:
 		++cfv->stats.rx_napi_complete;
 
-		/* Really out of patckets? (stolen from virtio_net)*/
+		/* Really out of packets? (stolen from virtio_net)*/
 		napi_complete(napi);
 		if (unlikely(!vringh_notify_enable_kern(cfv->vr_rx)) &&
 		    napi_schedule_prep(napi)) {
@@ -463,7 +463,7 @@ static int cfv_netdev_close(struct net_device *netdev)
 	vringh_notify_disable_kern(cfv->vr_rx);
 	napi_disable(&cfv->napi);
 
-	/* Release any TX buffers on both used and avilable rings */
+	/* Release any TX buffers on both used and available rings */
 	cfv_release_used_buf(cfv->vq_tx);
 	spin_lock_irqsave(&cfv->tx_lock, flags);
 	while ((buf_info = virtqueue_detach_unused_buf(cfv->vq_tx)))
@@ -497,7 +497,7 @@ static struct buf_info *cfv_alloc_and_copy_to_shm(struct cfv_info *cfv,
 	if (unlikely(!buf_info))
 		goto err;
 
-	/* Make the IP header aligned in tbe buffer */
+	/* Make the IP header aligned in the buffer */
 	hdr_ofs = cfv->tx_hr + info->hdr_len;
 	pad_len = hdr_ofs & (IP_HDR_ALIGN - 1);
 	buf_info->size = cfv->tx_hr + skb->len + cfv->tx_tr + pad_len;
-- 
2.17.1

