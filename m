Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6BA377DC8
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 10:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbhEJIQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 04:16:49 -0400
Received: from mga18.intel.com ([134.134.136.126]:57585 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230045AbhEJIQt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 04:16:49 -0400
IronPort-SDR: mAAhpM5gbz3qEYm3ZdUOcE2DWCIViTqcvesNLUwX8Jg4t29j2vSDXeX9T+Q7TmJNkqyoj05x1e
 e/cF8MUqlkiA==
X-IronPort-AV: E=McAfee;i="6200,9189,9979"; a="186587922"
X-IronPort-AV: E=Sophos;i="5.82,287,1613462400"; 
   d="scan'208";a="186587922"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2021 01:15:45 -0700
IronPort-SDR: ozlSm+ri35isq/tHio7nFJ+DSY5PXYei4Z6ianR6ucuIttq8SpeG5S8uNpJZL6PrbxbLazS7Pr
 BlXYLLL8WwHw==
X-IronPort-AV: E=Sophos;i="5.82,287,1613462400"; 
   d="scan'208";a="436040628"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2021 01:15:42 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 1/2] virtio: update virtio id table, add transitional ids
Date:   Mon, 10 May 2021 16:10:14 +0800
Message-Id: <20210510081015.4212-2-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210510081015.4212-1-lingshan.zhu@intel.com>
References: <20210510081015.4212-1-lingshan.zhu@intel.com>
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

