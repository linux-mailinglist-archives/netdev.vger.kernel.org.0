Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19CD26C2991
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 06:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbjCUFEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 01:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbjCUFEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 01:04:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF6232525;
        Mon, 20 Mar 2023 22:04:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 545B361959;
        Tue, 21 Mar 2023 05:03:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BD2FC433EF;
        Tue, 21 Mar 2023 05:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679375017;
        bh=RNkCa957yHjBr2Ua+meJiiBJW7D5Zer1JqYZm5HWVZo=;
        h=From:To:Cc:Subject:Date:From;
        b=fWcgXW8/b5zC9SMiuuN2pvgRsdt9DEuorvxbOJVlOfFNu8SrGWzt0e7vCK4pUwI8+
         wQSZMgwUo17oNZp+GSNt/GTCA1CxyWDKCCQNR5by+MPRK/+hrYRGXJ/g73tgWIcSn5
         8Na4IAQl1xWLyPYQk/C+SVM1EqLI/RmJXsVBWDLoptXAjxAHYXPKjRg4grrbeHI+BZ
         PlEN5cJcbVWn8oMha+i2GAI6GhsRNEyGONTukQb2H9qaYPFnBLXuNNWbgZFA/KTb4A
         8TsiRJ6IRUOENXAZLRkS+UzpV2pBeK6/gVrj/bjPeJByKw+smapso8lNe8QVZhtM75
         tNsoXq/S8Me5A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        corbet@lwn.net, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, pisa@cmp.felk.cvut.cz,
        mkl@pengutronix.de, linux-doc@vger.kernel.org,
        f.fainelli@gmail.com, stephen@networkplumber.org
Subject: [PATCH net-next v2] docs: networking: document NAPI
Date:   Mon, 20 Mar 2023 22:03:34 -0700
Message-Id: <20230321050334.1036870-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add basic documentation about NAPI. We can stop linking to the ancient
doc on the LF wiki.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Link: https://lore.kernel.org/all/20230315223044.471002-1-kuba@kernel.org/
Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
v2: remove the links in CAN and in ICE as well
    improve the start of the threaded NAPI section
    name footnote
    internal links from the intro to sections
    various clarifications from Florian and Stephen

CC: corbet@lwn.net
CC: jesse.brandeburg@intel.com
CC: anthony.l.nguyen@intel.com
CC: pisa@cmp.felk.cvut.cz
CC: mkl@pengutronix.de
CC: linux-doc@vger.kernel.org
CC: f.fainelli@gmail.com
CC: stephen@networkplumber.org
---
 .../can/ctu/ctucanfd-driver.rst               |   3 +-
 .../device_drivers/ethernet/intel/e100.rst    |   3 +-
 .../device_drivers/ethernet/intel/i40e.rst    |   4 +-
 .../device_drivers/ethernet/intel/ice.rst     |   4 +-
 .../device_drivers/ethernet/intel/ixgb.rst    |   4 +-
 Documentation/networking/index.rst            |   1 +
 Documentation/networking/napi.rst             | 251 ++++++++++++++++++
 include/linux/netdevice.h                     |  13 +-
 8 files changed, 267 insertions(+), 16 deletions(-)
 create mode 100644 Documentation/networking/napi.rst

diff --git a/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst b/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst
index 1a4fc6607582..1661d13174d5 100644
--- a/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst
+++ b/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst
@@ -229,8 +229,7 @@ frames for a while. This has a potential to avoid the costly round of
 enabling interrupts, handling an incoming IRQ in ISR, re-enabling the
 softirq and switching context back to softirq.
 
-More detailed documentation of NAPI may be found on the pages of Linux
-Foundation `<https://wiki.linuxfoundation.org/networking/napi>`_.
+See :ref:`Documentation/networking/napi.rst <napi>` for more information.
 
 Integrating the core to Xilinx Zynq
 -----------------------------------
diff --git a/Documentation/networking/device_drivers/ethernet/intel/e100.rst b/Documentation/networking/device_drivers/ethernet/intel/e100.rst
index 3d4a9ba21946..371b7e5c3293 100644
--- a/Documentation/networking/device_drivers/ethernet/intel/e100.rst
+++ b/Documentation/networking/device_drivers/ethernet/intel/e100.rst
@@ -151,8 +151,7 @@ NAPI
 
 NAPI (Rx polling mode) is supported in the e100 driver.
 
-See https://wiki.linuxfoundation.org/networking/napi for more
-information on NAPI.
+See :ref:`Documentation/networking/napi.rst <napi>` for more information.
 
 Multiple Interfaces on Same Ethernet Broadcast Network
 ------------------------------------------------------
diff --git a/Documentation/networking/device_drivers/ethernet/intel/i40e.rst b/Documentation/networking/device_drivers/ethernet/intel/i40e.rst
index ac35bd472bdc..c495c4e16b3b 100644
--- a/Documentation/networking/device_drivers/ethernet/intel/i40e.rst
+++ b/Documentation/networking/device_drivers/ethernet/intel/i40e.rst
@@ -399,8 +399,8 @@ operate only in full duplex and only at their native speed.
 NAPI
 ----
 NAPI (Rx polling mode) is supported in the i40e driver.
-For more information on NAPI, see
-https://wiki.linuxfoundation.org/networking/napi
+
+See :ref:`Documentation/networking/napi.rst <napi>` for more information.
 
 Flow Control
 ------------
diff --git a/Documentation/networking/device_drivers/ethernet/intel/ice.rst b/Documentation/networking/device_drivers/ethernet/intel/ice.rst
index 5efea4dd1251..2b6dc7880d7b 100644
--- a/Documentation/networking/device_drivers/ethernet/intel/ice.rst
+++ b/Documentation/networking/device_drivers/ethernet/intel/ice.rst
@@ -817,10 +817,10 @@ on your device, you may not be able to change the auto-negotiation setting.
 
 NAPI
 ----
+
 This driver supports NAPI (Rx polling mode).
-For more information on NAPI, see
-https://wiki.linuxfoundation.org/networking/napi
 
+See :ref:`Documentation/networking/napi.rst <napi>` for more information.
 
 MACVLAN
 -------
diff --git a/Documentation/networking/device_drivers/ethernet/intel/ixgb.rst b/Documentation/networking/device_drivers/ethernet/intel/ixgb.rst
index c6a233e68ad6..90ddbc912d8d 100644
--- a/Documentation/networking/device_drivers/ethernet/intel/ixgb.rst
+++ b/Documentation/networking/device_drivers/ethernet/intel/ixgb.rst
@@ -367,9 +367,7 @@ NAPI
 ----
 NAPI (Rx polling mode) is supported in the ixgb driver.
 
-See https://wiki.linuxfoundation.org/networking/napi for more information on
-NAPI.
-
+See :ref:`Documentation/networking/napi.rst <napi>` for more information.
 
 Known Issues/Troubleshooting
 ============================
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 4ddcae33c336..24bb256d6d53 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -73,6 +73,7 @@ Refer to :ref:`netdev-FAQ` for a guide on netdev development process specifics.
    mpls-sysctl
    mptcp-sysctl
    multiqueue
+   napi
    netconsole
    netdev-features
    netdevices
diff --git a/Documentation/networking/napi.rst b/Documentation/networking/napi.rst
new file mode 100644
index 000000000000..e9833f2b777a
--- /dev/null
+++ b/Documentation/networking/napi.rst
@@ -0,0 +1,251 @@
+.. _napi:
+
+====
+NAPI
+====
+
+NAPI is the event handling mechanism used by the Linux networking stack.
+The name NAPI does not stand for anything in particular [#]_.
+
+In basic operation device notifies the host about new events via an interrupt.
+The host then schedules a NAPI instance to process the events.
+Device may also be polled for events via NAPI without receiving
+interrupts first (:ref:`busy polling<poll>`).
+
+NAPI processing usually happens in the software interrupt context,
+but user may choose to use :ref:`separate kernel threads<threaded>`
+for NAPI processing.
+
+All in all NAPI abstracts away from the drivers the context and configuration
+of event (packet Rx and Tx) processing.
+
+Driver API
+==========
+
+The two most important elements of NAPI are the struct napi_struct
+and the associated poll method. struct napi_struct holds the state
+of the NAPI instance while the method is the driver-specific event
+handler. The method will typically free Tx packets which had been
+transmitted and process newly received packets.
+
+.. _drv_ctrl:
+
+Control API
+-----------
+
+netif_napi_add() and netif_napi_del() add/remove a NAPI instance
+from the system. The instances are attached to the netdevice passed
+as argument (and will be deleted automatically when netdevice is
+unregistered). Instances are added in a disabled state.
+
+napi_enable() and napi_disable() manage the disabled state.
+A disabled NAPI can't be scheduled and its poll method is guaranteed
+to not be invoked. napi_disable() waits for ownership of the NAPI
+instance to be released.
+
+The control APIs are not idempotent. Control API calls are safe against
+concurrent use of datapath APIs but incorrect sequence of control API
+calls may result in crashes, deadlocks, or race conditions. For example
+calling napi_disable() multiple times in a row will deadlock.
+
+Datapath API
+------------
+
+napi_schedule() is the basic method of scheduling a NAPI poll.
+Drivers should call this function in their interrupt handler
+(see :ref:`drv_sched` for more info). Successful call to napi_schedule()
+will take ownership of the NAPI instance.
+
+Some time after NAPI is scheduled driver's poll method will be
+called to process the events/packets. The method takes a ``budget``
+argument - drivers can process completions for any number of Tx
+packets but should only process up to ``budget`` number of
+Rx packets. Rx processing is usually much more expensive.
+
+In other words, it is recommended to ignore the budget argument when
+performing TX buffer reclamation to ensure that the reclamation is not
+arbitrarily bounded, however, it is required to honor the budget argument
+for RX processing.
+
+.. warning::
+
+   ``budget`` may be 0 if core tries to only process Tx completions
+   and no Rx packets.
+
+The poll method returns amount of work done. If the driver still
+has outstanding work to do (e.g. ``budget`` was exhausted)
+the poll method should return exactly ``budget``. In that case
+the NAPI instance will be serviced/polled again (without the
+need to be scheduled).
+
+If event processing has been completed (all outstanding packets
+processed) the poll method should call napi_complete_done()
+before returning. napi_complete_done() releases the ownership
+of the instance.
+
+.. warning::
+
+   The case of finishing all events and using exactly ``budget``
+   must be handled carefully. There is no way to report this
+   (rare) condition to the stack, so the driver must either
+   not call napi_complete_done() and wait to be called again,
+   or return ``budget - 1``.
+
+   If ``budget`` is 0 napi_complete_done() should never be called.
+
+Call sequence
+-------------
+
+Drivers should not make assumptions about the exact sequencing
+of calls. The poll method may be called without driver scheduling
+the instance (unless the instance is disabled). Similarly
+it's not guaranteed that the poll method will be called, even
+if napi_schedule() succeeded (e.g. if the instance gets disabled).
+
+As mentioned in the :ref:`drv_ctrl` section - napi_disable() and subsequent
+calls to the poll method only wait for the ownership of the instance
+to be released, not for the poll method to exit. This means that
+drivers should avoid accessing any data structures after calling
+napi_complete_done().
+
+.. _drv_sched:
+
+Scheduling and IRQ masking
+--------------------------
+
+Drivers should keep the interrupts masked after scheduling
+the NAPI instance - until NAPI polling finishes any further
+interrupts are unnecessary.
+
+Drivers which have to mask the interrupts explicitly (as opposed
+to IRQ being auto-masked by the device) should use the napi_schedule_prep()
+and __napi_schedule() calls:
+
+.. code-block:: c
+
+  if (napi_schedule_prep(&v->napi)) {
+      mydrv_mask_rxtx_irq(v->idx);
+      /* schedule after masking to avoid races */
+      __napi_schedule(&v->napi);
+  }
+
+IRQ should only be unmasked after successful call to napi_complete_done():
+
+.. code-block:: c
+
+  if (budget && napi_complete_done(&v->napi, work_done)) {
+    mydrv_unmask_rxtx_irq(v->idx);
+    return min(work_done, budget - 1);
+  }
+
+napi_schedule_irqoff() is a variant of napi_schedule() which takes advantage
+of guarantees given by being invoked in IRQ context (no need to
+mask interrupts). Note that PREEMPT_RT forces all interrupts
+to be threaded so the interrupt may need to be marked ``IRQF_NO_THREAD``
+to avoid issues on real-time kernel configurations.
+
+Instance to queue mapping
+-------------------------
+
+Modern devices have multiple NAPI instances (struct napi_struct) per
+interface. There is no strong requirement on how the instances are
+mapped to queues and interrupts. NAPI is primarily a polling/processing
+abstraction without many user-facing semantics. That said, most networking
+devices end up using NAPI in fairly similar ways.
+
+NAPI instances most often correspond 1:1:1 to interrupts and queue pairs
+(queue pair is a set of a single Rx and single Tx queue).
+
+In less common cases a NAPI instance may be used for multiple queues
+or Rx and Tx queues can be serviced by separate NAPI instances on a single
+core. Regardless of the queue assignment, however, there is usually still
+a 1:1 mapping between NAPI instances and interrupts.
+
+It's worth noting that the ethtool API uses a "channel" terminology where
+each channel can be either ``rx``, ``tx`` or ``combined``. It's not clear
+what constitutes a channel, the recommended interpretation is to understand
+a channel as an IRQ/NAPI which services queues of a given type. For example
+a configuration of 1 ``rx``, 1 ``tx`` and 1 ``combined`` channel is expected
+to utilize 3 interrupts, 2 Rx and 2 Tx queues.
+
+User API
+========
+
+User interactions with NAPI depend on NAPI instance ID. The instance IDs
+are only visible to the user thru the ``SO_INCOMING_NAPI_ID`` socket option.
+It's not currently possible to query IDs used by a given device.
+
+Software IRQ coalescing
+-----------------------
+
+NAPI does not perform any explicit event coalescing by default.
+In most scenarios batching happens due to IRQ coalescing which is done
+by the device. There are cases where software coalescing is helpful.
+
+NAPI can be configured to arm a repoll timer instead of unmasking
+the hardware interrupts as soon as all packets are processed.
+The ``gro_flush_timeout`` sysfs configuration of the netdevice
+is reused to control the delay of the timer, while
+``napi_defer_hard_irqs`` controls the number of consecutive empty polls
+before NAPI gives up and goes back to using hardware IRQs.
+
+.. _poll:
+
+Busy polling
+------------
+
+Busy polling allows user process to check for incoming packets before
+the device interrupt fires. As is the case with any busy polling it trades
+off CPU cycles for lower latency (in fact production uses of NAPI busy
+polling are not well known).
+
+User can enable busy polling by either setting ``SO_BUSY_POLL`` on
+selected sockets or using the global ``net.core.busy_poll`` and
+``net.core.busy_read`` sysctls. An io_uring API for NAPI busy polling
+also exists.
+
+IRQ mitigation
+---------------
+
+While busy polling is supposed to be used by low latency applications,
+a similar mechanism can be used for IRQ mitigation.
+
+Very high request-per-second applications (especially routing/forwarding
+applications and especially applications using AF_XDP sockets) may not
+want to be interrupted until they finish processing a request or a batch
+of packets.
+
+Such applications can pledge to the kernel that they will perform a busy
+polling operation periodically, and the driver should keep the device IRQs
+permanently masked. This mode is enabled by using the ``SO_PREFER_BUSY_POLL``
+socket option. To avoid the system misbehavior the pledge is revoked
+if ``gro_flush_timeout`` passes without any busy poll call.
+
+The NAPI budget for busy polling is lower than the default (which makes
+sense given the low latency intention of normal busy polling). This is
+not the case with IRQ mitigation, however, so the budget can be adjusted
+with the ``SO_BUSY_POLL_BUDGET`` socket option.
+
+.. _threaded:
+
+Threaded NAPI
+-------------
+
+Threaded NAPI is an operating mode which uses dedicated kernel
+threads rather than software IRQ context for NAPI processing.
+The configuration is per netdevice and will affect all
+NAPI instances of that device. Each NAPI instance will spawn a separate
+thread (called ``napi/${ifc-name}-${napi-id}``).
+
+It is recommended to pin each kernel thread to a single CPU, the same
+CPU as services the interrupt. Note that the mapping between IRQs and
+NAPI instances may not be trivial (and is driver dependent).
+The NAPI instance IDs will be assigned in the opposite order
+than the process IDs of the kernel threads.
+
+Threaded NAPI is controlled by writing 0/1 to the ``threaded`` file in
+netdev's sysfs directory.
+
+.. rubric:: Footnotes
+
+.. [#] NAPI was originally referred to as New API in 2.4 Linux.
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 470085b121d3..b439f877bc3a 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -508,15 +508,18 @@ static inline bool napi_reschedule(struct napi_struct *napi)
 	return false;
 }
 
-bool napi_complete_done(struct napi_struct *n, int work_done);
 /**
- *	napi_complete - NAPI processing complete
- *	@n: NAPI context
+ * napi_complete_done - NAPI processing complete
+ * @n: NAPI context
+ * @work_done: number of packets processed
  *
- * Mark NAPI processing as complete.
- * Consider using napi_complete_done() instead.
+ * Mark NAPI processing as complete. Should only be called if poll budget
+ * has not been completely consumed.
+ * Prefer over napi_complete().
  * Return false if device should avoid rearming interrupts.
  */
+bool napi_complete_done(struct napi_struct *n, int work_done);
+
 static inline bool napi_complete(struct napi_struct *n)
 {
 	return napi_complete_done(n, 0);
-- 
2.39.2

