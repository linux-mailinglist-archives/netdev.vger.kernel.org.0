Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 109DE4561E7
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 19:00:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbhKRSDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 13:03:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbhKRSDE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 13:03:04 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E16C061574
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 10:00:04 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id j6-20020a17090a588600b001a78a5ce46aso8907989pji.0
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 10:00:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GVzsMfq6X9H5Cdn1cgaO9+0ZvzZ1SeKQa+UZkjvE/B8=;
        b=zHrxTemWDNzSUS9UTTe4l0srB8/7xgWfhcBZpiAIH01vtw7eAKDxotU00ExbILBF2u
         GWvGoUARCY1fxZwOZjENTUCj73hEkL+7+htgCmpLsAkx86zHyiUTUnFwrqZFdp6Cf8LZ
         G+y7UjD5gkzQ9QwY30k0sI8e9hCoHJJO24HBsZGlrhyHolynhwfOIaUuMuGjHrhUGSXF
         L+eOfyiksFxXpcMTqhdFw8NQ+WisDJimS4E61POie6H6BWNYmEup4E9F6oArDmb8eWPv
         z3apKz3SiZAoOr43GWhf//HLfaUsSmtg681GDdciXUvvLwPopOXEuAqXHP9eoyNbLDXY
         FWnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GVzsMfq6X9H5Cdn1cgaO9+0ZvzZ1SeKQa+UZkjvE/B8=;
        b=D5fxqZBru/aldgr1NuyUXgF1GDmC/N4x2MD0zmI6rbFQlz6UIMVdb9r/FJIo5X8el/
         kx36I3Ssnp7Gw1A/ODrccshNMC5h0DF1dO94TIGptrazue7wIgLa/afDOtRfN01uY/3Z
         A6IKLK9TA/ChxWBLtEXVXXUbYuHAA6K9HC6euC/WcIHM4squoVzbO/3dKJkc/kqTp/IC
         o2bQxTXvuca1YTblh4LZEQnSOK+BxAkb6d7YjvIsDwT/xc+qW29f63JlkAbA486Wu75M
         MQ+bBOHkFksmcAHVCHBNVnAgrnmXTgZ+GuIEXCo5CkDpio72cp+v2eGfs4crcRY3VjJl
         zwgA==
X-Gm-Message-State: AOAM531Rw/wM+zkF8Lm7B/bY0LzBVqFnMBwWLAvnhsJoMzZMfr5bwVjH
        baKKxl9hD57AZ8HoXfU4ULCULwQeKFrxbw==
X-Google-Smtp-Source: ABdhPJwkWUO/plLmu+CFHJOYvRqzwgtXZ3KpoUIOo2muxwE/XcLNx6zAXZmy5+eb2htjKXopLt+5RA==
X-Received: by 2002:a17:90b:4b86:: with SMTP id lr6mr12224803pjb.98.1637258403747;
        Thu, 18 Nov 2021 10:00:03 -0800 (PST)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id l6sm288757pfc.126.2021.11.18.10.00.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 10:00:03 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Parav Pandit <parav@nvidia.com>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2] vdpa: align uapi headers
Date:   Thu, 18 Nov 2021 10:00:00 -0800
Message-Id: <20211118180000.30627-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211106064152.313417-1-parav@nvidia.com>
References: <20211106064152.313417-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update vdpa headers based on 5.16.0-rc1 and remove redundant copy.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 include/uapi/linux/vdpa.h            | 47 ----------------------------
 vdpa/include/uapi/linux/vdpa.h       |  7 +++++
 vdpa/include/uapi/linux/virtio_ids.h | 26 +++++++++++++++
 3 files changed, 33 insertions(+), 47 deletions(-)
 delete mode 100644 include/uapi/linux/vdpa.h

diff --git a/include/uapi/linux/vdpa.h b/include/uapi/linux/vdpa.h
deleted file mode 100644
index b7eab069988a..000000000000
--- a/include/uapi/linux/vdpa.h
+++ /dev/null
@@ -1,47 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
-/*
- * vdpa device management interface
- * Copyright (c) 2020 Mellanox Technologies Ltd. All rights reserved.
- */
-
-#ifndef _LINUX_VDPA_H_
-#define _LINUX_VDPA_H_
-
-#define VDPA_GENL_NAME "vdpa"
-#define VDPA_GENL_VERSION 0x1
-
-enum vdpa_command {
-	VDPA_CMD_UNSPEC,
-	VDPA_CMD_MGMTDEV_NEW,
-	VDPA_CMD_MGMTDEV_GET,		/* can dump */
-	VDPA_CMD_DEV_NEW,
-	VDPA_CMD_DEV_DEL,
-	VDPA_CMD_DEV_GET,		/* can dump */
-	VDPA_CMD_DEV_CONFIG_GET,	/* can dump */
-};
-
-enum vdpa_attr {
-	VDPA_ATTR_UNSPEC,
-
-	/* bus name (optional) + dev name together make the parent device handle */
-	VDPA_ATTR_MGMTDEV_BUS_NAME,		/* string */
-	VDPA_ATTR_MGMTDEV_DEV_NAME,		/* string */
-	VDPA_ATTR_MGMTDEV_SUPPORTED_CLASSES,	/* u64 */
-
-	VDPA_ATTR_DEV_NAME,			/* string */
-	VDPA_ATTR_DEV_ID,			/* u32 */
-	VDPA_ATTR_DEV_VENDOR_ID,		/* u32 */
-	VDPA_ATTR_DEV_MAX_VQS,			/* u32 */
-	VDPA_ATTR_DEV_MAX_VQ_SIZE,		/* u16 */
-	VDPA_ATTR_DEV_MIN_VQ_SIZE,		/* u16 */
-
-	VDPA_ATTR_DEV_NET_CFG_MACADDR,		/* binary */
-	VDPA_ATTR_DEV_NET_STATUS,		/* u8 */
-	VDPA_ATTR_DEV_NET_CFG_MAX_VQP,		/* u16 */
-	VDPA_ATTR_DEV_NET_CFG_MTU,		/* u16 */
-
-	/* new attributes must be added above here */
-	VDPA_ATTR_MAX,
-};
-
-#endif
diff --git a/vdpa/include/uapi/linux/vdpa.h b/vdpa/include/uapi/linux/vdpa.h
index 37ae26b6ba26..b7eab069988a 100644
--- a/vdpa/include/uapi/linux/vdpa.h
+++ b/vdpa/include/uapi/linux/vdpa.h
@@ -17,6 +17,7 @@ enum vdpa_command {
 	VDPA_CMD_DEV_NEW,
 	VDPA_CMD_DEV_DEL,
 	VDPA_CMD_DEV_GET,		/* can dump */
+	VDPA_CMD_DEV_CONFIG_GET,	/* can dump */
 };
 
 enum vdpa_attr {
@@ -32,6 +33,12 @@ enum vdpa_attr {
 	VDPA_ATTR_DEV_VENDOR_ID,		/* u32 */
 	VDPA_ATTR_DEV_MAX_VQS,			/* u32 */
 	VDPA_ATTR_DEV_MAX_VQ_SIZE,		/* u16 */
+	VDPA_ATTR_DEV_MIN_VQ_SIZE,		/* u16 */
+
+	VDPA_ATTR_DEV_NET_CFG_MACADDR,		/* binary */
+	VDPA_ATTR_DEV_NET_STATUS,		/* u8 */
+	VDPA_ATTR_DEV_NET_CFG_MAX_VQP,		/* u16 */
+	VDPA_ATTR_DEV_NET_CFG_MTU,		/* u16 */
 
 	/* new attributes must be added above here */
 	VDPA_ATTR_MAX,
diff --git a/vdpa/include/uapi/linux/virtio_ids.h b/vdpa/include/uapi/linux/virtio_ids.h
index bc1c0621f5ed..80d76b75bccd 100644
--- a/vdpa/include/uapi/linux/virtio_ids.h
+++ b/vdpa/include/uapi/linux/virtio_ids.h
@@ -51,8 +51,34 @@
 #define VIRTIO_ID_PSTORE		22 /* virtio pstore device */
 #define VIRTIO_ID_IOMMU			23 /* virtio IOMMU */
 #define VIRTIO_ID_MEM			24 /* virtio mem */
+#define VIRTIO_ID_SOUND			25 /* virtio sound */
 #define VIRTIO_ID_FS			26 /* virtio filesystem */
 #define VIRTIO_ID_PMEM			27 /* virtio pmem */
+#define VIRTIO_ID_RPMB			28 /* virtio rpmb */
 #define VIRTIO_ID_MAC80211_HWSIM	29 /* virtio mac80211-hwsim */
+#define VIRTIO_ID_VIDEO_ENCODER		30 /* virtio video encoder */
+#define VIRTIO_ID_VIDEO_DECODER		31 /* virtio video decoder */
+#define VIRTIO_ID_SCMI			32 /* virtio SCMI */
+#define VIRTIO_ID_NITRO_SEC_MOD		33 /* virtio nitro secure module*/
+#define VIRTIO_ID_I2C_ADAPTER		34 /* virtio i2c adapter */
+#define VIRTIO_ID_WATCHDOG		35 /* virtio watchdog */
+#define VIRTIO_ID_CAN			36 /* virtio can */
+#define VIRTIO_ID_DMABUF		37 /* virtio dmabuf */
+#define VIRTIO_ID_PARAM_SERV		38 /* virtio parameter server */
+#define VIRTIO_ID_AUDIO_POLICY		39 /* virtio audio policy */
+#define VIRTIO_ID_BT			40 /* virtio bluetooth */
+#define VIRTIO_ID_GPIO			41 /* virtio gpio */
+
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
 
 #endif /* _LINUX_VIRTIO_IDS_H */
-- 
2.30.2

