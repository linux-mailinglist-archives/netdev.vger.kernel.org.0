Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCAD43DA2FE
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 14:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236996AbhG2MSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 08:18:42 -0400
Received: from mx21.baidu.com ([220.181.3.85]:55426 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236978AbhG2MSl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Jul 2021 08:18:41 -0400
Received: from BC-Mail-EX08.internal.baidu.com (unknown [172.31.51.48])
        by Forcepoint Email with ESMTPS id 258AA6B4DB088E50910F;
        Thu, 29 Jul 2021 20:18:35 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-EX08.internal.baidu.com (172.31.51.48) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Thu, 29 Jul 2021 20:18:34 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Thu, 29 Jul 2021 20:18:34 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>, <pbonzini@redhat.com>,
        <stefanha@redhat.com>, <sgarzare@redhat.com>
CC:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        Cai Huoqing <caihuoqing@baidu.com>
Subject: [PATCH] vhost: Fix typo in comments
Date:   Thu, 29 Jul 2021 20:18:28 +0800
Message-ID: <20210729121828.2029-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BC-Mail-EX06.internal.baidu.com (172.31.51.46) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fix typo for vhost

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/vhost/scsi.c   |  4 ++--
 drivers/vhost/vhost.c  |  2 +-
 drivers/vhost/vringh.c | 18 +++++++++---------
 drivers/vhost/vsock.c  |  6 +++---
 4 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 46f897e41217..18612219e994 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -119,7 +119,7 @@ struct vhost_scsi_nexus {
 struct vhost_scsi_tpg {
 	/* Vhost port target portal group tag for TCM */
 	u16 tport_tpgt;
-	/* Used to track number of TPG Port/Lun Links wrt to explict I_T Nexus shutdown */
+	/* Used to track number of TPG Port/Lun Links wrt to explicit I_T Nexus shutdown */
 	int tv_tpg_port_count;
 	/* Used for vhost_scsi device reference to tpg_nexus, protected by tv_tpg_mutex */
 	int tv_tpg_vhost_count;
@@ -1057,7 +1057,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 			/*
 			 * Set prot_iter to data_iter and truncate it to
 			 * prot_bytes, and advance data_iter past any
-			 * preceeding prot_bytes that may be present.
+			 * preceding prot_bytes that may be present.
 			 *
 			 * Also fix up the exp_data_len to reflect only the
 			 * actual data payload length.
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index b9e853e6094d..9a0f8b93f64d 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2486,7 +2486,7 @@ void vhost_add_used_and_signal_n(struct vhost_dev *dev,
 }
 EXPORT_SYMBOL_GPL(vhost_add_used_and_signal_n);
 
-/* return true if we're sure that avaiable ring is empty */
+/* return true if we're sure that available ring is empty */
 bool vhost_vq_avail_empty(struct vhost_dev *dev, struct vhost_virtqueue *vq)
 {
 	__virtio16 avail_idx;
diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index 4af8fa259d65..83e8c677ac11 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -630,9 +630,9 @@ static inline int xfer_to_user(const struct vringh *vrh,
  * @features: the feature bits for this ring.
  * @num: the number of elements.
  * @weak_barriers: true if we only need memory barriers, not I/O.
- * @desc: the userpace descriptor pointer.
- * @avail: the userpace avail pointer.
- * @used: the userpace used pointer.
+ * @desc: the userspace descriptor pointer.
+ * @avail: the userspace avail pointer.
+ * @used: the userspace used pointer.
  *
  * Returns an error if num is invalid: you should check pointers
  * yourself!
@@ -905,9 +905,9 @@ static inline int kern_xfer(const struct vringh *vrh, void *dst,
  * @features: the feature bits for this ring.
  * @num: the number of elements.
  * @weak_barriers: true if we only need memory barriers, not I/O.
- * @desc: the userpace descriptor pointer.
- * @avail: the userpace avail pointer.
- * @used: the userpace used pointer.
+ * @desc: the userspace descriptor pointer.
+ * @avail: the userspace avail pointer.
+ * @used: the userspace used pointer.
  *
  * Returns an error if num is invalid.
  */
@@ -1268,9 +1268,9 @@ static inline int putused_iotlb(const struct vringh *vrh,
  * @features: the feature bits for this ring.
  * @num: the number of elements.
  * @weak_barriers: true if we only need memory barriers, not I/O.
- * @desc: the userpace descriptor pointer.
- * @avail: the userpace avail pointer.
- * @used: the userpace used pointer.
+ * @desc: the userspace descriptor pointer.
+ * @avail: the userspace avail pointer.
+ * @used: the userspace used pointer.
  *
  * Returns an error if num is invalid.
  */
diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index f249622ef11b..78f0efdc5713 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -178,10 +178,10 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 			 * small rx buffers, headers of packets in rx queue are
 			 * created dynamically and are initialized with header
 			 * of current packet(except length). But in case of
-			 * SOCK_SEQPACKET, we also must clear record delimeter
+			 * SOCK_SEQPACKET, we also must clear record delimiter
 			 * bit(VIRTIO_VSOCK_SEQ_EOR). Otherwise, instead of one
-			 * packet with delimeter(which marks end of record),
-			 * there will be sequence of packets with delimeter
+			 * packet with delimiter(which marks end of record),
+			 * there will be sequence of packets with delimiter
 			 * bit set. After initialized header will be copied to
 			 * rx buffer, this bit will be restored.
 			 */
-- 
2.25.1

