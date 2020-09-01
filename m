Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4C72585BE
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 04:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgIACmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 22:42:52 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:10741 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725901AbgIACmw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Aug 2020 22:42:52 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id D19B6F84F83104F950EF;
        Tue,  1 Sep 2020 10:42:49 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Tue, 1 Sep 2020 10:42:42 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH net-next] vhost: fix typo in error message
Date:   Tue, 1 Sep 2020 10:39:09 +0800
Message-ID: <1598927949-201997-1-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"enable" should be "disable" when the function name is
vhost_disable_notify(), which does the disabling work.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 drivers/vhost/vhost.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 5857d4e..b45519c 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2537,7 +2537,7 @@ void vhost_disable_notify(struct vhost_dev *dev, struct vhost_virtqueue *vq)
 	if (!vhost_has_feature(vq, VIRTIO_RING_F_EVENT_IDX)) {
 		r = vhost_update_used_flags(vq);
 		if (r)
-			vq_err(vq, "Failed to enable notification at %p: %d\n",
+			vq_err(vq, "Failed to disable notification at %p: %d\n",
 			       &vq->used->flags, r);
 	}
 }
-- 
2.8.1

