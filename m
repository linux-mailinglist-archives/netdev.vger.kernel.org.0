Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB6D39562D
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 09:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbhEaHff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 03:35:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:35460 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230215AbhEaHfb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 03:35:31 -0400
IronPort-SDR: yT6bnROv8fAvUwAg+6rYNK5NZKm7PdmRws8DwD3Set9rNm3IkIKbgJ2uwlRKOBOjRyn96n9n01
 ibO1PrgicpIA==
X-IronPort-AV: E=McAfee;i="6200,9189,10000"; a="203316623"
X-IronPort-AV: E=Sophos;i="5.83,236,1616482800"; 
   d="scan'208";a="203316623"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2021 00:33:52 -0700
IronPort-SDR: nbnPbZd9PyfltJ4vgqKfE9tXf2mg787eLyCLBzxanBr3Hk8rHeRvGSF1AnK8utbDZseNNJxjP8
 +McmxbRXrWtA==
X-IronPort-AV: E=Sophos;i="5.83,236,1616482800"; 
   d="scan'208";a="478809814"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.107])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2021 00:33:50 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH RESEND 1/2] virtio: update virtio id table, add transitional ids
Date:   Mon, 31 May 2021 15:27:42 +0800
Message-Id: <20210531072743.363171-2-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210531072743.363171-1-lingshan.zhu@intel.com>
References: <20210531072743.363171-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit updates virtio id table by adding transitional device
ids

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 include/uapi/linux/virtio_ids.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/uapi/linux/virtio_ids.h b/include/uapi/linux/virtio_ids.h
index f0c35ce8628c..fcc9ec6a73c1 100644
--- a/include/uapi/linux/virtio_ids.h
+++ b/include/uapi/linux/virtio_ids.h
@@ -57,4 +57,16 @@
 #define VIRTIO_ID_BT			28 /* virtio bluetooth */
 #define VIRTIO_ID_MAC80211_HWSIM	29 /* virtio mac80211-hwsim */
 
+/*
+ * Virtio Transitional IDs
+ */
+
+#define VIRTIO_TRANS_ID_NET		1000 /* transitional virtio net */
+#define VIRTIO_TRANS_ID_BLOCK		1001 /* transitional virtio block */
+#define VIRTIO_TRANS_ID_BALLOON		1002 /* transitional virtio balloon */
+#define VIRTIO_TRANS_ID_CONSOLE		1003 /* transitional virtio console */
+#define VIRTIO_TRANS_ID_SCSI		1004 /* transitional virtio SCSI */
+#define VIRTIO_TRANS_ID_RNG		1005 /* transitional virtio rng */
+#define VIRTIO_TRANS_ID_9P		1009 /* transitional virtio 9p console */
+
 #endif /* _LINUX_VIRTIO_IDS_H */
-- 
2.27.0

