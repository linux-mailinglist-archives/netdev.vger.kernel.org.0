Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6989213C92
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 17:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbgGCPbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 11:31:45 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:38688 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726111AbgGCPbp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 11:31:45 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.143])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 2DACE20095;
        Fri,  3 Jul 2020 15:31:42 +0000 (UTC)
Received: from us4-mdac16-35.at1.mdlocal (unknown [10.110.49.219])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 2BC75800A4;
        Fri,  3 Jul 2020 15:31:42 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.7])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 8030840058;
        Fri,  3 Jul 2020 15:31:41 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 0714A4C007F;
        Fri,  3 Jul 2020 15:31:41 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 3 Jul 2020
 16:31:36 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 03/15] sfc_ef100: skeleton EF100 PF driver
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <14d4694e-2493-abd3-b76e-09e38a01b588@solarflare.com>
Message-ID: <b9ccfacc-93c8-5f60-d3a5-ecd87fcef5ee@solarflare.com>
Date:   Fri, 3 Jul 2020 16:31:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <14d4694e-2493-abd3-b76e-09e38a01b588@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25518.003
X-TM-AS-Result: No-3.016300-8.000000-10
X-TMASE-MatchedRID: fU+NCbyBNBmyPSIT2k6m5EM/y5EMs/JmOTjDMsgp/8FWPcnrekBHfAra
        NtW4DkZY8XVI39JCRnSjfNAVYAJRAr+Q0YdVmuyWnFVnNmvv47uWODD/yzpvd1eIuu+Gkot8QBz
        oPKhLasjvAkvb7xTgsaUad1H6QNGj7igYWrzLr2O0pHkVd9vKzOPq4lm1oOj7HsnD6z4Q9PaVf7
        sm+EMO3Mg4geIu0I05kFZWCbRovEc+DMYP1Y4Xz7cPsR57JkIzChdI4sLlrjgPNrgrymv1t2eaW
        IM6JItDe0WOOv1MYsLdaeKRV3BJJwvpfXyH90tsIiU9hx6W6eZ0XCktmVbm9WOMyb1Ixq8VkrFb
        akGQlLPBBOpssnjSO1LWnBY2ZvwZsaLhFLnhBw6OFUiIwDKKzjB4tWHctlhIw1abgzWsDaa5ALz
        2VLh8nnYFVyLnLHGJLgw4kDXduPQH9MoYRDEfRQYzQiRf4l2xBnIRIVcCWN+XbcZfsC7t1COHhm
        ju++eFIji4jBXIrI0Sl20O4EJ/iCfe0T49Dwdo6GyDR2ZB+cYbGEo1PnheDou6fTXJM2TrmIRCr
        kxH6sA6FWRn9LUq8113lCMXIHsKy0Znp/xGmixFo9d++f6R6qPzCZSNeIaGs4be7XhW2Z6XBZ/v
        /hLIO0Bcp7vyblpb1+GfiEZub8hT/DdMZmG+2szSKGx9g8xhVXgJmiJ/ZEFrRM6wvXgDael39wE
        r1OabYS+IVS9oX2sjIesX8Y/kCRua258QXg/RYJF0zuzVwRSpvQ5ST6UgvRQGqRKhE3zga2ByQZ
        cfaSdA/W3naHSwCokA/x5eQ8zSc5HSCKyTA+2eAiCmPx4NwLTrdaH1ZWqC1kTfEkyaZdz6C0ePs
        7A07ThLrOxRSb5w1zPWKne0f4o7xDwc1KcPuPR69v9BDRQ3aWnI0XzQWOeQRHK5EcWCeFIypztS
        lSisEpGw8LptO86qtDFfJ0jAb5C8bGExn/XN
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.016300-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25518.003
X-MDID: 1593790302-NQk4dRubwLgS
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No TX or RX path, no MCDI, not even an ifup/down handler.
Besides stubs, the bulk of the patch deals with reading the Xilinx
 extended PCIe capability, which tells us where to find our BAR.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/Kconfig         |  10 +
 drivers/net/ethernet/sfc/Makefile        |   8 +
 drivers/net/ethernet/sfc/ef100.c         | 583 +++++++++++++++++++++++
 drivers/net/ethernet/sfc/ef100_ethtool.c |  26 +
 drivers/net/ethernet/sfc/ef100_ethtool.h |  12 +
 drivers/net/ethernet/sfc/ef100_netdev.c  | 135 ++++++
 drivers/net/ethernet/sfc/ef100_netdev.h  |  17 +
 drivers/net/ethernet/sfc/ef100_nic.c     | 177 +++++++
 drivers/net/ethernet/sfc/ef100_nic.h     |  26 +
 drivers/net/ethernet/sfc/ef100_rx.c      |  24 +
 drivers/net/ethernet/sfc/ef100_rx.h      |  17 +
 drivers/net/ethernet/sfc/ef100_tx.c      |  43 ++
 drivers/net/ethernet/sfc/ef100_tx.h      |  18 +
 drivers/net/ethernet/sfc/net_driver.h    |  12 +-
 14 files changed, 1107 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/sfc/ef100.c
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
index 81b0f7d3a025..2d37d1bc008c 100644
--- a/drivers/net/ethernet/sfc/Kconfig
+++ b/drivers/net/ethernet/sfc/Kconfig
@@ -28,6 +28,16 @@ config SFC
 
 	  To compile this driver as a module, choose M here.  The module
 	  will be called sfc.
+config SFC_EF100
+	tristate "Solarflare EF100 (Riverhead) support"
+	depends on PCI
+	default m
+	help
+          This driver supports 10/25/40/100-gigabit Ethernet cards based
+          on the Solarflare EF100 networking IP in Xilinx FPGAs.
+
+          To compile this driver as a module, choose M here. The module
+          will be called sfc_ef100.
 config SFC_MTD
 	bool "Solarflare SFC9000/SFC9100-family MTD support"
 	depends on SFC && MTD && !(SFC=y && MTD=m)
diff --git a/drivers/net/ethernet/sfc/Makefile b/drivers/net/ethernet/sfc/Makefile
index 87d093da22ca..90992a1c404d 100644
--- a/drivers/net/ethernet/sfc/Makefile
+++ b/drivers/net/ethernet/sfc/Makefile
@@ -10,4 +10,12 @@ sfc-$(CONFIG_SFC_SRIOV)	+= sriov.o siena_sriov.o ef10_sriov.o
 
 obj-$(CONFIG_SFC)	+= sfc.o
 
+sfc_ef100-y             += mcdi.o ef100.o efx_common.o efx_channels.o \
+                           ef100_nic.o nic.o ef100_netdev.o ef100_ethtool.o \
+                           ef100_rx.o rx_common.o ef100_tx.o tx_common.o \
+			   ethtool_common.o mcdi_port_common.o mcdi_functions.o \
+			   mcdi_filters.o selftest.o ptp.o
+
+obj-$(CONFIG_SFC_EF100) += sfc_ef100.o
+
 obj-$(CONFIG_SFC_FALCON) += falcon/
diff --git a/drivers/net/ethernet/sfc/ef100.c b/drivers/net/ethernet/sfc/ef100.c
new file mode 100644
index 000000000000..a2a816f691ee
--- /dev/null
+++ b/drivers/net/ethernet/sfc/ef100.c
@@ -0,0 +1,583 @@
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
+	((x) >> ((lbn) & 31)) & ((1ull << (width)) - 1)
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
+#define ef100_pci_get_bar_bits(efx, entry_location, bitdef) \
+	_ef100_pci_get_bar_bits_with_width(efx, entry_location, \
+		bitdef ## _LBN, bitdef ## _WIDTH)
+
+static int ef100_pci_parse_ef100_entry(struct efx_nic *efx, int entry_location,
+				       struct ef100_func_ctl_window *result)
+{
+	u32 bar = ef100_pci_get_bar_bits(efx, entry_location,
+					 ESF_GZ_CFGBAR_EF100_BAR);
+	u64 offset = ef100_pci_get_bar_bits(efx, entry_location,
+					    ESF_GZ_CFGBAR_EF100_FUNC_CTL_WIN_OFF) << ESE_GZ_EF100_FUNC_CTL_WIN_OFF_SHIFT;
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
+	if ((bar == ESE_GZ_CFGBAR_EF100_BAR_NUM_EXPANSION_ROM) ||
+	    (bar == ESE_GZ_CFGBAR_EF100_BAR_NUM_INVALID)) {
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
+		pci_resource_len(efx->pci_dev, bar);
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
+	if ((bar == ESE_GZ_VSEC_BAR_NUM_EXPANSION_ROM) ||
+	    (bar == ESE_GZ_VSEC_BAR_NUM_INVALID)) {
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
+		u32 id = ef100_pci_get_bar_bits(efx, current_entry,
+						ESF_GZ_CFGBAR_ENTRY_FORMAT);
+		u32 last = ef100_pci_get_bar_bits(efx, current_entry,
+						  ESF_GZ_CFGBAR_ENTRY_LAST);
+		u32 rev = ef100_pci_get_bar_bits(efx, current_entry,
+						 ESF_GZ_CFGBAR_ENTRY_REV);
+		u32 entry_size;
+
+		if (id == ESE_GZ_CFGBAR_ENTRY_LAST)
+			return 0;
+
+		entry_size = ef100_pci_get_bar_bits(efx, current_entry,
+						    ESF_GZ_CFGBAR_ENTRY_SIZE);
+
+		netif_dbg(efx, probe, efx->net_dev,
+			  "Seen Xilinx table entry 0x%x size 0x%x at 0x%llx in BAR[%d]\n",
+			  id, entry_size, current_entry, efx->mem_bar);
+
+		if (entry_size < sizeof(uint32_t) * 2) {
+			netif_err(efx, probe, efx->net_dev,
+				  "Xilinx table entry too short len=0x%x\n", entry_size);
+			return -EINVAL;
+		}
+
+		switch (id) {
+		case ESE_GZ_CFGBAR_ENTRY_EF100:
+			if ((rev != ESE_GZ_CFGBAR_ENTRY_REV_EF100) ||
+			    (entry_size < ESE_GZ_CFGBAR_ENTRY_SIZE_EF100)) {
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
+			if ((rev != 0) || (entry_size < ESE_GZ_CFGBAR_CONT_CAP_MIN_LENGTH)) {
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
+#define ef100_pci_get_config_bits(efx, entry_location, bitdef, result) \
+	_ef100_pci_get_config_bits_with_width(efx, entry_location,  \
+		bitdef ## _LBN, bitdef ## _WIDTH, result)
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
+	rc = ef100_pci_get_config_bits(efx, vndr_cap, ESF_GZ_VSEC_TBL_BAR, &bar);
+	if (rc) {
+		netif_err(efx, probe, efx->net_dev,
+			  "Failed to read ESF_GZ_VSEC_TBL_BAR, rc=%d\n",
+			  rc);
+		return rc;
+	}
+
+	if ((bar == ESE_GZ_CFGBAR_CONT_CAP_BAR_NUM_EXPANSION_ROM) ||
+	    (bar == ESE_GZ_CFGBAR_CONT_CAP_BAR_NUM_INVALID)) {
+		netif_err(efx, probe, efx->net_dev,
+			  "Bad BAR value of %d in Xilinx capabilities sub-table.\n",
+			  bar);
+		return -EINVAL;
+	}
+
+	rc = ef100_pci_get_config_bits(efx, vndr_cap, ESF_GZ_VSEC_TBL_OFF_LO, &offset_lo);
+	if (rc) {
+		netif_err(efx, probe, efx->net_dev,
+			  "Failed to read ESF_GZ_VSEC_TBL_OFF_LO, rc=%d\n",
+			  rc);
+		return rc;
+	}
+
+	/* Get optional extension to 64bit offset. */
+	if (has_offset_hi) {
+		rc = ef100_pci_get_config_bits(efx, vndr_cap, ESF_GZ_VSEC_TBL_OFF_HI, &offset_high);
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
+	if (offset > pci_resource_len(efx->pci_dev, bar) - sizeof(uint32_t) * 2) {
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
+		rc = ef100_pci_get_config_bits(efx, vndr_cap, ESF_GZ_VSEC_ID,
+					       &vsec_id);
+		if (rc) {
+			netif_err(efx, probe, efx->net_dev,
+				  "Failed to read ESF_GZ_VSEC_ID, rc=%d\n",
+				  rc);
+			return rc;
+		}
+
+		rc = ef100_pci_get_config_bits(efx, vndr_cap, ESF_GZ_VSEC_VER,
+					       &vsec_ver);
+		if (rc) {
+			netif_err(efx, probe, efx->net_dev,
+				  "Failed to read ESF_GZ_VSEC_VER, rc=%d\n",
+				  rc);
+			return rc;
+		}
+
+		/* Get length of whole capability - i.e. starting at cap */
+		rc = ef100_pci_get_config_bits(efx, vndr_cap, ESF_GZ_VSEC_LEN,
+					       &vsec_len);
+		if (rc) {
+			netif_err(efx, probe, efx->net_dev,
+				  "Failed to read ESF_GZ_VSEC_LEN, rc=%d\n",
+				  rc);
+			return rc;
+		}
+
+		if ((vsec_id == ESE_GZ_XILINX_VSEC_ID) &&
+		    (vsec_ver == ESE_GZ_VSEC_VER_XIL_CFGBAR) &&
+		    (vsec_len >= ESE_GZ_VSEC_LEN_MIN)) {
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
+static struct pci_driver ef100_pci_driver = {
+	.name           = KBUILD_MODNAME,
+	.id_table       = ef100_pci_table,
+	.probe          = ef100_pci_probe,
+	.remove         = ef100_pci_remove,
+	.err_handler    = &efx_err_handlers,
+};
+
+static int __init ef100_init_module(void)
+{
+	int rc;
+
+	pr_info("Solarflare EF100 NET driver v" EFX_DRIVER_VERSION "\n");
+
+	rc = efx_create_reset_workqueue();
+	if (rc)
+		goto err_reset;
+
+	rc = pci_register_driver(&ef100_pci_driver);
+	if (rc < 0) {
+		pr_err("pci_register_driver failed, rc=%d\n", rc);
+		goto err_pci;
+	}
+
+	return 0;
+
+err_pci:
+	efx_destroy_reset_workqueue();
+err_reset:
+	return rc;
+}
+
+static void __exit ef100_exit_module(void)
+{
+	pr_info("Solarflare EF100 NET driver unloading\n");
+
+	pci_unregister_driver(&ef100_pci_driver);
+}
+
+module_init(ef100_init_module);
+module_exit(ef100_exit_module);
+
+MODULE_DESCRIPTION("Solarflare EF100 network driver");
+MODULE_LICENSE("GPL");
+MODULE_DEVICE_TABLE(pci, ef100_pci_table);
+MODULE_VERSION(EFX_DRIVER_VERSION);
diff --git a/drivers/net/ethernet/sfc/ef100_ethtool.c b/drivers/net/ethernet/sfc/ef100_ethtool.c
new file mode 100644
index 000000000000..af3f385b828b
--- /dev/null
+++ b/drivers/net/ethernet/sfc/ef100_ethtool.c
@@ -0,0 +1,26 @@
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
+const char *efx_driver_name = KBUILD_MODNAME;
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
index 000000000000..356938104cb2
--- /dev/null
+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
@@ -0,0 +1,135 @@
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
+/* In EF10 this was a module parameter.  Since EF100 is a new module, we
+ * don't have to be compatible with the old module parameters, so we can
+ * get rid of it.
+ */
+bool efx_separate_tx_channels = false;
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
+netdev_tx_t ef100_hard_start_xmit(struct sk_buff *skb,
+				  struct net_device *net_dev)
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
+	rc = efx_enqueue_skb(tx_queue, skb);
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
index 000000000000..20b6f4bb35ad
--- /dev/null
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -0,0 +1,177 @@
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
+/* efx_mcdi_process_event() may call this */
+void efx_mcdi_sensor_event(struct efx_nic *efx, efx_qword_t *ev) {}
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
index 000000000000..f06aa302e9c9
--- /dev/null
+++ b/drivers/net/ethernet/sfc/ef100_rx.c
@@ -0,0 +1,24 @@
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
+
+void __efx_rx_packet(struct efx_channel *channel)
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
index 000000000000..9de9c2ab9014
--- /dev/null
+++ b/drivers/net/ethernet/sfc/ef100_rx.h
@@ -0,0 +1,17 @@
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
+#endif
diff --git a/drivers/net/ethernet/sfc/ef100_tx.c b/drivers/net/ethernet/sfc/ef100_tx.c
new file mode 100644
index 000000000000..0272f99b3115
--- /dev/null
+++ b/drivers/net/ethernet/sfc/ef100_tx.c
@@ -0,0 +1,43 @@
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
+#include "ef100_tx.h"
+
+int efx_enqueue_skb_tso(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
+			bool *data_mapped)
+{
+	/* This should never be called; it's just a stub callback for some
+	 * infrastructure that's shared with the EF10 driver
+	 * (tx_queue->handle_tso, only called from tx.c which isn't linked
+	 * into sfc_ef100.ko).
+	 */
+	WARN_ON_ONCE(1);
+	return -EOPNOTSUPP;
+}
+
+/* Add a socket buffer to a TX queue
+ *
+ * You must hold netif_tx_lock() to call this function.
+ *
+ * Returns 0 on success, error code otherwise. In case of an error this
+ * function will free the SKB.
+ */
+int efx_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb)
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
index 000000000000..dedfed5d3e53
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
+int efx_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb);
+#endif
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 5b3b3a976114..bf78c2faf999 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -38,7 +38,7 @@
  *
  **************************************************************************/
 
-#define EFX_DRIVER_VERSION	"4.1"
+#define EFX_DRIVER_VERSION	"4.2"
 
 #ifdef DEBUG
 #define EFX_WARN_ON_ONCE_PARANOID(x) WARN_ON_ONCE(x)
@@ -965,6 +965,7 @@ struct efx_async_filter_insertion {
  * @vpd_sn: Serial number read from VPD
  * @xdp_rxq_info_failed: Have any of the rx queues failed to initialise their
  *      xdp_rxq_info structures?
+ * @netdev_notifier: Netdevice notifier.
  * @mem_bar: The BAR that is mapped into membase.
  * @reg_base: Offset from the start of the bar to the function control window.
  * @monitor_work: Hardware monitor workitem
@@ -1144,6 +1145,8 @@ struct efx_nic {
 	char *vpd_sn;
 	bool xdp_rxq_info_failed;
 
+	struct notifier_block netdev_notifier;
+
 	unsigned int mem_bar;
 	u32 reg_base;
 
@@ -1532,6 +1535,13 @@ efx_get_channel(struct efx_nic *efx, unsigned index)
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


