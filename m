Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 274F220D795
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 22:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733103AbgF2TbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:31:14 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:44042 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733094AbgF2TbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:31:12 -0400
Received: from dispatch1-us1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id CD1194DDF8
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 13:34:49 +0000 (UTC)
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.143])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id BD45A20092;
        Mon, 29 Jun 2020 13:34:49 +0000 (UTC)
Received: from us4-mdac16-56.at1.mdlocal (unknown [10.110.48.199])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id BAE008009B;
        Mon, 29 Jun 2020 13:34:49 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.48.236])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 2B64C40075;
        Mon, 29 Jun 2020 13:34:49 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id BB44640008B;
        Mon, 29 Jun 2020 13:34:48 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 29 Jun
 2020 14:34:43 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v2 net-next 06/15] sfc: split up nic.h
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <3750523f-1c2f-628d-1f71-39b355cf6661@solarflare.com>
Message-ID: <a3465fc9-1ecc-45d7-9f85-b908acd39ee9@solarflare.com>
Date:   Mon, 29 Jun 2020 14:34:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <3750523f-1c2f-628d-1f71-39b355cf6661@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25510.003
X-TM-AS-Result: No-5.730200-8.000000-10
X-TMASE-MatchedRID: VbDXM5/NWNJyOVk+FPzL1znWPqHIgPkVFugFBW/IrRpTorRIuadptLBZ
        szSz1qeig7JIeR0pHqZTvVffeIwvQwUcfW/oedmqnFVnNmvv47vLvfc3C6SWwgdkFovAReUoaUX
        s6FguVy02dnVybJBziYKxaaSRk3XGuIonElFF+KGLCYYg4B+SYUqAhuLHn5fEvG/ZjO2Z8dRwDt
        YJWjotBZcDK8vJ3S53WWzqBh0gvID+7R666Nv/MSfphWrcxCwjeF6MevMVZUADAA5uRHailnjm0
        APnwZU2y88WsMrwAs8UUZUcIrQXSSY3KbvVmCqgh2VzUlo4HVMEa8g1x8eqFxHFkFAjR1tn02wd
        rrHq5dk6PfE3y61UJ/Upwle3EbpfCO9K4IAyv4ttawJSSsDgSXyzRzLq38pIqVMUMZkw+EK/Nu6
        cJYw0FkxiHcoOrVcouEEbrtBsW0+t+oG+w5GDbkjdMvjHG2ZbxYt6Ilbxn6m+fWK8N2kAh+vt+N
        YpsLRFByCs+a1lmJio2G4UH+Vcr/7Q+vCvN8cxyBWvqfKUOe5xWv4UB7dQNclGlivVky4t+3Lgf
        IsOH3OKyF/OCH7LeBue0GemvyOBHMxD66p2PMISEYfcJF0pRctEPnVvPlFkiiKPXbEds+42m2uV
        GloE8RII42Fbw8rEbt91DetHN6bRlxaUc/KTYYlSWYvdSPSYlNc2tyboPcJZmv1nL0uD0clQVvH
        1JO6TxnYsahtjnFN5yQbZp1Axru+TiHQ4exl35p1ddw6V4RuN+W0gaFoavaU5HSRtIMsRMuTwba
        qEJZNjH2GrNrri8shkX1ICvi+PJHTgf0XC7IueAiCmPx4NwLTrdaH1ZWqC1kTfEkyaZdz6C0ePs
        7A07b4iOwQQ4jNiMxffta9++V0OF8KM2zmlcy5OGDhPp5eIG/Z/Bbtk474=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.730200-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25510.003
X-MDID: 1593437689-lAl2gxl91idW
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The new nic_common.h contains the inlines for NIC-type function dispatch,
 declarations for NIC-generic functions in nic.c, and other similar NIC-
 generic functionality.  Retained in nic.h are NIC-specific declarations
 such as the siena and ef10 nic_data structs and various farch functions.

The EF100 driver will thus include nic_common.h but not nic.h.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef10.c       |   6 +-
 drivers/net/ethernet/sfc/nic.h        | 296 +-------------------------
 drivers/net/ethernet/sfc/nic_common.h | 273 ++++++++++++++++++++++++
 drivers/net/ethernet/sfc/ptp.c        |   3 +-
 drivers/net/ethernet/sfc/ptp.h        |  45 ++++
 5 files changed, 322 insertions(+), 301 deletions(-)
 create mode 100644 drivers/net/ethernet/sfc/nic_common.h
 create mode 100644 drivers/net/ethernet/sfc/ptp.h

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 49af06ba7a8e..3bdb8606512a 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -1433,8 +1433,6 @@ static int efx_ef10_reset(struct efx_nic *efx, enum reset_type reset_type)
 	{ NULL, 64, 8 * MC_CMD_MAC_ ## mcdi_name }
 #define EF10_OTHER_STAT(ext_name)				\
 	[EF10_STAT_ ## ext_name] = { #ext_name, 0, 0 }
-#define GENERIC_SW_STAT(ext_name)				\
-	[GENERIC_STAT_ ## ext_name] = { #ext_name, 0, 0 }
 
 static const struct efx_hw_stat_desc efx_ef10_stat_desc[EF10_STAT_COUNT] = {
 	EF10_DMA_STAT(port_tx_bytes, TX_BYTES),
@@ -1478,8 +1476,8 @@ static const struct efx_hw_stat_desc efx_ef10_stat_desc[EF10_STAT_COUNT] = {
 	EF10_DMA_STAT(port_rx_align_error, RX_ALIGN_ERROR_PKTS),
 	EF10_DMA_STAT(port_rx_length_error, RX_LENGTH_ERROR_PKTS),
 	EF10_DMA_STAT(port_rx_nodesc_drops, RX_NODESC_DROPS),
-	GENERIC_SW_STAT(rx_nodesc_trunc),
-	GENERIC_SW_STAT(rx_noskb_drops),
+	EFX_GENERIC_SW_STAT(rx_nodesc_trunc),
+	EFX_GENERIC_SW_STAT(rx_noskb_drops),
 	EF10_DMA_STAT(port_rx_pm_trunc_bb_overflow, PM_TRUNC_BB_OVERFLOW),
 	EF10_DMA_STAT(port_rx_pm_discard_bb_overflow, PM_DISCARD_BB_OVERFLOW),
 	EF10_DMA_STAT(port_rx_pm_trunc_vfifo_full, PM_TRUNC_VFIFO_FULL),
diff --git a/drivers/net/ethernet/sfc/nic.h b/drivers/net/ethernet/sfc/nic.h
index 792907aeeb75..135c43146c13 100644
--- a/drivers/net/ethernet/sfc/nic.h
+++ b/drivers/net/ethernet/sfc/nic.h
@@ -8,133 +8,11 @@
 #ifndef EFX_NIC_H
 #define EFX_NIC_H
 
-#include <linux/net_tstamp.h>
-#include "net_driver.h"
+#include "nic_common.h"
 #include "efx.h"
-#include "efx_common.h"
-#include "mcdi.h"
-
-enum {
-	/* Revisions 0-2 were Falcon A0, A1 and B0 respectively.
-	 * They are not supported by this driver but these revision numbers
-	 * form part of the ethtool API for register dumping.
-	 */
-	EFX_REV_SIENA_A0 = 3,
-	EFX_REV_HUNT_A0 = 4,
-};
-
-static inline int efx_nic_rev(struct efx_nic *efx)
-{
-	return efx->type->revision;
-}
 
 u32 efx_farch_fpga_ver(struct efx_nic *efx);
 
-/* Read the current event from the event queue */
-static inline efx_qword_t *efx_event(struct efx_channel *channel,
-				     unsigned int index)
-{
-	return ((efx_qword_t *) (channel->eventq.buf.addr)) +
-		(index & channel->eventq_mask);
-}
-
-/* See if an event is present
- *
- * We check both the high and low dword of the event for all ones.  We
- * wrote all ones when we cleared the event, and no valid event can
- * have all ones in either its high or low dwords.  This approach is
- * robust against reordering.
- *
- * Note that using a single 64-bit comparison is incorrect; even
- * though the CPU read will be atomic, the DMA write may not be.
- */
-static inline int efx_event_present(efx_qword_t *event)
-{
-	return !(EFX_DWORD_IS_ALL_ONES(event->dword[0]) |
-		  EFX_DWORD_IS_ALL_ONES(event->dword[1]));
-}
-
-/* Returns a pointer to the specified transmit descriptor in the TX
- * descriptor queue belonging to the specified channel.
- */
-static inline efx_qword_t *
-efx_tx_desc(struct efx_tx_queue *tx_queue, unsigned int index)
-{
-	return ((efx_qword_t *) (tx_queue->txd.buf.addr)) + index;
-}
-
-/* Get partner of a TX queue, seen as part of the same net core queue */
-static struct efx_tx_queue *efx_tx_queue_partner(struct efx_tx_queue *tx_queue)
-{
-	if (tx_queue->queue & EFX_TXQ_TYPE_OFFLOAD)
-		return tx_queue - EFX_TXQ_TYPE_OFFLOAD;
-	else
-		return tx_queue + EFX_TXQ_TYPE_OFFLOAD;
-}
-
-/* Report whether this TX queue would be empty for the given write_count.
- * May return false negative.
- */
-static inline bool __efx_nic_tx_is_empty(struct efx_tx_queue *tx_queue,
-					 unsigned int write_count)
-{
-	unsigned int empty_read_count = READ_ONCE(tx_queue->empty_read_count);
-
-	if (empty_read_count == 0)
-		return false;
-
-	return ((empty_read_count ^ write_count) & ~EFX_EMPTY_COUNT_VALID) == 0;
-}
-
-/* Report whether the NIC considers this TX queue empty, using
- * packet_write_count (the write count recorded for the last completable
- * doorbell push).  May return false negative.  EF10 only, which is OK
- * because only EF10 supports PIO.
- */
-static inline bool efx_nic_tx_is_empty(struct efx_tx_queue *tx_queue)
-{
-	EFX_WARN_ON_ONCE_PARANOID(!tx_queue->efx->type->option_descriptors);
-	return __efx_nic_tx_is_empty(tx_queue, tx_queue->packet_write_count);
-}
-
-/* Decide whether we can use TX PIO, ie. write packet data directly into
- * a buffer on the device.  This can reduce latency at the expense of
- * throughput, so we only do this if both hardware and software TX rings
- * are empty.  This also ensures that only one packet at a time can be
- * using the PIO buffer.
- */
-static inline bool efx_nic_may_tx_pio(struct efx_tx_queue *tx_queue)
-{
-	struct efx_tx_queue *partner = efx_tx_queue_partner(tx_queue);
-
-	return tx_queue->piobuf && efx_nic_tx_is_empty(tx_queue) &&
-	       efx_nic_tx_is_empty(partner);
-}
-
-/* Decide whether to push a TX descriptor to the NIC vs merely writing
- * the doorbell.  This can reduce latency when we are adding a single
- * descriptor to an empty queue, but is otherwise pointless.  Further,
- * Falcon and Siena have hardware bugs (SF bug 33851) that may be
- * triggered if we don't check this.
- * We use the write_count used for the last doorbell push, to get the
- * NIC's view of the tx queue.
- */
-static inline bool efx_nic_may_push_tx_desc(struct efx_tx_queue *tx_queue,
-					    unsigned int write_count)
-{
-	bool was_empty = __efx_nic_tx_is_empty(tx_queue, write_count);
-
-	tx_queue->empty_read_count = 0;
-	return was_empty && tx_queue->write_count - write_count == 1;
-}
-
-/* Returns a pointer to the specified descriptor in the RX descriptor queue */
-static inline efx_qword_t *
-efx_rx_desc(struct efx_rx_queue *rx_queue, unsigned int index)
-{
-	return ((efx_qword_t *) (rx_queue->rxd.buf.addr)) + index;
-}
-
 enum {
 	PHY_TYPE_NONE = 0,
 	PHY_TYPE_TXC43128 = 1,
@@ -147,18 +25,6 @@ enum {
 	PHY_TYPE_SFT9001B = 10,
 };
 
-/* Alignment of PCIe DMA boundaries (4KB) */
-#define EFX_PAGE_SIZE	4096
-/* Size and alignment of buffer table entries (same) */
-#define EFX_BUF_SIZE	EFX_PAGE_SIZE
-
-/* NIC-generic software stats */
-enum {
-	GENERIC_STAT_rx_noskb_drops,
-	GENERIC_STAT_rx_nodesc_trunc,
-	GENERIC_STAT_COUNT
-};
-
 enum {
 	SIENA_STAT_tx_bytes = GENERIC_STAT_COUNT,
 	SIENA_STAT_tx_good_bytes,
@@ -434,123 +300,15 @@ struct efx_ef10_nic_data {
 int efx_init_sriov(void);
 void efx_fini_sriov(void);
 
-struct ethtool_ts_info;
-int efx_ptp_probe(struct efx_nic *efx, struct efx_channel *channel);
-void efx_ptp_defer_probe_with_channel(struct efx_nic *efx);
-struct efx_channel *efx_ptp_channel(struct efx_nic *efx);
-void efx_ptp_remove(struct efx_nic *efx);
-int efx_ptp_set_ts_config(struct efx_nic *efx, struct ifreq *ifr);
-int efx_ptp_get_ts_config(struct efx_nic *efx, struct ifreq *ifr);
-void efx_ptp_get_ts_info(struct efx_nic *efx, struct ethtool_ts_info *ts_info);
-bool efx_ptp_is_ptp_tx(struct efx_nic *efx, struct sk_buff *skb);
-int efx_ptp_get_mode(struct efx_nic *efx);
-int efx_ptp_change_mode(struct efx_nic *efx, bool enable_wanted,
-			unsigned int new_mode);
-int efx_ptp_tx(struct efx_nic *efx, struct sk_buff *skb);
-void efx_ptp_event(struct efx_nic *efx, efx_qword_t *ev);
-size_t efx_ptp_describe_stats(struct efx_nic *efx, u8 *strings);
-size_t efx_ptp_update_stats(struct efx_nic *efx, u64 *stats);
-void efx_time_sync_event(struct efx_channel *channel, efx_qword_t *ev);
-void __efx_rx_skb_attach_timestamp(struct efx_channel *channel,
-				   struct sk_buff *skb);
-static inline void efx_rx_skb_attach_timestamp(struct efx_channel *channel,
-					       struct sk_buff *skb)
-{
-	if (channel->sync_events_state == SYNC_EVENTS_VALID)
-		__efx_rx_skb_attach_timestamp(channel, skb);
-}
-void efx_ptp_start_datapath(struct efx_nic *efx);
-void efx_ptp_stop_datapath(struct efx_nic *efx);
-bool efx_ptp_use_mac_tx_timestamps(struct efx_nic *efx);
-ktime_t efx_ptp_nic_to_kernel_time(struct efx_tx_queue *tx_queue);
-
-extern const struct efx_nic_type falcon_a1_nic_type;
-extern const struct efx_nic_type falcon_b0_nic_type;
 extern const struct efx_nic_type siena_a0_nic_type;
 extern const struct efx_nic_type efx_hunt_a0_nic_type;
 extern const struct efx_nic_type efx_hunt_a0_vf_nic_type;
 
-/**************************************************************************
- *
- * Externs
- *
- **************************************************************************
- */
-
 int falcon_probe_board(struct efx_nic *efx, u16 revision_info);
 
-/* TX data path */
-static inline int efx_nic_probe_tx(struct efx_tx_queue *tx_queue)
-{
-	return tx_queue->efx->type->tx_probe(tx_queue);
-}
-static inline void efx_nic_init_tx(struct efx_tx_queue *tx_queue)
-{
-	tx_queue->efx->type->tx_init(tx_queue);
-}
-static inline void efx_nic_remove_tx(struct efx_tx_queue *tx_queue)
-{
-	tx_queue->efx->type->tx_remove(tx_queue);
-}
-static inline void efx_nic_push_buffers(struct efx_tx_queue *tx_queue)
-{
-	tx_queue->efx->type->tx_write(tx_queue);
-}
-
 int efx_enqueue_skb_tso(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
 			bool *data_mapped);
 
-/* RX data path */
-static inline int efx_nic_probe_rx(struct efx_rx_queue *rx_queue)
-{
-	return rx_queue->efx->type->rx_probe(rx_queue);
-}
-static inline void efx_nic_init_rx(struct efx_rx_queue *rx_queue)
-{
-	rx_queue->efx->type->rx_init(rx_queue);
-}
-static inline void efx_nic_remove_rx(struct efx_rx_queue *rx_queue)
-{
-	rx_queue->efx->type->rx_remove(rx_queue);
-}
-static inline void efx_nic_notify_rx_desc(struct efx_rx_queue *rx_queue)
-{
-	rx_queue->efx->type->rx_write(rx_queue);
-}
-static inline void efx_nic_generate_fill_event(struct efx_rx_queue *rx_queue)
-{
-	rx_queue->efx->type->rx_defer_refill(rx_queue);
-}
-
-/* Event data path */
-static inline int efx_nic_probe_eventq(struct efx_channel *channel)
-{
-	return channel->efx->type->ev_probe(channel);
-}
-static inline int efx_nic_init_eventq(struct efx_channel *channel)
-{
-	return channel->efx->type->ev_init(channel);
-}
-static inline void efx_nic_fini_eventq(struct efx_channel *channel)
-{
-	channel->efx->type->ev_fini(channel);
-}
-static inline void efx_nic_remove_eventq(struct efx_channel *channel)
-{
-	channel->efx->type->ev_remove(channel);
-}
-static inline int
-efx_nic_process_eventq(struct efx_channel *channel, int quota)
-{
-	return channel->efx->type->ev_process(channel, quota);
-}
-static inline void efx_nic_eventq_read_ack(struct efx_channel *channel)
-{
-	channel->efx->type->ev_read_ack(channel);
-}
-
-void efx_nic_event_test_start(struct efx_channel *channel);
-
 /* Falcon/Siena queue operations */
 int efx_farch_tx_probe(struct efx_tx_queue *tx_queue);
 void efx_farch_tx_init(struct efx_tx_queue *tx_queue);
@@ -600,31 +358,6 @@ bool efx_farch_filter_rfs_expire_one(struct efx_nic *efx, u32 flow_id,
 #endif
 void efx_farch_filter_sync_rx_mode(struct efx_nic *efx);
 
-bool efx_nic_event_present(struct efx_channel *channel);
-
-/* Some statistics are computed as A - B where A and B each increase
- * linearly with some hardware counter(s) and the counters are read
- * asynchronously.  If the counters contributing to B are always read
- * after those contributing to A, the computed value may be lower than
- * the true value by some variable amount, and may decrease between
- * subsequent computations.
- *
- * We should never allow statistics to decrease or to exceed the true
- * value.  Since the computed value will never be greater than the
- * true value, we can achieve this by only storing the computed value
- * when it increases.
- */
-static inline void efx_update_diff_stat(u64 *stat, u64 diff)
-{
-	if ((s64)(diff - *stat) > 0)
-		*stat = diff;
-}
-
-/* Interrupts */
-int efx_nic_init_interrupt(struct efx_nic *efx);
-int efx_nic_irq_test_start(struct efx_nic *efx);
-void efx_nic_fini_interrupt(struct efx_nic *efx);
-
 /* Falcon/Siena interrupts */
 void efx_farch_irq_enable_master(struct efx_nic *efx);
 int efx_farch_irq_test_generate(struct efx_nic *efx);
@@ -633,17 +366,7 @@ irqreturn_t efx_farch_msi_interrupt(int irq, void *dev_id);
 irqreturn_t efx_farch_legacy_interrupt(int irq, void *dev_id);
 irqreturn_t efx_farch_fatal_interrupt(struct efx_nic *efx);
 
-static inline int efx_nic_event_test_irq_cpu(struct efx_channel *channel)
-{
-	return READ_ONCE(channel->event_test_cpu);
-}
-static inline int efx_nic_irq_test_irq_cpu(struct efx_nic *efx)
-{
-	return READ_ONCE(efx->last_irq_cpu);
-}
-
 /* Global Resources */
-int efx_nic_flush_queues(struct efx_nic *efx);
 void siena_prepare_flush(struct efx_nic *efx);
 int efx_farch_fini_dmaq(struct efx_nic *efx);
 void efx_farch_finish_flr(struct efx_nic *efx);
@@ -657,10 +380,6 @@ void efx_ef10_handle_drain_event(struct efx_nic *efx);
 void efx_farch_rx_push_indir_table(struct efx_nic *efx);
 void efx_farch_rx_pull_indir_table(struct efx_nic *efx);
 
-int efx_nic_alloc_buffer(struct efx_nic *efx, struct efx_buffer *buffer,
-			 unsigned int len, gfp_t gfp_flags);
-void efx_nic_free_buffer(struct efx_nic *efx, struct efx_buffer *buffer);
-
 /* Tests */
 struct efx_farch_register_test {
 	unsigned address;
@@ -671,19 +390,6 @@ int efx_farch_test_registers(struct efx_nic *efx,
 			     const struct efx_farch_register_test *regs,
 			     size_t n_regs);
 
-size_t efx_nic_get_regs_len(struct efx_nic *efx);
-void efx_nic_get_regs(struct efx_nic *efx, void *buf);
-
-size_t efx_nic_describe_stats(const struct efx_hw_stat_desc *desc, size_t count,
-			      const unsigned long *mask, u8 *names);
-int efx_nic_copy_stats(struct efx_nic *efx, __le64 *dest);
-void efx_nic_update_stats(const struct efx_hw_stat_desc *desc, size_t count,
-			  const unsigned long *mask, u64 *stats,
-			  const void *dma_buf, bool accumulate);
-void efx_nic_fix_nodesc_drop_stat(struct efx_nic *efx, u64 *stat);
-
-#define EFX_MAX_FLUSH_TIME 5000
-
 void efx_farch_generate_event(struct efx_nic *efx, unsigned int evq,
 			      efx_qword_t *event);
 
diff --git a/drivers/net/ethernet/sfc/nic_common.h b/drivers/net/ethernet/sfc/nic_common.h
new file mode 100644
index 000000000000..e90ce85359cb
--- /dev/null
+++ b/drivers/net/ethernet/sfc/nic_common.h
@@ -0,0 +1,273 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/****************************************************************************
+ * Driver for Solarflare network controllers and boards
+ * Copyright 2005-2006 Fen Systems Ltd.
+ * Copyright 2006-2013 Solarflare Communications Inc.
+ * Copyright 2019-2020 Xilinx Inc.
+ */
+
+#ifndef EFX_NIC_COMMON_H
+#define EFX_NIC_COMMON_H
+
+#include "net_driver.h"
+#include "efx_common.h"
+#include "mcdi.h"
+#include "ptp.h"
+
+enum {
+	/* Revisions 0-2 were Falcon A0, A1 and B0 respectively.
+	 * They are not supported by this driver but these revision numbers
+	 * form part of the ethtool API for register dumping.
+	 */
+	EFX_REV_SIENA_A0 = 3,
+	EFX_REV_HUNT_A0 = 4,
+};
+
+static inline int efx_nic_rev(struct efx_nic *efx)
+{
+	return efx->type->revision;
+}
+
+/* Read the current event from the event queue */
+static inline efx_qword_t *efx_event(struct efx_channel *channel,
+				     unsigned int index)
+{
+	return ((efx_qword_t *) (channel->eventq.buf.addr)) +
+		(index & channel->eventq_mask);
+}
+
+/* See if an event is present
+ *
+ * We check both the high and low dword of the event for all ones.  We
+ * wrote all ones when we cleared the event, and no valid event can
+ * have all ones in either its high or low dwords.  This approach is
+ * robust against reordering.
+ *
+ * Note that using a single 64-bit comparison is incorrect; even
+ * though the CPU read will be atomic, the DMA write may not be.
+ */
+static inline int efx_event_present(efx_qword_t *event)
+{
+	return !(EFX_DWORD_IS_ALL_ONES(event->dword[0]) |
+		  EFX_DWORD_IS_ALL_ONES(event->dword[1]));
+}
+
+/* Returns a pointer to the specified transmit descriptor in the TX
+ * descriptor queue belonging to the specified channel.
+ */
+static inline efx_qword_t *
+efx_tx_desc(struct efx_tx_queue *tx_queue, unsigned int index)
+{
+	return ((efx_qword_t *) (tx_queue->txd.buf.addr)) + index;
+}
+
+/* Report whether this TX queue would be empty for the given write_count.
+ * May return false negative.
+ */
+static inline bool __efx_nic_tx_is_empty(struct efx_tx_queue *tx_queue,
+					 unsigned int write_count)
+{
+	unsigned int empty_read_count = READ_ONCE(tx_queue->empty_read_count);
+
+	if (empty_read_count == 0)
+		return false;
+
+	return ((empty_read_count ^ write_count) & ~EFX_EMPTY_COUNT_VALID) == 0;
+}
+
+/* Report whether the NIC considers this TX queue empty, using
+ * packet_write_count (the write count recorded for the last completable
+ * doorbell push).  May return false negative.  EF10 only, which is OK
+ * because only EF10 supports PIO.
+ */
+static inline bool efx_nic_tx_is_empty(struct efx_tx_queue *tx_queue)
+{
+	EFX_WARN_ON_ONCE_PARANOID(!tx_queue->efx->type->option_descriptors);
+	return __efx_nic_tx_is_empty(tx_queue, tx_queue->packet_write_count);
+}
+
+/* Get partner of a TX queue, seen as part of the same net core queue */
+/* XXX is this a thing on EF100? */
+static inline struct efx_tx_queue *efx_tx_queue_partner(struct efx_tx_queue *tx_queue)
+{
+	if (tx_queue->queue & EFX_TXQ_TYPE_OFFLOAD)
+		return tx_queue - EFX_TXQ_TYPE_OFFLOAD;
+	else
+		return tx_queue + EFX_TXQ_TYPE_OFFLOAD;
+}
+
+/* Decide whether we can use TX PIO, ie. write packet data directly into
+ * a buffer on the device.  This can reduce latency at the expense of
+ * throughput, so we only do this if both hardware and software TX rings
+ * are empty.  This also ensures that only one packet at a time can be
+ * using the PIO buffer.
+ */
+static inline bool efx_nic_may_tx_pio(struct efx_tx_queue *tx_queue)
+{
+	struct efx_tx_queue *partner = efx_tx_queue_partner(tx_queue);
+
+	return tx_queue->piobuf && efx_nic_tx_is_empty(tx_queue) &&
+	       efx_nic_tx_is_empty(partner);
+}
+
+/* Decide whether to push a TX descriptor to the NIC vs merely writing
+ * the doorbell.  This can reduce latency when we are adding a single
+ * descriptor to an empty queue, but is otherwise pointless.  Further,
+ * Falcon and Siena have hardware bugs (SF bug 33851) that may be
+ * triggered if we don't check this.
+ * We use the write_count used for the last doorbell push, to get the
+ * NIC's view of the tx queue.
+ */
+static inline bool efx_nic_may_push_tx_desc(struct efx_tx_queue *tx_queue,
+					    unsigned int write_count)
+{
+	bool was_empty = __efx_nic_tx_is_empty(tx_queue, write_count);
+
+	tx_queue->empty_read_count = 0;
+	return was_empty && tx_queue->write_count - write_count == 1;
+}
+
+/* Returns a pointer to the specified descriptor in the RX descriptor queue */
+static inline efx_qword_t *
+efx_rx_desc(struct efx_rx_queue *rx_queue, unsigned int index)
+{
+	return ((efx_qword_t *) (rx_queue->rxd.buf.addr)) + index;
+}
+
+/* Alignment of PCIe DMA boundaries (4KB) */
+#define EFX_PAGE_SIZE	4096
+/* Size and alignment of buffer table entries (same) */
+#define EFX_BUF_SIZE	EFX_PAGE_SIZE
+
+/* NIC-generic software stats */
+enum {
+	GENERIC_STAT_rx_noskb_drops,
+	GENERIC_STAT_rx_nodesc_trunc,
+	GENERIC_STAT_COUNT
+};
+
+#define EFX_GENERIC_SW_STAT(ext_name)				\
+	[GENERIC_STAT_ ## ext_name] = { #ext_name, 0, 0 }
+
+/* TX data path */
+static inline int efx_nic_probe_tx(struct efx_tx_queue *tx_queue)
+{
+	return tx_queue->efx->type->tx_probe(tx_queue);
+}
+static inline void efx_nic_init_tx(struct efx_tx_queue *tx_queue)
+{
+	tx_queue->efx->type->tx_init(tx_queue);
+}
+static inline void efx_nic_remove_tx(struct efx_tx_queue *tx_queue)
+{
+	tx_queue->efx->type->tx_remove(tx_queue);
+}
+static inline void efx_nic_push_buffers(struct efx_tx_queue *tx_queue)
+{
+	tx_queue->efx->type->tx_write(tx_queue);
+}
+
+/* RX data path */
+static inline int efx_nic_probe_rx(struct efx_rx_queue *rx_queue)
+{
+	return rx_queue->efx->type->rx_probe(rx_queue);
+}
+static inline void efx_nic_init_rx(struct efx_rx_queue *rx_queue)
+{
+	rx_queue->efx->type->rx_init(rx_queue);
+}
+static inline void efx_nic_remove_rx(struct efx_rx_queue *rx_queue)
+{
+	rx_queue->efx->type->rx_remove(rx_queue);
+}
+static inline void efx_nic_notify_rx_desc(struct efx_rx_queue *rx_queue)
+{
+	rx_queue->efx->type->rx_write(rx_queue);
+}
+static inline void efx_nic_generate_fill_event(struct efx_rx_queue *rx_queue)
+{
+	rx_queue->efx->type->rx_defer_refill(rx_queue);
+}
+
+/* Event data path */
+static inline int efx_nic_probe_eventq(struct efx_channel *channel)
+{
+	return channel->efx->type->ev_probe(channel);
+}
+static inline int efx_nic_init_eventq(struct efx_channel *channel)
+{
+	return channel->efx->type->ev_init(channel);
+}
+static inline void efx_nic_fini_eventq(struct efx_channel *channel)
+{
+	channel->efx->type->ev_fini(channel);
+}
+static inline void efx_nic_remove_eventq(struct efx_channel *channel)
+{
+	channel->efx->type->ev_remove(channel);
+}
+static inline int
+efx_nic_process_eventq(struct efx_channel *channel, int quota)
+{
+	return channel->efx->type->ev_process(channel, quota);
+}
+static inline void efx_nic_eventq_read_ack(struct efx_channel *channel)
+{
+	channel->efx->type->ev_read_ack(channel);
+}
+
+void efx_nic_event_test_start(struct efx_channel *channel);
+
+bool efx_nic_event_present(struct efx_channel *channel);
+
+/* Some statistics are computed as A - B where A and B each increase
+ * linearly with some hardware counter(s) and the counters are read
+ * asynchronously.  If the counters contributing to B are always read
+ * after those contributing to A, the computed value may be lower than
+ * the true value by some variable amount, and may decrease between
+ * subsequent computations.
+ *
+ * We should never allow statistics to decrease or to exceed the true
+ * value.  Since the computed value will never be greater than the
+ * true value, we can achieve this by only storing the computed value
+ * when it increases.
+ */
+static inline void efx_update_diff_stat(u64 *stat, u64 diff)
+{
+	if ((s64)(diff - *stat) > 0)
+		*stat = diff;
+}
+
+/* Interrupts */
+int efx_nic_init_interrupt(struct efx_nic *efx);
+int efx_nic_irq_test_start(struct efx_nic *efx);
+void efx_nic_fini_interrupt(struct efx_nic *efx);
+
+static inline int efx_nic_event_test_irq_cpu(struct efx_channel *channel)
+{
+	return READ_ONCE(channel->event_test_cpu);
+}
+static inline int efx_nic_irq_test_irq_cpu(struct efx_nic *efx)
+{
+	return READ_ONCE(efx->last_irq_cpu);
+}
+
+/* Global Resources */
+int efx_nic_alloc_buffer(struct efx_nic *efx, struct efx_buffer *buffer,
+			 unsigned int len, gfp_t gfp_flags);
+void efx_nic_free_buffer(struct efx_nic *efx, struct efx_buffer *buffer);
+
+size_t efx_nic_get_regs_len(struct efx_nic *efx);
+void efx_nic_get_regs(struct efx_nic *efx, void *buf);
+
+size_t efx_nic_describe_stats(const struct efx_hw_stat_desc *desc, size_t count,
+			      const unsigned long *mask, u8 *names);
+int efx_nic_copy_stats(struct efx_nic *efx, __le64 *dest);
+void efx_nic_update_stats(const struct efx_hw_stat_desc *desc, size_t count,
+			  const unsigned long *mask, u64 *stats,
+			  const void *dma_buf, bool accumulate);
+void efx_nic_fix_nodesc_drop_stat(struct efx_nic *efx, u64 *stat);
+
+#define EFX_MAX_FLUSH_TIME 5000
+
+#endif /* EFX_NIC_COMMON_H */
diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index 15c08cae6ae6..393b7cbac8b2 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -35,7 +35,6 @@
 #include <linux/time.h>
 #include <linux/ktime.h>
 #include <linux/module.h>
-#include <linux/net_tstamp.h>
 #include <linux/pps_kernel.h>
 #include <linux/ptp_clock_kernel.h>
 #include "net_driver.h"
@@ -44,7 +43,7 @@
 #include "mcdi_pcol.h"
 #include "io.h"
 #include "farch_regs.h"
-#include "nic.h"
+#include "nic.h" /* indirectly includes ptp.h */
 
 /* Maximum number of events expected to make up a PTP event */
 #define	MAX_EVENT_FRAGS			3
diff --git a/drivers/net/ethernet/sfc/ptp.h b/drivers/net/ethernet/sfc/ptp.h
new file mode 100644
index 000000000000..9855e8c9e544
--- /dev/null
+++ b/drivers/net/ethernet/sfc/ptp.h
@@ -0,0 +1,45 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/****************************************************************************
+ * Driver for Solarflare network controllers and boards
+ * Copyright 2005-2006 Fen Systems Ltd.
+ * Copyright 2006-2013 Solarflare Communications Inc.
+ * Copyright 2019-2020 Xilinx Inc.
+ */
+
+#ifndef EFX_PTP_H
+#define EFX_PTP_H
+
+#include <linux/net_tstamp.h>
+#include "net_driver.h"
+
+struct ethtool_ts_info;
+int efx_ptp_probe(struct efx_nic *efx, struct efx_channel *channel);
+void efx_ptp_defer_probe_with_channel(struct efx_nic *efx);
+struct efx_channel *efx_ptp_channel(struct efx_nic *efx);
+void efx_ptp_remove(struct efx_nic *efx);
+int efx_ptp_set_ts_config(struct efx_nic *efx, struct ifreq *ifr);
+int efx_ptp_get_ts_config(struct efx_nic *efx, struct ifreq *ifr);
+void efx_ptp_get_ts_info(struct efx_nic *efx, struct ethtool_ts_info *ts_info);
+bool efx_ptp_is_ptp_tx(struct efx_nic *efx, struct sk_buff *skb);
+int efx_ptp_get_mode(struct efx_nic *efx);
+int efx_ptp_change_mode(struct efx_nic *efx, bool enable_wanted,
+			unsigned int new_mode);
+int efx_ptp_tx(struct efx_nic *efx, struct sk_buff *skb);
+void efx_ptp_event(struct efx_nic *efx, efx_qword_t *ev);
+size_t efx_ptp_describe_stats(struct efx_nic *efx, u8 *strings);
+size_t efx_ptp_update_stats(struct efx_nic *efx, u64 *stats);
+void efx_time_sync_event(struct efx_channel *channel, efx_qword_t *ev);
+void __efx_rx_skb_attach_timestamp(struct efx_channel *channel,
+				   struct sk_buff *skb);
+static inline void efx_rx_skb_attach_timestamp(struct efx_channel *channel,
+					       struct sk_buff *skb)
+{
+	if (channel->sync_events_state == SYNC_EVENTS_VALID)
+		__efx_rx_skb_attach_timestamp(channel, skb);
+}
+void efx_ptp_start_datapath(struct efx_nic *efx);
+void efx_ptp_stop_datapath(struct efx_nic *efx);
+bool efx_ptp_use_mac_tx_timestamps(struct efx_nic *efx);
+ktime_t efx_ptp_nic_to_kernel_time(struct efx_tx_queue *tx_queue);
+
+#endif /* EFX_PTP_H */

