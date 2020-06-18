Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 314131FEAB8
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 07:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbgFRFOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 01:14:03 -0400
Received: from mga07.intel.com ([134.134.136.100]:28000 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726987AbgFRFOB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 01:14:01 -0400
IronPort-SDR: fkmLeZuaG4v9dRN9RAnxvCgFwDJwN3JXXGXFJ9ZerxCzbxEiIrWRvYBjI5Rbolltu5YwDMLFru
 umag3q4OGujQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9655"; a="207694702"
X-IronPort-AV: E=Sophos;i="5.73,525,1583222400"; 
   d="scan'208";a="207694702"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2020 22:13:50 -0700
IronPort-SDR: pX4ODUEaGhAWXYnx4ETEfcm7hZiT6QO8W4OYNVpfAgY9P23O4BhGZMpmFt1dzy8/PqdvGmZbEY
 ZmvxaI5ZmbOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,525,1583222400"; 
   d="scan'208";a="263495586"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga008.fm.intel.com with ESMTP; 17 Jun 2020 22:13:49 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Alice Michael <alice.michael@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Alan Brady <alan.brady@intel.com>,
        Phani Burra <phani.r.burra@intel.com>,
        Joshua Hay <joshua.a.hay@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        Donald Skidmore <donald.c.skidmore@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 04/15] iecm: Common module introduction and function stubs
Date:   Wed, 17 Jun 2020 22:13:33 -0700
Message-Id: <20200618051344.516587-5-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200618051344.516587-1-jeffrey.t.kirsher@intel.com>
References: <20200618051344.516587-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alice Michael <alice.michael@intel.com>

This introduces function stubs for the framework of the common
module.

Signed-off-by: Alice Michael <alice.michael@intel.com>
Signed-off-by: Alan Brady <alan.brady@intel.com>
Signed-off-by: Phani Burra <phani.r.burra@intel.com>
Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
Signed-off-by: Madhu Chittim <madhu.chittim@intel.com>
Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
Reviewed-by: Donald Skidmore <donald.c.skidmore@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/iecm/iecm_controlq.c   |  200 +++
 .../ethernet/intel/iecm/iecm_controlq_setup.c |   84 ++
 .../net/ethernet/intel/iecm/iecm_ethtool.c    |   16 +
 drivers/net/ethernet/intel/iecm/iecm_lib.c    |  406 ++++++
 drivers/net/ethernet/intel/iecm/iecm_main.c   |   47 +
 drivers/net/ethernet/intel/iecm/iecm_osdep.c  |   15 +
 .../ethernet/intel/iecm/iecm_singleq_txrx.c   |  255 ++++
 drivers/net/ethernet/intel/iecm/iecm_txrx.c   | 1256 +++++++++++++++++
 .../net/ethernet/intel/iecm/iecm_virtchnl.c   |  570 ++++++++
 9 files changed, 2849 insertions(+)
 create mode 100644 drivers/net/ethernet/intel/iecm/iecm_controlq.c
 create mode 100644 drivers/net/ethernet/intel/iecm/iecm_controlq_setup.c
 create mode 100644 drivers/net/ethernet/intel/iecm/iecm_ethtool.c
 create mode 100644 drivers/net/ethernet/intel/iecm/iecm_lib.c
 create mode 100644 drivers/net/ethernet/intel/iecm/iecm_main.c
 create mode 100644 drivers/net/ethernet/intel/iecm/iecm_osdep.c
 create mode 100644 drivers/net/ethernet/intel/iecm/iecm_singleq_txrx.c
 create mode 100644 drivers/net/ethernet/intel/iecm/iecm_txrx.c
 create mode 100644 drivers/net/ethernet/intel/iecm/iecm_virtchnl.c

diff --git a/drivers/net/ethernet/intel/iecm/iecm_controlq.c b/drivers/net/ethernet/intel/iecm/iecm_controlq.c
new file mode 100644
index 000000000000..390c499d9eb5
--- /dev/null
+++ b/drivers/net/ethernet/intel/iecm/iecm_controlq.c
@@ -0,0 +1,200 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2020, Intel Corporation. */
+
+#include <linux/net/intel/iecm_osdep.h>
+#include <linux/net/intel/iecm_controlq.h>
+#include <linux/net/intel/iecm_type.h>
+
+/**
+ * iecm_ctlq_setup_regs - initialize control queue registers
+ * @cq: pointer to the specific control queue
+ * @q_create_info: structs containing info for each queue to be initialized
+ */
+static void
+iecm_ctlq_setup_regs(struct iecm_ctlq_info *cq,
+		     struct iecm_ctlq_create_info *q_create_info)
+{
+	/* stub */
+}
+
+/**
+ * iecm_ctlq_init_regs - Initialize control queue registers
+ * @hw: pointer to hw struct
+ * @cq: pointer to the specific Control queue
+ * @is_rxq: true if receive control queue, false otherwise
+ *
+ * Initialize registers. The caller is expected to have already initialized the
+ * descriptor ring memory and buffer memory
+ */
+static enum iecm_status iecm_ctlq_init_regs(struct iecm_hw *hw,
+					    struct iecm_ctlq_info *cq,
+					    bool is_rxq)
+{
+	/* stub */
+}
+
+/**
+ * iecm_ctlq_init_rxq_bufs - populate receive queue descriptors with buf
+ * @cq: pointer to the specific Control queue
+ *
+ * Record the address of the receive queue DMA buffers in the descriptors.
+ * The buffers must have been previously allocated.
+ */
+static void iecm_ctlq_init_rxq_bufs(struct iecm_ctlq_info *cq)
+{
+	/* stub */
+}
+
+/**
+ * iecm_ctlq_shutdown - shutdown the CQ
+ * @hw: pointer to hw struct
+ * @cq: pointer to the specific Control queue
+ *
+ * The main shutdown routine for any controq queue
+ */
+static void iecm_ctlq_shutdown(struct iecm_hw *hw, struct iecm_ctlq_info *cq)
+{
+	/* stub */
+}
+
+/**
+ * iecm_ctlq_add - add one control queue
+ * @hw: pointer to hardware struct
+ * @q_info: info for queue to be created
+ * @cq: (output) double pointer to control queue to be created
+ *
+ * Allocate and initialize a control queue and add it to the control queue list.
+ * The cq parameter will be allocated/initialized and passed back to the caller
+ * if no errors occur.
+ *
+ * Note: iecm_ctlq_init must be called prior to any calls to iecm_ctlq_add
+ */
+enum iecm_status iecm_ctlq_add(struct iecm_hw *hw,
+			       struct iecm_ctlq_create_info *qinfo,
+			       struct iecm_ctlq_info **cq)
+{
+	/* stub */
+}
+
+/**
+ * iecm_ctlq_remove - deallocate and remove specified control queue
+ * @hw: pointer to hardware struct
+ * @cq: pointer to control queue to be removed
+ */
+void iecm_ctlq_remove(struct iecm_hw *hw,
+		      struct iecm_ctlq_info *cq)
+{
+	/* stub */
+}
+
+/**
+ * iecm_ctlq_init - main initialization routine for all control queues
+ * @hw: pointer to hardware struct
+ * @num_q: number of queues to initialize
+ * @q_info: array of structs containing info for each queue to be initialized
+ *
+ * This initializes any number and any type of control queues. This is an all
+ * or nothing routine; if one fails, all previously allocated queues will be
+ * destroyed. This must be called prior to using the individual add/remove
+ * APIs.
+ */
+enum iecm_status iecm_ctlq_init(struct iecm_hw *hw, u8 num_q,
+				struct iecm_ctlq_create_info *q_info)
+{
+	/* stub */
+}
+
+/**
+ * iecm_ctlq_deinit - destroy all control queues
+ * @hw: pointer to hw struct
+ */
+enum iecm_status iecm_ctlq_deinit(struct iecm_hw *hw)
+{
+	/* stub */
+}
+
+/**
+ * iecm_ctlq_send - send command to Control Queue (CTQ)
+ * @hw: pointer to hw struct
+ * @cq: handle to control queue struct to send on
+ * @num_q_msg: number of messages to send on control queue
+ * @q_msg: pointer to array of queue messages to be sent
+ *
+ * The caller is expected to allocate DMAable buffers and pass them to the
+ * send routine via the q_msg struct / control queue specific data struct.
+ * The control queue will hold a reference to each send message until
+ * the completion for that message has been cleaned.
+ */
+enum iecm_status iecm_ctlq_send(struct iecm_hw *hw,
+				struct iecm_ctlq_info *cq,
+				u16 num_q_msg,
+				struct iecm_ctlq_msg q_msg[])
+{
+	/* stub */
+}
+
+/**
+ * iecm_ctlq_clean_sq - reclaim send descriptors on HW write back for the
+ * requested queue
+ * @hw: pointer to hw struct
+ * @cq: pointer to the specific Control queue
+ * @clean_count: (input|output) number of descriptors to clean as input, and
+ * number of descriptors actually cleaned as output
+ * @msg_status: (output) pointer to msg pointer array to be populated; needs
+ * to be allocated by caller
+ *
+ * Returns an an array of message pointers associated with the cleaned
+ * descriptors. The pointers are to the original ctlq_msgs sent on the cleaned
+ * descriptors.  The status will be returned for each; any messages that failed
+ * to send will have a non-zero status. The caller is expected to free original
+ * ctlq_msgs and free or reuse the DMA buffers.
+ */
+enum iecm_status iecm_ctlq_clean_sq(struct iecm_hw *hw,
+				    struct iecm_ctlq_info *cq,
+				    u16 *clean_count,
+				    struct iecm_ctlq_msg *msg_status[])
+{
+	/* stub */
+}
+
+/**
+ * iecm_ctlq_post_rx_buffs - post buffers to descriptor ring
+ * @hw: pointer to hw struct
+ * @cq: pointer to control queue handle
+ * @buff_count: (input|output) input is number of buffers caller is trying to
+ * return; output is number of buffers that were not posted
+ * @buffs: array of pointers to DMA mem structs to be given to hardware
+ *
+ * Caller uses this function to return DMA buffers to the descriptor ring after
+ * consuming them; buff_count will be the number of buffers.
+ *
+ * Note: this function needs to be called after a receive call even
+ * if there are no DMA buffers to be returned, i.e. buff_count = 0,
+ * buffs = NULL to support direct commands
+ */
+enum iecm_status iecm_ctlq_post_rx_buffs(struct iecm_hw *hw,
+					 struct iecm_ctlq_info *cq,
+					 u16 *buff_count,
+					 struct iecm_dma_mem **buffs)
+{
+	/* stub */
+}
+
+/**
+ * iecm_ctlq_recv - receive control queue message call back
+ * @hw: pointer to hw struct
+ * @cq: pointer to control queue handle to receive on
+ * @num_q_msg: (input|output) input number of messages that should be received;
+ * output number of messages actually received
+ * @q_msg: (output) array of received control queue messages on this q;
+ * needs to be pre-allocated by caller for as many messages as requested
+ *
+ * Called by interrupt handler or polling mechanism. Caller is expected
+ * to free buffers
+ */
+enum iecm_status iecm_ctlq_recv(struct iecm_hw *hw,
+				struct iecm_ctlq_info *cq,
+				u16 *num_q_msg, struct iecm_ctlq_msg *q_msg)
+{
+	/* stub */
+}
diff --git a/drivers/net/ethernet/intel/iecm/iecm_controlq_setup.c b/drivers/net/ethernet/intel/iecm/iecm_controlq_setup.c
new file mode 100644
index 000000000000..2fd6e3d15a1a
--- /dev/null
+++ b/drivers/net/ethernet/intel/iecm/iecm_controlq_setup.c
@@ -0,0 +1,84 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2020, Intel Corporation. */
+
+#include <linux/net/intel/iecm_osdep.h>
+#include <linux/net/intel/iecm_type.h>
+
+/**
+ * iecm_ctlq_alloc_desc_ring - Allocate Control Queue (CQ) rings
+ * @hw: pointer to hw struct
+ * @cq: pointer to the specific Control queue
+ */
+static enum iecm_status
+iecm_ctlq_alloc_desc_ring(struct iecm_hw *hw,
+			  struct iecm_ctlq_info *cq)
+{
+	/* stub */
+}
+
+/**
+ * iecm_ctlq_alloc_bufs - Allocate Control Queue (CQ) buffers
+ * @hw: pointer to hw struct
+ * @cq: pointer to the specific Control queue
+ *
+ * Allocate the buffer head for all control queues, and if it's a receive
+ * queue, allocate DMA buffers
+ */
+static enum iecm_status iecm_ctlq_alloc_bufs(struct iecm_hw *hw,
+					     struct iecm_ctlq_info *cq)
+{
+	/* stub */
+}
+
+/**
+ * iecm_ctlq_free_desc_ring - Free Control Queue (CQ) rings
+ * @hw: pointer to hw struct
+ * @cq: pointer to the specific Control queue
+ *
+ * This assumes the posted send buffers have already been cleaned
+ * and de-allocated
+ */
+static void iecm_ctlq_free_desc_ring(struct iecm_hw *hw,
+				     struct iecm_ctlq_info *cq)
+{
+	/* stub */
+}
+
+/**
+ * iecm_ctlq_free_bufs - Free CQ buffer info elements
+ * @hw: pointer to hw struct
+ * @cq: pointer to the specific Control queue
+ *
+ * Free the DMA buffers for RX queues, and DMA buffer header for both RX and TX
+ * queues.  The upper layers are expected to manage freeing of TX DMA buffers
+ */
+static void iecm_ctlq_free_bufs(struct iecm_hw *hw, struct iecm_ctlq_info *cq)
+{
+	/* stub */
+}
+
+/**
+ * iecm_ctlq_dealloc_ring_res - Free memory allocated for control queue
+ * @hw: pointer to hw struct
+ * @cq: pointer to the specific Control queue
+ *
+ * Free the memory used by the ring, buffers and other related structures
+ */
+void iecm_ctlq_dealloc_ring_res(struct iecm_hw *hw, struct iecm_ctlq_info *cq)
+{
+	/* stub */
+}
+
+/**
+ * iecm_ctlq_alloc_ring_res - allocate memory for descriptor ring and bufs
+ * @hw: pointer to hw struct
+ * @cq: pointer to control queue struct
+ *
+ * Do *NOT* hold the lock when calling this as the memory allocation routines
+ * called are not going to be atomic context safe
+ */
+enum iecm_status iecm_ctlq_alloc_ring_res(struct iecm_hw *hw,
+					  struct iecm_ctlq_info *cq)
+{
+	/* stub */
+}
diff --git a/drivers/net/ethernet/intel/iecm/iecm_ethtool.c b/drivers/net/ethernet/intel/iecm/iecm_ethtool.c
new file mode 100644
index 000000000000..a6532592f2f4
--- /dev/null
+++ b/drivers/net/ethernet/intel/iecm/iecm_ethtool.c
@@ -0,0 +1,16 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (C) 2020 Intel Corporation */
+
+#include <linux/net/intel/iecm.h>
+
+/**
+ * iecm_set_ethtool_ops - Initialize ethtool ops struct
+ * @netdev: network interface device structure
+ *
+ * Sets ethtool ops struct in our netdev so that ethtool can call
+ * our functions.
+ */
+void iecm_set_ethtool_ops(struct net_device *netdev)
+{
+	/* stub */
+}
diff --git a/drivers/net/ethernet/intel/iecm/iecm_lib.c b/drivers/net/ethernet/intel/iecm/iecm_lib.c
new file mode 100644
index 000000000000..57a20204a7c8
--- /dev/null
+++ b/drivers/net/ethernet/intel/iecm/iecm_lib.c
@@ -0,0 +1,406 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (C) 2020 Intel Corporation */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/net/intel/iecm.h>
+
+static const struct net_device_ops iecm_netdev_ops_splitq;
+static const struct net_device_ops iecm_netdev_ops_singleq;
+extern int debug;
+
+/**
+ * iecm_mb_intr_rel_irq - Free the IRQ association with the OS
+ * @adapter: adapter structure
+ */
+static void iecm_mb_intr_rel_irq(struct iecm_adapter *adapter)
+{
+	/* stub */
+}
+
+/**
+ * iecm_intr_rel - Release interrupt capabilities and free memory
+ * @adapter: adapter to disable interrupts on
+ */
+static void iecm_intr_rel(struct iecm_adapter *adapter)
+{
+	/* stub */
+}
+
+/**
+ * iecm_mb_intr_clean - Interrupt handler for the mailbox
+ * @irq: interrupt number
+ * @data: pointer to the adapter structure
+ */
+irqreturn_t iecm_mb_intr_clean(int __always_unused irq, void *data)
+{
+	/* stub */
+}
+
+/**
+ * iecm_mb_irq_enable - Enable MSIX interrupt for the mailbox
+ * @adapter: adapter to get the hardware address for register write
+ */
+void iecm_mb_irq_enable(struct iecm_adapter *adapter)
+{
+	/* stub */
+}
+
+/**
+ * iecm_mb_intr_req_irq - Request IRQ for the mailbox interrupt
+ * @adapter: adapter structure to pass to the mailbox IRQ handler
+ */
+int iecm_mb_intr_req_irq(struct iecm_adapter *adapter)
+{
+	/* stub */
+}
+
+/**
+ * iecm_get_mb_vec_id - Get vector index for mailbox
+ * @adapter: adapter structure to access the vector chunks
+ *
+ * The first vector id in the requested vector chunks from the CP is for
+ * the mailbox
+ */
+void iecm_get_mb_vec_id(struct iecm_adapter *adapter)
+{
+	/* stub */
+}
+
+/**
+ * iecm_mb_intr_init - Initialize the mailbox interrupt
+ * @adapter: adapter structure to store the mailbox vector
+ */
+int iecm_mb_intr_init(struct iecm_adapter *adapter)
+{
+	/* stub */
+}
+
+/**
+ * iecm_intr_distribute - Distribute MSIX vectors
+ * @adapter: adapter structure to get the vports
+ *
+ * Distribute the MSIX vectors acquired from the OS to the vports based on the
+ * num of vectors requested by each vport
+ */
+void iecm_intr_distribute(struct iecm_adapter *adapter)
+{
+	/* stub */
+}
+
+/**
+ * iecm_intr_req - Request interrupt capabilities
+ * @adapter: adapter to enable interrupts on
+ *
+ * Returns 0 on success, negative on failure
+ */
+static int iecm_intr_req(struct iecm_adapter *adapter)
+{
+	/* stub */
+}
+
+/**
+ * iecm_cfg_netdev - Allocate, configure and register a netdev
+ * @vport: main vport structure
+ *
+ * Returns 0 on success, negative value on failure
+ */
+static int iecm_cfg_netdev(struct iecm_vport *vport)
+{
+	/* stub */
+}
+
+/**
+ * iecm_cfg_hw - Initialize HW struct
+ * @adapter: adapter to setup hw struct for
+ *
+ * Returns 0 on success, negative on failure
+ */
+static int iecm_cfg_hw(struct iecm_adapter *adapter)
+{
+	/* stub */
+}
+
+/**
+ * iecm_get_free_slot - get the next non-NULL location index in array
+ * @array: array to search
+ * @size: size of the array
+ * @curr: last known occupied index to be used as a search hint
+ *
+ * void * is being used to keep the functionality generic. This lets us use this
+ * function on any array of pointers.
+ */
+static int iecm_get_free_slot(void *array, int size, int curr)
+{
+	/* stub */
+}
+
+/**
+ * iecm_netdev_to_vport - get a vport handle from a netdev
+ * @netdev: network interface device structure
+ */
+struct iecm_vport *iecm_netdev_to_vport(struct net_device *netdev)
+{
+	/* stub */
+}
+
+/**
+ * iecm_netdev_to_adapter - get an adapter handle from a netdev
+ * @netdev: network interface device structure
+ */
+struct iecm_adapter *iecm_netdev_to_adapter(struct net_device *netdev)
+{
+	/* stub */
+}
+
+/**
+ * iecm_vport_stop - Disable a vport
+ * @vport: vport to disable
+ */
+static void iecm_vport_stop(struct iecm_vport *vport)
+{
+	/* stub */
+}
+
+/**
+ * iecm_stop - Disables a network interface
+ * @netdev: network interface device structure
+ *
+ * The stop entry point is called when an interface is de-activated by the OS,
+ * and the netdevice enters the DOWN state.  The hardware is still under the
+ * driver's control, but the netdev interface is disabled.
+ *
+ * Returns success only - not allowed to fail
+ */
+static int iecm_stop(struct net_device *netdev)
+{
+	/* stub */
+}
+
+/**
+ * iecm_vport_rel - Delete a vport and free its resources
+ * @vport: the vport being removed
+ *
+ * Returns 0 on success or < 0 on error
+ */
+int iecm_vport_rel(struct iecm_vport *vport)
+{
+	/* stub */
+}
+
+/**
+ * iecm_vport_rel_all - Delete all vports
+ * @adapter: adapter from which all vports are being removed
+ */
+static void iecm_vport_rel_all(struct iecm_adapter *adapter)
+{
+	/* stub */
+}
+
+/**
+ * iecm_vport_set_hsplit - enable or disable header split on a given vport
+ * @vport: virtual port
+ * @prog: bpf_program attached to an interface or NULL
+ */
+void iecm_vport_set_hsplit(struct iecm_vport *vport, struct bpf_prog *prog)
+{
+	/* stub */
+}
+
+/**
+ * iecm_vport_alloc - Allocates the next available struct vport in the adapter
+ * @adapter: board private structure
+ * @vport_type: type of vport
+ *
+ * returns a pointer to a vport on success, NULL on failure.
+ */
+static struct iecm_vport *
+iecm_vport_alloc(struct iecm_adapter *adapter, int vport_id)
+{
+	/* stub */
+}
+
+/**
+ * iecm_service_task - Delayed task for handling mailbox responses
+ * @work: work_struct handle to our data
+ *
+ */
+static void iecm_service_task(struct work_struct *work)
+{
+	/* stub */
+}
+
+/**
+ * iecm_up_complete - Complete interface up sequence
+ * @vport: virtual port structure
+ *
+ */
+static void iecm_up_complete(struct iecm_vport *vport)
+{
+	/* stub */
+}
+
+/**
+ * iecm_vport_open - Bring up a vport
+ * @vport: vport to bring up
+ */
+static int iecm_vport_open(struct iecm_vport *vport)
+{
+	/* stub */
+}
+
+/**
+ * iecm_init_task - Delayed initialization task
+ * @work: work_struct handle to our data
+ *
+ * Init task finishes up pending work started in probe.  Due to the asynchronous
+ * nature in which the device communicates with hardware, we may have to wait
+ * several milliseconds to get a response.  Instead of busy polling in probe,
+ * pulling it out into a delayed work task prevents us from bogging down the
+ * whole system waiting for a response from hardware.
+ */
+static void iecm_init_task(struct work_struct *work)
+{
+	/* stub */
+}
+
+/**
+ * iecm_api_init - Initialize and verify device API
+ * @adapter: driver specific private structure
+ *
+ * Returns 0 on success, negative on failure
+ */
+static int iecm_api_init(struct iecm_adapter *adapter)
+{
+	/* stub */
+}
+
+/**
+ * iecm_deinit_task - Device deinit routine
+ * @adapter: Driver specific private structure
+ *
+ * Extended remove logic which will be used for
+ * hard reset as well
+ */
+void iecm_deinit_task(struct iecm_adapter *adapter)
+{
+	/* stub */
+}
+
+/**
+ * iecm_init_hard_reset - Initiate a hardware reset
+ * @adapter: Driver specific private structure
+ *
+ * Deallocate the vports and all the resources associated with them and
+ * reallocate. Also reinitialize the mailbox
+ */
+static enum iecm_status
+iecm_init_hard_reset(struct iecm_adapter *adapter)
+{
+	/* stub */
+}
+
+/**
+ * iecm_vc_event_task - Handle virtchannel event logic
+ * @work: work queue struct
+ */
+static void iecm_vc_event_task(struct work_struct *work)
+{
+	/* stub */
+}
+
+/**
+ * iecm_initiate_soft_reset - Initiate a software reset
+ * @vport: virtual port data struct
+ * @reset_cause: reason for the soft reset
+ *
+ * Soft reset does not involve bringing down the mailbox queue and also we do
+ * not destroy vport.  Only queue resources are touched
+ */
+int iecm_initiate_soft_reset(struct iecm_vport *vport,
+			     enum iecm_flags reset_cause)
+{
+	/* stub */
+}
+
+/**
+ * iecm_probe - Device initialization routine
+ * @pdev: PCI device information struct
+ * @ent: entry in iecm_pci_tbl
+ * @adapter: driver specific private structure
+ *
+ * Returns 0 on success, negative on failure
+ */
+int iecm_probe(struct pci_dev *pdev,
+	       const struct pci_device_id __always_unused *ent,
+	       struct iecm_adapter *adapter)
+{
+	/* stub */
+}
+EXPORT_SYMBOL(iecm_probe);
+
+/**
+ * iecm_remove - Device removal routine
+ * @pdev: PCI device information struct
+ */
+void iecm_remove(struct pci_dev *pdev)
+{
+	/* stub */
+}
+EXPORT_SYMBOL(iecm_remove);
+
+/**
+ * iecm_shutdown - PCI callback for shutting down device
+ * @pdev: PCI device information struct
+ */
+void iecm_shutdown(struct pci_dev *pdev)
+{
+	/* stub */
+}
+EXPORT_SYMBOL(iecm_shutdown);
+
+/**
+ * iecm_open - Called when a network interface becomes active
+ * @netdev: network interface device structure
+ *
+ * The open entry point is called when a network interface is made
+ * active by the system (IFF_UP).  At this point all resources needed
+ * for transmit and receive operations are allocated, the interrupt
+ * handler is registered with the OS, the netdev watchdog is enabled,
+ * and the stack is notified that the interface is ready.
+ *
+ * Returns 0 on success, negative value on failure
+ */
+static int iecm_open(struct net_device *netdev)
+{
+	/* stub */
+}
+
+/**
+ * iecm_change_mtu - NDO callback to change the MTU
+ * @netdev: network interface device structure
+ * @new_mtu: new value for maximum frame size
+ *
+ * Returns 0 on success, negative on failure
+ */
+static int iecm_change_mtu(struct net_device *netdev, int new_mtu)
+{
+	/* stub */
+}
+
+static const struct net_device_ops iecm_netdev_ops_splitq = {
+	.ndo_open = iecm_open,
+	.ndo_stop = iecm_stop,
+	.ndo_start_xmit = iecm_tx_splitq_start,
+	.ndo_validate_addr = eth_validate_addr,
+	.ndo_get_stats64 = iecm_get_stats64,
+};
+
+static const struct net_device_ops iecm_netdev_ops_singleq = {
+	.ndo_open = iecm_open,
+	.ndo_stop = iecm_stop,
+	.ndo_start_xmit = iecm_tx_singleq_start,
+	.ndo_validate_addr = eth_validate_addr,
+	.ndo_change_mtu = iecm_change_mtu,
+	.ndo_get_stats64 = iecm_get_stats64,
+};
diff --git a/drivers/net/ethernet/intel/iecm/iecm_main.c b/drivers/net/ethernet/intel/iecm/iecm_main.c
new file mode 100644
index 000000000000..0644581fc746
--- /dev/null
+++ b/drivers/net/ethernet/intel/iecm/iecm_main.c
@@ -0,0 +1,47 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (C) 2020 Intel Corporation */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/net/intel/iecm.h>
+
+char iecm_drv_name[] = "iecm";
+#define DRV_SUMMARY	"Intel(R) Data Plane Function Linux Driver"
+static const char iecm_driver_string[] = DRV_SUMMARY;
+static const char iecm_copyright[] = "Copyright (c) 2020, Intel Corporation.";
+
+MODULE_AUTHOR("Intel Corporation, <linux.nics@intel.com>");
+MODULE_DESCRIPTION(DRV_SUMMARY);
+MODULE_LICENSE("GPL v2");
+
+int debug = -1;
+module_param(debug, int, 0644);
+#ifndef CONFIG_DYNAMIC_DEBUG
+MODULE_PARM_DESC(debug, "netif level (0=none,...,16=all), hw debug_mask (0x8XXXXXXX)");
+#else
+MODULE_PARM_DESC(debug, "netif level (0=none,...,16=all)");
+#endif /* !CONFIG_DYNAMIC_DEBUG */
+
+/**
+ * iecm_module_init - Driver registration routine
+ *
+ * iecm_module_init is the first routine called when the driver is
+ * loaded. All it does is register with the PCI subsystem.
+ */
+static int __init iecm_module_init(void)
+{
+	/* stub */
+}
+module_init(iecm_module_init);
+
+/**
+ * iecm_module_exit - Driver exit cleanup routine
+ *
+ * iecm_module_exit is called just before the driver is removed
+ * from memory.
+ */
+static void __exit iecm_module_exit(void)
+{
+	/* stub */
+}
+module_exit(iecm_module_exit);
diff --git a/drivers/net/ethernet/intel/iecm/iecm_osdep.c b/drivers/net/ethernet/intel/iecm/iecm_osdep.c
new file mode 100644
index 000000000000..d0534df357d0
--- /dev/null
+++ b/drivers/net/ethernet/intel/iecm/iecm_osdep.c
@@ -0,0 +1,15 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2020 Intel Corporation. */
+
+#include <linux/net/intel/iecm_osdep.h>
+#include <linux/net/intel/iecm.h>
+
+void *iecm_alloc_dma_mem(struct iecm_hw *hw, struct iecm_dma_mem *mem, u64 size)
+{
+	/* stub */
+}
+
+void iecm_free_dma_mem(struct iecm_hw *hw, struct iecm_dma_mem *mem)
+{
+	/* stub */
+}
diff --git a/drivers/net/ethernet/intel/iecm/iecm_singleq_txrx.c b/drivers/net/ethernet/intel/iecm/iecm_singleq_txrx.c
new file mode 100644
index 000000000000..a85471e72d66
--- /dev/null
+++ b/drivers/net/ethernet/intel/iecm/iecm_singleq_txrx.c
@@ -0,0 +1,255 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (C) 2020 Intel Corporation */
+
+#include <linux/prefetch.h>
+#include <linux/net/intel/iecm.h>
+
+/**
+ * iecm_tx_singleq_build_ctob - populate command tag offset and size
+ * @td_cmd: Command to be filled in desc
+ * @td_offset: Offset to be filled in desc
+ * @size: Size of the buffer
+ * @td_tag: VLAN tag to be filled
+ *
+ * Returns the 64 bit value populated with the input parameters
+ */
+static __le64
+iecm_tx_singleq_build_ctob(u64 td_cmd, u64 td_offset, unsigned int size,
+			   u64 td_tag)
+{
+	/* stub */
+}
+
+/**
+ * iecm_tx_singleq_csum - Enable Tx checksum offloads
+ * @first: pointer to first descriptor
+ * @off: pointer to struct that holds offload parameters
+ *
+ * Returns 0 or error (negative) if checksum offload
+ */
+static
+int iecm_tx_singleq_csum(struct iecm_tx_buf *first,
+			 struct iecm_tx_offload_params *off)
+{
+	/* stub */
+}
+
+/**
+ * iecm_tx_singleq_map - Build the Tx base descriptor
+ * @tx_q: queue to send buffer on
+ * @first: first buffer info buffer to use
+ * @offloads: pointer to struct that holds offload parameters
+ *
+ * This function loops over the skb data pointed to by *first
+ * and gets a physical address for each memory location and programs
+ * it and the length into the transmit base mode descriptor.
+ */
+static void
+iecm_tx_singleq_map(struct iecm_queue *tx_q, struct iecm_tx_buf *first,
+		    struct iecm_tx_offload_params *offloads)
+{
+	/* stub */
+}
+
+/**
+ * iecm_tx_singleq_frame - Sends buffer on Tx ring using base descriptors
+ * @skb: send buffer
+ * @tx_q: queue to send buffer on
+ *
+ * Returns NETDEV_TX_OK if sent, else an error code
+ */
+static netdev_tx_t
+iecm_tx_singleq_frame(struct sk_buff *skb, struct iecm_queue *tx_q)
+{
+	/* stub */
+}
+
+/**
+ * iecm_tx_singleq_start - Selects the right Tx queue to send buffer
+ * @skb: send buffer
+ * @netdev: network interface device structure
+ *
+ * Returns NETDEV_TX_OK if sent, else an error code
+ */
+netdev_tx_t iecm_tx_singleq_start(struct sk_buff *skb,
+				  struct net_device *netdev)
+{
+	/* stub */
+}
+
+/**
+ * iecm_tx_singleq_clean - Reclaim resources from queue
+ * @tx_q: Tx queue to clean
+ * @napi_budget: Used to determine if we are in netpoll
+ *
+ */
+static bool iecm_tx_singleq_clean(struct iecm_queue *tx_q, int napi_budget)
+{
+	/* stub */
+}
+
+/**
+ * iecm_tx_singleq_clean_all - Clean all Tx queues
+ * @q_vec: queue vector
+ * @budget: Used to determine if we are in netpoll
+ *
+ * Returns false if clean is not complete else returns true
+ */
+static inline bool
+iecm_tx_singleq_clean_all(struct iecm_q_vector *q_vec, int budget)
+{
+	/* stub */
+}
+
+/**
+ * iecm_rx_singleq_test_staterr - tests bits in Rx descriptor
+ * status and error fields
+ * @rx_desc: pointer to receive descriptor (in le64 format)
+ * @stat_err_bits: value to mask
+ *
+ * This function does some fast chicanery in order to return the
+ * value of the mask which is really only used for boolean tests.
+ * The status_error_ptype_len doesn't need to be shifted because it begins
+ * at offset zero.
+ */
+static bool
+iecm_rx_singleq_test_staterr(struct iecm_singleq_base_rx_desc *rx_desc,
+			     const u64 stat_err_bits)
+{
+	/* stub */
+}
+
+/**
+ * iecm_rx_singleq_is_non_eop - process handling of non-EOP buffers
+ * @rxq: Rx ring being processed
+ * @rx_desc: Rx descriptor for current buffer
+ * @skb: Current socket buffer containing buffer in progress
+ */
+static bool iecm_rx_singleq_is_non_eop(struct iecm_queue *rxq,
+				       struct iecm_singleq_base_rx_desc
+				       *rx_desc, struct sk_buff *skb)
+{
+	/* stub */
+}
+
+/**
+ * iecm_rx_singleq_csum - Indicate in skb if checksum is good
+ * @rxq: Rx descriptor ring packet is being transacted on
+ * @skb: skb currently being received and modified
+ * @rx_desc: the receive descriptor
+ * @ptype: the packet type decoded by hardware
+ *
+ * skb->protocol must be set before this function is called
+ */
+static void iecm_rx_singleq_csum(struct iecm_queue *rxq, struct sk_buff *skb,
+				 struct iecm_singleq_base_rx_desc *rx_desc,
+				 u8 ptype)
+{
+	/* stub */
+}
+
+/**
+ * iecm_rx_singleq_process_skb_fields - Populate skb header fields from Rx
+ * descriptor
+ * @rxq: Rx descriptor ring packet is being transacted on
+ * @skb: pointer to current skb being populated
+ *
+ * This function checks the ring, descriptor, and packet information in
+ * order to populate the hash, checksum, VLAN, protocol, and
+ * other fields within the skb.
+ */
+static void
+iecm_rx_singleq_process_skb_fields(struct iecm_queue *rxq, struct sk_buff *skb,
+				   struct iecm_singleq_base_rx_desc *rx_desc,
+				   u8 ptype)
+{
+	/* stub */
+}
+
+/**
+ * iecm_rx_singleq_buf_hw_alloc_all - Replace used receive buffers
+ * @rx_q: queue for which the hw buffers are allocated
+ * @cleaned_count: number of buffers to replace
+ *
+ * Returns false if all allocations were successful, true if any fail
+ */
+bool iecm_rx_singleq_buf_hw_alloc_all(struct iecm_queue *rx_q,
+				      u16 cleaned_count)
+{
+	/* stub */
+}
+
+/**
+ * iecm_singleq_rx_put_buf - wrapper function to clean and recycle buffers
+ * @rx_bufq: Rx descriptor queue to transact packets on
+ * @rx_buf: Rx buffer to pull data from
+
+ * This function will update the next_to_use/next_to_alloc if the current
+ * buffer is recycled.
+ */
+static void iecm_singleq_rx_put_buf(struct iecm_queue *rx_bufq,
+				    struct iecm_rx_buf *rx_buf)
+{
+	/* stub */
+}
+
+/**
+ * iecm_rx_bump_ntc - Bump and wrap q->next_to_clean value
+ * @q: queue to bump
+ */
+static void iecm_singleq_rx_bump_ntc(struct iecm_queue *q)
+{
+	/* stub */
+}
+
+/**
+ * iecm_singleq_rx_get_buf_page - Fetch Rx buffer page and synchronize data
+ * @rx_buf: Rx buf to fetch page for
+ * @size: size of buffer to add to skb
+ *
+ * This function will pull an Rx buffer page from the ring and synchronize it
+ * for use by the CPU.
+ */
+static struct sk_buff *
+iecm_singleq_rx_get_buf_page(struct device *dev, struct iecm_rx_buf *rx_buf,
+			     const unsigned int size)
+{
+	/* stub */
+}
+
+/**
+ * iecm_rx_singleq_clean - Reclaim resources after receive completes
+ * @rx_q: Rx queue to clean
+ * @budget: Total limit on number of packets to process
+ *
+ * Returns true if there's any budget left (e.g. the clean is finished)
+ */
+static int iecm_rx_singleq_clean(struct iecm_queue *rx_q, int budget)
+{
+	/* stub */
+}
+
+/**
+ * iecm_rx_singleq_clean_all - Clean all Rx queues
+ * @q_vec: queue vector
+ * @budget: Used to determine if we are in netpoll
+ * @cleaned: returns number of packets cleaned
+ *
+ * Returns false if clean is not complete else returns true
+ */
+static inline bool
+iecm_rx_singleq_clean_all(struct iecm_q_vector *q_vec, int budget,
+			  int *cleaned)
+{
+	/* stub */
+}
+
+/**
+ * iecm_vport_singleq_napi_poll - NAPI handler
+ * @napi: struct from which you get q_vector
+ * @budget: budget provided by stack
+ */
+int iecm_vport_singleq_napi_poll(struct napi_struct *napi, int budget)
+{
+	/* stub */
+}
diff --git a/drivers/net/ethernet/intel/iecm/iecm_txrx.c b/drivers/net/ethernet/intel/iecm/iecm_txrx.c
new file mode 100644
index 000000000000..b4688daa744d
--- /dev/null
+++ b/drivers/net/ethernet/intel/iecm/iecm_txrx.c
@@ -0,0 +1,1256 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (C) 2020 Intel Corporation */
+
+#include <linux/net/intel/iecm.h>
+
+/**
+ * iecm_buf_lifo_push - push a buffer pointer onto stack
+ * @stack: pointer to stack struct
+ * @buf: pointer to buf to push
+ **/
+static enum iecm_status iecm_buf_lifo_push(struct iecm_buf_lifo *stack,
+					   struct iecm_tx_buf *buf)
+{
+	/* stub */
+}
+
+/**
+ * iecm_buf_lifo_pop - pop a buffer pointer from stack
+ * @stack: pointer to stack struct
+ **/
+static struct iecm_tx_buf *iecm_buf_lifo_pop(struct iecm_buf_lifo *stack)
+{
+	/* stub */
+}
+
+/**
+ * iecm_get_stats64 - get statistics for network device structure
+ * @netdev: network interface device structure
+ * @stats: main device statistics structure
+ */
+void iecm_get_stats64(struct net_device *netdev,
+		      struct rtnl_link_stats64 *stats)
+{
+	/* stub */
+}
+
+/**
+ * iecm_tx_buf_rel - Release a Tx buffer
+ * @tx_q: the queue that owns the buffer
+ * @tx_buf: the buffer to free
+ */
+void iecm_tx_buf_rel(struct iecm_queue *tx_q, struct iecm_tx_buf *tx_buf)
+{
+	/* stub */
+}
+
+/**
+ * iecm_tx_buf_rel all - Free any empty Tx buffers
+ * @txq: queue to be cleaned
+ */
+void iecm_tx_buf_rel_all(struct iecm_queue *txq)
+{
+	/* stub */
+}
+
+/**
+ * iecm_tx_desc_rel - Free Tx resources per queue
+ * @txq: Tx descriptor ring for a specific queue
+ * @bufq: buffer q or completion q
+ *
+ * Free all transmit software resources
+ */
+void iecm_tx_desc_rel(struct iecm_queue *txq, bool bufq)
+{
+	/* stub */
+}
+
+/**
+ * iecm_tx_desc_rel_all - Free Tx Resources for All Queues
+ * @vport: virtual port structure
+ *
+ * Free all transmit software resources
+ */
+void iecm_tx_desc_rel_all(struct iecm_vport *vport)
+{
+	/* stub */
+}
+
+/**
+ * iecm_tx_buf_alloc_all - Allocate memory for all buffer resources
+ * @tx_q: queue for which the buffers are allocated
+ */
+static enum iecm_status iecm_tx_buf_alloc_all(struct iecm_queue *tx_q)
+{
+	/* stub */
+}
+
+/**
+ * iecm_tx_desc_alloc - Allocate the Tx descriptors
+ * @tx_q: the Tx ring to set up
+ * @bufq: buffer or completion queue
+ */
+static enum iecm_status iecm_tx_desc_alloc(struct iecm_queue *tx_q, bool bufq)
+{
+	/* stub */
+}
+
+/**
+ * iecm_tx_desc_alloc_all - allocate all queues Tx resources
+ * @vport: virtual port private structure
+ */
+static enum iecm_status iecm_tx_desc_alloc_all(struct iecm_vport *vport)
+{
+	/* stub */
+}
+
+/**
+ * iecm_rx_buf_rel - Release a Rx buffer
+ * @rxq: the queue that owns the buffer
+ * @rx_buf: the buffer to free
+ */
+static void iecm_rx_buf_rel(struct iecm_queue *rxq,
+			    struct iecm_rx_buf *rx_buf)
+{
+	/* stub */
+}
+
+/**
+ * iecm_rx_buf_rel_all - Free all Rx buffer resources for a queue
+ * @rxq: queue to be cleaned
+ */
+void iecm_rx_buf_rel_all(struct iecm_queue *rxq)
+{
+	/* stub */
+}
+
+/**
+ * iecm_rx_desc_rel - Free a specific Rx q resources
+ * @rxq: queue to clean the resources from
+ * @bufq: buffer q or completion q
+ * @q_model: single or split q model
+ *
+ * Free a specific Rx queue resources
+ */
+void iecm_rx_desc_rel(struct iecm_queue *rxq, bool bufq,
+		      enum virtchnl_queue_model q_model)
+{
+	/* stub */
+}
+
+/**
+ * iecm_rx_desc_rel_all - Free Rx Resources for All Queues
+ * @vport: virtual port structure
+ *
+ * Free all Rx queues resources
+ */
+void iecm_rx_desc_rel_all(struct iecm_vport *vport)
+{
+	/* stub */
+}
+
+/**
+ * iecm_rx_buf_hw_update - Store the new tail and head values
+ * @rxq: queue to bump
+ * @val: new head index
+ */
+void iecm_rx_buf_hw_update(struct iecm_queue *rxq, u32 val)
+{
+	/* stub */
+}
+
+/**
+ * iecm_rx_buf_hw_alloc - recycle or make a new page
+ * @rxq: ring to use
+ * @buf: rx_buffer struct to modify
+ *
+ * Returns true if the page was successfully allocated or
+ * reused.
+ */
+bool iecm_rx_buf_hw_alloc(struct iecm_queue *rxq, struct iecm_rx_buf *buf)
+{
+	/* stub */
+}
+
+/**
+ * iecm_rx_hdr_buf_hw_alloc - recycle or make a new page for header buffer
+ * @rxq: ring to use
+ * @hdr_buf: rx_buffer struct to modify
+ *
+ * Returns true if the page was successfully allocated or
+ * reused.
+ */
+bool iecm_rx_hdr_buf_hw_alloc(struct iecm_queue *rxq,
+			      struct iecm_rx_buf *hdr_buf)
+{
+	/* stub */
+}
+
+/**
+ * iecm_rx_buf_hw_alloc_all - Replace used receive buffers
+ * @rxq: queue for which the hw buffers are allocated
+ * @cleaned_count: number of buffers to replace
+ *
+ * Returns false if all allocations were successful, true if any fail
+ */
+static bool
+iecm_rx_buf_hw_alloc_all(struct iecm_queue *rxq,
+			 u16 cleaned_count)
+{
+	/* stub */
+}
+
+/**
+ * iecm_rx_buf_alloc_all - Allocate memory for all buffer resources
+ * @rxq: queue for which the buffers are allocated
+ */
+static enum iecm_status iecm_rx_buf_alloc_all(struct iecm_queue *rxq)
+{
+	/* stub */
+}
+
+/**
+ * iecm_rx_desc_alloc - Allocate queue Rx resources
+ * @rxq: Rx queue for which the resources are setup
+ * @bufq: buffer or completion queue
+ * @q_model: single or split queue model
+ */
+static enum iecm_status iecm_rx_desc_alloc(struct iecm_queue *rxq, bool bufq,
+					   enum virtchnl_queue_model q_model)
+{
+	/* stub */
+}
+
+/**
+ * iecm_rx_desc_alloc_all - allocate all RX queues resources
+ * @vport: virtual port structure
+ */
+static enum iecm_status iecm_rx_desc_alloc_all(struct iecm_vport *vport)
+{
+	/* stub */
+}
+
+/**
+ * iecm_txq_group_rel - Release all resources for txq groups
+ * @vport: vport to release txq groups on
+ */
+static void iecm_txq_group_rel(struct iecm_vport *vport)
+{
+	/* stub */
+}
+
+/**
+ * iecm_rxq_group_rel - Release all resources for rxq groups
+ * @vport: vport to release rxq groups on
+ */
+static void iecm_rxq_group_rel(struct iecm_vport *vport)
+{
+	/* stub */
+}
+
+/**
+ * iecm_vport_queue_grp_rel_all - Release all queue groups
+ * @vport: vport to release queue groups for
+ */
+static void iecm_vport_queue_grp_rel_all(struct iecm_vport *vport)
+{
+	/* stub */
+}
+
+/**
+ * iecm_vport_queues_rel - Free memory for all queues
+ * @vport: virtual port
+ *
+ * Free the memory allocated for queues associated to a vport
+ */
+void iecm_vport_queues_rel(struct iecm_vport *vport)
+{
+	/* stub */
+}
+
+/**
+ * iecm_vport_init_fast_path_txqs - Initialize fast path txq array
+ * @vport: vport to init txqs on
+ *
+ * We get a queue index from skb->queue_mapping and we need a fast way to
+ * dereference the queue from queue groups.  This allows us to quickly pull a
+ * txq based on a queue index.
+ */
+static enum iecm_status
+iecm_vport_init_fast_path_txqs(struct iecm_vport *vport)
+{
+	/* stub */
+}
+
+/**
+ * iecm_vport_init_num_qs - Initialize number of queues
+ * @vport: vport to initialize qs
+ * @vport_msg: data to be filled into vport
+ */
+void iecm_vport_init_num_qs(struct iecm_vport *vport,
+			    struct virtchnl_create_vport *vport_msg)
+{
+	/* stub */
+}
+
+/**
+ * iecm_vport_calc_num_q_desc - Calculate number of queue groups
+ * @vport: vport to calculate q groups for
+ */
+void iecm_vport_calc_num_q_desc(struct iecm_vport *vport)
+{
+	/* stub */
+}
+EXPORT_SYMBOL(iecm_vport_calc_num_q_desc);
+
+/**
+ * iecm_vport_calc_total_qs - Calculate total number of queues
+ * @vport_msg: message to fill with data
+ * @num_req_qs: user requested queues
+ */
+void iecm_vport_calc_total_qs(struct virtchnl_create_vport *vport_msg,
+			      int num_req_qs)
+{
+	/* stub */
+}
+
+/**
+ * iecm_vport_calc_num_q_groups - Calculate number of queue groups
+ * @vport: vport to calculate q groups for
+ */
+void iecm_vport_calc_num_q_groups(struct iecm_vport *vport)
+{
+	/* stub */
+}
+EXPORT_SYMBOL(iecm_vport_calc_num_q_groups);
+
+/**
+ * iecm_vport_calc_numq_per_grp - Calculate number of queues per group
+ * @vport: vport to calculate queues for
+ * @num_txq: int return parameter
+ * @num_rxq: int return parameter
+ */
+static void iecm_vport_calc_numq_per_grp(struct iecm_vport *vport,
+					 int *num_txq, int *num_rxq)
+{
+	/* stub */
+}
+
+/**
+ * iecm_vport_calc_num_q_vec - Calculate total number of vectors required for
+ * this vport
+ * @vport: virtual port
+ *
+ */
+void iecm_vport_calc_num_q_vec(struct iecm_vport *vport)
+{
+	/* stub */
+}
+
+/**
+ * iecm_txq_group_alloc - Allocate all txq group resources
+ * @vport: vport to allocate txq groups for
+ * @num_txq: number of txqs to allocate for each group
+ */
+static enum iecm_status iecm_txq_group_alloc(struct iecm_vport *vport,
+					     int num_txq)
+{
+	/* stub */
+}
+
+/**
+ * iecm_rxq_group_alloc - Allocate all rxq group resources
+ * @vport: vport to allocate rxq groups for
+ * @num_rxq: number of rxqs to allocate for each group
+ */
+static enum iecm_status iecm_rxq_group_alloc(struct iecm_vport *vport,
+					     int num_rxq)
+{
+	/* stub */
+}
+
+/**
+ * iecm_vport_queue_grp_alloc_all - Allocate all queue groups/resources
+ * @vport: vport with qgrps to allocate
+ */
+static enum iecm_status
+iecm_vport_queue_grp_alloc_all(struct iecm_vport *vport)
+{
+	/* stub */
+}
+
+/**
+ * iecm_vport_queues_alloc - Allocate memory for all queues
+ * @vport: virtual port
+ *
+ * Allocate memory for queues associated with a vport
+ */
+enum iecm_status iecm_vport_queues_alloc(struct iecm_vport *vport)
+{
+	/* stub */
+}
+
+/**
+ * iecm_tx_find_q - Find the Tx q based on q id
+ * @vport: the vport we care about
+ * @q_id: Id of the queue
+ *
+ * Returns queue ptr if found else returns NULL
+ */
+static struct iecm_queue *
+iecm_tx_find_q(struct iecm_vport *vport, int q_id)
+{
+	/* stub */
+}
+
+/**
+ * iecm_tx_handle_sw_marker - Handle queue marker packet
+ * @tx_q: Tx queue to handle software marker
+ */
+static void iecm_tx_handle_sw_marker(struct iecm_queue *tx_q)
+{
+	/* stub */
+}
+
+/**
+ * iecm_tx_splitq_clean_buf - Clean TX buffer resources
+ * @tx_q: Tx queue to clean buffer from
+ * @tx_buf: buffer to be cleaned
+ * @napi_budget: Used to determine if we are in netpoll
+ *
+ * Returns the stats (bytes/packets) cleaned from this buffer
+ */
+static struct iecm_tx_queue_stats
+iecm_tx_splitq_clean_buf(struct iecm_queue *tx_q, struct iecm_tx_buf *tx_buf,
+			 int napi_budget)
+{
+	/* stub */
+}
+
+/**
+ * iecm_stash_flow_sch_buffers - store buffere parameter info to be freed at a
+ * later time (only relevant for flow scheduling mode)
+ * @txq: Tx queue to clean
+ * @tx_buf: buffer to store
+ */
+static int
+iecm_stash_flow_sch_buffers(struct iecm_queue *txq, struct iecm_tx_buf *tx_buf)
+{
+	/* stub */
+}
+
+/**
+ * iecm_tx_splitq_clean - Reclaim resources from buffer queue
+ * @tx_q: Tx queue to clean
+ * @end: queue index until which it should be cleaned
+ * @napi_budget: Used to determine if we are in netpoll
+ * @descs_only: true if queue is using flow-based scheduling and should
+ * not clean buffers at this time
+ *
+ * Cleans the queue descriptor ring. If the queue is using queue-based
+ * scheduling, the buffers will be cleaned as well and this function will
+ * return the number of bytes/packets cleaned. If the queue is using flow-based
+ * scheduling, only the descriptors are cleaned at this time. Separate packet
+ * completion events will be reported on the completion queue, and the
+ * buffers will be cleaned separately. The stats returned from this function
+ * when using flow-based scheduling are irrelevant.
+ */
+static struct iecm_tx_queue_stats
+iecm_tx_splitq_clean(struct iecm_queue *tx_q, u16 end, int napi_budget,
+		     bool descs_only)
+{
+	/* stub */
+}
+
+/**
+ * iecm_tx_hw_tstamp - report hw timestamp from completion desc to stack
+ * @skb: original skb
+ * @desc_ts: pointer to 3 byte timestamp from descriptor
+ */
+static inline void iecm_tx_hw_tstamp(struct sk_buff *skb, u8 *desc_ts)
+{
+	/* stub */
+}
+
+/**
+ * iecm_tx_clean_flow_sch_bufs - clean bufs that were stored for
+ * out of order completions
+ * @txq: queue to clean
+ * @compl_tag: completion tag of packet to clean (from completion descriptor)
+ * @desc_ts: pointer to 3 byte timestamp from descriptor
+ * @budget: Used to determine if we are in netpoll
+ */
+static struct iecm_tx_queue_stats
+iecm_tx_clean_flow_sch_bufs(struct iecm_queue *txq, u16 compl_tag,
+			    u8 *desc_ts, int budget)
+{
+	/* stub */
+}
+
+/**
+ * iecm_tx_clean_complq - Reclaim resources on completion queue
+ * @complq: Tx ring to clean
+ * @budget: Used to determine if we are in netpoll
+ *
+ * Returns true if there's any budget left (e.g. the clean is finished)
+ */
+static bool
+iecm_tx_clean_complq(struct iecm_queue *complq, int budget)
+{
+	/* stub */
+}
+
+/**
+ * iecm_tx_splitq_build_ctb - populate command tag and size for queue
+ * based scheduling descriptors
+ * @desc: descriptor to populate
+ * @parms: pointer to Tx params struct
+ * @td_cmd: command to be filled in desc
+ * @size: size of buffer
+ */
+static inline void
+iecm_tx_splitq_build_ctb(union iecm_tx_flex_desc *desc,
+			 struct iecm_tx_splitq_params *parms,
+			 u16 td_cmd, u16 size)
+{
+	/* stub */
+}
+
+/**
+ * iecm_tx_splitq_build_flow_desc - populate command tag and size for flow
+ * scheduling descriptors
+ * @desc: descriptor to populate
+ * @parms: pointer to Tx params struct
+ * @td_cmd: command to be filled in desc
+ * @size: size of buffer
+ */
+static inline void
+iecm_tx_splitq_build_flow_desc(union iecm_tx_flex_desc *desc,
+			       struct iecm_tx_splitq_params *parms,
+			       u16 td_cmd, u16 size)
+{
+	/* stub */
+}
+
+/**
+ * __iecm_tx_maybe_stop - 2nd level check for Tx stop conditions
+ * @tx_q: the queue to be checked
+ * @size: the size buffer we want to assure is available
+ *
+ * Returns -EBUSY if a stop is needed, else 0
+ */
+static int
+__iecm_tx_maybe_stop(struct iecm_queue *tx_q, unsigned int size)
+{
+	/* stub */
+}
+
+/**
+ * iecm_tx_maybe_stop - 1st level check for Tx stop conditions
+ * @tx_q: the queue to be checked
+ * @size: number of descriptors we want to assure is available
+ *
+ * Returns 0 if stop is not needed
+ */
+int iecm_tx_maybe_stop(struct iecm_queue *tx_q, unsigned int size)
+{
+	/* stub */
+}
+
+/**
+ * iecm_tx_buf_hw_update - Store the new tail and head values
+ * @tx_q: queue to bump
+ * @val: new head index
+ * @skb: skb for which the descriptors are updated
+ */
+void iecm_tx_buf_hw_update(struct iecm_queue *tx_q, u32 val,
+			   struct sk_buff *skb)
+{
+	/* stub */
+}
+
+/**
+ * __iecm_tx_desc_count required - Get the number of descriptors needed for Tx
+ * @size: transmit request size in bytes
+ *
+ * Due to hardware alignment restrictions (4K alignment), we need to
+ * assume that we can have no more than 12K of data per descriptor, even
+ * though each descriptor can take up to 16K - 1 bytes of aligned memory.
+ * Thus, we need to divide by 12K. But division is slow! Instead,
+ * we decompose the operation into shifts and one relatively cheap
+ * multiply operation.
+ *
+ * To divide by 12K, we first divide by 4K, then divide by 3:
+ *     To divide by 4K, shift right by 12 bits
+ *     To divide by 3, multiply by 85, then divide by 256
+ *     (Divide by 256 is done by shifting right by 8 bits)
+ * Finally, we add one to round up. Because 256 isn't an exact multiple of
+ * 3, we'll underestimate near each multiple of 12K. This is actually more
+ * accurate as we have 4K - 1 of wiggle room that we can fit into the last
+ * segment. For our purposes this is accurate out to 1M which is orders of
+ * magnitude greater than our largest possible GSO size.
+ *
+ * This would then be implemented as:
+ *     return (((size >> 12) * 85) >> 8) + IECM_TX_DESCS_FOR_SKB_DATA_PTR;
+ *
+ * Since multiplication and division are commutative, we can reorder
+ * operations into:
+ *     return ((size * 85) >> 20) + IECM_TX_DESCS_FOR_SKB_DATA_PTR;
+ */
+static unsigned int __iecm_tx_desc_count_required(unsigned int size)
+{
+	/* stub */
+}
+
+/**
+ * iecm_tx_desc_count_required - calculate number of Tx descriptors needed
+ * @skb: send buffer
+ *
+ * Returns number of data descriptors needed for this skb.
+ */
+unsigned int iecm_tx_desc_count_required(struct sk_buff *skb)
+{
+	/* stub */
+}
+
+/**
+ * iecm_tx_splitq_map - Build the Tx flex descriptor
+ * @tx_q: queue to send buffer on
+ * @off: pointer to offload params struct
+ * @first: first buffer info buffer to use
+ *
+ * This function loops over the skb data pointed to by *first
+ * and gets a physical address for each memory location and programs
+ * it and the length into the transmit flex descriptor.
+ */
+static void
+iecm_tx_splitq_map(struct iecm_queue *tx_q,
+		   struct iecm_tx_offload_params *off,
+		   struct iecm_tx_buf *first)
+{
+	/* stub */
+}
+
+/**
+ * iecm_tso - computes mss and TSO length to prepare for TSO
+ * @first: pointer to struct iecm_tx_buf
+ * @off: pointer to struct that holds offload parameters
+ *
+ * Returns error (negative) if TSO doesn't apply to the given skb,
+ * 0 otherwise.
+ *
+ * Note: this function can be used in the splitq and singleq paths
+ */
+static int iecm_tso(struct iecm_tx_buf *first,
+		    struct iecm_tx_offload_params *off)
+{
+	/* stub */
+}
+
+/**
+ * iecm_tx_splitq_frame - Sends buffer on Tx ring using flex descriptors
+ * @skb: send buffer
+ * @tx_q: queue to send buffer on
+ *
+ * Returns NETDEV_TX_OK if sent, else an error code
+ */
+static netdev_tx_t
+iecm_tx_splitq_frame(struct sk_buff *skb, struct iecm_queue *tx_q)
+{
+	/* stub */
+}
+
+/**
+ * iecm_tx_splitq_start - Selects the right Tx queue to send buffer
+ * @skb: send buffer
+ * @netdev: network interface device structure
+ *
+ * Returns NETDEV_TX_OK if sent, else an error code
+ */
+netdev_tx_t iecm_tx_splitq_start(struct sk_buff *skb,
+				 struct net_device *netdev)
+{
+	/* stub */
+}
+
+/**
+ * iecm_ptype_to_htype - get a hash type
+ * @vport: virtual port data
+ * @ptype: the ptype value from the descriptor
+ *
+ * Returns appropriate hash type (such as PKT_HASH_TYPE_L2/L3/L4) to be used by
+ * skb_set_hash based on PTYPE as parsed by HW Rx pipeline and is part of
+ * Rx desc.
+ */
+static enum pkt_hash_types iecm_ptype_to_htype(struct iecm_vport *vport,
+					       u16 ptype)
+{
+	/* stub */
+}
+
+/**
+ * iecm_rx_hash - set the hash value in the skb
+ * @rxq: Rx descriptor ring packet is being transacted on
+ * @skb: pointer to current skb being populated
+ * @rx_desc: Receive descriptor
+ * @ptype: the packet type decoded by hardware
+ */
+static void
+iecm_rx_hash(struct iecm_queue *rxq, struct sk_buff *skb,
+	     struct iecm_flex_rx_desc *rx_desc, u16 ptype)
+{
+	/* stub */
+}
+
+/**
+ * iecm_rx_csum - Indicate in skb if checksum is good
+ * @rxq: Rx descriptor ring packet is being transacted on
+ * @skb: pointer to current skb being populated
+ * @rx_desc: Receive descriptor
+ * @ptype: the packet type decoded by hardware
+ *
+ * skb->protocol must be set before this function is called
+ */
+static void
+iecm_rx_csum(struct iecm_queue *rxq, struct sk_buff *skb,
+	     struct iecm_flex_rx_desc *rx_desc, u16 ptype)
+{
+	/* stub */
+}
+
+/**
+ * iecm_rx_rsc - Set the RSC fields in the skb
+ * @rxq : Rx descriptor ring packet is being transacted on
+ * @skb : pointer to current skb being populated
+ * @rx_desc: Receive descriptor
+ * @ptype: the packet type decoded by hardware
+ *
+ * Populate the skb fields with the total number of RSC segments, RSC payload
+ * length and packet type.
+ */
+static bool iecm_rx_rsc(struct iecm_queue *rxq, struct sk_buff *skb,
+			struct iecm_flex_rx_desc *rx_desc, u16 ptype)
+{
+	/* stub */
+}
+
+/**
+ * iecm_rx_hwtstamp - check for an RX timestamp and pass up
+ * the stack
+ * @rx_desc: pointer to Rx descriptor containing timestamp
+ * @skb: skb to put timestamp in
+ */
+static void iecm_rx_hwtstamp(struct iecm_flex_rx_desc *rx_desc,
+			     struct sk_buff __maybe_unused *skb)
+{
+	/* stub */
+}
+
+/**
+ * iecm_rx_process_skb_fields - Populate skb header fields from Rx descriptor
+ * @rxq: Rx descriptor ring packet is being transacted on
+ * @skb: pointer to current skb being populated
+ * @rx_desc: Receive descriptor
+ *
+ * This function checks the ring, descriptor, and packet information in
+ * order to populate the hash, checksum, VLAN, protocol, and
+ * other fields within the skb.
+ */
+static bool
+iecm_rx_process_skb_fields(struct iecm_queue *rxq, struct sk_buff *skb,
+			   struct iecm_flex_rx_desc *rx_desc)
+{
+	/* stub */
+}
+
+/**
+ * iecm_rx_skb - Send a completed packet up the stack
+ * @rxq: Rx ring in play
+ * @skb: packet to send up
+ *
+ * This function sends the completed packet (via. skb) up the stack using
+ * GRO receive functions
+ */
+void iecm_rx_skb(struct iecm_queue *rxq, struct sk_buff *skb)
+{
+	/* stub */
+}
+
+/**
+ * iecm_rx_page_is_reserved - check if reuse is possible
+ * @page: page struct to check
+ */
+static bool iecm_rx_page_is_reserved(struct page *page)
+{
+	/* stub */
+}
+
+/**
+ * iecm_rx_buf_adjust_pg_offset - Prepare Rx buffer for reuse
+ * @rx_buf: Rx buffer to adjust
+ * @size: Size of adjustment
+ *
+ * Update the offset within page so that Rx buf will be ready to be reused.
+ * For systems with PAGE_SIZE < 8192 this function will flip the page offset
+ * so the second half of page assigned to Rx buffer will be used, otherwise
+ * the offset is moved by the @size bytes
+ */
+static void
+iecm_rx_buf_adjust_pg_offset(struct iecm_rx_buf *rx_buf, unsigned int size)
+{
+	/* stub */
+}
+
+/**
+ * iecm_rx_can_reuse_page - Determine if page can be reused for another Rx
+ * @rx_buf: buffer containing the page
+ *
+ * If page is reusable, we have a green light for calling iecm_reuse_rx_page,
+ * which will assign the current buffer to the buffer that next_to_alloc is
+ * pointing to; otherwise, the DMA mapping needs to be destroyed and
+ * page freed
+ */
+static bool iecm_rx_can_reuse_page(struct iecm_rx_buf *rx_buf)
+{
+	/* stub */
+}
+
+/**
+ * iecm_rx_add_frag - Add contents of Rx buffer to sk_buff as a frag
+ * @rx_buf: buffer containing page to add
+ * @skb: sk_buff to place the data into
+ * @size: packet length from rx_desc
+ *
+ * This function will add the data contained in rx_buf->page to the skb.
+ * It will just attach the page as a frag to the skb.
+ * The function will then update the page offset.
+ */
+void iecm_rx_add_frag(struct iecm_rx_buf *rx_buf, struct sk_buff *skb,
+		      unsigned int size)
+{
+	/* stub */
+}
+
+/**
+ * iecm_rx_reuse_page - page flip buffer and store it back on the queue
+ * @rx_bufq: Rx descriptor ring to store buffers on
+ * @hsplit: true if header buffer, false otherwise
+ * @old_buf: donor buffer to have page reused
+ *
+ * Synchronizes page for reuse by the adapter
+ */
+void iecm_rx_reuse_page(struct iecm_queue *rx_bufq,
+			bool hsplit,
+			struct iecm_rx_buf *old_buf)
+{
+	/* stub */
+}
+
+/**
+ * iecm_rx_get_buf_page - Fetch Rx buffer page and synchronize data for use
+ * @rx_buf: Rx buf to fetch page for
+ * @size: size of buffer to add to skb
+ *
+ * This function will pull an Rx buffer page from the ring and synchronize it
+ * for use by the CPU.
+ */
+static void
+iecm_rx_get_buf_page(struct device *dev, struct iecm_rx_buf *rx_buf,
+		     const unsigned int size)
+{
+	/* stub */
+}
+
+/**
+ * iecm_rx_construct_skb - Allocate skb and populate it
+ * @rxq: Rx descriptor queue
+ * @rx_buf: Rx buffer to pull data from
+ * @size: the length of the packet
+ *
+ * This function allocates an skb. It then populates it with the page
+ * data from the current receive descriptor, taking care to set up the
+ * skb correctly.
+ */
+struct sk_buff *
+iecm_rx_construct_skb(struct iecm_queue *rxq, struct iecm_rx_buf *rx_buf,
+		      unsigned int size)
+{
+	/* stub */
+}
+
+/**
+ * iecm_rx_cleanup_headers - Correct empty headers
+ * @skb: pointer to current skb being fixed
+ *
+ * Also address the case where we are pulling data in on pages only
+ * and as such no data is present in the skb header.
+ *
+ * In addition if skb is not at least 60 bytes we need to pad it so that
+ * it is large enough to qualify as a valid Ethernet frame.
+ *
+ * Returns true if an error was encountered and skb was freed.
+ */
+bool iecm_rx_cleanup_headers(struct sk_buff *skb)
+{
+	/* stub */
+}
+
+/**
+ * iecm_rx_splitq_test_staterr - tests bits in Rx descriptor
+ * status and error fields
+ * @stat_err_field: field from descriptor to test bits in
+ * @stat_err_bits: value to mask
+ *
+ */
+static bool
+iecm_rx_splitq_test_staterr(u8 stat_err_field, const u8 stat_err_bits)
+{
+	/* stub */
+}
+
+/**
+ * iecm_rx_splitq_is_non_eop - process handling of non-EOP buffers
+ * @rx_desc: Rx descriptor for current buffer
+ *
+ * If the buffer is an EOP buffer, this function exits returning false,
+ * otherwise return true indicating that this is in fact a non-EOP buffer.
+ */
+static bool
+iecm_rx_splitq_is_non_eop(struct iecm_flex_rx_desc *rx_desc)
+{
+	/* stub */
+}
+
+/**
+ * iecm_rx_recycle_buf - Clean up used buffer and either recycle or free
+ * @rx_bufq: Rx descriptor queue to transact packets on
+ * @hsplit: true if buffer is a header buffer
+ * @rx_buf: Rx buffer to pull data from
+ *
+ * This function will clean up the contents of the rx_buf. It will either
+ * recycle the buffer or unmap it and free the associated resources.
+ *
+ * Returns true if the buffer is reused, false if the buffer is freed.
+ */
+bool iecm_rx_recycle_buf(struct iecm_queue *rx_bufq, bool hsplit,
+			 struct iecm_rx_buf *rx_buf)
+{
+	/* stub */
+}
+
+/**
+ * iecm_rx_splitq_put_bufs - wrapper function to clean and recycle buffers
+ * @rx_bufq: Rx descriptor queue to transact packets on
+ * @hdr_buf: Rx header buffer to pull data from
+ * @rx_buf: Rx buffer to pull data from
+ *
+ * This function will update the next_to_use/next_to_alloc if the current
+ * buffer is recycled.
+ */
+static void iecm_rx_splitq_put_bufs(struct iecm_queue *rx_bufq,
+				    struct iecm_rx_buf *hdr_buf,
+				    struct iecm_rx_buf *rx_buf)
+{
+	/* stub */
+}
+
+/**
+ * iecm_rx_bump_ntc - Bump and wrap q->next_to_clean value
+ * @q: queue to bump
+ */
+static void iecm_rx_bump_ntc(struct iecm_queue *q)
+{
+	/* stub */
+}
+
+/**
+ * iecm_rx_splitq_clean - Clean completed descriptors from Rx queue
+ * @rxq: Rx descriptor queue to retrieve receive buffer queue
+ * @budget: Total limit on number of packets to process
+ *
+ * This function provides a "bounce buffer" approach to Rx interrupt
+ * processing. The advantage to this is that on systems that have
+ * expensive overhead for IOMMU access this provides a means of avoiding
+ * it by maintaining the mapping of the page to the system.
+ *
+ * Returns amount of work completed
+ */
+static int iecm_rx_splitq_clean(struct iecm_queue *rxq, int budget)
+{
+	/* stub */
+}
+
+/**
+ * iecm_vport_intr_clean_queues - MSIX mode Interrupt Handler
+ * @irq: interrupt number
+ * @data: pointer to a q_vector
+ *
+ */
+irqreturn_t
+iecm_vport_intr_clean_queues(int __always_unused irq, void *data)
+{
+	/* stub */
+}
+
+/**
+ * iecm_vport_intr_napi_dis_all - Disable NAPI for all q_vectors in the vport
+ * @vport: main vport structure
+ */
+static void iecm_vport_intr_napi_dis_all(struct iecm_vport *vport)
+{
+	/* stub */
+}
+
+/**
+ * iecm_vport_intr_rel - Free memory allocated for interrupt vectors
+ * @vport: virtual port
+ *
+ * Free the memory allocated for interrupt vectors  associated to a vport
+ */
+static void iecm_vport_intr_rel(struct iecm_vport *vport)
+{
+	/* stub */
+}
+
+/**
+ * iecm_vport_intr_rel_irq - Free the IRQ association with the OS
+ * @vport: main vport structure
+ */
+static void iecm_vport_intr_rel_irq(struct iecm_vport *vport)
+{
+	/* stub */
+}
+
+/**
+ * iecm_vport_intr_dis_irq_all - Disable each interrupt
+ * @vport: main vport structure
+ */
+void iecm_vport_intr_dis_irq_all(struct iecm_vport *vport)
+{
+	/* stub */
+}
+
+/**
+ * iecm_vport_intr_buildreg_itr - Enable default interrupt generation settings
+ * @q_vector: pointer to q_vector
+ * @type: ITR index
+ * @itr: ITR value
+ */
+static u32 iecm_vport_intr_buildreg_itr(struct iecm_q_vector *q_vector,
+					const int type, u16 itr)
+{
+	/* stub */
+}
+
+static inline unsigned int iecm_itr_divisor(struct iecm_q_vector *q_vector)
+{
+	/* stub */
+}
+
+/**
+ * iecm_vport_intr_set_new_itr - update the ITR value based on statistics
+ * @q_vector: structure containing interrupt and ring information
+ * @itr: structure containing queue performance data
+ * @q_type: queue type
+ *
+ * Stores a new ITR value based on packets and byte
+ * counts during the last interrupt.  The advantage of per interrupt
+ * computation is faster updates and more accurate ITR for the current
+ * traffic pattern.  Constants in this function were computed
+ * based on theoretical maximum wire speed and thresholds were set based
+ * on testing data as well as attempting to minimize response time
+ * while increasing bulk throughput.
+ */
+static void iecm_vport_intr_set_new_itr(struct iecm_q_vector *q_vector,
+					struct iecm_itr *itr,
+					enum virtchnl_queue_type q_type)
+{
+	/* stub */
+}
+
+/**
+ * iecm_vport_intr_update_itr_ena_irq - Update ITR and re-enable MSIX interrupt
+ * @q_vector: q_vector for which ITR is being updated and interrupt enabled
+ */
+void iecm_vport_intr_update_itr_ena_irq(struct iecm_q_vector *q_vector)
+{
+	/* stub */
+}
+
+/**
+ * iecm_vport_intr_req_irq - get MSI-X vectors from the OS for the vport
+ * @vport: main vport structure
+ * @basename: name for the vector
+ */
+static int
+iecm_vport_intr_req_irq(struct iecm_vport *vport, char *basename)
+{
+	/* stub */
+}
+
+/**
+ * iecm_vport_intr_ena_irq_all - Enable IRQ for the given vport
+ * @vport: main vport structure
+ */
+void iecm_vport_intr_ena_irq_all(struct iecm_vport *vport)
+{
+	/* stub */
+}
+
+/**
+ * iecm_vport_intr_deinit - Release all vector associations for the vport
+ * @vport: main vport structure
+ */
+void iecm_vport_intr_deinit(struct iecm_vport *vport)
+{
+	/* stub */
+}
+
+/**
+ * iecm_vport_intr_napi_ena_all - Enable NAPI for all q_vectors in the vport
+ * @vport: main vport structure
+ */
+static void
+iecm_vport_intr_napi_ena_all(struct iecm_vport *vport)
+{
+	/* stub */
+}
+
+/**
+ * iecm_tx_splitq_clean_all- Clean completion queues
+ * @q_vec: queue vector
+ * @budget: Used to determine if we are in netpoll
+ *
+ * Returns false if clean is not complete else returns true
+ */
+static inline bool
+iecm_tx_splitq_clean_all(struct iecm_q_vector *q_vec, int budget)
+{
+	/* stub */
+}
+
+/**
+ * iecm_rx_splitq_clean_all- Clean completion queues
+ * @q_vec: queue vector
+ * @budget: Used to determine if we are in netpoll
+ * @cleaned: returns number of packets cleaned
+ *
+ * Returns false if clean is not complete else returns true
+ */
+static inline bool
+iecm_rx_splitq_clean_all(struct iecm_q_vector *q_vec, int budget,
+			 int *cleaned)
+{
+	/* stub */
+}
+
+/**
+ * iecm_vport_splitq_napi_poll - NAPI handler
+ * @napi: struct from which you get q_vector
+ * @budget: budget provided by stack
+ */
+int iecm_vport_splitq_napi_poll(struct napi_struct *napi, int budget)
+{
+	/* stub */
+}
+
+/**
+ * iecm_vport_intr_map_vector_to_qs - Map vectors to queues
+ * @vport: virtual port
+ *
+ * Mapping for vectors to queues
+ */
+void iecm_vport_intr_map_vector_to_qs(struct iecm_vport *vport)
+{
+	/* stub */
+}
+
+/**
+ * iecm_vport_intr_init_vec_idx - Initialize the vector indexes
+ * @vport: virtual port
+ *
+ * Initialize vector indexes with values returned over mailbox
+ */
+static int iecm_vport_intr_init_vec_idx(struct iecm_vport *vport)
+{
+	/* stub */
+}
+
+/**
+ * iecm_vport_intr_alloc - Allocate memory for interrupt vectors
+ * @vport: virtual port
+ *
+ * We allocate one q_vector per queue interrupt. If allocation fails we
+ * return -ENOMEM.
+ */
+int iecm_vport_intr_alloc(struct iecm_vport *vport)
+{
+	/* stub */
+}
+
+/**
+ * iecm_vport_intr_init - Setup all vectors for the given vport
+ * @vport: virtual port
+ *
+ * Returns 0 on success or negative on failure
+ */
+int iecm_vport_intr_init(struct iecm_vport *vport)
+{
+	/* stub */
+}
+EXPORT_SYMBOL(iecm_vport_calc_num_q_vec);
+
+/**
+ * iecm_config_rss - Prepare for RSS
+ * @vport: virtual port
+ *
+ * Return 0 on success, negative on failure
+ */
+int iecm_config_rss(struct iecm_vport *vport)
+{
+	/* stub */
+}
+
+/**
+ * iecm_get_rx_qid_list - Create a list of RX QIDs
+ * @vport: virtual port
+ *
+ * qid_list is created and freed by the caller
+ */
+void iecm_get_rx_qid_list(struct iecm_vport *vport, u16 *qid_list)
+{
+	/* stub */
+}
+
+/**
+ * iecm_fill_dflt_rss_lut - Fill the indirection table with the default values
+ * @vport: virtual port structure
+ * @qid_list: List of the RX qid's
+ *
+ * qid_list is created and freed by the caller
+ */
+void iecm_fill_dflt_rss_lut(struct iecm_vport *vport, u16 *qid_list)
+{
+	/* stub */
+}
+
+/**
+ * iecm_init_rss - Prepare for RSS
+ * @vport: virtual port
+ *
+ * Return 0 on success, negative on failure
+ */
+int iecm_init_rss(struct iecm_vport *vport)
+{
+	/* stub */
+}
+
+/**
+ * iecm_deinit_rss - Prepare for RSS
+ * @vport: virtual port
+ *
+ */
+void iecm_deinit_rss(struct iecm_vport *vport)
+{
+	/* stub */
+}
diff --git a/drivers/net/ethernet/intel/iecm/iecm_virtchnl.c b/drivers/net/ethernet/intel/iecm/iecm_virtchnl.c
new file mode 100644
index 000000000000..271009350503
--- /dev/null
+++ b/drivers/net/ethernet/intel/iecm/iecm_virtchnl.c
@@ -0,0 +1,570 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (C) 2020 Intel Corporation */
+
+#include <linux/net/intel/iecm.h>
+
+/**
+ * iecm_recv_event_msg - Receive virtchnl event message
+ * @vport: virtual port structure
+ *
+ * Receive virtchnl event message
+ */
+void iecm_recv_event_msg(struct iecm_vport *vport)
+{
+	/* stub */
+}
+
+/**
+ * iecm_mb_clean - Reclaim the send mailbox queue entries
+ * @adapter: Driver specific private structure
+ *
+ * Reclaim the send mailbox queue entries to be used to send further messages
+ *
+ * Returns success or failure
+ */
+enum iecm_status
+iecm_mb_clean(struct iecm_adapter *adapter)
+{
+	/* stub */
+}
+
+/**
+ * iecm_send_mb_msg - Send message over mailbox
+ * @adapter: Driver specific private structure
+ * @op: virtchnl opcode
+ * @msg_size: size of the payload
+ * @msg: pointer to buffer holding the payload
+ *
+ * Will prepare the control queue message and initiates the send API
+ *
+ * Returns success or failure
+ */
+enum iecm_status
+iecm_send_mb_msg(struct iecm_adapter *adapter, enum virtchnl_ops op,
+		 u16 msg_size, u8 *msg)
+{
+	/* stub */
+}
+EXPORT_SYMBOL(iecm_send_mb_msg);
+
+/**
+ * iecm_recv_mb_msg - Receive message over mailbox
+ * @adapter: Driver specific private structure
+ * @op: virtchnl operation code
+ * @msg: Received message holding buffer
+ * @msg_size: message size
+ *
+ * Will receive control queue message and posts the receive buffer
+ */
+enum iecm_status
+iecm_recv_mb_msg(struct iecm_adapter *adapter, enum virtchnl_ops op,
+		 void *msg, int msg_size)
+{
+	/* stub */
+}
+EXPORT_SYMBOL(iecm_recv_mb_msg);
+
+/**
+ * iecm_send_ver_msg - send virtchnl version message
+ * @adapter: Driver specific private structure
+ *
+ * Send virtchnl version message
+ */
+static enum iecm_status
+iecm_send_ver_msg(struct iecm_adapter *adapter)
+{
+	/* stub */
+}
+
+/**
+ * iecm_recv_ver_msg - Receive virtchnl version message
+ * @adapter: Driver specific private structure
+ *
+ * Receive virtchnl version message
+ */
+static enum iecm_status
+iecm_recv_ver_msg(struct iecm_adapter *adapter)
+{
+	/* stub */
+}
+
+/**
+ * iecm_send_get_caps_msg - Send virtchnl get capabilities message
+ * @adapter: Driver specific private structure
+ *
+ * send virtchnl get capabilities message
+ */
+enum iecm_status
+iecm_send_get_caps_msg(struct iecm_adapter *adapter)
+{
+	/* stub */
+}
+EXPORT_SYMBOL(iecm_send_get_caps_msg);
+
+/**
+ * iecm_recv_get_caps_msg - Receive virtchnl get capabilities message
+ * @adapter: Driver specific private structure
+ *
+ * Receive virtchnl get capabilities message
+ */
+static enum iecm_status
+iecm_recv_get_caps_msg(struct iecm_adapter *adapter)
+{
+	/* stub */
+}
+
+/**
+ * iecm_send_create_vport_msg - Send virtchnl create vport message
+ * @adapter: Driver specific private structure
+ *
+ * send virtchnl create vport message
+ *
+ * Returns success or failure
+ */
+static enum iecm_status
+iecm_send_create_vport_msg(struct iecm_adapter *adapter)
+{
+	/* stub */
+}
+
+/**
+ * iecm_recv_create_vport_msg - Receive virtchnl create vport message
+ * @adapter: Driver specific private structure
+ * @vport_id: Virtual port identifier
+ *
+ * Receive virtchnl create vport message
+ *
+ * Returns success or failure
+ */
+static enum iecm_status
+iecm_recv_create_vport_msg(struct iecm_adapter *adapter,
+			   int *vport_id)
+{
+	/* stub */
+}
+
+/**
+ * iecm_wait_for_event - wait for virtchnl response
+ * @adapter: Driver private data structure
+ * @state: check on state upon timeout after 500ms
+ * @err_check: check if this specific error bit is set
+ *
+ * checks if state is set upon expiry of timeout
+ *
+ * Returns success or failure
+ */
+enum iecm_status
+iecm_wait_for_event(struct iecm_adapter *adapter,
+		    enum iecm_vport_vc_state state,
+		    enum iecm_vport_vc_state err_check)
+{
+	/* stub */
+}
+EXPORT_SYMBOL(iecm_wait_for_event);
+
+/**
+ * iecm_send_destroy_vport_msg - Send virtchnl destroy vport message
+ * @vport: virtual port data structure
+ *
+ * send virtchnl destroy vport message
+ */
+enum iecm_status
+iecm_send_destroy_vport_msg(struct iecm_vport *vport)
+{
+	/* stub */
+}
+
+/**
+ * iecm_send_enable_vport_msg - Send virtchnl enable vport message
+ * @vport: virtual port data structure
+ *
+ * send enable vport virtchnl message
+ */
+enum iecm_status
+iecm_send_enable_vport_msg(struct iecm_vport *vport)
+{
+	/* stub */
+}
+
+/**
+ * iecm_send_disable_vport_msg - Send virtchnl disable vport message
+ * @vport: virtual port data structure
+ *
+ * send disable vport virtchnl message
+ */
+enum iecm_status
+iecm_send_disable_vport_msg(struct iecm_vport *vport)
+{
+	/* stub */
+}
+
+/**
+ * iecm_send_config_tx_queues_msg - Send virtchnl config Tx queues message
+ * @vport: virtual port data structure
+ *
+ * send config Tx queues virtchnl message
+ *
+ * Returns success or failure
+ */
+enum iecm_status
+iecm_send_config_tx_queues_msg(struct iecm_vport *vport)
+{
+	/* stub */
+}
+
+/**
+ * iecm_send_config_rx_queues_msg - Send virtchnl config Rx queues message
+ * @vport: virtual port data structure
+ *
+ * send config Rx queues virtchnl message
+ *
+ * Returns success or failure
+ */
+enum iecm_status
+iecm_send_config_rx_queues_msg(struct iecm_vport *vport)
+{
+	/* stub */
+}
+
+/**
+ * iecm_send_ena_dis_queues_msg - Send virtchnl enable or disable
+ * queues message
+ * @vport: virtual port data structure
+ * @vc_op: virtchnl op code to send
+ *
+ * send enable or disable queues virtchnl message
+ *
+ * Returns success or failure
+ */
+static enum iecm_status
+iecm_send_ena_dis_queues_msg(struct iecm_vport *vport,
+			     enum virtchnl_ops vc_op)
+{
+	/* stub */
+}
+
+/**
+ * iecm_send_map_unmap_queue_vector_msg - Send virtchnl map or unmap queue
+ * vector message
+ * @vport: virtual port data structure
+ * @map: true for map and false for unmap
+ *
+ * send map or unmap queue vector virtchnl message
+ *
+ * Returns success or failure
+ */
+static enum iecm_status
+iecm_send_map_unmap_queue_vector_msg(struct iecm_vport *vport,
+				     bool map)
+{
+	/* stub */
+}
+
+/**
+ * iecm_send_enable_queues_msg - send enable queues virtchnl message
+ * @vport: Virtual port private data structure
+ *
+ * Will send enable queues virtchnl message
+ */
+static enum iecm_status
+iecm_send_enable_queues_msg(struct iecm_vport *vport)
+{
+	/* stub */
+}
+
+/**
+ * iecm_send_disable_queues_msg - send disable queues virtchnl message
+ * @vport: Virtual port private data structure
+ *
+ * Will send disable queues virtchnl message
+ */
+static enum iecm_status
+iecm_send_disable_queues_msg(struct iecm_vport *vport)
+{
+	/* stub */
+}
+
+/**
+ * iecm_send_delete_queues_msg - send delete queues virtchnl message
+ * @vport: Virtual port private data structure
+ *
+ * Will send delete queues virtchnl message
+ */
+enum iecm_status
+iecm_send_delete_queues_msg(struct iecm_vport *vport)
+{
+	/* stub */
+}
+
+/**
+ * iecm_send_config_queues_msg - Send config queues virtchnl message
+ * @vport: Virtual port private data structure
+ *
+ * Will send config queues virtchnl message
+ */
+static enum iecm_status
+iecm_send_config_queues_msg(struct iecm_vport *vport)
+{
+	/* stub */
+}
+
+/**
+ * iecm_send_add_queues_msg - Send virtchnl add queues message
+ * @vport: Virtual port private data structure
+ * @num_tx_q: number of transmit queues
+ * @num_complq: number of transmit completion queues
+ * @num_rx_q: number of receive queues
+ * @num_rx_bufq: number of receive buffer queues
+ *
+ * Returns success or failure
+ */
+enum iecm_status
+iecm_send_add_queues_msg(struct iecm_vport *vport, u16 num_tx_q,
+			 u16 num_complq, u16 num_rx_q, u16 num_rx_bufq)
+{
+	/* stub */
+}
+
+/**
+ * iecm_send_get_stats_msg - Send virtchnl get statistics message
+ * @adapter: Driver specific private structure
+ *
+ * Returns success or failure
+ */
+enum iecm_status
+iecm_send_get_stats_msg(struct iecm_vport *vport)
+{
+	/* stub */
+}
+
+/**
+ * iecm_send_get_set_rss_hash_msg - Send set or get RSS hash message
+ * @vport: virtual port data structure
+ * @get: flag to get or set RSS hash
+ *
+ * Returns success or failure
+ */
+enum iecm_status
+iecm_send_get_set_rss_hash_msg(struct iecm_vport *vport, bool get)
+{
+	/* stub */
+}
+
+/**
+ * iecm_send_get_set_rss_lut_msg - Send virtchnl get or set RSS lut message
+ * @vport: virtual port data structure
+ * @get: flag to set or get RSS look up table
+ *
+ * Returns success or failure
+ */
+enum iecm_status
+iecm_send_get_set_rss_lut_msg(struct iecm_vport *vport, bool get)
+{
+	/* stub */
+}
+
+/**
+ * iecm_send_get_set_rss_key_msg - Send virtchnl get or set RSS key message
+ * @vport: virtual port data structure
+ * @get: flag to set or get RSS look up table
+ *
+ * Returns success or failure
+ */
+enum iecm_status
+iecm_send_get_set_rss_key_msg(struct iecm_vport *vport, bool get)
+{
+	/* stub */
+}
+
+/**
+ * iecm_send_get_rx_ptype_msg - Send virtchnl get or set RSS key message
+ * @vport: virtual port data structure
+ *
+ * Returns success or failure
+ */
+enum iecm_status iecm_send_get_rx_ptype_msg(struct iecm_vport *vport)
+{
+	/* stub */
+}
+
+/**
+ * iecm_find_ctlq - Given a type and id, find ctlq info
+ * @adapter: adapter info struct
+ * @type: type of ctrlq to find
+ * @id: ctlq id to find
+ *
+ * Returns pointer to found ctlq info struct, NULL otherwise.
+ */
+static struct iecm_ctlq_info *iecm_find_ctlq(struct iecm_hw *hw,
+					     enum iecm_ctlq_type type, int id)
+{
+	/* stub */
+}
+
+/**
+ * iecm_deinit_dflt_mbx - De initialize mailbox
+ * @adapter: adapter info struct
+ */
+void iecm_deinit_dflt_mbx(struct iecm_adapter *adapter)
+{
+	/* stub */
+}
+
+/**
+ * iecm_init_dflt_mbx - Setup default mailbox parameters and make request
+ * @adapter: adapter info struct
+ *
+ * Returns 0 on success, negative otherwise
+ */
+enum iecm_status iecm_init_dflt_mbx(struct iecm_adapter *adapter)
+{
+	/* stub */
+}
+
+/**
+ * iecm_vport_params_buf_alloc - Allocate memory for mailbox resources
+ * @adapter: Driver specific private data structure
+ *
+ * Will alloc memory to hold the vport parameters received on mailbox
+ */
+int iecm_vport_params_buf_alloc(struct iecm_adapter *adapter)
+{
+	/* stub */
+}
+
+/**
+ * iecm_vport_params_buf_rel - Release memory for mailbox resources
+ * @adapter: Driver specific private data structure
+ *
+ * Will release memory to hold the vport parameters received on mailbox
+ */
+void iecm_vport_params_buf_rel(struct iecm_adapter *adapter)
+{
+	/* stub */
+}
+
+/**
+ * iecm_vc_core_init - Initialize mailbox and get resources
+ * @adapter: Driver specific private structure
+ * @vport_id: Virtual port identifier
+ *
+ * Will check if HW is ready with reset complete. Initializes the mailbox and
+ * communicate with master to get all the default vport parameters.
+ */
+int iecm_vc_core_init(struct iecm_adapter *adapter, int *vport_id)
+{
+	/* stub */
+}
+EXPORT_SYMBOL(iecm_vc_core_init);
+
+/**
+ * iecm_vport_init - Initialize virtual port
+ * @vport: virtual port to be initialized
+ * @vport_id: Unique identification number of vport
+ *
+ * Will initialize vport with the info received through MB earlier
+ */
+static void iecm_vport_init(struct iecm_vport *vport, int vport_id)
+{
+	/* stub */
+}
+
+/**
+ * iecm_vport_get_vec_ids - Initialize vector id from Mailbox parameters
+ * @vecids: Array of vector ids
+ * @num_vecids: number of vector ids
+ * @chunks: vector ids received over mailbox
+ *
+ * Will initialize all vector ids with ids received as mailbox parameters
+ * Returns number of ids filled
+ */
+int
+iecm_vport_get_vec_ids(u16 *vecids, int num_vecids,
+		       struct virtchnl_vector_chunks *chunks)
+{
+	/* stub */
+}
+
+/**
+ * iecm_vport_get_queue_ids - Initialize queue id from Mailbox parameters
+ * @qids: Array of queue ids
+ * @num_qids: number of queue ids
+ * @q_type: queue model
+ * @chunks: queue ids received over mailbox
+ *
+ * Will initialize all queue ids with ids received as mailbox parameters
+ * Returns number of ids filled
+ */
+static int
+iecm_vport_get_queue_ids(u16 *qids, int num_qids,
+			 enum virtchnl_queue_type q_type,
+			 struct virtchnl_queue_chunks *chunks)
+{
+	/* stub */
+}
+
+/**
+ * __iecm_vport_queue_ids_init - Initialize queue ids from Mailbox parameters
+ * @vport: virtual port for which the queues ids are initialized
+ * @qids: queue ids
+ * @num_qids: number of queue ids
+ * @q_type: type of queue
+ *
+ * Will initialize all queue ids with ids received as mailbox
+ * parameters. Returns number of queue ids initialized.
+ */
+static int
+__iecm_vport_queue_ids_init(struct iecm_vport *vport, u16 *qids,
+			    int num_qids, enum virtchnl_queue_type q_type)
+{
+	/* stub */
+}
+
+/**
+ * iecm_vport_queue_ids_init - Initialize queue ids from Mailbox parameters
+ * @vport: virtual port for which the queues ids are initialized
+ *
+ * Will initialize all queue ids with ids received as mailbox
+ * parameters. Returns error if all the queues are not initialized
+ */
+static
+enum iecm_status iecm_vport_queue_ids_init(struct iecm_vport *vport)
+{
+	/* stub */
+}
+
+/**
+ * iecm_vport_adjust_qs - Adjust to new requested queues
+ * @vport: virtual port data struct
+ *
+ * Renegotiate queues
+ */
+enum iecm_status iecm_vport_adjust_qs(struct iecm_vport *vport)
+{
+	/* stub */
+}
+
+/**
+ * iecm_is_capability_ena - Default implementation of capability checking
+ * @adapter: Private data struct
+ * @flag: flag to check
+ *
+ * Return true if capability is supported, false otherwise
+ */
+static bool iecm_is_capability_ena(struct iecm_adapter *adapter, u64 flag)
+{
+	/* stub */
+}
+
+/**
+ * iecm_vc_ops_init - Initialize virtchnl common API
+ * @adapter: Driver specific private structure
+ *
+ * Initialize the function pointers with the extended feature set functions
+ * as APF will deal only with new set of opcodes.
+ */
+void iecm_vc_ops_init(struct iecm_adapter *adapter)
+{
+	/* stub */
+}
+EXPORT_SYMBOL(iecm_vc_ops_init);
-- 
2.26.2

