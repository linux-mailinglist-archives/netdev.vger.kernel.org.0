Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 006BD134746
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 17:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728526AbgAHQKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 11:10:45 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:59304 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726922AbgAHQKp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 11:10:45 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us3.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id CD743600063;
        Wed,  8 Jan 2020 16:10:40 +0000 (UTC)
Received: from amm-opti7060.uk.solarflarecom.com (10.17.20.147) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 8 Jan 2020 16:10:35 +0000
From:   "Alex Maftei (amaftei)" <amaftei@solarflare.com>
Subject: [PATCH net-next 01/14] sfc: add new headers in preparation for code
 split
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>
CC:     <linux-net-drivers@solarflare.com>, <scrum-linux@solarflare.com>
References: <a0cfb828-b98e-3a63-15d9-592675e81b5f@solarflare.com>
Message-ID: <32da7849-b107-dd1c-0a5b-b6e710b5d8a1@solarflare.com>
Date:   Wed, 8 Jan 2020 16:10:32 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <a0cfb828-b98e-3a63-15d9-592675e81b5f@solarflare.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.147]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25154.003
X-TM-AS-Result: No-9.530900-8.000000-10
X-TMASE-MatchedRID: uJTAcZ5y+iZONLYsznOVdbgTyrrpk8McWw/OppTVsvKL0zi0dfYTDDB9
        ccde3hbUtr9V5KPqvlr8EHxW1bLlRnCbAkrOahe8qJSK+HSPY+/pVMb1xnESMnAal2A1DQms0WB
        KbT1Evhl4IpTMgJ4C0oW6KT8GDoUT8jVhulLX5q8/ApMPW/xhXkyQ5fRSh2656BqEPPevP+sV9A
        vxm8OyI4f4rG901qKZi32irAw+LfDUBIEM4OQ6eCAI8aJmq0jwpKS8Vb1YbZ1IyDY579vwTHddu
        Dm7lgGnN9hK99OcWw/NAoysHGBSsWZRsKzcNsjWSHCU59h5KrH1+9bO3CCbk+f8JLZult7EUUnI
        jW9ScS7cduZrEPeRqdowwOiDsiJWj59gj64ZeesyIyttzvQ99w+jS+LRpl817L2+zGEubN4xAnK
        2eeQXhh2gdSjq/iwa8w2GomqlEbRTattrga832Ob3p4cnIXGN5PYstWAKH2rHN9tnHHgXhLLJAi
        e8s+T8/RDNPRhFXVs0T8qvnrlreGDtLgkoS6O6h2VzUlo4HVM8Via9JYHCQLPe+XjpM5v6sx8UM
        Jr4pnceXniSvWT8hm6TVJgtX6V2aii2LgALayLykdOisNw8ykYj0zDHPzJpvnfHvUgggRIpQP60
        tO0L4T+YxycINhfXXGPg4ZVz5GpCITNtteitHAe06kQGFaIWPf2+tfEqWx2RoQLwUmtov6pviUG
        7kJm0Pvj+zmhFFKYbYnEX6DW3ut5PpICuz1Ooc14SYkyIBT1x7+KjXMomVT3GLc3r41vQaMvzMb
        GvEKuh7mJIdqWWcXVnrRUKQfV2oYAeIqRSPiqrm7DrUlmNkJGTpe1iiCJqb5ic6rRyh48LbigRn
        pKlKTpcQTtiHDgW4eZLp8bTU/Q=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--9.530900-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25154.003
X-MDID: 1578499842-3We4WId0Ny46
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

New headers contain prototypes of functions that will be common between
ef10 and upcoming driver.
Removed static modifier from the affected functions.
Some function prototypes were removed from existing headers.

Signed-off-by: Alexandru-Mihai Maftei <amaftei@solarflare.com>
---
 drivers/net/ethernet/sfc/ef10.c             |  2 +
 drivers/net/ethernet/sfc/efx.c              | 91 +++++++++------------
 drivers/net/ethernet/sfc/efx.h              | 32 --------
 drivers/net/ethernet/sfc/efx_channels.h     | 55 +++++++++++++
 drivers/net/ethernet/sfc/efx_common.h       | 52 ++++++++++++
 drivers/net/ethernet/sfc/ethtool.c          |  3 +
 drivers/net/ethernet/sfc/farch.c            |  1 +
 drivers/net/ethernet/sfc/mcdi.h             |  1 -
 drivers/net/ethernet/sfc/mcdi_functions.h   | 30 +++++++
 drivers/net/ethernet/sfc/mcdi_port.c        | 50 ++++-------
 drivers/net/ethernet/sfc/mcdi_port_common.h | 53 ++++++++++++
 drivers/net/ethernet/sfc/net_driver.h       | 13 ++-
 drivers/net/ethernet/sfc/nic.h              |  6 ++
 drivers/net/ethernet/sfc/rx.c               | 22 ++---
 drivers/net/ethernet/sfc/rx_common.h        | 42 ++++++++++
 drivers/net/ethernet/sfc/selftest.c         |  2 +
 drivers/net/ethernet/sfc/siena.c            |  1 +
 drivers/net/ethernet/sfc/tx.c               | 19 +++--
 drivers/net/ethernet/sfc/tx_common.h        | 31 +++++++
 19 files changed, 365 insertions(+), 141 deletions(-)
 create mode 100644 drivers/net/ethernet/sfc/efx_channels.h
 create mode 100644 drivers/net/ethernet/sfc/efx_common.h
 create mode 100644 drivers/net/ethernet/sfc/mcdi_functions.h
 create mode 100644 drivers/net/ethernet/sfc/mcdi_port_common.h
 create mode 100644 drivers/net/ethernet/sfc/rx_common.h
 create mode 100644 drivers/net/ethernet/sfc/tx_common.h

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 4d9bbccc6f89..de6e6cd4469b 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -9,10 +9,12 @@
 #include "io.h"
 #include "mcdi.h"
 #include "mcdi_pcol.h"
+#include "mcdi_port_common.h"
 #include "nic.h"
 #include "workarounds.h"
 #include "selftest.h"
 #include "ef10_sriov.h"
+#include "rx_common.h"
 #include <linux/in.h>
 #include <linux/jhash.h>
 #include <linux/wait.h>
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 033907e6fdb0..c5bcdfcfee87 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -23,6 +23,10 @@
 #include <net/gre.h>
 #include <net/udp_tunnel.h>
 #include "efx.h"
+#include "efx_common.h"
+#include "efx_channels.h"
+#include "rx_common.h"
+#include "tx_common.h"
 #include "nic.h"
 #include "io.h"
 #include "selftest.h"
@@ -214,18 +218,8 @@ MODULE_PARM_DESC(debug, "Bitmapped debugging message enable value");
  *
  *************************************************************************/
 
-static int efx_soft_enable_interrupts(struct efx_nic *efx);
-static void efx_soft_disable_interrupts(struct efx_nic *efx);
-static void efx_remove_channel(struct efx_channel *channel);
-static void efx_remove_channels(struct efx_nic *efx);
 static const struct efx_channel_type efx_default_channel_type;
 static void efx_remove_port(struct efx_nic *efx);
-static void efx_init_napi_channel(struct efx_channel *channel);
-static void efx_fini_napi(struct efx_nic *efx);
-static void efx_fini_napi_channel(struct efx_channel *channel);
-static void efx_fini_struct(struct efx_nic *efx);
-static void efx_start_all(struct efx_nic *efx);
-static void efx_stop_all(struct efx_nic *efx);
 static int efx_xdp_setup_prog(struct efx_nic *efx, struct bpf_prog *prog);
 static int efx_xdp(struct net_device *dev, struct netdev_bpf *xdp);
 static int efx_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **xdpfs,
@@ -239,7 +233,7 @@ static int efx_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **xdpfs,
 			ASSERT_RTNL();			\
 	} while (0)
 
-static int efx_check_disabled(struct efx_nic *efx)
+int efx_check_disabled(struct efx_nic *efx)
 {
 	if (efx->state == STATE_DISABLED || efx->state == STATE_RECOVERY) {
 		netif_err(efx, drv, efx->net_dev,
@@ -375,7 +369,7 @@ static int efx_poll(struct napi_struct *napi, int budget)
  * is reset, the memory buffer will be reused; this guards against
  * errors during channel reset and also simplifies interrupt handling.
  */
-static int efx_probe_eventq(struct efx_channel *channel)
+int efx_probe_eventq(struct efx_channel *channel)
 {
 	struct efx_nic *efx = channel->efx;
 	unsigned long entries;
@@ -393,7 +387,7 @@ static int efx_probe_eventq(struct efx_channel *channel)
 }
 
 /* Prepare channel's event queue */
-static int efx_init_eventq(struct efx_channel *channel)
+int efx_init_eventq(struct efx_channel *channel)
 {
 	struct efx_nic *efx = channel->efx;
 	int rc;
@@ -436,7 +430,7 @@ void efx_stop_eventq(struct efx_channel *channel)
 	channel->enabled = false;
 }
 
-static void efx_fini_eventq(struct efx_channel *channel)
+void efx_fini_eventq(struct efx_channel *channel)
 {
 	if (!channel->eventq_init)
 		return;
@@ -448,7 +442,7 @@ static void efx_fini_eventq(struct efx_channel *channel)
 	channel->eventq_init = false;
 }
 
-static void efx_remove_eventq(struct efx_channel *channel)
+void efx_remove_eventq(struct efx_channel *channel)
 {
 	netif_dbg(channel->efx, drv, channel->efx->net_dev,
 		  "chan %d remove event queue\n", channel->channel);
@@ -463,7 +457,7 @@ static void efx_remove_eventq(struct efx_channel *channel)
  *************************************************************************/
 
 /* Allocate and initialise a channel structure. */
-static struct efx_channel *
+struct efx_channel *
 efx_alloc_channel(struct efx_nic *efx, int i, struct efx_channel *old_channel)
 {
 	struct efx_channel *channel;
@@ -500,8 +494,7 @@ efx_alloc_channel(struct efx_nic *efx, int i, struct efx_channel *old_channel)
 /* Allocate and initialise a channel structure, copying parameters
  * (but not resources) from an old channel structure.
  */
-static struct efx_channel *
-efx_copy_channel(const struct efx_channel *old_channel)
+struct efx_channel *efx_copy_channel(const struct efx_channel *old_channel)
 {
 	struct efx_channel *channel;
 	struct efx_rx_queue *rx_queue;
@@ -577,8 +570,7 @@ static int efx_probe_channel(struct efx_channel *channel)
 	return rc;
 }
 
-static void
-efx_get_channel_name(struct efx_channel *channel, char *buf, size_t len)
+void efx_get_channel_name(struct efx_channel *channel, char *buf, size_t len)
 {
 	struct efx_nic *efx = channel->efx;
 	const char *type;
@@ -601,7 +593,7 @@ efx_get_channel_name(struct efx_channel *channel, char *buf, size_t len)
 	snprintf(buf, len, "%s%s-%d", efx->name, type, number);
 }
 
-static void efx_set_channel_names(struct efx_nic *efx)
+void efx_set_channel_names(struct efx_nic *efx)
 {
 	struct efx_channel *channel;
 
@@ -611,7 +603,7 @@ static void efx_set_channel_names(struct efx_nic *efx)
 					sizeof(efx->msi_context[0].name));
 }
 
-static int efx_probe_channels(struct efx_nic *efx)
+int efx_probe_channels(struct efx_nic *efx)
 {
 	struct efx_channel *channel;
 	int rc;
@@ -788,7 +780,7 @@ static void efx_stop_datapath(struct efx_nic *efx)
 	efx->xdp_rxq_info_failed = false;
 }
 
-static void efx_remove_channel(struct efx_channel *channel)
+void efx_remove_channel(struct efx_channel *channel)
 {
 	struct efx_tx_queue *tx_queue;
 	struct efx_rx_queue *rx_queue;
@@ -804,7 +796,7 @@ static void efx_remove_channel(struct efx_channel *channel)
 	channel->type->post_remove(channel);
 }
 
-static void efx_remove_channels(struct efx_nic *efx)
+void efx_remove_channels(struct efx_nic *efx)
 {
 	struct efx_channel *channel;
 
@@ -814,8 +806,7 @@ static void efx_remove_channels(struct efx_nic *efx)
 	kfree(efx->xdp_tx_queues);
 }
 
-int
-efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries)
+int efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries)
 {
 	struct efx_channel *other_channel[EFX_MAX_CHANNELS], *channel;
 	u32 old_rxq_entries, old_txq_entries;
@@ -929,7 +920,7 @@ void efx_schedule_slow_fill(struct efx_rx_queue *rx_queue)
 	mod_timer(&rx_queue->slow_fill, jiffies + msecs_to_jiffies(10));
 }
 
-static bool efx_default_channel_want_txqs(struct efx_channel *channel)
+bool efx_default_channel_want_txqs(struct efx_channel *channel)
 {
 	return channel->channel - channel->efx->tx_channel_offset <
 		channel->efx->n_tx_channels;
@@ -1292,7 +1283,7 @@ static void efx_dissociate(struct efx_nic *efx)
 }
 
 /* This configures the PCI device to enable I/O and DMA. */
-static int efx_init_io(struct efx_nic *efx)
+int efx_init_io(struct efx_nic *efx)
 {
 	struct pci_dev *pci_dev = efx->pci_dev;
 	dma_addr_t dma_mask = efx->type->max_dma_mask;
@@ -1363,7 +1354,7 @@ static int efx_init_io(struct efx_nic *efx)
 	return rc;
 }
 
-static void efx_fini_io(struct efx_nic *efx)
+void efx_fini_io(struct efx_nic *efx)
 {
 	int bar;
 
@@ -1545,7 +1536,7 @@ static int efx_allocate_msix_channels(struct efx_nic *efx,
 /* Probe the number and type of interrupts we are able to obtain, and
  * the resulting numbers of channels and RX queues.
  */
-static int efx_probe_interrupts(struct efx_nic *efx)
+int efx_probe_interrupts(struct efx_nic *efx)
 {
 	unsigned int extra_channels = 0;
 	unsigned int rss_spread;
@@ -1657,7 +1648,7 @@ static int efx_probe_interrupts(struct efx_nic *efx)
 }
 
 #if defined(CONFIG_SMP)
-static void efx_set_interrupt_affinity(struct efx_nic *efx)
+void efx_set_interrupt_affinity(struct efx_nic *efx)
 {
 	struct efx_channel *channel;
 	unsigned int cpu;
@@ -1669,7 +1660,7 @@ static void efx_set_interrupt_affinity(struct efx_nic *efx)
 	}
 }
 
-static void efx_clear_interrupt_affinity(struct efx_nic *efx)
+void efx_clear_interrupt_affinity(struct efx_nic *efx)
 {
 	struct efx_channel *channel;
 
@@ -1677,18 +1668,16 @@ static void efx_clear_interrupt_affinity(struct efx_nic *efx)
 		irq_set_affinity_hint(channel->irq, NULL);
 }
 #else
-static void
-efx_set_interrupt_affinity(struct efx_nic *efx __attribute__ ((unused)))
+void efx_set_interrupt_affinity(struct efx_nic *efx __attribute__ ((unused)))
 {
 }
 
-static void
-efx_clear_interrupt_affinity(struct efx_nic *efx __attribute__ ((unused)))
+void efx_clear_interrupt_affinity(struct efx_nic *efx __attribute__ ((unused)))
 {
 }
 #endif /* CONFIG_SMP */
 
-static int efx_soft_enable_interrupts(struct efx_nic *efx)
+int efx_soft_enable_interrupts(struct efx_nic *efx)
 {
 	struct efx_channel *channel, *end_channel;
 	int rc;
@@ -1723,7 +1712,7 @@ static int efx_soft_enable_interrupts(struct efx_nic *efx)
 	return rc;
 }
 
-static void efx_soft_disable_interrupts(struct efx_nic *efx)
+void efx_soft_disable_interrupts(struct efx_nic *efx)
 {
 	struct efx_channel *channel;
 
@@ -1751,7 +1740,7 @@ static void efx_soft_disable_interrupts(struct efx_nic *efx)
 	efx_mcdi_flush_async(efx);
 }
 
-static int efx_enable_interrupts(struct efx_nic *efx)
+int efx_enable_interrupts(struct efx_nic *efx)
 {
 	struct efx_channel *channel, *end_channel;
 	int rc;
@@ -1793,7 +1782,7 @@ static int efx_enable_interrupts(struct efx_nic *efx)
 	return rc;
 }
 
-static void efx_disable_interrupts(struct efx_nic *efx)
+void efx_disable_interrupts(struct efx_nic *efx)
 {
 	struct efx_channel *channel;
 
@@ -1807,7 +1796,7 @@ static void efx_disable_interrupts(struct efx_nic *efx)
 	efx->type->irq_disable_non_ev(efx);
 }
 
-static void efx_remove_interrupts(struct efx_nic *efx)
+void efx_remove_interrupts(struct efx_nic *efx)
 {
 	struct efx_channel *channel;
 
@@ -1821,7 +1810,7 @@ static void efx_remove_interrupts(struct efx_nic *efx)
 	efx->legacy_irq = 0;
 }
 
-static int efx_set_channels(struct efx_nic *efx)
+int efx_set_channels(struct efx_nic *efx)
 {
 	struct efx_channel *channel;
 	struct efx_tx_queue *tx_queue;
@@ -2074,7 +2063,7 @@ static int efx_probe_all(struct efx_nic *efx)
  * is safe to call multiple times, so long as the NIC is not disabled.
  * Requires the RTNL lock.
  */
-static void efx_start_all(struct efx_nic *efx)
+void efx_start_all(struct efx_nic *efx)
 {
 	EFX_ASSERT_RESET_SERIALISED(efx);
 	BUG_ON(efx->state == STATE_DISABLED);
@@ -2113,7 +2102,7 @@ static void efx_start_all(struct efx_nic *efx)
  * times with the NIC in almost any state, but interrupts should be
  * enabled.  Requires the RTNL lock.
  */
-static void efx_stop_all(struct efx_nic *efx)
+void efx_stop_all(struct efx_nic *efx)
 {
 	EFX_ASSERT_RESET_SERIALISED(efx);
 
@@ -2298,7 +2287,7 @@ static int efx_ioctl(struct net_device *net_dev, struct ifreq *ifr, int cmd)
  *
  **************************************************************************/
 
-static void efx_init_napi_channel(struct efx_channel *channel)
+void efx_init_napi_channel(struct efx_channel *channel)
 {
 	struct efx_nic *efx = channel->efx;
 
@@ -2307,7 +2296,7 @@ static void efx_init_napi_channel(struct efx_channel *channel)
 		       efx_poll, napi_weight);
 }
 
-static void efx_init_napi(struct efx_nic *efx)
+void efx_init_napi(struct efx_nic *efx)
 {
 	struct efx_channel *channel;
 
@@ -2315,7 +2304,7 @@ static void efx_init_napi(struct efx_nic *efx)
 		efx_init_napi_channel(channel);
 }
 
-static void efx_fini_napi_channel(struct efx_channel *channel)
+void efx_fini_napi_channel(struct efx_channel *channel)
 {
 	if (channel->napi_dev)
 		netif_napi_del(&channel->napi_str);
@@ -2323,7 +2312,7 @@ static void efx_fini_napi_channel(struct efx_channel *channel)
 	channel->napi_dev = NULL;
 }
 
-static void efx_fini_napi(struct efx_nic *efx)
+void efx_fini_napi(struct efx_nic *efx)
 {
 	struct efx_channel *channel;
 
@@ -3203,8 +3192,8 @@ static const struct efx_phy_operations efx_dummy_phy_operations = {
 /* This zeroes out and then fills in the invariants in a struct
  * efx_nic (including all sub-structures).
  */
-static int efx_init_struct(struct efx_nic *efx,
-			   struct pci_dev *pci_dev, struct net_device *net_dev)
+int efx_init_struct(struct efx_nic *efx, struct pci_dev *pci_dev,
+		    struct net_device *net_dev)
 {
 	int rc = -ENOMEM, i;
 
@@ -3283,7 +3272,7 @@ static int efx_init_struct(struct efx_nic *efx,
 	return rc;
 }
 
-static void efx_fini_struct(struct efx_nic *efx)
+void efx_fini_struct(struct efx_nic *efx)
 {
 	int i;
 
diff --git a/drivers/net/ethernet/sfc/efx.h b/drivers/net/ethernet/sfc/efx.h
index 2dd8d5002315..6ff454f2cb62 100644
--- a/drivers/net/ethernet/sfc/efx.h
+++ b/drivers/net/ethernet/sfc/efx.h
@@ -15,31 +15,19 @@ int efx_net_open(struct net_device *net_dev);
 int efx_net_stop(struct net_device *net_dev);
 
 /* TX */
-int efx_probe_tx_queue(struct efx_tx_queue *tx_queue);
-void efx_remove_tx_queue(struct efx_tx_queue *tx_queue);
-void efx_init_tx_queue(struct efx_tx_queue *tx_queue);
 void efx_init_tx_queue_core_txq(struct efx_tx_queue *tx_queue);
-void efx_fini_tx_queue(struct efx_tx_queue *tx_queue);
 netdev_tx_t efx_hard_start_xmit(struct sk_buff *skb,
 				struct net_device *net_dev);
 netdev_tx_t efx_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb);
 void efx_xmit_done(struct efx_tx_queue *tx_queue, unsigned int index);
 int efx_setup_tc(struct net_device *net_dev, enum tc_setup_type type,
 		 void *type_data);
-unsigned int efx_tx_max_skb_descs(struct efx_nic *efx);
 extern unsigned int efx_piobuf_size;
 extern bool efx_separate_tx_channels;
 
 /* RX */
 void efx_set_default_rx_indir_table(struct efx_nic *efx,
 				    struct efx_rss_context *ctx);
-void efx_rx_config_page_split(struct efx_nic *efx);
-int efx_probe_rx_queue(struct efx_rx_queue *rx_queue);
-void efx_remove_rx_queue(struct efx_rx_queue *rx_queue);
-void efx_init_rx_queue(struct efx_rx_queue *rx_queue);
-void efx_fini_rx_queue(struct efx_rx_queue *rx_queue);
-void efx_fast_push_rx_descriptors(struct efx_rx_queue *rx_queue, bool atomic);
-void efx_rx_slow_fill(struct timer_list *t);
 void __efx_rx_packet(struct efx_channel *channel);
 void efx_rx_packet(struct efx_rx_queue *rx_queue, unsigned int index,
 		   unsigned int n_frags, unsigned int len, u16 flags);
@@ -48,7 +36,6 @@ static inline void efx_rx_flush_packet(struct efx_channel *channel)
 	if (channel->rx_pkt_n_frags)
 		__efx_rx_packet(channel);
 }
-void efx_schedule_slow_fill(struct efx_rx_queue *rx_queue);
 
 #define EFX_MAX_DMAQ_SIZE 4096UL
 #define EFX_DEFAULT_DMAQ_SIZE 1024UL
@@ -80,8 +67,6 @@ static inline bool efx_rss_enabled(struct efx_nic *efx)
 
 /* Filters */
 
-void efx_mac_reconfigure(struct efx_nic *efx);
-
 /**
  * efx_filter_insert_filter - add or replace a filter
  * @efx: NIC in which to insert the filter
@@ -221,23 +206,11 @@ static inline bool efx_rss_active(struct efx_rss_context *ctx)
 /* Channels */
 int efx_channel_dummy_op_int(struct efx_channel *channel);
 void efx_channel_dummy_op_void(struct efx_channel *channel);
-int efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries);
-
-/* Ports */
-int efx_reconfigure_port(struct efx_nic *efx);
-int __efx_reconfigure_port(struct efx_nic *efx);
 
 /* Ethtool support */
 extern const struct ethtool_ops efx_ethtool_ops;
 
-/* Reset handling */
-int efx_reset(struct efx_nic *efx, enum reset_type method);
-void efx_reset_down(struct efx_nic *efx, enum reset_type method);
-int efx_reset_up(struct efx_nic *efx, enum reset_type method, bool ok);
-int efx_try_recovery(struct efx_nic *efx);
-
 /* Global */
-void efx_schedule_reset(struct efx_nic *efx, enum reset_type type);
 unsigned int efx_usecs_to_ticks(struct efx_nic *efx, unsigned int usecs);
 unsigned int efx_ticks_to_usecs(struct efx_nic *efx, unsigned int ticks);
 int efx_init_irq_moderation(struct efx_nic *efx, unsigned int tx_usecs,
@@ -245,8 +218,6 @@ int efx_init_irq_moderation(struct efx_nic *efx, unsigned int tx_usecs,
 			    bool rx_may_override_tx);
 void efx_get_irq_moderation(struct efx_nic *efx, unsigned int *tx_usecs,
 			    unsigned int *rx_usecs, bool *rx_adaptive);
-void efx_stop_eventq(struct efx_channel *channel);
-void efx_start_eventq(struct efx_channel *channel);
 
 /* Dummy PHY ops for PHY drivers */
 int efx_port_dummy_op_int(struct efx_nic *efx);
@@ -293,9 +264,6 @@ static inline void efx_schedule_channel_irq(struct efx_channel *channel)
 	efx_schedule_channel(channel);
 }
 
-void efx_link_status_changed(struct efx_nic *efx);
-void efx_link_set_advertising(struct efx_nic *efx,
-			      const unsigned long *advertising);
 void efx_link_clear_advertising(struct efx_nic *efx);
 void efx_link_set_wanted_fc(struct efx_nic *efx, u8);
 
diff --git a/drivers/net/ethernet/sfc/efx_channels.h b/drivers/net/ethernet/sfc/efx_channels.h
new file mode 100644
index 000000000000..8d7b8c4142d7
--- /dev/null
+++ b/drivers/net/ethernet/sfc/efx_channels.h
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/****************************************************************************
+ * Driver for Solarflare network controllers and boards
+ * Copyright 2018 Solarflare Communications Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation, incorporated herein by reference.
+ */
+
+#ifndef EFX_CHANNELS_H
+#define EFX_CHANNELS_H
+
+int efx_probe_interrupts(struct efx_nic *efx);
+void efx_remove_interrupts(struct efx_nic *efx);
+int efx_soft_enable_interrupts(struct efx_nic *efx);
+void efx_soft_disable_interrupts(struct efx_nic *efx);
+int efx_enable_interrupts(struct efx_nic *efx);
+void efx_disable_interrupts(struct efx_nic *efx);
+
+void efx_set_interrupt_affinity(struct efx_nic *efx);
+void efx_clear_interrupt_affinity(struct efx_nic *efx);
+
+int efx_probe_eventq(struct efx_channel *channel);
+int efx_init_eventq(struct efx_channel *channel);
+void efx_start_eventq(struct efx_channel *channel);
+void efx_stop_eventq(struct efx_channel *channel);
+void efx_fini_eventq(struct efx_channel *channel);
+void efx_remove_eventq(struct efx_channel *channel);
+
+struct efx_channel *
+efx_alloc_channel(struct efx_nic *efx, int i, struct efx_channel *old_channel);
+int efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries);
+void efx_get_channel_name(struct efx_channel *channel, char *buf, size_t len);
+void efx_set_channel_names(struct efx_nic *efx);
+int efx_init_channels(struct efx_nic *efx);
+int efx_probe_channels(struct efx_nic *efx);
+int efx_set_channels(struct efx_nic *efx);
+bool efx_default_channel_want_txqs(struct efx_channel *channel);
+void efx_remove_channel(struct efx_channel *channel);
+void efx_remove_channels(struct efx_nic *efx);
+void efx_fini_channels(struct efx_nic *efx);
+struct efx_channel *efx_copy_channel(const struct efx_channel *old_channel);
+void efx_start_channels(struct efx_nic *efx);
+void efx_stop_channels(struct efx_nic *efx);
+
+void efx_init_napi_channel(struct efx_channel *channel);
+void efx_init_napi(struct efx_nic *efx);
+void efx_fini_napi_channel(struct efx_channel *channel);
+void efx_fini_napi(struct efx_nic *efx);
+
+int efx_channel_dummy_op_int(struct efx_channel *channel);
+void efx_channel_dummy_op_void(struct efx_channel *channel);
+
+#endif
diff --git a/drivers/net/ethernet/sfc/efx_common.h b/drivers/net/ethernet/sfc/efx_common.h
new file mode 100644
index 000000000000..cb690d01adbc
--- /dev/null
+++ b/drivers/net/ethernet/sfc/efx_common.h
@@ -0,0 +1,52 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/****************************************************************************
+ * Driver for Solarflare network controllers and boards
+ * Copyright 2018 Solarflare Communications Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation, incorporated herein by reference.
+ */
+
+#ifndef EFX_COMMON_H
+#define EFX_COMMON_H
+
+int efx_init_io(struct efx_nic *efx);
+void efx_fini_io(struct efx_nic *efx);
+int efx_init_struct(struct efx_nic *efx, struct pci_dev *pci_dev,
+		    struct net_device *net_dev);
+void efx_fini_struct(struct efx_nic *efx);
+
+void efx_start_all(struct efx_nic *efx);
+void efx_stop_all(struct efx_nic *efx);
+
+int efx_create_reset_workqueue(void);
+void efx_queue_reset_work(struct efx_nic *efx);
+void efx_flush_reset_workqueue(struct efx_nic *efx);
+void efx_destroy_reset_workqueue(void);
+
+void efx_start_monitor(struct efx_nic *efx);
+
+int __efx_reconfigure_port(struct efx_nic *efx);
+int efx_reconfigure_port(struct efx_nic *efx);
+
+#define EFX_ASSERT_RESET_SERIALISED(efx)		\
+	do {						\
+		if ((efx->state == STATE_READY) ||	\
+		    (efx->state == STATE_RECOVERY) ||	\
+		    (efx->state == STATE_DISABLED))	\
+			ASSERT_RTNL();			\
+	} while (0)
+
+int efx_try_recovery(struct efx_nic *efx);
+void efx_reset_down(struct efx_nic *efx, enum reset_type method);
+int efx_reset_up(struct efx_nic *efx, enum reset_type method, bool ok);
+int efx_reset(struct efx_nic *efx, enum reset_type method);
+void efx_schedule_reset(struct efx_nic *efx, enum reset_type type);
+
+int efx_check_disabled(struct efx_nic *efx);
+
+void efx_mac_reconfigure(struct efx_nic *efx);
+void efx_link_status_changed(struct efx_nic *efx);
+
+#endif
diff --git a/drivers/net/ethernet/sfc/ethtool.c b/drivers/net/ethernet/sfc/ethtool.c
index b31032da4bcb..f83398721ad7 100644
--- a/drivers/net/ethernet/sfc/ethtool.c
+++ b/drivers/net/ethernet/sfc/ethtool.c
@@ -13,6 +13,9 @@
 #include "workarounds.h"
 #include "selftest.h"
 #include "efx.h"
+#include "efx_channels.h"
+#include "rx_common.h"
+#include "tx_common.h"
 #include "filter.h"
 #include "nic.h"
 
diff --git a/drivers/net/ethernet/sfc/farch.c b/drivers/net/ethernet/sfc/farch.c
index eedd32e2bfcb..dbbb898adddb 100644
--- a/drivers/net/ethernet/sfc/farch.c
+++ b/drivers/net/ethernet/sfc/farch.c
@@ -15,6 +15,7 @@
 #include "net_driver.h"
 #include "bitfield.h"
 #include "efx.h"
+#include "rx_common.h"
 #include "nic.h"
 #include "farch_regs.h"
 #include "sriov.h"
diff --git a/drivers/net/ethernet/sfc/mcdi.h b/drivers/net/ethernet/sfc/mcdi.h
index 9081f84a2604..65e454a062f7 100644
--- a/drivers/net/ethernet/sfc/mcdi.h
+++ b/drivers/net/ethernet/sfc/mcdi.h
@@ -346,7 +346,6 @@ int efx_mcdi_flush_rxqs(struct efx_nic *efx);
 int efx_mcdi_port_probe(struct efx_nic *efx);
 void efx_mcdi_port_remove(struct efx_nic *efx);
 int efx_mcdi_port_reconfigure(struct efx_nic *efx);
-int efx_mcdi_port_get_number(struct efx_nic *efx);
 u32 efx_mcdi_phy_get_caps(struct efx_nic *efx);
 void efx_mcdi_process_link_change(struct efx_nic *efx, efx_qword_t *ev);
 int efx_mcdi_set_mac(struct efx_nic *efx);
diff --git a/drivers/net/ethernet/sfc/mcdi_functions.h b/drivers/net/ethernet/sfc/mcdi_functions.h
new file mode 100644
index 000000000000..f0726c71698b
--- /dev/null
+++ b/drivers/net/ethernet/sfc/mcdi_functions.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/****************************************************************************
+ * Driver for Solarflare network controllers and boards
+ * Copyright 2018 Solarflare Communications Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation, incorporated herein by reference.
+ */
+#ifndef EFX_MCDI_FUNCTIONS_H
+#define EFX_MCDI_FUNCTIONS_H
+
+int efx_mcdi_alloc_vis(struct efx_nic *efx, unsigned int min_vis,
+		       unsigned int max_vis, unsigned int *vi_base,
+		       unsigned int *allocated_vis);
+int efx_mcdi_free_vis(struct efx_nic *efx);
+
+int efx_mcdi_ev_probe(struct efx_channel *channel);
+int efx_mcdi_ev_init(struct efx_channel *channel, bool v1_cut_thru, bool v2);
+void efx_mcdi_ev_remove(struct efx_channel *channel);
+void efx_mcdi_ev_fini(struct efx_channel *channel);
+int efx_mcdi_tx_init(struct efx_tx_queue *tx_queue, bool tso_v2);
+void efx_mcdi_tx_remove(struct efx_tx_queue *tx_queue);
+void efx_mcdi_tx_fini(struct efx_tx_queue *tx_queue);
+int efx_mcdi_rx_probe(struct efx_rx_queue *rx_queue);
+int efx_mcdi_rx_init(struct efx_rx_queue *rx_queue, bool want_outer_classes);
+void efx_mcdi_rx_remove(struct efx_rx_queue *rx_queue);
+void efx_mcdi_rx_fini(struct efx_rx_queue *rx_queue);
+
+#endif
diff --git a/drivers/net/ethernet/sfc/mcdi_port.c b/drivers/net/ethernet/sfc/mcdi_port.c
index fb7cde4980ed..f19d7b8a2935 100644
--- a/drivers/net/ethernet/sfc/mcdi_port.c
+++ b/drivers/net/ethernet/sfc/mcdi_port.c
@@ -14,23 +14,9 @@
 #include "mcdi_pcol.h"
 #include "nic.h"
 #include "selftest.h"
+#include "mcdi_port_common.h"
 
-struct efx_mcdi_phy_data {
-	u32 flags;
-	u32 type;
-	u32 supported_cap;
-	u32 channel;
-	u32 port;
-	u32 stats_mask;
-	u8 name[20];
-	u32 media;
-	u32 mmd_mask;
-	u8 revision[20];
-	u32 forced_cap;
-};
-
-static int
-efx_mcdi_get_phy_cfg(struct efx_nic *efx, struct efx_mcdi_phy_data *cfg)
+int efx_mcdi_get_phy_cfg(struct efx_nic *efx, struct efx_mcdi_phy_data *cfg)
 {
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_PHY_CFG_OUT_LEN);
 	size_t outlen;
@@ -70,9 +56,9 @@ efx_mcdi_get_phy_cfg(struct efx_nic *efx, struct efx_mcdi_phy_data *cfg)
 	return rc;
 }
 
-static int efx_mcdi_set_link(struct efx_nic *efx, u32 capabilities,
-			     u32 flags, u32 loopback_mode,
-			     u32 loopback_speed)
+int efx_mcdi_set_link(struct efx_nic *efx, u32 capabilities,
+		      u32 flags, u32 loopback_mode,
+		      u32 loopback_speed)
 {
 	MCDI_DECLARE_BUF(inbuf, MC_CMD_SET_LINK_IN_LEN);
 	int rc;
@@ -89,7 +75,7 @@ static int efx_mcdi_set_link(struct efx_nic *efx, u32 capabilities,
 	return rc;
 }
 
-static int efx_mcdi_loopback_modes(struct efx_nic *efx, u64 *loopback_modes)
+int efx_mcdi_loopback_modes(struct efx_nic *efx, u64 *loopback_modes)
 {
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_LOOPBACK_MODES_OUT_LEN);
 	size_t outlen;
@@ -168,7 +154,7 @@ static int efx_mcdi_mdio_write(struct net_device *net_dev,
 	return 0;
 }
 
-static void mcdi_to_ethtool_linkset(u32 media, u32 cap, unsigned long *linkset)
+void mcdi_to_ethtool_linkset(u32 media, u32 cap, unsigned long *linkset)
 {
 	#define SET_BIT(name)	__set_bit(ETHTOOL_LINK_MODE_ ## name ## _BIT, \
 					  linkset)
@@ -232,7 +218,7 @@ static void mcdi_to_ethtool_linkset(u32 media, u32 cap, unsigned long *linkset)
 	#undef SET_BIT
 }
 
-static u32 ethtool_linkset_to_mcdi_cap(const unsigned long *linkset)
+u32 ethtool_linkset_to_mcdi_cap(const unsigned long *linkset)
 {
 	u32 result = 0;
 
@@ -273,7 +259,7 @@ static u32 ethtool_linkset_to_mcdi_cap(const unsigned long *linkset)
 	return result;
 }
 
-static u32 efx_get_mcdi_phy_flags(struct efx_nic *efx)
+u32 efx_get_mcdi_phy_flags(struct efx_nic *efx)
 {
 	struct efx_mcdi_phy_data *phy_cfg = efx->phy_data;
 	enum efx_phy_mode mode, supported;
@@ -301,7 +287,7 @@ static u32 efx_get_mcdi_phy_flags(struct efx_nic *efx)
 	return flags;
 }
 
-static u8 mcdi_to_ethtool_media(u32 media)
+u8 mcdi_to_ethtool_media(u32 media)
 {
 	switch (media) {
 	case MC_CMD_MEDIA_XAUI:
@@ -322,7 +308,7 @@ static u8 mcdi_to_ethtool_media(u32 media)
 	}
 }
 
-static void efx_mcdi_phy_decode_link(struct efx_nic *efx,
+void efx_mcdi_phy_decode_link(struct efx_nic *efx,
 			      struct efx_link_state *link_state,
 			      u32 speed, u32 flags, u32 fcntl)
 {
@@ -365,7 +351,7 @@ static void efx_mcdi_phy_decode_link(struct efx_nic *efx,
  * Both RS and BASER (whether AUTO or not) means use FEC if cable and link
  * partner support it, preferring RS to BASER.
  */
-static u32 ethtool_fec_caps_to_mcdi(u32 ethtool_cap)
+u32 ethtool_fec_caps_to_mcdi(u32 ethtool_cap)
 {
 	u32 ret = 0;
 
@@ -392,7 +378,7 @@ static u32 ethtool_fec_caps_to_mcdi(u32 ethtool_cap)
  * maps both of those to AUTO.  This should never matter, and it's not clear
  * what a better mapping would be anyway.
  */
-static u32 mcdi_fec_caps_to_ethtool(u32 caps, bool is_25g)
+u32 mcdi_fec_caps_to_ethtool(u32 caps, bool is_25g)
 {
 	bool rs = caps & (1 << MC_CMD_PHY_CAP_RS_FEC_LBN),
 	     rs_req = caps & (1 << MC_CMD_PHY_CAP_RS_FEC_REQUESTED_LBN),
@@ -530,7 +516,7 @@ int efx_mcdi_port_reconfigure(struct efx_nic *efx)
 /* Verify that the forced flow control settings (!EFX_FC_AUTO) are
  * supported by the link partner. Warn the user if this isn't the case
  */
-static void efx_mcdi_phy_check_fcntl(struct efx_nic *efx, u32 lpa)
+void efx_mcdi_phy_check_fcntl(struct efx_nic *efx, u32 lpa)
 {
 	struct efx_mcdi_phy_data *phy_cfg = efx->phy_data;
 	u32 rmtadv;
@@ -555,7 +541,7 @@ static void efx_mcdi_phy_check_fcntl(struct efx_nic *efx, u32 lpa)
 			  "warning: link partner doesn't support pause frames");
 }
 
-static bool efx_mcdi_phy_poll(struct efx_nic *efx)
+bool efx_mcdi_phy_poll(struct efx_nic *efx)
 {
 	struct efx_link_state old_state = efx->link_state;
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_LINK_OUT_LEN);
@@ -666,8 +652,8 @@ efx_mcdi_phy_set_link_ksettings(struct efx_nic *efx,
 	return 0;
 }
 
-static int efx_mcdi_phy_get_fecparam(struct efx_nic *efx,
-				     struct ethtool_fecparam *fec)
+int efx_mcdi_phy_get_fecparam(struct efx_nic *efx,
+			      struct ethtool_fecparam *fec)
 {
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_LINK_OUT_V2_LEN);
 	u32 caps, active, speed; /* MCDI format */
@@ -745,7 +731,7 @@ static int efx_mcdi_phy_set_fecparam(struct efx_nic *efx,
 	return 0;
 }
 
-static int efx_mcdi_phy_test_alive(struct efx_nic *efx)
+int efx_mcdi_phy_test_alive(struct efx_nic *efx)
 {
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_PHY_STATE_OUT_LEN);
 	size_t outlen;
diff --git a/drivers/net/ethernet/sfc/mcdi_port_common.h b/drivers/net/ethernet/sfc/mcdi_port_common.h
new file mode 100644
index 000000000000..10772de94b2c
--- /dev/null
+++ b/drivers/net/ethernet/sfc/mcdi_port_common.h
@@ -0,0 +1,53 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/****************************************************************************
+ * Driver for Solarflare network controllers and boards
+ * Copyright 2018 Solarflare Communications Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation, incorporated herein by reference.
+ */
+#ifndef EFX_MCDI_PORT_COMMON_H
+#define EFX_MCDI_PORT_COMMON_H
+
+#include "net_driver.h"
+#include "mcdi.h"
+#include "mcdi_pcol.h"
+
+struct efx_mcdi_phy_data {
+	u32 flags;
+	u32 type;
+	u32 supported_cap;
+	u32 channel;
+	u32 port;
+	u32 stats_mask;
+	u8 name[20];
+	u32 media;
+	u32 mmd_mask;
+	u8 revision[20];
+	u32 forced_cap;
+};
+
+int efx_mcdi_get_phy_cfg(struct efx_nic *efx, struct efx_mcdi_phy_data *cfg);
+void efx_link_set_advertising(struct efx_nic *efx,
+			      const unsigned long *advertising);
+int efx_mcdi_set_link(struct efx_nic *efx, u32 capabilities,
+		      u32 flags, u32 loopback_mode, u32 loopback_speed);
+int efx_mcdi_loopback_modes(struct efx_nic *efx, u64 *loopback_modes);
+void mcdi_to_ethtool_linkset(u32 media, u32 cap, unsigned long *linkset);
+u32 ethtool_linkset_to_mcdi_cap(const unsigned long *linkset);
+u32 efx_get_mcdi_phy_flags(struct efx_nic *efx);
+u8 mcdi_to_ethtool_media(u32 media);
+void efx_mcdi_phy_decode_link(struct efx_nic *efx,
+			      struct efx_link_state *link_state,
+			      u32 speed, u32 flags, u32 fcntl);
+u32 ethtool_fec_caps_to_mcdi(u32 ethtool_cap);
+u32 mcdi_fec_caps_to_ethtool(u32 caps, bool is_25g);
+void efx_mcdi_phy_check_fcntl(struct efx_nic *efx, u32 lpa);
+bool efx_mcdi_phy_poll(struct efx_nic *efx);
+int efx_mcdi_phy_get_fecparam(struct efx_nic *efx,
+			      struct ethtool_fecparam *fec);
+int efx_mcdi_phy_test_alive(struct efx_nic *efx);
+int efx_mcdi_port_get_number(struct efx_nic *efx);
+
+#endif
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 709172a6995e..52e6f11d8818 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -138,6 +138,8 @@ struct efx_special_buffer {
  *	freed when descriptor completes
  * @xdpf: When @flags & %EFX_TX_BUF_XDP, the XDP frame information; its @data
  *	member is the associated buffer to drop a page reference on.
+ * @option: When @flags & %EFX_TX_BUF_OPTION, an EF10-specific option
+ *	descriptor.
  * @dma_addr: DMA address of the fragment.
  * @flags: Flags for allocation and DMA mapping type
  * @len: Length of this fragment.
@@ -152,7 +154,7 @@ struct efx_tx_buffer {
 		struct xdp_frame *xdpf;
 	};
 	union {
-		efx_qword_t option;
+		efx_qword_t option;    /* EF10 */
 		dma_addr_t dma_addr;
 	};
 	unsigned short flags;
@@ -1610,6 +1612,15 @@ static inline struct efx_rx_buffer *efx_rx_buffer(struct efx_rx_queue *rx_queue,
 	return &rx_queue->buffer[index];
 }
 
+static inline struct efx_rx_buffer *
+efx_rx_buf_next(struct efx_rx_queue *rx_queue, struct efx_rx_buffer *rx_buf)
+{
+	if (unlikely(rx_buf == efx_rx_buffer(rx_queue, rx_queue->ptr_mask)))
+		return efx_rx_buffer(rx_queue, 0);
+	else
+		return rx_buf + 1;
+}
+
 /**
  * EFX_MAX_FRAME_LEN - calculate maximum frame length
  *
diff --git a/drivers/net/ethernet/sfc/nic.h b/drivers/net/ethernet/sfc/nic.h
index bf0bdb22cc64..6670fda8f35a 100644
--- a/drivers/net/ethernet/sfc/nic.h
+++ b/drivers/net/ethernet/sfc/nic.h
@@ -11,6 +11,7 @@
 #include <linux/net_tstamp.h>
 #include "net_driver.h"
 #include "efx.h"
+#include "efx_common.h"
 #include "mcdi.h"
 
 enum {
@@ -505,6 +506,9 @@ static inline void efx_nic_push_buffers(struct efx_tx_queue *tx_queue)
 	tx_queue->efx->type->tx_write(tx_queue);
 }
 
+int efx_enqueue_skb_tso(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
+			bool *data_mapped);
+
 /* RX data path */
 static inline int efx_nic_probe_rx(struct efx_rx_queue *rx_queue)
 {
@@ -553,6 +557,7 @@ static inline void efx_nic_eventq_read_ack(struct efx_channel *channel)
 {
 	channel->efx->type->ev_read_ack(channel);
 }
+
 void efx_nic_event_test_start(struct efx_channel *channel);
 
 /* Falcon/Siena queue operations */
@@ -670,6 +675,7 @@ struct efx_farch_register_test {
 	unsigned address;
 	efx_oword_t mask;
 };
+
 int efx_farch_test_registers(struct efx_nic *efx,
 			     const struct efx_farch_register_test *regs,
 			     size_t n_regs);
diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.c
index c29bf862a94c..26b5c36237fe 100644
--- a/drivers/net/ethernet/sfc/rx.c
+++ b/drivers/net/ethernet/sfc/rx.c
@@ -21,6 +21,7 @@
 #include <linux/bpf_trace.h>
 #include "net_driver.h"
 #include "efx.h"
+#include "rx_common.h"
 #include "filter.h"
 #include "nic.h"
 #include "selftest.h"
@@ -77,15 +78,6 @@ static inline u32 efx_rx_buf_hash(struct efx_nic *efx, const u8 *eh)
 #endif
 }
 
-static inline struct efx_rx_buffer *
-efx_rx_buf_next(struct efx_rx_queue *rx_queue, struct efx_rx_buffer *rx_buf)
-{
-	if (unlikely(rx_buf == efx_rx_buffer(rx_queue, rx_queue->ptr_mask)))
-		return efx_rx_buffer(rx_queue, 0);
-	else
-		return rx_buf + 1;
-}
-
 static inline void efx_sync_rx_buffer(struct efx_nic *efx,
 				      struct efx_rx_buffer *rx_buf,
 				      unsigned int len)
@@ -152,7 +144,7 @@ static struct page *efx_reuse_page(struct efx_rx_queue *rx_queue)
  * 0 on success. If a single page can be used for multiple buffers,
  * then the page will either be inserted fully, or not at all.
  */
-static int efx_init_rx_buffers(struct efx_rx_queue *rx_queue, bool atomic)
+int efx_init_rx_buffers(struct efx_rx_queue *rx_queue, bool atomic)
 {
 	struct efx_nic *efx = rx_queue->efx;
 	struct efx_rx_buffer *rx_buf;
@@ -215,8 +207,8 @@ static int efx_init_rx_buffers(struct efx_rx_queue *rx_queue, bool atomic)
 /* Unmap a DMA-mapped page.  This function is only called for the final RX
  * buffer in a page.
  */
-static void efx_unmap_rx_buffer(struct efx_nic *efx,
-				struct efx_rx_buffer *rx_buf)
+void efx_unmap_rx_buffer(struct efx_nic *efx,
+			 struct efx_rx_buffer *rx_buf)
 {
 	struct page *page = rx_buf->page;
 
@@ -229,9 +221,9 @@ static void efx_unmap_rx_buffer(struct efx_nic *efx,
 	}
 }
 
-static void efx_free_rx_buffers(struct efx_rx_queue *rx_queue,
-				struct efx_rx_buffer *rx_buf,
-				unsigned int num_bufs)
+void efx_free_rx_buffers(struct efx_rx_queue *rx_queue,
+			 struct efx_rx_buffer *rx_buf,
+			 unsigned int num_bufs)
 {
 	do {
 		if (rx_buf->page) {
diff --git a/drivers/net/ethernet/sfc/rx_common.h b/drivers/net/ethernet/sfc/rx_common.h
new file mode 100644
index 000000000000..8b23a7accea1
--- /dev/null
+++ b/drivers/net/ethernet/sfc/rx_common.h
@@ -0,0 +1,42 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/****************************************************************************
+ * Driver for Solarflare network controllers and boards
+ * Copyright 2018 Solarflare Communications Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation, incorporated herein by reference.
+ */
+
+#ifndef EFX_RX_COMMON_H
+#define EFX_RX_COMMON_H
+
+/* Preferred number of descriptors to fill at once */
+#define EFX_RX_PREFERRED_BATCH 8U
+
+/* Each packet can consume up to ceil(max_frame_len / buffer_size) buffers */
+#define EFX_RX_MAX_FRAGS DIV_ROUND_UP(EFX_MAX_FRAME_LEN(EFX_MAX_MTU), \
+				      EFX_RX_USR_BUF_SIZE)
+
+void efx_rx_slow_fill(struct timer_list *t);
+
+int efx_probe_rx_queue(struct efx_rx_queue *rx_queue);
+void efx_init_rx_queue(struct efx_rx_queue *rx_queue);
+void efx_fini_rx_queue(struct efx_rx_queue *rx_queue);
+void efx_remove_rx_queue(struct efx_rx_queue *rx_queue);
+void efx_destroy_rx_queue(struct efx_rx_queue *rx_queue);
+
+void efx_init_rx_buffer(struct efx_rx_queue *rx_queue,
+			struct page *page,
+			unsigned int page_offset,
+			u16 flags);
+void efx_unmap_rx_buffer(struct efx_nic *efx, struct efx_rx_buffer *rx_buf);
+void efx_free_rx_buffers(struct efx_rx_queue *rx_queue,
+			 struct efx_rx_buffer *rx_buf,
+			 unsigned int num_bufs);
+
+void efx_schedule_slow_fill(struct efx_rx_queue *rx_queue);
+void efx_rx_config_page_split(struct efx_nic *efx);
+void efx_fast_push_rx_descriptors(struct efx_rx_queue *rx_queue, bool atomic);
+
+#endif
diff --git a/drivers/net/ethernet/sfc/selftest.c b/drivers/net/ethernet/sfc/selftest.c
index 8474cf8ea7d3..ec5002b5ec4f 100644
--- a/drivers/net/ethernet/sfc/selftest.c
+++ b/drivers/net/ethernet/sfc/selftest.c
@@ -18,6 +18,8 @@
 #include <linux/slab.h>
 #include "net_driver.h"
 #include "efx.h"
+#include "efx_common.h"
+#include "efx_channels.h"
 #include "nic.h"
 #include "selftest.h"
 #include "workarounds.h"
diff --git a/drivers/net/ethernet/sfc/siena.c b/drivers/net/ethernet/sfc/siena.c
index 81499244a4b4..810f6fc8a937 100644
--- a/drivers/net/ethernet/sfc/siena.c
+++ b/drivers/net/ethernet/sfc/siena.c
@@ -14,6 +14,7 @@
 #include "net_driver.h"
 #include "bitfield.h"
 #include "efx.h"
+#include "efx_common.h"
 #include "nic.h"
 #include "farch_regs.h"
 #include "io.h"
diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
index 00c1c4402451..1c30354e098c 100644
--- a/drivers/net/ethernet/sfc/tx.c
+++ b/drivers/net/ethernet/sfc/tx.c
@@ -20,6 +20,7 @@
 #include "io.h"
 #include "nic.h"
 #include "tx.h"
+#include "tx_common.h"
 #include "workarounds.h"
 #include "ef10_regs.h"
 
@@ -56,10 +57,10 @@ u8 *efx_tx_get_copy_buffer_limited(struct efx_tx_queue *tx_queue,
 	return efx_tx_get_copy_buffer(tx_queue, buffer);
 }
 
-static void efx_dequeue_buffer(struct efx_tx_queue *tx_queue,
-			       struct efx_tx_buffer *buffer,
-			       unsigned int *pkts_compl,
-			       unsigned int *bytes_compl)
+void efx_dequeue_buffer(struct efx_tx_queue *tx_queue,
+			struct efx_tx_buffer *buffer,
+			unsigned int *pkts_compl,
+			unsigned int *bytes_compl)
 {
 	if (buffer->unmap_len) {
 		struct device *dma_dev = &tx_queue->efx->pci_dev->dev;
@@ -333,9 +334,9 @@ static int efx_enqueue_skb_pio(struct efx_tx_queue *tx_queue,
 }
 #endif /* EFX_USE_PIO */
 
-static struct efx_tx_buffer *efx_tx_map_chunk(struct efx_tx_queue *tx_queue,
-					      dma_addr_t dma_addr,
-					      size_t len)
+struct efx_tx_buffer *efx_tx_map_chunk(struct efx_tx_queue *tx_queue,
+				       dma_addr_t dma_addr,
+				       size_t len)
 {
 	const struct efx_nic_type *nic_type = tx_queue->efx->type;
 	struct efx_tx_buffer *buffer;
@@ -359,8 +360,8 @@ static struct efx_tx_buffer *efx_tx_map_chunk(struct efx_tx_queue *tx_queue,
 
 /* Map all data from an SKB for DMA and create descriptors on the queue.
  */
-static int efx_tx_map_data(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
-			   unsigned int segment_count)
+int efx_tx_map_data(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
+		    unsigned int segment_count)
 {
 	struct efx_nic *efx = tx_queue->efx;
 	struct device *dma_dev = &efx->pci_dev->dev;
diff --git a/drivers/net/ethernet/sfc/tx_common.h b/drivers/net/ethernet/sfc/tx_common.h
new file mode 100644
index 000000000000..afdfc79a8ea0
--- /dev/null
+++ b/drivers/net/ethernet/sfc/tx_common.h
@@ -0,0 +1,31 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/****************************************************************************
+ * Driver for Solarflare network controllers and boards
+ * Copyright 2018 Solarflare Communications Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation, incorporated herein by reference.
+ */
+
+#ifndef EFX_TX_COMMON_H
+#define EFX_TX_COMMON_H
+
+int efx_probe_tx_queue(struct efx_tx_queue *tx_queue);
+void efx_init_tx_queue(struct efx_tx_queue *tx_queue);
+void efx_fini_tx_queue(struct efx_tx_queue *tx_queue);
+void efx_remove_tx_queue(struct efx_tx_queue *tx_queue);
+
+void efx_dequeue_buffer(struct efx_tx_queue *tx_queue,
+			struct efx_tx_buffer *buffer,
+			unsigned int *pkts_compl,
+			unsigned int *bytes_compl);
+
+struct efx_tx_buffer *efx_tx_map_chunk(struct efx_tx_queue *tx_queue,
+				       dma_addr_t dma_addr, size_t len);
+int efx_tx_map_data(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
+		    unsigned int segment_count);
+
+unsigned int efx_tx_max_skb_descs(struct efx_nic *efx);
+
+#endif
-- 
2.20.1



