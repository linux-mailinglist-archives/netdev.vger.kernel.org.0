Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C778830766
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 05:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbfEaDz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 23:55:28 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:54409 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726787AbfEaDyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 23:54:05 -0400
Received: by mail-it1-f194.google.com with SMTP id h20so13557427itk.4
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 20:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z6hkJmMf8qtiwvP4+iR9vyBYr7u1fX1hzLkLMLwIWRM=;
        b=wN+D8g8js2XEisYQvkeRXQyiudL2LOGxdjA6s3gBd3JT7xGJ4KaoGwGeKO3Z7Dy7w6
         yzE99/Z6KpE+IpuoRCd2NoNhpmRZa66jvWpbDkVqD6K01Gvfwmn7NPO7slvfRWGJn5bO
         kVB9+nk6uZyMHpD5kym1spUnMEAGoGLIrT5Hr8pH+xj3qxm2NtmvvDtU0/JrPDJreVhD
         x5jMIZe6Du7Np9fy06y/Ovem90Cf9ekTySYP5Y/oI7+F450Erw7g9N6T9kpo5wduuVYB
         PW2A8y1zWvH9t/5xHxAhpejmVqntLlAXzT6WWMK0ZkThSVnHvRYW9zRFkqY2b+yDhI7k
         Pvpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z6hkJmMf8qtiwvP4+iR9vyBYr7u1fX1hzLkLMLwIWRM=;
        b=Md0tmOymNGEihLUA/6bKAMhdKcd35hB2FJo6OwzsRu3q5n2n4juZEdfbTnP+mAG2Lt
         9Py0rDuBiNObgGqz7QSNOrjWkwYh48KhcuiLlELVFyFCfNLFqJpY322Cfz6xU4U0+TTo
         rM/7L2rIvA3qCPiTBDo4lt1N1ATnivWogqt35s+LtM7vFlEhI0XfyA6UOafRJgtpDtzG
         C+pwOB9nE6UIiAYprlSrL9jYoDUHaN6VSbNVKlb6OGzdx3MtftDISGa+yYlIftSjdOCo
         HkhZsFYZbQNLkk0H7k/S4q3TG0lAgW3IBtzqIcNqks7cgVtfnB/9C3yD1obQL43MVpfW
         pu1w==
X-Gm-Message-State: APjAAAXqX/v1/ttAIaw7bzHlP5vv/WBxiiBQTHvfID9N5LXZOVcO/tKy
        bF9Fp7L0slFTzPYMp72MPmIGJQ==
X-Google-Smtp-Source: APXvYqx9RDeuEcDH6yMlb3paYNoy6N9tU8gTrpR8s3fvcsTb1+uQBTG4QNVvcqoz/PnBQLHsphhsOw==
X-Received: by 2002:a24:ed03:: with SMTP id r3mr6249612ith.47.1559274843847;
        Thu, 30 May 2019 20:54:03 -0700 (PDT)
Received: from localhost.localdomain (c-71-195-29-92.hsd1.mn.comcast.net. [71.195.29.92])
        by smtp.gmail.com with ESMTPSA id q15sm1626947ioi.15.2019.05.30.20.54.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 20:54:03 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, arnd@arndb.de, bjorn.andersson@linaro.org,
        ilias.apalodimas@linaro.org
Cc:     evgreen@chromium.org, benchan@google.com, ejcaruso@google.com,
        cpratapa@codeaurora.org, syadagir@codeaurora.org,
        subashab@codeaurora.org, abhishek.esse@gmail.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH v2 06/17] soc: qcom: ipa: GSI headers
Date:   Thu, 30 May 2019 22:53:37 -0500
Message-Id: <20190531035348.7194-7-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190531035348.7194-1-elder@linaro.org>
References: <20190531035348.7194-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Generic Software Interface is a layer of the IPA driver that
abstracts the underlying hardware.  The next patch includes the
main code for GSI (including some additional documentation).  This
patch just includes three GSI header files.

  - "gsi.h" is the top-level GSI header file.  There is one of these
    associated with the IPA structure; in fact, it is embedded within
    the IPA structure.  (Were it not embedded this way, many of the
    definitions structures defined here could be private to GSI code.)
    The main abstraction implemented by the GSI code is the channel,
    and this header exposes several operations that can be performed
    on a GSI channel.

  - "gsi_private.h" exposes some definitions that are intended to be
    private, used only by the main GSI code and the GSI transaction
    code (defined in an upcoming patch).

  - Like "ipa_reg.h", "gsi_reg.h" defines the offsets of the 32-bit
    registers used by the GSI layer, along with masks that define the
    position and width of fields less than 32 bits located within
    these registers.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.h         | 246 ++++++++++++++++++++++
 drivers/net/ipa/gsi_private.h | 148 +++++++++++++
 drivers/net/ipa/gsi_reg.h     | 376 ++++++++++++++++++++++++++++++++++
 3 files changed, 770 insertions(+)
 create mode 100644 drivers/net/ipa/gsi.h
 create mode 100644 drivers/net/ipa/gsi_private.h
 create mode 100644 drivers/net/ipa/gsi_reg.h

diff --git a/drivers/net/ipa/gsi.h b/drivers/net/ipa/gsi.h
new file mode 100644
index 000000000000..872ca682853a
--- /dev/null
+++ b/drivers/net/ipa/gsi.h
@@ -0,0 +1,246 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* Copyright (c) 2015-2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2018-2019 Linaro Ltd.
+ */
+#ifndef _GSI_H_
+#define _GSI_H_
+
+#include <linux/types.h>
+#include <linux/spinlock.h>
+#include <linux/mutex.h>
+#include <linux/completion.h>
+#include <linux/platform_device.h>
+#include <linux/netdevice.h>
+
+#define GSI_CHANNEL_MAX		14
+#define GSI_EVT_RING_MAX	10
+
+struct device;
+struct scatterlist;
+struct platform_device;
+
+struct gsi;
+struct gsi_trans;
+struct gsi_channel_data;
+struct gsi_ipa_endpoint_data;
+
+/* Execution environment IDs */
+enum gsi_ee_id {
+	GSI_EE_AP	= 0,
+	GSI_EE_MODEM	= 1,
+	GSI_EE_UC	= 2,
+	GSI_EE_TZ	= 3,
+};
+
+/* Channel operation statistics, aggregated across all channels */
+struct gsi_channel_stats {
+	u64 allocate;
+	u64 start;
+	u64 stop;
+	u64 reset;
+	u64 free;
+};
+
+struct gsi_ring {
+	void *virt;			/* ring array base address */
+	dma_addr_t addr;		/* primarily low 32 bits used */
+	u32 count;			/* number of elements in ring */
+
+	/* The ring index value indicates the next "open" entry in the ring.
+	 *
+	 * A channel ring consists of TRE entries filled by the AP and passed
+	 * to the hardware for processing.  For a channel ring, the ring index
+	 * identifies the next unused entry to be filled by the AP.
+	 *
+	 * An event ring consists of event structures filled by the hardware
+	 * and passed to the AP.  For event rings, the ring index identifies
+	 * the next ring entry that is not known to have been filled by the
+	 * hardware.
+	 */
+	u32 index;
+};
+
+struct gsi_trans_info {
+	struct gsi_trans **map;		/* TRE -> transaction map */
+	u32 pool_count;			/* # transactions in the pool */
+	struct gsi_trans *pool;		/* transaction allocation pool */
+	u32 pool_free;			/* next free trans in pool (modulo) */
+	u32 sg_pool_count;		/* # SGs in the allocation pool */
+	struct scatterlist *sg_pool;	/* SG allocation pool */
+	u32 sg_pool_free;		/* next free SG pool entry */
+
+	atomic_t tre_avail;		/* # unallocated TREs in ring */
+	spinlock_t spinlock;		/* protects updates to the lists */
+	struct list_head alloc;		/* allocated, not committed */
+	struct list_head pending;	/* committed, awaiting completion */
+	struct list_head complete;	/* completed, awaiting poll */
+	struct list_head polled;	/* returned by gsi_channel_poll_one() */
+};
+
+/* Hardware values signifying the state of a channel */
+enum gsi_channel_state {
+	GSI_CHANNEL_STATE_NOT_ALLOCATED	= 0x0,
+	GSI_CHANNEL_STATE_ALLOCATED	= 0x1,
+	GSI_CHANNEL_STATE_STARTED	= 0x2,
+	GSI_CHANNEL_STATE_STOPPED	= 0x3,
+	GSI_CHANNEL_STATE_STOP_IN_PROC	= 0x4,
+	GSI_CHANNEL_STATE_ERROR		= 0xf,
+};
+
+/* We only care about channels between IPA and AP */
+struct gsi_channel {
+	struct gsi *gsi;
+	u32 toward_ipa;			/* 0: IPA->AP; 1: AP->IPA */
+
+	const struct gsi_channel_data *data;	/* initialization data */
+
+	struct completion completion;	/* signals channel state changes */
+	enum gsi_channel_state state;
+
+	struct gsi_ring tre_ring;
+	u32 evt_ring_id;
+
+	u64 byte_count;			/* total # bytes transferred */
+	u64 trans_count;		/* total # transactions */
+	/* The following counts are used only for TX endpoints */
+	u64 queued_byte_count;		/* last reported queued byte count */
+	u64 queued_trans_count;		/* ...and queued trans count */
+	u64 compl_byte_count;		/* last reported completed byte count */
+	u64 compl_trans_count;		/* ...and completed trans count */
+
+	struct gsi_trans_info trans_info;
+
+	struct napi_struct napi;
+};
+
+/* Hardware values signifying the state of an event ring */
+enum gsi_evt_ring_state {
+	GSI_EVT_RING_STATE_NOT_ALLOCATED	= 0x0,
+	GSI_EVT_RING_STATE_ALLOCATED		= 0x1,
+	GSI_EVT_RING_STATE_ERROR		= 0xf,
+};
+
+struct gsi_evt_ring {
+	struct gsi_channel *channel;
+	struct completion completion;	/* signals event ring state changes */
+	enum gsi_evt_ring_state state;
+	struct gsi_ring ring;
+};
+
+struct gsi {
+	struct device *dev;		/* Same as IPA device */
+	struct net_device dummy_dev;	/* needed for NAPI */
+	void __iomem *virt;
+	u32 irq;
+	u32 irq_wake_enabled;		/* 1: irq wake was enabled */
+	struct gsi_channel channel[GSI_CHANNEL_MAX];
+	struct gsi_channel_stats channel_stats;
+	struct gsi_evt_ring evt_ring[GSI_EVT_RING_MAX];
+	u32 event_bitmap;
+	u32 event_enable_bitmap;
+	struct mutex mutex;		/* protects commands, programming */
+};
+
+/**
+ * gsi_setup() - Set up the GSI subsystem
+ * @gsi:	Address of GSI structure embedded in an IPA structure
+ *
+ * @Return:	0 if successful, or a negative error code
+ *
+ * Performs initialization that must wait until the GSI hardware is
+ * ready (including firmware loaded).
+ */
+int gsi_setup(struct gsi *gsi);
+
+/**
+ * gsi_teardown() - Tear down GSI subsystem
+ * @gsi:	GSI address previously passed to a successful gsi_setup() call
+ */
+void gsi_teardown(struct gsi *gsi);
+
+/**
+ * gsi_channel_trans_max() - Channel maximum number of transactions
+ * @gsi:	GSI pointer
+ * @channel_id:	Channel whose limit is to be returned
+ *
+ * @Return:	 The maximum number of pending transactions on the channel
+ */
+u32 gsi_channel_trans_max(struct gsi *gsi, u32 channel_id);
+
+/**
+ * gsi_channel_trans_tre_max() - Return the maximum TREs per transaction
+ * @gsi:	GSI pointer
+ * @channel_id:	Channel whose limit is to be returned
+ *
+ * @Return:	 The maximum TRE count per transaction on the channel
+ */
+u32 gsi_channel_trans_tre_max(struct gsi *gsi, u32 channel_id);
+
+/**
+ * gsi_channel_trans_quiesce() - Wait for channel transactions to complete
+ * @gsi:	GSI pointer
+ * @channel_id:	Channel to quiesce
+ *
+ * Wait for all of a channel's currently-allocated transactions to
+ * be committed, complete, and be freed.
+ *
+ * NOTE:  Assumes no new transactions will be issued before it returns.
+ */
+void gsi_channel_trans_quiesce(struct gsi *gsi, u32 channel_id);
+
+/**
+ * gsi_channel_start() - Make a GSI channel operational
+ * @gsi:	GSI pointer
+ * @channel_id:	Channel to start
+ *
+ * @Return:	0 if successful, or a negative error code
+ */
+int gsi_channel_start(struct gsi *gsi, u32 channel_id);
+
+/**
+ * gsi_channel_stop() - Stop an operational GSI channel
+ * @gsi:	GSI pointer returned by gsi_setup()
+ * @channel_id:	Channel to stop
+ *
+ * @Return:	0 if successful, or a negative error code
+ */
+int gsi_channel_stop(struct gsi *gsi, u32 channel_id);
+
+/**
+ * gsi_channel_reset() - Reset a GSI channel
+ * @gsi:	GSI pointer
+ * @channel_id:	Channel to be reset
+ * @db_enable:	Whether doorbell engine should be enabled
+ *
+ * @Return:	0 if successful, or a negative error code
+ *
+ * Reset a channel and reconfigure it.  The @db_enable flag indicates
+ * whether the doorbell engine will be enabled following reconfiguration.
+ *
+ * GSI hardware relinquishes ownership of all pending receive buffer
+ * transactions as a result of reset.  They will be completed with
+ * result code -ECANCELED.
+ */
+int gsi_channel_reset(struct gsi *gsi, u32 channel_id, bool db_enable);
+
+/**
+ * gsi_init() - Initialize the GSI subsystem
+ * @gsi:	Address of GSI structure embedded in an IPA structure
+ * @pdev:	IPA platform device
+ *
+ * @Return:	0 if successful, or a negative error code
+ *
+ * Early stage initialization of the GSI subsystem, performing tasks
+ * that can be done before the GSI hardware is ready to use.
+ */
+int gsi_init(struct gsi *gsi, struct platform_device *pdev, u32 data_count,
+	     const struct gsi_ipa_endpoint_data *data);
+
+/**
+ * gsi_exit() - Exit the GSI subsystem
+ * @gsi:	GSI address previously passed to a successful gsi_init() call
+ */
+void gsi_exit(struct gsi *gsi);
+
+#endif /* _GSI_H_ */
diff --git a/drivers/net/ipa/gsi_private.h b/drivers/net/ipa/gsi_private.h
new file mode 100644
index 000000000000..778e2dcb5b2b
--- /dev/null
+++ b/drivers/net/ipa/gsi_private.h
@@ -0,0 +1,148 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* Copyright (c) 2015-2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2018-2019 Linaro Ltd.
+ */
+#ifndef _GSI_PRIVATE_H_
+#define _GSI_PRIVATE_H_
+
+/* === Only "gsi.c" and "gsi_trans.c" should include this file === */
+
+#include <linux/types.h>
+
+struct gsi_trans;
+struct gsi_ring;
+struct gsi_channel;
+
+/* An entry in an event ring */
+struct gsi_xfer_compl_evt {
+	__le64 xfer_ptr;
+	__le16 len;
+	u8 reserved1;
+	u8 code;
+	__le16 reserved2;
+	u8 type;
+	u8 chid;
+};
+
+/* An entry in a channel ring */
+struct gsi_tre {
+	__le64 addr;		/* DMA address */
+	__le16 len_opcode;	/* length in bytes or enum IPA_CMD_* */
+	__le16 reserved;
+	__le32 flags;		/* GSI_TRE_FLAGS_* */
+};
+
+/**
+ * gsi_trans_move_complete() - Mark a GSI transaction completed
+ * @trans:	Transaction to commit
+ */
+void gsi_trans_move_complete(struct gsi_trans *trans);
+
+/**
+ * gsi_trans_move_polled() - Mark a transaction polled
+ * @trans:	Transaction to update
+ */
+void gsi_trans_move_polled(struct gsi_trans *trans);
+
+/**
+ * gsi_channel_trans_last() - Get channel's last allocated transaction
+ * @gsi:	GSI pointer
+ * @channel_id:	Channel whose transaction is to be returned
+ *
+ * @Return:	Channel's last GSI transaction pointer allocated (or NULL)
+ *
+ * Returns a pointer to the last transaction allocated on a channel.
+ * That transaction could be in any state:  allocated; pending;
+ * complete; or polled.  A null pointer is returned if all allocated
+ * transactions have been freed.
+ *
+ * NOTE:  Caller is responsible for supplying the returned pointer
+ *	  to gsi_trans_free() if it is non-null.
+ */
+struct gsi_trans *gsi_channel_trans_last(struct gsi *gsi, u32 channel_id);
+
+/**
+ * gsi_trans_complete() - Complete a GSI transaction
+ * @trans:	Transaction to complete
+ *
+ * Marks a transaction complete (including freeing it).
+ */
+void gsi_trans_complete(struct gsi_trans *trans);
+
+/**
+ * gsi_channel_trans_mapped() - Return a transaction mapped to a TRE index
+ * @channel:	Channel associated with the transaction
+ * @index:	Index of the TRE having a transaction
+ *
+ * @Return:	The GSI transaction pointer associated with the TRE index
+ */
+struct gsi_trans *gsi_channel_trans_mapped(struct gsi_channel *channel,
+					   u32 index);
+
+/**
+ * gsi_channel_trans_complete() - Return a channel's next completed transaction
+ * @channel:	Channel whose next transaction is to be returned
+ *
+ * @Return:	The next completed transaction, or NULL if nothing new
+ */
+struct gsi_trans *gsi_channel_trans_complete(struct gsi_channel *channel);
+
+/**
+ * gsi_channel_trans_cancel_pending() - Cancel pending transactions
+ * @channel:	Channel whose pending transactions should be cancelled
+ *
+ * Cancel all pending transactions on a channel.  These are
+ * transactions that have been comitted but not yet completed.  This
+ * is required when the channel gets reset.  At that time all
+ * pending transactions will be completed with a result -ECANCELED.
+ *
+ * NOTE:  Transactions already complete at the time of this call are
+ *	  unaffected.
+ */
+void gsi_channel_trans_cancel_pending(struct gsi_channel *channel);
+
+/**
+ * gsi_channel_trans_init() - Initialize a channel's GSI transaction info
+ * @channel:	The channel whose transaction info is to be set up
+ *
+ * @Return:	0 if successful, or -ENOMEM on allocation failure
+ *
+ * Creates and sets up information for managing transactions on a channel
+ */
+int gsi_channel_trans_init(struct gsi_channel *channel);
+
+/**
+ * gsi_channel_trans_exit() - Inverse of gsi_channel_trans_init()
+ * @channel:	Channel whose transaction information is to be cleaned up
+ */
+void gsi_channel_trans_exit(struct gsi_channel *channel);
+
+/**
+ * gsi_channel_doorbell() - Ring a channel's doorbell
+ * @channel:	Channel whose doorbell should be rung
+ *
+ * Rings a channel's doorbell to inform the GSI hardware that new
+ * transactions (TREs, really) are available for it to process.
+ */
+void gsi_channel_doorbell(struct gsi_channel *channel);
+
+/**
+ * gsi_ring_virt() - Return virtual address for a ring entry
+ * @ring:	Ring whose address is to be translated
+ * @addr:	Index (slot number) of entry
+ */
+void *gsi_ring_virt(struct gsi_ring *ring, u32 index);
+
+/**
+ * gsi_channel_tx_queued() - Report the number of bytes queued to hardware
+ * @channel:	Channel whose bytes have been queued
+ *
+ * This arranges for the the number of transactions and bytes for
+ * transfer that have been queued to hardware to be reported.  It
+ * passes this information up the network stack so it can be used to
+ * throttle transmissions.
+ */
+void gsi_channel_tx_queued(struct gsi_channel *channel);
+
+#endif /* _GSI_PRIVATE_H_ */
diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
new file mode 100644
index 000000000000..c6e68933b011
--- /dev/null
+++ b/drivers/net/ipa/gsi_reg.h
@@ -0,0 +1,376 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* Copyright (c) 2015-2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2018-2019 Linaro Ltd.
+ */
+#ifndef _GSI_REG_H_
+#define _GSI_REG_H_
+
+/* === Only "gsi.c" should include this file === */
+
+#include <linux/bits.h>
+
+/**
+ * DOC: GSI Registers
+ *
+ * GSI registers are located within the "gsi" address space defined by Device
+ * Tree.  The offset of each register within that space is specified by
+ * symbols defined below.  The GSI address space is mapped to virtual memory
+ * space in gsi_init().  All GSI registers are 32 bits wide.
+ *
+ * Each register type is duplicated for a number of instances of something.
+ * For example, each GSI channel has its own set of registers defining its
+ * configuration.  The offset to a channel's set of registers is computed
+ * based on a "base" offset plus an additional "stride" amount computed
+ * from the channel's ID.  For such registers, the offset is computed by a
+ * function-like macro that takes a parameter used in the computation.
+ *
+ * The offset of a register dependent on execution environment is computed
+ * by a macro that is supplied a parameter "ee".  The "ee" value is a member
+ * of the gsi_ee enumerated type.
+ *
+ * The offset of a channel register is computed by a macro that is supplied a
+ * parameter "ch".  The "ch" value is a channel id whose maximum value is 30
+ * (though the actual limit is hardware-dependent).
+ *
+ * The offset of an event register is computed by a macro that is supplied a
+ * parameter "ev".  The "ev" value is an event id whose maximum value is 15
+ * (though the actual limit is hardware-dependent).
+ */
+
+#define GSI_INTER_EE_SRC_CH_IRQ_OFFSET \
+			GSI_INTER_EE_N_SRC_CH_IRQ_OFFSET(GSI_EE_AP)
+#define GSI_INTER_EE_N_SRC_CH_IRQ_OFFSET(ee) \
+			(0x0000c018 + 0x1000 * (ee))
+
+#define GSI_INTER_EE_SRC_EV_CH_IRQ_OFFSET \
+			GSI_INTER_EE_N_SRC_EV_CH_IRQ_OFFSET(GSI_EE_AP)
+#define GSI_INTER_EE_N_SRC_EV_CH_IRQ_OFFSET(ee) \
+			(0x0000c01c + 0x1000 * (ee))
+
+#define GSI_INTER_EE_SRC_CH_IRQ_CLR_OFFSET \
+			GSI_INTER_EE_N_SRC_CH_IRQ_CLR_OFFSET(GSI_EE_AP)
+#define GSI_INTER_EE_N_SRC_CH_IRQ_CLR_OFFSET(ee) \
+			(0x0000c028 + 0x1000 * (ee))
+
+#define GSI_INTER_EE_SRC_EV_CH_IRQ_CLR_OFFSET \
+			GSI_INTER_EE_N_SRC_EV_CH_IRQ_CLR_OFFSET(GSI_EE_AP)
+#define GSI_INTER_EE_N_SRC_EV_CH_IRQ_CLR_OFFSET(ee) \
+			(0x0000c02c + 0x1000 * (ee))
+
+#define GSI_CH_C_CNTXT_0_OFFSET(ch) \
+		GSI_EE_N_CH_C_CNTXT_0_OFFSET((ch), GSI_EE_AP)
+#define GSI_EE_N_CH_C_CNTXT_0_OFFSET(ch, ee) \
+		(0x0001c000 + 0x4000 * (ee) + 0x80 * (ch))
+#define CHTYPE_PROTOCOL_FMASK		GENMASK(2, 0)
+#define CHTYPE_DIR_FMASK		GENMASK(3, 3)
+#define EE_FMASK			GENMASK(7, 4)
+#define CHID_FMASK			GENMASK(12, 8)
+#define ERINDEX_FMASK			GENMASK(18, 14)
+#define CHSTATE_FMASK			GENMASK(23, 20)
+#define ELEMENT_SIZE_FMASK		GENMASK(31, 24)
+
+#define GSI_CH_C_CNTXT_1_OFFSET(ch) \
+		GSI_EE_N_CH_C_CNTXT_1_OFFSET((ch), GSI_EE_AP)
+#define GSI_EE_N_CH_C_CNTXT_1_OFFSET(ch, ee) \
+		(0x0001c004 + 0x4000 * (ee) + 0x80 * (ch))
+#define R_LENGTH_FMASK			GENMASK(15, 0)
+
+#define GSI_CH_C_CNTXT_2_OFFSET(ch) \
+		GSI_EE_N_CH_C_CNTXT_2_OFFSET((ch), GSI_EE_AP)
+#define GSI_EE_N_CH_C_CNTXT_2_OFFSET(ch, ee) \
+		(0x0001c008 + 0x4000 * (ee) + 0x80 * (ch))
+
+#define GSI_CH_C_CNTXT_3_OFFSET(ch) \
+		GSI_EE_N_CH_C_CNTXT_3_OFFSET((ch), GSI_EE_AP)
+#define GSI_EE_N_CH_C_CNTXT_3_OFFSET(ch, ee) \
+		(0x0001c00c + 0x4000 * (ee) + 0x80 * (ch))
+
+#define GSI_CH_C_QOS_OFFSET(ch) \
+		GSI_EE_N_CH_C_QOS_OFFSET((ch), GSI_EE_AP)
+#define GSI_EE_N_CH_C_QOS_OFFSET(ch, ee) \
+		(0x0001c05c + 0x4000 * (ee) + 0x80 * (ch))
+#define WRR_WEIGHT_FMASK		GENMASK(3, 0)
+#define MAX_PREFETCH_FMASK		GENMASK(8, 8)
+#define USE_DB_ENG_FMASK		GENMASK(9, 9)
+
+#define GSI_CH_C_SCRATCH_0_OFFSET(ch) \
+		GSI_EE_N_CH_C_SCRATCH_0_OFFSET((ch), GSI_EE_AP)
+#define GSI_EE_N_CH_C_SCRATCH_0_OFFSET(ch, ee) \
+		(0x0001c060 + 0x4000 * (ee) + 0x80 * (ch))
+
+#define GSI_CH_C_SCRATCH_1_OFFSET(ch) \
+		GSI_EE_N_CH_C_SCRATCH_1_OFFSET((ch), GSI_EE_AP)
+#define GSI_EE_N_CH_C_SCRATCH_1_OFFSET(ch, ee) \
+		(0x0001c064 + 0x4000 * (ee) + 0x80 * (ch))
+
+#define GSI_CH_C_SCRATCH_2_OFFSET(ch) \
+		GSI_EE_N_CH_C_SCRATCH_2_OFFSET((ch), GSI_EE_AP)
+#define GSI_EE_N_CH_C_SCRATCH_2_OFFSET(ch, ee) \
+		(0x0001c068 + 0x4000 * (ee) + 0x80 * (ch))
+
+#define GSI_CH_C_SCRATCH_3_OFFSET(ch) \
+		GSI_EE_N_CH_C_SCRATCH_3_OFFSET((ch), GSI_EE_AP)
+#define GSI_EE_N_CH_C_SCRATCH_3_OFFSET(ch, ee) \
+		(0x0001c06c + 0x4000 * (ee) + 0x80 * (ch))
+
+#define GSI_EV_CH_E_CNTXT_0_OFFSET(ev) \
+		GSI_EE_N_EV_CH_E_CNTXT_0_OFFSET((ev), GSI_EE_AP)
+#define GSI_EE_N_EV_CH_E_CNTXT_0_OFFSET(ev, ee) \
+		(0x0001d000 + 0x4000 * (ee) + 0x80 * (ev))
+#define EV_CHTYPE_FMASK			GENMASK(3, 0)
+#define EV_EE_FMASK			GENMASK(7, 4)
+#define EV_EVCHID_FMASK			GENMASK(15, 8)
+#define EV_INTYPE_FMASK			GENMASK(16, 16)
+#define EV_CHSTATE_FMASK		GENMASK(23, 20)
+#define EV_ELEMENT_SIZE_FMASK		GENMASK(31, 24)
+
+#define GSI_EV_CH_E_CNTXT_1_OFFSET(ev) \
+		GSI_EE_N_EV_CH_E_CNTXT_1_OFFSET((ev), GSI_EE_AP)
+#define GSI_EE_N_EV_CH_E_CNTXT_1_OFFSET(ev, ee) \
+		(0x0001d004 + 0x4000 * (ee) + 0x80 * (ev))
+#define EV_R_LENGTH_FMASK		GENMASK(15, 0)
+
+#define GSI_EV_CH_E_CNTXT_2_OFFSET(ev) \
+		GSI_EE_N_EV_CH_E_CNTXT_2_OFFSET((ev), GSI_EE_AP)
+#define GSI_EE_N_EV_CH_E_CNTXT_2_OFFSET(ev, ee) \
+		(0x0001d008 + 0x4000 * (ee) + 0x80 * (ev))
+
+#define GSI_EV_CH_E_CNTXT_3_OFFSET(ev) \
+		GSI_EE_N_EV_CH_E_CNTXT_3_OFFSET((ev), GSI_EE_AP)
+#define GSI_EE_N_EV_CH_E_CNTXT_3_OFFSET(ev, ee) \
+		(0x0001d00c + 0x4000 * (ee) + 0x80 * (ev))
+
+#define GSI_EV_CH_E_CNTXT_4_OFFSET(ev) \
+		GSI_EE_N_EV_CH_E_CNTXT_4_OFFSET((ev), GSI_EE_AP)
+#define GSI_EE_N_EV_CH_E_CNTXT_4_OFFSET(ev, ee) \
+		(0x0001d010 + 0x4000 * (ee) + 0x80 * (ev))
+
+#define GSI_EV_CH_E_CNTXT_8_OFFSET(ev) \
+		GSI_EE_N_EV_CH_E_CNTXT_8_OFFSET((ev), GSI_EE_AP)
+#define GSI_EE_N_EV_CH_E_CNTXT_8_OFFSET(ev, ee) \
+		(0x0001d020 + 0x4000 * (ee) + 0x80 * (ev))
+#define MODT_FMASK			GENMASK(15, 0)
+#define MODC_FMASK			GENMASK(23, 16)
+#define MOD_CNT_FMASK			GENMASK(31, 24)
+
+#define GSI_EV_CH_E_CNTXT_9_OFFSET(ev) \
+		GSI_EE_N_EV_CH_E_CNTXT_9_OFFSET((ev), GSI_EE_AP)
+#define GSI_EE_N_EV_CH_E_CNTXT_9_OFFSET(ev, ee) \
+		(0x0001d024 + 0x4000 * (ee) + 0x80 * (ev))
+
+#define GSI_EV_CH_E_CNTXT_10_OFFSET(ev) \
+		GSI_EE_N_EV_CH_E_CNTXT_10_OFFSET((ev), GSI_EE_AP)
+#define GSI_EE_N_EV_CH_E_CNTXT_10_OFFSET(ev, ee) \
+		(0x0001d028 + 0x4000 * (ee) + 0x80 * (ev))
+
+#define GSI_EV_CH_E_CNTXT_11_OFFSET(ev) \
+		GSI_EE_N_EV_CH_E_CNTXT_11_OFFSET((ev), GSI_EE_AP)
+#define GSI_EE_N_EV_CH_E_CNTXT_11_OFFSET(ev, ee) \
+		(0x0001d02c + 0x4000 * (ee) + 0x80 * (ev))
+
+#define GSI_EV_CH_E_CNTXT_12_OFFSET(ev) \
+		GSI_EE_N_EV_CH_E_CNTXT_12_OFFSET((ev), GSI_EE_AP)
+#define GSI_EE_N_EV_CH_E_CNTXT_12_OFFSET(ev, ee) \
+		(0x0001d030 + 0x4000 * (ee) + 0x80 * (ev))
+
+#define GSI_EV_CH_E_CNTXT_13_OFFSET(ev) \
+		GSI_EE_N_EV_CH_E_CNTXT_13_OFFSET((ev), GSI_EE_AP)
+#define GSI_EE_N_EV_CH_E_CNTXT_13_OFFSET(ev, ee) \
+		(0x0001d034 + 0x4000 * (ee) + 0x80 * (ev))
+
+#define GSI_EV_CH_E_SCRATCH_0_OFFSET(ev) \
+		GSI_EE_N_EV_CH_E_SCRATCH_0_OFFSET((ev), GSI_EE_AP)
+#define GSI_EE_N_EV_CH_E_SCRATCH_0_OFFSET(ev, ee) \
+		(0x0001d048 + 0x4000 * (ee) + 0x80 * (ev))
+
+#define GSI_EV_CH_E_SCRATCH_1_OFFSET(ev) \
+		GSI_EE_N_EV_CH_E_SCRATCH_1_OFFSET((ev), GSI_EE_AP)
+#define GSI_EE_N_EV_CH_E_SCRATCH_1_OFFSET(ev, ee) \
+		(0x0001d04c + 0x4000 * (ee) + 0x80 * (ev))
+
+#define GSI_CH_C_DOORBELL_0_OFFSET(ch) \
+		GSI_EE_N_CH_C_DOORBELL_0_OFFSET((ch), GSI_EE_AP)
+#define GSI_EE_N_CH_C_DOORBELL_0_OFFSET(ch, ee) \
+			(0x0001e000 + 0x4000 * (ee) + 0x08 * (ch))
+
+#define GSI_EV_CH_E_DOORBELL_0_OFFSET(ev) \
+			GSI_EE_N_EV_CH_E_DOORBELL_0_OFFSET((ev), GSI_EE_AP)
+#define GSI_EE_N_EV_CH_E_DOORBELL_0_OFFSET(ev, ee) \
+			(0x0001e100 + 0x4000 * (ee) + 0x08 * (ev))
+
+#define GSI_GSI_STATUS_OFFSET \
+			GSI_EE_N_GSI_STATUS_OFFSET(GSI_EE_AP)
+#define GSI_EE_N_GSI_STATUS_OFFSET(ee) \
+			(0x0001f000 + 0x4000 * (ee))
+#define ENABLED_FMASK			GENMASK(0, 0)
+
+#define GSI_CH_CMD_OFFSET \
+			GSI_EE_N_CH_CMD_OFFSET(GSI_EE_AP)
+#define GSI_EE_N_CH_CMD_OFFSET(ee) \
+			(0x0001f008 + 0x4000 * (ee))
+#define CH_CHID_FMASK			GENMASK(7, 0)
+#define CH_OPCODE_FMASK			GENMASK(31, 24)
+
+#define GSI_EV_CH_CMD_OFFSET \
+			GSI_EE_N_EV_CH_CMD_OFFSET(GSI_EE_AP)
+#define GSI_EE_N_EV_CH_CMD_OFFSET(ee) \
+			(0x0001f010 + 0x4000 * (ee))
+#define EV_CHID_FMASK			GENMASK(7, 0)
+#define EV_OPCODE_FMASK			GENMASK(31, 24)
+
+#define GSI_GSI_HW_PARAM_2_OFFSET \
+			GSI_EE_N_GSI_HW_PARAM_2_OFFSET(GSI_EE_AP)
+#define GSI_EE_N_GSI_HW_PARAM_2_OFFSET(ee) \
+			(0x0001f040 + 0x4000 * (ee))
+#define IRAM_SIZE_FMASK			GENMASK(2, 0)
+#define NUM_CH_PER_EE_FMASK		GENMASK(7, 3)
+#define NUM_EV_PER_EE_FMASK		GENMASK(12, 8)
+#define GSI_CH_PEND_TRANSLATE_FMASK	GENMASK(13, 13)
+#define GSI_CH_FULL_LOGIC_FMASK		GENMASK(14, 14)
+#define IRAM_SIZE_ONE_KB_FVAL			0
+#define IRAM_SIZE_TWO_KB_FVAL			1
+
+#define GSI_CNTXT_TYPE_IRQ_OFFSET \
+			GSI_EE_N_CNTXT_TYPE_IRQ_OFFSET(GSI_EE_AP)
+#define GSI_EE_N_CNTXT_TYPE_IRQ_OFFSET(ee) \
+			(0x0001f080 + 0x4000 * (ee))
+#define CH_CTRL_FMASK			GENMASK(0, 0)
+#define EV_CTRL_FMASK			GENMASK(1, 1)
+#define GLOB_EE_FMASK			GENMASK(2, 2)
+#define IEOB_FMASK			GENMASK(3, 3)
+#define INTER_EE_CH_CTRL_FMASK		GENMASK(4, 4)
+#define INTER_EE_EV_CTRL_FMASK		GENMASK(5, 5)
+#define GENERAL_FMASK			GENMASK(6, 6)
+
+#define GSI_CNTXT_TYPE_IRQ_MSK_OFFSET \
+			GSI_EE_N_CNTXT_TYPE_IRQ_MSK_OFFSET(GSI_EE_AP)
+#define GSI_EE_N_CNTXT_TYPE_IRQ_MSK_OFFSET(ee) \
+			(0x0001f088 + 0x4000 * (ee))
+#define MSK_CH_CTRL_FMASK		GENMASK(0, 0)
+#define MSK_EV_CTRL_FMASK		GENMASK(1, 1)
+#define MSK_GLOB_EE_FMASK		GENMASK(2, 2)
+#define MSK_IEOB_FMASK			GENMASK(3, 3)
+#define MSK_INTER_EE_CH_CTRL_FMASK	GENMASK(4, 4)
+#define MSK_INTER_EE_EV_CTRL_FMASK	GENMASK(5, 5)
+#define MSK_GENERAL_FMASK		GENMASK(6, 6)
+#define GSI_CNTXT_TYPE_IRQ_MSK_ALL	GENMASK(6, 0)
+
+#define GSI_CNTXT_SRC_CH_IRQ_OFFSET \
+			GSI_EE_N_CNTXT_SRC_CH_IRQ_OFFSET(GSI_EE_AP)
+#define GSI_EE_N_CNTXT_SRC_CH_IRQ_OFFSET(ee) \
+			(0x0001f090 + 0x4000 * (ee))
+
+#define GSI_CNTXT_SRC_EV_CH_IRQ_OFFSET \
+			GSI_EE_N_CNTXT_SRC_EV_CH_IRQ_OFFSET(GSI_EE_AP)
+#define GSI_EE_N_CNTXT_SRC_EV_CH_IRQ_OFFSET(ee) \
+			(0x0001f094 + 0x4000 * (ee))
+
+#define GSI_CNTXT_SRC_CH_IRQ_MSK_OFFSET \
+			GSI_EE_N_CNTXT_SRC_CH_IRQ_MSK_OFFSET(GSI_EE_AP)
+#define GSI_EE_N_CNTXT_SRC_CH_IRQ_MSK_OFFSET(ee) \
+			(0x0001f098 + 0x4000 * (ee))
+
+#define GSI_CNTXT_SRC_EV_CH_IRQ_MSK_OFFSET \
+			GSI_EE_N_CNTXT_SRC_EV_CH_IRQ_MSK_OFFSET(GSI_EE_AP)
+#define GSI_EE_N_CNTXT_SRC_EV_CH_IRQ_MSK_OFFSET(ee) \
+			(0x0001f09c + 0x4000 * (ee))
+
+#define GSI_CNTXT_SRC_CH_IRQ_CLR_OFFSET \
+			GSI_EE_N_CNTXT_SRC_CH_IRQ_CLR_OFFSET(GSI_EE_AP)
+#define GSI_EE_N_CNTXT_SRC_CH_IRQ_CLR_OFFSET(ee) \
+			(0x0001f0a0 + 0x4000 * (ee))
+
+#define GSI_CNTXT_SRC_EV_CH_IRQ_CLR_OFFSET \
+			GSI_EE_N_CNTXT_SRC_EV_CH_IRQ_CLR_OFFSET(GSI_EE_AP)
+#define GSI_EE_N_CNTXT_SRC_EV_CH_IRQ_CLR_OFFSET(ee) \
+			(0x0001f0a4 + 0x4000 * (ee))
+
+#define GSI_CNTXT_SRC_IEOB_IRQ_OFFSET \
+			GSI_EE_N_CNTXT_SRC_IEOB_IRQ_OFFSET(GSI_EE_AP)
+#define GSI_EE_N_CNTXT_SRC_IEOB_IRQ_OFFSET(ee) \
+			(0x0001f0b0 + 0x4000 * (ee))
+
+#define GSI_CNTXT_SRC_IEOB_IRQ_MSK_OFFSET \
+			GSI_EE_N_CNTXT_SRC_IEOB_IRQ_MSK_OFFSET(GSI_EE_AP)
+#define GSI_EE_N_CNTXT_SRC_IEOB_IRQ_MSK_OFFSET(ee) \
+			(0x0001f0b8 + 0x4000 * (ee))
+
+#define GSI_CNTXT_SRC_IEOB_IRQ_CLR_OFFSET \
+			GSI_EE_N_CNTXT_SRC_IEOB_IRQ_CLR_OFFSET(GSI_EE_AP)
+#define GSI_EE_N_CNTXT_SRC_IEOB_IRQ_CLR_OFFSET(ee) \
+			(0x0001f0c0 + 0x4000 * (ee))
+
+#define GSI_CNTXT_GLOB_IRQ_STTS_OFFSET \
+			GSI_EE_N_CNTXT_GLOB_IRQ_STTS_OFFSET(GSI_EE_AP)
+#define GSI_EE_N_CNTXT_GLOB_IRQ_STTS_OFFSET(ee) \
+			(0x0001f100 + 0x4000 * (ee))
+#define ERROR_INT_FMASK			GENMASK(0, 0)
+#define GP_INT1_FMASK			GENMASK(1, 1)
+#define GP_INT2_FMASK			GENMASK(2, 2)
+#define GP_INT3_FMASK			GENMASK(3, 3)
+
+#define GSI_CNTXT_GLOB_IRQ_EN_OFFSET \
+			GSI_EE_N_CNTXT_GLOB_IRQ_EN_OFFSET(GSI_EE_AP)
+#define GSI_EE_N_CNTXT_GLOB_IRQ_EN_OFFSET(ee) \
+			(0x0001f108 + 0x4000 * (ee))
+#define EN_ERROR_INT_FMASK		GENMASK(0, 0)
+#define EN_GP_INT1_FMASK		GENMASK(1, 1)
+#define EN_GP_INT2_FMASK		GENMASK(2, 2)
+#define EN_GP_INT3_FMASK		GENMASK(3, 3)
+#define GSI_CNTXT_GLOB_IRQ_ALL		GENMASK(3, 0)
+
+#define GSI_CNTXT_GLOB_IRQ_CLR_OFFSET \
+			GSI_EE_N_CNTXT_GLOB_IRQ_CLR_OFFSET(GSI_EE_AP)
+#define GSI_EE_N_CNTXT_GLOB_IRQ_CLR_OFFSET(ee) \
+			(0x0001f110 + 0x4000 * (ee))
+#define CLR_ERROR_INT_FMASK		GENMASK(0, 0)
+#define CLR_GP_INT1_FMASK		GENMASK(1, 1)
+#define CLR_GP_INT2_FMASK		GENMASK(2, 2)
+#define CLR_GP_INT3_FMASK		GENMASK(3, 3)
+
+#define GSI_CNTXT_GSI_IRQ_STTS_OFFSET \
+			GSI_EE_N_CNTXT_GSI_IRQ_STTS_OFFSET(GSI_EE_AP)
+#define GSI_EE_N_CNTXT_GSI_IRQ_STTS_OFFSET(ee) \
+			(0x0001f118 + 0x4000 * (ee))
+#define BREAK_POINT_FMASK		GENMASK(0, 0)
+#define BUS_ERROR_FMASK			GENMASK(1, 1)
+#define CMD_FIFO_OVRFLOW_FMASK		GENMASK(2, 2)
+#define MCS_STACK_OVRFLOW_FMASK		GENMASK(3, 3)
+
+#define GSI_CNTXT_GSI_IRQ_EN_OFFSET \
+			GSI_EE_N_CNTXT_GSI_IRQ_EN_OFFSET(GSI_EE_AP)
+#define GSI_EE_N_CNTXT_GSI_IRQ_EN_OFFSET(ee) \
+			(0x0001f120 + 0x4000 * (ee))
+#define EN_BREAK_POINT_FMASK		GENMASK(0, 0)
+#define EN_BUS_ERROR_FMASK		GENMASK(1, 1)
+#define EN_CMD_FIFO_OVRFLOW_FMASK	GENMASK(2, 2)
+#define EN_MCS_STACK_OVRFLOW_FMASK	GENMASK(3, 3)
+#define GSI_CNTXT_GSI_IRQ_ALL		GENMASK(3, 0)
+
+#define GSI_CNTXT_GSI_IRQ_CLR_OFFSET \
+			GSI_EE_N_CNTXT_GSI_IRQ_CLR_OFFSET(GSI_EE_AP)
+#define GSI_EE_N_CNTXT_GSI_IRQ_CLR_OFFSET(ee) \
+			(0x0001f128 + 0x4000 * (ee))
+#define CLR_BREAK_POINT_FMASK		GENMASK(0, 0)
+#define CLR_BUS_ERROR_FMASK		GENMASK(1, 1)
+#define CLR_CMD_FIFO_OVRFLOW_FMASK	GENMASK(2, 2)
+#define CLR_MCS_STACK_OVRFLOW_FMASK	GENMASK(3, 3)
+
+#define GSI_CNTXT_INTSET_OFFSET \
+			GSI_EE_N_CNTXT_INTSET_OFFSET(GSI_EE_AP)
+#define GSI_EE_N_CNTXT_INTSET_OFFSET(ee) \
+			(0x0001f180 + 0x4000 * (ee))
+#define INTYPE_FMASK			GENMASK(0, 0)
+
+#define GSI_ERROR_LOG_OFFSET \
+			GSI_EE_N_ERROR_LOG_OFFSET(GSI_EE_AP)
+#define GSI_EE_N_ERROR_LOG_OFFSET(ee) \
+			(0x0001f200 + 0x4000 * (ee))
+
+#define GSI_ERROR_LOG_CLR_OFFSET \
+			GSI_EE_N_ERROR_LOG_CLR_OFFSET(GSI_EE_AP)
+#define GSI_EE_N_ERROR_LOG_CLR_OFFSET(ee) \
+			(0x0001f210 + 0x4000 * (ee))
+
+#endif	/* _GSI_REG_H_ */
-- 
2.20.1

