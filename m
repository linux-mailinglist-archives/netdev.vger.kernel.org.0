Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BEBC22EB8E
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 13:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728254AbgG0L4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 07:56:07 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:51036 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727088AbgG0L4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 07:56:07 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.64])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 111C160096;
        Mon, 27 Jul 2020 11:56:05 +0000 (UTC)
Received: from us4-mdac16-2.ut7.mdlocal (unknown [10.7.65.70])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 0F4562009B;
        Mon, 27 Jul 2020 11:56:05 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.31])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 512ED22004D;
        Mon, 27 Jul 2020 11:56:04 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id A25E9940054;
        Mon, 27 Jul 2020 11:56:03 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 27 Jul
 2020 12:55:58 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v5 net-next 04/16] sfc: skeleton EF100 PF driver
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <72cc6ef1-4f7f-bf22-5bec-942beb6353ed@solarflare.com>
Message-ID: <502269cb-74c1-02e9-894b-373ded300465@solarflare.com>
Date:   Mon, 27 Jul 2020 12:55:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <72cc6ef1-4f7f-bf22-5bec-942beb6353ed@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25566.005
X-TM-AS-Result: No-6.403600-8.000000-10
X-TMASE-MatchedRID: fU+NCbyBNBmyPSIT2k6m5EM/y5EMs/JmOTjDMsgp/8FWPcnrekBHfNlC
        JKzdgWU6TQ0JkPG2879V4HNAAEjuPkUJwFoxFPdrsFkCLeeufNtGI9Mwxz8yaSVUVJNKM+0dyJN
        a6DYLgM2XUzspP39qoBSiTGLfVnzerSKKfw/QqNVPs79gcmEg0Etc8DbogbSE31GU/N5W5BB42s
        15z/uIuGbSQUnvDV1ncWLklltEhMBh44VlLBLudI0JVVcEm48nFBBqKQc8RSdUjspoiX02F6T+L
        5D9x/jKYvHDi6owMqk9ale0zS6mxF14TAV3phuUBcaL/tyWL2M9mZudjaoMid9zZd3pUn7KQ1GJ
        L9SdCx+xgMT5dyKQL8yraoXH55SUPgzGD9WOF8+3D7EeeyZCMwoXSOLC5a44Dza4K8pr9bdnmli
        DOiSLQ3tFjjr9TGLC3WnikVdwSScL6X18h/dLbCIlPYcelunmdFwpLZlW5vVjjMm9SMavFQYxJy
        kfuo4A0ZiHYm0cDqVhWU2vzPHGyl9XRwZBPkGQkr0W/BDHWEXmTPEuA2FKKRlAJyV0DPGybB51Y
        JYRNfFX6mZf8RDtgikTGeJZVBs5tPSNURdbMHAMOWxRtywg+lJVMsx1CTj3Rv42dwBeoHvD9iRj
        9LIMxmAUgCBEamo8L3N7x/GmgwE/4fo82jMOqDQ60lWQoG0rLYdywTHl7nv/64I/Z3Fs/T5l7G/
        l0cAqqT5QyTzcBXcD/RBcLWr1gh2kPcMpOH5ASZJFFtJz2zc8/9bDwLOgR9uykrHhg4Pdxmos9Q
        G2BXlY6JfesOfoPn368Ltj4hpzNJC5O3FGeZKeAiCmPx4NwLTrdaH1ZWqC1kTfEkyaZdz6C0ePs
        7A07QKmARN5PTKc
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.403600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25566.005
X-MDID: 1595850964-SsnmqFdmPqhP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No TX or RX path, no MCDI, not even an ifup/down handler.
Besides stubs, the bulk of the patch deals with reading the Xilinx
 extended PCIe capability, which tells us where to find our BAR.

Though in the same module, EF100 has its own struct pci_driver,
 which is named sfc_ef100.

A small number of additional nic_type methods are added; those in the
 TX (tx_enqueue) and RX (rx_packet) paths are called through indirect
 call wrappers to minimise the performance impact.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/Kconfig          |   5 +-
 drivers/net/ethernet/sfc/Makefile         |   4 +-
 drivers/net/ethernet/sfc/ef10.c           |   7 +
 drivers/net/ethernet/sfc/ef100.c          | 541 ++++++++++++++++++++++
 drivers/net/ethernet/sfc/ef100.h          |  12 +
 drivers/net/ethernet/sfc/ef100_ethtool.c  |  24 +
 drivers/net/ethernet/sfc/ef100_ethtool.h  |  12 +
 drivers/net/ethernet/sfc/ef100_netdev.c   | 129 ++++++
 drivers/net/ethernet/sfc/ef100_netdev.h   |  17 +
 drivers/net/ethernet/sfc/ef100_nic.c      | 174 +++++++
 drivers/net/ethernet/sfc/ef100_nic.h      |  26 ++
 drivers/net/ethernet/sfc/ef100_rx.c       |  25 +
 drivers/net/ethernet/sfc/ef100_rx.h       |  19 +
 drivers/net/ethernet/sfc/ef100_tx.c       |  32 ++
 drivers/net/ethernet/sfc/ef100_tx.h       |  18 +
 drivers/net/ethernet/sfc/efx.c            |   8 +
 drivers/net/ethernet/sfc/efx.h            |  16 +-
 drivers/net/ethernet/sfc/ethtool.c        |   2 -
 drivers/net/ethernet/sfc/ethtool_common.c |   2 +-
 drivers/net/ethernet/sfc/ethtool_common.h |   2 -
 drivers/net/ethernet/sfc/mcdi.c           |   2 +-
 drivers/net/ethernet/sfc/net_driver.h     |  16 +
 drivers/net/ethernet/sfc/nic_common.h     |   6 +
 drivers/net/ethernet/sfc/siena.c          |   3 +
 drivers/net/ethernet/sfc/tx.c             |   4 +-
 drivers/net/ethernet/sfc/tx_common.h      |   2 +
 26 files changed, 1095 insertions(+), 13 deletions(-)
 create mode 100644 drivers/net/ethernet/sfc/ef100.c
 create mode 100644 drivers/net/ethernet/sfc/ef100.h
 create mode 100644 drivers/net/ethernet/sfc/ef100_ethtool.c
 create mode 100644 drivers/net/ethernet/sfc/ef100_ethtool.h
 create mode 100644 drivers/net/ethernet/sfc/ef100_netdev.c
 create mode 100644 drivers/net/ethernet/sfc/ef100_netdev.h
 create mode 100644 drivers/net/ethernet/sfc/ef100_nic.c
 create mode 100644 drivers/net/ethernet/sfc/ef100_nic.h
 create mode 100644 drivers/net/ethernet/sfc/ef100_rx.c
 create mode 100644 drivers/net/ethernet/sfc/ef100_rx.h
 create mode 100644 drivers/net/ethernet/sfc/ef100_tx.c
 create mode 100644 drivers/net/ethernet/sfc/ef100_tx.h

diff --git a/drivers/net/ethernet/sfc/Kconfig b/drivers/net/ethernet/sfc/Kconfig
index 81b0f7d3a025..5e37c8313725 100644
--- a/drivers/net/ethernet/sfc/Kconfig
+++ b/drivers/net/ethernet/sfc/Kconfig
@@ -17,7 +17,7 @@ config NET_VENDOR_SOLARFLARE
 if NET_VENDOR_SOLARFLARE
 
 config SFC
-	tristate "Solarflare SFC9000/SFC9100-family support"
+	tristate "Solarflare SFC9000/SFC9100/EF100-family support"
 	depends on PCI
 	select MDIO
 	select CRC32
@@ -26,6 +26,9 @@ config SFC
 	  This driver supports 10/40-gigabit Ethernet cards based on
 	  the Solarflare SFC9000-family and SFC9100-family controllers.
 
+	  It also supports 10/25/40/100-gigabit Ethernet cards based
+	  on the Solarflare EF100 networking IP in Xilinx FPGAs.
+
 	  To compile this driver as a module, choose M here.  The module
 	  will be called sfc.
 config SFC_MTD
diff --git a/drivers/net/ethernet/sfc/Makefile b/drivers/net/ethernet/sfc/Makefile
index 87d093da22ca..8bd01c429f91 100644
--- a/drivers/net/ethernet/sfc/Makefile
+++ b/drivers/net/ethernet/sfc/Makefile
@@ -4,7 +4,9 @@ sfc-y			+= efx.o efx_common.o efx_channels.o nic.o \
 			   tx.o tx_common.o tx_tso.o rx.o rx_common.o \
 			   selftest.o ethtool.o ethtool_common.o ptp.o \
 			   mcdi.o mcdi_port.o mcdi_port_common.o \
-			   mcdi_functions.o mcdi_filters.o mcdi_mon.o
+			   mcdi_functions.o mcdi_filters.o mcdi_mon.o \
+			   ef100.o ef100_nic.o ef100_netdev.o \
+			   ef100_ethtool.o ef100_rx.o ef100_tx.o
 sfc-$(CONFIG_SFC_MTD)	+= mtd.o
 sfc-$(CONFIG_SFC_SRIOV)	+= sriov.o siena_sriov.o ef10_sriov.o
 
diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index fa7229fff2ff..4b0b2cf026a5 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -6,6 +6,7 @@
 
 #include "net_driver.h"
 #include "rx_common.h"
+#include "tx_common.h"
 #include "ef10_regs.h"
 #include "io.h"
 #include "mcdi.h"
@@ -3977,6 +3978,7 @@ const struct efx_nic_type efx_hunt_a0_vf_nic_type = {
 	.tx_remove = efx_mcdi_tx_remove,
 	.tx_write = efx_ef10_tx_write,
 	.tx_limit_len = efx_ef10_tx_limit_len,
+	.tx_enqueue = __efx_enqueue_skb,
 	.rx_push_rss_config = efx_mcdi_vf_rx_push_rss_config,
 	.rx_pull_rss_config = efx_mcdi_rx_pull_rss_config,
 	.rx_probe = efx_mcdi_rx_probe,
@@ -3984,6 +3986,7 @@ const struct efx_nic_type efx_hunt_a0_vf_nic_type = {
 	.rx_remove = efx_mcdi_rx_remove,
 	.rx_write = efx_ef10_rx_write,
 	.rx_defer_refill = efx_ef10_rx_defer_refill,
+	.rx_packet = __efx_rx_packet,
 	.ev_probe = efx_mcdi_ev_probe,
 	.ev_init = efx_ef10_ev_init,
 	.ev_fini = efx_mcdi_ev_fini,
@@ -4038,6 +4041,7 @@ const struct efx_nic_type efx_hunt_a0_vf_nic_type = {
 	.rx_hash_key_size = 40,
 	.check_caps = ef10_check_caps,
 	.print_additional_fwver = efx_ef10_print_additional_fwver,
+	.sensor_event = efx_mcdi_sensor_event,
 };
 
 const struct efx_nic_type efx_hunt_a0_nic_type = {
@@ -4087,6 +4091,7 @@ const struct efx_nic_type efx_hunt_a0_nic_type = {
 	.tx_remove = efx_mcdi_tx_remove,
 	.tx_write = efx_ef10_tx_write,
 	.tx_limit_len = efx_ef10_tx_limit_len,
+	.tx_enqueue = __efx_enqueue_skb,
 	.rx_push_rss_config = efx_mcdi_pf_rx_push_rss_config,
 	.rx_pull_rss_config = efx_mcdi_rx_pull_rss_config,
 	.rx_push_rss_context_config = efx_mcdi_rx_push_rss_context_config,
@@ -4097,6 +4102,7 @@ const struct efx_nic_type efx_hunt_a0_nic_type = {
 	.rx_remove = efx_mcdi_rx_remove,
 	.rx_write = efx_ef10_rx_write,
 	.rx_defer_refill = efx_ef10_rx_defer_refill,
+	.rx_packet = __efx_rx_packet,
 	.ev_probe = efx_mcdi_ev_probe,
 	.ev_init = efx_ef10_ev_init,
 	.ev_fini = efx_mcdi_ev_fini,
@@ -4172,4 +4178,5 @@ const struct efx_nic_type efx_hunt_a0_nic_type = {
 	.rx_hash_key_size = 40,
 	.check_caps = ef10_check_caps,
 	.print_additional_fwver = efx_ef10_print_additional_fwver,
+	.sensor_event = efx_mcdi_sensor_event,
 };
diff --git a/drivers/net/ethernet/sfc/ef100.c b/drivers/net/ethernet/sfc/ef100.c
new file mode 100644
index 000000000000..de611c0f94e7
--- /dev/null
+++ b/drivers/net/ethernet/sfc/ef100.c
@@ -0,0 +1,541 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/****************************************************************************
+ * Driver for Solarflare network controllers and boards
+ * Copyright 2005-2018 Solarflare Communications Inc.
+ * Copyright 2019-2020 Xilinx Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation, incorporated herein by reference.
+ */
+
+#include "net_driver.h"
+#include <linux/module.h>
+#include <linux/aer.h>
+#include "efx_common.h"
+#include "efx_channels.h"
+#include "io.h"
+#include "ef100_nic.h"
+#include "ef100_netdev.h"
+#include "ef100_regs.h"
+#include "ef100.h"
+
+#define EFX_EF100_PCI_DEFAULT_BAR	2
+
+/* Number of bytes at start of vendor specified extended capability that indicate
+ * that the capability is vendor specified. i.e. offset from value returned by
+ * pci_find_next_ext_capability() to beginning of vendor specified capability
+ * header.
+ */
+#define PCI_EXT_CAP_HDR_LENGTH  4
+
+/* Expected size of a Xilinx continuation address table entry. */
+#define ESE_GZ_CFGBAR_CONT_CAP_MIN_LENGTH      16
+
+struct ef100_func_ctl_window {
+	bool valid;
+	unsigned int bar;
+	u64 offset;
+};
+
+static int ef100_pci_walk_xilinx_table(struct efx_nic *efx, u64 offset,
+				       struct ef100_func_ctl_window *result);
+
+/* Number of bytes to offset when reading bit position x with dword accessors. */
+#define ROUND_DOWN_TO_DWORD(x) (((x) & (~31)) >> 3)
+
+#define EXTRACT_BITS(x, lbn, width) \
+	(((x) >> ((lbn) & 31)) & ((1ull << (width)) - 1))
+
+static u32 _ef100_pci_get_bar_bits_with_width(struct efx_nic *efx,
+					      int structure_start,
+					      int lbn, int width)
+{
+	efx_dword_t dword;
+
+	efx_readd(efx, &dword, structure_start + ROUND_DOWN_TO_DWORD(lbn));
+
+	return EXTRACT_BITS(le32_to_cpu(dword.u32[0]), lbn, width);
+}
+
+#define ef100_pci_get_bar_bits(efx, entry_location, bitdef)	\
+	_ef100_pci_get_bar_bits_with_width(efx, entry_location,	\
+		ESF_GZ_CFGBAR_ ## bitdef ## _LBN,		\
+		ESF_GZ_CFGBAR_ ## bitdef ## _WIDTH)
+
+static int ef100_pci_parse_ef100_entry(struct efx_nic *efx, int entry_location,
+				       struct ef100_func_ctl_window *result)
+{
+	u64 offset = ef100_pci_get_bar_bits(efx, entry_location, EF100_FUNC_CTL_WIN_OFF) <<
+					ESE_GZ_EF100_FUNC_CTL_WIN_OFF_SHIFT;
+	u32 bar = ef100_pci_get_bar_bits(efx, entry_location, EF100_BAR);
+
+	netif_dbg(efx, probe, efx->net_dev,
+		  "Found EF100 function control window bar=%d offset=0x%llx\n",
+		  bar, offset);
+
+	if (result->valid) {
+		netif_err(efx, probe, efx->net_dev,
+			  "Duplicated EF100 table entry.\n");
+		return -EINVAL;
+	}
+
+	if (bar == ESE_GZ_CFGBAR_EF100_BAR_NUM_EXPANSION_ROM ||
+	    bar == ESE_GZ_CFGBAR_EF100_BAR_NUM_INVALID) {
+		netif_err(efx, probe, efx->net_dev,
+			  "Bad BAR value of %d in Xilinx capabilities EF100 entry.\n",
+			  bar);
+		return -EINVAL;
+	}
+
+	result->bar = bar;
+	result->offset = offset;
+	result->valid = true;
+	return 0;
+}
+
+static bool ef100_pci_does_bar_overflow(struct efx_nic *efx, int bar,
+					u64 next_entry)
+{
+	return next_entry + ESE_GZ_CFGBAR_ENTRY_HEADER_SIZE >
+					pci_resource_len(efx->pci_dev, bar);
+}
+
+/* Parse a Xilinx capabilities table entry describing a continuation to a new
+ * sub-table.
+ */
+static int ef100_pci_parse_continue_entry(struct efx_nic *efx, int entry_location,
+					  struct ef100_func_ctl_window *result)
+{
+	unsigned int previous_bar;
+	efx_oword_t entry;
+	u64 offset;
+	int rc = 0;
+	u32 bar;
+
+	efx_reado(efx, &entry, entry_location);
+
+	bar = EFX_OWORD_FIELD32(entry, ESF_GZ_CFGBAR_CONT_CAP_BAR);
+
+	offset = EFX_OWORD_FIELD64(entry, ESF_GZ_CFGBAR_CONT_CAP_OFFSET) <<
+		ESE_GZ_CONT_CAP_OFFSET_BYTES_SHIFT;
+
+	previous_bar = efx->mem_bar;
+
+	if (bar == ESE_GZ_VSEC_BAR_NUM_EXPANSION_ROM ||
+	    bar == ESE_GZ_VSEC_BAR_NUM_INVALID) {
+		netif_err(efx, probe, efx->net_dev,
+			  "Bad BAR value of %d in Xilinx capabilities sub-table.\n",
+			  bar);
+		return -EINVAL;
+	}
+
+	if (bar != previous_bar) {
+		efx_fini_io(efx);
+
+		if (ef100_pci_does_bar_overflow(efx, bar, offset)) {
+			netif_err(efx, probe, efx->net_dev,
+				  "Xilinx table will overrun BAR[%d] offset=0x%llx\n",
+				  bar, offset);
+			return -EINVAL;
+		}
+
+		/* Temporarily map new BAR. */
+		rc = efx_init_io(efx, bar,
+				 DMA_BIT_MASK(ESF_GZ_TX_SEND_ADDR_WIDTH),
+				 pci_resource_len(efx->pci_dev, bar));
+		if (rc) {
+			netif_err(efx, probe, efx->net_dev,
+				  "Mapping new BAR for Xilinx table failed, rc=%d\n", rc);
+			return rc;
+		}
+	}
+
+	rc = ef100_pci_walk_xilinx_table(efx, offset, result);
+	if (rc)
+		return rc;
+
+	if (bar != previous_bar) {
+		efx_fini_io(efx);
+
+		/* Put old BAR back. */
+		rc = efx_init_io(efx, previous_bar,
+				 DMA_BIT_MASK(ESF_GZ_TX_SEND_ADDR_WIDTH),
+				 pci_resource_len(efx->pci_dev, previous_bar));
+		if (rc) {
+			netif_err(efx, probe, efx->net_dev,
+				  "Putting old BAR back failed, rc=%d\n", rc);
+			return rc;
+		}
+	}
+
+	return 0;
+}
+
+/* Iterate over the Xilinx capabilities table in the currently mapped BAR and
+ * call ef100_pci_parse_ef100_entry() on any EF100 entries and
+ * ef100_pci_parse_continue_entry() on any table continuations.
+ */
+static int ef100_pci_walk_xilinx_table(struct efx_nic *efx, u64 offset,
+				       struct ef100_func_ctl_window *result)
+{
+	u64 current_entry = offset;
+	int rc = 0;
+
+	while (true) {
+		u32 id = ef100_pci_get_bar_bits(efx, current_entry, ENTRY_FORMAT);
+		u32 last = ef100_pci_get_bar_bits(efx, current_entry, ENTRY_LAST);
+		u32 rev = ef100_pci_get_bar_bits(efx, current_entry, ENTRY_REV);
+		u32 entry_size;
+
+		if (id == ESE_GZ_CFGBAR_ENTRY_LAST)
+			return 0;
+
+		entry_size = ef100_pci_get_bar_bits(efx, current_entry, ENTRY_SIZE);
+
+		netif_dbg(efx, probe, efx->net_dev,
+			  "Seen Xilinx table entry 0x%x size 0x%x at 0x%llx in BAR[%d]\n",
+			  id, entry_size, current_entry, efx->mem_bar);
+
+		if (entry_size < sizeof(u32) * 2) {
+			netif_err(efx, probe, efx->net_dev,
+				  "Xilinx table entry too short len=0x%x\n", entry_size);
+			return -EINVAL;
+		}
+
+		switch (id) {
+		case ESE_GZ_CFGBAR_ENTRY_EF100:
+			if (rev != ESE_GZ_CFGBAR_ENTRY_REV_EF100 ||
+			    entry_size < ESE_GZ_CFGBAR_ENTRY_SIZE_EF100) {
+				netif_err(efx, probe, efx->net_dev,
+					  "Bad length or rev for EF100 entry in Xilinx capabilities table. entry_size=%d rev=%d.\n",
+					  entry_size, rev);
+				return -EINVAL;
+			}
+
+			rc = ef100_pci_parse_ef100_entry(efx, current_entry,
+							 result);
+			if (rc)
+				return rc;
+			break;
+		case ESE_GZ_CFGBAR_ENTRY_CONT_CAP_ADDR:
+			if (rev != 0 || entry_size < ESE_GZ_CFGBAR_CONT_CAP_MIN_LENGTH) {
+				netif_err(efx, probe, efx->net_dev,
+					  "Bad length or rev for continue entry in Xilinx capabilities table. entry_size=%d rev=%d.\n",
+					  entry_size, rev);
+				return -EINVAL;
+			}
+
+			rc = ef100_pci_parse_continue_entry(efx, current_entry, result);
+			if (rc)
+				return rc;
+			break;
+		default:
+			/* Ignore unknown table entries. */
+			break;
+		}
+
+		if (last)
+			return 0;
+
+		current_entry += entry_size;
+
+		if (ef100_pci_does_bar_overflow(efx, efx->mem_bar, current_entry)) {
+			netif_err(efx, probe, efx->net_dev,
+				  "Xilinx table overrun at position=0x%llx.\n",
+				  current_entry);
+			return -EINVAL;
+		}
+	}
+}
+
+static int _ef100_pci_get_config_bits_with_width(struct efx_nic *efx,
+						 int structure_start, int lbn,
+						 int width, u32 *result)
+{
+	int rc, pos = structure_start + ROUND_DOWN_TO_DWORD(lbn);
+	u32 temp;
+
+	rc = pci_read_config_dword(efx->pci_dev, pos, &temp);
+	if (rc) {
+		netif_err(efx, probe, efx->net_dev,
+			  "Failed to read PCI config dword at %d\n",
+			  pos);
+		return rc;
+	}
+
+	*result = EXTRACT_BITS(temp, lbn, width);
+
+	return 0;
+}
+
+#define ef100_pci_get_config_bits(efx, entry_location, bitdef, result)	\
+	_ef100_pci_get_config_bits_with_width(efx, entry_location,	\
+		 ESF_GZ_VSEC_ ## bitdef ## _LBN,			\
+		 ESF_GZ_VSEC_ ## bitdef ## _WIDTH, result)
+
+/* Call ef100_pci_walk_xilinx_table() for the Xilinx capabilities table pointed
+ * to by this PCI_EXT_CAP_ID_VNDR.
+ */
+static int ef100_pci_parse_xilinx_cap(struct efx_nic *efx, int vndr_cap,
+				      bool has_offset_hi,
+				      struct ef100_func_ctl_window *result)
+{
+	u32 offset_high = 0;
+	u32 offset_lo = 0;
+	u64 offset = 0;
+	u32 bar = 0;
+	int rc = 0;
+
+	rc = ef100_pci_get_config_bits(efx, vndr_cap, TBL_BAR, &bar);
+	if (rc) {
+		netif_err(efx, probe, efx->net_dev,
+			  "Failed to read ESF_GZ_VSEC_TBL_BAR, rc=%d\n",
+			  rc);
+		return rc;
+	}
+
+	if (bar == ESE_GZ_CFGBAR_CONT_CAP_BAR_NUM_EXPANSION_ROM ||
+	    bar == ESE_GZ_CFGBAR_CONT_CAP_BAR_NUM_INVALID) {
+		netif_err(efx, probe, efx->net_dev,
+			  "Bad BAR value of %d in Xilinx capabilities sub-table.\n",
+			  bar);
+		return -EINVAL;
+	}
+
+	rc = ef100_pci_get_config_bits(efx, vndr_cap, TBL_OFF_LO, &offset_lo);
+	if (rc) {
+		netif_err(efx, probe, efx->net_dev,
+			  "Failed to read ESF_GZ_VSEC_TBL_OFF_LO, rc=%d\n",
+			  rc);
+		return rc;
+	}
+
+	/* Get optional extension to 64bit offset. */
+	if (has_offset_hi) {
+		rc = ef100_pci_get_config_bits(efx, vndr_cap, TBL_OFF_HI, &offset_high);
+		if (rc) {
+			netif_err(efx, probe, efx->net_dev,
+				  "Failed to read ESF_GZ_VSEC_TBL_OFF_HI, rc=%d\n",
+				  rc);
+			return rc;
+		}
+	}
+
+	offset = (((u64)offset_lo) << ESE_GZ_VSEC_TBL_OFF_LO_BYTES_SHIFT) |
+		 (((u64)offset_high) << ESE_GZ_VSEC_TBL_OFF_HI_BYTES_SHIFT);
+
+	if (offset > pci_resource_len(efx->pci_dev, bar) - sizeof(u32) * 2) {
+		netif_err(efx, probe, efx->net_dev,
+			  "Xilinx table will overrun BAR[%d] offset=0x%llx\n",
+			  bar, offset);
+		return -EINVAL;
+	}
+
+	/* Temporarily map BAR. */
+	rc = efx_init_io(efx, bar,
+			 DMA_BIT_MASK(ESF_GZ_TX_SEND_ADDR_WIDTH),
+			 pci_resource_len(efx->pci_dev, bar));
+	if (rc) {
+		netif_err(efx, probe, efx->net_dev,
+			  "efx_init_io failed, rc=%d\n", rc);
+		return rc;
+	}
+
+	rc = ef100_pci_walk_xilinx_table(efx, offset, result);
+
+	/* Unmap temporarily mapped BAR. */
+	efx_fini_io(efx);
+	return rc;
+}
+
+/* Call ef100_pci_parse_ef100_entry() for each Xilinx PCI_EXT_CAP_ID_VNDR
+ * capability.
+ */
+static int ef100_pci_find_func_ctrl_window(struct efx_nic *efx,
+					   struct ef100_func_ctl_window *result)
+{
+	int num_xilinx_caps = 0;
+	int cap = 0;
+
+	result->valid = false;
+
+	while ((cap = pci_find_next_ext_capability(efx->pci_dev, cap, PCI_EXT_CAP_ID_VNDR)) != 0) {
+		int vndr_cap = cap + PCI_EXT_CAP_HDR_LENGTH;
+		u32 vsec_ver = 0;
+		u32 vsec_len = 0;
+		u32 vsec_id = 0;
+		int rc = 0;
+
+		num_xilinx_caps++;
+
+		rc = ef100_pci_get_config_bits(efx, vndr_cap, ID, &vsec_id);
+		if (rc) {
+			netif_err(efx, probe, efx->net_dev,
+				  "Failed to read ESF_GZ_VSEC_ID, rc=%d\n",
+				  rc);
+			return rc;
+		}
+
+		rc = ef100_pci_get_config_bits(efx, vndr_cap, VER, &vsec_ver);
+		if (rc) {
+			netif_err(efx, probe, efx->net_dev,
+				  "Failed to read ESF_GZ_VSEC_VER, rc=%d\n",
+				  rc);
+			return rc;
+		}
+
+		/* Get length of whole capability - i.e. starting at cap */
+		rc = ef100_pci_get_config_bits(efx, vndr_cap, LEN, &vsec_len);
+		if (rc) {
+			netif_err(efx, probe, efx->net_dev,
+				  "Failed to read ESF_GZ_VSEC_LEN, rc=%d\n",
+				  rc);
+			return rc;
+		}
+
+		if (vsec_id == ESE_GZ_XILINX_VSEC_ID &&
+		    vsec_ver == ESE_GZ_VSEC_VER_XIL_CFGBAR &&
+		    vsec_len >= ESE_GZ_VSEC_LEN_MIN) {
+			bool has_offset_hi = (vsec_len >= ESE_GZ_VSEC_LEN_HIGH_OFFT);
+
+			rc = ef100_pci_parse_xilinx_cap(efx, vndr_cap,
+							has_offset_hi, result);
+			if (rc)
+				return rc;
+		}
+	}
+
+	if (num_xilinx_caps && !result->valid) {
+		netif_err(efx, probe, efx->net_dev,
+			  "Seen %d Xilinx tables, but no EF100 entry.\n",
+			  num_xilinx_caps);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/* Final NIC shutdown
+ * This is called only at module unload (or hotplug removal).  A PF can call
+ * this on its VFs to ensure they are unbound first.
+ */
+static void ef100_pci_remove(struct pci_dev *pci_dev)
+{
+	struct efx_nic *efx;
+
+	efx = pci_get_drvdata(pci_dev);
+	if (!efx)
+		return;
+
+	rtnl_lock();
+	dev_close(efx->net_dev);
+	rtnl_unlock();
+
+	/* Unregistering our netdev notifier triggers unbinding of TC indirect
+	 * blocks, so we have to do it before PCI removal.
+	 */
+	unregister_netdevice_notifier(&efx->netdev_notifier);
+	ef100_remove(efx);
+	efx_fini_io(efx);
+	netif_dbg(efx, drv, efx->net_dev, "shutdown successful\n");
+
+	pci_set_drvdata(pci_dev, NULL);
+	efx_fini_struct(efx);
+	free_netdev(efx->net_dev);
+
+	pci_disable_pcie_error_reporting(pci_dev);
+};
+
+static int ef100_pci_probe(struct pci_dev *pci_dev,
+			   const struct pci_device_id *entry)
+{
+	struct ef100_func_ctl_window fcw = { 0 };
+	struct net_device *net_dev;
+	struct efx_nic *efx;
+	int rc;
+
+	/* Allocate and initialise a struct net_device and struct efx_nic */
+	net_dev = alloc_etherdev_mq(sizeof(*efx), EFX_MAX_CORE_TX_QUEUES);
+	if (!net_dev)
+		return -ENOMEM;
+	efx = netdev_priv(net_dev);
+	efx->type = (const struct efx_nic_type *)entry->driver_data;
+
+	pci_set_drvdata(pci_dev, efx);
+	SET_NETDEV_DEV(net_dev, &pci_dev->dev);
+	rc = efx_init_struct(efx, pci_dev, net_dev);
+	if (rc)
+		goto fail;
+
+	efx->vi_stride = EF100_DEFAULT_VI_STRIDE;
+	netif_info(efx, probe, efx->net_dev,
+		   "Solarflare EF100 NIC detected\n");
+
+	rc = ef100_pci_find_func_ctrl_window(efx, &fcw);
+	if (rc) {
+		netif_err(efx, probe, efx->net_dev,
+			  "Error looking for ef100 function control window, rc=%d\n",
+			  rc);
+		goto fail;
+	}
+
+	if (!fcw.valid) {
+		/* Extended capability not found - use defaults. */
+		fcw.bar = EFX_EF100_PCI_DEFAULT_BAR;
+		fcw.offset = 0;
+		fcw.valid = true;
+	}
+
+	if (fcw.offset > pci_resource_len(efx->pci_dev, fcw.bar) - ESE_GZ_FCW_LEN) {
+		netif_err(efx, probe, efx->net_dev,
+			  "Func control window overruns BAR\n");
+		goto fail;
+	}
+
+	/* Set up basic I/O (BAR mappings etc) */
+	rc = efx_init_io(efx, fcw.bar,
+			 DMA_BIT_MASK(ESF_GZ_TX_SEND_ADDR_WIDTH),
+			 pci_resource_len(efx->pci_dev, fcw.bar));
+	if (rc)
+		goto fail;
+
+	efx->reg_base = fcw.offset;
+
+	efx->netdev_notifier.notifier_call = ef100_netdev_event;
+	rc = register_netdevice_notifier(&efx->netdev_notifier);
+	if (rc) {
+		netif_err(efx, probe, efx->net_dev,
+			  "Failed to register netdevice notifier, rc=%d\n", rc);
+		goto fail;
+	}
+
+	rc = efx->type->probe(efx);
+	if (rc)
+		goto fail;
+
+	netif_dbg(efx, probe, efx->net_dev, "initialisation successful\n");
+
+	return 0;
+
+fail:
+	ef100_pci_remove(pci_dev);
+	return rc;
+}
+
+/* PCI device ID table */
+static const struct pci_device_id ef100_pci_table[] = {
+	{PCI_DEVICE(PCI_VENDOR_ID_XILINX, 0x0100),  /* Riverhead PF */
+		.driver_data = (unsigned long) &ef100_pf_nic_type },
+	{0}                     /* end of list */
+};
+
+struct pci_driver ef100_pci_driver = {
+	.name           = "sfc_ef100",
+	.id_table       = ef100_pci_table,
+	.probe          = ef100_pci_probe,
+	.remove         = ef100_pci_remove,
+	.err_handler    = &efx_err_handlers,
+};
+
+MODULE_DEVICE_TABLE(pci, ef100_pci_table);
diff --git a/drivers/net/ethernet/sfc/ef100.h b/drivers/net/ethernet/sfc/ef100.h
new file mode 100644
index 000000000000..a63f0ff6641b
--- /dev/null
+++ b/drivers/net/ethernet/sfc/ef100.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/****************************************************************************
+ * Driver for Solarflare network controllers and boards
+ * Copyright 2018 Solarflare Communications Inc.
+ * Copyright 2019-2020 Xilinx Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation, incorporated herein by reference.
+ */
+
+extern struct pci_driver ef100_pci_driver;
diff --git a/drivers/net/ethernet/sfc/ef100_ethtool.c b/drivers/net/ethernet/sfc/ef100_ethtool.c
new file mode 100644
index 000000000000..729c425d0f78
--- /dev/null
+++ b/drivers/net/ethernet/sfc/ef100_ethtool.c
@@ -0,0 +1,24 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/****************************************************************************
+ * Driver for Solarflare network controllers and boards
+ * Copyright 2018 Solarflare Communications Inc.
+ * Copyright 2019-2020 Xilinx Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation, incorporated herein by reference.
+ */
+#include <linux/module.h>
+#include <linux/netdevice.h>
+#include "net_driver.h"
+#include "efx.h"
+#include "mcdi_port_common.h"
+#include "ethtool_common.h"
+#include "ef100_ethtool.h"
+#include "mcdi_functions.h"
+
+/*	Ethtool options available
+ */
+const struct ethtool_ops ef100_ethtool_ops = {
+	.get_drvinfo		= efx_ethtool_get_drvinfo,
+};
diff --git a/drivers/net/ethernet/sfc/ef100_ethtool.h b/drivers/net/ethernet/sfc/ef100_ethtool.h
new file mode 100644
index 000000000000..6efda72dfc6c
--- /dev/null
+++ b/drivers/net/ethernet/sfc/ef100_ethtool.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/****************************************************************************
+ * Driver for Solarflare network controllers and boards
+ * Copyright 2018 Solarflare Communications Inc.
+ * Copyright 2019-2020 Xilinx Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation, incorporated herein by reference.
+ */
+
+extern const struct ethtool_ops ef100_ethtool_ops;
diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
new file mode 100644
index 000000000000..f900b375d9b1
--- /dev/null
+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
@@ -0,0 +1,129 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/****************************************************************************
+ * Driver for Solarflare network controllers and boards
+ * Copyright 2018 Solarflare Communications Inc.
+ * Copyright 2019-2020 Xilinx Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation, incorporated herein by reference.
+ */
+#include "net_driver.h"
+#include "mcdi_port_common.h"
+#include "mcdi_functions.h"
+#include "efx_common.h"
+#include "efx_channels.h"
+#include "tx_common.h"
+#include "ef100_netdev.h"
+#include "ef100_ethtool.h"
+#include "efx_common.h"
+#include "nic_common.h"
+#include "ef100_nic.h"
+#include "ef100_tx.h"
+#include "ef100_regs.h"
+#include "mcdi_filters.h"
+#include "rx_common.h"
+
+static void ef100_update_name(struct efx_nic *efx)
+{
+	strcpy(efx->name, efx->net_dev->name);
+}
+
+/* Initiate a packet transmission.  We use one channel per CPU
+ * (sharing when we have more CPUs than channels).
+ *
+ * Context: non-blocking.
+ * Note that returning anything other than NETDEV_TX_OK will cause the
+ * OS to free the skb.
+ */
+static netdev_tx_t ef100_hard_start_xmit(struct sk_buff *skb,
+					 struct net_device *net_dev)
+{
+	struct efx_nic *efx = netdev_priv(net_dev);
+	struct efx_tx_queue *tx_queue;
+	struct efx_channel *channel;
+	int rc;
+
+	channel = efx_get_tx_channel(efx, skb_get_queue_mapping(skb));
+	netif_vdbg(efx, tx_queued, efx->net_dev,
+		   "%s len %d data %d channel %d\n", __func__,
+		   skb->len, skb->data_len, channel->channel);
+	if (!efx->n_channels || !efx->n_tx_channels || !channel) {
+		netif_stop_queue(net_dev);
+		goto err;
+	}
+
+	tx_queue = &channel->tx_queue[0];
+	rc = ef100_enqueue_skb(tx_queue, skb);
+	if (rc == 0)
+		return NETDEV_TX_OK;
+
+err:
+	net_dev->stats.tx_dropped++;
+	return NETDEV_TX_OK;
+}
+
+static const struct net_device_ops ef100_netdev_ops = {
+	.ndo_start_xmit         = ef100_hard_start_xmit,
+};
+
+/*	Netdev registration
+ */
+int ef100_netdev_event(struct notifier_block *this,
+		       unsigned long event, void *ptr)
+{
+	struct efx_nic *efx = container_of(this, struct efx_nic, netdev_notifier);
+	struct net_device *net_dev = netdev_notifier_info_to_dev(ptr);
+
+	if (netdev_priv(net_dev) == efx && event == NETDEV_CHANGENAME)
+		ef100_update_name(efx);
+
+	return NOTIFY_DONE;
+}
+
+int ef100_register_netdev(struct efx_nic *efx)
+{
+	struct net_device *net_dev = efx->net_dev;
+	int rc;
+
+	net_dev->watchdog_timeo = 5 * HZ;
+	net_dev->irq = efx->pci_dev->irq;
+	net_dev->netdev_ops = &ef100_netdev_ops;
+	net_dev->min_mtu = EFX_MIN_MTU;
+	net_dev->max_mtu = EFX_MAX_MTU;
+	net_dev->ethtool_ops = &ef100_ethtool_ops;
+
+	rtnl_lock();
+
+	rc = dev_alloc_name(net_dev, net_dev->name);
+	if (rc < 0)
+		goto fail_locked;
+	ef100_update_name(efx);
+
+	rc = register_netdevice(net_dev);
+	if (rc)
+		goto fail_locked;
+
+	/* Always start with carrier off; PHY events will detect the link */
+	netif_carrier_off(net_dev);
+
+	efx->state = STATE_READY;
+	rtnl_unlock();
+	efx_init_mcdi_logging(efx);
+
+	return 0;
+
+fail_locked:
+	rtnl_unlock();
+	netif_err(efx, drv, efx->net_dev, "could not register net dev\n");
+	return rc;
+}
+
+void ef100_unregister_netdev(struct efx_nic *efx)
+{
+	if (efx_dev_registered(efx)) {
+		efx_fini_mcdi_logging(efx);
+		efx->state = STATE_UNINIT;
+		unregister_netdev(efx->net_dev);
+	}
+}
diff --git a/drivers/net/ethernet/sfc/ef100_netdev.h b/drivers/net/ethernet/sfc/ef100_netdev.h
new file mode 100644
index 000000000000..d40abb7cc086
--- /dev/null
+++ b/drivers/net/ethernet/sfc/ef100_netdev.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/****************************************************************************
+ * Driver for Solarflare network controllers and boards
+ * Copyright 2018 Solarflare Communications Inc.
+ * Copyright 2019-2020 Xilinx Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation, incorporated herein by reference.
+ */
+
+#include <linux/netdevice.h>
+
+int ef100_netdev_event(struct notifier_block *this,
+		       unsigned long event, void *ptr);
+int ef100_register_netdev(struct efx_nic *efx);
+void ef100_unregister_netdev(struct efx_nic *efx);
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
new file mode 100644
index 000000000000..7bb304bc148e
--- /dev/null
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -0,0 +1,174 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/****************************************************************************
+ * Driver for Solarflare network controllers and boards
+ * Copyright 2018 Solarflare Communications Inc.
+ * Copyright 2019-2020 Xilinx Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation, incorporated herein by reference.
+ */
+
+#include "ef100_nic.h"
+#include "efx_common.h"
+#include "efx_channels.h"
+#include "io.h"
+#include "selftest.h"
+#include "ef100_regs.h"
+#include "mcdi.h"
+#include "mcdi_pcol.h"
+#include "mcdi_port_common.h"
+#include "mcdi_functions.h"
+#include "mcdi_filters.h"
+#include "ef100_rx.h"
+#include "ef100_tx.h"
+#include "ef100_netdev.h"
+
+#define EF100_MAX_VIS 4096
+
+/*	MCDI
+ */
+static int ef100_get_warm_boot_count(struct efx_nic *efx)
+{
+	efx_dword_t reg;
+
+	efx_readd(efx, &reg, efx_reg(efx, ER_GZ_MC_SFT_STATUS));
+
+	if (EFX_DWORD_FIELD(reg, EFX_DWORD_0) == 0xffffffff) {
+		netif_err(efx, hw, efx->net_dev, "Hardware unavailable\n");
+		efx->state = STATE_DISABLED;
+		return -ENETDOWN;
+	} else {
+		return EFX_DWORD_FIELD(reg, EFX_WORD_1) == 0xb007 ?
+			EFX_DWORD_FIELD(reg, EFX_WORD_0) : -EIO;
+	}
+}
+
+/*	Event handling
+ */
+static int ef100_ev_probe(struct efx_channel *channel)
+{
+	/* Allocate an extra descriptor for the QMDA status completion entry */
+	return efx_nic_alloc_buffer(channel->efx, &channel->eventq.buf,
+				    (channel->eventq_mask + 2) *
+				    sizeof(efx_qword_t),
+				    GFP_KERNEL);
+}
+
+static irqreturn_t ef100_msi_interrupt(int irq, void *dev_id)
+{
+	struct efx_msi_context *context = dev_id;
+	struct efx_nic *efx = context->efx;
+
+	netif_vdbg(efx, intr, efx->net_dev,
+		   "IRQ %d on CPU %d\n", irq, raw_smp_processor_id());
+
+	if (likely(READ_ONCE(efx->irq_soft_enabled))) {
+		/* Note test interrupts */
+		if (context->index == efx->irq_level)
+			efx->last_irq_cpu = raw_smp_processor_id();
+
+		/* Schedule processing of the channel */
+		efx_schedule_channel_irq(efx->channel[context->index]);
+	}
+
+	return IRQ_HANDLED;
+}
+
+/*	NIC level access functions
+ */
+const struct efx_nic_type ef100_pf_nic_type = {
+	.revision = EFX_REV_EF100,
+	.is_vf = false,
+	.probe = ef100_probe_pf,
+	.mcdi_max_ver = 2,
+	.irq_enable_master = efx_port_dummy_op_void,
+	.irq_disable_non_ev = efx_port_dummy_op_void,
+	.push_irq_moderation = efx_channel_dummy_op_void,
+	.min_interrupt_mode = EFX_INT_MODE_MSIX,
+
+	.ev_probe = ef100_ev_probe,
+	.irq_handle_msi = ef100_msi_interrupt,
+
+	/* Per-type bar/size configuration not used on ef100. Location of
+	 * registers is defined by extended capabilities.
+	 */
+	.mem_bar = NULL,
+	.mem_map_size = NULL,
+
+};
+
+/*	NIC probe and remove
+ */
+static int ef100_probe_main(struct efx_nic *efx)
+{
+	unsigned int bar_size = resource_size(&efx->pci_dev->resource[efx->mem_bar]);
+	struct net_device *net_dev = efx->net_dev;
+	struct ef100_nic_data *nic_data;
+	int i, rc;
+
+	if (WARN_ON(bar_size == 0))
+		return -EIO;
+
+	nic_data = kzalloc(sizeof(*nic_data), GFP_KERNEL);
+	if (!nic_data)
+		return -ENOMEM;
+	efx->nic_data = nic_data;
+	nic_data->efx = efx;
+	net_dev->features |= efx->type->offload_features;
+	net_dev->hw_features |= efx->type->offload_features;
+
+	/* Get the MC's warm boot count.  In case it's rebooting right
+	 * now, be prepared to retry.
+	 */
+	i = 0;
+	for (;;) {
+		rc = ef100_get_warm_boot_count(efx);
+		if (rc >= 0)
+			break;
+		if (++i == 5)
+			goto fail;
+		ssleep(1);
+	}
+	nic_data->warm_boot_count = rc;
+
+	/* In case we're recovering from a crash (kexec), we want to
+	 * cancel any outstanding request by the previous user of this
+	 * function.  We send a special message using the least
+	 * significant bits of the 'high' (doorbell) register.
+	 */
+	_efx_writed(efx, cpu_to_le32(1), efx_reg(efx, ER_GZ_MC_DB_HWRD));
+
+	/* Post-IO section. */
+
+	efx->max_vis = EF100_MAX_VIS;
+
+	rc = efx_init_channels(efx);
+	if (rc)
+		goto fail;
+
+	rc = ef100_register_netdev(efx);
+	if (rc)
+		goto fail;
+
+	return 0;
+fail:
+	return rc;
+}
+
+int ef100_probe_pf(struct efx_nic *efx)
+{
+	return ef100_probe_main(efx);
+}
+
+void ef100_remove(struct efx_nic *efx)
+{
+	struct ef100_nic_data *nic_data = efx->nic_data;
+
+	ef100_unregister_netdev(efx);
+	efx_fini_channels(efx);
+	kfree(efx->phy_data);
+	efx->phy_data = NULL;
+	kfree(nic_data);
+	efx->nic_data = NULL;
+}
diff --git a/drivers/net/ethernet/sfc/ef100_nic.h b/drivers/net/ethernet/sfc/ef100_nic.h
new file mode 100644
index 000000000000..643111aebba5
--- /dev/null
+++ b/drivers/net/ethernet/sfc/ef100_nic.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/****************************************************************************
+ * Driver for Solarflare network controllers and boards
+ * Copyright 2018 Solarflare Communications Inc.
+ * Copyright 2019-2020 Xilinx Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation, incorporated herein by reference.
+ */
+
+#include "net_driver.h"
+#include "nic_common.h"
+
+extern const struct efx_nic_type ef100_pf_nic_type;
+
+int ef100_probe_pf(struct efx_nic *efx);
+void ef100_remove(struct efx_nic *efx);
+
+struct ef100_nic_data {
+	struct efx_nic *efx;
+	u16 warm_boot_count;
+};
+
+#define efx_ef100_has_cap(caps, flag) \
+	(!!((caps) & BIT_ULL(MC_CMD_GET_CAPABILITIES_V4_OUT_ ## flag ## _LBN)))
diff --git a/drivers/net/ethernet/sfc/ef100_rx.c b/drivers/net/ethernet/sfc/ef100_rx.c
new file mode 100644
index 000000000000..d6b62f980463
--- /dev/null
+++ b/drivers/net/ethernet/sfc/ef100_rx.c
@@ -0,0 +1,25 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/****************************************************************************
+ * Driver for Solarflare network controllers and boards
+ * Copyright 2005-2019 Solarflare Communications Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation, incorporated herein by reference.
+ */
+
+#include "net_driver.h"
+#include "ef100_rx.h"
+#include "rx_common.h"
+#include "efx.h"
+
+void __ef100_rx_packet(struct efx_channel *channel)
+{
+	/* Stub.  No RX path yet.  Discard the buffer. */
+	struct efx_rx_buffer *rx_buf = efx_rx_buffer(&channel->rx_queue,
+						     channel->rx_pkt_index);
+	struct efx_rx_queue *rx_queue = efx_channel_get_rx_queue(channel);
+
+	efx_free_rx_buffers(rx_queue, rx_buf, 1);
+	channel->rx_pkt_n_frags = 0;
+}
diff --git a/drivers/net/ethernet/sfc/ef100_rx.h b/drivers/net/ethernet/sfc/ef100_rx.h
new file mode 100644
index 000000000000..a6083a98f362
--- /dev/null
+++ b/drivers/net/ethernet/sfc/ef100_rx.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/****************************************************************************
+ * Driver for Solarflare network controllers and boards
+ * Copyright 2019 Solarflare Communications Inc.
+ * Copyright 2019-2020 Xilinx Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation, incorporated herein by reference.
+ */
+
+#ifndef EFX_EF100_RX_H
+#define EFX_EF100_RX_H
+
+#include "net_driver.h"
+
+void __ef100_rx_packet(struct efx_channel *channel);
+
+#endif
diff --git a/drivers/net/ethernet/sfc/ef100_tx.c b/drivers/net/ethernet/sfc/ef100_tx.c
new file mode 100644
index 000000000000..b12295413c0d
--- /dev/null
+++ b/drivers/net/ethernet/sfc/ef100_tx.c
@@ -0,0 +1,32 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/****************************************************************************
+ * Driver for Solarflare network controllers and boards
+ * Copyright 2018 Solarflare Communications Inc.
+ * Copyright 2019-2020 Xilinx Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation, incorporated herein by reference.
+ */
+
+#include "net_driver.h"
+#include "tx_common.h"
+#include "nic_common.h"
+#include "ef100_tx.h"
+
+/* Add a socket buffer to a TX queue
+ *
+ * You must hold netif_tx_lock() to call this function.
+ *
+ * Returns 0 on success, error code otherwise. In case of an error this
+ * function will free the SKB.
+ */
+int ef100_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb)
+{
+	/* Stub.  No TX path yet. */
+	struct efx_nic *efx = tx_queue->efx;
+
+	netif_stop_queue(efx->net_dev);
+	dev_kfree_skb_any(skb);
+	return -ENODEV;
+}
diff --git a/drivers/net/ethernet/sfc/ef100_tx.h b/drivers/net/ethernet/sfc/ef100_tx.h
new file mode 100644
index 000000000000..a7895efca4ff
--- /dev/null
+++ b/drivers/net/ethernet/sfc/ef100_tx.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/****************************************************************************
+ * Driver for Solarflare network controllers and boards
+ * Copyright 2019 Solarflare Communications Inc.
+ * Copyright 2019-2020 Xilinx Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation, incorporated herein by reference.
+ */
+
+#ifndef EFX_EF100_TX_H
+#define EFX_EF100_TX_H
+
+#include "net_driver.h"
+
+netdev_tx_t ef100_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb);
+#endif
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index f16b4f236031..f5aa1bd02f19 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -25,6 +25,7 @@
 #include "efx.h"
 #include "efx_common.h"
 #include "efx_channels.h"
+#include "ef100.h"
 #include "rx_common.h"
 #include "tx_common.h"
 #include "nic.h"
@@ -1360,8 +1361,14 @@ static int __init efx_init_module(void)
 	if (rc < 0)
 		goto err_pci;
 
+	rc = pci_register_driver(&ef100_pci_driver);
+	if (rc < 0)
+		goto err_pci_ef100;
+
 	return 0;
 
+ err_pci_ef100:
+	pci_unregister_driver(&efx_pci_driver);
  err_pci:
 	efx_destroy_reset_workqueue();
  err_reset:
@@ -1378,6 +1385,7 @@ static void __exit efx_exit_module(void)
 {
 	printk(KERN_INFO "Solarflare NET driver unloading\n");
 
+	pci_unregister_driver(&ef100_pci_driver);
 	pci_unregister_driver(&efx_pci_driver);
 	efx_destroy_reset_workqueue();
 #ifdef CONFIG_SFC_SRIOV
diff --git a/drivers/net/ethernet/sfc/efx.h b/drivers/net/ethernet/sfc/efx.h
index e7e7d8d1a07b..a9808e86068d 100644
--- a/drivers/net/ethernet/sfc/efx.h
+++ b/drivers/net/ethernet/sfc/efx.h
@@ -8,7 +8,10 @@
 #ifndef EFX_EFX_H
 #define EFX_EFX_H
 
+#include <linux/indirect_call_wrapper.h>
 #include "net_driver.h"
+#include "ef100_rx.h"
+#include "ef100_tx.h"
 #include "filter.h"
 
 int efx_net_open(struct net_device *net_dev);
@@ -18,13 +21,18 @@ int efx_net_stop(struct net_device *net_dev);
 void efx_init_tx_queue_core_txq(struct efx_tx_queue *tx_queue);
 netdev_tx_t efx_hard_start_xmit(struct sk_buff *skb,
 				struct net_device *net_dev);
-netdev_tx_t efx_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb);
+netdev_tx_t __efx_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb);
+static inline netdev_tx_t efx_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb)
+{
+	return INDIRECT_CALL_2(tx_queue->efx->type->tx_enqueue,
+			       ef100_enqueue_skb, __efx_enqueue_skb,
+			       tx_queue, skb);
+}
 void efx_xmit_done(struct efx_tx_queue *tx_queue, unsigned int index);
 void efx_xmit_done_single(struct efx_tx_queue *tx_queue);
 int efx_setup_tc(struct net_device *net_dev, enum tc_setup_type type,
 		 void *type_data);
 extern unsigned int efx_piobuf_size;
-extern bool efx_separate_tx_channels;
 
 /* RX */
 void __efx_rx_packet(struct efx_channel *channel);
@@ -33,7 +41,9 @@ void efx_rx_packet(struct efx_rx_queue *rx_queue, unsigned int index,
 static inline void efx_rx_flush_packet(struct efx_channel *channel)
 {
 	if (channel->rx_pkt_n_frags)
-		__efx_rx_packet(channel);
+		INDIRECT_CALL_2(channel->efx->type->rx_packet,
+				__ef100_rx_packet, __efx_rx_packet,
+				channel);
 }
 
 /* Maximum number of TCP segments we support for soft-TSO */
diff --git a/drivers/net/ethernet/sfc/ethtool.c b/drivers/net/ethernet/sfc/ethtool.c
index 038c08d2d7aa..4ffda7782f68 100644
--- a/drivers/net/ethernet/sfc/ethtool.c
+++ b/drivers/net/ethernet/sfc/ethtool.c
@@ -221,8 +221,6 @@ static int efx_ethtool_get_ts_info(struct net_device *net_dev,
 	return 0;
 }
 
-const char *efx_driver_name = KBUILD_MODNAME;
-
 const struct ethtool_ops efx_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_USECS_IRQ |
diff --git a/drivers/net/ethernet/sfc/ethtool_common.c b/drivers/net/ethernet/sfc/ethtool_common.c
index fb06097b70d8..05ac87807929 100644
--- a/drivers/net/ethernet/sfc/ethtool_common.c
+++ b/drivers/net/ethernet/sfc/ethtool_common.c
@@ -104,7 +104,7 @@ void efx_ethtool_get_drvinfo(struct net_device *net_dev,
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 
-	strlcpy(info->driver, efx_driver_name, sizeof(info->driver));
+	strlcpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
 	strlcpy(info->version, EFX_DRIVER_VERSION, sizeof(info->version));
 	efx_mcdi_print_fwver(efx, info->fw_version,
 			     sizeof(info->fw_version));
diff --git a/drivers/net/ethernet/sfc/ethtool_common.h b/drivers/net/ethernet/sfc/ethtool_common.h
index 0c0ea9ac4d08..659491932101 100644
--- a/drivers/net/ethernet/sfc/ethtool_common.h
+++ b/drivers/net/ethernet/sfc/ethtool_common.h
@@ -11,8 +11,6 @@
 #ifndef EFX_ETHTOOL_COMMON_H
 #define EFX_ETHTOOL_COMMON_H
 
-extern const char *efx_driver_name;
-
 void efx_ethtool_get_drvinfo(struct net_device *net_dev,
 			     struct ethtool_drvinfo *info);
 u32 efx_ethtool_get_msglevel(struct net_device *net_dev);
diff --git a/drivers/net/ethernet/sfc/mcdi.c b/drivers/net/ethernet/sfc/mcdi.c
index 6c49740a178e..5467819aef6e 100644
--- a/drivers/net/ethernet/sfc/mcdi.c
+++ b/drivers/net/ethernet/sfc/mcdi.c
@@ -1337,7 +1337,7 @@ void efx_mcdi_process_event(struct efx_channel *channel,
 		efx_mcdi_process_link_change(efx, event);
 		break;
 	case MCDI_EVENT_CODE_SENSOREVT:
-		efx_mcdi_sensor_event(efx, event);
+		efx_sensor_event(efx, event);
 		break;
 	case MCDI_EVENT_CODE_SCHEDERR:
 		netif_dbg(efx, hw, efx->net_dev,
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index db35beabdcff..9791fac0b649 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -963,6 +963,7 @@ struct efx_async_filter_insertion {
  * @vpd_sn: Serial number read from VPD
  * @xdp_rxq_info_failed: Have any of the rx queues failed to initialise their
  *      xdp_rxq_info structures?
+ * @netdev_notifier: Netdevice notifier.
  * @mem_bar: The BAR that is mapped into membase.
  * @reg_base: Offset from the start of the bar to the function control window.
  * @monitor_work: Hardware monitor workitem
@@ -1142,6 +1143,8 @@ struct efx_nic {
 	char *vpd_sn;
 	bool xdp_rxq_info_failed;
 
+	struct notifier_block netdev_notifier;
+
 	unsigned int mem_bar;
 	u32 reg_base;
 
@@ -1246,6 +1249,7 @@ struct efx_udp_tunnel {
  * @tx_init: Initialise TX queue on the NIC
  * @tx_remove: Free resources for TX queue
  * @tx_write: Write TX descriptors and doorbell
+ * @tx_enqueue: Add an SKB to TX queue
  * @rx_push_rss_config: Write RSS hash key and indirection table to the NIC
  * @rx_pull_rss_config: Read RSS hash key and indirection table back from the NIC
  * @rx_push_rss_context_config: Write RSS hash key and indirection table for
@@ -1257,6 +1261,7 @@ struct efx_udp_tunnel {
  * @rx_remove: Free resources for RX queue
  * @rx_write: Write RX descriptors and doorbell
  * @rx_defer_refill: Generate a refill reminder event
+ * @rx_packet: Receive the queued RX buffer on a channel
  * @ev_probe: Allocate resources for event queue
  * @ev_init: Initialise event queue on the NIC
  * @ev_fini: Deinitialise event queue on the NIC
@@ -1301,6 +1306,7 @@ struct efx_udp_tunnel {
  * @udp_tnl_push_ports: Push the list of UDP tunnel ports to the NIC if required.
  * @udp_tnl_has_port: Check if a port has been added as UDP tunnel
  * @print_additional_fwver: Dump NIC-specific additional FW version info
+ * @sensor_event: Handle a sensor event from MCDI
  * @revision: Hardware architecture revision
  * @txd_ptr_tbl_base: TX descriptor ring base address
  * @rxd_ptr_tbl_base: RX descriptor ring base address
@@ -1381,6 +1387,7 @@ struct efx_nic_type {
 	void (*tx_init)(struct efx_tx_queue *tx_queue);
 	void (*tx_remove)(struct efx_tx_queue *tx_queue);
 	void (*tx_write)(struct efx_tx_queue *tx_queue);
+	netdev_tx_t (*tx_enqueue)(struct efx_tx_queue *tx_queue, struct sk_buff *skb);
 	unsigned int (*tx_limit_len)(struct efx_tx_queue *tx_queue,
 				     dma_addr_t dma_addr, unsigned int len);
 	int (*rx_push_rss_config)(struct efx_nic *efx, bool user,
@@ -1398,6 +1405,7 @@ struct efx_nic_type {
 	void (*rx_remove)(struct efx_rx_queue *rx_queue);
 	void (*rx_write)(struct efx_rx_queue *rx_queue);
 	void (*rx_defer_refill)(struct efx_rx_queue *rx_queue);
+	void (*rx_packet)(struct efx_channel *channel);
 	int (*ev_probe)(struct efx_channel *channel);
 	int (*ev_init)(struct efx_channel *channel);
 	void (*ev_fini)(struct efx_channel *channel);
@@ -1472,6 +1480,7 @@ struct efx_nic_type {
 	bool (*udp_tnl_has_port)(struct efx_nic *efx, __be16 port);
 	size_t (*print_additional_fwver)(struct efx_nic *efx, char *buf,
 					 size_t len);
+	void (*sensor_event)(struct efx_nic *efx, efx_qword_t *ev);
 
 	int revision;
 	unsigned int txd_ptr_tbl_base;
@@ -1523,6 +1532,13 @@ efx_get_channel(struct efx_nic *efx, unsigned index)
 	     _channel = _channel->channel ?				\
 		     (_efx)->channel[_channel->channel - 1] : NULL)
 
+static inline struct efx_channel *
+efx_get_tx_channel(struct efx_nic *efx, unsigned int index)
+{
+	EFX_WARN_ON_ONCE_PARANOID(index >= efx->n_tx_channels);
+	return efx->channel[efx->tx_channel_offset + index];
+}
+
 static inline struct efx_tx_queue *
 efx_get_tx_queue(struct efx_nic *efx, unsigned index, unsigned type)
 {
diff --git a/drivers/net/ethernet/sfc/nic_common.h b/drivers/net/ethernet/sfc/nic_common.h
index e04b6817cde3..974107354087 100644
--- a/drivers/net/ethernet/sfc/nic_common.h
+++ b/drivers/net/ethernet/sfc/nic_common.h
@@ -225,6 +225,12 @@ void efx_nic_event_test_start(struct efx_channel *channel);
 
 bool efx_nic_event_present(struct efx_channel *channel);
 
+static inline void efx_sensor_event(struct efx_nic *efx, efx_qword_t *ev)
+{
+	if (efx->type->sensor_event)
+		efx->type->sensor_event(efx, ev);
+}
+
 /* Some statistics are computed as A - B where A and B each increase
  * linearly with some hardware counter(s) and the counters are read
  * asynchronously.  If the counters contributing to B are always read
diff --git a/drivers/net/ethernet/sfc/siena.c b/drivers/net/ethernet/sfc/siena.c
index 219fb3a0c9d0..a7ea630bb5e6 100644
--- a/drivers/net/ethernet/sfc/siena.c
+++ b/drivers/net/ethernet/sfc/siena.c
@@ -1018,6 +1018,7 @@ const struct efx_nic_type siena_a0_nic_type = {
 	.tx_remove = efx_farch_tx_remove,
 	.tx_write = efx_farch_tx_write,
 	.tx_limit_len = efx_farch_tx_limit_len,
+	.tx_enqueue = __efx_enqueue_skb,
 	.rx_push_rss_config = siena_rx_push_rss_config,
 	.rx_pull_rss_config = siena_rx_pull_rss_config,
 	.rx_probe = efx_farch_rx_probe,
@@ -1025,6 +1026,7 @@ const struct efx_nic_type siena_a0_nic_type = {
 	.rx_remove = efx_farch_rx_remove,
 	.rx_write = efx_farch_rx_write,
 	.rx_defer_refill = efx_farch_rx_defer_refill,
+	.rx_packet = __efx_rx_packet,
 	.ev_probe = efx_farch_ev_probe,
 	.ev_init = efx_farch_ev_init,
 	.ev_fini = efx_farch_ev_fini,
@@ -1096,4 +1098,5 @@ const struct efx_nic_type siena_a0_nic_type = {
 			     1 << HWTSTAMP_FILTER_PTP_V2_L4_EVENT),
 	.rx_hash_key_size = 16,
 	.check_caps = siena_check_caps,
+	.sensor_event = efx_mcdi_sensor_event,
 };
diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
index 1bcf50ab95d9..727201d5eb24 100644
--- a/drivers/net/ethernet/sfc/tx.c
+++ b/drivers/net/ethernet/sfc/tx.c
@@ -284,7 +284,7 @@ static int efx_enqueue_skb_pio(struct efx_tx_queue *tx_queue,
  * Returns NETDEV_TX_OK.
  * You must hold netif_tx_lock() to call this function.
  */
-netdev_tx_t efx_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb)
+netdev_tx_t __efx_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb)
 {
 	unsigned int old_insert_count = tx_queue->insert_count;
 	bool xmit_more = netdev_xmit_more();
@@ -503,7 +503,7 @@ netdev_tx_t efx_hard_start_xmit(struct sk_buff *skb,
 	}
 	tx_queue = efx_get_tx_queue(efx, index, type);
 
-	return efx_enqueue_skb(tx_queue, skb);
+	return __efx_enqueue_skb(tx_queue, skb);
 }
 
 void efx_xmit_done_single(struct efx_tx_queue *tx_queue)
diff --git a/drivers/net/ethernet/sfc/tx_common.h b/drivers/net/ethernet/sfc/tx_common.h
index cbe995b024a6..bbab7f248250 100644
--- a/drivers/net/ethernet/sfc/tx_common.h
+++ b/drivers/net/ethernet/sfc/tx_common.h
@@ -40,4 +40,6 @@ int efx_tx_map_data(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
 
 unsigned int efx_tx_max_skb_descs(struct efx_nic *efx);
 int efx_tx_tso_fallback(struct efx_tx_queue *tx_queue, struct sk_buff *skb);
+
+extern bool efx_separate_tx_channels;
 #endif

