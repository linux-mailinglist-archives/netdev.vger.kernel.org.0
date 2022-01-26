Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 355FF49C465
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 08:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237891AbiAZHfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 02:35:41 -0500
Received: from out199-6.us.a.mail.aliyun.com ([47.90.199.6]:34467 "EHLO
        out199-6.us.a.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237874AbiAZHfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 02:35:38 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0V2uAwQt_1643182534;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V2uAwQt_1643182534)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 26 Jan 2022 15:35:35 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org
Subject: [PATCH v3 01/17] virtio_pci: struct virtio_pci_common_cfg add queue_notify_data
Date:   Wed, 26 Jan 2022 15:35:17 +0800
Message-Id: <20220126073533.44994-2-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220126073533.44994-1-xuanzhuo@linux.alibaba.com>
References: <20220126073533.44994-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add queue_notify_data in struct virtio_pci_common_cfg, which comes from
here https://github.com/oasis-tcs/virtio-spec/issues/89

Since I want to add queue_reset after it, I submitted this patch first.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 include/uapi/linux/virtio_pci.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
index 3a86f36d7e3d..492c89f56c6a 100644
--- a/include/uapi/linux/virtio_pci.h
+++ b/include/uapi/linux/virtio_pci.h
@@ -164,6 +164,7 @@ struct virtio_pci_common_cfg {
 	__le32 queue_avail_hi;		/* read-write */
 	__le32 queue_used_lo;		/* read-write */
 	__le32 queue_used_hi;		/* read-write */
+	__le16 queue_notify_data;	/* read-write */
 };
 
 /* Fields in VIRTIO_PCI_CAP_PCI_CFG: */
-- 
2.31.0

