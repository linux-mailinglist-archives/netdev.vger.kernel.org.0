Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 831FB20B06E
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 13:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728538AbgFZL22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 07:28:28 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:55096 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728507AbgFZL20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 07:28:26 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.137])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id A286F2006B;
        Fri, 26 Jun 2020 11:27:48 +0000 (UTC)
Received: from us4-mdac16-5.at1.mdlocal (unknown [10.110.49.156])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 9F570600A1;
        Fri, 26 Jun 2020 11:27:48 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.30])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id A3FF2220064;
        Fri, 26 Jun 2020 11:27:44 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id CD26D140053;
        Fri, 26 Jun 2020 11:27:43 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 26 Jun
 2020 12:27:36 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 01/15] sfc: update MCDI protocol headers
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <1a1716f9-f909-4093-8107-3c2435d834c5@solarflare.com>
Message-ID: <34ed97ee-30cf-79e4-1b7e-d632ccd873cc@solarflare.com>
Date:   Fri, 26 Jun 2020 12:27:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <1a1716f9-f909-4093-8107-3c2435d834c5@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25504.003
X-TM-AS-Result: No-11.076900-8.000000-10
X-TMASE-MatchedRID: RNGTuDIf0k40x5Wy/Waw/TCMW7zNwFaIeouvej40T4gd0WOKRkwsh3lo
        OvA4aBJJrdoLblq9S5oZhhkmdi0+GYH/9PEJqVb6yZHnIMmQ+Dh5ybkwtj/jvu+uPZ9E4AOJ1Pv
        t1iy/ad68lIcLEfemdMJC8zT8f/R3NLV8+yUR4KdtJYfOb0q5O86gBdMBUo412AlgMLPEIJY0AU
        nua7sA98H8WmACRbCuqGEXec6WUwS8d5sejJ4RdTn/wcdfjLjCUP/nkmPe8m5GMe+tDjQ3FuJ6q
        U1Gmm/Nn85M69KSLUlkn5lfr/bPm0sKIxV/Fggwk3vBUrd+MKd7xIKEgZq/AeXPgbQLgxs4NUJp
        jGnFhxTP7W1KyBJxpCe74xqcXYB1v6BRlcbPgdhusn2BWc6xndxWLypmYlZzRUPw1XTj5tPmxz8
        jq9dj3f1yMmLedky+w6gcKyTiSFpOb9m2zrTOQ2XW2V5hhS4ny0Q+dW8+UWRpsnGGIgWMmUqP1H
        OowF+7UD1P2LdFGf9G0976twbFk/K98DYar94BdftNavdzL2Gpvf+jmz45w2JGTIGsciLKMH1xx
        17eFtR/XFK38Ckcc4W6jRXgzU+w1O4tb6B2RARhXXywTJLpfF0DithooYrC+S5C/08hWc1LQZ8+
        Eb8GqI2cFpsnR1Q00RYK3pgVNSV7itKE91x1NqCkgp86+voPy6ZbL0nhex6HX0cDZiY+DVPzm1Q
        SSld2l2fYH5Y6jrWXnuE8Z2hbG9bCHM2gsS6ODDlsUbcsIPoD35/t0iNbhJiQXtm0V8JT2P2km/
        foisnXEy6weMUo0uORc+mJA7zJMGg+wgnY/emeAiCmPx4NwLTrdaH1ZWqC1kTfEkyaZdz6C0ePs
        7A07QKmARN5PTKc
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--11.076900-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25504.003
X-MDID: 1593170865-KrCPzySlRVvQ
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The script used to generate these now includes _OFST definitions for
 flags, to identify the containing flag word.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/mcdi_pcol.h | 6933 +++++++++++++++++++++++++-
 1 file changed, 6869 insertions(+), 64 deletions(-)

diff --git a/drivers/net/ethernet/sfc/mcdi_pcol.h b/drivers/net/ethernet/sfc/mcdi_pcol.h
index 79d834a4ae49..d3fcbf930dba 100644
--- a/drivers/net/ethernet/sfc/mcdi_pcol.h
+++ b/drivers/net/ethernet/sfc/mcdi_pcol.h
@@ -1,7 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /****************************************************************************
  * Driver for Solarflare network controllers and boards
- * Copyright 2009-2013 Solarflare Communications Inc.
+ * Copyright 2009-2018 Solarflare Communications Inc.
+ * Copyright 2019-2020 Xilinx Inc.
  */
 
 
@@ -383,14 +384,19 @@
 #define          MCDI_EVENT_LEVEL_FATAL 0x3
 #define       MCDI_EVENT_DATA_OFST 0
 #define       MCDI_EVENT_DATA_LEN 4
+#define        MCDI_EVENT_CMDDONE_SEQ_OFST 0
 #define        MCDI_EVENT_CMDDONE_SEQ_LBN 0
 #define        MCDI_EVENT_CMDDONE_SEQ_WIDTH 8
+#define        MCDI_EVENT_CMDDONE_DATALEN_OFST 0
 #define        MCDI_EVENT_CMDDONE_DATALEN_LBN 8
 #define        MCDI_EVENT_CMDDONE_DATALEN_WIDTH 8
+#define        MCDI_EVENT_CMDDONE_ERRNO_OFST 0
 #define        MCDI_EVENT_CMDDONE_ERRNO_LBN 16
 #define        MCDI_EVENT_CMDDONE_ERRNO_WIDTH 8
+#define        MCDI_EVENT_LINKCHANGE_LP_CAP_OFST 0
 #define        MCDI_EVENT_LINKCHANGE_LP_CAP_LBN 0
 #define        MCDI_EVENT_LINKCHANGE_LP_CAP_WIDTH 16
+#define        MCDI_EVENT_LINKCHANGE_SPEED_OFST 0
 #define        MCDI_EVENT_LINKCHANGE_SPEED_LBN 16
 #define        MCDI_EVENT_LINKCHANGE_SPEED_WIDTH 4
 /* enum: Link is down or link speed could not be determined */
@@ -409,26 +415,36 @@
 #define          MCDI_EVENT_LINKCHANGE_SPEED_50G 0x6
 /* enum: 100Gbs */
 #define          MCDI_EVENT_LINKCHANGE_SPEED_100G 0x7
+#define        MCDI_EVENT_LINKCHANGE_FCNTL_OFST 0
 #define        MCDI_EVENT_LINKCHANGE_FCNTL_LBN 20
 #define        MCDI_EVENT_LINKCHANGE_FCNTL_WIDTH 4
+#define        MCDI_EVENT_LINKCHANGE_LINK_FLAGS_OFST 0
 #define        MCDI_EVENT_LINKCHANGE_LINK_FLAGS_LBN 24
 #define        MCDI_EVENT_LINKCHANGE_LINK_FLAGS_WIDTH 8
+#define        MCDI_EVENT_SENSOREVT_MONITOR_OFST 0
 #define        MCDI_EVENT_SENSOREVT_MONITOR_LBN 0
 #define        MCDI_EVENT_SENSOREVT_MONITOR_WIDTH 8
+#define        MCDI_EVENT_SENSOREVT_STATE_OFST 0
 #define        MCDI_EVENT_SENSOREVT_STATE_LBN 8
 #define        MCDI_EVENT_SENSOREVT_STATE_WIDTH 8
+#define        MCDI_EVENT_SENSOREVT_VALUE_OFST 0
 #define        MCDI_EVENT_SENSOREVT_VALUE_LBN 16
 #define        MCDI_EVENT_SENSOREVT_VALUE_WIDTH 16
+#define        MCDI_EVENT_FWALERT_DATA_OFST 0
 #define        MCDI_EVENT_FWALERT_DATA_LBN 8
 #define        MCDI_EVENT_FWALERT_DATA_WIDTH 24
+#define        MCDI_EVENT_FWALERT_REASON_OFST 0
 #define        MCDI_EVENT_FWALERT_REASON_LBN 0
 #define        MCDI_EVENT_FWALERT_REASON_WIDTH 8
 /* enum: SRAM Access. */
 #define          MCDI_EVENT_FWALERT_REASON_SRAM_ACCESS 0x1
+#define        MCDI_EVENT_FLR_VF_OFST 0
 #define        MCDI_EVENT_FLR_VF_LBN 0
 #define        MCDI_EVENT_FLR_VF_WIDTH 8
+#define        MCDI_EVENT_TX_ERR_TXQ_OFST 0
 #define        MCDI_EVENT_TX_ERR_TXQ_LBN 0
 #define        MCDI_EVENT_TX_ERR_TXQ_WIDTH 12
+#define        MCDI_EVENT_TX_ERR_TYPE_OFST 0
 #define        MCDI_EVENT_TX_ERR_TYPE_LBN 12
 #define        MCDI_EVENT_TX_ERR_TYPE_WIDTH 4
 /* enum: Descriptor loader reported failure */
@@ -443,12 +459,16 @@
 #define          MCDI_EVENT_TX_OPT_IN_PKT 0x8
 /* enum: DMA or PIO data access error */
 #define          MCDI_EVENT_TX_ERR_BAD_DMA_OR_PIO 0x9
+#define        MCDI_EVENT_TX_ERR_INFO_OFST 0
 #define        MCDI_EVENT_TX_ERR_INFO_LBN 16
 #define        MCDI_EVENT_TX_ERR_INFO_WIDTH 16
+#define        MCDI_EVENT_TX_FLUSH_TO_DRIVER_OFST 0
 #define        MCDI_EVENT_TX_FLUSH_TO_DRIVER_LBN 12
 #define        MCDI_EVENT_TX_FLUSH_TO_DRIVER_WIDTH 1
+#define        MCDI_EVENT_TX_FLUSH_TXQ_OFST 0
 #define        MCDI_EVENT_TX_FLUSH_TXQ_LBN 0
 #define        MCDI_EVENT_TX_FLUSH_TXQ_WIDTH 12
+#define        MCDI_EVENT_PTP_ERR_TYPE_OFST 0
 #define        MCDI_EVENT_PTP_ERR_TYPE_LBN 0
 #define        MCDI_EVENT_PTP_ERR_TYPE_WIDTH 8
 /* enum: PLL lost lock */
@@ -459,6 +479,7 @@
 #define          MCDI_EVENT_PTP_ERR_FIFO 0x3
 /* enum: Merge queue overflow */
 #define          MCDI_EVENT_PTP_ERR_QUEUE 0x4
+#define        MCDI_EVENT_AOE_ERR_TYPE_OFST 0
 #define        MCDI_EVENT_AOE_ERR_TYPE_LBN 0
 #define        MCDI_EVENT_AOE_ERR_TYPE_WIDTH 8
 /* enum: AOE failed to load - no valid image? */
@@ -505,8 +526,10 @@
 #define          MCDI_EVENT_AOE_FPGA_CLOCKS_PROGRAM_FAILED 0x13
 /* enum: Notify that FPGA Controller is alive to serve MCDI requests */
 #define          MCDI_EVENT_AOE_FC_RUNNING 0x14
+#define        MCDI_EVENT_AOE_ERR_DATA_OFST 0
 #define        MCDI_EVENT_AOE_ERR_DATA_LBN 8
 #define        MCDI_EVENT_AOE_ERR_DATA_WIDTH 8
+#define        MCDI_EVENT_AOE_ERR_FC_ASSERT_INFO_OFST 0
 #define        MCDI_EVENT_AOE_ERR_FC_ASSERT_INFO_LBN 8
 #define        MCDI_EVENT_AOE_ERR_FC_ASSERT_INFO_WIDTH 8
 /* enum: FC Assert happened, but the register information is not available */
@@ -514,6 +537,7 @@
 /* enum: The register information for FC Assert is ready for readinng by driver
  */
 #define          MCDI_EVENT_AOE_ERR_FC_ASSERT_DATA_READY 0x1
+#define        MCDI_EVENT_AOE_ERR_CODE_FPGA_HEADER_VERIFY_FAILED_OFST 0
 #define        MCDI_EVENT_AOE_ERR_CODE_FPGA_HEADER_VERIFY_FAILED_LBN 8
 #define        MCDI_EVENT_AOE_ERR_CODE_FPGA_HEADER_VERIFY_FAILED_WIDTH 8
 /* enum: Reading from NV failed */
@@ -534,28 +558,38 @@
 #define          MCDI_EVENT_AOE_ERR_FPGA_HEADER_DDR_SIZE 0x7
 /* enum: Unsupported DDR rank */
 #define          MCDI_EVENT_AOE_ERR_FPGA_HEADER_DDR_RANK 0x8
+#define        MCDI_EVENT_AOE_ERR_CODE_INVALID_FPGA_FLASH_TYPE_INFO_OFST 0
 #define        MCDI_EVENT_AOE_ERR_CODE_INVALID_FPGA_FLASH_TYPE_INFO_LBN 8
 #define        MCDI_EVENT_AOE_ERR_CODE_INVALID_FPGA_FLASH_TYPE_INFO_WIDTH 8
 /* enum: Primary boot flash */
 #define          MCDI_EVENT_AOE_FLASH_TYPE_BOOT_PRIMARY 0x0
 /* enum: Secondary boot flash */
 #define          MCDI_EVENT_AOE_FLASH_TYPE_BOOT_SECONDARY 0x1
+#define        MCDI_EVENT_AOE_ERR_CODE_FPGA_POWER_OFF_OFST 0
 #define        MCDI_EVENT_AOE_ERR_CODE_FPGA_POWER_OFF_LBN 8
 #define        MCDI_EVENT_AOE_ERR_CODE_FPGA_POWER_OFF_WIDTH 8
+#define        MCDI_EVENT_AOE_ERR_CODE_FPGA_LOAD_FAILED_OFST 0
 #define        MCDI_EVENT_AOE_ERR_CODE_FPGA_LOAD_FAILED_LBN 8
 #define        MCDI_EVENT_AOE_ERR_CODE_FPGA_LOAD_FAILED_WIDTH 8
+#define        MCDI_EVENT_RX_ERR_RXQ_OFST 0
 #define        MCDI_EVENT_RX_ERR_RXQ_LBN 0
 #define        MCDI_EVENT_RX_ERR_RXQ_WIDTH 12
+#define        MCDI_EVENT_RX_ERR_TYPE_OFST 0
 #define        MCDI_EVENT_RX_ERR_TYPE_LBN 12
 #define        MCDI_EVENT_RX_ERR_TYPE_WIDTH 4
+#define        MCDI_EVENT_RX_ERR_INFO_OFST 0
 #define        MCDI_EVENT_RX_ERR_INFO_LBN 16
 #define        MCDI_EVENT_RX_ERR_INFO_WIDTH 16
+#define        MCDI_EVENT_RX_FLUSH_TO_DRIVER_OFST 0
 #define        MCDI_EVENT_RX_FLUSH_TO_DRIVER_LBN 12
 #define        MCDI_EVENT_RX_FLUSH_TO_DRIVER_WIDTH 1
+#define        MCDI_EVENT_RX_FLUSH_RXQ_OFST 0
 #define        MCDI_EVENT_RX_FLUSH_RXQ_LBN 0
 #define        MCDI_EVENT_RX_FLUSH_RXQ_WIDTH 12
+#define        MCDI_EVENT_MC_REBOOT_COUNT_OFST 0
 #define        MCDI_EVENT_MC_REBOOT_COUNT_LBN 0
 #define        MCDI_EVENT_MC_REBOOT_COUNT_WIDTH 16
+#define        MCDI_EVENT_MUM_ERR_TYPE_OFST 0
 #define        MCDI_EVENT_MUM_ERR_TYPE_LBN 0
 #define        MCDI_EVENT_MUM_ERR_TYPE_WIDTH 8
 /* enum: MUM failed to load - no valid image? */
@@ -564,10 +598,13 @@
 #define          MCDI_EVENT_MUM_ASSERT 0x2
 /* enum: MUM not kicking watchdog */
 #define          MCDI_EVENT_MUM_WATCHDOG 0x3
+#define        MCDI_EVENT_MUM_ERR_DATA_OFST 0
 #define        MCDI_EVENT_MUM_ERR_DATA_LBN 8
 #define        MCDI_EVENT_MUM_ERR_DATA_WIDTH 8
+#define        MCDI_EVENT_DBRET_SEQ_OFST 0
 #define        MCDI_EVENT_DBRET_SEQ_LBN 0
 #define        MCDI_EVENT_DBRET_SEQ_WIDTH 8
+#define        MCDI_EVENT_SUC_ERR_TYPE_OFST 0
 #define        MCDI_EVENT_SUC_ERR_TYPE_LBN 0
 #define        MCDI_EVENT_SUC_ERR_TYPE_WIDTH 8
 /* enum: Corrupted or bad SUC application. */
@@ -578,14 +615,48 @@
 #define          MCDI_EVENT_SUC_EXCEPTION 0x3
 /* enum: SUC watchdog timer expired. */
 #define          MCDI_EVENT_SUC_WATCHDOG 0x4
+#define        MCDI_EVENT_SUC_ERR_ADDRESS_OFST 0
 #define        MCDI_EVENT_SUC_ERR_ADDRESS_LBN 8
 #define        MCDI_EVENT_SUC_ERR_ADDRESS_WIDTH 24
+#define        MCDI_EVENT_SUC_ERR_DATA_OFST 0
 #define        MCDI_EVENT_SUC_ERR_DATA_LBN 8
 #define        MCDI_EVENT_SUC_ERR_DATA_WIDTH 24
+#define        MCDI_EVENT_LINKCHANGE_V2_LP_CAP_OFST 0
+#define        MCDI_EVENT_LINKCHANGE_V2_LP_CAP_LBN 0
+#define        MCDI_EVENT_LINKCHANGE_V2_LP_CAP_WIDTH 24
+#define        MCDI_EVENT_LINKCHANGE_V2_SPEED_OFST 0
+#define        MCDI_EVENT_LINKCHANGE_V2_SPEED_LBN 24
+#define        MCDI_EVENT_LINKCHANGE_V2_SPEED_WIDTH 4
+/*             Enum values, see field(s): */
+/*                MCDI_EVENT/LINKCHANGE_SPEED */
+#define        MCDI_EVENT_LINKCHANGE_V2_FLAGS_LINK_UP_OFST 0
+#define        MCDI_EVENT_LINKCHANGE_V2_FLAGS_LINK_UP_LBN 28
+#define        MCDI_EVENT_LINKCHANGE_V2_FLAGS_LINK_UP_WIDTH 1
+#define        MCDI_EVENT_LINKCHANGE_V2_FCNTL_OFST 0
+#define        MCDI_EVENT_LINKCHANGE_V2_FCNTL_LBN 29
+#define        MCDI_EVENT_LINKCHANGE_V2_FCNTL_WIDTH 3
+/*             Enum values, see field(s): */
+/*                MC_CMD_SET_MAC/MC_CMD_SET_MAC_IN/FCNTL */
+#define        MCDI_EVENT_MODULECHANGE_LD_CAP_OFST 0
+#define        MCDI_EVENT_MODULECHANGE_LD_CAP_LBN 0
+#define        MCDI_EVENT_MODULECHANGE_LD_CAP_WIDTH 30
+#define        MCDI_EVENT_MODULECHANGE_SEQ_OFST 0
+#define        MCDI_EVENT_MODULECHANGE_SEQ_LBN 30
+#define        MCDI_EVENT_MODULECHANGE_SEQ_WIDTH 2
 #define       MCDI_EVENT_DATA_LBN 0
 #define       MCDI_EVENT_DATA_WIDTH 32
+/* Alias for PTP_DATA. */
 #define       MCDI_EVENT_SRC_LBN 36
 #define       MCDI_EVENT_SRC_WIDTH 8
+/* Data associated with PTP events which doesn't fit into the main DATA field
+ */
+#define       MCDI_EVENT_PTP_DATA_LBN 36
+#define       MCDI_EVENT_PTP_DATA_WIDTH 8
+/* EF100 specific. Defined by QDMA. The phase bit, changes each time round the
+ * event ring
+ */
+#define       MCDI_EVENT_EV_EVQ_PHASE_LBN 59
+#define       MCDI_EVENT_EV_EVQ_PHASE_WIDTH 1
 #define       MCDI_EVENT_EV_CODE_LBN 60
 #define       MCDI_EVENT_EV_CODE_WIDTH 4
 #define       MCDI_EVENT_CODE_LBN 44
@@ -660,6 +731,48 @@
 #define          MCDI_EVENT_CODE_DBRET 0x1e
 /* enum: The MC has detected a fault on the SUC */
 #define          MCDI_EVENT_CODE_SUC 0x1f
+/* enum: Link change. This event is sent instead of LINKCHANGE if
+ * WANT_V2_LINKCHANGES was set on driver attach.
+ */
+#define          MCDI_EVENT_CODE_LINKCHANGE_V2 0x20
+/* enum: This event is sent if WANT_V2_LINKCHANGES was set on driver attach
+ * when the local device capabilities changes. This will usually correspond to
+ * a module change.
+ */
+#define          MCDI_EVENT_CODE_MODULECHANGE 0x21
+/* enum: Notification that the sensors have been added and/or removed from the
+ * sensor table. This event includes the new sensor table generation count, if
+ * this does not match the driver's local copy it is expected to call
+ * DYNAMIC_SENSORS_LIST to refresh it.
+ */
+#define          MCDI_EVENT_CODE_DYNAMIC_SENSORS_CHANGE 0x22
+/* enum: Notification that a sensor has changed state as a result of a reading
+ * crossing a threshold. This is sent as two events, the first event contains
+ * the handle and the sensor's state (in the SRC field), and the second
+ * contains the value.
+ */
+#define          MCDI_EVENT_CODE_DYNAMIC_SENSORS_STATE_CHANGE 0x23
+/* enum: Notification that a descriptor proxy function configuration has been
+ * pushed to "live" status (visible to host). SRC field contains the handle of
+ * the affected descriptor proxy function. DATA field contains the generation
+ * count of configuration set applied. See MC_CMD_DESC_PROXY_FUNC_CONFIG_SET /
+ * MC_CMD_DESC_PROXY_FUNC_CONFIG_COMMIT and SF-122927-TC for details.
+ */
+#define          MCDI_EVENT_CODE_DESC_PROXY_FUNC_CONFIG_COMMITTED 0x24
+/* enum: Notification that a descriptor proxy function has been reset. SRC
+ * field contains the handle of the affected descriptor proxy function. See
+ * SF-122927-TC for details.
+ */
+#define          MCDI_EVENT_CODE_DESC_PROXY_FUNC_RESET 0x25
+/* enum: Notification that a driver attached to a descriptor proxy function.
+ * SRC field contains the handle of the affected descriptor proxy function. For
+ * Virtio proxy functions this message consists of two MCDI events, where the
+ * first event's (CONT=1) DATA field carries negotiated virtio feature bits 0
+ * to 31 and the second (CONT=0) carries bits 32 to 63. For EF100 proxy
+ * functions event length and meaning of DATA field is not yet defined. See
+ * SF-122927-TC for details.
+ */
+#define          MCDI_EVENT_CODE_DESC_PROXY_FUNC_DRIVER_ATTACH 0x26
 /* enum: Artificial event generated by host and posted via MC for test
  * purposes.
  */
@@ -785,6 +898,48 @@
 #define       MCDI_EVENT_DBRET_DATA_LEN 4
 #define       MCDI_EVENT_DBRET_DATA_LBN 0
 #define       MCDI_EVENT_DBRET_DATA_WIDTH 32
+#define       MCDI_EVENT_LINKCHANGE_V2_DATA_OFST 0
+#define       MCDI_EVENT_LINKCHANGE_V2_DATA_LEN 4
+#define       MCDI_EVENT_LINKCHANGE_V2_DATA_LBN 0
+#define       MCDI_EVENT_LINKCHANGE_V2_DATA_WIDTH 32
+#define       MCDI_EVENT_MODULECHANGE_DATA_OFST 0
+#define       MCDI_EVENT_MODULECHANGE_DATA_LEN 4
+#define       MCDI_EVENT_MODULECHANGE_DATA_LBN 0
+#define       MCDI_EVENT_MODULECHANGE_DATA_WIDTH 32
+/* The new generation count after a sensor has been added or deleted. */
+#define       MCDI_EVENT_DYNAMIC_SENSORS_GENERATION_OFST 0
+#define       MCDI_EVENT_DYNAMIC_SENSORS_GENERATION_LEN 4
+#define       MCDI_EVENT_DYNAMIC_SENSORS_GENERATION_LBN 0
+#define       MCDI_EVENT_DYNAMIC_SENSORS_GENERATION_WIDTH 32
+/* The handle of a dynamic sensor. */
+#define       MCDI_EVENT_DYNAMIC_SENSORS_HANDLE_OFST 0
+#define       MCDI_EVENT_DYNAMIC_SENSORS_HANDLE_LEN 4
+#define       MCDI_EVENT_DYNAMIC_SENSORS_HANDLE_LBN 0
+#define       MCDI_EVENT_DYNAMIC_SENSORS_HANDLE_WIDTH 32
+/* The current values of a sensor. */
+#define       MCDI_EVENT_DYNAMIC_SENSORS_VALUE_OFST 0
+#define       MCDI_EVENT_DYNAMIC_SENSORS_VALUE_LEN 4
+#define       MCDI_EVENT_DYNAMIC_SENSORS_VALUE_LBN 0
+#define       MCDI_EVENT_DYNAMIC_SENSORS_VALUE_WIDTH 32
+/* The current state of a sensor. */
+#define       MCDI_EVENT_DYNAMIC_SENSORS_STATE_LBN 36
+#define       MCDI_EVENT_DYNAMIC_SENSORS_STATE_WIDTH 8
+#define       MCDI_EVENT_DESC_PROXY_DATA_OFST 0
+#define       MCDI_EVENT_DESC_PROXY_DATA_LEN 4
+#define       MCDI_EVENT_DESC_PROXY_DATA_LBN 0
+#define       MCDI_EVENT_DESC_PROXY_DATA_WIDTH 32
+/* Generation count of applied configuration set */
+#define       MCDI_EVENT_DESC_PROXY_GENERATION_OFST 0
+#define       MCDI_EVENT_DESC_PROXY_GENERATION_LEN 4
+#define       MCDI_EVENT_DESC_PROXY_GENERATION_LBN 0
+#define       MCDI_EVENT_DESC_PROXY_GENERATION_WIDTH 32
+/* Virtio features negotiated with the host driver. First event (CONT=1)
+ * carries bits 0 to 31. Second event (CONT=0) carries bits 32 to 63.
+ */
+#define       MCDI_EVENT_DESC_PROXY_VIRTIO_FEATURES_OFST 0
+#define       MCDI_EVENT_DESC_PROXY_VIRTIO_FEATURES_LEN 4
+#define       MCDI_EVENT_DESC_PROXY_VIRTIO_FEATURES_LBN 0
+#define       MCDI_EVENT_DESC_PROXY_VIRTIO_FEATURES_WIDTH 32
 
 /* FCDI_EVENT structuredef */
 #define    FCDI_EVENT_LEN 8
@@ -802,6 +957,7 @@
 #define          FCDI_EVENT_LEVEL_FATAL 0x3
 #define       FCDI_EVENT_DATA_OFST 0
 #define       FCDI_EVENT_DATA_LEN 4
+#define        FCDI_EVENT_LINK_STATE_STATUS_OFST 0
 #define        FCDI_EVENT_LINK_STATE_STATUS_LBN 0
 #define        FCDI_EVENT_LINK_STATE_STATUS_WIDTH 1
 #define          FCDI_EVENT_LINK_DOWN 0x0 /* enum */
@@ -892,7 +1048,9 @@
  */
 #define    FCDI_EXTENDED_EVENT_PPS_LENMIN 16
 #define    FCDI_EXTENDED_EVENT_PPS_LENMAX 248
+#define    FCDI_EXTENDED_EVENT_PPS_LENMAX_MCDI2 1016
 #define    FCDI_EXTENDED_EVENT_PPS_LEN(num) (8+8*(num))
+#define    FCDI_EXTENDED_EVENT_PPS_TIMESTAMPS_NUM(len) (((len)-8)/8)
 /* Number of timestamps following */
 #define       FCDI_EXTENDED_EVENT_PPS_COUNT_OFST 0
 #define       FCDI_EXTENDED_EVENT_PPS_COUNT_LEN 4
@@ -915,6 +1073,7 @@
 #define       FCDI_EXTENDED_EVENT_PPS_TIMESTAMPS_HI_OFST 12
 #define       FCDI_EXTENDED_EVENT_PPS_TIMESTAMPS_MINNUM 1
 #define       FCDI_EXTENDED_EVENT_PPS_TIMESTAMPS_MAXNUM 30
+#define       FCDI_EXTENDED_EVENT_PPS_TIMESTAMPS_MAXNUM_MCDI2 126
 #define       FCDI_EXTENDED_EVENT_PPS_TIMESTAMPS_LBN 64
 #define       FCDI_EXTENDED_EVENT_PPS_TIMESTAMPS_WIDTH 64
 
@@ -934,24 +1093,33 @@
 #define          MUM_EVENT_LEVEL_FATAL 0x3
 #define       MUM_EVENT_DATA_OFST 0
 #define       MUM_EVENT_DATA_LEN 4
+#define        MUM_EVENT_SENSOR_ID_OFST 0
 #define        MUM_EVENT_SENSOR_ID_LBN 0
 #define        MUM_EVENT_SENSOR_ID_WIDTH 8
 /*             Enum values, see field(s): */
 /*                MC_CMD_SENSOR_INFO/MC_CMD_SENSOR_INFO_OUT/MASK */
+#define        MUM_EVENT_SENSOR_STATE_OFST 0
 #define        MUM_EVENT_SENSOR_STATE_LBN 8
 #define        MUM_EVENT_SENSOR_STATE_WIDTH 8
+#define        MUM_EVENT_PORT_PHY_READY_OFST 0
 #define        MUM_EVENT_PORT_PHY_READY_LBN 0
 #define        MUM_EVENT_PORT_PHY_READY_WIDTH 1
+#define        MUM_EVENT_PORT_PHY_LINK_UP_OFST 0
 #define        MUM_EVENT_PORT_PHY_LINK_UP_LBN 1
 #define        MUM_EVENT_PORT_PHY_LINK_UP_WIDTH 1
+#define        MUM_EVENT_PORT_PHY_TX_LOL_OFST 0
 #define        MUM_EVENT_PORT_PHY_TX_LOL_LBN 2
 #define        MUM_EVENT_PORT_PHY_TX_LOL_WIDTH 1
+#define        MUM_EVENT_PORT_PHY_RX_LOL_OFST 0
 #define        MUM_EVENT_PORT_PHY_RX_LOL_LBN 3
 #define        MUM_EVENT_PORT_PHY_RX_LOL_WIDTH 1
+#define        MUM_EVENT_PORT_PHY_TX_LOS_OFST 0
 #define        MUM_EVENT_PORT_PHY_TX_LOS_LBN 4
 #define        MUM_EVENT_PORT_PHY_TX_LOS_WIDTH 1
+#define        MUM_EVENT_PORT_PHY_RX_LOS_OFST 0
 #define        MUM_EVENT_PORT_PHY_RX_LOS_LBN 5
 #define        MUM_EVENT_PORT_PHY_RX_LOS_WIDTH 1
+#define        MUM_EVENT_PORT_PHY_TX_FAULT_OFST 0
 #define        MUM_EVENT_PORT_PHY_TX_FAULT_LBN 6
 #define        MUM_EVENT_PORT_PHY_TX_FAULT_WIDTH 1
 #define       MUM_EVENT_DATA_LBN 0
@@ -1016,6 +1184,7 @@
  * has additional checks to reject insecure calls.
  */
 #define MC_CMD_READ32 0x1
+#undef MC_CMD_0x1_PRIVILEGE_CTG
 
 #define MC_CMD_0x1_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
@@ -1029,11 +1198,14 @@
 /* MC_CMD_READ32_OUT msgresponse */
 #define    MC_CMD_READ32_OUT_LENMIN 4
 #define    MC_CMD_READ32_OUT_LENMAX 252
+#define    MC_CMD_READ32_OUT_LENMAX_MCDI2 1020
 #define    MC_CMD_READ32_OUT_LEN(num) (0+4*(num))
+#define    MC_CMD_READ32_OUT_BUFFER_NUM(len) (((len)-0)/4)
 #define       MC_CMD_READ32_OUT_BUFFER_OFST 0
 #define       MC_CMD_READ32_OUT_BUFFER_LEN 4
 #define       MC_CMD_READ32_OUT_BUFFER_MINNUM 1
 #define       MC_CMD_READ32_OUT_BUFFER_MAXNUM 63
+#define       MC_CMD_READ32_OUT_BUFFER_MAXNUM_MCDI2 255
 
 
 /***********************************/
@@ -1041,19 +1213,23 @@
  * Write multiple 32byte words to MC memory.
  */
 #define MC_CMD_WRITE32 0x2
+#undef MC_CMD_0x2_PRIVILEGE_CTG
 
 #define MC_CMD_0x2_PRIVILEGE_CTG SRIOV_CTG_INSECURE
 
 /* MC_CMD_WRITE32_IN msgrequest */
 #define    MC_CMD_WRITE32_IN_LENMIN 8
 #define    MC_CMD_WRITE32_IN_LENMAX 252
+#define    MC_CMD_WRITE32_IN_LENMAX_MCDI2 1020
 #define    MC_CMD_WRITE32_IN_LEN(num) (4+4*(num))
+#define    MC_CMD_WRITE32_IN_BUFFER_NUM(len) (((len)-4)/4)
 #define       MC_CMD_WRITE32_IN_ADDR_OFST 0
 #define       MC_CMD_WRITE32_IN_ADDR_LEN 4
 #define       MC_CMD_WRITE32_IN_BUFFER_OFST 4
 #define       MC_CMD_WRITE32_IN_BUFFER_LEN 4
 #define       MC_CMD_WRITE32_IN_BUFFER_MINNUM 1
 #define       MC_CMD_WRITE32_IN_BUFFER_MAXNUM 62
+#define       MC_CMD_WRITE32_IN_BUFFER_MAXNUM_MCDI2 254
 
 /* MC_CMD_WRITE32_OUT msgresponse */
 #define    MC_CMD_WRITE32_OUT_LEN 0
@@ -1066,6 +1242,7 @@
  * has additional checks to reject insecure calls.
  */
 #define MC_CMD_COPYCODE 0x3
+#undef MC_CMD_0x3_PRIVILEGE_CTG
 
 #define MC_CMD_0x3_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
@@ -1090,16 +1267,22 @@
  * below)
  */
 #define          MC_CMD_COPYCODE_HUNT_IGNORE_CONFIG_MAGIC_ADDR 0x1badc
+#define        MC_CMD_COPYCODE_IN_BOOT_MAGIC_PRESENT_OFST 0
 #define        MC_CMD_COPYCODE_IN_BOOT_MAGIC_PRESENT_LBN 17
 #define        MC_CMD_COPYCODE_IN_BOOT_MAGIC_PRESENT_WIDTH 1
+#define        MC_CMD_COPYCODE_IN_BOOT_MAGIC_SATELLITE_CPUS_NOT_LOADED_OFST 0
 #define        MC_CMD_COPYCODE_IN_BOOT_MAGIC_SATELLITE_CPUS_NOT_LOADED_LBN 2
 #define        MC_CMD_COPYCODE_IN_BOOT_MAGIC_SATELLITE_CPUS_NOT_LOADED_WIDTH 1
+#define        MC_CMD_COPYCODE_IN_BOOT_MAGIC_IGNORE_CONFIG_OFST 0
 #define        MC_CMD_COPYCODE_IN_BOOT_MAGIC_IGNORE_CONFIG_LBN 3
 #define        MC_CMD_COPYCODE_IN_BOOT_MAGIC_IGNORE_CONFIG_WIDTH 1
+#define        MC_CMD_COPYCODE_IN_BOOT_MAGIC_SKIP_BOOT_ICORE_SYNC_OFST 0
 #define        MC_CMD_COPYCODE_IN_BOOT_MAGIC_SKIP_BOOT_ICORE_SYNC_LBN 4
 #define        MC_CMD_COPYCODE_IN_BOOT_MAGIC_SKIP_BOOT_ICORE_SYNC_WIDTH 1
+#define        MC_CMD_COPYCODE_IN_BOOT_MAGIC_FORCE_STANDALONE_OFST 0
 #define        MC_CMD_COPYCODE_IN_BOOT_MAGIC_FORCE_STANDALONE_LBN 5
 #define        MC_CMD_COPYCODE_IN_BOOT_MAGIC_FORCE_STANDALONE_WIDTH 1
+#define        MC_CMD_COPYCODE_IN_BOOT_MAGIC_DISABLE_XIP_OFST 0
 #define        MC_CMD_COPYCODE_IN_BOOT_MAGIC_DISABLE_XIP_LBN 6
 #define        MC_CMD_COPYCODE_IN_BOOT_MAGIC_DISABLE_XIP_WIDTH 1
 /* Destination address */
@@ -1122,6 +1305,7 @@
  * Select function for function-specific commands.
  */
 #define MC_CMD_SET_FUNC 0x4
+#undef MC_CMD_0x4_PRIVILEGE_CTG
 
 #define MC_CMD_0x4_PRIVILEGE_CTG SRIOV_CTG_INSECURE
 
@@ -1140,6 +1324,7 @@
  * Get the instruction address from which the MC booted.
  */
 #define MC_CMD_GET_BOOT_STATUS 0x5
+#undef MC_CMD_0x5_PRIVILEGE_CTG
 
 #define MC_CMD_0x5_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -1155,10 +1340,13 @@
 #define          MC_CMD_GET_BOOT_STATUS_OUT_BOOT_OFFSET_NULL 0xdeadbeef
 #define       MC_CMD_GET_BOOT_STATUS_OUT_FLAGS_OFST 4
 #define       MC_CMD_GET_BOOT_STATUS_OUT_FLAGS_LEN 4
+#define        MC_CMD_GET_BOOT_STATUS_OUT_FLAGS_WATCHDOG_OFST 4
 #define        MC_CMD_GET_BOOT_STATUS_OUT_FLAGS_WATCHDOG_LBN 0
 #define        MC_CMD_GET_BOOT_STATUS_OUT_FLAGS_WATCHDOG_WIDTH 1
+#define        MC_CMD_GET_BOOT_STATUS_OUT_FLAGS_PRIMARY_OFST 4
 #define        MC_CMD_GET_BOOT_STATUS_OUT_FLAGS_PRIMARY_LBN 1
 #define        MC_CMD_GET_BOOT_STATUS_OUT_FLAGS_PRIMARY_WIDTH 1
+#define        MC_CMD_GET_BOOT_STATUS_OUT_FLAGS_BACKUP_OFST 4
 #define        MC_CMD_GET_BOOT_STATUS_OUT_FLAGS_BACKUP_LBN 2
 #define        MC_CMD_GET_BOOT_STATUS_OUT_FLAGS_BACKUP_WIDTH 1
 
@@ -1170,6 +1358,7 @@
  * fields will only be present if OUT.GLOBAL_FLAGS != NO_FAILS
  */
 #define MC_CMD_GET_ASSERTS 0x6
+#undef MC_CMD_0x6_PRIVILEGE_CTG
 
 #define MC_CMD_0x6_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
@@ -1211,6 +1400,104 @@
 #define       MC_CMD_GET_ASSERTS_OUT_RESERVED_OFST 136
 #define       MC_CMD_GET_ASSERTS_OUT_RESERVED_LEN 4
 
+/* MC_CMD_GET_ASSERTS_OUT_V2 msgresponse: Extended response for MicroBlaze CPUs
+ * found on Riverhead designs
+ */
+#define    MC_CMD_GET_ASSERTS_OUT_V2_LEN 240
+/* Assertion status flag. */
+#define       MC_CMD_GET_ASSERTS_OUT_V2_GLOBAL_FLAGS_OFST 0
+#define       MC_CMD_GET_ASSERTS_OUT_V2_GLOBAL_FLAGS_LEN 4
+/* enum: No assertions have failed. */
+/*               MC_CMD_GET_ASSERTS_FLAGS_NO_FAILS 0x1 */
+/* enum: A system-level assertion has failed. */
+/*               MC_CMD_GET_ASSERTS_FLAGS_SYS_FAIL 0x2 */
+/* enum: A thread-level assertion has failed. */
+/*               MC_CMD_GET_ASSERTS_FLAGS_THR_FAIL 0x3 */
+/* enum: The system was reset by the watchdog. */
+/*               MC_CMD_GET_ASSERTS_FLAGS_WDOG_FIRED 0x4 */
+/* enum: An illegal address trap stopped the system (huntington and later) */
+/*               MC_CMD_GET_ASSERTS_FLAGS_ADDR_TRAP 0x5 */
+/* Failing PC value */
+#define       MC_CMD_GET_ASSERTS_OUT_V2_SAVED_PC_OFFS_OFST 4
+#define       MC_CMD_GET_ASSERTS_OUT_V2_SAVED_PC_OFFS_LEN 4
+/* Saved GP regs */
+#define       MC_CMD_GET_ASSERTS_OUT_V2_GP_REGS_OFFS_OFST 8
+#define       MC_CMD_GET_ASSERTS_OUT_V2_GP_REGS_OFFS_LEN 4
+#define       MC_CMD_GET_ASSERTS_OUT_V2_GP_REGS_OFFS_NUM 31
+/* enum: A magic value hinting that the value in this register at the time of
+ * the failure has likely been lost.
+ */
+/*               MC_CMD_GET_ASSERTS_REG_NO_DATA 0xda7a1057 */
+/* Failing thread address */
+#define       MC_CMD_GET_ASSERTS_OUT_V2_THREAD_OFFS_OFST 132
+#define       MC_CMD_GET_ASSERTS_OUT_V2_THREAD_OFFS_LEN 4
+#define       MC_CMD_GET_ASSERTS_OUT_V2_RESERVED_OFST 136
+#define       MC_CMD_GET_ASSERTS_OUT_V2_RESERVED_LEN 4
+/* Saved Special Function Registers */
+#define       MC_CMD_GET_ASSERTS_OUT_V2_SF_REGS_OFFS_OFST 136
+#define       MC_CMD_GET_ASSERTS_OUT_V2_SF_REGS_OFFS_LEN 4
+#define       MC_CMD_GET_ASSERTS_OUT_V2_SF_REGS_OFFS_NUM 26
+
+/* MC_CMD_GET_ASSERTS_OUT_V3 msgresponse: Extended response with asserted
+ * firmware version information
+ */
+#define    MC_CMD_GET_ASSERTS_OUT_V3_LEN 360
+/* Assertion status flag. */
+#define       MC_CMD_GET_ASSERTS_OUT_V3_GLOBAL_FLAGS_OFST 0
+#define       MC_CMD_GET_ASSERTS_OUT_V3_GLOBAL_FLAGS_LEN 4
+/* enum: No assertions have failed. */
+/*               MC_CMD_GET_ASSERTS_FLAGS_NO_FAILS 0x1 */
+/* enum: A system-level assertion has failed. */
+/*               MC_CMD_GET_ASSERTS_FLAGS_SYS_FAIL 0x2 */
+/* enum: A thread-level assertion has failed. */
+/*               MC_CMD_GET_ASSERTS_FLAGS_THR_FAIL 0x3 */
+/* enum: The system was reset by the watchdog. */
+/*               MC_CMD_GET_ASSERTS_FLAGS_WDOG_FIRED 0x4 */
+/* enum: An illegal address trap stopped the system (huntington and later) */
+/*               MC_CMD_GET_ASSERTS_FLAGS_ADDR_TRAP 0x5 */
+/* Failing PC value */
+#define       MC_CMD_GET_ASSERTS_OUT_V3_SAVED_PC_OFFS_OFST 4
+#define       MC_CMD_GET_ASSERTS_OUT_V3_SAVED_PC_OFFS_LEN 4
+/* Saved GP regs */
+#define       MC_CMD_GET_ASSERTS_OUT_V3_GP_REGS_OFFS_OFST 8
+#define       MC_CMD_GET_ASSERTS_OUT_V3_GP_REGS_OFFS_LEN 4
+#define       MC_CMD_GET_ASSERTS_OUT_V3_GP_REGS_OFFS_NUM 31
+/* enum: A magic value hinting that the value in this register at the time of
+ * the failure has likely been lost.
+ */
+/*               MC_CMD_GET_ASSERTS_REG_NO_DATA 0xda7a1057 */
+/* Failing thread address */
+#define       MC_CMD_GET_ASSERTS_OUT_V3_THREAD_OFFS_OFST 132
+#define       MC_CMD_GET_ASSERTS_OUT_V3_THREAD_OFFS_LEN 4
+#define       MC_CMD_GET_ASSERTS_OUT_V3_RESERVED_OFST 136
+#define       MC_CMD_GET_ASSERTS_OUT_V3_RESERVED_LEN 4
+/* Saved Special Function Registers */
+#define       MC_CMD_GET_ASSERTS_OUT_V3_SF_REGS_OFFS_OFST 136
+#define       MC_CMD_GET_ASSERTS_OUT_V3_SF_REGS_OFFS_LEN 4
+#define       MC_CMD_GET_ASSERTS_OUT_V3_SF_REGS_OFFS_NUM 26
+/* MC firmware unique build ID (as binary SHA-1 value) */
+#define       MC_CMD_GET_ASSERTS_OUT_V3_MC_FW_BUILD_ID_OFST 240
+#define       MC_CMD_GET_ASSERTS_OUT_V3_MC_FW_BUILD_ID_LEN 20
+/* MC firmware build date (as Unix timestamp) */
+#define       MC_CMD_GET_ASSERTS_OUT_V3_MC_FW_BUILD_TIMESTAMP_OFST 260
+#define       MC_CMD_GET_ASSERTS_OUT_V3_MC_FW_BUILD_TIMESTAMP_LEN 8
+#define       MC_CMD_GET_ASSERTS_OUT_V3_MC_FW_BUILD_TIMESTAMP_LO_OFST 260
+#define       MC_CMD_GET_ASSERTS_OUT_V3_MC_FW_BUILD_TIMESTAMP_HI_OFST 264
+/* MC firmware version number */
+#define       MC_CMD_GET_ASSERTS_OUT_V3_MC_FW_VERSION_OFST 268
+#define       MC_CMD_GET_ASSERTS_OUT_V3_MC_FW_VERSION_LEN 8
+#define       MC_CMD_GET_ASSERTS_OUT_V3_MC_FW_VERSION_LO_OFST 268
+#define       MC_CMD_GET_ASSERTS_OUT_V3_MC_FW_VERSION_HI_OFST 272
+/* MC firmware security level */
+#define       MC_CMD_GET_ASSERTS_OUT_V3_MC_FW_SECURITY_LEVEL_OFST 276
+#define       MC_CMD_GET_ASSERTS_OUT_V3_MC_FW_SECURITY_LEVEL_LEN 4
+/* MC firmware extra version info (as null-terminated US-ASCII string) */
+#define       MC_CMD_GET_ASSERTS_OUT_V3_MC_FW_EXTRA_INFO_OFST 280
+#define       MC_CMD_GET_ASSERTS_OUT_V3_MC_FW_EXTRA_INFO_LEN 16
+/* MC firmware build name (as null-terminated US-ASCII string) */
+#define       MC_CMD_GET_ASSERTS_OUT_V3_MC_FW_BUILD_NAME_OFST 296
+#define       MC_CMD_GET_ASSERTS_OUT_V3_MC_FW_BUILD_NAME_LEN 64
+
 
 /***********************************/
 /* MC_CMD_LOG_CTRL
@@ -1218,6 +1505,7 @@
  * sensor notifications and MCDI completions
  */
 #define MC_CMD_LOG_CTRL 0x7
+#undef MC_CMD_0x7_PRIVILEGE_CTG
 
 #define MC_CMD_0x7_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -1240,9 +1528,10 @@
 
 /***********************************/
 /* MC_CMD_GET_VERSION
- * Get version information about the MC firmware.
+ * Get version information about adapter components.
  */
 #define MC_CMD_GET_VERSION 0x8
+#undef MC_CMD_0x8_PRIVILEGE_CTG
 
 #define MC_CMD_0x8_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -1303,12 +1592,107 @@
 #define       MC_CMD_GET_VERSION_EXT_OUT_EXTRA_OFST 32
 #define       MC_CMD_GET_VERSION_EXT_OUT_EXTRA_LEN 16
 
+/* MC_CMD_GET_VERSION_V2_OUT msgresponse: Extended response providing version
+ * information for all adapter components. For Riverhead based designs, base MC
+ * firmware version fields refer to NMC firmware, while CMC firmware data is in
+ * dedicated CMC fields. Flags indicate which data is present in the response
+ * (depending on which components exist on a particular adapter)
+ */
+#define    MC_CMD_GET_VERSION_V2_OUT_LEN 304
+/*            MC_CMD_GET_VERSION_OUT_FIRMWARE_OFST 0 */
+/*            MC_CMD_GET_VERSION_OUT_FIRMWARE_LEN 4 */
+/*            Enum values, see field(s): */
+/*               MC_CMD_GET_VERSION_V0_OUT/MC_CMD_GET_VERSION_OUT_FIRMWARE */
+#define       MC_CMD_GET_VERSION_V2_OUT_PCOL_OFST 4
+#define       MC_CMD_GET_VERSION_V2_OUT_PCOL_LEN 4
+/* 128bit mask of functions supported by the current firmware */
+#define       MC_CMD_GET_VERSION_V2_OUT_SUPPORTED_FUNCS_OFST 8
+#define       MC_CMD_GET_VERSION_V2_OUT_SUPPORTED_FUNCS_LEN 16
+#define       MC_CMD_GET_VERSION_V2_OUT_VERSION_OFST 24
+#define       MC_CMD_GET_VERSION_V2_OUT_VERSION_LEN 8
+#define       MC_CMD_GET_VERSION_V2_OUT_VERSION_LO_OFST 24
+#define       MC_CMD_GET_VERSION_V2_OUT_VERSION_HI_OFST 28
+/* extra info */
+#define       MC_CMD_GET_VERSION_V2_OUT_EXTRA_OFST 32
+#define       MC_CMD_GET_VERSION_V2_OUT_EXTRA_LEN 16
+/* Flags indicating which extended fields are valid */
+#define       MC_CMD_GET_VERSION_V2_OUT_FLAGS_OFST 48
+#define       MC_CMD_GET_VERSION_V2_OUT_FLAGS_LEN 4
+#define        MC_CMD_GET_VERSION_V2_OUT_MCFW_EXT_INFO_PRESENT_OFST 48
+#define        MC_CMD_GET_VERSION_V2_OUT_MCFW_EXT_INFO_PRESENT_LBN 0
+#define        MC_CMD_GET_VERSION_V2_OUT_MCFW_EXT_INFO_PRESENT_WIDTH 1
+#define        MC_CMD_GET_VERSION_V2_OUT_SUCFW_EXT_INFO_PRESENT_OFST 48
+#define        MC_CMD_GET_VERSION_V2_OUT_SUCFW_EXT_INFO_PRESENT_LBN 1
+#define        MC_CMD_GET_VERSION_V2_OUT_SUCFW_EXT_INFO_PRESENT_WIDTH 1
+#define        MC_CMD_GET_VERSION_V2_OUT_CMC_EXT_INFO_PRESENT_OFST 48
+#define        MC_CMD_GET_VERSION_V2_OUT_CMC_EXT_INFO_PRESENT_LBN 2
+#define        MC_CMD_GET_VERSION_V2_OUT_CMC_EXT_INFO_PRESENT_WIDTH 1
+#define        MC_CMD_GET_VERSION_V2_OUT_FPGA_EXT_INFO_PRESENT_OFST 48
+#define        MC_CMD_GET_VERSION_V2_OUT_FPGA_EXT_INFO_PRESENT_LBN 3
+#define        MC_CMD_GET_VERSION_V2_OUT_FPGA_EXT_INFO_PRESENT_WIDTH 1
+#define        MC_CMD_GET_VERSION_V2_OUT_BOARD_EXT_INFO_PRESENT_OFST 48
+#define        MC_CMD_GET_VERSION_V2_OUT_BOARD_EXT_INFO_PRESENT_LBN 4
+#define        MC_CMD_GET_VERSION_V2_OUT_BOARD_EXT_INFO_PRESENT_WIDTH 1
+/* MC firmware unique build ID (as binary SHA-1 value) */
+#define       MC_CMD_GET_VERSION_V2_OUT_MCFW_BUILD_ID_OFST 52
+#define       MC_CMD_GET_VERSION_V2_OUT_MCFW_BUILD_ID_LEN 20
+/* MC firmware security level */
+#define       MC_CMD_GET_VERSION_V2_OUT_MCFW_SECURITY_LEVEL_OFST 72
+#define       MC_CMD_GET_VERSION_V2_OUT_MCFW_SECURITY_LEVEL_LEN 4
+/* MC firmware build name (as null-terminated US-ASCII string) */
+#define       MC_CMD_GET_VERSION_V2_OUT_MCFW_BUILD_NAME_OFST 76
+#define       MC_CMD_GET_VERSION_V2_OUT_MCFW_BUILD_NAME_LEN 64
+/* The SUC firmware version as four numbers - a.b.c.d */
+#define       MC_CMD_GET_VERSION_V2_OUT_SUCFW_VERSION_OFST 140
+#define       MC_CMD_GET_VERSION_V2_OUT_SUCFW_VERSION_LEN 4
+#define       MC_CMD_GET_VERSION_V2_OUT_SUCFW_VERSION_NUM 4
+/* SUC firmware build date (as 64-bit Unix timestamp) */
+#define       MC_CMD_GET_VERSION_V2_OUT_SUCFW_BUILD_DATE_OFST 156
+#define       MC_CMD_GET_VERSION_V2_OUT_SUCFW_BUILD_DATE_LEN 8
+#define       MC_CMD_GET_VERSION_V2_OUT_SUCFW_BUILD_DATE_LO_OFST 156
+#define       MC_CMD_GET_VERSION_V2_OUT_SUCFW_BUILD_DATE_HI_OFST 160
+/* The ID of the SUC chip. This is specific to the platform but typically
+ * indicates family, memory sizes etc. See SF-116728-SW for further details.
+ */
+#define       MC_CMD_GET_VERSION_V2_OUT_SUCFW_CHIP_ID_OFST 164
+#define       MC_CMD_GET_VERSION_V2_OUT_SUCFW_CHIP_ID_LEN 4
+/* The CMC firmware version as four numbers - a.b.c.d */
+#define       MC_CMD_GET_VERSION_V2_OUT_CMCFW_VERSION_OFST 168
+#define       MC_CMD_GET_VERSION_V2_OUT_CMCFW_VERSION_LEN 4
+#define       MC_CMD_GET_VERSION_V2_OUT_CMCFW_VERSION_NUM 4
+/* CMC firmware build date (as 64-bit Unix timestamp) */
+#define       MC_CMD_GET_VERSION_V2_OUT_CMCFW_BUILD_DATE_OFST 184
+#define       MC_CMD_GET_VERSION_V2_OUT_CMCFW_BUILD_DATE_LEN 8
+#define       MC_CMD_GET_VERSION_V2_OUT_CMCFW_BUILD_DATE_LO_OFST 184
+#define       MC_CMD_GET_VERSION_V2_OUT_CMCFW_BUILD_DATE_HI_OFST 188
+/* FPGA version as three numbers. On Riverhead based systems this field uses
+ * the same encoding as hardware version ID registers (MC_FPGA_BUILD_HWRD_REG):
+ * FPGA_VERSION[0]: x => Image H{x} FPGA_VERSION[1]: Revision letter (0 => A, 1
+ * => B, ...) FPGA_VERSION[2]: Sub-revision number
+ */
+#define       MC_CMD_GET_VERSION_V2_OUT_FPGA_VERSION_OFST 192
+#define       MC_CMD_GET_VERSION_V2_OUT_FPGA_VERSION_LEN 4
+#define       MC_CMD_GET_VERSION_V2_OUT_FPGA_VERSION_NUM 3
+/* Extra FPGA revision information (as null-terminated US-ASCII string) */
+#define       MC_CMD_GET_VERSION_V2_OUT_FPGA_EXTRA_OFST 204
+#define       MC_CMD_GET_VERSION_V2_OUT_FPGA_EXTRA_LEN 16
+/* Board name / adapter model (as null-terminated US-ASCII string) */
+#define       MC_CMD_GET_VERSION_V2_OUT_BOARD_NAME_OFST 220
+#define       MC_CMD_GET_VERSION_V2_OUT_BOARD_NAME_LEN 16
+/* Board revision number */
+#define       MC_CMD_GET_VERSION_V2_OUT_BOARD_REVISION_OFST 236
+#define       MC_CMD_GET_VERSION_V2_OUT_BOARD_REVISION_LEN 4
+/* Board serial number (as null-terminated US-ASCII string) */
+#define       MC_CMD_GET_VERSION_V2_OUT_BOARD_SERIAL_OFST 240
+#define       MC_CMD_GET_VERSION_V2_OUT_BOARD_SERIAL_LEN 64
+
 
 /***********************************/
 /* MC_CMD_PTP
  * Perform PTP operation
  */
 #define MC_CMD_PTP 0xb
+#undef MC_CMD_0xb_PRIVILEGE_CTG
 
 #define MC_CMD_0xb_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -1434,7 +1818,9 @@
 /* MC_CMD_PTP_IN_TRANSMIT msgrequest */
 #define    MC_CMD_PTP_IN_TRANSMIT_LENMIN 13
 #define    MC_CMD_PTP_IN_TRANSMIT_LENMAX 252
+#define    MC_CMD_PTP_IN_TRANSMIT_LENMAX_MCDI2 1020
 #define    MC_CMD_PTP_IN_TRANSMIT_LEN(num) (12+1*(num))
+#define    MC_CMD_PTP_IN_TRANSMIT_PACKET_NUM(len) (((len)-12)/1)
 /*            MC_CMD_PTP_IN_CMD_OFST 0 */
 /*            MC_CMD_PTP_IN_CMD_LEN 4 */
 /*            MC_CMD_PTP_IN_PERIPH_ID_OFST 4 */
@@ -1447,6 +1833,7 @@
 #define       MC_CMD_PTP_IN_TRANSMIT_PACKET_LEN 1
 #define       MC_CMD_PTP_IN_TRANSMIT_PACKET_MINNUM 1
 #define       MC_CMD_PTP_IN_TRANSMIT_PACKET_MAXNUM 240
+#define       MC_CMD_PTP_IN_TRANSMIT_PACKET_MAXNUM_MCDI2 1008
 
 /* MC_CMD_PTP_IN_READ_NIC_TIME msgrequest */
 #define    MC_CMD_PTP_IN_READ_NIC_TIME_LEN 8
@@ -1599,7 +1986,9 @@
 /* MC_CMD_PTP_IN_FPGAWRITE msgrequest */
 #define    MC_CMD_PTP_IN_FPGAWRITE_LENMIN 13
 #define    MC_CMD_PTP_IN_FPGAWRITE_LENMAX 252
+#define    MC_CMD_PTP_IN_FPGAWRITE_LENMAX_MCDI2 1020
 #define    MC_CMD_PTP_IN_FPGAWRITE_LEN(num) (12+1*(num))
+#define    MC_CMD_PTP_IN_FPGAWRITE_BUFFER_NUM(len) (((len)-12)/1)
 /*            MC_CMD_PTP_IN_CMD_OFST 0 */
 /*            MC_CMD_PTP_IN_CMD_LEN 4 */
 /*            MC_CMD_PTP_IN_PERIPH_ID_OFST 4 */
@@ -1610,6 +1999,7 @@
 #define       MC_CMD_PTP_IN_FPGAWRITE_BUFFER_LEN 1
 #define       MC_CMD_PTP_IN_FPGAWRITE_BUFFER_MINNUM 1
 #define       MC_CMD_PTP_IN_FPGAWRITE_BUFFER_MAXNUM 240
+#define       MC_CMD_PTP_IN_FPGAWRITE_BUFFER_MAXNUM_MCDI2 1008
 
 /* MC_CMD_PTP_IN_CLOCK_OFFSET_ADJUST msgrequest */
 #define    MC_CMD_PTP_IN_CLOCK_OFFSET_ADJUST_LEN 16
@@ -1774,8 +2164,10 @@
 /* Original field containing queue ID. Now extended to include flags. */
 #define       MC_CMD_PTP_IN_TIME_EVENT_SUBSCRIBE_QUEUE_OFST 8
 #define       MC_CMD_PTP_IN_TIME_EVENT_SUBSCRIBE_QUEUE_LEN 4
+#define        MC_CMD_PTP_IN_TIME_EVENT_SUBSCRIBE_QUEUE_ID_OFST 8
 #define        MC_CMD_PTP_IN_TIME_EVENT_SUBSCRIBE_QUEUE_ID_LBN 0
 #define        MC_CMD_PTP_IN_TIME_EVENT_SUBSCRIBE_QUEUE_ID_WIDTH 16
+#define        MC_CMD_PTP_IN_TIME_EVENT_SUBSCRIBE_REPORT_SYNC_STATUS_OFST 8
 #define        MC_CMD_PTP_IN_TIME_EVENT_SUBSCRIBE_REPORT_SYNC_STATUS_LBN 31
 #define        MC_CMD_PTP_IN_TIME_EVENT_SUBSCRIBE_REPORT_SYNC_STATUS_WIDTH 1
 
@@ -1940,12 +2332,15 @@
 /* MC_CMD_PTP_OUT_SYNCHRONIZE msgresponse */
 #define    MC_CMD_PTP_OUT_SYNCHRONIZE_LENMIN 20
 #define    MC_CMD_PTP_OUT_SYNCHRONIZE_LENMAX 240
+#define    MC_CMD_PTP_OUT_SYNCHRONIZE_LENMAX_MCDI2 1020
 #define    MC_CMD_PTP_OUT_SYNCHRONIZE_LEN(num) (0+20*(num))
+#define    MC_CMD_PTP_OUT_SYNCHRONIZE_TIMESET_NUM(len) (((len)-0)/20)
 /* A set of host and NIC times */
 #define       MC_CMD_PTP_OUT_SYNCHRONIZE_TIMESET_OFST 0
 #define       MC_CMD_PTP_OUT_SYNCHRONIZE_TIMESET_LEN 20
 #define       MC_CMD_PTP_OUT_SYNCHRONIZE_TIMESET_MINNUM 1
 #define       MC_CMD_PTP_OUT_SYNCHRONIZE_TIMESET_MAXNUM 12
+#define       MC_CMD_PTP_OUT_SYNCHRONIZE_TIMESET_MAXNUM_MCDI2 51
 /* Host time immediately before NIC's hardware clock read */
 #define       MC_CMD_PTP_OUT_SYNCHRONIZE_HOSTSTART_OFST 0
 #define       MC_CMD_PTP_OUT_SYNCHRONIZE_HOSTSTART_LEN 4
@@ -2022,11 +2417,14 @@
 /* MC_CMD_PTP_OUT_FPGAREAD msgresponse */
 #define    MC_CMD_PTP_OUT_FPGAREAD_LENMIN 1
 #define    MC_CMD_PTP_OUT_FPGAREAD_LENMAX 252
+#define    MC_CMD_PTP_OUT_FPGAREAD_LENMAX_MCDI2 1020
 #define    MC_CMD_PTP_OUT_FPGAREAD_LEN(num) (0+1*(num))
+#define    MC_CMD_PTP_OUT_FPGAREAD_BUFFER_NUM(len) (((len)-0)/1)
 #define       MC_CMD_PTP_OUT_FPGAREAD_BUFFER_OFST 0
 #define       MC_CMD_PTP_OUT_FPGAREAD_BUFFER_LEN 1
 #define       MC_CMD_PTP_OUT_FPGAREAD_BUFFER_MINNUM 1
 #define       MC_CMD_PTP_OUT_FPGAREAD_BUFFER_MAXNUM 252
+#define       MC_CMD_PTP_OUT_FPGAREAD_BUFFER_MAXNUM_MCDI2 1020
 
 /* MC_CMD_PTP_OUT_GET_TIME_FORMAT msgresponse */
 #define    MC_CMD_PTP_OUT_GET_TIME_FORMAT_LEN 4
@@ -2075,12 +2473,16 @@
 /* Various PTP capabilities */
 #define       MC_CMD_PTP_OUT_GET_ATTRIBUTES_CAPABILITIES_OFST 8
 #define       MC_CMD_PTP_OUT_GET_ATTRIBUTES_CAPABILITIES_LEN 4
+#define        MC_CMD_PTP_OUT_GET_ATTRIBUTES_REPORT_SYNC_STATUS_OFST 8
 #define        MC_CMD_PTP_OUT_GET_ATTRIBUTES_REPORT_SYNC_STATUS_LBN 0
 #define        MC_CMD_PTP_OUT_GET_ATTRIBUTES_REPORT_SYNC_STATUS_WIDTH 1
+#define        MC_CMD_PTP_OUT_GET_ATTRIBUTES_RX_TSTAMP_OOB_OFST 8
 #define        MC_CMD_PTP_OUT_GET_ATTRIBUTES_RX_TSTAMP_OOB_LBN 1
 #define        MC_CMD_PTP_OUT_GET_ATTRIBUTES_RX_TSTAMP_OOB_WIDTH 1
+#define        MC_CMD_PTP_OUT_GET_ATTRIBUTES_64BIT_SECONDS_OFST 8
 #define        MC_CMD_PTP_OUT_GET_ATTRIBUTES_64BIT_SECONDS_LBN 2
 #define        MC_CMD_PTP_OUT_GET_ATTRIBUTES_64BIT_SECONDS_WIDTH 1
+#define        MC_CMD_PTP_OUT_GET_ATTRIBUTES_FP44_FREQ_ADJ_OFST 8
 #define        MC_CMD_PTP_OUT_GET_ATTRIBUTES_FP44_FREQ_ADJ_LBN 3
 #define        MC_CMD_PTP_OUT_GET_ATTRIBUTES_FP44_FREQ_ADJ_WIDTH 1
 #define       MC_CMD_PTP_OUT_GET_ATTRIBUTES_RESERVED0_OFST 12
@@ -2143,6 +2545,7 @@
  * Read 32bit words from the indirect memory map.
  */
 #define MC_CMD_CSR_READ32 0xc
+#undef MC_CMD_0xc_PRIVILEGE_CTG
 
 #define MC_CMD_0xc_PRIVILEGE_CTG SRIOV_CTG_INSECURE
 
@@ -2159,12 +2562,15 @@
 /* MC_CMD_CSR_READ32_OUT msgresponse */
 #define    MC_CMD_CSR_READ32_OUT_LENMIN 4
 #define    MC_CMD_CSR_READ32_OUT_LENMAX 252
+#define    MC_CMD_CSR_READ32_OUT_LENMAX_MCDI2 1020
 #define    MC_CMD_CSR_READ32_OUT_LEN(num) (0+4*(num))
+#define    MC_CMD_CSR_READ32_OUT_BUFFER_NUM(len) (((len)-0)/4)
 /* The last dword is the status, not a value read */
 #define       MC_CMD_CSR_READ32_OUT_BUFFER_OFST 0
 #define       MC_CMD_CSR_READ32_OUT_BUFFER_LEN 4
 #define       MC_CMD_CSR_READ32_OUT_BUFFER_MINNUM 1
 #define       MC_CMD_CSR_READ32_OUT_BUFFER_MAXNUM 63
+#define       MC_CMD_CSR_READ32_OUT_BUFFER_MAXNUM_MCDI2 255
 
 
 /***********************************/
@@ -2172,13 +2578,16 @@
  * Write 32bit dwords to the indirect memory map.
  */
 #define MC_CMD_CSR_WRITE32 0xd
+#undef MC_CMD_0xd_PRIVILEGE_CTG
 
 #define MC_CMD_0xd_PRIVILEGE_CTG SRIOV_CTG_INSECURE
 
 /* MC_CMD_CSR_WRITE32_IN msgrequest */
 #define    MC_CMD_CSR_WRITE32_IN_LENMIN 12
 #define    MC_CMD_CSR_WRITE32_IN_LENMAX 252
+#define    MC_CMD_CSR_WRITE32_IN_LENMAX_MCDI2 1020
 #define    MC_CMD_CSR_WRITE32_IN_LEN(num) (8+4*(num))
+#define    MC_CMD_CSR_WRITE32_IN_BUFFER_NUM(len) (((len)-8)/4)
 /* Address */
 #define       MC_CMD_CSR_WRITE32_IN_ADDR_OFST 0
 #define       MC_CMD_CSR_WRITE32_IN_ADDR_LEN 4
@@ -2188,6 +2597,7 @@
 #define       MC_CMD_CSR_WRITE32_IN_BUFFER_LEN 4
 #define       MC_CMD_CSR_WRITE32_IN_BUFFER_MINNUM 1
 #define       MC_CMD_CSR_WRITE32_IN_BUFFER_MAXNUM 61
+#define       MC_CMD_CSR_WRITE32_IN_BUFFER_MAXNUM_MCDI2 253
 
 /* MC_CMD_CSR_WRITE32_OUT msgresponse */
 #define    MC_CMD_CSR_WRITE32_OUT_LEN 4
@@ -2201,6 +2611,7 @@
  * MCDI command to avoid creating too many MCDI commands.
  */
 #define MC_CMD_HP 0x54
+#undef MC_CMD_0x54_PRIVILEGE_CTG
 
 #define MC_CMD_0x54_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
@@ -2247,6 +2658,7 @@
  * Get stack information.
  */
 #define MC_CMD_STACKINFO 0xf
+#undef MC_CMD_0xf_PRIVILEGE_CTG
 
 #define MC_CMD_0xf_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
@@ -2256,12 +2668,15 @@
 /* MC_CMD_STACKINFO_OUT msgresponse */
 #define    MC_CMD_STACKINFO_OUT_LENMIN 12
 #define    MC_CMD_STACKINFO_OUT_LENMAX 252
+#define    MC_CMD_STACKINFO_OUT_LENMAX_MCDI2 1020
 #define    MC_CMD_STACKINFO_OUT_LEN(num) (0+12*(num))
+#define    MC_CMD_STACKINFO_OUT_THREAD_INFO_NUM(len) (((len)-0)/12)
 /* (thread ptr, stack size, free space) for each thread in system */
 #define       MC_CMD_STACKINFO_OUT_THREAD_INFO_OFST 0
 #define       MC_CMD_STACKINFO_OUT_THREAD_INFO_LEN 12
 #define       MC_CMD_STACKINFO_OUT_THREAD_INFO_MINNUM 1
 #define       MC_CMD_STACKINFO_OUT_THREAD_INFO_MAXNUM 21
+#define       MC_CMD_STACKINFO_OUT_THREAD_INFO_MAXNUM_MCDI2 85
 
 
 /***********************************/
@@ -2269,6 +2684,7 @@
  * MDIO register read.
  */
 #define MC_CMD_MDIO_READ 0x10
+#undef MC_CMD_0x10_PRIVILEGE_CTG
 
 #define MC_CMD_0x10_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -2316,6 +2732,7 @@
  * MDIO register write.
  */
 #define MC_CMD_MDIO_WRITE 0x11
+#undef MC_CMD_0x11_PRIVILEGE_CTG
 
 #define MC_CMD_0x11_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
@@ -2363,13 +2780,16 @@
  * Write DBI register(s).
  */
 #define MC_CMD_DBI_WRITE 0x12
+#undef MC_CMD_0x12_PRIVILEGE_CTG
 
 #define MC_CMD_0x12_PRIVILEGE_CTG SRIOV_CTG_INSECURE
 
 /* MC_CMD_DBI_WRITE_IN msgrequest */
 #define    MC_CMD_DBI_WRITE_IN_LENMIN 12
 #define    MC_CMD_DBI_WRITE_IN_LENMAX 252
+#define    MC_CMD_DBI_WRITE_IN_LENMAX_MCDI2 1020
 #define    MC_CMD_DBI_WRITE_IN_LEN(num) (0+12*(num))
+#define    MC_CMD_DBI_WRITE_IN_DBIWROP_NUM(len) (((len)-0)/12)
 /* Each write op consists of an address (offset 0), byte enable/VF/CS2 (offset
  * 32) and value (offset 64). See MC_CMD_DBIWROP_TYPEDEF.
  */
@@ -2377,6 +2797,7 @@
 #define       MC_CMD_DBI_WRITE_IN_DBIWROP_LEN 12
 #define       MC_CMD_DBI_WRITE_IN_DBIWROP_MINNUM 1
 #define       MC_CMD_DBI_WRITE_IN_DBIWROP_MAXNUM 21
+#define       MC_CMD_DBI_WRITE_IN_DBIWROP_MAXNUM_MCDI2 85
 
 /* MC_CMD_DBI_WRITE_OUT msgresponse */
 #define    MC_CMD_DBI_WRITE_OUT_LEN 0
@@ -2389,10 +2810,13 @@
 #define       MC_CMD_DBIWROP_TYPEDEF_ADDRESS_WIDTH 32
 #define       MC_CMD_DBIWROP_TYPEDEF_PARMS_OFST 4
 #define       MC_CMD_DBIWROP_TYPEDEF_PARMS_LEN 4
+#define        MC_CMD_DBIWROP_TYPEDEF_VF_NUM_OFST 4
 #define        MC_CMD_DBIWROP_TYPEDEF_VF_NUM_LBN 16
 #define        MC_CMD_DBIWROP_TYPEDEF_VF_NUM_WIDTH 16
+#define        MC_CMD_DBIWROP_TYPEDEF_VF_ACTIVE_OFST 4
 #define        MC_CMD_DBIWROP_TYPEDEF_VF_ACTIVE_LBN 15
 #define        MC_CMD_DBIWROP_TYPEDEF_VF_ACTIVE_WIDTH 1
+#define        MC_CMD_DBIWROP_TYPEDEF_CS2_OFST 4
 #define        MC_CMD_DBIWROP_TYPEDEF_CS2_LBN 14
 #define        MC_CMD_DBIWROP_TYPEDEF_CS2_WIDTH 1
 #define       MC_CMD_DBIWROP_TYPEDEF_PARMS_LBN 32
@@ -2526,6 +2950,7 @@
  * Returns the MC firmware configuration structure.
  */
 #define MC_CMD_GET_BOARD_CFG 0x18
+#undef MC_CMD_0x18_PRIVILEGE_CTG
 
 #define MC_CMD_0x18_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -2535,7 +2960,9 @@
 /* MC_CMD_GET_BOARD_CFG_OUT msgresponse */
 #define    MC_CMD_GET_BOARD_CFG_OUT_LENMIN 96
 #define    MC_CMD_GET_BOARD_CFG_OUT_LENMAX 136
+#define    MC_CMD_GET_BOARD_CFG_OUT_LENMAX_MCDI2 136
 #define    MC_CMD_GET_BOARD_CFG_OUT_LEN(num) (72+2*(num))
+#define    MC_CMD_GET_BOARD_CFG_OUT_FW_SUBTYPE_LIST_NUM(len) (((len)-72)/2)
 #define       MC_CMD_GET_BOARD_CFG_OUT_BOARD_TYPE_OFST 0
 #define       MC_CMD_GET_BOARD_CFG_OUT_BOARD_TYPE_LEN 4
 #define       MC_CMD_GET_BOARD_CFG_OUT_BOARD_NAME_OFST 4
@@ -2590,6 +3017,7 @@
 #define       MC_CMD_GET_BOARD_CFG_OUT_FW_SUBTYPE_LIST_LEN 2
 #define       MC_CMD_GET_BOARD_CFG_OUT_FW_SUBTYPE_LIST_MINNUM 12
 #define       MC_CMD_GET_BOARD_CFG_OUT_FW_SUBTYPE_LIST_MAXNUM 32
+#define       MC_CMD_GET_BOARD_CFG_OUT_FW_SUBTYPE_LIST_MAXNUM_MCDI2 32
 
 
 /***********************************/
@@ -2597,13 +3025,16 @@
  * Read DBI register(s) -- extended functionality
  */
 #define MC_CMD_DBI_READX 0x19
+#undef MC_CMD_0x19_PRIVILEGE_CTG
 
 #define MC_CMD_0x19_PRIVILEGE_CTG SRIOV_CTG_INSECURE
 
 /* MC_CMD_DBI_READX_IN msgrequest */
 #define    MC_CMD_DBI_READX_IN_LENMIN 8
 #define    MC_CMD_DBI_READX_IN_LENMAX 248
+#define    MC_CMD_DBI_READX_IN_LENMAX_MCDI2 1016
 #define    MC_CMD_DBI_READX_IN_LEN(num) (0+8*(num))
+#define    MC_CMD_DBI_READX_IN_DBIRDOP_NUM(len) (((len)-0)/8)
 /* Each Read op consists of an address (offset 0), VF/CS2) */
 #define       MC_CMD_DBI_READX_IN_DBIRDOP_OFST 0
 #define       MC_CMD_DBI_READX_IN_DBIRDOP_LEN 8
@@ -2611,16 +3042,20 @@
 #define       MC_CMD_DBI_READX_IN_DBIRDOP_HI_OFST 4
 #define       MC_CMD_DBI_READX_IN_DBIRDOP_MINNUM 1
 #define       MC_CMD_DBI_READX_IN_DBIRDOP_MAXNUM 31
+#define       MC_CMD_DBI_READX_IN_DBIRDOP_MAXNUM_MCDI2 127
 
 /* MC_CMD_DBI_READX_OUT msgresponse */
 #define    MC_CMD_DBI_READX_OUT_LENMIN 4
 #define    MC_CMD_DBI_READX_OUT_LENMAX 252
+#define    MC_CMD_DBI_READX_OUT_LENMAX_MCDI2 1020
 #define    MC_CMD_DBI_READX_OUT_LEN(num) (0+4*(num))
+#define    MC_CMD_DBI_READX_OUT_VALUE_NUM(len) (((len)-0)/4)
 /* Value */
 #define       MC_CMD_DBI_READX_OUT_VALUE_OFST 0
 #define       MC_CMD_DBI_READX_OUT_VALUE_LEN 4
 #define       MC_CMD_DBI_READX_OUT_VALUE_MINNUM 1
 #define       MC_CMD_DBI_READX_OUT_VALUE_MAXNUM 63
+#define       MC_CMD_DBI_READX_OUT_VALUE_MAXNUM_MCDI2 255
 
 /* MC_CMD_DBIRDOP_TYPEDEF structuredef */
 #define    MC_CMD_DBIRDOP_TYPEDEF_LEN 8
@@ -2630,10 +3065,13 @@
 #define       MC_CMD_DBIRDOP_TYPEDEF_ADDRESS_WIDTH 32
 #define       MC_CMD_DBIRDOP_TYPEDEF_PARMS_OFST 4
 #define       MC_CMD_DBIRDOP_TYPEDEF_PARMS_LEN 4
+#define        MC_CMD_DBIRDOP_TYPEDEF_VF_NUM_OFST 4
 #define        MC_CMD_DBIRDOP_TYPEDEF_VF_NUM_LBN 16
 #define        MC_CMD_DBIRDOP_TYPEDEF_VF_NUM_WIDTH 16
+#define        MC_CMD_DBIRDOP_TYPEDEF_VF_ACTIVE_OFST 4
 #define        MC_CMD_DBIRDOP_TYPEDEF_VF_ACTIVE_LBN 15
 #define        MC_CMD_DBIRDOP_TYPEDEF_VF_ACTIVE_WIDTH 1
+#define        MC_CMD_DBIRDOP_TYPEDEF_CS2_OFST 4
 #define        MC_CMD_DBIRDOP_TYPEDEF_CS2_LBN 14
 #define        MC_CMD_DBIRDOP_TYPEDEF_CS2_WIDTH 1
 #define       MC_CMD_DBIRDOP_TYPEDEF_PARMS_LBN 32
@@ -2645,6 +3083,7 @@
  * Set the 16byte seed for the MC pseudo-random generator.
  */
 #define MC_CMD_SET_RAND_SEED 0x1a
+#undef MC_CMD_0x1a_PRIVILEGE_CTG
 
 #define MC_CMD_0x1a_PRIVILEGE_CTG SRIOV_CTG_INSECURE
 
@@ -2670,12 +3109,15 @@
 /* MC_CMD_LTSSM_HIST_OUT msgresponse */
 #define    MC_CMD_LTSSM_HIST_OUT_LENMIN 0
 #define    MC_CMD_LTSSM_HIST_OUT_LENMAX 252
+#define    MC_CMD_LTSSM_HIST_OUT_LENMAX_MCDI2 1020
 #define    MC_CMD_LTSSM_HIST_OUT_LEN(num) (0+4*(num))
+#define    MC_CMD_LTSSM_HIST_OUT_DATA_NUM(len) (((len)-0)/4)
 /* variable number of LTSSM values, as bytes. The history is read-to-clear. */
 #define       MC_CMD_LTSSM_HIST_OUT_DATA_OFST 0
 #define       MC_CMD_LTSSM_HIST_OUT_DATA_LEN 4
 #define       MC_CMD_LTSSM_HIST_OUT_DATA_MINNUM 0
 #define       MC_CMD_LTSSM_HIST_OUT_DATA_MAXNUM 63
+#define       MC_CMD_LTSSM_HIST_OUT_DATA_MAXNUM_MCDI2 255
 
 
 /***********************************/
@@ -2688,6 +3130,7 @@
  * platforms.
  */
 #define MC_CMD_DRV_ATTACH 0x1c
+#undef MC_CMD_0x1c_PRIVILEGE_CTG
 
 #define MC_CMD_0x1c_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -2696,18 +3139,33 @@
 /* new state to set if UPDATE=1 */
 #define       MC_CMD_DRV_ATTACH_IN_NEW_STATE_OFST 0
 #define       MC_CMD_DRV_ATTACH_IN_NEW_STATE_LEN 4
+#define        MC_CMD_DRV_ATTACH_OFST 0
 #define        MC_CMD_DRV_ATTACH_LBN 0
 #define        MC_CMD_DRV_ATTACH_WIDTH 1
+#define        MC_CMD_DRV_ATTACH_IN_ATTACH_OFST 0
 #define        MC_CMD_DRV_ATTACH_IN_ATTACH_LBN 0
 #define        MC_CMD_DRV_ATTACH_IN_ATTACH_WIDTH 1
+#define        MC_CMD_DRV_PREBOOT_OFST 0
 #define        MC_CMD_DRV_PREBOOT_LBN 1
 #define        MC_CMD_DRV_PREBOOT_WIDTH 1
+#define        MC_CMD_DRV_ATTACH_IN_PREBOOT_OFST 0
 #define        MC_CMD_DRV_ATTACH_IN_PREBOOT_LBN 1
 #define        MC_CMD_DRV_ATTACH_IN_PREBOOT_WIDTH 1
+#define        MC_CMD_DRV_ATTACH_IN_SUBVARIANT_AWARE_OFST 0
 #define        MC_CMD_DRV_ATTACH_IN_SUBVARIANT_AWARE_LBN 2
 #define        MC_CMD_DRV_ATTACH_IN_SUBVARIANT_AWARE_WIDTH 1
+#define        MC_CMD_DRV_ATTACH_IN_WANT_VI_SPREADING_OFST 0
 #define        MC_CMD_DRV_ATTACH_IN_WANT_VI_SPREADING_LBN 3
 #define        MC_CMD_DRV_ATTACH_IN_WANT_VI_SPREADING_WIDTH 1
+#define        MC_CMD_DRV_ATTACH_IN_WANT_V2_LINKCHANGES_OFST 0
+#define        MC_CMD_DRV_ATTACH_IN_WANT_V2_LINKCHANGES_LBN 4
+#define        MC_CMD_DRV_ATTACH_IN_WANT_V2_LINKCHANGES_WIDTH 1
+#define        MC_CMD_DRV_ATTACH_IN_WANT_RX_VI_SPREADING_INHIBIT_OFST 0
+#define        MC_CMD_DRV_ATTACH_IN_WANT_RX_VI_SPREADING_INHIBIT_LBN 5
+#define        MC_CMD_DRV_ATTACH_IN_WANT_RX_VI_SPREADING_INHIBIT_WIDTH 1
+#define        MC_CMD_DRV_ATTACH_IN_WANT_TX_ONLY_SPREADING_OFST 0
+#define        MC_CMD_DRV_ATTACH_IN_WANT_TX_ONLY_SPREADING_LBN 5
+#define        MC_CMD_DRV_ATTACH_IN_WANT_TX_ONLY_SPREADING_WIDTH 1
 /* 1 to set new state, or 0 to just report the existing state */
 #define       MC_CMD_DRV_ATTACH_IN_UPDATE_OFST 4
 #define       MC_CMD_DRV_ATTACH_IN_UPDATE_LEN 4
@@ -2736,9 +3194,91 @@
  * bug69716)
  */
 #define          MC_CMD_FW_L3XUDP 0x7
+/* enum: Requests that the MC keep whatever datapath firmware is currently
+ * running. It's used for test purposes, where we want to be able to shmboot
+ * special test firmware variants. This option is only recognised in eftest
+ * (i.e. non-production) builds.
+ */
+#define          MC_CMD_FW_KEEP_CURRENT_EFTEST_ONLY 0xfffffffe
 /* enum: Only this option is allowed for non-admin functions */
 #define          MC_CMD_FW_DONT_CARE 0xffffffff
 
+/* MC_CMD_DRV_ATTACH_IN_V2 msgrequest: Updated DRV_ATTACH to include driver
+ * version
+ */
+#define    MC_CMD_DRV_ATTACH_IN_V2_LEN 32
+/* new state to set if UPDATE=1 */
+#define       MC_CMD_DRV_ATTACH_IN_V2_NEW_STATE_OFST 0
+#define       MC_CMD_DRV_ATTACH_IN_V2_NEW_STATE_LEN 4
+/*             MC_CMD_DRV_ATTACH_OFST 0 */
+/*             MC_CMD_DRV_ATTACH_LBN 0 */
+/*             MC_CMD_DRV_ATTACH_WIDTH 1 */
+#define        MC_CMD_DRV_ATTACH_IN_V2_ATTACH_OFST 0
+#define        MC_CMD_DRV_ATTACH_IN_V2_ATTACH_LBN 0
+#define        MC_CMD_DRV_ATTACH_IN_V2_ATTACH_WIDTH 1
+/*             MC_CMD_DRV_PREBOOT_OFST 0 */
+/*             MC_CMD_DRV_PREBOOT_LBN 1 */
+/*             MC_CMD_DRV_PREBOOT_WIDTH 1 */
+#define        MC_CMD_DRV_ATTACH_IN_V2_PREBOOT_OFST 0
+#define        MC_CMD_DRV_ATTACH_IN_V2_PREBOOT_LBN 1
+#define        MC_CMD_DRV_ATTACH_IN_V2_PREBOOT_WIDTH 1
+#define        MC_CMD_DRV_ATTACH_IN_V2_SUBVARIANT_AWARE_OFST 0
+#define        MC_CMD_DRV_ATTACH_IN_V2_SUBVARIANT_AWARE_LBN 2
+#define        MC_CMD_DRV_ATTACH_IN_V2_SUBVARIANT_AWARE_WIDTH 1
+#define        MC_CMD_DRV_ATTACH_IN_V2_WANT_VI_SPREADING_OFST 0
+#define        MC_CMD_DRV_ATTACH_IN_V2_WANT_VI_SPREADING_LBN 3
+#define        MC_CMD_DRV_ATTACH_IN_V2_WANT_VI_SPREADING_WIDTH 1
+#define        MC_CMD_DRV_ATTACH_IN_V2_WANT_V2_LINKCHANGES_OFST 0
+#define        MC_CMD_DRV_ATTACH_IN_V2_WANT_V2_LINKCHANGES_LBN 4
+#define        MC_CMD_DRV_ATTACH_IN_V2_WANT_V2_LINKCHANGES_WIDTH 1
+#define        MC_CMD_DRV_ATTACH_IN_V2_WANT_RX_VI_SPREADING_INHIBIT_OFST 0
+#define        MC_CMD_DRV_ATTACH_IN_V2_WANT_RX_VI_SPREADING_INHIBIT_LBN 5
+#define        MC_CMD_DRV_ATTACH_IN_V2_WANT_RX_VI_SPREADING_INHIBIT_WIDTH 1
+#define        MC_CMD_DRV_ATTACH_IN_V2_WANT_TX_ONLY_SPREADING_OFST 0
+#define        MC_CMD_DRV_ATTACH_IN_V2_WANT_TX_ONLY_SPREADING_LBN 5
+#define        MC_CMD_DRV_ATTACH_IN_V2_WANT_TX_ONLY_SPREADING_WIDTH 1
+/* 1 to set new state, or 0 to just report the existing state */
+#define       MC_CMD_DRV_ATTACH_IN_V2_UPDATE_OFST 4
+#define       MC_CMD_DRV_ATTACH_IN_V2_UPDATE_LEN 4
+/* preferred datapath firmware (for Huntington; ignored for Siena) */
+#define       MC_CMD_DRV_ATTACH_IN_V2_FIRMWARE_ID_OFST 8
+#define       MC_CMD_DRV_ATTACH_IN_V2_FIRMWARE_ID_LEN 4
+/* enum: Prefer to use full featured firmware */
+/*               MC_CMD_FW_FULL_FEATURED 0x0 */
+/* enum: Prefer to use firmware with fewer features but lower latency */
+/*               MC_CMD_FW_LOW_LATENCY 0x1 */
+/* enum: Prefer to use firmware for SolarCapture packed stream mode */
+/*               MC_CMD_FW_PACKED_STREAM 0x2 */
+/* enum: Prefer to use firmware with fewer features and simpler TX event
+ * batching but higher TX packet rate
+ */
+/*               MC_CMD_FW_HIGH_TX_RATE 0x3 */
+/* enum: Reserved value */
+/*               MC_CMD_FW_PACKED_STREAM_HASH_MODE_1 0x4 */
+/* enum: Prefer to use firmware with additional "rules engine" filtering
+ * support
+ */
+/*               MC_CMD_FW_RULES_ENGINE 0x5 */
+/* enum: Prefer to use firmware with additional DPDK support */
+/*               MC_CMD_FW_DPDK 0x6 */
+/* enum: Prefer to use "l3xudp" custom datapath firmware (see SF-119495-PD and
+ * bug69716)
+ */
+/*               MC_CMD_FW_L3XUDP 0x7 */
+/* enum: Requests that the MC keep whatever datapath firmware is currently
+ * running. It's used for test purposes, where we want to be able to shmboot
+ * special test firmware variants. This option is only recognised in eftest
+ * (i.e. non-production) builds.
+ */
+/*               MC_CMD_FW_KEEP_CURRENT_EFTEST_ONLY 0xfffffffe */
+/* enum: Only this option is allowed for non-admin functions */
+/*               MC_CMD_FW_DONT_CARE 0xffffffff */
+/* Version of the driver to be reported by management protocols (e.g. NC-SI)
+ * handled by the NIC. This is a zero-terminated ASCII string.
+ */
+#define       MC_CMD_DRV_ATTACH_IN_V2_DRIVER_VERSION_OFST 12
+#define       MC_CMD_DRV_ATTACH_IN_V2_DRIVER_VERSION_LEN 20
+
 /* MC_CMD_DRV_ATTACH_OUT msgresponse */
 #define    MC_CMD_DRV_ATTACH_OUT_LEN 4
 /* previous or existing state, see the bitmask at NEW_STATE */
@@ -2770,6 +3310,13 @@
  * input.
  */
 #define          MC_CMD_DRV_ATTACH_EXT_OUT_FLAG_VI_SPREADING_ENABLED 0x4
+/* enum: Used during development only. Should no longer be used. */
+#define          MC_CMD_DRV_ATTACH_EXT_OUT_FLAG_RX_VI_SPREADING_INHIBITED 0x5
+/* enum: If set, indicates that TX only spreading is enabled. Even-numbered
+ * TXQs will use one engine, and odd-numbered TXQs will use the other. This
+ * also has the effect that only even-numbered RXQs will receive traffic.
+ */
+#define          MC_CMD_DRV_ATTACH_EXT_OUT_FLAG_TX_ONLY_VI_SPREADING_ENABLED 0x5
 
 
 /***********************************/
@@ -2795,6 +3342,7 @@
  * use MC_CMD_ENTITY_RESET instead.
  */
 #define MC_CMD_PORT_RESET 0x20
+#undef MC_CMD_0x20_PRIVILEGE_CTG
 
 #define MC_CMD_0x20_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -2821,6 +3369,7 @@
  */
 #define       MC_CMD_ENTITY_RESET_IN_FLAG_OFST 0
 #define       MC_CMD_ENTITY_RESET_IN_FLAG_LEN 4
+#define        MC_CMD_ENTITY_RESET_IN_FUNCTION_RESOURCE_RESET_OFST 0
 #define        MC_CMD_ENTITY_RESET_IN_FUNCTION_RESOURCE_RESET_LBN 0
 #define        MC_CMD_ENTITY_RESET_IN_FUNCTION_RESOURCE_RESET_WIDTH 1
 
@@ -2927,17 +3476,22 @@
  * Copy the given ASCII string out onto UART and/or out of the network port.
  */
 #define MC_CMD_PUTS 0x23
+#undef MC_CMD_0x23_PRIVILEGE_CTG
 
 #define MC_CMD_0x23_PRIVILEGE_CTG SRIOV_CTG_INSECURE
 
 /* MC_CMD_PUTS_IN msgrequest */
 #define    MC_CMD_PUTS_IN_LENMIN 13
 #define    MC_CMD_PUTS_IN_LENMAX 252
+#define    MC_CMD_PUTS_IN_LENMAX_MCDI2 1020
 #define    MC_CMD_PUTS_IN_LEN(num) (12+1*(num))
+#define    MC_CMD_PUTS_IN_STRING_NUM(len) (((len)-12)/1)
 #define       MC_CMD_PUTS_IN_DEST_OFST 0
 #define       MC_CMD_PUTS_IN_DEST_LEN 4
+#define        MC_CMD_PUTS_IN_UART_OFST 0
 #define        MC_CMD_PUTS_IN_UART_LBN 0
 #define        MC_CMD_PUTS_IN_UART_WIDTH 1
+#define        MC_CMD_PUTS_IN_PORT_OFST 0
 #define        MC_CMD_PUTS_IN_PORT_LBN 1
 #define        MC_CMD_PUTS_IN_PORT_WIDTH 1
 #define       MC_CMD_PUTS_IN_DHOST_OFST 4
@@ -2946,6 +3500,7 @@
 #define       MC_CMD_PUTS_IN_STRING_LEN 1
 #define       MC_CMD_PUTS_IN_STRING_MINNUM 1
 #define       MC_CMD_PUTS_IN_STRING_MAXNUM 240
+#define       MC_CMD_PUTS_IN_STRING_MAXNUM_MCDI2 1008
 
 /* MC_CMD_PUTS_OUT msgresponse */
 #define    MC_CMD_PUTS_OUT_LEN 0
@@ -2957,6 +3512,7 @@
  * 'zombie' state. Locks required: None
  */
 #define MC_CMD_GET_PHY_CFG 0x24
+#undef MC_CMD_0x24_PRIVILEGE_CTG
 
 #define MC_CMD_0x24_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -2968,18 +3524,25 @@
 /* flags */
 #define       MC_CMD_GET_PHY_CFG_OUT_FLAGS_OFST 0
 #define       MC_CMD_GET_PHY_CFG_OUT_FLAGS_LEN 4
+#define        MC_CMD_GET_PHY_CFG_OUT_PRESENT_OFST 0
 #define        MC_CMD_GET_PHY_CFG_OUT_PRESENT_LBN 0
 #define        MC_CMD_GET_PHY_CFG_OUT_PRESENT_WIDTH 1
+#define        MC_CMD_GET_PHY_CFG_OUT_BIST_CABLE_SHORT_OFST 0
 #define        MC_CMD_GET_PHY_CFG_OUT_BIST_CABLE_SHORT_LBN 1
 #define        MC_CMD_GET_PHY_CFG_OUT_BIST_CABLE_SHORT_WIDTH 1
+#define        MC_CMD_GET_PHY_CFG_OUT_BIST_CABLE_LONG_OFST 0
 #define        MC_CMD_GET_PHY_CFG_OUT_BIST_CABLE_LONG_LBN 2
 #define        MC_CMD_GET_PHY_CFG_OUT_BIST_CABLE_LONG_WIDTH 1
+#define        MC_CMD_GET_PHY_CFG_OUT_LOWPOWER_OFST 0
 #define        MC_CMD_GET_PHY_CFG_OUT_LOWPOWER_LBN 3
 #define        MC_CMD_GET_PHY_CFG_OUT_LOWPOWER_WIDTH 1
+#define        MC_CMD_GET_PHY_CFG_OUT_POWEROFF_OFST 0
 #define        MC_CMD_GET_PHY_CFG_OUT_POWEROFF_LBN 4
 #define        MC_CMD_GET_PHY_CFG_OUT_POWEROFF_WIDTH 1
+#define        MC_CMD_GET_PHY_CFG_OUT_TXDIS_OFST 0
 #define        MC_CMD_GET_PHY_CFG_OUT_TXDIS_LBN 5
 #define        MC_CMD_GET_PHY_CFG_OUT_TXDIS_WIDTH 1
+#define        MC_CMD_GET_PHY_CFG_OUT_BIST_OFST 0
 #define        MC_CMD_GET_PHY_CFG_OUT_BIST_LBN 6
 #define        MC_CMD_GET_PHY_CFG_OUT_BIST_WIDTH 1
 /* ?? */
@@ -2988,46 +3551,67 @@
 /* Bitmask of supported capabilities */
 #define       MC_CMD_GET_PHY_CFG_OUT_SUPPORTED_CAP_OFST 8
 #define       MC_CMD_GET_PHY_CFG_OUT_SUPPORTED_CAP_LEN 4
+#define        MC_CMD_PHY_CAP_10HDX_OFST 8
 #define        MC_CMD_PHY_CAP_10HDX_LBN 1
 #define        MC_CMD_PHY_CAP_10HDX_WIDTH 1
+#define        MC_CMD_PHY_CAP_10FDX_OFST 8
 #define        MC_CMD_PHY_CAP_10FDX_LBN 2
 #define        MC_CMD_PHY_CAP_10FDX_WIDTH 1
+#define        MC_CMD_PHY_CAP_100HDX_OFST 8
 #define        MC_CMD_PHY_CAP_100HDX_LBN 3
 #define        MC_CMD_PHY_CAP_100HDX_WIDTH 1
+#define        MC_CMD_PHY_CAP_100FDX_OFST 8
 #define        MC_CMD_PHY_CAP_100FDX_LBN 4
 #define        MC_CMD_PHY_CAP_100FDX_WIDTH 1
+#define        MC_CMD_PHY_CAP_1000HDX_OFST 8
 #define        MC_CMD_PHY_CAP_1000HDX_LBN 5
 #define        MC_CMD_PHY_CAP_1000HDX_WIDTH 1
+#define        MC_CMD_PHY_CAP_1000FDX_OFST 8
 #define        MC_CMD_PHY_CAP_1000FDX_LBN 6
 #define        MC_CMD_PHY_CAP_1000FDX_WIDTH 1
+#define        MC_CMD_PHY_CAP_10000FDX_OFST 8
 #define        MC_CMD_PHY_CAP_10000FDX_LBN 7
 #define        MC_CMD_PHY_CAP_10000FDX_WIDTH 1
+#define        MC_CMD_PHY_CAP_PAUSE_OFST 8
 #define        MC_CMD_PHY_CAP_PAUSE_LBN 8
 #define        MC_CMD_PHY_CAP_PAUSE_WIDTH 1
+#define        MC_CMD_PHY_CAP_ASYM_OFST 8
 #define        MC_CMD_PHY_CAP_ASYM_LBN 9
 #define        MC_CMD_PHY_CAP_ASYM_WIDTH 1
+#define        MC_CMD_PHY_CAP_AN_OFST 8
 #define        MC_CMD_PHY_CAP_AN_LBN 10
 #define        MC_CMD_PHY_CAP_AN_WIDTH 1
+#define        MC_CMD_PHY_CAP_40000FDX_OFST 8
 #define        MC_CMD_PHY_CAP_40000FDX_LBN 11
 #define        MC_CMD_PHY_CAP_40000FDX_WIDTH 1
+#define        MC_CMD_PHY_CAP_DDM_OFST 8
 #define        MC_CMD_PHY_CAP_DDM_LBN 12
 #define        MC_CMD_PHY_CAP_DDM_WIDTH 1
+#define        MC_CMD_PHY_CAP_100000FDX_OFST 8
 #define        MC_CMD_PHY_CAP_100000FDX_LBN 13
 #define        MC_CMD_PHY_CAP_100000FDX_WIDTH 1
+#define        MC_CMD_PHY_CAP_25000FDX_OFST 8
 #define        MC_CMD_PHY_CAP_25000FDX_LBN 14
 #define        MC_CMD_PHY_CAP_25000FDX_WIDTH 1
+#define        MC_CMD_PHY_CAP_50000FDX_OFST 8
 #define        MC_CMD_PHY_CAP_50000FDX_LBN 15
 #define        MC_CMD_PHY_CAP_50000FDX_WIDTH 1
+#define        MC_CMD_PHY_CAP_BASER_FEC_OFST 8
 #define        MC_CMD_PHY_CAP_BASER_FEC_LBN 16
 #define        MC_CMD_PHY_CAP_BASER_FEC_WIDTH 1
+#define        MC_CMD_PHY_CAP_BASER_FEC_REQUESTED_OFST 8
 #define        MC_CMD_PHY_CAP_BASER_FEC_REQUESTED_LBN 17
 #define        MC_CMD_PHY_CAP_BASER_FEC_REQUESTED_WIDTH 1
+#define        MC_CMD_PHY_CAP_RS_FEC_OFST 8
 #define        MC_CMD_PHY_CAP_RS_FEC_LBN 18
 #define        MC_CMD_PHY_CAP_RS_FEC_WIDTH 1
+#define        MC_CMD_PHY_CAP_RS_FEC_REQUESTED_OFST 8
 #define        MC_CMD_PHY_CAP_RS_FEC_REQUESTED_LBN 19
 #define        MC_CMD_PHY_CAP_RS_FEC_REQUESTED_WIDTH 1
+#define        MC_CMD_PHY_CAP_25G_BASER_FEC_OFST 8
 #define        MC_CMD_PHY_CAP_25G_BASER_FEC_LBN 20
 #define        MC_CMD_PHY_CAP_25G_BASER_FEC_WIDTH 1
+#define        MC_CMD_PHY_CAP_25G_BASER_FEC_REQUESTED_OFST 8
 #define        MC_CMD_PHY_CAP_25G_BASER_FEC_REQUESTED_LBN 21
 #define        MC_CMD_PHY_CAP_25G_BASER_FEC_REQUESTED_WIDTH 1
 /* ?? */
@@ -3084,6 +3668,7 @@
  * Return code: 0, EINVAL, EACCES (if PHY_LOCK is not held)
  */
 #define MC_CMD_START_BIST 0x25
+#undef MC_CMD_0x25_PRIVILEGE_CTG
 
 #define MC_CMD_0x25_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
@@ -3123,6 +3708,7 @@
  * EACCES (if PHY_LOCK is not held).
  */
 #define MC_CMD_POLL_BIST 0x26
+#undef MC_CMD_0x26_PRIVILEGE_CTG
 
 #define MC_CMD_0x26_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
@@ -3295,11 +3881,14 @@
 /* MC_CMD_FLUSH_RX_QUEUES_IN msgrequest */
 #define    MC_CMD_FLUSH_RX_QUEUES_IN_LENMIN 4
 #define    MC_CMD_FLUSH_RX_QUEUES_IN_LENMAX 252
+#define    MC_CMD_FLUSH_RX_QUEUES_IN_LENMAX_MCDI2 1020
 #define    MC_CMD_FLUSH_RX_QUEUES_IN_LEN(num) (0+4*(num))
+#define    MC_CMD_FLUSH_RX_QUEUES_IN_QID_OFST_NUM(len) (((len)-0)/4)
 #define       MC_CMD_FLUSH_RX_QUEUES_IN_QID_OFST_OFST 0
 #define       MC_CMD_FLUSH_RX_QUEUES_IN_QID_OFST_LEN 4
 #define       MC_CMD_FLUSH_RX_QUEUES_IN_QID_OFST_MINNUM 1
 #define       MC_CMD_FLUSH_RX_QUEUES_IN_QID_OFST_MAXNUM 63
+#define       MC_CMD_FLUSH_RX_QUEUES_IN_QID_OFST_MAXNUM_MCDI2 255
 
 /* MC_CMD_FLUSH_RX_QUEUES_OUT msgresponse */
 #define    MC_CMD_FLUSH_RX_QUEUES_OUT_LEN 0
@@ -3310,6 +3899,7 @@
  * Returns a bitmask of loopback modes available at each speed.
  */
 #define MC_CMD_GET_LOOPBACK_MODES 0x28
+#undef MC_CMD_0x28_PRIVILEGE_CTG
 
 #define MC_CMD_0x28_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -3605,6 +4195,7 @@
  * ETIME.
  */
 #define MC_CMD_GET_LINK 0x29
+#undef MC_CMD_0x29_PRIVILEGE_CTG
 
 #define MC_CMD_0x29_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -3635,18 +4226,30 @@
 /*               MC_CMD_GET_LOOPBACK_MODES/MC_CMD_GET_LOOPBACK_MODES_OUT/100M */
 #define       MC_CMD_GET_LINK_OUT_FLAGS_OFST 16
 #define       MC_CMD_GET_LINK_OUT_FLAGS_LEN 4
+#define        MC_CMD_GET_LINK_OUT_LINK_UP_OFST 16
 #define        MC_CMD_GET_LINK_OUT_LINK_UP_LBN 0
 #define        MC_CMD_GET_LINK_OUT_LINK_UP_WIDTH 1
+#define        MC_CMD_GET_LINK_OUT_FULL_DUPLEX_OFST 16
 #define        MC_CMD_GET_LINK_OUT_FULL_DUPLEX_LBN 1
 #define        MC_CMD_GET_LINK_OUT_FULL_DUPLEX_WIDTH 1
+#define        MC_CMD_GET_LINK_OUT_BPX_LINK_OFST 16
 #define        MC_CMD_GET_LINK_OUT_BPX_LINK_LBN 2
 #define        MC_CMD_GET_LINK_OUT_BPX_LINK_WIDTH 1
+#define        MC_CMD_GET_LINK_OUT_PHY_LINK_OFST 16
 #define        MC_CMD_GET_LINK_OUT_PHY_LINK_LBN 3
 #define        MC_CMD_GET_LINK_OUT_PHY_LINK_WIDTH 1
+#define        MC_CMD_GET_LINK_OUT_LINK_FAULT_RX_OFST 16
 #define        MC_CMD_GET_LINK_OUT_LINK_FAULT_RX_LBN 6
 #define        MC_CMD_GET_LINK_OUT_LINK_FAULT_RX_WIDTH 1
+#define        MC_CMD_GET_LINK_OUT_LINK_FAULT_TX_OFST 16
 #define        MC_CMD_GET_LINK_OUT_LINK_FAULT_TX_LBN 7
 #define        MC_CMD_GET_LINK_OUT_LINK_FAULT_TX_WIDTH 1
+#define        MC_CMD_GET_LINK_OUT_MODULE_UP_VALID_OFST 16
+#define        MC_CMD_GET_LINK_OUT_MODULE_UP_VALID_LBN 8
+#define        MC_CMD_GET_LINK_OUT_MODULE_UP_VALID_WIDTH 1
+#define        MC_CMD_GET_LINK_OUT_MODULE_UP_OFST 16
+#define        MC_CMD_GET_LINK_OUT_MODULE_UP_LBN 9
+#define        MC_CMD_GET_LINK_OUT_MODULE_UP_WIDTH 1
 /* This returns the negotiated flow control value. */
 #define       MC_CMD_GET_LINK_OUT_FCNTL_OFST 20
 #define       MC_CMD_GET_LINK_OUT_FCNTL_LEN 4
@@ -3654,12 +4257,16 @@
 /*               MC_CMD_SET_MAC/MC_CMD_SET_MAC_IN/FCNTL */
 #define       MC_CMD_GET_LINK_OUT_MAC_FAULT_OFST 24
 #define       MC_CMD_GET_LINK_OUT_MAC_FAULT_LEN 4
+#define        MC_CMD_MAC_FAULT_XGMII_LOCAL_OFST 24
 #define        MC_CMD_MAC_FAULT_XGMII_LOCAL_LBN 0
 #define        MC_CMD_MAC_FAULT_XGMII_LOCAL_WIDTH 1
+#define        MC_CMD_MAC_FAULT_XGMII_REMOTE_OFST 24
 #define        MC_CMD_MAC_FAULT_XGMII_REMOTE_LBN 1
 #define        MC_CMD_MAC_FAULT_XGMII_REMOTE_WIDTH 1
+#define        MC_CMD_MAC_FAULT_SGMII_REMOTE_OFST 24
 #define        MC_CMD_MAC_FAULT_SGMII_REMOTE_LBN 2
 #define        MC_CMD_MAC_FAULT_SGMII_REMOTE_WIDTH 1
+#define        MC_CMD_MAC_FAULT_PENDING_RECONFIG_OFST 24
 #define        MC_CMD_MAC_FAULT_PENDING_RECONFIG_LBN 3
 #define        MC_CMD_MAC_FAULT_PENDING_RECONFIG_WIDTH 1
 
@@ -3687,18 +4294,30 @@
 /*               MC_CMD_GET_LOOPBACK_MODES/MC_CMD_GET_LOOPBACK_MODES_OUT/100M */
 #define       MC_CMD_GET_LINK_OUT_V2_FLAGS_OFST 16
 #define       MC_CMD_GET_LINK_OUT_V2_FLAGS_LEN 4
+#define        MC_CMD_GET_LINK_OUT_V2_LINK_UP_OFST 16
 #define        MC_CMD_GET_LINK_OUT_V2_LINK_UP_LBN 0
 #define        MC_CMD_GET_LINK_OUT_V2_LINK_UP_WIDTH 1
+#define        MC_CMD_GET_LINK_OUT_V2_FULL_DUPLEX_OFST 16
 #define        MC_CMD_GET_LINK_OUT_V2_FULL_DUPLEX_LBN 1
 #define        MC_CMD_GET_LINK_OUT_V2_FULL_DUPLEX_WIDTH 1
+#define        MC_CMD_GET_LINK_OUT_V2_BPX_LINK_OFST 16
 #define        MC_CMD_GET_LINK_OUT_V2_BPX_LINK_LBN 2
 #define        MC_CMD_GET_LINK_OUT_V2_BPX_LINK_WIDTH 1
+#define        MC_CMD_GET_LINK_OUT_V2_PHY_LINK_OFST 16
 #define        MC_CMD_GET_LINK_OUT_V2_PHY_LINK_LBN 3
 #define        MC_CMD_GET_LINK_OUT_V2_PHY_LINK_WIDTH 1
+#define        MC_CMD_GET_LINK_OUT_V2_LINK_FAULT_RX_OFST 16
 #define        MC_CMD_GET_LINK_OUT_V2_LINK_FAULT_RX_LBN 6
 #define        MC_CMD_GET_LINK_OUT_V2_LINK_FAULT_RX_WIDTH 1
+#define        MC_CMD_GET_LINK_OUT_V2_LINK_FAULT_TX_OFST 16
 #define        MC_CMD_GET_LINK_OUT_V2_LINK_FAULT_TX_LBN 7
 #define        MC_CMD_GET_LINK_OUT_V2_LINK_FAULT_TX_WIDTH 1
+#define        MC_CMD_GET_LINK_OUT_V2_MODULE_UP_VALID_OFST 16
+#define        MC_CMD_GET_LINK_OUT_V2_MODULE_UP_VALID_LBN 8
+#define        MC_CMD_GET_LINK_OUT_V2_MODULE_UP_VALID_WIDTH 1
+#define        MC_CMD_GET_LINK_OUT_V2_MODULE_UP_OFST 16
+#define        MC_CMD_GET_LINK_OUT_V2_MODULE_UP_LBN 9
+#define        MC_CMD_GET_LINK_OUT_V2_MODULE_UP_WIDTH 1
 /* This returns the negotiated flow control value. */
 #define       MC_CMD_GET_LINK_OUT_V2_FCNTL_OFST 20
 #define       MC_CMD_GET_LINK_OUT_V2_FCNTL_LEN 4
@@ -3706,12 +4325,16 @@
 /*               MC_CMD_SET_MAC/MC_CMD_SET_MAC_IN/FCNTL */
 #define       MC_CMD_GET_LINK_OUT_V2_MAC_FAULT_OFST 24
 #define       MC_CMD_GET_LINK_OUT_V2_MAC_FAULT_LEN 4
+/*             MC_CMD_MAC_FAULT_XGMII_LOCAL_OFST 24 */
 /*             MC_CMD_MAC_FAULT_XGMII_LOCAL_LBN 0 */
 /*             MC_CMD_MAC_FAULT_XGMII_LOCAL_WIDTH 1 */
+/*             MC_CMD_MAC_FAULT_XGMII_REMOTE_OFST 24 */
 /*             MC_CMD_MAC_FAULT_XGMII_REMOTE_LBN 1 */
 /*             MC_CMD_MAC_FAULT_XGMII_REMOTE_WIDTH 1 */
+/*             MC_CMD_MAC_FAULT_SGMII_REMOTE_OFST 24 */
 /*             MC_CMD_MAC_FAULT_SGMII_REMOTE_LBN 2 */
 /*             MC_CMD_MAC_FAULT_SGMII_REMOTE_WIDTH 1 */
+/*             MC_CMD_MAC_FAULT_PENDING_RECONFIG_OFST 24 */
 /*             MC_CMD_MAC_FAULT_PENDING_RECONFIG_LBN 3 */
 /*             MC_CMD_MAC_FAULT_PENDING_RECONFIG_WIDTH 1 */
 /* True local device capabilities (taking into account currently used PMD/MDI,
@@ -3735,32 +4358,45 @@
 /*               FEC_TYPE/TYPE */
 #define       MC_CMD_GET_LINK_OUT_V2_EXT_FLAGS_OFST 40
 #define       MC_CMD_GET_LINK_OUT_V2_EXT_FLAGS_LEN 4
+#define        MC_CMD_GET_LINK_OUT_V2_PMD_MDI_CONNECTED_OFST 40
 #define        MC_CMD_GET_LINK_OUT_V2_PMD_MDI_CONNECTED_LBN 0
 #define        MC_CMD_GET_LINK_OUT_V2_PMD_MDI_CONNECTED_WIDTH 1
+#define        MC_CMD_GET_LINK_OUT_V2_PMD_READY_OFST 40
 #define        MC_CMD_GET_LINK_OUT_V2_PMD_READY_LBN 1
 #define        MC_CMD_GET_LINK_OUT_V2_PMD_READY_WIDTH 1
+#define        MC_CMD_GET_LINK_OUT_V2_PMD_LINK_UP_OFST 40
 #define        MC_CMD_GET_LINK_OUT_V2_PMD_LINK_UP_LBN 2
 #define        MC_CMD_GET_LINK_OUT_V2_PMD_LINK_UP_WIDTH 1
+#define        MC_CMD_GET_LINK_OUT_V2_PMA_LINK_UP_OFST 40
 #define        MC_CMD_GET_LINK_OUT_V2_PMA_LINK_UP_LBN 3
 #define        MC_CMD_GET_LINK_OUT_V2_PMA_LINK_UP_WIDTH 1
+#define        MC_CMD_GET_LINK_OUT_V2_PCS_LOCK_OFST 40
 #define        MC_CMD_GET_LINK_OUT_V2_PCS_LOCK_LBN 4
 #define        MC_CMD_GET_LINK_OUT_V2_PCS_LOCK_WIDTH 1
+#define        MC_CMD_GET_LINK_OUT_V2_ALIGN_LOCK_OFST 40
 #define        MC_CMD_GET_LINK_OUT_V2_ALIGN_LOCK_LBN 5
 #define        MC_CMD_GET_LINK_OUT_V2_ALIGN_LOCK_WIDTH 1
+#define        MC_CMD_GET_LINK_OUT_V2_HI_BER_OFST 40
 #define        MC_CMD_GET_LINK_OUT_V2_HI_BER_LBN 6
 #define        MC_CMD_GET_LINK_OUT_V2_HI_BER_WIDTH 1
+#define        MC_CMD_GET_LINK_OUT_V2_FEC_LOCK_OFST 40
 #define        MC_CMD_GET_LINK_OUT_V2_FEC_LOCK_LBN 7
 #define        MC_CMD_GET_LINK_OUT_V2_FEC_LOCK_WIDTH 1
+#define        MC_CMD_GET_LINK_OUT_V2_AN_DONE_OFST 40
 #define        MC_CMD_GET_LINK_OUT_V2_AN_DONE_LBN 8
 #define        MC_CMD_GET_LINK_OUT_V2_AN_DONE_WIDTH 1
+#define        MC_CMD_GET_LINK_OUT_V2_PORT_SHUTDOWN_OFST 40
+#define        MC_CMD_GET_LINK_OUT_V2_PORT_SHUTDOWN_LBN 9
+#define        MC_CMD_GET_LINK_OUT_V2_PORT_SHUTDOWN_WIDTH 1
 
 
 /***********************************/
 /* MC_CMD_SET_LINK
  * Write the unified MAC/PHY link configuration. Locks required: None. Return
- * code: 0, EINVAL, ETIME
+ * code: 0, EINVAL, ETIME, EAGAIN
  */
 #define MC_CMD_SET_LINK 0x2a
+#undef MC_CMD_0x2a_PRIVILEGE_CTG
 
 #define MC_CMD_0x2a_PRIVILEGE_CTG SRIOV_CTG_LINK
 
@@ -3774,12 +4410,18 @@
 /* Flags */
 #define       MC_CMD_SET_LINK_IN_FLAGS_OFST 4
 #define       MC_CMD_SET_LINK_IN_FLAGS_LEN 4
+#define        MC_CMD_SET_LINK_IN_LOWPOWER_OFST 4
 #define        MC_CMD_SET_LINK_IN_LOWPOWER_LBN 0
 #define        MC_CMD_SET_LINK_IN_LOWPOWER_WIDTH 1
+#define        MC_CMD_SET_LINK_IN_POWEROFF_OFST 4
 #define        MC_CMD_SET_LINK_IN_POWEROFF_LBN 1
 #define        MC_CMD_SET_LINK_IN_POWEROFF_WIDTH 1
+#define        MC_CMD_SET_LINK_IN_TXDIS_OFST 4
 #define        MC_CMD_SET_LINK_IN_TXDIS_LBN 2
 #define        MC_CMD_SET_LINK_IN_TXDIS_WIDTH 1
+#define        MC_CMD_SET_LINK_IN_LINKDOWN_OFST 4
+#define        MC_CMD_SET_LINK_IN_LINKDOWN_LBN 3
+#define        MC_CMD_SET_LINK_IN_LINKDOWN_WIDTH 1
 /* Loopback mode. */
 #define       MC_CMD_SET_LINK_IN_LOOPBACK_MODE_OFST 8
 #define       MC_CMD_SET_LINK_IN_LOOPBACK_MODE_LEN 4
@@ -3791,6 +4433,50 @@
 #define       MC_CMD_SET_LINK_IN_LOOPBACK_SPEED_OFST 12
 #define       MC_CMD_SET_LINK_IN_LOOPBACK_SPEED_LEN 4
 
+/* MC_CMD_SET_LINK_IN_V2 msgrequest: Updated SET_LINK to include sequence
+ * number to ensure this SET_LINK command corresponds to the latest
+ * MODULECHANGE event.
+ */
+#define    MC_CMD_SET_LINK_IN_V2_LEN 17
+/* Near-side advertised capabilities. Refer to
+ * MC_CMD_GET_PHY_CFG_OUT/SUPPORTED_CAP for bit definitions.
+ */
+#define       MC_CMD_SET_LINK_IN_V2_CAP_OFST 0
+#define       MC_CMD_SET_LINK_IN_V2_CAP_LEN 4
+/* Flags */
+#define       MC_CMD_SET_LINK_IN_V2_FLAGS_OFST 4
+#define       MC_CMD_SET_LINK_IN_V2_FLAGS_LEN 4
+#define        MC_CMD_SET_LINK_IN_V2_LOWPOWER_OFST 4
+#define        MC_CMD_SET_LINK_IN_V2_LOWPOWER_LBN 0
+#define        MC_CMD_SET_LINK_IN_V2_LOWPOWER_WIDTH 1
+#define        MC_CMD_SET_LINK_IN_V2_POWEROFF_OFST 4
+#define        MC_CMD_SET_LINK_IN_V2_POWEROFF_LBN 1
+#define        MC_CMD_SET_LINK_IN_V2_POWEROFF_WIDTH 1
+#define        MC_CMD_SET_LINK_IN_V2_TXDIS_OFST 4
+#define        MC_CMD_SET_LINK_IN_V2_TXDIS_LBN 2
+#define        MC_CMD_SET_LINK_IN_V2_TXDIS_WIDTH 1
+#define        MC_CMD_SET_LINK_IN_V2_LINKDOWN_OFST 4
+#define        MC_CMD_SET_LINK_IN_V2_LINKDOWN_LBN 3
+#define        MC_CMD_SET_LINK_IN_V2_LINKDOWN_WIDTH 1
+/* Loopback mode. */
+#define       MC_CMD_SET_LINK_IN_V2_LOOPBACK_MODE_OFST 8
+#define       MC_CMD_SET_LINK_IN_V2_LOOPBACK_MODE_LEN 4
+/*            Enum values, see field(s): */
+/*               MC_CMD_GET_LOOPBACK_MODES/MC_CMD_GET_LOOPBACK_MODES_OUT/100M */
+/* A loopback speed of "0" is supported, and means (choose any available
+ * speed).
+ */
+#define       MC_CMD_SET_LINK_IN_V2_LOOPBACK_SPEED_OFST 12
+#define       MC_CMD_SET_LINK_IN_V2_LOOPBACK_SPEED_LEN 4
+#define       MC_CMD_SET_LINK_IN_V2_MODULE_SEQ_OFST 16
+#define       MC_CMD_SET_LINK_IN_V2_MODULE_SEQ_LEN 1
+#define        MC_CMD_SET_LINK_IN_V2_MODULE_SEQ_NUMBER_OFST 16
+#define        MC_CMD_SET_LINK_IN_V2_MODULE_SEQ_NUMBER_LBN 0
+#define        MC_CMD_SET_LINK_IN_V2_MODULE_SEQ_NUMBER_WIDTH 7
+#define        MC_CMD_SET_LINK_IN_V2_MODULE_SEQ_IGNORE_OFST 16
+#define        MC_CMD_SET_LINK_IN_V2_MODULE_SEQ_IGNORE_LBN 7
+#define        MC_CMD_SET_LINK_IN_V2_MODULE_SEQ_IGNORE_WIDTH 1
+
 /* MC_CMD_SET_LINK_OUT msgresponse */
 #define    MC_CMD_SET_LINK_OUT_LEN 0
 
@@ -3800,6 +4486,7 @@
  * Set identification LED state. Locks required: None. Return code: 0, EINVAL
  */
 #define MC_CMD_SET_ID_LED 0x2b
+#undef MC_CMD_0x2b_PRIVILEGE_CTG
 
 #define MC_CMD_0x2b_PRIVILEGE_CTG SRIOV_CTG_LINK
 
@@ -3821,6 +4508,7 @@
  * Set MAC configuration. Locks required: None. Return code: 0, EINVAL
  */
 #define MC_CMD_SET_MAC 0x2c
+#undef MC_CMD_0x2c_PRIVILEGE_CTG
 
 #define MC_CMD_0x2c_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -3839,8 +4527,10 @@
 #define       MC_CMD_SET_MAC_IN_ADDR_HI_OFST 12
 #define       MC_CMD_SET_MAC_IN_REJECT_OFST 16
 #define       MC_CMD_SET_MAC_IN_REJECT_LEN 4
+#define        MC_CMD_SET_MAC_IN_REJECT_UNCST_OFST 16
 #define        MC_CMD_SET_MAC_IN_REJECT_UNCST_LBN 0
 #define        MC_CMD_SET_MAC_IN_REJECT_UNCST_WIDTH 1
+#define        MC_CMD_SET_MAC_IN_REJECT_BRDCST_OFST 16
 #define        MC_CMD_SET_MAC_IN_REJECT_BRDCST_LBN 1
 #define        MC_CMD_SET_MAC_IN_REJECT_BRDCST_WIDTH 1
 #define       MC_CMD_SET_MAC_IN_FCNTL_OFST 20
@@ -3859,6 +4549,7 @@
 #define          MC_CMD_FCNTL_GENERATE 0x5
 #define       MC_CMD_SET_MAC_IN_FLAGS_OFST 24
 #define       MC_CMD_SET_MAC_IN_FLAGS_LEN 4
+#define        MC_CMD_SET_MAC_IN_FLAG_INCLUDE_FCS_OFST 24
 #define        MC_CMD_SET_MAC_IN_FLAG_INCLUDE_FCS_LBN 0
 #define        MC_CMD_SET_MAC_IN_FLAG_INCLUDE_FCS_WIDTH 1
 
@@ -3877,8 +4568,10 @@
 #define       MC_CMD_SET_MAC_EXT_IN_ADDR_HI_OFST 12
 #define       MC_CMD_SET_MAC_EXT_IN_REJECT_OFST 16
 #define       MC_CMD_SET_MAC_EXT_IN_REJECT_LEN 4
+#define        MC_CMD_SET_MAC_EXT_IN_REJECT_UNCST_OFST 16
 #define        MC_CMD_SET_MAC_EXT_IN_REJECT_UNCST_LBN 0
 #define        MC_CMD_SET_MAC_EXT_IN_REJECT_UNCST_WIDTH 1
+#define        MC_CMD_SET_MAC_EXT_IN_REJECT_BRDCST_OFST 16
 #define        MC_CMD_SET_MAC_EXT_IN_REJECT_BRDCST_LBN 1
 #define        MC_CMD_SET_MAC_EXT_IN_REJECT_BRDCST_WIDTH 1
 #define       MC_CMD_SET_MAC_EXT_IN_FCNTL_OFST 20
@@ -3897,6 +4590,7 @@
 /*               MC_CMD_FCNTL_GENERATE 0x5 */
 #define       MC_CMD_SET_MAC_EXT_IN_FLAGS_OFST 24
 #define       MC_CMD_SET_MAC_EXT_IN_FLAGS_LEN 4
+#define        MC_CMD_SET_MAC_EXT_IN_FLAG_INCLUDE_FCS_OFST 24
 #define        MC_CMD_SET_MAC_EXT_IN_FLAG_INCLUDE_FCS_LBN 0
 #define        MC_CMD_SET_MAC_EXT_IN_FLAG_INCLUDE_FCS_WIDTH 1
 /* Select which parameters to configure. A parameter will only be modified if
@@ -3906,14 +4600,19 @@
  */
 #define       MC_CMD_SET_MAC_EXT_IN_CONTROL_OFST 28
 #define       MC_CMD_SET_MAC_EXT_IN_CONTROL_LEN 4
+#define        MC_CMD_SET_MAC_EXT_IN_CFG_MTU_OFST 28
 #define        MC_CMD_SET_MAC_EXT_IN_CFG_MTU_LBN 0
 #define        MC_CMD_SET_MAC_EXT_IN_CFG_MTU_WIDTH 1
+#define        MC_CMD_SET_MAC_EXT_IN_CFG_DRAIN_OFST 28
 #define        MC_CMD_SET_MAC_EXT_IN_CFG_DRAIN_LBN 1
 #define        MC_CMD_SET_MAC_EXT_IN_CFG_DRAIN_WIDTH 1
+#define        MC_CMD_SET_MAC_EXT_IN_CFG_REJECT_OFST 28
 #define        MC_CMD_SET_MAC_EXT_IN_CFG_REJECT_LBN 2
 #define        MC_CMD_SET_MAC_EXT_IN_CFG_REJECT_WIDTH 1
+#define        MC_CMD_SET_MAC_EXT_IN_CFG_FCNTL_OFST 28
 #define        MC_CMD_SET_MAC_EXT_IN_CFG_FCNTL_LBN 3
 #define        MC_CMD_SET_MAC_EXT_IN_CFG_FCNTL_WIDTH 1
+#define        MC_CMD_SET_MAC_EXT_IN_CFG_FCS_OFST 28
 #define        MC_CMD_SET_MAC_EXT_IN_CFG_FCS_LBN 4
 #define        MC_CMD_SET_MAC_EXT_IN_CFG_FCS_WIDTH 1
 
@@ -3940,6 +4639,7 @@
  * Returns: 0, ETIME
  */
 #define MC_CMD_PHY_STATS 0x2d
+#undef MC_CMD_0x2d_PRIVILEGE_CTG
 
 #define MC_CMD_0x2d_PRIVILEGE_CTG SRIOV_CTG_LINK
 
@@ -4021,6 +4721,7 @@
  * effect. Returns: 0, ETIME
  */
 #define MC_CMD_MAC_STATS 0x2e
+#undef MC_CMD_0x2e_PRIVILEGE_CTG
 
 #define MC_CMD_0x2e_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -4033,18 +4734,25 @@
 #define       MC_CMD_MAC_STATS_IN_DMA_ADDR_HI_OFST 4
 #define       MC_CMD_MAC_STATS_IN_CMD_OFST 8
 #define       MC_CMD_MAC_STATS_IN_CMD_LEN 4
+#define        MC_CMD_MAC_STATS_IN_DMA_OFST 8
 #define        MC_CMD_MAC_STATS_IN_DMA_LBN 0
 #define        MC_CMD_MAC_STATS_IN_DMA_WIDTH 1
+#define        MC_CMD_MAC_STATS_IN_CLEAR_OFST 8
 #define        MC_CMD_MAC_STATS_IN_CLEAR_LBN 1
 #define        MC_CMD_MAC_STATS_IN_CLEAR_WIDTH 1
+#define        MC_CMD_MAC_STATS_IN_PERIODIC_CHANGE_OFST 8
 #define        MC_CMD_MAC_STATS_IN_PERIODIC_CHANGE_LBN 2
 #define        MC_CMD_MAC_STATS_IN_PERIODIC_CHANGE_WIDTH 1
+#define        MC_CMD_MAC_STATS_IN_PERIODIC_ENABLE_OFST 8
 #define        MC_CMD_MAC_STATS_IN_PERIODIC_ENABLE_LBN 3
 #define        MC_CMD_MAC_STATS_IN_PERIODIC_ENABLE_WIDTH 1
+#define        MC_CMD_MAC_STATS_IN_PERIODIC_CLEAR_OFST 8
 #define        MC_CMD_MAC_STATS_IN_PERIODIC_CLEAR_LBN 4
 #define        MC_CMD_MAC_STATS_IN_PERIODIC_CLEAR_WIDTH 1
+#define        MC_CMD_MAC_STATS_IN_PERIODIC_NOEVENT_OFST 8
 #define        MC_CMD_MAC_STATS_IN_PERIODIC_NOEVENT_LBN 5
 #define        MC_CMD_MAC_STATS_IN_PERIODIC_NOEVENT_WIDTH 1
+#define        MC_CMD_MAC_STATS_IN_PERIOD_MS_OFST 8
 #define        MC_CMD_MAC_STATS_IN_PERIOD_MS_LBN 16
 #define        MC_CMD_MAC_STATS_IN_PERIOD_MS_WIDTH 16
 /* DMA length. Should be set to MAC_STATS_NUM_STATS * sizeof(uint64_t), as
@@ -4321,6 +5029,37 @@
 /*            Other enum values, see field(s): */
 /*               MC_CMD_MAC_STATS_V2_OUT_NO_DMA/STATISTICS */
 
+/* MC_CMD_MAC_STATS_V4_OUT_DMA msgresponse */
+#define    MC_CMD_MAC_STATS_V4_OUT_DMA_LEN 0
+
+/* MC_CMD_MAC_STATS_V4_OUT_NO_DMA msgresponse */
+#define    MC_CMD_MAC_STATS_V4_OUT_NO_DMA_LEN (((MC_CMD_MAC_NSTATS_V4*64))>>3)
+#define       MC_CMD_MAC_STATS_V4_OUT_NO_DMA_STATISTICS_OFST 0
+#define       MC_CMD_MAC_STATS_V4_OUT_NO_DMA_STATISTICS_LEN 8
+#define       MC_CMD_MAC_STATS_V4_OUT_NO_DMA_STATISTICS_LO_OFST 0
+#define       MC_CMD_MAC_STATS_V4_OUT_NO_DMA_STATISTICS_HI_OFST 4
+#define       MC_CMD_MAC_STATS_V4_OUT_NO_DMA_STATISTICS_NUM MC_CMD_MAC_NSTATS_V4
+/* enum: Start of V4 stats buffer space */
+#define          MC_CMD_MAC_V4_DMABUF_START 0x79
+/* enum: RXDP counter: Number of packets truncated because scattering was
+ * disabled.
+ */
+#define          MC_CMD_MAC_RXDP_SCATTER_DISABLED_TRUNC 0x79
+/* enum: RXDP counter: Number of times the RXDP head of line blocked waiting
+ * for descriptors. Will be zero unless RXDP_HLB_IDLE capability is set.
+ */
+#define          MC_CMD_MAC_RXDP_HLB_IDLE 0x7a
+/* enum: RXDP counter: Number of times the RXDP timed out while head of line
+ * blocking. Will be zero unless RXDP_HLB_IDLE capability is set.
+ */
+#define          MC_CMD_MAC_RXDP_HLB_TIMEOUT 0x7b
+/* enum: This includes the space at offset 124 which is the final
+ * GENERATION_END in a MAC_STATS_V4 response and otherwise unused.
+ */
+#define          MC_CMD_MAC_NSTATS_V4 0x7d
+/*            Other enum values, see field(s): */
+/*               MC_CMD_MAC_STATS_V3_OUT_NO_DMA/STATISTICS */
+
 
 /***********************************/
 /* MC_CMD_SRIOV
@@ -4403,12 +5142,15 @@
 /* MC_CMD_MEMCPY_IN msgrequest */
 #define    MC_CMD_MEMCPY_IN_LENMIN 32
 #define    MC_CMD_MEMCPY_IN_LENMAX 224
+#define    MC_CMD_MEMCPY_IN_LENMAX_MCDI2 992
 #define    MC_CMD_MEMCPY_IN_LEN(num) (0+32*(num))
+#define    MC_CMD_MEMCPY_IN_RECORD_NUM(len) (((len)-0)/32)
 /* see MC_CMD_MEMCPY_RECORD_TYPEDEF */
 #define       MC_CMD_MEMCPY_IN_RECORD_OFST 0
 #define       MC_CMD_MEMCPY_IN_RECORD_LEN 32
 #define       MC_CMD_MEMCPY_IN_RECORD_MINNUM 1
 #define       MC_CMD_MEMCPY_IN_RECORD_MAXNUM 7
+#define       MC_CMD_MEMCPY_IN_RECORD_MAXNUM_MCDI2 31
 
 /* MC_CMD_MEMCPY_OUT msgresponse */
 #define    MC_CMD_MEMCPY_OUT_LEN 0
@@ -4419,6 +5161,7 @@
  * Set a WoL filter.
  */
 #define MC_CMD_WOL_FILTER_SET 0x32
+#undef MC_CMD_0x32_PRIVILEGE_CTG
 
 #define MC_CMD_0x32_PRIVILEGE_CTG SRIOV_CTG_LINK
 
@@ -4515,8 +5258,10 @@
 /*            MC_CMD_WOL_FILTER_SET_IN_WOL_TYPE_LEN 4 */
 #define       MC_CMD_WOL_FILTER_SET_IN_LINK_MASK_OFST 8
 #define       MC_CMD_WOL_FILTER_SET_IN_LINK_MASK_LEN 4
+#define        MC_CMD_WOL_FILTER_SET_IN_LINK_UP_OFST 8
 #define        MC_CMD_WOL_FILTER_SET_IN_LINK_UP_LBN 0
 #define        MC_CMD_WOL_FILTER_SET_IN_LINK_UP_WIDTH 1
+#define        MC_CMD_WOL_FILTER_SET_IN_LINK_DOWN_OFST 8
 #define        MC_CMD_WOL_FILTER_SET_IN_LINK_DOWN_LBN 1
 #define        MC_CMD_WOL_FILTER_SET_IN_LINK_DOWN_WIDTH 1
 
@@ -4531,6 +5276,7 @@
  * Remove a WoL filter. Locks required: None. Returns: 0, EINVAL, ENOSYS
  */
 #define MC_CMD_WOL_FILTER_REMOVE 0x33
+#undef MC_CMD_0x33_PRIVILEGE_CTG
 
 #define MC_CMD_0x33_PRIVILEGE_CTG SRIOV_CTG_LINK
 
@@ -4549,6 +5295,7 @@
  * ENOSYS
  */
 #define MC_CMD_WOL_FILTER_RESET 0x34
+#undef MC_CMD_0x34_PRIVILEGE_CTG
 
 #define MC_CMD_0x34_PRIVILEGE_CTG SRIOV_CTG_LINK
 
@@ -4586,6 +5333,7 @@
  * Locks required: none. Returns: 0
  */
 #define MC_CMD_NVRAM_TYPES 0x36
+#undef MC_CMD_0x36_PRIVILEGE_CTG
 
 #define MC_CMD_0x36_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
@@ -4647,6 +5395,7 @@
  * EINVAL (bad type).
  */
 #define MC_CMD_NVRAM_INFO 0x37
+#undef MC_CMD_0x37_PRIVILEGE_CTG
 
 #define MC_CMD_0x37_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
@@ -4669,16 +5418,25 @@
 #define       MC_CMD_NVRAM_INFO_OUT_ERASESIZE_LEN 4
 #define       MC_CMD_NVRAM_INFO_OUT_FLAGS_OFST 12
 #define       MC_CMD_NVRAM_INFO_OUT_FLAGS_LEN 4
+#define        MC_CMD_NVRAM_INFO_OUT_PROTECTED_OFST 12
 #define        MC_CMD_NVRAM_INFO_OUT_PROTECTED_LBN 0
 #define        MC_CMD_NVRAM_INFO_OUT_PROTECTED_WIDTH 1
+#define        MC_CMD_NVRAM_INFO_OUT_TLV_OFST 12
 #define        MC_CMD_NVRAM_INFO_OUT_TLV_LBN 1
 #define        MC_CMD_NVRAM_INFO_OUT_TLV_WIDTH 1
+#define        MC_CMD_NVRAM_INFO_OUT_READ_ONLY_IF_TSA_BOUND_OFST 12
 #define        MC_CMD_NVRAM_INFO_OUT_READ_ONLY_IF_TSA_BOUND_LBN 2
 #define        MC_CMD_NVRAM_INFO_OUT_READ_ONLY_IF_TSA_BOUND_WIDTH 1
+#define        MC_CMD_NVRAM_INFO_OUT_CRC_OFST 12
+#define        MC_CMD_NVRAM_INFO_OUT_CRC_LBN 3
+#define        MC_CMD_NVRAM_INFO_OUT_CRC_WIDTH 1
+#define        MC_CMD_NVRAM_INFO_OUT_READ_ONLY_OFST 12
 #define        MC_CMD_NVRAM_INFO_OUT_READ_ONLY_LBN 5
 #define        MC_CMD_NVRAM_INFO_OUT_READ_ONLY_WIDTH 1
+#define        MC_CMD_NVRAM_INFO_OUT_CMAC_OFST 12
 #define        MC_CMD_NVRAM_INFO_OUT_CMAC_LBN 6
 #define        MC_CMD_NVRAM_INFO_OUT_CMAC_WIDTH 1
+#define        MC_CMD_NVRAM_INFO_OUT_A_B_OFST 12
 #define        MC_CMD_NVRAM_INFO_OUT_A_B_LBN 7
 #define        MC_CMD_NVRAM_INFO_OUT_A_B_WIDTH 1
 #define       MC_CMD_NVRAM_INFO_OUT_PHYSDEV_OFST 16
@@ -4698,14 +5456,19 @@
 #define       MC_CMD_NVRAM_INFO_V2_OUT_ERASESIZE_LEN 4
 #define       MC_CMD_NVRAM_INFO_V2_OUT_FLAGS_OFST 12
 #define       MC_CMD_NVRAM_INFO_V2_OUT_FLAGS_LEN 4
+#define        MC_CMD_NVRAM_INFO_V2_OUT_PROTECTED_OFST 12
 #define        MC_CMD_NVRAM_INFO_V2_OUT_PROTECTED_LBN 0
 #define        MC_CMD_NVRAM_INFO_V2_OUT_PROTECTED_WIDTH 1
+#define        MC_CMD_NVRAM_INFO_V2_OUT_TLV_OFST 12
 #define        MC_CMD_NVRAM_INFO_V2_OUT_TLV_LBN 1
 #define        MC_CMD_NVRAM_INFO_V2_OUT_TLV_WIDTH 1
+#define        MC_CMD_NVRAM_INFO_V2_OUT_READ_ONLY_IF_TSA_BOUND_OFST 12
 #define        MC_CMD_NVRAM_INFO_V2_OUT_READ_ONLY_IF_TSA_BOUND_LBN 2
 #define        MC_CMD_NVRAM_INFO_V2_OUT_READ_ONLY_IF_TSA_BOUND_WIDTH 1
+#define        MC_CMD_NVRAM_INFO_V2_OUT_READ_ONLY_OFST 12
 #define        MC_CMD_NVRAM_INFO_V2_OUT_READ_ONLY_LBN 5
 #define        MC_CMD_NVRAM_INFO_V2_OUT_READ_ONLY_WIDTH 1
+#define        MC_CMD_NVRAM_INFO_V2_OUT_A_B_OFST 12
 #define        MC_CMD_NVRAM_INFO_V2_OUT_A_B_LBN 7
 #define        MC_CMD_NVRAM_INFO_V2_OUT_A_B_WIDTH 1
 #define       MC_CMD_NVRAM_INFO_V2_OUT_PHYSDEV_OFST 16
@@ -4729,6 +5492,7 @@
  * EPERM.
  */
 #define MC_CMD_NVRAM_UPDATE_START 0x38
+#undef MC_CMD_0x38_PRIVILEGE_CTG
 
 #define MC_CMD_0x38_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
@@ -4753,6 +5517,7 @@
 /*               MC_CMD_NVRAM_TYPES/MC_CMD_NVRAM_TYPES_OUT/TYPES */
 #define       MC_CMD_NVRAM_UPDATE_START_V2_IN_FLAGS_OFST 4
 #define       MC_CMD_NVRAM_UPDATE_START_V2_IN_FLAGS_LEN 4
+#define        MC_CMD_NVRAM_UPDATE_START_V2_IN_FLAG_REPORT_VERIFY_RESULT_OFST 4
 #define        MC_CMD_NVRAM_UPDATE_START_V2_IN_FLAG_REPORT_VERIFY_RESULT_LBN 0
 #define        MC_CMD_NVRAM_UPDATE_START_V2_IN_FLAG_REPORT_VERIFY_RESULT_WIDTH 1
 
@@ -4767,6 +5532,7 @@
  * PHY_LOCK required and not held)
  */
 #define MC_CMD_NVRAM_READ 0x39
+#undef MC_CMD_0x39_PRIVILEGE_CTG
 
 #define MC_CMD_0x39_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
@@ -4820,11 +5586,14 @@
 /* MC_CMD_NVRAM_READ_OUT msgresponse */
 #define    MC_CMD_NVRAM_READ_OUT_LENMIN 1
 #define    MC_CMD_NVRAM_READ_OUT_LENMAX 252
+#define    MC_CMD_NVRAM_READ_OUT_LENMAX_MCDI2 1020
 #define    MC_CMD_NVRAM_READ_OUT_LEN(num) (0+1*(num))
+#define    MC_CMD_NVRAM_READ_OUT_READ_BUFFER_NUM(len) (((len)-0)/1)
 #define       MC_CMD_NVRAM_READ_OUT_READ_BUFFER_OFST 0
 #define       MC_CMD_NVRAM_READ_OUT_READ_BUFFER_LEN 1
 #define       MC_CMD_NVRAM_READ_OUT_READ_BUFFER_MINNUM 1
 #define       MC_CMD_NVRAM_READ_OUT_READ_BUFFER_MAXNUM 252
+#define       MC_CMD_NVRAM_READ_OUT_READ_BUFFER_MAXNUM_MCDI2 1020
 
 
 /***********************************/
@@ -4834,13 +5603,16 @@
  * PHY_LOCK required and not held)
  */
 #define MC_CMD_NVRAM_WRITE 0x3a
+#undef MC_CMD_0x3a_PRIVILEGE_CTG
 
 #define MC_CMD_0x3a_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
 /* MC_CMD_NVRAM_WRITE_IN msgrequest */
 #define    MC_CMD_NVRAM_WRITE_IN_LENMIN 13
 #define    MC_CMD_NVRAM_WRITE_IN_LENMAX 252
+#define    MC_CMD_NVRAM_WRITE_IN_LENMAX_MCDI2 1020
 #define    MC_CMD_NVRAM_WRITE_IN_LEN(num) (12+1*(num))
+#define    MC_CMD_NVRAM_WRITE_IN_WRITE_BUFFER_NUM(len) (((len)-12)/1)
 #define       MC_CMD_NVRAM_WRITE_IN_TYPE_OFST 0
 #define       MC_CMD_NVRAM_WRITE_IN_TYPE_LEN 4
 /*            Enum values, see field(s): */
@@ -4853,6 +5625,7 @@
 #define       MC_CMD_NVRAM_WRITE_IN_WRITE_BUFFER_LEN 1
 #define       MC_CMD_NVRAM_WRITE_IN_WRITE_BUFFER_MINNUM 1
 #define       MC_CMD_NVRAM_WRITE_IN_WRITE_BUFFER_MAXNUM 240
+#define       MC_CMD_NVRAM_WRITE_IN_WRITE_BUFFER_MAXNUM_MCDI2 1008
 
 /* MC_CMD_NVRAM_WRITE_OUT msgresponse */
 #define    MC_CMD_NVRAM_WRITE_OUT_LEN 0
@@ -4865,6 +5638,7 @@
  * PHY_LOCK required and not held)
  */
 #define MC_CMD_NVRAM_ERASE 0x3b
+#undef MC_CMD_0x3b_PRIVILEGE_CTG
 
 #define MC_CMD_0x3b_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
@@ -4894,6 +5668,7 @@
  * the error EPERM.
  */
 #define MC_CMD_NVRAM_UPDATE_FINISH 0x3c
+#undef MC_CMD_0x3c_PRIVILEGE_CTG
 
 #define MC_CMD_0x3c_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
@@ -4922,8 +5697,15 @@
 #define       MC_CMD_NVRAM_UPDATE_FINISH_V2_IN_REBOOT_LEN 4
 #define       MC_CMD_NVRAM_UPDATE_FINISH_V2_IN_FLAGS_OFST 8
 #define       MC_CMD_NVRAM_UPDATE_FINISH_V2_IN_FLAGS_LEN 4
+#define        MC_CMD_NVRAM_UPDATE_FINISH_V2_IN_FLAG_REPORT_VERIFY_RESULT_OFST 8
 #define        MC_CMD_NVRAM_UPDATE_FINISH_V2_IN_FLAG_REPORT_VERIFY_RESULT_LBN 0
 #define        MC_CMD_NVRAM_UPDATE_FINISH_V2_IN_FLAG_REPORT_VERIFY_RESULT_WIDTH 1
+#define        MC_CMD_NVRAM_UPDATE_FINISH_V2_IN_FLAG_RUN_IN_BACKGROUND_OFST 8
+#define        MC_CMD_NVRAM_UPDATE_FINISH_V2_IN_FLAG_RUN_IN_BACKGROUND_LBN 1
+#define        MC_CMD_NVRAM_UPDATE_FINISH_V2_IN_FLAG_RUN_IN_BACKGROUND_WIDTH 1
+#define        MC_CMD_NVRAM_UPDATE_FINISH_V2_IN_FLAG_POLL_VERIFY_RESULT_OFST 8
+#define        MC_CMD_NVRAM_UPDATE_FINISH_V2_IN_FLAG_POLL_VERIFY_RESULT_LBN 2
+#define        MC_CMD_NVRAM_UPDATE_FINISH_V2_IN_FLAG_POLL_VERIFY_RESULT_WIDTH 1
 
 /* MC_CMD_NVRAM_UPDATE_FINISH_OUT msgresponse: Legacy NVRAM_UPDATE_FINISH
  * response. Use NVRAM_UPDATE_FINISH_V2_OUT in new code
@@ -4946,7 +5728,10 @@
  * has completed.
  */
 #define    MC_CMD_NVRAM_UPDATE_FINISH_V2_OUT_LEN 4
-/* Result of nvram update completion processing */
+/* Result of nvram update completion processing. Result codes that indicate an
+ * internal build failure and therefore not expected to be seen by customers in
+ * the field are marked with a prefix 'Internal-error'.
+ */
 #define       MC_CMD_NVRAM_UPDATE_FINISH_V2_OUT_RESULT_CODE_OFST 0
 #define       MC_CMD_NVRAM_UPDATE_FINISH_V2_OUT_RESULT_CODE_LEN 4
 /* enum: Invalid return code; only non-zero values are defined. Defined as
@@ -4985,6 +5770,51 @@
 #define          MC_CMD_NVRAM_VERIFY_RC_REJECT_TEST_SIGNED 0xc
 /* enum: The image has a lower security level than the current firmware. */
 #define          MC_CMD_NVRAM_VERIFY_RC_SECURITY_LEVEL_DOWNGRADE 0xd
+/* enum: Internal-error. The signed image is missing the 'contents' section,
+ * where the 'contents' section holds the actual image payload to be applied.
+ */
+#define          MC_CMD_NVRAM_VERIFY_RC_CONTENT_NOT_FOUND 0xe
+/* enum: Internal-error. The bundle header is invalid. */
+#define          MC_CMD_NVRAM_VERIFY_RC_BUNDLE_CONTENT_HEADER_INVALID 0xf
+/* enum: Internal-error. The bundle does not have a valid reflash image layout.
+ */
+#define          MC_CMD_NVRAM_VERIFY_RC_BUNDLE_REFLASH_IMAGE_INVALID 0x10
+/* enum: Internal-error. The bundle has an inconsistent layout of components or
+ * incorrect checksum.
+ */
+#define          MC_CMD_NVRAM_VERIFY_RC_BUNDLE_IMAGE_LAYOUT_INVALID 0x11
+/* enum: Internal-error. The bundle manifest is inconsistent with components in
+ * the bundle.
+ */
+#define          MC_CMD_NVRAM_VERIFY_RC_BUNDLE_MANIFEST_INVALID 0x12
+/* enum: Internal-error. The number of components in a bundle do not match the
+ * number of components advertised by the bundle manifest.
+ */
+#define          MC_CMD_NVRAM_VERIFY_RC_BUNDLE_MANIFEST_NUM_COMPONENTS_MISMATCH 0x13
+/* enum: Internal-error. The bundle contains too many components for the MC
+ * firmware to process
+ */
+#define          MC_CMD_NVRAM_VERIFY_RC_BUNDLE_MANIFEST_TOO_MANY_COMPONENTS 0x14
+/* enum: Internal-error. The bundle manifest has an invalid/inconsistent
+ * component.
+ */
+#define          MC_CMD_NVRAM_VERIFY_RC_BUNDLE_MANIFEST_COMPONENT_INVALID 0x15
+/* enum: Internal-error. The hash of a component does not match the hash stored
+ * in the bundle manifest.
+ */
+#define          MC_CMD_NVRAM_VERIFY_RC_BUNDLE_MANIFEST_COMPONENT_HASH_MISMATCH 0x16
+/* enum: Internal-error. Component hash calculation failed. */
+#define          MC_CMD_NVRAM_VERIFY_RC_BUNDLE_MANIFEST_COMPONENT_HASH_FAILED 0x17
+/* enum: Internal-error. The component does not have a valid reflash image
+ * layout.
+ */
+#define          MC_CMD_NVRAM_VERIFY_RC_BUNDLE_COMPONENT_REFLASH_IMAGE_INVALID 0x18
+/* enum: The bundle processing code failed to copy a component to its target
+ * partition.
+ */
+#define          MC_CMD_NVRAM_VERIFY_RC_BUNDLE_COMPONENT_COPY_FAILED 0x19
+/* enum: The update operation is in-progress. */
+#define          MC_CMD_NVRAM_VERIFY_RC_PENDING 0x1a
 
 
 /***********************************/
@@ -5006,6 +5836,7 @@
  * DATALEN=0
  */
 #define MC_CMD_REBOOT 0x3d
+#undef MC_CMD_0x3d_PRIVILEGE_CTG
 
 #define MC_CMD_0x3d_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
@@ -5026,6 +5857,7 @@
  * thread address.
  */
 #define MC_CMD_SCHEDINFO 0x3e
+#undef MC_CMD_0x3e_PRIVILEGE_CTG
 
 #define MC_CMD_0x3e_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
@@ -5035,11 +5867,14 @@
 /* MC_CMD_SCHEDINFO_OUT msgresponse */
 #define    MC_CMD_SCHEDINFO_OUT_LENMIN 4
 #define    MC_CMD_SCHEDINFO_OUT_LENMAX 252
+#define    MC_CMD_SCHEDINFO_OUT_LENMAX_MCDI2 1020
 #define    MC_CMD_SCHEDINFO_OUT_LEN(num) (0+4*(num))
+#define    MC_CMD_SCHEDINFO_OUT_DATA_NUM(len) (((len)-0)/4)
 #define       MC_CMD_SCHEDINFO_OUT_DATA_OFST 0
 #define       MC_CMD_SCHEDINFO_OUT_DATA_LEN 4
 #define       MC_CMD_SCHEDINFO_OUT_DATA_MINNUM 1
 #define       MC_CMD_SCHEDINFO_OUT_DATA_MAXNUM 63
+#define       MC_CMD_SCHEDINFO_OUT_DATA_MAXNUM_MCDI2 255
 
 
 /***********************************/
@@ -5048,6 +5883,7 @@
  * mode to the specified value. Returns the old mode.
  */
 #define MC_CMD_REBOOT_MODE 0x3f
+#undef MC_CMD_0x3f_PRIVILEGE_CTG
 
 #define MC_CMD_0x3f_PRIVILEGE_CTG SRIOV_CTG_INSECURE
 
@@ -5063,6 +5899,7 @@
 #define          MC_CMD_REBOOT_MODE_SNAPPER 0x3
 /* enum: snapper fake POR */
 #define          MC_CMD_REBOOT_MODE_SNAPPER_POR 0x4
+#define        MC_CMD_REBOOT_MODE_IN_FAKE_OFST 0
 #define        MC_CMD_REBOOT_MODE_IN_FAKE_LBN 7
 #define        MC_CMD_REBOOT_MODE_IN_FAKE_WIDTH 1
 
@@ -5104,6 +5941,7 @@
  * Locks required: None Returns: 0
  */
 #define MC_CMD_SENSOR_INFO 0x41
+#undef MC_CMD_0x41_PRIVILEGE_CTG
 
 #define MC_CMD_0x41_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -5121,10 +5959,29 @@
 #define       MC_CMD_SENSOR_INFO_EXT_IN_PAGE_OFST 0
 #define       MC_CMD_SENSOR_INFO_EXT_IN_PAGE_LEN 4
 
+/* MC_CMD_SENSOR_INFO_EXT_IN_V2 msgrequest */
+#define    MC_CMD_SENSOR_INFO_EXT_IN_V2_LEN 8
+/* Which page of sensors to report.
+ *
+ * Page 0 contains sensors 0 to 30 (sensor 31 is the next page bit).
+ *
+ * Page 1 contains sensors 32 to 62 (sensor 63 is the next page bit). etc.
+ */
+#define       MC_CMD_SENSOR_INFO_EXT_IN_V2_PAGE_OFST 0
+#define       MC_CMD_SENSOR_INFO_EXT_IN_V2_PAGE_LEN 4
+/* Flags controlling information retrieved */
+#define       MC_CMD_SENSOR_INFO_EXT_IN_V2_FLAGS_OFST 4
+#define       MC_CMD_SENSOR_INFO_EXT_IN_V2_FLAGS_LEN 4
+#define        MC_CMD_SENSOR_INFO_EXT_IN_V2_ENGINEERING_OFST 4
+#define        MC_CMD_SENSOR_INFO_EXT_IN_V2_ENGINEERING_LBN 0
+#define        MC_CMD_SENSOR_INFO_EXT_IN_V2_ENGINEERING_WIDTH 1
+
 /* MC_CMD_SENSOR_INFO_OUT msgresponse */
 #define    MC_CMD_SENSOR_INFO_OUT_LENMIN 4
 #define    MC_CMD_SENSOR_INFO_OUT_LENMAX 252
+#define    MC_CMD_SENSOR_INFO_OUT_LENMAX_MCDI2 1020
 #define    MC_CMD_SENSOR_INFO_OUT_LEN(num) (4+8*(num))
+#define    MC_CMD_SENSOR_INFO_OUT_MC_CMD_SENSOR_ENTRY_NUM(len) (((len)-4)/8)
 #define       MC_CMD_SENSOR_INFO_OUT_MASK_OFST 0
 #define       MC_CMD_SENSOR_INFO_OUT_MASK_LEN 4
 /* enum: Controller temperature: degC */
@@ -5301,6 +6158,22 @@
 #define          MC_CMD_SENSOR_IN_1V3 0x55
 /* enum: 1.3v power current: mA */
 #define          MC_CMD_SENSOR_IN_I1V3 0x56
+/* enum: Engineering sensor 1 */
+#define          MC_CMD_SENSOR_ENGINEERING_1 0x57
+/* enum: Engineering sensor 2 */
+#define          MC_CMD_SENSOR_ENGINEERING_2 0x58
+/* enum: Engineering sensor 3 */
+#define          MC_CMD_SENSOR_ENGINEERING_3 0x59
+/* enum: Engineering sensor 4 */
+#define          MC_CMD_SENSOR_ENGINEERING_4 0x5a
+/* enum: Engineering sensor 5 */
+#define          MC_CMD_SENSOR_ENGINEERING_5 0x5b
+/* enum: Engineering sensor 6 */
+#define          MC_CMD_SENSOR_ENGINEERING_6 0x5c
+/* enum: Engineering sensor 7 */
+#define          MC_CMD_SENSOR_ENGINEERING_7 0x5d
+/* enum: Engineering sensor 8 */
+#define          MC_CMD_SENSOR_ENGINEERING_8 0x5e
 /* enum: Not a sensor: reserved for the next page flag */
 #define          MC_CMD_SENSOR_PAGE2_NEXT 0x5f
 /* MC_CMD_SENSOR_INFO_ENTRY_TYPEDEF */
@@ -5310,15 +6183,19 @@
 #define       MC_CMD_SENSOR_ENTRY_HI_OFST 8
 #define       MC_CMD_SENSOR_ENTRY_MINNUM 0
 #define       MC_CMD_SENSOR_ENTRY_MAXNUM 31
+#define       MC_CMD_SENSOR_ENTRY_MAXNUM_MCDI2 127
 
 /* MC_CMD_SENSOR_INFO_EXT_OUT msgresponse */
 #define    MC_CMD_SENSOR_INFO_EXT_OUT_LENMIN 4
 #define    MC_CMD_SENSOR_INFO_EXT_OUT_LENMAX 252
+#define    MC_CMD_SENSOR_INFO_EXT_OUT_LENMAX_MCDI2 1020
 #define    MC_CMD_SENSOR_INFO_EXT_OUT_LEN(num) (4+8*(num))
+#define    MC_CMD_SENSOR_INFO_EXT_OUT_MC_CMD_SENSOR_ENTRY_NUM(len) (((len)-4)/8)
 #define       MC_CMD_SENSOR_INFO_EXT_OUT_MASK_OFST 0
 #define       MC_CMD_SENSOR_INFO_EXT_OUT_MASK_LEN 4
 /*            Enum values, see field(s): */
 /*               MC_CMD_SENSOR_INFO_OUT */
+#define        MC_CMD_SENSOR_INFO_EXT_OUT_NEXT_PAGE_OFST 0
 #define        MC_CMD_SENSOR_INFO_EXT_OUT_NEXT_PAGE_LBN 31
 #define        MC_CMD_SENSOR_INFO_EXT_OUT_NEXT_PAGE_WIDTH 1
 /* MC_CMD_SENSOR_INFO_ENTRY_TYPEDEF */
@@ -5328,6 +6205,7 @@
 /*            MC_CMD_SENSOR_ENTRY_HI_OFST 8 */
 /*            MC_CMD_SENSOR_ENTRY_MINNUM 0 */
 /*            MC_CMD_SENSOR_ENTRY_MAXNUM 31 */
+/*            MC_CMD_SENSOR_ENTRY_MAXNUM_MCDI2 127 */
 
 /* MC_CMD_SENSOR_INFO_ENTRY_TYPEDEF structuredef */
 #define    MC_CMD_SENSOR_INFO_ENTRY_TYPEDEF_LEN 8
@@ -5367,12 +6245,17 @@
  * STATE_WARNING. Otherwise the board should not be expected to function.
  */
 #define MC_CMD_READ_SENSORS 0x42
+#undef MC_CMD_0x42_PRIVILEGE_CTG
 
 #define MC_CMD_0x42_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
 /* MC_CMD_READ_SENSORS_IN msgrequest */
 #define    MC_CMD_READ_SENSORS_IN_LEN 8
-/* DMA address of host buffer for sensor readings (must be 4Kbyte aligned). */
+/* DMA address of host buffer for sensor readings (must be 4Kbyte aligned).
+ *
+ * If the address is 0xffffffffffffffff send the readings in the response (used
+ * by cmdclient).
+ */
 #define       MC_CMD_READ_SENSORS_IN_DMA_ADDR_OFST 0
 #define       MC_CMD_READ_SENSORS_IN_DMA_ADDR_LEN 8
 #define       MC_CMD_READ_SENSORS_IN_DMA_ADDR_LO_OFST 0
@@ -5380,7 +6263,11 @@
 
 /* MC_CMD_READ_SENSORS_EXT_IN msgrequest */
 #define    MC_CMD_READ_SENSORS_EXT_IN_LEN 12
-/* DMA address of host buffer for sensor readings (must be 4Kbyte aligned). */
+/* DMA address of host buffer for sensor readings (must be 4Kbyte aligned).
+ *
+ * If the address is 0xffffffffffffffff send the readings in the response (used
+ * by cmdclient).
+ */
 #define       MC_CMD_READ_SENSORS_EXT_IN_DMA_ADDR_OFST 0
 #define       MC_CMD_READ_SENSORS_EXT_IN_DMA_ADDR_LEN 8
 #define       MC_CMD_READ_SENSORS_EXT_IN_DMA_ADDR_LO_OFST 0
@@ -5389,6 +6276,27 @@
 #define       MC_CMD_READ_SENSORS_EXT_IN_LENGTH_OFST 8
 #define       MC_CMD_READ_SENSORS_EXT_IN_LENGTH_LEN 4
 
+/* MC_CMD_READ_SENSORS_EXT_IN_V2 msgrequest */
+#define    MC_CMD_READ_SENSORS_EXT_IN_V2_LEN 16
+/* DMA address of host buffer for sensor readings (must be 4Kbyte aligned).
+ *
+ * If the address is 0xffffffffffffffff send the readings in the response (used
+ * by cmdclient).
+ */
+#define       MC_CMD_READ_SENSORS_EXT_IN_V2_DMA_ADDR_OFST 0
+#define       MC_CMD_READ_SENSORS_EXT_IN_V2_DMA_ADDR_LEN 8
+#define       MC_CMD_READ_SENSORS_EXT_IN_V2_DMA_ADDR_LO_OFST 0
+#define       MC_CMD_READ_SENSORS_EXT_IN_V2_DMA_ADDR_HI_OFST 4
+/* Size in bytes of host buffer. */
+#define       MC_CMD_READ_SENSORS_EXT_IN_V2_LENGTH_OFST 8
+#define       MC_CMD_READ_SENSORS_EXT_IN_V2_LENGTH_LEN 4
+/* Flags controlling information retrieved */
+#define       MC_CMD_READ_SENSORS_EXT_IN_V2_FLAGS_OFST 12
+#define       MC_CMD_READ_SENSORS_EXT_IN_V2_FLAGS_LEN 4
+#define        MC_CMD_READ_SENSORS_EXT_IN_V2_ENGINEERING_OFST 12
+#define        MC_CMD_READ_SENSORS_EXT_IN_V2_ENGINEERING_LBN 0
+#define        MC_CMD_READ_SENSORS_EXT_IN_V2_ENGINEERING_WIDTH 1
+
 /* MC_CMD_READ_SENSORS_OUT msgresponse */
 #define    MC_CMD_READ_SENSORS_OUT_LEN 0
 
@@ -5432,6 +6340,7 @@
  * code: 0
  */
 #define MC_CMD_GET_PHY_STATE 0x43
+#undef MC_CMD_0x43_PRIVILEGE_CTG
 
 #define MC_CMD_0x43_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -5469,6 +6378,7 @@
  * Retrieve ID of any WoL filters. Locks required: None. Returns: 0, ENOSYS
  */
 #define MC_CMD_WOL_FILTER_GET 0x45
+#undef MC_CMD_0x45_PRIVILEGE_CTG
 
 #define MC_CMD_0x45_PRIVILEGE_CTG SRIOV_CTG_LINK
 
@@ -5487,13 +6397,16 @@
  * Returns: 0, ENOSYS
  */
 #define MC_CMD_ADD_LIGHTSOUT_OFFLOAD 0x46
+#undef MC_CMD_0x46_PRIVILEGE_CTG
 
 #define MC_CMD_0x46_PRIVILEGE_CTG SRIOV_CTG_LINK
 
 /* MC_CMD_ADD_LIGHTSOUT_OFFLOAD_IN msgrequest */
 #define    MC_CMD_ADD_LIGHTSOUT_OFFLOAD_IN_LENMIN 8
 #define    MC_CMD_ADD_LIGHTSOUT_OFFLOAD_IN_LENMAX 252
+#define    MC_CMD_ADD_LIGHTSOUT_OFFLOAD_IN_LENMAX_MCDI2 1020
 #define    MC_CMD_ADD_LIGHTSOUT_OFFLOAD_IN_LEN(num) (4+4*(num))
+#define    MC_CMD_ADD_LIGHTSOUT_OFFLOAD_IN_DATA_NUM(len) (((len)-4)/4)
 #define       MC_CMD_ADD_LIGHTSOUT_OFFLOAD_IN_PROTOCOL_OFST 0
 #define       MC_CMD_ADD_LIGHTSOUT_OFFLOAD_IN_PROTOCOL_LEN 4
 #define          MC_CMD_LIGHTSOUT_OFFLOAD_PROTOCOL_ARP 0x1 /* enum */
@@ -5502,6 +6415,7 @@
 #define       MC_CMD_ADD_LIGHTSOUT_OFFLOAD_IN_DATA_LEN 4
 #define       MC_CMD_ADD_LIGHTSOUT_OFFLOAD_IN_DATA_MINNUM 1
 #define       MC_CMD_ADD_LIGHTSOUT_OFFLOAD_IN_DATA_MAXNUM 62
+#define       MC_CMD_ADD_LIGHTSOUT_OFFLOAD_IN_DATA_MAXNUM_MCDI2 254
 
 /* MC_CMD_ADD_LIGHTSOUT_OFFLOAD_IN_ARP msgrequest */
 #define    MC_CMD_ADD_LIGHTSOUT_OFFLOAD_IN_ARP_LEN 14
@@ -5535,6 +6449,7 @@
  * None. Returns: 0, ENOSYS
  */
 #define MC_CMD_REMOVE_LIGHTSOUT_OFFLOAD 0x47
+#undef MC_CMD_0x47_PRIVILEGE_CTG
 
 #define MC_CMD_0x47_PRIVILEGE_CTG SRIOV_CTG_LINK
 
@@ -5569,6 +6484,7 @@
  * required: None Returns: 0
  */
 #define MC_CMD_TESTASSERT 0x49
+#undef MC_CMD_0x49_PRIVILEGE_CTG
 
 #define MC_CMD_0x49_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
@@ -5611,6 +6527,7 @@
  * basis. Locks required: None. Returns: 0, EINVAL .
  */
 #define MC_CMD_WORKAROUND 0x4a
+#undef MC_CMD_0x4a_PRIVILEGE_CTG
 
 #define MC_CMD_0x4a_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
@@ -5658,6 +6575,7 @@
 #define    MC_CMD_WORKAROUND_EXT_OUT_LEN 4
 #define       MC_CMD_WORKAROUND_EXT_OUT_FLAGS_OFST 0
 #define       MC_CMD_WORKAROUND_EXT_OUT_FLAGS_LEN 4
+#define        MC_CMD_WORKAROUND_EXT_OUT_FLR_DONE_OFST 0
 #define        MC_CMD_WORKAROUND_EXT_OUT_FLR_DONE_LBN 0
 #define        MC_CMD_WORKAROUND_EXT_OUT_FLR_DONE_WIDTH 1
 
@@ -5672,6 +6590,7 @@
  * Anything else: currently undefined. Locks required: None. Return code: 0.
  */
 #define MC_CMD_GET_PHY_MEDIA_INFO 0x4b
+#undef MC_CMD_0x4b_PRIVILEGE_CTG
 
 #define MC_CMD_0x4b_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
@@ -5683,7 +6602,9 @@
 /* MC_CMD_GET_PHY_MEDIA_INFO_OUT msgresponse */
 #define    MC_CMD_GET_PHY_MEDIA_INFO_OUT_LENMIN 5
 #define    MC_CMD_GET_PHY_MEDIA_INFO_OUT_LENMAX 252
+#define    MC_CMD_GET_PHY_MEDIA_INFO_OUT_LENMAX_MCDI2 1020
 #define    MC_CMD_GET_PHY_MEDIA_INFO_OUT_LEN(num) (4+1*(num))
+#define    MC_CMD_GET_PHY_MEDIA_INFO_OUT_DATA_NUM(len) (((len)-4)/1)
 /* in bytes */
 #define       MC_CMD_GET_PHY_MEDIA_INFO_OUT_DATALEN_OFST 0
 #define       MC_CMD_GET_PHY_MEDIA_INFO_OUT_DATALEN_LEN 4
@@ -5691,6 +6612,7 @@
 #define       MC_CMD_GET_PHY_MEDIA_INFO_OUT_DATA_LEN 1
 #define       MC_CMD_GET_PHY_MEDIA_INFO_OUT_DATA_MINNUM 1
 #define       MC_CMD_GET_PHY_MEDIA_INFO_OUT_DATA_MAXNUM 248
+#define       MC_CMD_GET_PHY_MEDIA_INFO_OUT_DATA_MAXNUM_MCDI2 1016
 
 
 /***********************************/
@@ -5699,6 +6621,7 @@
  * on the type of partition).
  */
 #define MC_CMD_NVRAM_TEST 0x4c
+#undef MC_CMD_0x4c_PRIVILEGE_CTG
 
 #define MC_CMD_0x4c_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
@@ -5771,6 +6694,7 @@
  * of range.
  */
 #define MC_CMD_SENSOR_SET_LIMS 0x4e
+#undef MC_CMD_0x4e_PRIVILEGE_CTG
 
 #define MC_CMD_0x4e_PRIVILEGE_CTG SRIOV_CTG_INSECURE
 
@@ -5823,6 +6747,7 @@
  * none. Returns: 0, EINVAL (bad type).
  */
 #define MC_CMD_NVRAM_PARTITIONS 0x51
+#undef MC_CMD_0x51_PRIVILEGE_CTG
 
 #define MC_CMD_0x51_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
@@ -5832,7 +6757,9 @@
 /* MC_CMD_NVRAM_PARTITIONS_OUT msgresponse */
 #define    MC_CMD_NVRAM_PARTITIONS_OUT_LENMIN 4
 #define    MC_CMD_NVRAM_PARTITIONS_OUT_LENMAX 252
+#define    MC_CMD_NVRAM_PARTITIONS_OUT_LENMAX_MCDI2 1020
 #define    MC_CMD_NVRAM_PARTITIONS_OUT_LEN(num) (4+4*(num))
+#define    MC_CMD_NVRAM_PARTITIONS_OUT_TYPE_ID_NUM(len) (((len)-4)/4)
 /* total number of partitions */
 #define       MC_CMD_NVRAM_PARTITIONS_OUT_NUM_PARTITIONS_OFST 0
 #define       MC_CMD_NVRAM_PARTITIONS_OUT_NUM_PARTITIONS_LEN 4
@@ -5841,6 +6768,7 @@
 #define       MC_CMD_NVRAM_PARTITIONS_OUT_TYPE_ID_LEN 4
 #define       MC_CMD_NVRAM_PARTITIONS_OUT_TYPE_ID_MINNUM 0
 #define       MC_CMD_NVRAM_PARTITIONS_OUT_TYPE_ID_MAXNUM 62
+#define       MC_CMD_NVRAM_PARTITIONS_OUT_TYPE_ID_MAXNUM_MCDI2 254
 
 
 /***********************************/
@@ -5849,6 +6777,7 @@
  * none. Returns: 0, EINVAL (bad type).
  */
 #define MC_CMD_NVRAM_METADATA 0x52
+#undef MC_CMD_0x52_PRIVILEGE_CTG
 
 #define MC_CMD_0x52_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
@@ -5861,16 +6790,21 @@
 /* MC_CMD_NVRAM_METADATA_OUT msgresponse */
 #define    MC_CMD_NVRAM_METADATA_OUT_LENMIN 20
 #define    MC_CMD_NVRAM_METADATA_OUT_LENMAX 252
+#define    MC_CMD_NVRAM_METADATA_OUT_LENMAX_MCDI2 1020
 #define    MC_CMD_NVRAM_METADATA_OUT_LEN(num) (20+1*(num))
+#define    MC_CMD_NVRAM_METADATA_OUT_DESCRIPTION_NUM(len) (((len)-20)/1)
 /* Partition type ID code */
 #define       MC_CMD_NVRAM_METADATA_OUT_TYPE_OFST 0
 #define       MC_CMD_NVRAM_METADATA_OUT_TYPE_LEN 4
 #define       MC_CMD_NVRAM_METADATA_OUT_FLAGS_OFST 4
 #define       MC_CMD_NVRAM_METADATA_OUT_FLAGS_LEN 4
+#define        MC_CMD_NVRAM_METADATA_OUT_SUBTYPE_VALID_OFST 4
 #define        MC_CMD_NVRAM_METADATA_OUT_SUBTYPE_VALID_LBN 0
 #define        MC_CMD_NVRAM_METADATA_OUT_SUBTYPE_VALID_WIDTH 1
+#define        MC_CMD_NVRAM_METADATA_OUT_VERSION_VALID_OFST 4
 #define        MC_CMD_NVRAM_METADATA_OUT_VERSION_VALID_LBN 1
 #define        MC_CMD_NVRAM_METADATA_OUT_VERSION_VALID_WIDTH 1
+#define        MC_CMD_NVRAM_METADATA_OUT_DESCRIPTION_VALID_OFST 4
 #define        MC_CMD_NVRAM_METADATA_OUT_DESCRIPTION_VALID_LBN 2
 #define        MC_CMD_NVRAM_METADATA_OUT_DESCRIPTION_VALID_WIDTH 1
 /* Subtype ID code for content of this partition */
@@ -5893,6 +6827,7 @@
 #define       MC_CMD_NVRAM_METADATA_OUT_DESCRIPTION_LEN 1
 #define       MC_CMD_NVRAM_METADATA_OUT_DESCRIPTION_MINNUM 0
 #define       MC_CMD_NVRAM_METADATA_OUT_DESCRIPTION_MAXNUM 232
+#define       MC_CMD_NVRAM_METADATA_OUT_DESCRIPTION_MAXNUM_MCDI2 1000
 
 
 /***********************************/
@@ -5900,6 +6835,7 @@
  * Returns the base MAC, count and stride for the requesting function
  */
 #define MC_CMD_GET_MAC_ADDRESSES 0x55
+#undef MC_CMD_0x55_PRIVILEGE_CTG
 
 #define MC_CMD_0x55_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -5924,9 +6860,13 @@
 
 /***********************************/
 /* MC_CMD_CLP
- * Perform a CLP related operation
+ * Perform a CLP related operation, see SF-110495-PS for details of CLP
+ * processing. This command has been extended to accomodate the requirements of
+ * different manufacturers which are to be found in SF-119187-TC, SF-119186-TC,
+ * SF-120509-TC and SF-117282-PS.
  */
 #define MC_CMD_CLP 0x56
+#undef MC_CMD_0x56_PRIVILEGE_CTG
 
 #define MC_CMD_0x56_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
@@ -5961,7 +6901,10 @@
 #define    MC_CMD_CLP_IN_SET_MAC_LEN 12
 /*            MC_CMD_CLP_IN_OP_OFST 0 */
 /*            MC_CMD_CLP_IN_OP_LEN 4 */
-/* MAC address assigned to port */
+/* The MAC address assigned to port. A zero MAC address of 00:00:00:00:00:00
+ * restores the permanent (factory-programmed) MAC address associated with the
+ * port. A non-zero MAC address persists until a PCIe reset or a power cycle.
+ */
 #define       MC_CMD_CLP_IN_SET_MAC_ADDR_OFST 4
 #define       MC_CMD_CLP_IN_SET_MAC_ADDR_LEN 6
 /* Padding */
@@ -5971,11 +6914,40 @@
 /* MC_CMD_CLP_OUT_SET_MAC msgresponse */
 #define    MC_CMD_CLP_OUT_SET_MAC_LEN 0
 
+/* MC_CMD_CLP_IN_SET_MAC_V2 msgrequest */
+#define    MC_CMD_CLP_IN_SET_MAC_V2_LEN 16
+/*            MC_CMD_CLP_IN_OP_OFST 0 */
+/*            MC_CMD_CLP_IN_OP_LEN 4 */
+/* The MAC address assigned to port. A zero MAC address of 00:00:00:00:00:00
+ * restores the permanent (factory-programmed) MAC address associated with the
+ * port. A non-zero MAC address persists until a PCIe reset or a power cycle.
+ */
+#define       MC_CMD_CLP_IN_SET_MAC_V2_ADDR_OFST 4
+#define       MC_CMD_CLP_IN_SET_MAC_V2_ADDR_LEN 6
+/* Padding */
+#define       MC_CMD_CLP_IN_SET_MAC_V2_RESERVED_OFST 10
+#define       MC_CMD_CLP_IN_SET_MAC_V2_RESERVED_LEN 2
+#define       MC_CMD_CLP_IN_SET_MAC_V2_FLAGS_OFST 12
+#define       MC_CMD_CLP_IN_SET_MAC_V2_FLAGS_LEN 4
+#define        MC_CMD_CLP_IN_SET_MAC_V2_VIRTUAL_OFST 12
+#define        MC_CMD_CLP_IN_SET_MAC_V2_VIRTUAL_LBN 0
+#define        MC_CMD_CLP_IN_SET_MAC_V2_VIRTUAL_WIDTH 1
+
 /* MC_CMD_CLP_IN_GET_MAC msgrequest */
 #define    MC_CMD_CLP_IN_GET_MAC_LEN 4
 /*            MC_CMD_CLP_IN_OP_OFST 0 */
 /*            MC_CMD_CLP_IN_OP_LEN 4 */
 
+/* MC_CMD_CLP_IN_GET_MAC_V2 msgrequest */
+#define    MC_CMD_CLP_IN_GET_MAC_V2_LEN 8
+/*            MC_CMD_CLP_IN_OP_OFST 0 */
+/*            MC_CMD_CLP_IN_OP_LEN 4 */
+#define       MC_CMD_CLP_IN_GET_MAC_V2_FLAGS_OFST 4
+#define       MC_CMD_CLP_IN_GET_MAC_V2_FLAGS_LEN 4
+#define        MC_CMD_CLP_IN_GET_MAC_V2_PERMANENT_OFST 4
+#define        MC_CMD_CLP_IN_GET_MAC_V2_PERMANENT_LBN 0
+#define        MC_CMD_CLP_IN_GET_MAC_V2_PERMANENT_WIDTH 1
+
 /* MC_CMD_CLP_OUT_GET_MAC msgresponse */
 #define    MC_CMD_CLP_OUT_GET_MAC_LEN 8
 /* MAC address assigned to port */
@@ -6016,6 +6988,7 @@
  * Perform a MUM operation
  */
 #define MC_CMD_MUM 0x57
+#undef MC_CMD_0x57_PRIVILEGE_CTG
 
 #define MC_CMD_0x57_PRIVILEGE_CTG SRIOV_CTG_INSECURE
 
@@ -6023,6 +6996,7 @@
 #define    MC_CMD_MUM_IN_LEN 4
 #define       MC_CMD_MUM_IN_OP_HDR_OFST 0
 #define       MC_CMD_MUM_IN_OP_HDR_LEN 4
+#define        MC_CMD_MUM_IN_OP_OFST 0
 #define        MC_CMD_MUM_IN_OP_LBN 0
 #define        MC_CMD_MUM_IN_OP_WIDTH 8
 /* enum: NULL MCDI command to MUM */
@@ -6092,7 +7066,9 @@
 /* MC_CMD_MUM_IN_WRITE msgrequest */
 #define    MC_CMD_MUM_IN_WRITE_LENMIN 16
 #define    MC_CMD_MUM_IN_WRITE_LENMAX 252
+#define    MC_CMD_MUM_IN_WRITE_LENMAX_MCDI2 1020
 #define    MC_CMD_MUM_IN_WRITE_LEN(num) (12+4*(num))
+#define    MC_CMD_MUM_IN_WRITE_BUFFER_NUM(len) (((len)-12)/4)
 /* MUM cmd header */
 /*            MC_CMD_MUM_IN_CMD_OFST 0 */
 /*            MC_CMD_MUM_IN_CMD_LEN 4 */
@@ -6109,11 +7085,14 @@
 #define       MC_CMD_MUM_IN_WRITE_BUFFER_LEN 4
 #define       MC_CMD_MUM_IN_WRITE_BUFFER_MINNUM 1
 #define       MC_CMD_MUM_IN_WRITE_BUFFER_MAXNUM 60
+#define       MC_CMD_MUM_IN_WRITE_BUFFER_MAXNUM_MCDI2 252
 
 /* MC_CMD_MUM_IN_RAW_CMD msgrequest */
 #define    MC_CMD_MUM_IN_RAW_CMD_LENMIN 17
 #define    MC_CMD_MUM_IN_RAW_CMD_LENMAX 252
+#define    MC_CMD_MUM_IN_RAW_CMD_LENMAX_MCDI2 1020
 #define    MC_CMD_MUM_IN_RAW_CMD_LEN(num) (16+1*(num))
+#define    MC_CMD_MUM_IN_RAW_CMD_WRITE_DATA_NUM(len) (((len)-16)/1)
 /* MUM cmd header */
 /*            MC_CMD_MUM_IN_CMD_OFST 0 */
 /*            MC_CMD_MUM_IN_CMD_LEN 4 */
@@ -6131,6 +7110,7 @@
 #define       MC_CMD_MUM_IN_RAW_CMD_WRITE_DATA_LEN 1
 #define       MC_CMD_MUM_IN_RAW_CMD_WRITE_DATA_MINNUM 1
 #define       MC_CMD_MUM_IN_RAW_CMD_WRITE_DATA_MAXNUM 236
+#define       MC_CMD_MUM_IN_RAW_CMD_WRITE_DATA_MAXNUM_MCDI2 1004
 
 /* MC_CMD_MUM_IN_LOG msgrequest */
 #define    MC_CMD_MUM_IN_LOG_LEN 8
@@ -6158,6 +7138,7 @@
 /*            MC_CMD_MUM_IN_CMD_LEN 4 */
 #define       MC_CMD_MUM_IN_GPIO_HDR_OFST 4
 #define       MC_CMD_MUM_IN_GPIO_HDR_LEN 4
+#define        MC_CMD_MUM_IN_GPIO_OPCODE_OFST 4
 #define        MC_CMD_MUM_IN_GPIO_OPCODE_LBN 0
 #define        MC_CMD_MUM_IN_GPIO_OPCODE_WIDTH 8
 #define          MC_CMD_MUM_IN_GPIO_IN_READ 0x0 /* enum */
@@ -6220,12 +7201,14 @@
 /*            MC_CMD_MUM_IN_CMD_LEN 4 */
 #define       MC_CMD_MUM_IN_GPIO_OP_HDR_OFST 4
 #define       MC_CMD_MUM_IN_GPIO_OP_HDR_LEN 4
+#define        MC_CMD_MUM_IN_GPIO_OP_BITWISE_OP_OFST 4
 #define        MC_CMD_MUM_IN_GPIO_OP_BITWISE_OP_LBN 8
 #define        MC_CMD_MUM_IN_GPIO_OP_BITWISE_OP_WIDTH 8
 #define          MC_CMD_MUM_IN_GPIO_OP_OUT_READ 0x0 /* enum */
 #define          MC_CMD_MUM_IN_GPIO_OP_OUT_WRITE 0x1 /* enum */
 #define          MC_CMD_MUM_IN_GPIO_OP_OUT_CONFIG 0x2 /* enum */
 #define          MC_CMD_MUM_IN_GPIO_OP_OUT_ENABLE 0x3 /* enum */
+#define        MC_CMD_MUM_IN_GPIO_OP_GPIO_NUMBER_OFST 4
 #define        MC_CMD_MUM_IN_GPIO_OP_GPIO_NUMBER_LBN 16
 #define        MC_CMD_MUM_IN_GPIO_OP_GPIO_NUMBER_WIDTH 8
 
@@ -6242,6 +7225,7 @@
 /*            MC_CMD_MUM_IN_CMD_LEN 4 */
 #define       MC_CMD_MUM_IN_GPIO_OP_OUT_WRITE_HDR_OFST 4
 #define       MC_CMD_MUM_IN_GPIO_OP_OUT_WRITE_HDR_LEN 4
+#define        MC_CMD_MUM_IN_GPIO_OP_OUT_WRITE_WRITEBIT_OFST 4
 #define        MC_CMD_MUM_IN_GPIO_OP_OUT_WRITE_WRITEBIT_LBN 24
 #define        MC_CMD_MUM_IN_GPIO_OP_OUT_WRITE_WRITEBIT_WIDTH 8
 
@@ -6251,6 +7235,7 @@
 /*            MC_CMD_MUM_IN_CMD_LEN 4 */
 #define       MC_CMD_MUM_IN_GPIO_OP_OUT_CONFIG_HDR_OFST 4
 #define       MC_CMD_MUM_IN_GPIO_OP_OUT_CONFIG_HDR_LEN 4
+#define        MC_CMD_MUM_IN_GPIO_OP_OUT_CONFIG_CFG_OFST 4
 #define        MC_CMD_MUM_IN_GPIO_OP_OUT_CONFIG_CFG_LBN 24
 #define        MC_CMD_MUM_IN_GPIO_OP_OUT_CONFIG_CFG_WIDTH 8
 
@@ -6260,6 +7245,7 @@
 /*            MC_CMD_MUM_IN_CMD_LEN 4 */
 #define       MC_CMD_MUM_IN_GPIO_OP_OUT_ENABLE_HDR_OFST 4
 #define       MC_CMD_MUM_IN_GPIO_OP_OUT_ENABLE_HDR_LEN 4
+#define        MC_CMD_MUM_IN_GPIO_OP_OUT_ENABLE_ENABLEBIT_OFST 4
 #define        MC_CMD_MUM_IN_GPIO_OP_OUT_ENABLE_ENABLEBIT_LBN 24
 #define        MC_CMD_MUM_IN_GPIO_OP_OUT_ENABLE_ENABLEBIT_WIDTH 8
 
@@ -6270,8 +7256,10 @@
 /*            MC_CMD_MUM_IN_CMD_LEN 4 */
 #define       MC_CMD_MUM_IN_READ_SENSORS_PARAMS_OFST 4
 #define       MC_CMD_MUM_IN_READ_SENSORS_PARAMS_LEN 4
+#define        MC_CMD_MUM_IN_READ_SENSORS_SENSOR_ID_OFST 4
 #define        MC_CMD_MUM_IN_READ_SENSORS_SENSOR_ID_LBN 0
 #define        MC_CMD_MUM_IN_READ_SENSORS_SENSOR_ID_WIDTH 8
+#define        MC_CMD_MUM_IN_READ_SENSORS_NUM_SENSORS_OFST 4
 #define        MC_CMD_MUM_IN_READ_SENSORS_NUM_SENSORS_LBN 8
 #define        MC_CMD_MUM_IN_READ_SENSORS_NUM_SENSORS_WIDTH 8
 
@@ -6289,10 +7277,13 @@
 /* Control flags for clock programming */
 #define       MC_CMD_MUM_IN_PROGRAM_CLOCKS_FLAGS_OFST 8
 #define       MC_CMD_MUM_IN_PROGRAM_CLOCKS_FLAGS_LEN 4
+#define        MC_CMD_MUM_IN_PROGRAM_CLOCKS_OVERCLOCK_110_OFST 8
 #define        MC_CMD_MUM_IN_PROGRAM_CLOCKS_OVERCLOCK_110_LBN 0
 #define        MC_CMD_MUM_IN_PROGRAM_CLOCKS_OVERCLOCK_110_WIDTH 1
+#define        MC_CMD_MUM_IN_PROGRAM_CLOCKS_CLOCK_NIC_FROM_FPGA_OFST 8
 #define        MC_CMD_MUM_IN_PROGRAM_CLOCKS_CLOCK_NIC_FROM_FPGA_LBN 1
 #define        MC_CMD_MUM_IN_PROGRAM_CLOCKS_CLOCK_NIC_FROM_FPGA_WIDTH 1
+#define        MC_CMD_MUM_IN_PROGRAM_CLOCKS_CLOCK_REF_FROM_XO_OFST 8
 #define        MC_CMD_MUM_IN_PROGRAM_CLOCKS_CLOCK_REF_FROM_XO_LBN 2
 #define        MC_CMD_MUM_IN_PROGRAM_CLOCKS_CLOCK_REF_FROM_XO_WIDTH 1
 
@@ -6318,6 +7309,7 @@
 /*            MC_CMD_MUM_IN_CMD_LEN 4 */
 #define       MC_CMD_MUM_IN_QSFP_HDR_OFST 4
 #define       MC_CMD_MUM_IN_QSFP_HDR_LEN 4
+#define        MC_CMD_MUM_IN_QSFP_OPCODE_OFST 4
 #define        MC_CMD_MUM_IN_QSFP_OPCODE_LBN 0
 #define        MC_CMD_MUM_IN_QSFP_OPCODE_WIDTH 4
 #define          MC_CMD_MUM_IN_QSFP_INIT 0x0 /* enum */
@@ -6417,21 +7409,27 @@
 /* MC_CMD_MUM_OUT_RAW_CMD msgresponse */
 #define    MC_CMD_MUM_OUT_RAW_CMD_LENMIN 1
 #define    MC_CMD_MUM_OUT_RAW_CMD_LENMAX 252
+#define    MC_CMD_MUM_OUT_RAW_CMD_LENMAX_MCDI2 1020
 #define    MC_CMD_MUM_OUT_RAW_CMD_LEN(num) (0+1*(num))
+#define    MC_CMD_MUM_OUT_RAW_CMD_DATA_NUM(len) (((len)-0)/1)
 /* returned data */
 #define       MC_CMD_MUM_OUT_RAW_CMD_DATA_OFST 0
 #define       MC_CMD_MUM_OUT_RAW_CMD_DATA_LEN 1
 #define       MC_CMD_MUM_OUT_RAW_CMD_DATA_MINNUM 1
 #define       MC_CMD_MUM_OUT_RAW_CMD_DATA_MAXNUM 252
+#define       MC_CMD_MUM_OUT_RAW_CMD_DATA_MAXNUM_MCDI2 1020
 
 /* MC_CMD_MUM_OUT_READ msgresponse */
 #define    MC_CMD_MUM_OUT_READ_LENMIN 4
 #define    MC_CMD_MUM_OUT_READ_LENMAX 252
+#define    MC_CMD_MUM_OUT_READ_LENMAX_MCDI2 1020
 #define    MC_CMD_MUM_OUT_READ_LEN(num) (0+4*(num))
+#define    MC_CMD_MUM_OUT_READ_BUFFER_NUM(len) (((len)-0)/4)
 #define       MC_CMD_MUM_OUT_READ_BUFFER_OFST 0
 #define       MC_CMD_MUM_OUT_READ_BUFFER_LEN 4
 #define       MC_CMD_MUM_OUT_READ_BUFFER_MINNUM 1
 #define       MC_CMD_MUM_OUT_READ_BUFFER_MAXNUM 63
+#define       MC_CMD_MUM_OUT_READ_BUFFER_MAXNUM_MCDI2 255
 
 /* MC_CMD_MUM_OUT_WRITE msgresponse */
 #define    MC_CMD_MUM_OUT_WRITE_LEN 0
@@ -6490,15 +7488,21 @@
 /* MC_CMD_MUM_OUT_READ_SENSORS msgresponse */
 #define    MC_CMD_MUM_OUT_READ_SENSORS_LENMIN 4
 #define    MC_CMD_MUM_OUT_READ_SENSORS_LENMAX 252
+#define    MC_CMD_MUM_OUT_READ_SENSORS_LENMAX_MCDI2 1020
 #define    MC_CMD_MUM_OUT_READ_SENSORS_LEN(num) (0+4*(num))
+#define    MC_CMD_MUM_OUT_READ_SENSORS_DATA_NUM(len) (((len)-0)/4)
 #define       MC_CMD_MUM_OUT_READ_SENSORS_DATA_OFST 0
 #define       MC_CMD_MUM_OUT_READ_SENSORS_DATA_LEN 4
 #define       MC_CMD_MUM_OUT_READ_SENSORS_DATA_MINNUM 1
 #define       MC_CMD_MUM_OUT_READ_SENSORS_DATA_MAXNUM 63
+#define       MC_CMD_MUM_OUT_READ_SENSORS_DATA_MAXNUM_MCDI2 255
+#define        MC_CMD_MUM_OUT_READ_SENSORS_READING_OFST 0
 #define        MC_CMD_MUM_OUT_READ_SENSORS_READING_LBN 0
 #define        MC_CMD_MUM_OUT_READ_SENSORS_READING_WIDTH 16
+#define        MC_CMD_MUM_OUT_READ_SENSORS_STATE_OFST 0
 #define        MC_CMD_MUM_OUT_READ_SENSORS_STATE_LBN 16
 #define        MC_CMD_MUM_OUT_READ_SENSORS_STATE_WIDTH 8
+#define        MC_CMD_MUM_OUT_READ_SENSORS_TYPE_OFST 0
 #define        MC_CMD_MUM_OUT_READ_SENSORS_TYPE_LBN 24
 #define        MC_CMD_MUM_OUT_READ_SENSORS_TYPE_WIDTH 8
 
@@ -6524,8 +7528,10 @@
 #define       MC_CMD_MUM_OUT_QSFP_RECONFIGURE_PORT_PHY_LP_CAP_LEN 4
 #define       MC_CMD_MUM_OUT_QSFP_RECONFIGURE_PORT_PHY_FLAGS_OFST 4
 #define       MC_CMD_MUM_OUT_QSFP_RECONFIGURE_PORT_PHY_FLAGS_LEN 4
+#define        MC_CMD_MUM_OUT_QSFP_RECONFIGURE_PORT_PHY_READY_OFST 4
 #define        MC_CMD_MUM_OUT_QSFP_RECONFIGURE_PORT_PHY_READY_LBN 0
 #define        MC_CMD_MUM_OUT_QSFP_RECONFIGURE_PORT_PHY_READY_WIDTH 1
+#define        MC_CMD_MUM_OUT_QSFP_RECONFIGURE_PORT_PHY_LINK_UP_OFST 4
 #define        MC_CMD_MUM_OUT_QSFP_RECONFIGURE_PORT_PHY_LINK_UP_LBN 1
 #define        MC_CMD_MUM_OUT_QSFP_RECONFIGURE_PORT_PHY_LINK_UP_WIDTH 1
 
@@ -6537,7 +7543,9 @@
 /* MC_CMD_MUM_OUT_QSFP_GET_MEDIA_INFO msgresponse */
 #define    MC_CMD_MUM_OUT_QSFP_GET_MEDIA_INFO_LENMIN 5
 #define    MC_CMD_MUM_OUT_QSFP_GET_MEDIA_INFO_LENMAX 252
+#define    MC_CMD_MUM_OUT_QSFP_GET_MEDIA_INFO_LENMAX_MCDI2 1020
 #define    MC_CMD_MUM_OUT_QSFP_GET_MEDIA_INFO_LEN(num) (4+1*(num))
+#define    MC_CMD_MUM_OUT_QSFP_GET_MEDIA_INFO_DATA_NUM(len) (((len)-4)/1)
 /* in bytes */
 #define       MC_CMD_MUM_OUT_QSFP_GET_MEDIA_INFO_DATALEN_OFST 0
 #define       MC_CMD_MUM_OUT_QSFP_GET_MEDIA_INFO_DATALEN_LEN 4
@@ -6545,6 +7553,7 @@
 #define       MC_CMD_MUM_OUT_QSFP_GET_MEDIA_INFO_DATA_LEN 1
 #define       MC_CMD_MUM_OUT_QSFP_GET_MEDIA_INFO_DATA_MINNUM 1
 #define       MC_CMD_MUM_OUT_QSFP_GET_MEDIA_INFO_DATA_MAXNUM 248
+#define       MC_CMD_MUM_OUT_QSFP_GET_MEDIA_INFO_DATA_MAXNUM_MCDI2 1016
 
 /* MC_CMD_MUM_OUT_QSFP_FILL_STATS msgresponse */
 #define    MC_CMD_MUM_OUT_QSFP_FILL_STATS_LEN 8
@@ -6561,12 +7570,16 @@
 /* MC_CMD_MUM_OUT_READ_DDR_INFO msgresponse */
 #define    MC_CMD_MUM_OUT_READ_DDR_INFO_LENMIN 24
 #define    MC_CMD_MUM_OUT_READ_DDR_INFO_LENMAX 248
+#define    MC_CMD_MUM_OUT_READ_DDR_INFO_LENMAX_MCDI2 1016
 #define    MC_CMD_MUM_OUT_READ_DDR_INFO_LEN(num) (8+8*(num))
+#define    MC_CMD_MUM_OUT_READ_DDR_INFO_SODIMM_INFO_RECORD_NUM(len) (((len)-8)/8)
 /* Discrete (soldered) DDR resistor strap info */
 #define       MC_CMD_MUM_OUT_READ_DDR_INFO_DISCRETE_DDR_INFO_OFST 0
 #define       MC_CMD_MUM_OUT_READ_DDR_INFO_DISCRETE_DDR_INFO_LEN 4
+#define        MC_CMD_MUM_OUT_READ_DDR_INFO_VRATIO_OFST 0
 #define        MC_CMD_MUM_OUT_READ_DDR_INFO_VRATIO_LBN 0
 #define        MC_CMD_MUM_OUT_READ_DDR_INFO_VRATIO_WIDTH 16
+#define        MC_CMD_MUM_OUT_READ_DDR_INFO_RESERVED1_OFST 0
 #define        MC_CMD_MUM_OUT_READ_DDR_INFO_RESERVED1_LBN 16
 #define        MC_CMD_MUM_OUT_READ_DDR_INFO_RESERVED1_WIDTH 16
 /* Number of SODIMM info records */
@@ -6579,6 +7592,8 @@
 #define       MC_CMD_MUM_OUT_READ_DDR_INFO_SODIMM_INFO_RECORD_HI_OFST 12
 #define       MC_CMD_MUM_OUT_READ_DDR_INFO_SODIMM_INFO_RECORD_MINNUM 2
 #define       MC_CMD_MUM_OUT_READ_DDR_INFO_SODIMM_INFO_RECORD_MAXNUM 30
+#define       MC_CMD_MUM_OUT_READ_DDR_INFO_SODIMM_INFO_RECORD_MAXNUM_MCDI2 126
+#define        MC_CMD_MUM_OUT_READ_DDR_INFO_BANK_ID_OFST 8
 #define        MC_CMD_MUM_OUT_READ_DDR_INFO_BANK_ID_LBN 0
 #define        MC_CMD_MUM_OUT_READ_DDR_INFO_BANK_ID_WIDTH 8
 /* enum: SODIMM bank 1 (Top SODIMM for Sorrento) */
@@ -6587,10 +7602,13 @@
 #define          MC_CMD_MUM_OUT_READ_DDR_INFO_BANK2 0x1
 /* enum: Total number of SODIMM banks */
 #define          MC_CMD_MUM_OUT_READ_DDR_INFO_NUM_BANKS 0x2
+#define        MC_CMD_MUM_OUT_READ_DDR_INFO_TYPE_OFST 8
 #define        MC_CMD_MUM_OUT_READ_DDR_INFO_TYPE_LBN 8
 #define        MC_CMD_MUM_OUT_READ_DDR_INFO_TYPE_WIDTH 8
+#define        MC_CMD_MUM_OUT_READ_DDR_INFO_RANK_OFST 8
 #define        MC_CMD_MUM_OUT_READ_DDR_INFO_RANK_LBN 16
 #define        MC_CMD_MUM_OUT_READ_DDR_INFO_RANK_WIDTH 4
+#define        MC_CMD_MUM_OUT_READ_DDR_INFO_VOLTAGE_OFST 8
 #define        MC_CMD_MUM_OUT_READ_DDR_INFO_VOLTAGE_LBN 20
 #define        MC_CMD_MUM_OUT_READ_DDR_INFO_VOLTAGE_WIDTH 4
 #define          MC_CMD_MUM_OUT_READ_DDR_INFO_NOT_POWERED 0x0 /* enum */
@@ -6599,10 +7617,13 @@
 #define          MC_CMD_MUM_OUT_READ_DDR_INFO_1V5 0x3 /* enum */
 /* enum: Values 5-15 are reserved for future usage */
 #define          MC_CMD_MUM_OUT_READ_DDR_INFO_1V8 0x4
+#define        MC_CMD_MUM_OUT_READ_DDR_INFO_SIZE_OFST 8
 #define        MC_CMD_MUM_OUT_READ_DDR_INFO_SIZE_LBN 24
 #define        MC_CMD_MUM_OUT_READ_DDR_INFO_SIZE_WIDTH 8
+#define        MC_CMD_MUM_OUT_READ_DDR_INFO_SPEED_OFST 8
 #define        MC_CMD_MUM_OUT_READ_DDR_INFO_SPEED_LBN 32
 #define        MC_CMD_MUM_OUT_READ_DDR_INFO_SPEED_WIDTH 16
+#define        MC_CMD_MUM_OUT_READ_DDR_INFO_STATE_OFST 8
 #define        MC_CMD_MUM_OUT_READ_DDR_INFO_STATE_LBN 48
 #define        MC_CMD_MUM_OUT_READ_DDR_INFO_STATE_WIDTH 4
 /* enum: No module present */
@@ -6620,14 +7641,314 @@
 /* enum: Modules may or may not be present, but cannot establish contact by I2C
  */
 #define          MC_CMD_MUM_OUT_READ_DDR_INFO_NOT_REACHABLE 0x6
+#define        MC_CMD_MUM_OUT_READ_DDR_INFO_RESERVED2_OFST 8
 #define        MC_CMD_MUM_OUT_READ_DDR_INFO_RESERVED2_LBN 52
 #define        MC_CMD_MUM_OUT_READ_DDR_INFO_RESERVED2_WIDTH 12
 
-/* MC_CMD_RESOURCE_SPECIFIER enum */
-/* enum: Any */
-#define          MC_CMD_RESOURCE_INSTANCE_ANY 0xffffffff
-/* enum: None */
-#define          MC_CMD_RESOURCE_INSTANCE_NONE 0xfffffffe
+/* MC_CMD_DYNAMIC_SENSORS_LIMITS structuredef: Set of sensor limits. This
+ * should match the equivalent structure in the sensor_query SPHINX service.
+ */
+#define    MC_CMD_DYNAMIC_SENSORS_LIMITS_LEN 24
+/* A value below this will trigger a warning event. */
+#define       MC_CMD_DYNAMIC_SENSORS_LIMITS_LO_WARNING_OFST 0
+#define       MC_CMD_DYNAMIC_SENSORS_LIMITS_LO_WARNING_LEN 4
+#define       MC_CMD_DYNAMIC_SENSORS_LIMITS_LO_WARNING_LBN 0
+#define       MC_CMD_DYNAMIC_SENSORS_LIMITS_LO_WARNING_WIDTH 32
+/* A value below this will trigger a critical event. */
+#define       MC_CMD_DYNAMIC_SENSORS_LIMITS_LO_CRITICAL_OFST 4
+#define       MC_CMD_DYNAMIC_SENSORS_LIMITS_LO_CRITICAL_LEN 4
+#define       MC_CMD_DYNAMIC_SENSORS_LIMITS_LO_CRITICAL_LBN 32
+#define       MC_CMD_DYNAMIC_SENSORS_LIMITS_LO_CRITICAL_WIDTH 32
+/* A value below this will shut down the card. */
+#define       MC_CMD_DYNAMIC_SENSORS_LIMITS_LO_FATAL_OFST 8
+#define       MC_CMD_DYNAMIC_SENSORS_LIMITS_LO_FATAL_LEN 4
+#define       MC_CMD_DYNAMIC_SENSORS_LIMITS_LO_FATAL_LBN 64
+#define       MC_CMD_DYNAMIC_SENSORS_LIMITS_LO_FATAL_WIDTH 32
+/* A value above this will trigger a warning event. */
+#define       MC_CMD_DYNAMIC_SENSORS_LIMITS_HI_WARNING_OFST 12
+#define       MC_CMD_DYNAMIC_SENSORS_LIMITS_HI_WARNING_LEN 4
+#define       MC_CMD_DYNAMIC_SENSORS_LIMITS_HI_WARNING_LBN 96
+#define       MC_CMD_DYNAMIC_SENSORS_LIMITS_HI_WARNING_WIDTH 32
+/* A value above this will trigger a critical event. */
+#define       MC_CMD_DYNAMIC_SENSORS_LIMITS_HI_CRITICAL_OFST 16
+#define       MC_CMD_DYNAMIC_SENSORS_LIMITS_HI_CRITICAL_LEN 4
+#define       MC_CMD_DYNAMIC_SENSORS_LIMITS_HI_CRITICAL_LBN 128
+#define       MC_CMD_DYNAMIC_SENSORS_LIMITS_HI_CRITICAL_WIDTH 32
+/* A value above this will shut down the card. */
+#define       MC_CMD_DYNAMIC_SENSORS_LIMITS_HI_FATAL_OFST 20
+#define       MC_CMD_DYNAMIC_SENSORS_LIMITS_HI_FATAL_LEN 4
+#define       MC_CMD_DYNAMIC_SENSORS_LIMITS_HI_FATAL_LBN 160
+#define       MC_CMD_DYNAMIC_SENSORS_LIMITS_HI_FATAL_WIDTH 32
+
+/* MC_CMD_DYNAMIC_SENSORS_DESCRIPTION structuredef: Description of a sensor.
+ * This should match the equivalent structure in the sensor_query SPHINX
+ * service.
+ */
+#define    MC_CMD_DYNAMIC_SENSORS_DESCRIPTION_LEN 64
+/* The handle used to identify the sensor in calls to
+ * MC_CMD_DYNAMIC_SENSORS_GET_VALUES
+ */
+#define       MC_CMD_DYNAMIC_SENSORS_DESCRIPTION_HANDLE_OFST 0
+#define       MC_CMD_DYNAMIC_SENSORS_DESCRIPTION_HANDLE_LEN 4
+#define       MC_CMD_DYNAMIC_SENSORS_DESCRIPTION_HANDLE_LBN 0
+#define       MC_CMD_DYNAMIC_SENSORS_DESCRIPTION_HANDLE_WIDTH 32
+/* A human-readable name for the sensor (zero terminated string, max 32 bytes)
+ */
+#define       MC_CMD_DYNAMIC_SENSORS_DESCRIPTION_NAME_OFST 4
+#define       MC_CMD_DYNAMIC_SENSORS_DESCRIPTION_NAME_LEN 32
+#define       MC_CMD_DYNAMIC_SENSORS_DESCRIPTION_NAME_LBN 32
+#define       MC_CMD_DYNAMIC_SENSORS_DESCRIPTION_NAME_WIDTH 256
+/* The type of the sensor device, and by implication the unit of that the
+ * values will be reported in
+ */
+#define       MC_CMD_DYNAMIC_SENSORS_DESCRIPTION_TYPE_OFST 36
+#define       MC_CMD_DYNAMIC_SENSORS_DESCRIPTION_TYPE_LEN 4
+/* enum: A voltage sensor. Unit is mV */
+#define          MC_CMD_DYNAMIC_SENSORS_DESCRIPTION_VOLTAGE 0x0
+/* enum: A current sensor. Unit is mA */
+#define          MC_CMD_DYNAMIC_SENSORS_DESCRIPTION_CURRENT 0x1
+/* enum: A power sensor. Unit is mW */
+#define          MC_CMD_DYNAMIC_SENSORS_DESCRIPTION_POWER 0x2
+/* enum: A temperature sensor. Unit is Celsius */
+#define          MC_CMD_DYNAMIC_SENSORS_DESCRIPTION_TEMPERATURE 0x3
+/* enum: A cooling fan sensor. Unit is RPM */
+#define          MC_CMD_DYNAMIC_SENSORS_DESCRIPTION_FAN 0x4
+#define       MC_CMD_DYNAMIC_SENSORS_DESCRIPTION_TYPE_LBN 288
+#define       MC_CMD_DYNAMIC_SENSORS_DESCRIPTION_TYPE_WIDTH 32
+/* A single MC_CMD_DYNAMIC_SENSORS_LIMITS structure */
+#define       MC_CMD_DYNAMIC_SENSORS_DESCRIPTION_LIMITS_OFST 40
+#define       MC_CMD_DYNAMIC_SENSORS_DESCRIPTION_LIMITS_LEN 24
+#define       MC_CMD_DYNAMIC_SENSORS_DESCRIPTION_LIMITS_LBN 320
+#define       MC_CMD_DYNAMIC_SENSORS_DESCRIPTION_LIMITS_WIDTH 192
+
+/* MC_CMD_DYNAMIC_SENSORS_READING structuredef: State and value of a sensor.
+ * This should match the equivalent structure in the sensor_query SPHINX
+ * service.
+ */
+#define    MC_CMD_DYNAMIC_SENSORS_READING_LEN 12
+/* The handle used to identify the sensor */
+#define       MC_CMD_DYNAMIC_SENSORS_READING_HANDLE_OFST 0
+#define       MC_CMD_DYNAMIC_SENSORS_READING_HANDLE_LEN 4
+#define       MC_CMD_DYNAMIC_SENSORS_READING_HANDLE_LBN 0
+#define       MC_CMD_DYNAMIC_SENSORS_READING_HANDLE_WIDTH 32
+/* The current value of the sensor */
+#define       MC_CMD_DYNAMIC_SENSORS_READING_VALUE_OFST 4
+#define       MC_CMD_DYNAMIC_SENSORS_READING_VALUE_LEN 4
+#define       MC_CMD_DYNAMIC_SENSORS_READING_VALUE_LBN 32
+#define       MC_CMD_DYNAMIC_SENSORS_READING_VALUE_WIDTH 32
+/* The sensor's condition, e.g. good, broken or removed */
+#define       MC_CMD_DYNAMIC_SENSORS_READING_STATE_OFST 8
+#define       MC_CMD_DYNAMIC_SENSORS_READING_STATE_LEN 4
+/* enum: Sensor working normally within limits */
+#define          MC_CMD_DYNAMIC_SENSORS_READING_OK 0x0
+/* enum: Warning threshold breached */
+#define          MC_CMD_DYNAMIC_SENSORS_READING_WARNING 0x1
+/* enum: Critical threshold breached */
+#define          MC_CMD_DYNAMIC_SENSORS_READING_CRITICAL 0x2
+/* enum: Fatal threshold breached */
+#define          MC_CMD_DYNAMIC_SENSORS_READING_FATAL 0x3
+/* enum: Sensor not working */
+#define          MC_CMD_DYNAMIC_SENSORS_READING_BROKEN 0x4
+/* enum: Sensor working but no reading available */
+#define          MC_CMD_DYNAMIC_SENSORS_READING_NO_READING 0x5
+/* enum: Sensor initialization failed */
+#define          MC_CMD_DYNAMIC_SENSORS_READING_INIT_FAILED 0x6
+#define       MC_CMD_DYNAMIC_SENSORS_READING_STATE_LBN 64
+#define       MC_CMD_DYNAMIC_SENSORS_READING_STATE_WIDTH 32
+
+
+/***********************************/
+/* MC_CMD_DYNAMIC_SENSORS_LIST
+ * Return a complete list of handles for sensors currently managed by the MC,
+ * and a generation count for this version of the sensor table. On systems
+ * advertising the DYNAMIC_SENSORS capability bit, this replaces the
+ * MC_CMD_READ_SENSORS command. On multi-MC systems this may include sensors
+ * added by the NMC.
+ *
+ * Sensor handles are persistent for the lifetime of the sensor and are used to
+ * identify sensors in MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS and
+ * MC_CMD_DYNAMIC_SENSORS_GET_VALUES.
+ *
+ * The generation count is maintained by the MC, is persistent across reboots
+ * and will be incremented each time the sensor table is modified. When the
+ * table is modified, a CODE_DYNAMIC_SENSORS_CHANGE event will be generated
+ * containing the new generation count. The driver should compare this against
+ * the current generation count, and if it is different, call
+ * MC_CMD_DYNAMIC_SENSORS_LIST again to update it's copy of the sensor table.
+ *
+ * The sensor count is provided to allow a future path to supporting more than
+ * MC_CMD_DYNAMIC_SENSORS_GET_READINGS_IN_HANDLES_MAXNUM_MCDI2 sensors, i.e.
+ * the maximum number that will fit in a single response. As this is a fairly
+ * large number (253) it is not anticipated that this will be needed in the
+ * near future, so can currently be ignored.
+ *
+ * On Riverhead this command is implemented as a a wrapper for `list` in the
+ * sensor_query SPHINX service.
+ */
+#define MC_CMD_DYNAMIC_SENSORS_LIST 0x66
+#undef MC_CMD_0x66_PRIVILEGE_CTG
+
+#define MC_CMD_0x66_PRIVILEGE_CTG SRIOV_CTG_GENERAL
+
+/* MC_CMD_DYNAMIC_SENSORS_LIST_IN msgrequest */
+#define    MC_CMD_DYNAMIC_SENSORS_LIST_IN_LEN 0
+
+/* MC_CMD_DYNAMIC_SENSORS_LIST_OUT msgresponse */
+#define    MC_CMD_DYNAMIC_SENSORS_LIST_OUT_LENMIN 8
+#define    MC_CMD_DYNAMIC_SENSORS_LIST_OUT_LENMAX 252
+#define    MC_CMD_DYNAMIC_SENSORS_LIST_OUT_LENMAX_MCDI2 1020
+#define    MC_CMD_DYNAMIC_SENSORS_LIST_OUT_LEN(num) (8+4*(num))
+#define    MC_CMD_DYNAMIC_SENSORS_LIST_OUT_HANDLES_NUM(len) (((len)-8)/4)
+/* Generation count, which will be updated each time a sensor is added to or
+ * removed from the MC sensor table.
+ */
+#define       MC_CMD_DYNAMIC_SENSORS_LIST_OUT_GENERATION_OFST 0
+#define       MC_CMD_DYNAMIC_SENSORS_LIST_OUT_GENERATION_LEN 4
+/* Number of sensors managed by the MC. Note that in principle, this can be
+ * larger than the size of the HANDLES array.
+ */
+#define       MC_CMD_DYNAMIC_SENSORS_LIST_OUT_COUNT_OFST 4
+#define       MC_CMD_DYNAMIC_SENSORS_LIST_OUT_COUNT_LEN 4
+/* Array of sensor handles */
+#define       MC_CMD_DYNAMIC_SENSORS_LIST_OUT_HANDLES_OFST 8
+#define       MC_CMD_DYNAMIC_SENSORS_LIST_OUT_HANDLES_LEN 4
+#define       MC_CMD_DYNAMIC_SENSORS_LIST_OUT_HANDLES_MINNUM 0
+#define       MC_CMD_DYNAMIC_SENSORS_LIST_OUT_HANDLES_MAXNUM 61
+#define       MC_CMD_DYNAMIC_SENSORS_LIST_OUT_HANDLES_MAXNUM_MCDI2 253
+
+
+/***********************************/
+/* MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS
+ * Get descriptions for a set of sensors, specified as an array of sensor
+ * handles as returned by MC_CMD_DYNAMIC_SENSORS_LIST
+ *
+ * Any handles which do not correspond to a sensor currently managed by the MC
+ * will be dropped from from the response. This may happen when a sensor table
+ * update is in progress, and effectively means the set of usable sensors is
+ * the intersection between the sets of sensors known to the driver and the MC.
+ *
+ * On Riverhead this command is implemented as a a wrapper for
+ * `get_descriptions` in the sensor_query SPHINX service.
+ */
+#define MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS 0x67
+#undef MC_CMD_0x67_PRIVILEGE_CTG
+
+#define MC_CMD_0x67_PRIVILEGE_CTG SRIOV_CTG_GENERAL
+
+/* MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS_IN msgrequest */
+#define    MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS_IN_LENMIN 0
+#define    MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS_IN_LENMAX 252
+#define    MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS_IN_LENMAX_MCDI2 1020
+#define    MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS_IN_LEN(num) (0+4*(num))
+#define    MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS_IN_HANDLES_NUM(len) (((len)-0)/4)
+/* Array of sensor handles */
+#define       MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS_IN_HANDLES_OFST 0
+#define       MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS_IN_HANDLES_LEN 4
+#define       MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS_IN_HANDLES_MINNUM 0
+#define       MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS_IN_HANDLES_MAXNUM 63
+#define       MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS_IN_HANDLES_MAXNUM_MCDI2 255
+
+/* MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS_OUT msgresponse */
+#define    MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS_OUT_LENMIN 0
+#define    MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS_OUT_LENMAX 192
+#define    MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS_OUT_LENMAX_MCDI2 960
+#define    MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS_OUT_LEN(num) (0+64*(num))
+#define    MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS_OUT_SENSORS_NUM(len) (((len)-0)/64)
+/* Array of MC_CMD_DYNAMIC_SENSORS_DESCRIPTION structures */
+#define       MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS_OUT_SENSORS_OFST 0
+#define       MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS_OUT_SENSORS_LEN 64
+#define       MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS_OUT_SENSORS_MINNUM 0
+#define       MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS_OUT_SENSORS_MAXNUM 3
+#define       MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS_OUT_SENSORS_MAXNUM_MCDI2 15
+
+
+/***********************************/
+/* MC_CMD_DYNAMIC_SENSORS_GET_READINGS
+ * Read the state and value for a set of sensors, specified as an array of
+ * sensor handles as returned by MC_CMD_DYNAMIC_SENSORS_LIST.
+ *
+ * In the case of a broken sensor, then the state of the response's
+ * MC_CMD_DYNAMIC_SENSORS_VALUE entry will be set to BROKEN, and any value
+ * provided should be treated as erroneous.
+ *
+ * Any handles which do not correspond to a sensor currently managed by the MC
+ * will be dropped from from the response. This may happen when a sensor table
+ * update is in progress, and effectively means the set of usable sensors is
+ * the intersection between the sets of sensors known to the driver and the MC.
+ *
+ * On Riverhead this command is implemented as a a wrapper for `get_readings`
+ * in the sensor_query SPHINX service.
+ */
+#define MC_CMD_DYNAMIC_SENSORS_GET_READINGS 0x68
+#undef MC_CMD_0x68_PRIVILEGE_CTG
+
+#define MC_CMD_0x68_PRIVILEGE_CTG SRIOV_CTG_GENERAL
+
+/* MC_CMD_DYNAMIC_SENSORS_GET_READINGS_IN msgrequest */
+#define    MC_CMD_DYNAMIC_SENSORS_GET_READINGS_IN_LENMIN 0
+#define    MC_CMD_DYNAMIC_SENSORS_GET_READINGS_IN_LENMAX 252
+#define    MC_CMD_DYNAMIC_SENSORS_GET_READINGS_IN_LENMAX_MCDI2 1020
+#define    MC_CMD_DYNAMIC_SENSORS_GET_READINGS_IN_LEN(num) (0+4*(num))
+#define    MC_CMD_DYNAMIC_SENSORS_GET_READINGS_IN_HANDLES_NUM(len) (((len)-0)/4)
+/* Array of sensor handles */
+#define       MC_CMD_DYNAMIC_SENSORS_GET_READINGS_IN_HANDLES_OFST 0
+#define       MC_CMD_DYNAMIC_SENSORS_GET_READINGS_IN_HANDLES_LEN 4
+#define       MC_CMD_DYNAMIC_SENSORS_GET_READINGS_IN_HANDLES_MINNUM 0
+#define       MC_CMD_DYNAMIC_SENSORS_GET_READINGS_IN_HANDLES_MAXNUM 63
+#define       MC_CMD_DYNAMIC_SENSORS_GET_READINGS_IN_HANDLES_MAXNUM_MCDI2 255
+
+/* MC_CMD_DYNAMIC_SENSORS_GET_READINGS_OUT msgresponse */
+#define    MC_CMD_DYNAMIC_SENSORS_GET_READINGS_OUT_LENMIN 0
+#define    MC_CMD_DYNAMIC_SENSORS_GET_READINGS_OUT_LENMAX 252
+#define    MC_CMD_DYNAMIC_SENSORS_GET_READINGS_OUT_LENMAX_MCDI2 1020
+#define    MC_CMD_DYNAMIC_SENSORS_GET_READINGS_OUT_LEN(num) (0+12*(num))
+#define    MC_CMD_DYNAMIC_SENSORS_GET_READINGS_OUT_VALUES_NUM(len) (((len)-0)/12)
+/* Array of MC_CMD_DYNAMIC_SENSORS_READING structures */
+#define       MC_CMD_DYNAMIC_SENSORS_GET_READINGS_OUT_VALUES_OFST 0
+#define       MC_CMD_DYNAMIC_SENSORS_GET_READINGS_OUT_VALUES_LEN 12
+#define       MC_CMD_DYNAMIC_SENSORS_GET_READINGS_OUT_VALUES_MINNUM 0
+#define       MC_CMD_DYNAMIC_SENSORS_GET_READINGS_OUT_VALUES_MAXNUM 21
+#define       MC_CMD_DYNAMIC_SENSORS_GET_READINGS_OUT_VALUES_MAXNUM_MCDI2 85
+
+
+/***********************************/
+/* MC_CMD_EVENT_CTRL
+ * Configure which categories of unsolicited events the driver expects to
+ * receive (Riverhead).
+ */
+#define MC_CMD_EVENT_CTRL 0x69
+#undef MC_CMD_0x69_PRIVILEGE_CTG
+
+#define MC_CMD_0x69_PRIVILEGE_CTG SRIOV_CTG_GENERAL
+
+/* MC_CMD_EVENT_CTRL_IN msgrequest */
+#define    MC_CMD_EVENT_CTRL_IN_LENMIN 0
+#define    MC_CMD_EVENT_CTRL_IN_LENMAX 252
+#define    MC_CMD_EVENT_CTRL_IN_LENMAX_MCDI2 1020
+#define    MC_CMD_EVENT_CTRL_IN_LEN(num) (0+4*(num))
+#define    MC_CMD_EVENT_CTRL_IN_EVENT_TYPE_NUM(len) (((len)-0)/4)
+/* Array of event categories for which the driver wishes to receive events. */
+#define       MC_CMD_EVENT_CTRL_IN_EVENT_TYPE_OFST 0
+#define       MC_CMD_EVENT_CTRL_IN_EVENT_TYPE_LEN 4
+#define       MC_CMD_EVENT_CTRL_IN_EVENT_TYPE_MINNUM 0
+#define       MC_CMD_EVENT_CTRL_IN_EVENT_TYPE_MAXNUM 63
+#define       MC_CMD_EVENT_CTRL_IN_EVENT_TYPE_MAXNUM_MCDI2 255
+/* enum: Driver wishes to receive LINKCHANGE events. */
+#define          MC_CMD_EVENT_CTRL_IN_MCDI_EVENT_CODE_LINKCHANGE 0x0
+/* enum: Driver wishes to receive SENSOR_CHANGE and SENSOR_STATE_CHANGE events.
+ */
+#define          MC_CMD_EVENT_CTRL_IN_MCDI_EVENT_CODE_SENSOREVT 0x1
+/* enum: Driver wishes to receive receive errors. */
+#define          MC_CMD_EVENT_CTRL_IN_MCDI_EVENT_CODE_RX_ERR 0x2
+/* enum: Driver wishes to receive transmit errors. */
+#define          MC_CMD_EVENT_CTRL_IN_MCDI_EVENT_CODE_TX_ERR 0x3
+/* enum: Driver wishes to receive firmware alerts. */
+#define          MC_CMD_EVENT_CTRL_IN_MCDI_EVENT_CODE_FWALERT 0x4
+/* enum: Driver wishes to receive reboot events. */
+#define          MC_CMD_EVENT_CTRL_IN_MCDI_EVENT_CODE_MC_REBOOT 0x5
+
+/* MC_CMD_EVENT_CTRL_OUT msgrequest */
+#define    MC_CMD_EVENT_CTRL_OUT_LEN 0
 
 /* EVB_PORT_ID structuredef */
 #define    EVB_PORT_ID_LEN 4
@@ -6789,6 +8110,8 @@
 #define          NVRAM_PARTITION_TYPE_BUNDLE_METADATA 0x1e01
 /* enum: Bundle update non-volatile log output partition */
 #define          NVRAM_PARTITION_TYPE_BUNDLE_LOG 0x1e02
+/* enum: Partition for Solarflare gPXE bootrom installed via Bundle update. */
+#define          NVRAM_PARTITION_TYPE_EXPANSION_ROM_INTERNAL 0x1e03
 /* enum: Start of reserved value range (firmware may use for any purpose) */
 #define          NVRAM_PARTITION_TYPE_RESERVED_VALUES_MIN 0xff00
 /* enum: End of reserved value range (firmware may use for any purpose) */
@@ -6846,24 +8169,34 @@
 #define       LICENSED_FEATURES_MASK_LEN 8
 #define       LICENSED_FEATURES_MASK_LO_OFST 0
 #define       LICENSED_FEATURES_MASK_HI_OFST 4
+#define        LICENSED_FEATURES_RX_CUT_THROUGH_OFST 0
 #define        LICENSED_FEATURES_RX_CUT_THROUGH_LBN 0
 #define        LICENSED_FEATURES_RX_CUT_THROUGH_WIDTH 1
+#define        LICENSED_FEATURES_PIO_OFST 0
 #define        LICENSED_FEATURES_PIO_LBN 1
 #define        LICENSED_FEATURES_PIO_WIDTH 1
+#define        LICENSED_FEATURES_EVQ_TIMER_OFST 0
 #define        LICENSED_FEATURES_EVQ_TIMER_LBN 2
 #define        LICENSED_FEATURES_EVQ_TIMER_WIDTH 1
+#define        LICENSED_FEATURES_CLOCK_OFST 0
 #define        LICENSED_FEATURES_CLOCK_LBN 3
 #define        LICENSED_FEATURES_CLOCK_WIDTH 1
+#define        LICENSED_FEATURES_RX_TIMESTAMPS_OFST 0
 #define        LICENSED_FEATURES_RX_TIMESTAMPS_LBN 4
 #define        LICENSED_FEATURES_RX_TIMESTAMPS_WIDTH 1
+#define        LICENSED_FEATURES_TX_TIMESTAMPS_OFST 0
 #define        LICENSED_FEATURES_TX_TIMESTAMPS_LBN 5
 #define        LICENSED_FEATURES_TX_TIMESTAMPS_WIDTH 1
+#define        LICENSED_FEATURES_RX_SNIFF_OFST 0
 #define        LICENSED_FEATURES_RX_SNIFF_LBN 6
 #define        LICENSED_FEATURES_RX_SNIFF_WIDTH 1
+#define        LICENSED_FEATURES_TX_SNIFF_OFST 0
 #define        LICENSED_FEATURES_TX_SNIFF_LBN 7
 #define        LICENSED_FEATURES_TX_SNIFF_WIDTH 1
+#define        LICENSED_FEATURES_PROXY_FILTER_OPS_OFST 0
 #define        LICENSED_FEATURES_PROXY_FILTER_OPS_LBN 8
 #define        LICENSED_FEATURES_PROXY_FILTER_OPS_WIDTH 1
+#define        LICENSED_FEATURES_EVENT_CUT_THROUGH_OFST 0
 #define        LICENSED_FEATURES_EVENT_CUT_THROUGH_LBN 9
 #define        LICENSED_FEATURES_EVENT_CUT_THROUGH_WIDTH 1
 #define       LICENSED_FEATURES_MASK_LBN 0
@@ -6876,36 +8209,52 @@
 #define       LICENSED_V3_APPS_MASK_LEN 8
 #define       LICENSED_V3_APPS_MASK_LO_OFST 0
 #define       LICENSED_V3_APPS_MASK_HI_OFST 4
+#define        LICENSED_V3_APPS_ONLOAD_OFST 0
 #define        LICENSED_V3_APPS_ONLOAD_LBN 0
 #define        LICENSED_V3_APPS_ONLOAD_WIDTH 1
+#define        LICENSED_V3_APPS_PTP_OFST 0
 #define        LICENSED_V3_APPS_PTP_LBN 1
 #define        LICENSED_V3_APPS_PTP_WIDTH 1
+#define        LICENSED_V3_APPS_SOLARCAPTURE_PRO_OFST 0
 #define        LICENSED_V3_APPS_SOLARCAPTURE_PRO_LBN 2
 #define        LICENSED_V3_APPS_SOLARCAPTURE_PRO_WIDTH 1
+#define        LICENSED_V3_APPS_SOLARSECURE_OFST 0
 #define        LICENSED_V3_APPS_SOLARSECURE_LBN 3
 #define        LICENSED_V3_APPS_SOLARSECURE_WIDTH 1
+#define        LICENSED_V3_APPS_PERF_MONITOR_OFST 0
 #define        LICENSED_V3_APPS_PERF_MONITOR_LBN 4
 #define        LICENSED_V3_APPS_PERF_MONITOR_WIDTH 1
+#define        LICENSED_V3_APPS_SOLARCAPTURE_LIVE_OFST 0
 #define        LICENSED_V3_APPS_SOLARCAPTURE_LIVE_LBN 5
 #define        LICENSED_V3_APPS_SOLARCAPTURE_LIVE_WIDTH 1
+#define        LICENSED_V3_APPS_CAPTURE_SOLARSYSTEM_OFST 0
 #define        LICENSED_V3_APPS_CAPTURE_SOLARSYSTEM_LBN 6
 #define        LICENSED_V3_APPS_CAPTURE_SOLARSYSTEM_WIDTH 1
+#define        LICENSED_V3_APPS_NETWORK_ACCESS_CONTROL_OFST 0
 #define        LICENSED_V3_APPS_NETWORK_ACCESS_CONTROL_LBN 7
 #define        LICENSED_V3_APPS_NETWORK_ACCESS_CONTROL_WIDTH 1
+#define        LICENSED_V3_APPS_TCP_DIRECT_OFST 0
 #define        LICENSED_V3_APPS_TCP_DIRECT_LBN 8
 #define        LICENSED_V3_APPS_TCP_DIRECT_WIDTH 1
+#define        LICENSED_V3_APPS_LOW_LATENCY_OFST 0
 #define        LICENSED_V3_APPS_LOW_LATENCY_LBN 9
 #define        LICENSED_V3_APPS_LOW_LATENCY_WIDTH 1
+#define        LICENSED_V3_APPS_SOLARCAPTURE_TAP_OFST 0
 #define        LICENSED_V3_APPS_SOLARCAPTURE_TAP_LBN 10
 #define        LICENSED_V3_APPS_SOLARCAPTURE_TAP_WIDTH 1
+#define        LICENSED_V3_APPS_CAPTURE_SOLARSYSTEM_40G_OFST 0
 #define        LICENSED_V3_APPS_CAPTURE_SOLARSYSTEM_40G_LBN 11
 #define        LICENSED_V3_APPS_CAPTURE_SOLARSYSTEM_40G_WIDTH 1
+#define        LICENSED_V3_APPS_CAPTURE_SOLARSYSTEM_1G_OFST 0
 #define        LICENSED_V3_APPS_CAPTURE_SOLARSYSTEM_1G_LBN 12
 #define        LICENSED_V3_APPS_CAPTURE_SOLARSYSTEM_1G_WIDTH 1
+#define        LICENSED_V3_APPS_SCALEOUT_ONLOAD_OFST 0
 #define        LICENSED_V3_APPS_SCALEOUT_ONLOAD_LBN 13
 #define        LICENSED_V3_APPS_SCALEOUT_ONLOAD_WIDTH 1
+#define        LICENSED_V3_APPS_DSHBRD_OFST 0
 #define        LICENSED_V3_APPS_DSHBRD_LBN 14
 #define        LICENSED_V3_APPS_DSHBRD_WIDTH 1
+#define        LICENSED_V3_APPS_SCATRD_OFST 0
 #define        LICENSED_V3_APPS_SCATRD_LBN 15
 #define        LICENSED_V3_APPS_SCATRD_WIDTH 1
 #define       LICENSED_V3_APPS_MASK_LBN 0
@@ -6918,24 +8267,34 @@
 #define       LICENSED_V3_FEATURES_MASK_LEN 8
 #define       LICENSED_V3_FEATURES_MASK_LO_OFST 0
 #define       LICENSED_V3_FEATURES_MASK_HI_OFST 4
+#define        LICENSED_V3_FEATURES_RX_CUT_THROUGH_OFST 0
 #define        LICENSED_V3_FEATURES_RX_CUT_THROUGH_LBN 0
 #define        LICENSED_V3_FEATURES_RX_CUT_THROUGH_WIDTH 1
+#define        LICENSED_V3_FEATURES_PIO_OFST 0
 #define        LICENSED_V3_FEATURES_PIO_LBN 1
 #define        LICENSED_V3_FEATURES_PIO_WIDTH 1
+#define        LICENSED_V3_FEATURES_EVQ_TIMER_OFST 0
 #define        LICENSED_V3_FEATURES_EVQ_TIMER_LBN 2
 #define        LICENSED_V3_FEATURES_EVQ_TIMER_WIDTH 1
+#define        LICENSED_V3_FEATURES_CLOCK_OFST 0
 #define        LICENSED_V3_FEATURES_CLOCK_LBN 3
 #define        LICENSED_V3_FEATURES_CLOCK_WIDTH 1
+#define        LICENSED_V3_FEATURES_RX_TIMESTAMPS_OFST 0
 #define        LICENSED_V3_FEATURES_RX_TIMESTAMPS_LBN 4
 #define        LICENSED_V3_FEATURES_RX_TIMESTAMPS_WIDTH 1
+#define        LICENSED_V3_FEATURES_TX_TIMESTAMPS_OFST 0
 #define        LICENSED_V3_FEATURES_TX_TIMESTAMPS_LBN 5
 #define        LICENSED_V3_FEATURES_TX_TIMESTAMPS_WIDTH 1
+#define        LICENSED_V3_FEATURES_RX_SNIFF_OFST 0
 #define        LICENSED_V3_FEATURES_RX_SNIFF_LBN 6
 #define        LICENSED_V3_FEATURES_RX_SNIFF_WIDTH 1
+#define        LICENSED_V3_FEATURES_TX_SNIFF_OFST 0
 #define        LICENSED_V3_FEATURES_TX_SNIFF_LBN 7
 #define        LICENSED_V3_FEATURES_TX_SNIFF_WIDTH 1
+#define        LICENSED_V3_FEATURES_PROXY_FILTER_OPS_OFST 0
 #define        LICENSED_V3_FEATURES_PROXY_FILTER_OPS_LBN 8
 #define        LICENSED_V3_FEATURES_PROXY_FILTER_OPS_WIDTH 1
+#define        LICENSED_V3_FEATURES_EVENT_CUT_THROUGH_OFST 0
 #define        LICENSED_V3_FEATURES_EVENT_CUT_THROUGH_LBN 9
 #define        LICENSED_V3_FEATURES_EVENT_CUT_THROUGH_WIDTH 1
 #define       LICENSED_V3_FEATURES_MASK_LBN 0
@@ -6988,12 +8347,16 @@
  */
 #define       RSS_MODE_HASH_SELECTOR_OFST 0
 #define       RSS_MODE_HASH_SELECTOR_LEN 1
+#define        RSS_MODE_HASH_SRC_ADDR_OFST 0
 #define        RSS_MODE_HASH_SRC_ADDR_LBN 0
 #define        RSS_MODE_HASH_SRC_ADDR_WIDTH 1
+#define        RSS_MODE_HASH_DST_ADDR_OFST 0
 #define        RSS_MODE_HASH_DST_ADDR_LBN 1
 #define        RSS_MODE_HASH_DST_ADDR_WIDTH 1
+#define        RSS_MODE_HASH_SRC_PORT_OFST 0
 #define        RSS_MODE_HASH_SRC_PORT_LBN 2
 #define        RSS_MODE_HASH_SRC_PORT_WIDTH 1
+#define        RSS_MODE_HASH_DST_PORT_OFST 0
 #define        RSS_MODE_HASH_DST_PORT_LBN 3
 #define        RSS_MODE_HASH_DST_PORT_WIDTH 1
 #define       RSS_MODE_HASH_SELECTOR_LBN 0
@@ -7018,6 +8381,7 @@
  * Get a dump of the MCPU registers
  */
 #define MC_CMD_READ_REGS 0x50
+#undef MC_CMD_0x50_PRIVILEGE_CTG
 
 #define MC_CMD_0x50_PRIVILEGE_CTG SRIOV_CTG_INSECURE
 
@@ -7043,13 +8407,16 @@
  * end with an address for each 4k of host memory required to back the EVQ.
  */
 #define MC_CMD_INIT_EVQ 0x80
+#undef MC_CMD_0x80_PRIVILEGE_CTG
 
 #define MC_CMD_0x80_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
 /* MC_CMD_INIT_EVQ_IN msgrequest */
 #define    MC_CMD_INIT_EVQ_IN_LENMIN 44
 #define    MC_CMD_INIT_EVQ_IN_LENMAX 548
+#define    MC_CMD_INIT_EVQ_IN_LENMAX_MCDI2 548
 #define    MC_CMD_INIT_EVQ_IN_LEN(num) (36+8*(num))
+#define    MC_CMD_INIT_EVQ_IN_DMA_ADDR_NUM(len) (((len)-36)/8)
 /* Size, in entries */
 #define       MC_CMD_INIT_EVQ_IN_SIZE_OFST 0
 #define       MC_CMD_INIT_EVQ_IN_SIZE_LEN 4
@@ -7068,18 +8435,25 @@
 /* tbd */
 #define       MC_CMD_INIT_EVQ_IN_FLAGS_OFST 16
 #define       MC_CMD_INIT_EVQ_IN_FLAGS_LEN 4
+#define        MC_CMD_INIT_EVQ_IN_FLAG_INTERRUPTING_OFST 16
 #define        MC_CMD_INIT_EVQ_IN_FLAG_INTERRUPTING_LBN 0
 #define        MC_CMD_INIT_EVQ_IN_FLAG_INTERRUPTING_WIDTH 1
+#define        MC_CMD_INIT_EVQ_IN_FLAG_RPTR_DOS_OFST 16
 #define        MC_CMD_INIT_EVQ_IN_FLAG_RPTR_DOS_LBN 1
 #define        MC_CMD_INIT_EVQ_IN_FLAG_RPTR_DOS_WIDTH 1
+#define        MC_CMD_INIT_EVQ_IN_FLAG_INT_ARMD_OFST 16
 #define        MC_CMD_INIT_EVQ_IN_FLAG_INT_ARMD_LBN 2
 #define        MC_CMD_INIT_EVQ_IN_FLAG_INT_ARMD_WIDTH 1
+#define        MC_CMD_INIT_EVQ_IN_FLAG_CUT_THRU_OFST 16
 #define        MC_CMD_INIT_EVQ_IN_FLAG_CUT_THRU_LBN 3
 #define        MC_CMD_INIT_EVQ_IN_FLAG_CUT_THRU_WIDTH 1
+#define        MC_CMD_INIT_EVQ_IN_FLAG_RX_MERGE_OFST 16
 #define        MC_CMD_INIT_EVQ_IN_FLAG_RX_MERGE_LBN 4
 #define        MC_CMD_INIT_EVQ_IN_FLAG_RX_MERGE_WIDTH 1
+#define        MC_CMD_INIT_EVQ_IN_FLAG_TX_MERGE_OFST 16
 #define        MC_CMD_INIT_EVQ_IN_FLAG_TX_MERGE_LBN 5
 #define        MC_CMD_INIT_EVQ_IN_FLAG_TX_MERGE_WIDTH 1
+#define        MC_CMD_INIT_EVQ_IN_FLAG_USE_TIMER_OFST 16
 #define        MC_CMD_INIT_EVQ_IN_FLAG_USE_TIMER_LBN 6
 #define        MC_CMD_INIT_EVQ_IN_FLAG_USE_TIMER_WIDTH 1
 #define       MC_CMD_INIT_EVQ_IN_TMR_MODE_OFST 20
@@ -7122,6 +8496,7 @@
 #define       MC_CMD_INIT_EVQ_IN_DMA_ADDR_HI_OFST 40
 #define       MC_CMD_INIT_EVQ_IN_DMA_ADDR_MINNUM 1
 #define       MC_CMD_INIT_EVQ_IN_DMA_ADDR_MAXNUM 64
+#define       MC_CMD_INIT_EVQ_IN_DMA_ADDR_MAXNUM_MCDI2 64
 
 /* MC_CMD_INIT_EVQ_OUT msgresponse */
 #define    MC_CMD_INIT_EVQ_OUT_LEN 4
@@ -7132,7 +8507,9 @@
 /* MC_CMD_INIT_EVQ_V2_IN msgrequest */
 #define    MC_CMD_INIT_EVQ_V2_IN_LENMIN 44
 #define    MC_CMD_INIT_EVQ_V2_IN_LENMAX 548
+#define    MC_CMD_INIT_EVQ_V2_IN_LENMAX_MCDI2 548
 #define    MC_CMD_INIT_EVQ_V2_IN_LEN(num) (36+8*(num))
+#define    MC_CMD_INIT_EVQ_V2_IN_DMA_ADDR_NUM(len) (((len)-36)/8)
 /* Size, in entries */
 #define       MC_CMD_INIT_EVQ_V2_IN_SIZE_OFST 0
 #define       MC_CMD_INIT_EVQ_V2_IN_SIZE_LEN 4
@@ -7151,20 +8528,28 @@
 /* tbd */
 #define       MC_CMD_INIT_EVQ_V2_IN_FLAGS_OFST 16
 #define       MC_CMD_INIT_EVQ_V2_IN_FLAGS_LEN 4
+#define        MC_CMD_INIT_EVQ_V2_IN_FLAG_INTERRUPTING_OFST 16
 #define        MC_CMD_INIT_EVQ_V2_IN_FLAG_INTERRUPTING_LBN 0
 #define        MC_CMD_INIT_EVQ_V2_IN_FLAG_INTERRUPTING_WIDTH 1
+#define        MC_CMD_INIT_EVQ_V2_IN_FLAG_RPTR_DOS_OFST 16
 #define        MC_CMD_INIT_EVQ_V2_IN_FLAG_RPTR_DOS_LBN 1
 #define        MC_CMD_INIT_EVQ_V2_IN_FLAG_RPTR_DOS_WIDTH 1
+#define        MC_CMD_INIT_EVQ_V2_IN_FLAG_INT_ARMD_OFST 16
 #define        MC_CMD_INIT_EVQ_V2_IN_FLAG_INT_ARMD_LBN 2
 #define        MC_CMD_INIT_EVQ_V2_IN_FLAG_INT_ARMD_WIDTH 1
+#define        MC_CMD_INIT_EVQ_V2_IN_FLAG_CUT_THRU_OFST 16
 #define        MC_CMD_INIT_EVQ_V2_IN_FLAG_CUT_THRU_LBN 3
 #define        MC_CMD_INIT_EVQ_V2_IN_FLAG_CUT_THRU_WIDTH 1
+#define        MC_CMD_INIT_EVQ_V2_IN_FLAG_RX_MERGE_OFST 16
 #define        MC_CMD_INIT_EVQ_V2_IN_FLAG_RX_MERGE_LBN 4
 #define        MC_CMD_INIT_EVQ_V2_IN_FLAG_RX_MERGE_WIDTH 1
+#define        MC_CMD_INIT_EVQ_V2_IN_FLAG_TX_MERGE_OFST 16
 #define        MC_CMD_INIT_EVQ_V2_IN_FLAG_TX_MERGE_LBN 5
 #define        MC_CMD_INIT_EVQ_V2_IN_FLAG_TX_MERGE_WIDTH 1
+#define        MC_CMD_INIT_EVQ_V2_IN_FLAG_USE_TIMER_OFST 16
 #define        MC_CMD_INIT_EVQ_V2_IN_FLAG_USE_TIMER_LBN 6
 #define        MC_CMD_INIT_EVQ_V2_IN_FLAG_USE_TIMER_WIDTH 1
+#define        MC_CMD_INIT_EVQ_V2_IN_FLAG_TYPE_OFST 16
 #define        MC_CMD_INIT_EVQ_V2_IN_FLAG_TYPE_LBN 7
 #define        MC_CMD_INIT_EVQ_V2_IN_FLAG_TYPE_WIDTH 4
 /* enum: All initialisation flags specified by host. */
@@ -7186,6 +8571,9 @@
  * MC_CMD_INIT_EVQ_V2/MC_CMD_INIT_EVQ_V2_OUT/FLAGS for list of affected flags.
  */
 #define          MC_CMD_INIT_EVQ_V2_IN_FLAG_TYPE_AUTO 0x3
+#define        MC_CMD_INIT_EVQ_V2_IN_FLAG_EXT_WIDTH_OFST 16
+#define        MC_CMD_INIT_EVQ_V2_IN_FLAG_EXT_WIDTH_LBN 11
+#define        MC_CMD_INIT_EVQ_V2_IN_FLAG_EXT_WIDTH_WIDTH 1
 #define       MC_CMD_INIT_EVQ_V2_IN_TMR_MODE_OFST 20
 #define       MC_CMD_INIT_EVQ_V2_IN_TMR_MODE_LEN 4
 /* enum: Disabled */
@@ -7226,6 +8614,7 @@
 #define       MC_CMD_INIT_EVQ_V2_IN_DMA_ADDR_HI_OFST 40
 #define       MC_CMD_INIT_EVQ_V2_IN_DMA_ADDR_MINNUM 1
 #define       MC_CMD_INIT_EVQ_V2_IN_DMA_ADDR_MAXNUM 64
+#define       MC_CMD_INIT_EVQ_V2_IN_DMA_ADDR_MAXNUM_MCDI2 64
 
 /* MC_CMD_INIT_EVQ_V2_OUT msgresponse */
 #define    MC_CMD_INIT_EVQ_V2_OUT_LEN 8
@@ -7235,12 +8624,16 @@
 /* Actual configuration applied on the card */
 #define       MC_CMD_INIT_EVQ_V2_OUT_FLAGS_OFST 4
 #define       MC_CMD_INIT_EVQ_V2_OUT_FLAGS_LEN 4
+#define        MC_CMD_INIT_EVQ_V2_OUT_FLAG_CUT_THRU_OFST 4
 #define        MC_CMD_INIT_EVQ_V2_OUT_FLAG_CUT_THRU_LBN 0
 #define        MC_CMD_INIT_EVQ_V2_OUT_FLAG_CUT_THRU_WIDTH 1
+#define        MC_CMD_INIT_EVQ_V2_OUT_FLAG_RX_MERGE_OFST 4
 #define        MC_CMD_INIT_EVQ_V2_OUT_FLAG_RX_MERGE_LBN 1
 #define        MC_CMD_INIT_EVQ_V2_OUT_FLAG_RX_MERGE_WIDTH 1
+#define        MC_CMD_INIT_EVQ_V2_OUT_FLAG_TX_MERGE_OFST 4
 #define        MC_CMD_INIT_EVQ_V2_OUT_FLAG_TX_MERGE_LBN 2
 #define        MC_CMD_INIT_EVQ_V2_OUT_FLAG_TX_MERGE_WIDTH 1
+#define        MC_CMD_INIT_EVQ_V2_OUT_FLAG_RXQ_FORCE_EV_MERGING_OFST 4
 #define        MC_CMD_INIT_EVQ_V2_OUT_FLAG_RXQ_FORCE_EV_MERGING_LBN 3
 #define        MC_CMD_INIT_EVQ_V2_OUT_FLAG_RXQ_FORCE_EV_MERGING_WIDTH 1
 
@@ -7271,6 +8664,7 @@
  * the RXQ.
  */
 #define MC_CMD_INIT_RXQ 0x81
+#undef MC_CMD_0x81_PRIVILEGE_CTG
 
 #define MC_CMD_0x81_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -7279,7 +8673,9 @@
  */
 #define    MC_CMD_INIT_RXQ_IN_LENMIN 36
 #define    MC_CMD_INIT_RXQ_IN_LENMAX 252
+#define    MC_CMD_INIT_RXQ_IN_LENMAX_MCDI2 1020
 #define    MC_CMD_INIT_RXQ_IN_LEN(num) (28+8*(num))
+#define    MC_CMD_INIT_RXQ_IN_DMA_ADDR_NUM(len) (((len)-28)/8)
 /* Size, in entries */
 #define       MC_CMD_INIT_RXQ_IN_SIZE_OFST 0
 #define       MC_CMD_INIT_RXQ_IN_SIZE_LEN 4
@@ -7298,20 +8694,28 @@
 /* There will be more flags here. */
 #define       MC_CMD_INIT_RXQ_IN_FLAGS_OFST 16
 #define       MC_CMD_INIT_RXQ_IN_FLAGS_LEN 4
+#define        MC_CMD_INIT_RXQ_IN_FLAG_BUFF_MODE_OFST 16
 #define        MC_CMD_INIT_RXQ_IN_FLAG_BUFF_MODE_LBN 0
 #define        MC_CMD_INIT_RXQ_IN_FLAG_BUFF_MODE_WIDTH 1
+#define        MC_CMD_INIT_RXQ_IN_FLAG_HDR_SPLIT_OFST 16
 #define        MC_CMD_INIT_RXQ_IN_FLAG_HDR_SPLIT_LBN 1
 #define        MC_CMD_INIT_RXQ_IN_FLAG_HDR_SPLIT_WIDTH 1
+#define        MC_CMD_INIT_RXQ_IN_FLAG_TIMESTAMP_OFST 16
 #define        MC_CMD_INIT_RXQ_IN_FLAG_TIMESTAMP_LBN 2
 #define        MC_CMD_INIT_RXQ_IN_FLAG_TIMESTAMP_WIDTH 1
+#define        MC_CMD_INIT_RXQ_IN_CRC_MODE_OFST 16
 #define        MC_CMD_INIT_RXQ_IN_CRC_MODE_LBN 3
 #define        MC_CMD_INIT_RXQ_IN_CRC_MODE_WIDTH 4
+#define        MC_CMD_INIT_RXQ_IN_FLAG_CHAIN_OFST 16
 #define        MC_CMD_INIT_RXQ_IN_FLAG_CHAIN_LBN 7
 #define        MC_CMD_INIT_RXQ_IN_FLAG_CHAIN_WIDTH 1
+#define        MC_CMD_INIT_RXQ_IN_FLAG_PREFIX_OFST 16
 #define        MC_CMD_INIT_RXQ_IN_FLAG_PREFIX_LBN 8
 #define        MC_CMD_INIT_RXQ_IN_FLAG_PREFIX_WIDTH 1
+#define        MC_CMD_INIT_RXQ_IN_FLAG_DISABLE_SCATTER_OFST 16
 #define        MC_CMD_INIT_RXQ_IN_FLAG_DISABLE_SCATTER_LBN 9
 #define        MC_CMD_INIT_RXQ_IN_FLAG_DISABLE_SCATTER_WIDTH 1
+#define        MC_CMD_INIT_RXQ_IN_UNUSED_OFST 16
 #define        MC_CMD_INIT_RXQ_IN_UNUSED_LBN 10
 #define        MC_CMD_INIT_RXQ_IN_UNUSED_WIDTH 1
 /* Owner ID to use if in buffer mode (zero if physical) */
@@ -7327,6 +8731,7 @@
 #define       MC_CMD_INIT_RXQ_IN_DMA_ADDR_HI_OFST 32
 #define       MC_CMD_INIT_RXQ_IN_DMA_ADDR_MINNUM 1
 #define       MC_CMD_INIT_RXQ_IN_DMA_ADDR_MAXNUM 28
+#define       MC_CMD_INIT_RXQ_IN_DMA_ADDR_MAXNUM_MCDI2 124
 
 /* MC_CMD_INIT_RXQ_EXT_IN msgrequest: Extended RXQ_INIT with additional mode
  * flags
@@ -7341,7 +8746,7 @@
 #define       MC_CMD_INIT_RXQ_EXT_IN_TARGET_EVQ_OFST 4
 #define       MC_CMD_INIT_RXQ_EXT_IN_TARGET_EVQ_LEN 4
 /* The value to put in the event data. Check hardware spec. for valid range.
- * This field is ignored if DMA_MODE == EQUAL_STRIDE_PACKED_STREAM or DMA_MODE
+ * This field is ignored if DMA_MODE == EQUAL_STRIDE_SUPER_BUFFER or DMA_MODE
  * == PACKED_STREAM.
  */
 #define       MC_CMD_INIT_RXQ_EXT_IN_LABEL_OFST 8
@@ -7354,20 +8759,28 @@
 /* There will be more flags here. */
 #define       MC_CMD_INIT_RXQ_EXT_IN_FLAGS_OFST 16
 #define       MC_CMD_INIT_RXQ_EXT_IN_FLAGS_LEN 4
+#define        MC_CMD_INIT_RXQ_EXT_IN_FLAG_BUFF_MODE_OFST 16
 #define        MC_CMD_INIT_RXQ_EXT_IN_FLAG_BUFF_MODE_LBN 0
 #define        MC_CMD_INIT_RXQ_EXT_IN_FLAG_BUFF_MODE_WIDTH 1
+#define        MC_CMD_INIT_RXQ_EXT_IN_FLAG_HDR_SPLIT_OFST 16
 #define        MC_CMD_INIT_RXQ_EXT_IN_FLAG_HDR_SPLIT_LBN 1
 #define        MC_CMD_INIT_RXQ_EXT_IN_FLAG_HDR_SPLIT_WIDTH 1
+#define        MC_CMD_INIT_RXQ_EXT_IN_FLAG_TIMESTAMP_OFST 16
 #define        MC_CMD_INIT_RXQ_EXT_IN_FLAG_TIMESTAMP_LBN 2
 #define        MC_CMD_INIT_RXQ_EXT_IN_FLAG_TIMESTAMP_WIDTH 1
+#define        MC_CMD_INIT_RXQ_EXT_IN_CRC_MODE_OFST 16
 #define        MC_CMD_INIT_RXQ_EXT_IN_CRC_MODE_LBN 3
 #define        MC_CMD_INIT_RXQ_EXT_IN_CRC_MODE_WIDTH 4
+#define        MC_CMD_INIT_RXQ_EXT_IN_FLAG_CHAIN_OFST 16
 #define        MC_CMD_INIT_RXQ_EXT_IN_FLAG_CHAIN_LBN 7
 #define        MC_CMD_INIT_RXQ_EXT_IN_FLAG_CHAIN_WIDTH 1
+#define        MC_CMD_INIT_RXQ_EXT_IN_FLAG_PREFIX_OFST 16
 #define        MC_CMD_INIT_RXQ_EXT_IN_FLAG_PREFIX_LBN 8
 #define        MC_CMD_INIT_RXQ_EXT_IN_FLAG_PREFIX_WIDTH 1
+#define        MC_CMD_INIT_RXQ_EXT_IN_FLAG_DISABLE_SCATTER_OFST 16
 #define        MC_CMD_INIT_RXQ_EXT_IN_FLAG_DISABLE_SCATTER_LBN 9
 #define        MC_CMD_INIT_RXQ_EXT_IN_FLAG_DISABLE_SCATTER_WIDTH 1
+#define        MC_CMD_INIT_RXQ_EXT_IN_DMA_MODE_OFST 16
 #define        MC_CMD_INIT_RXQ_EXT_IN_DMA_MODE_LBN 10
 #define        MC_CMD_INIT_RXQ_EXT_IN_DMA_MODE_WIDTH 4
 /* enum: One packet per descriptor (for normal networking) */
@@ -7380,9 +8793,13 @@
  * description see SF-119419-TC. This mode is only supported by "dpdk" datapath
  * firmware.
  */
+#define          MC_CMD_INIT_RXQ_EXT_IN_EQUAL_STRIDE_SUPER_BUFFER 0x2
+/* enum: Deprecated name for EQUAL_STRIDE_SUPER_BUFFER. */
 #define          MC_CMD_INIT_RXQ_EXT_IN_EQUAL_STRIDE_PACKED_STREAM 0x2
+#define        MC_CMD_INIT_RXQ_EXT_IN_FLAG_SNAPSHOT_MODE_OFST 16
 #define        MC_CMD_INIT_RXQ_EXT_IN_FLAG_SNAPSHOT_MODE_LBN 14
 #define        MC_CMD_INIT_RXQ_EXT_IN_FLAG_SNAPSHOT_MODE_WIDTH 1
+#define        MC_CMD_INIT_RXQ_EXT_IN_PACKED_STREAM_BUFF_SIZE_OFST 16
 #define        MC_CMD_INIT_RXQ_EXT_IN_PACKED_STREAM_BUFF_SIZE_LBN 15
 #define        MC_CMD_INIT_RXQ_EXT_IN_PACKED_STREAM_BUFF_SIZE_WIDTH 3
 #define          MC_CMD_INIT_RXQ_EXT_IN_PS_BUFF_1M 0x0 /* enum */
@@ -7390,10 +8807,15 @@
 #define          MC_CMD_INIT_RXQ_EXT_IN_PS_BUFF_256K 0x2 /* enum */
 #define          MC_CMD_INIT_RXQ_EXT_IN_PS_BUFF_128K 0x3 /* enum */
 #define          MC_CMD_INIT_RXQ_EXT_IN_PS_BUFF_64K 0x4 /* enum */
+#define        MC_CMD_INIT_RXQ_EXT_IN_FLAG_WANT_OUTER_CLASSES_OFST 16
 #define        MC_CMD_INIT_RXQ_EXT_IN_FLAG_WANT_OUTER_CLASSES_LBN 18
 #define        MC_CMD_INIT_RXQ_EXT_IN_FLAG_WANT_OUTER_CLASSES_WIDTH 1
+#define        MC_CMD_INIT_RXQ_EXT_IN_FLAG_FORCE_EV_MERGING_OFST 16
 #define        MC_CMD_INIT_RXQ_EXT_IN_FLAG_FORCE_EV_MERGING_LBN 19
 #define        MC_CMD_INIT_RXQ_EXT_IN_FLAG_FORCE_EV_MERGING_WIDTH 1
+#define        MC_CMD_INIT_RXQ_EXT_IN_FLAG_NO_CONT_EV_OFST 16
+#define        MC_CMD_INIT_RXQ_EXT_IN_FLAG_NO_CONT_EV_LBN 20
+#define        MC_CMD_INIT_RXQ_EXT_IN_FLAG_NO_CONT_EV_WIDTH 1
 /* Owner ID to use if in buffer mode (zero if physical) */
 #define       MC_CMD_INIT_RXQ_EXT_IN_OWNER_ID_OFST 20
 #define       MC_CMD_INIT_RXQ_EXT_IN_OWNER_ID_LEN 4
@@ -7421,7 +8843,7 @@
 #define       MC_CMD_INIT_RXQ_V3_IN_TARGET_EVQ_OFST 4
 #define       MC_CMD_INIT_RXQ_V3_IN_TARGET_EVQ_LEN 4
 /* The value to put in the event data. Check hardware spec. for valid range.
- * This field is ignored if DMA_MODE == EQUAL_STRIDE_PACKED_STREAM or DMA_MODE
+ * This field is ignored if DMA_MODE == EQUAL_STRIDE_SUPER_BUFFER or DMA_MODE
  * == PACKED_STREAM.
  */
 #define       MC_CMD_INIT_RXQ_V3_IN_LABEL_OFST 8
@@ -7434,20 +8856,28 @@
 /* There will be more flags here. */
 #define       MC_CMD_INIT_RXQ_V3_IN_FLAGS_OFST 16
 #define       MC_CMD_INIT_RXQ_V3_IN_FLAGS_LEN 4
+#define        MC_CMD_INIT_RXQ_V3_IN_FLAG_BUFF_MODE_OFST 16
 #define        MC_CMD_INIT_RXQ_V3_IN_FLAG_BUFF_MODE_LBN 0
 #define        MC_CMD_INIT_RXQ_V3_IN_FLAG_BUFF_MODE_WIDTH 1
+#define        MC_CMD_INIT_RXQ_V3_IN_FLAG_HDR_SPLIT_OFST 16
 #define        MC_CMD_INIT_RXQ_V3_IN_FLAG_HDR_SPLIT_LBN 1
 #define        MC_CMD_INIT_RXQ_V3_IN_FLAG_HDR_SPLIT_WIDTH 1
+#define        MC_CMD_INIT_RXQ_V3_IN_FLAG_TIMESTAMP_OFST 16
 #define        MC_CMD_INIT_RXQ_V3_IN_FLAG_TIMESTAMP_LBN 2
 #define        MC_CMD_INIT_RXQ_V3_IN_FLAG_TIMESTAMP_WIDTH 1
+#define        MC_CMD_INIT_RXQ_V3_IN_CRC_MODE_OFST 16
 #define        MC_CMD_INIT_RXQ_V3_IN_CRC_MODE_LBN 3
 #define        MC_CMD_INIT_RXQ_V3_IN_CRC_MODE_WIDTH 4
+#define        MC_CMD_INIT_RXQ_V3_IN_FLAG_CHAIN_OFST 16
 #define        MC_CMD_INIT_RXQ_V3_IN_FLAG_CHAIN_LBN 7
 #define        MC_CMD_INIT_RXQ_V3_IN_FLAG_CHAIN_WIDTH 1
+#define        MC_CMD_INIT_RXQ_V3_IN_FLAG_PREFIX_OFST 16
 #define        MC_CMD_INIT_RXQ_V3_IN_FLAG_PREFIX_LBN 8
 #define        MC_CMD_INIT_RXQ_V3_IN_FLAG_PREFIX_WIDTH 1
+#define        MC_CMD_INIT_RXQ_V3_IN_FLAG_DISABLE_SCATTER_OFST 16
 #define        MC_CMD_INIT_RXQ_V3_IN_FLAG_DISABLE_SCATTER_LBN 9
 #define        MC_CMD_INIT_RXQ_V3_IN_FLAG_DISABLE_SCATTER_WIDTH 1
+#define        MC_CMD_INIT_RXQ_V3_IN_DMA_MODE_OFST 16
 #define        MC_CMD_INIT_RXQ_V3_IN_DMA_MODE_LBN 10
 #define        MC_CMD_INIT_RXQ_V3_IN_DMA_MODE_WIDTH 4
 /* enum: One packet per descriptor (for normal networking) */
@@ -7460,9 +8890,13 @@
  * description see SF-119419-TC. This mode is only supported by "dpdk" datapath
  * firmware.
  */
+#define          MC_CMD_INIT_RXQ_V3_IN_EQUAL_STRIDE_SUPER_BUFFER 0x2
+/* enum: Deprecated name for EQUAL_STRIDE_SUPER_BUFFER. */
 #define          MC_CMD_INIT_RXQ_V3_IN_EQUAL_STRIDE_PACKED_STREAM 0x2
+#define        MC_CMD_INIT_RXQ_V3_IN_FLAG_SNAPSHOT_MODE_OFST 16
 #define        MC_CMD_INIT_RXQ_V3_IN_FLAG_SNAPSHOT_MODE_LBN 14
 #define        MC_CMD_INIT_RXQ_V3_IN_FLAG_SNAPSHOT_MODE_WIDTH 1
+#define        MC_CMD_INIT_RXQ_V3_IN_PACKED_STREAM_BUFF_SIZE_OFST 16
 #define        MC_CMD_INIT_RXQ_V3_IN_PACKED_STREAM_BUFF_SIZE_LBN 15
 #define        MC_CMD_INIT_RXQ_V3_IN_PACKED_STREAM_BUFF_SIZE_WIDTH 3
 #define          MC_CMD_INIT_RXQ_V3_IN_PS_BUFF_1M 0x0 /* enum */
@@ -7470,10 +8904,15 @@
 #define          MC_CMD_INIT_RXQ_V3_IN_PS_BUFF_256K 0x2 /* enum */
 #define          MC_CMD_INIT_RXQ_V3_IN_PS_BUFF_128K 0x3 /* enum */
 #define          MC_CMD_INIT_RXQ_V3_IN_PS_BUFF_64K 0x4 /* enum */
+#define        MC_CMD_INIT_RXQ_V3_IN_FLAG_WANT_OUTER_CLASSES_OFST 16
 #define        MC_CMD_INIT_RXQ_V3_IN_FLAG_WANT_OUTER_CLASSES_LBN 18
 #define        MC_CMD_INIT_RXQ_V3_IN_FLAG_WANT_OUTER_CLASSES_WIDTH 1
+#define        MC_CMD_INIT_RXQ_V3_IN_FLAG_FORCE_EV_MERGING_OFST 16
 #define        MC_CMD_INIT_RXQ_V3_IN_FLAG_FORCE_EV_MERGING_LBN 19
 #define        MC_CMD_INIT_RXQ_V3_IN_FLAG_FORCE_EV_MERGING_WIDTH 1
+#define        MC_CMD_INIT_RXQ_V3_IN_FLAG_NO_CONT_EV_OFST 16
+#define        MC_CMD_INIT_RXQ_V3_IN_FLAG_NO_CONT_EV_LBN 20
+#define        MC_CMD_INIT_RXQ_V3_IN_FLAG_NO_CONT_EV_WIDTH 1
 /* Owner ID to use if in buffer mode (zero if physical) */
 #define       MC_CMD_INIT_RXQ_V3_IN_OWNER_ID_OFST 20
 #define       MC_CMD_INIT_RXQ_V3_IN_OWNER_ID_LEN 4
@@ -7490,21 +8929,21 @@
 #define       MC_CMD_INIT_RXQ_V3_IN_SNAPSHOT_LENGTH_OFST 540
 #define       MC_CMD_INIT_RXQ_V3_IN_SNAPSHOT_LENGTH_LEN 4
 /* The number of packet buffers that will be contained within each
- * EQUAL_STRIDE_PACKED_STREAM format bucket supplied by the driver. This field
- * is ignored unless DMA_MODE == EQUAL_STRIDE_PACKED_STREAM.
+ * EQUAL_STRIDE_SUPER_BUFFER format bucket supplied by the driver. This field
+ * is ignored unless DMA_MODE == EQUAL_STRIDE_SUPER_BUFFER.
  */
 #define       MC_CMD_INIT_RXQ_V3_IN_ES_PACKET_BUFFERS_PER_BUCKET_OFST 544
 #define       MC_CMD_INIT_RXQ_V3_IN_ES_PACKET_BUFFERS_PER_BUCKET_LEN 4
 /* The length in bytes of the area in each packet buffer that can be written to
  * by the adapter. This is used to store the packet prefix and the packet
  * payload. This length does not include any end padding added by the driver.
- * This field is ignored unless DMA_MODE == EQUAL_STRIDE_PACKED_STREAM.
+ * This field is ignored unless DMA_MODE == EQUAL_STRIDE_SUPER_BUFFER.
  */
 #define       MC_CMD_INIT_RXQ_V3_IN_ES_MAX_DMA_LEN_OFST 548
 #define       MC_CMD_INIT_RXQ_V3_IN_ES_MAX_DMA_LEN_LEN 4
 /* The length in bytes of a single packet buffer within a
- * EQUAL_STRIDE_PACKED_STREAM format bucket. This field is ignored unless
- * DMA_MODE == EQUAL_STRIDE_PACKED_STREAM.
+ * EQUAL_STRIDE_SUPER_BUFFER format bucket. This field is ignored unless
+ * DMA_MODE == EQUAL_STRIDE_SUPER_BUFFER.
  */
 #define       MC_CMD_INIT_RXQ_V3_IN_ES_PACKET_STRIDE_OFST 552
 #define       MC_CMD_INIT_RXQ_V3_IN_ES_PACKET_STRIDE_LEN 4
@@ -7512,11 +8951,296 @@
  * there are no RX descriptors available. If the timeout is reached and there
  * are still no descriptors then the packet will be dropped. A timeout of 0
  * means the datapath will never be blocked. This field is ignored unless
- * DMA_MODE == EQUAL_STRIDE_PACKED_STREAM.
+ * DMA_MODE == EQUAL_STRIDE_SUPER_BUFFER.
  */
 #define       MC_CMD_INIT_RXQ_V3_IN_ES_HEAD_OF_LINE_BLOCK_TIMEOUT_OFST 556
 #define       MC_CMD_INIT_RXQ_V3_IN_ES_HEAD_OF_LINE_BLOCK_TIMEOUT_LEN 4
 
+/* MC_CMD_INIT_RXQ_V4_IN msgrequest: INIT_RXQ request with new field required
+ * for systems with a QDMA (currently, Riverhead)
+ */
+#define    MC_CMD_INIT_RXQ_V4_IN_LEN 564
+/* Size, in entries */
+#define       MC_CMD_INIT_RXQ_V4_IN_SIZE_OFST 0
+#define       MC_CMD_INIT_RXQ_V4_IN_SIZE_LEN 4
+/* The EVQ to send events to. This is an index originally specified to
+ * INIT_EVQ. If DMA_MODE == PACKED_STREAM this must be equal to INSTANCE.
+ */
+#define       MC_CMD_INIT_RXQ_V4_IN_TARGET_EVQ_OFST 4
+#define       MC_CMD_INIT_RXQ_V4_IN_TARGET_EVQ_LEN 4
+/* The value to put in the event data. Check hardware spec. for valid range.
+ * This field is ignored if DMA_MODE == EQUAL_STRIDE_SUPER_BUFFER or DMA_MODE
+ * == PACKED_STREAM.
+ */
+#define       MC_CMD_INIT_RXQ_V4_IN_LABEL_OFST 8
+#define       MC_CMD_INIT_RXQ_V4_IN_LABEL_LEN 4
+/* Desired instance. Must be set to a specific instance, which is a function
+ * local queue index.
+ */
+#define       MC_CMD_INIT_RXQ_V4_IN_INSTANCE_OFST 12
+#define       MC_CMD_INIT_RXQ_V4_IN_INSTANCE_LEN 4
+/* There will be more flags here. */
+#define       MC_CMD_INIT_RXQ_V4_IN_FLAGS_OFST 16
+#define       MC_CMD_INIT_RXQ_V4_IN_FLAGS_LEN 4
+#define        MC_CMD_INIT_RXQ_V4_IN_FLAG_BUFF_MODE_OFST 16
+#define        MC_CMD_INIT_RXQ_V4_IN_FLAG_BUFF_MODE_LBN 0
+#define        MC_CMD_INIT_RXQ_V4_IN_FLAG_BUFF_MODE_WIDTH 1
+#define        MC_CMD_INIT_RXQ_V4_IN_FLAG_HDR_SPLIT_OFST 16
+#define        MC_CMD_INIT_RXQ_V4_IN_FLAG_HDR_SPLIT_LBN 1
+#define        MC_CMD_INIT_RXQ_V4_IN_FLAG_HDR_SPLIT_WIDTH 1
+#define        MC_CMD_INIT_RXQ_V4_IN_FLAG_TIMESTAMP_OFST 16
+#define        MC_CMD_INIT_RXQ_V4_IN_FLAG_TIMESTAMP_LBN 2
+#define        MC_CMD_INIT_RXQ_V4_IN_FLAG_TIMESTAMP_WIDTH 1
+#define        MC_CMD_INIT_RXQ_V4_IN_CRC_MODE_OFST 16
+#define        MC_CMD_INIT_RXQ_V4_IN_CRC_MODE_LBN 3
+#define        MC_CMD_INIT_RXQ_V4_IN_CRC_MODE_WIDTH 4
+#define        MC_CMD_INIT_RXQ_V4_IN_FLAG_CHAIN_OFST 16
+#define        MC_CMD_INIT_RXQ_V4_IN_FLAG_CHAIN_LBN 7
+#define        MC_CMD_INIT_RXQ_V4_IN_FLAG_CHAIN_WIDTH 1
+#define        MC_CMD_INIT_RXQ_V4_IN_FLAG_PREFIX_OFST 16
+#define        MC_CMD_INIT_RXQ_V4_IN_FLAG_PREFIX_LBN 8
+#define        MC_CMD_INIT_RXQ_V4_IN_FLAG_PREFIX_WIDTH 1
+#define        MC_CMD_INIT_RXQ_V4_IN_FLAG_DISABLE_SCATTER_OFST 16
+#define        MC_CMD_INIT_RXQ_V4_IN_FLAG_DISABLE_SCATTER_LBN 9
+#define        MC_CMD_INIT_RXQ_V4_IN_FLAG_DISABLE_SCATTER_WIDTH 1
+#define        MC_CMD_INIT_RXQ_V4_IN_DMA_MODE_OFST 16
+#define        MC_CMD_INIT_RXQ_V4_IN_DMA_MODE_LBN 10
+#define        MC_CMD_INIT_RXQ_V4_IN_DMA_MODE_WIDTH 4
+/* enum: One packet per descriptor (for normal networking) */
+#define          MC_CMD_INIT_RXQ_V4_IN_SINGLE_PACKET 0x0
+/* enum: Pack multiple packets into large descriptors (for SolarCapture) */
+#define          MC_CMD_INIT_RXQ_V4_IN_PACKED_STREAM 0x1
+/* enum: Pack multiple packets into large descriptors using the format designed
+ * to maximise packet rate. This mode uses 1 "bucket" per descriptor with
+ * multiple fixed-size packet buffers within each bucket. For a full
+ * description see SF-119419-TC. This mode is only supported by "dpdk" datapath
+ * firmware.
+ */
+#define          MC_CMD_INIT_RXQ_V4_IN_EQUAL_STRIDE_SUPER_BUFFER 0x2
+/* enum: Deprecated name for EQUAL_STRIDE_SUPER_BUFFER. */
+#define          MC_CMD_INIT_RXQ_V4_IN_EQUAL_STRIDE_PACKED_STREAM 0x2
+#define        MC_CMD_INIT_RXQ_V4_IN_FLAG_SNAPSHOT_MODE_OFST 16
+#define        MC_CMD_INIT_RXQ_V4_IN_FLAG_SNAPSHOT_MODE_LBN 14
+#define        MC_CMD_INIT_RXQ_V4_IN_FLAG_SNAPSHOT_MODE_WIDTH 1
+#define        MC_CMD_INIT_RXQ_V4_IN_PACKED_STREAM_BUFF_SIZE_OFST 16
+#define        MC_CMD_INIT_RXQ_V4_IN_PACKED_STREAM_BUFF_SIZE_LBN 15
+#define        MC_CMD_INIT_RXQ_V4_IN_PACKED_STREAM_BUFF_SIZE_WIDTH 3
+#define          MC_CMD_INIT_RXQ_V4_IN_PS_BUFF_1M 0x0 /* enum */
+#define          MC_CMD_INIT_RXQ_V4_IN_PS_BUFF_512K 0x1 /* enum */
+#define          MC_CMD_INIT_RXQ_V4_IN_PS_BUFF_256K 0x2 /* enum */
+#define          MC_CMD_INIT_RXQ_V4_IN_PS_BUFF_128K 0x3 /* enum */
+#define          MC_CMD_INIT_RXQ_V4_IN_PS_BUFF_64K 0x4 /* enum */
+#define        MC_CMD_INIT_RXQ_V4_IN_FLAG_WANT_OUTER_CLASSES_OFST 16
+#define        MC_CMD_INIT_RXQ_V4_IN_FLAG_WANT_OUTER_CLASSES_LBN 18
+#define        MC_CMD_INIT_RXQ_V4_IN_FLAG_WANT_OUTER_CLASSES_WIDTH 1
+#define        MC_CMD_INIT_RXQ_V4_IN_FLAG_FORCE_EV_MERGING_OFST 16
+#define        MC_CMD_INIT_RXQ_V4_IN_FLAG_FORCE_EV_MERGING_LBN 19
+#define        MC_CMD_INIT_RXQ_V4_IN_FLAG_FORCE_EV_MERGING_WIDTH 1
+#define        MC_CMD_INIT_RXQ_V4_IN_FLAG_NO_CONT_EV_OFST 16
+#define        MC_CMD_INIT_RXQ_V4_IN_FLAG_NO_CONT_EV_LBN 20
+#define        MC_CMD_INIT_RXQ_V4_IN_FLAG_NO_CONT_EV_WIDTH 1
+/* Owner ID to use if in buffer mode (zero if physical) */
+#define       MC_CMD_INIT_RXQ_V4_IN_OWNER_ID_OFST 20
+#define       MC_CMD_INIT_RXQ_V4_IN_OWNER_ID_LEN 4
+/* The port ID associated with the v-adaptor which should contain this DMAQ. */
+#define       MC_CMD_INIT_RXQ_V4_IN_PORT_ID_OFST 24
+#define       MC_CMD_INIT_RXQ_V4_IN_PORT_ID_LEN 4
+/* 64-bit address of 4k of 4k-aligned host memory buffer */
+#define       MC_CMD_INIT_RXQ_V4_IN_DMA_ADDR_OFST 28
+#define       MC_CMD_INIT_RXQ_V4_IN_DMA_ADDR_LEN 8
+#define       MC_CMD_INIT_RXQ_V4_IN_DMA_ADDR_LO_OFST 28
+#define       MC_CMD_INIT_RXQ_V4_IN_DMA_ADDR_HI_OFST 32
+#define       MC_CMD_INIT_RXQ_V4_IN_DMA_ADDR_NUM 64
+/* Maximum length of packet to receive, if SNAPSHOT_MODE flag is set */
+#define       MC_CMD_INIT_RXQ_V4_IN_SNAPSHOT_LENGTH_OFST 540
+#define       MC_CMD_INIT_RXQ_V4_IN_SNAPSHOT_LENGTH_LEN 4
+/* The number of packet buffers that will be contained within each
+ * EQUAL_STRIDE_SUPER_BUFFER format bucket supplied by the driver. This field
+ * is ignored unless DMA_MODE == EQUAL_STRIDE_SUPER_BUFFER.
+ */
+#define       MC_CMD_INIT_RXQ_V4_IN_ES_PACKET_BUFFERS_PER_BUCKET_OFST 544
+#define       MC_CMD_INIT_RXQ_V4_IN_ES_PACKET_BUFFERS_PER_BUCKET_LEN 4
+/* The length in bytes of the area in each packet buffer that can be written to
+ * by the adapter. This is used to store the packet prefix and the packet
+ * payload. This length does not include any end padding added by the driver.
+ * This field is ignored unless DMA_MODE == EQUAL_STRIDE_SUPER_BUFFER.
+ */
+#define       MC_CMD_INIT_RXQ_V4_IN_ES_MAX_DMA_LEN_OFST 548
+#define       MC_CMD_INIT_RXQ_V4_IN_ES_MAX_DMA_LEN_LEN 4
+/* The length in bytes of a single packet buffer within a
+ * EQUAL_STRIDE_SUPER_BUFFER format bucket. This field is ignored unless
+ * DMA_MODE == EQUAL_STRIDE_SUPER_BUFFER.
+ */
+#define       MC_CMD_INIT_RXQ_V4_IN_ES_PACKET_STRIDE_OFST 552
+#define       MC_CMD_INIT_RXQ_V4_IN_ES_PACKET_STRIDE_LEN 4
+/* The maximum time in nanoseconds that the datapath will be backpressured if
+ * there are no RX descriptors available. If the timeout is reached and there
+ * are still no descriptors then the packet will be dropped. A timeout of 0
+ * means the datapath will never be blocked. This field is ignored unless
+ * DMA_MODE == EQUAL_STRIDE_SUPER_BUFFER.
+ */
+#define       MC_CMD_INIT_RXQ_V4_IN_ES_HEAD_OF_LINE_BLOCK_TIMEOUT_OFST 556
+#define       MC_CMD_INIT_RXQ_V4_IN_ES_HEAD_OF_LINE_BLOCK_TIMEOUT_LEN 4
+/* V4 message data */
+#define       MC_CMD_INIT_RXQ_V4_IN_V4_DATA_OFST 560
+#define       MC_CMD_INIT_RXQ_V4_IN_V4_DATA_LEN 4
+/* Size in bytes of buffers attached to descriptors posted to this queue. Set
+ * to zero if using this message on non-QDMA based platforms. Currently in
+ * Riverhead there is a global limit of eight different buffer sizes across all
+ * active queues. A 2KB and 4KB buffer is guaranteed to be available, but a
+ * request for a different buffer size will fail if there are already eight
+ * other buffer sizes in use. In future Riverhead this limit will go away and
+ * any size will be accepted.
+ */
+#define       MC_CMD_INIT_RXQ_V4_IN_BUFFER_SIZE_BYTES_OFST 560
+#define       MC_CMD_INIT_RXQ_V4_IN_BUFFER_SIZE_BYTES_LEN 4
+
+/* MC_CMD_INIT_RXQ_V5_IN msgrequest: INIT_RXQ request with ability to request a
+ * different RX packet prefix
+ */
+#define    MC_CMD_INIT_RXQ_V5_IN_LEN 568
+/* Size, in entries */
+#define       MC_CMD_INIT_RXQ_V5_IN_SIZE_OFST 0
+#define       MC_CMD_INIT_RXQ_V5_IN_SIZE_LEN 4
+/* The EVQ to send events to. This is an index originally specified to
+ * INIT_EVQ. If DMA_MODE == PACKED_STREAM this must be equal to INSTANCE.
+ */
+#define       MC_CMD_INIT_RXQ_V5_IN_TARGET_EVQ_OFST 4
+#define       MC_CMD_INIT_RXQ_V5_IN_TARGET_EVQ_LEN 4
+/* The value to put in the event data. Check hardware spec. for valid range.
+ * This field is ignored if DMA_MODE == EQUAL_STRIDE_SUPER_BUFFER or DMA_MODE
+ * == PACKED_STREAM.
+ */
+#define       MC_CMD_INIT_RXQ_V5_IN_LABEL_OFST 8
+#define       MC_CMD_INIT_RXQ_V5_IN_LABEL_LEN 4
+/* Desired instance. Must be set to a specific instance, which is a function
+ * local queue index.
+ */
+#define       MC_CMD_INIT_RXQ_V5_IN_INSTANCE_OFST 12
+#define       MC_CMD_INIT_RXQ_V5_IN_INSTANCE_LEN 4
+/* There will be more flags here. */
+#define       MC_CMD_INIT_RXQ_V5_IN_FLAGS_OFST 16
+#define       MC_CMD_INIT_RXQ_V5_IN_FLAGS_LEN 4
+#define        MC_CMD_INIT_RXQ_V5_IN_FLAG_BUFF_MODE_OFST 16
+#define        MC_CMD_INIT_RXQ_V5_IN_FLAG_BUFF_MODE_LBN 0
+#define        MC_CMD_INIT_RXQ_V5_IN_FLAG_BUFF_MODE_WIDTH 1
+#define        MC_CMD_INIT_RXQ_V5_IN_FLAG_HDR_SPLIT_OFST 16
+#define        MC_CMD_INIT_RXQ_V5_IN_FLAG_HDR_SPLIT_LBN 1
+#define        MC_CMD_INIT_RXQ_V5_IN_FLAG_HDR_SPLIT_WIDTH 1
+#define        MC_CMD_INIT_RXQ_V5_IN_FLAG_TIMESTAMP_OFST 16
+#define        MC_CMD_INIT_RXQ_V5_IN_FLAG_TIMESTAMP_LBN 2
+#define        MC_CMD_INIT_RXQ_V5_IN_FLAG_TIMESTAMP_WIDTH 1
+#define        MC_CMD_INIT_RXQ_V5_IN_CRC_MODE_OFST 16
+#define        MC_CMD_INIT_RXQ_V5_IN_CRC_MODE_LBN 3
+#define        MC_CMD_INIT_RXQ_V5_IN_CRC_MODE_WIDTH 4
+#define        MC_CMD_INIT_RXQ_V5_IN_FLAG_CHAIN_OFST 16
+#define        MC_CMD_INIT_RXQ_V5_IN_FLAG_CHAIN_LBN 7
+#define        MC_CMD_INIT_RXQ_V5_IN_FLAG_CHAIN_WIDTH 1
+#define        MC_CMD_INIT_RXQ_V5_IN_FLAG_PREFIX_OFST 16
+#define        MC_CMD_INIT_RXQ_V5_IN_FLAG_PREFIX_LBN 8
+#define        MC_CMD_INIT_RXQ_V5_IN_FLAG_PREFIX_WIDTH 1
+#define        MC_CMD_INIT_RXQ_V5_IN_FLAG_DISABLE_SCATTER_OFST 16
+#define        MC_CMD_INIT_RXQ_V5_IN_FLAG_DISABLE_SCATTER_LBN 9
+#define        MC_CMD_INIT_RXQ_V5_IN_FLAG_DISABLE_SCATTER_WIDTH 1
+#define        MC_CMD_INIT_RXQ_V5_IN_DMA_MODE_OFST 16
+#define        MC_CMD_INIT_RXQ_V5_IN_DMA_MODE_LBN 10
+#define        MC_CMD_INIT_RXQ_V5_IN_DMA_MODE_WIDTH 4
+/* enum: One packet per descriptor (for normal networking) */
+#define          MC_CMD_INIT_RXQ_V5_IN_SINGLE_PACKET 0x0
+/* enum: Pack multiple packets into large descriptors (for SolarCapture) */
+#define          MC_CMD_INIT_RXQ_V5_IN_PACKED_STREAM 0x1
+/* enum: Pack multiple packets into large descriptors using the format designed
+ * to maximise packet rate. This mode uses 1 "bucket" per descriptor with
+ * multiple fixed-size packet buffers within each bucket. For a full
+ * description see SF-119419-TC. This mode is only supported by "dpdk" datapath
+ * firmware.
+ */
+#define          MC_CMD_INIT_RXQ_V5_IN_EQUAL_STRIDE_SUPER_BUFFER 0x2
+/* enum: Deprecated name for EQUAL_STRIDE_SUPER_BUFFER. */
+#define          MC_CMD_INIT_RXQ_V5_IN_EQUAL_STRIDE_PACKED_STREAM 0x2
+#define        MC_CMD_INIT_RXQ_V5_IN_FLAG_SNAPSHOT_MODE_OFST 16
+#define        MC_CMD_INIT_RXQ_V5_IN_FLAG_SNAPSHOT_MODE_LBN 14
+#define        MC_CMD_INIT_RXQ_V5_IN_FLAG_SNAPSHOT_MODE_WIDTH 1
+#define        MC_CMD_INIT_RXQ_V5_IN_PACKED_STREAM_BUFF_SIZE_OFST 16
+#define        MC_CMD_INIT_RXQ_V5_IN_PACKED_STREAM_BUFF_SIZE_LBN 15
+#define        MC_CMD_INIT_RXQ_V5_IN_PACKED_STREAM_BUFF_SIZE_WIDTH 3
+#define          MC_CMD_INIT_RXQ_V5_IN_PS_BUFF_1M 0x0 /* enum */
+#define          MC_CMD_INIT_RXQ_V5_IN_PS_BUFF_512K 0x1 /* enum */
+#define          MC_CMD_INIT_RXQ_V5_IN_PS_BUFF_256K 0x2 /* enum */
+#define          MC_CMD_INIT_RXQ_V5_IN_PS_BUFF_128K 0x3 /* enum */
+#define          MC_CMD_INIT_RXQ_V5_IN_PS_BUFF_64K 0x4 /* enum */
+#define        MC_CMD_INIT_RXQ_V5_IN_FLAG_WANT_OUTER_CLASSES_OFST 16
+#define        MC_CMD_INIT_RXQ_V5_IN_FLAG_WANT_OUTER_CLASSES_LBN 18
+#define        MC_CMD_INIT_RXQ_V5_IN_FLAG_WANT_OUTER_CLASSES_WIDTH 1
+#define        MC_CMD_INIT_RXQ_V5_IN_FLAG_FORCE_EV_MERGING_OFST 16
+#define        MC_CMD_INIT_RXQ_V5_IN_FLAG_FORCE_EV_MERGING_LBN 19
+#define        MC_CMD_INIT_RXQ_V5_IN_FLAG_FORCE_EV_MERGING_WIDTH 1
+#define        MC_CMD_INIT_RXQ_V5_IN_FLAG_NO_CONT_EV_OFST 16
+#define        MC_CMD_INIT_RXQ_V5_IN_FLAG_NO_CONT_EV_LBN 20
+#define        MC_CMD_INIT_RXQ_V5_IN_FLAG_NO_CONT_EV_WIDTH 1
+/* Owner ID to use if in buffer mode (zero if physical) */
+#define       MC_CMD_INIT_RXQ_V5_IN_OWNER_ID_OFST 20
+#define       MC_CMD_INIT_RXQ_V5_IN_OWNER_ID_LEN 4
+/* The port ID associated with the v-adaptor which should contain this DMAQ. */
+#define       MC_CMD_INIT_RXQ_V5_IN_PORT_ID_OFST 24
+#define       MC_CMD_INIT_RXQ_V5_IN_PORT_ID_LEN 4
+/* 64-bit address of 4k of 4k-aligned host memory buffer */
+#define       MC_CMD_INIT_RXQ_V5_IN_DMA_ADDR_OFST 28
+#define       MC_CMD_INIT_RXQ_V5_IN_DMA_ADDR_LEN 8
+#define       MC_CMD_INIT_RXQ_V5_IN_DMA_ADDR_LO_OFST 28
+#define       MC_CMD_INIT_RXQ_V5_IN_DMA_ADDR_HI_OFST 32
+#define       MC_CMD_INIT_RXQ_V5_IN_DMA_ADDR_NUM 64
+/* Maximum length of packet to receive, if SNAPSHOT_MODE flag is set */
+#define       MC_CMD_INIT_RXQ_V5_IN_SNAPSHOT_LENGTH_OFST 540
+#define       MC_CMD_INIT_RXQ_V5_IN_SNAPSHOT_LENGTH_LEN 4
+/* The number of packet buffers that will be contained within each
+ * EQUAL_STRIDE_SUPER_BUFFER format bucket supplied by the driver. This field
+ * is ignored unless DMA_MODE == EQUAL_STRIDE_SUPER_BUFFER.
+ */
+#define       MC_CMD_INIT_RXQ_V5_IN_ES_PACKET_BUFFERS_PER_BUCKET_OFST 544
+#define       MC_CMD_INIT_RXQ_V5_IN_ES_PACKET_BUFFERS_PER_BUCKET_LEN 4
+/* The length in bytes of the area in each packet buffer that can be written to
+ * by the adapter. This is used to store the packet prefix and the packet
+ * payload. This length does not include any end padding added by the driver.
+ * This field is ignored unless DMA_MODE == EQUAL_STRIDE_SUPER_BUFFER.
+ */
+#define       MC_CMD_INIT_RXQ_V5_IN_ES_MAX_DMA_LEN_OFST 548
+#define       MC_CMD_INIT_RXQ_V5_IN_ES_MAX_DMA_LEN_LEN 4
+/* The length in bytes of a single packet buffer within a
+ * EQUAL_STRIDE_SUPER_BUFFER format bucket. This field is ignored unless
+ * DMA_MODE == EQUAL_STRIDE_SUPER_BUFFER.
+ */
+#define       MC_CMD_INIT_RXQ_V5_IN_ES_PACKET_STRIDE_OFST 552
+#define       MC_CMD_INIT_RXQ_V5_IN_ES_PACKET_STRIDE_LEN 4
+/* The maximum time in nanoseconds that the datapath will be backpressured if
+ * there are no RX descriptors available. If the timeout is reached and there
+ * are still no descriptors then the packet will be dropped. A timeout of 0
+ * means the datapath will never be blocked. This field is ignored unless
+ * DMA_MODE == EQUAL_STRIDE_SUPER_BUFFER.
+ */
+#define       MC_CMD_INIT_RXQ_V5_IN_ES_HEAD_OF_LINE_BLOCK_TIMEOUT_OFST 556
+#define       MC_CMD_INIT_RXQ_V5_IN_ES_HEAD_OF_LINE_BLOCK_TIMEOUT_LEN 4
+/* V4 message data */
+#define       MC_CMD_INIT_RXQ_V5_IN_V4_DATA_OFST 560
+#define       MC_CMD_INIT_RXQ_V5_IN_V4_DATA_LEN 4
+/* Size in bytes of buffers attached to descriptors posted to this queue. Set
+ * to zero if using this message on non-QDMA based platforms. Currently in
+ * Riverhead there is a global limit of eight different buffer sizes across all
+ * active queues. A 2KB and 4KB buffer is guaranteed to be available, but a
+ * request for a different buffer size will fail if there are already eight
+ * other buffer sizes in use. In future Riverhead this limit will go away and
+ * any size will be accepted.
+ */
+#define       MC_CMD_INIT_RXQ_V5_IN_BUFFER_SIZE_BYTES_OFST 560
+#define       MC_CMD_INIT_RXQ_V5_IN_BUFFER_SIZE_BYTES_LEN 4
+/* Prefix id for the RX prefix format to use on packets delivered this queue.
+ * Zero is always a valid prefix id and means the default prefix format
+ * documented for the platform. Other prefix ids can be obtained by calling
+ * MC_CMD_GET_RX_PREFIX_ID with a requested set of prefix fields.
+ */
+#define       MC_CMD_INIT_RXQ_V5_IN_RX_PREFIX_ID_OFST 564
+#define       MC_CMD_INIT_RXQ_V5_IN_RX_PREFIX_ID_LEN 4
+
 /* MC_CMD_INIT_RXQ_OUT msgresponse */
 #define    MC_CMD_INIT_RXQ_OUT_LEN 0
 
@@ -7526,11 +9250,18 @@
 /* MC_CMD_INIT_RXQ_V3_OUT msgresponse */
 #define    MC_CMD_INIT_RXQ_V3_OUT_LEN 0
 
+/* MC_CMD_INIT_RXQ_V4_OUT msgresponse */
+#define    MC_CMD_INIT_RXQ_V4_OUT_LEN 0
+
+/* MC_CMD_INIT_RXQ_V5_OUT msgresponse */
+#define    MC_CMD_INIT_RXQ_V5_OUT_LEN 0
+
 
 /***********************************/
 /* MC_CMD_INIT_TXQ
  */
 #define MC_CMD_INIT_TXQ 0x82
+#undef MC_CMD_0x82_PRIVILEGE_CTG
 
 #define MC_CMD_0x82_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -7539,7 +9270,9 @@
  */
 #define    MC_CMD_INIT_TXQ_IN_LENMIN 36
 #define    MC_CMD_INIT_TXQ_IN_LENMAX 252
+#define    MC_CMD_INIT_TXQ_IN_LENMAX_MCDI2 1020
 #define    MC_CMD_INIT_TXQ_IN_LEN(num) (28+8*(num))
+#define    MC_CMD_INIT_TXQ_IN_DMA_ADDR_NUM(len) (((len)-28)/8)
 /* Size, in entries */
 #define       MC_CMD_INIT_TXQ_IN_SIZE_OFST 0
 #define       MC_CMD_INIT_TXQ_IN_SIZE_LEN 4
@@ -7559,22 +9292,31 @@
 /* There will be more flags here. */
 #define       MC_CMD_INIT_TXQ_IN_FLAGS_OFST 16
 #define       MC_CMD_INIT_TXQ_IN_FLAGS_LEN 4
+#define        MC_CMD_INIT_TXQ_IN_FLAG_BUFF_MODE_OFST 16
 #define        MC_CMD_INIT_TXQ_IN_FLAG_BUFF_MODE_LBN 0
 #define        MC_CMD_INIT_TXQ_IN_FLAG_BUFF_MODE_WIDTH 1
+#define        MC_CMD_INIT_TXQ_IN_FLAG_IP_CSUM_DIS_OFST 16
 #define        MC_CMD_INIT_TXQ_IN_FLAG_IP_CSUM_DIS_LBN 1
 #define        MC_CMD_INIT_TXQ_IN_FLAG_IP_CSUM_DIS_WIDTH 1
+#define        MC_CMD_INIT_TXQ_IN_FLAG_TCP_CSUM_DIS_OFST 16
 #define        MC_CMD_INIT_TXQ_IN_FLAG_TCP_CSUM_DIS_LBN 2
 #define        MC_CMD_INIT_TXQ_IN_FLAG_TCP_CSUM_DIS_WIDTH 1
+#define        MC_CMD_INIT_TXQ_IN_FLAG_TCP_UDP_ONLY_OFST 16
 #define        MC_CMD_INIT_TXQ_IN_FLAG_TCP_UDP_ONLY_LBN 3
 #define        MC_CMD_INIT_TXQ_IN_FLAG_TCP_UDP_ONLY_WIDTH 1
+#define        MC_CMD_INIT_TXQ_IN_CRC_MODE_OFST 16
 #define        MC_CMD_INIT_TXQ_IN_CRC_MODE_LBN 4
 #define        MC_CMD_INIT_TXQ_IN_CRC_MODE_WIDTH 4
+#define        MC_CMD_INIT_TXQ_IN_FLAG_TIMESTAMP_OFST 16
 #define        MC_CMD_INIT_TXQ_IN_FLAG_TIMESTAMP_LBN 8
 #define        MC_CMD_INIT_TXQ_IN_FLAG_TIMESTAMP_WIDTH 1
+#define        MC_CMD_INIT_TXQ_IN_FLAG_PACER_BYPASS_OFST 16
 #define        MC_CMD_INIT_TXQ_IN_FLAG_PACER_BYPASS_LBN 9
 #define        MC_CMD_INIT_TXQ_IN_FLAG_PACER_BYPASS_WIDTH 1
+#define        MC_CMD_INIT_TXQ_IN_FLAG_INNER_IP_CSUM_EN_OFST 16
 #define        MC_CMD_INIT_TXQ_IN_FLAG_INNER_IP_CSUM_EN_LBN 10
 #define        MC_CMD_INIT_TXQ_IN_FLAG_INNER_IP_CSUM_EN_WIDTH 1
+#define        MC_CMD_INIT_TXQ_IN_FLAG_INNER_TCP_CSUM_EN_OFST 16
 #define        MC_CMD_INIT_TXQ_IN_FLAG_INNER_TCP_CSUM_EN_LBN 11
 #define        MC_CMD_INIT_TXQ_IN_FLAG_INNER_TCP_CSUM_EN_WIDTH 1
 /* Owner ID to use if in buffer mode (zero if physical) */
@@ -7590,6 +9332,7 @@
 #define       MC_CMD_INIT_TXQ_IN_DMA_ADDR_HI_OFST 32
 #define       MC_CMD_INIT_TXQ_IN_DMA_ADDR_MINNUM 1
 #define       MC_CMD_INIT_TXQ_IN_DMA_ADDR_MAXNUM 28
+#define       MC_CMD_INIT_TXQ_IN_DMA_ADDR_MAXNUM_MCDI2 124
 
 /* MC_CMD_INIT_TXQ_EXT_IN msgrequest: Extended INIT_TXQ with additional mode
  * flags
@@ -7614,30 +9357,48 @@
 /* There will be more flags here. */
 #define       MC_CMD_INIT_TXQ_EXT_IN_FLAGS_OFST 16
 #define       MC_CMD_INIT_TXQ_EXT_IN_FLAGS_LEN 4
+#define        MC_CMD_INIT_TXQ_EXT_IN_FLAG_BUFF_MODE_OFST 16
 #define        MC_CMD_INIT_TXQ_EXT_IN_FLAG_BUFF_MODE_LBN 0
 #define        MC_CMD_INIT_TXQ_EXT_IN_FLAG_BUFF_MODE_WIDTH 1
+#define        MC_CMD_INIT_TXQ_EXT_IN_FLAG_IP_CSUM_DIS_OFST 16
 #define        MC_CMD_INIT_TXQ_EXT_IN_FLAG_IP_CSUM_DIS_LBN 1
 #define        MC_CMD_INIT_TXQ_EXT_IN_FLAG_IP_CSUM_DIS_WIDTH 1
+#define        MC_CMD_INIT_TXQ_EXT_IN_FLAG_TCP_CSUM_DIS_OFST 16
 #define        MC_CMD_INIT_TXQ_EXT_IN_FLAG_TCP_CSUM_DIS_LBN 2
 #define        MC_CMD_INIT_TXQ_EXT_IN_FLAG_TCP_CSUM_DIS_WIDTH 1
+#define        MC_CMD_INIT_TXQ_EXT_IN_FLAG_TCP_UDP_ONLY_OFST 16
 #define        MC_CMD_INIT_TXQ_EXT_IN_FLAG_TCP_UDP_ONLY_LBN 3
 #define        MC_CMD_INIT_TXQ_EXT_IN_FLAG_TCP_UDP_ONLY_WIDTH 1
+#define        MC_CMD_INIT_TXQ_EXT_IN_CRC_MODE_OFST 16
 #define        MC_CMD_INIT_TXQ_EXT_IN_CRC_MODE_LBN 4
 #define        MC_CMD_INIT_TXQ_EXT_IN_CRC_MODE_WIDTH 4
+#define        MC_CMD_INIT_TXQ_EXT_IN_FLAG_TIMESTAMP_OFST 16
 #define        MC_CMD_INIT_TXQ_EXT_IN_FLAG_TIMESTAMP_LBN 8
 #define        MC_CMD_INIT_TXQ_EXT_IN_FLAG_TIMESTAMP_WIDTH 1
+#define        MC_CMD_INIT_TXQ_EXT_IN_FLAG_PACER_BYPASS_OFST 16
 #define        MC_CMD_INIT_TXQ_EXT_IN_FLAG_PACER_BYPASS_LBN 9
 #define        MC_CMD_INIT_TXQ_EXT_IN_FLAG_PACER_BYPASS_WIDTH 1
+#define        MC_CMD_INIT_TXQ_EXT_IN_FLAG_INNER_IP_CSUM_EN_OFST 16
 #define        MC_CMD_INIT_TXQ_EXT_IN_FLAG_INNER_IP_CSUM_EN_LBN 10
 #define        MC_CMD_INIT_TXQ_EXT_IN_FLAG_INNER_IP_CSUM_EN_WIDTH 1
+#define        MC_CMD_INIT_TXQ_EXT_IN_FLAG_INNER_TCP_CSUM_EN_OFST 16
 #define        MC_CMD_INIT_TXQ_EXT_IN_FLAG_INNER_TCP_CSUM_EN_LBN 11
 #define        MC_CMD_INIT_TXQ_EXT_IN_FLAG_INNER_TCP_CSUM_EN_WIDTH 1
+#define        MC_CMD_INIT_TXQ_EXT_IN_FLAG_TSOV2_EN_OFST 16
 #define        MC_CMD_INIT_TXQ_EXT_IN_FLAG_TSOV2_EN_LBN 12
 #define        MC_CMD_INIT_TXQ_EXT_IN_FLAG_TSOV2_EN_WIDTH 1
+#define        MC_CMD_INIT_TXQ_EXT_IN_FLAG_CTPIO_OFST 16
 #define        MC_CMD_INIT_TXQ_EXT_IN_FLAG_CTPIO_LBN 13
 #define        MC_CMD_INIT_TXQ_EXT_IN_FLAG_CTPIO_WIDTH 1
+#define        MC_CMD_INIT_TXQ_EXT_IN_FLAG_CTPIO_UTHRESH_OFST 16
 #define        MC_CMD_INIT_TXQ_EXT_IN_FLAG_CTPIO_UTHRESH_LBN 14
 #define        MC_CMD_INIT_TXQ_EXT_IN_FLAG_CTPIO_UTHRESH_WIDTH 1
+#define        MC_CMD_INIT_TXQ_EXT_IN_FLAG_M2M_D2C_OFST 16
+#define        MC_CMD_INIT_TXQ_EXT_IN_FLAG_M2M_D2C_LBN 15
+#define        MC_CMD_INIT_TXQ_EXT_IN_FLAG_M2M_D2C_WIDTH 1
+#define        MC_CMD_INIT_TXQ_EXT_IN_FLAG_DESC_PROXY_OFST 16
+#define        MC_CMD_INIT_TXQ_EXT_IN_FLAG_DESC_PROXY_LBN 16
+#define        MC_CMD_INIT_TXQ_EXT_IN_FLAG_DESC_PROXY_WIDTH 1
 /* Owner ID to use if in buffer mode (zero if physical) */
 #define       MC_CMD_INIT_TXQ_EXT_IN_OWNER_ID_OFST 20
 #define       MC_CMD_INIT_TXQ_EXT_IN_OWNER_ID_LEN 4
@@ -7651,11 +9412,14 @@
 #define       MC_CMD_INIT_TXQ_EXT_IN_DMA_ADDR_HI_OFST 32
 #define       MC_CMD_INIT_TXQ_EXT_IN_DMA_ADDR_MINNUM 1
 #define       MC_CMD_INIT_TXQ_EXT_IN_DMA_ADDR_MAXNUM 64
+#define       MC_CMD_INIT_TXQ_EXT_IN_DMA_ADDR_MAXNUM_MCDI2 64
 /* Flags related to Qbb flow control mode. */
 #define       MC_CMD_INIT_TXQ_EXT_IN_QBB_FLAGS_OFST 540
 #define       MC_CMD_INIT_TXQ_EXT_IN_QBB_FLAGS_LEN 4
+#define        MC_CMD_INIT_TXQ_EXT_IN_QBB_ENABLE_OFST 540
 #define        MC_CMD_INIT_TXQ_EXT_IN_QBB_ENABLE_LBN 0
 #define        MC_CMD_INIT_TXQ_EXT_IN_QBB_ENABLE_WIDTH 1
+#define        MC_CMD_INIT_TXQ_EXT_IN_QBB_PRIORITY_OFST 540
 #define        MC_CMD_INIT_TXQ_EXT_IN_QBB_PRIORITY_LBN 1
 #define        MC_CMD_INIT_TXQ_EXT_IN_QBB_PRIORITY_WIDTH 3
 
@@ -7671,6 +9435,7 @@
  * or the operation will fail with EBUSY
  */
 #define MC_CMD_FINI_EVQ 0x83
+#undef MC_CMD_0x83_PRIVILEGE_CTG
 
 #define MC_CMD_0x83_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -7691,6 +9456,7 @@
  * Teardown a RXQ.
  */
 #define MC_CMD_FINI_RXQ 0x84
+#undef MC_CMD_0x84_PRIVILEGE_CTG
 
 #define MC_CMD_0x84_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -7709,6 +9475,7 @@
  * Teardown a TXQ.
  */
 #define MC_CMD_FINI_TXQ 0x85
+#undef MC_CMD_0x85_PRIVILEGE_CTG
 
 #define MC_CMD_0x85_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -7727,6 +9494,7 @@
  * Generate an event on an EVQ belonging to the function issuing the command.
  */
 #define MC_CMD_DRIVER_EVENT 0x86
+#undef MC_CMD_0x86_PRIVILEGE_CTG
 
 #define MC_CMD_0x86_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -7753,6 +9521,7 @@
  * MC_CMD_SET_FUNC, which remains available for Siena but now deprecated.
  */
 #define MC_CMD_PROXY_CMD 0x5b
+#undef MC_CMD_0x5b_PRIVILEGE_CTG
 
 #define MC_CMD_0x5b_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
@@ -7761,8 +9530,10 @@
 /* The handle of the target function. */
 #define       MC_CMD_PROXY_CMD_IN_TARGET_OFST 0
 #define       MC_CMD_PROXY_CMD_IN_TARGET_LEN 4
+#define        MC_CMD_PROXY_CMD_IN_TARGET_PF_OFST 0
 #define        MC_CMD_PROXY_CMD_IN_TARGET_PF_LBN 0
 #define        MC_CMD_PROXY_CMD_IN_TARGET_PF_WIDTH 16
+#define        MC_CMD_PROXY_CMD_IN_TARGET_VF_OFST 0
 #define        MC_CMD_PROXY_CMD_IN_TARGET_VF_LBN 16
 #define        MC_CMD_PROXY_CMD_IN_TARGET_VF_WIDTH 16
 #define          MC_CMD_PROXY_CMD_IN_VF_NULL 0xffff /* enum */
@@ -7818,6 +9589,7 @@
  * a designated admin function
  */
 #define MC_CMD_PROXY_CONFIGURE 0x58
+#undef MC_CMD_0x58_PRIVILEGE_CTG
 
 #define MC_CMD_0x58_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
@@ -7825,6 +9597,7 @@
 #define    MC_CMD_PROXY_CONFIGURE_IN_LEN 108
 #define       MC_CMD_PROXY_CONFIGURE_IN_FLAGS_OFST 0
 #define       MC_CMD_PROXY_CONFIGURE_IN_FLAGS_LEN 4
+#define        MC_CMD_PROXY_CONFIGURE_IN_ENABLE_OFST 0
 #define        MC_CMD_PROXY_CONFIGURE_IN_ENABLE_LBN 0
 #define        MC_CMD_PROXY_CONFIGURE_IN_ENABLE_WIDTH 1
 /* Host provides a contiguous memory buffer that contains at least NUM_BLOCKS
@@ -7869,6 +9642,7 @@
 #define    MC_CMD_PROXY_CONFIGURE_EXT_IN_LEN 112
 #define       MC_CMD_PROXY_CONFIGURE_EXT_IN_FLAGS_OFST 0
 #define       MC_CMD_PROXY_CONFIGURE_EXT_IN_FLAGS_LEN 4
+#define        MC_CMD_PROXY_CONFIGURE_EXT_IN_ENABLE_OFST 0
 #define        MC_CMD_PROXY_CONFIGURE_EXT_IN_ENABLE_LBN 0
 #define        MC_CMD_PROXY_CONFIGURE_EXT_IN_ENABLE_WIDTH 1
 /* Host provides a contiguous memory buffer that contains at least NUM_BLOCKS
@@ -7923,6 +9697,7 @@
  * MC_CMD_PROXY_CONFIGURE).
  */
 #define MC_CMD_PROXY_COMPLETE 0x5f
+#undef MC_CMD_0x5f_PRIVILEGE_CTG
 
 #define MC_CMD_0x5f_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
@@ -7960,6 +9735,7 @@
  * cannot do so). The buffer table entries will initially be zeroed.
  */
 #define MC_CMD_ALLOC_BUFTBL_CHUNK 0x87
+#undef MC_CMD_0x87_PRIVILEGE_CTG
 
 #define MC_CMD_0x87_PRIVILEGE_CTG SRIOV_CTG_ONLOAD
 
@@ -7990,13 +9766,16 @@
  * Reprogram a set of buffer table entries in the specified chunk.
  */
 #define MC_CMD_PROGRAM_BUFTBL_ENTRIES 0x88
+#undef MC_CMD_0x88_PRIVILEGE_CTG
 
 #define MC_CMD_0x88_PRIVILEGE_CTG SRIOV_CTG_ONLOAD
 
 /* MC_CMD_PROGRAM_BUFTBL_ENTRIES_IN msgrequest */
 #define    MC_CMD_PROGRAM_BUFTBL_ENTRIES_IN_LENMIN 20
 #define    MC_CMD_PROGRAM_BUFTBL_ENTRIES_IN_LENMAX 268
+#define    MC_CMD_PROGRAM_BUFTBL_ENTRIES_IN_LENMAX_MCDI2 268
 #define    MC_CMD_PROGRAM_BUFTBL_ENTRIES_IN_LEN(num) (12+8*(num))
+#define    MC_CMD_PROGRAM_BUFTBL_ENTRIES_IN_ENTRY_NUM(len) (((len)-12)/8)
 #define       MC_CMD_PROGRAM_BUFTBL_ENTRIES_IN_HANDLE_OFST 0
 #define       MC_CMD_PROGRAM_BUFTBL_ENTRIES_IN_HANDLE_LEN 4
 /* ID */
@@ -8012,6 +9791,7 @@
 #define       MC_CMD_PROGRAM_BUFTBL_ENTRIES_IN_ENTRY_HI_OFST 16
 #define       MC_CMD_PROGRAM_BUFTBL_ENTRIES_IN_ENTRY_MINNUM 1
 #define       MC_CMD_PROGRAM_BUFTBL_ENTRIES_IN_ENTRY_MAXNUM 32
+#define       MC_CMD_PROGRAM_BUFTBL_ENTRIES_IN_ENTRY_MAXNUM_MCDI2 32
 
 /* MC_CMD_PROGRAM_BUFTBL_ENTRIES_OUT msgresponse */
 #define    MC_CMD_PROGRAM_BUFTBL_ENTRIES_OUT_LEN 0
@@ -8021,6 +9801,7 @@
 /* MC_CMD_FREE_BUFTBL_CHUNK
  */
 #define MC_CMD_FREE_BUFTBL_CHUNK 0x89
+#undef MC_CMD_0x89_PRIVILEGE_CTG
 
 #define MC_CMD_0x89_PRIVILEGE_CTG SRIOV_CTG_ONLOAD
 
@@ -8038,6 +9819,7 @@
  * Multiplexed MCDI call for filter operations
  */
 #define MC_CMD_FILTER_OP 0x8a
+#undef MC_CMD_0x8a_PRIVILEGE_CTG
 
 #define MC_CMD_0x8a_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -8070,32 +9852,46 @@
 /* fields to include in match criteria */
 #define       MC_CMD_FILTER_OP_IN_MATCH_FIELDS_OFST 16
 #define       MC_CMD_FILTER_OP_IN_MATCH_FIELDS_LEN 4
+#define        MC_CMD_FILTER_OP_IN_MATCH_SRC_IP_OFST 16
 #define        MC_CMD_FILTER_OP_IN_MATCH_SRC_IP_LBN 0
 #define        MC_CMD_FILTER_OP_IN_MATCH_SRC_IP_WIDTH 1
+#define        MC_CMD_FILTER_OP_IN_MATCH_DST_IP_OFST 16
 #define        MC_CMD_FILTER_OP_IN_MATCH_DST_IP_LBN 1
 #define        MC_CMD_FILTER_OP_IN_MATCH_DST_IP_WIDTH 1
+#define        MC_CMD_FILTER_OP_IN_MATCH_SRC_MAC_OFST 16
 #define        MC_CMD_FILTER_OP_IN_MATCH_SRC_MAC_LBN 2
 #define        MC_CMD_FILTER_OP_IN_MATCH_SRC_MAC_WIDTH 1
+#define        MC_CMD_FILTER_OP_IN_MATCH_SRC_PORT_OFST 16
 #define        MC_CMD_FILTER_OP_IN_MATCH_SRC_PORT_LBN 3
 #define        MC_CMD_FILTER_OP_IN_MATCH_SRC_PORT_WIDTH 1
+#define        MC_CMD_FILTER_OP_IN_MATCH_DST_MAC_OFST 16
 #define        MC_CMD_FILTER_OP_IN_MATCH_DST_MAC_LBN 4
 #define        MC_CMD_FILTER_OP_IN_MATCH_DST_MAC_WIDTH 1
+#define        MC_CMD_FILTER_OP_IN_MATCH_DST_PORT_OFST 16
 #define        MC_CMD_FILTER_OP_IN_MATCH_DST_PORT_LBN 5
 #define        MC_CMD_FILTER_OP_IN_MATCH_DST_PORT_WIDTH 1
+#define        MC_CMD_FILTER_OP_IN_MATCH_ETHER_TYPE_OFST 16
 #define        MC_CMD_FILTER_OP_IN_MATCH_ETHER_TYPE_LBN 6
 #define        MC_CMD_FILTER_OP_IN_MATCH_ETHER_TYPE_WIDTH 1
+#define        MC_CMD_FILTER_OP_IN_MATCH_INNER_VLAN_OFST 16
 #define        MC_CMD_FILTER_OP_IN_MATCH_INNER_VLAN_LBN 7
 #define        MC_CMD_FILTER_OP_IN_MATCH_INNER_VLAN_WIDTH 1
+#define        MC_CMD_FILTER_OP_IN_MATCH_OUTER_VLAN_OFST 16
 #define        MC_CMD_FILTER_OP_IN_MATCH_OUTER_VLAN_LBN 8
 #define        MC_CMD_FILTER_OP_IN_MATCH_OUTER_VLAN_WIDTH 1
+#define        MC_CMD_FILTER_OP_IN_MATCH_IP_PROTO_OFST 16
 #define        MC_CMD_FILTER_OP_IN_MATCH_IP_PROTO_LBN 9
 #define        MC_CMD_FILTER_OP_IN_MATCH_IP_PROTO_WIDTH 1
+#define        MC_CMD_FILTER_OP_IN_MATCH_FWDEF0_OFST 16
 #define        MC_CMD_FILTER_OP_IN_MATCH_FWDEF0_LBN 10
 #define        MC_CMD_FILTER_OP_IN_MATCH_FWDEF0_WIDTH 1
+#define        MC_CMD_FILTER_OP_IN_MATCH_FWDEF1_OFST 16
 #define        MC_CMD_FILTER_OP_IN_MATCH_FWDEF1_LBN 11
 #define        MC_CMD_FILTER_OP_IN_MATCH_FWDEF1_WIDTH 1
+#define        MC_CMD_FILTER_OP_IN_MATCH_UNKNOWN_MCAST_DST_OFST 16
 #define        MC_CMD_FILTER_OP_IN_MATCH_UNKNOWN_MCAST_DST_LBN 30
 #define        MC_CMD_FILTER_OP_IN_MATCH_UNKNOWN_MCAST_DST_WIDTH 1
+#define        MC_CMD_FILTER_OP_IN_MATCH_UNKNOWN_UCAST_DST_OFST 16
 #define        MC_CMD_FILTER_OP_IN_MATCH_UNKNOWN_UCAST_DST_LBN 31
 #define        MC_CMD_FILTER_OP_IN_MATCH_UNKNOWN_UCAST_DST_WIDTH 1
 /* receive destination */
@@ -8143,8 +9939,10 @@
 #define       MC_CMD_FILTER_OP_IN_TX_DEST_LEN 4
 /* enum: request default behaviour (based on filter type) */
 #define          MC_CMD_FILTER_OP_IN_TX_DEST_DEFAULT 0xffffffff
+#define        MC_CMD_FILTER_OP_IN_TX_DEST_MAC_OFST 40
 #define        MC_CMD_FILTER_OP_IN_TX_DEST_MAC_LBN 0
 #define        MC_CMD_FILTER_OP_IN_TX_DEST_MAC_WIDTH 1
+#define        MC_CMD_FILTER_OP_IN_TX_DEST_PM_OFST 40
 #define        MC_CMD_FILTER_OP_IN_TX_DEST_PM_LBN 1
 #define        MC_CMD_FILTER_OP_IN_TX_DEST_PM_WIDTH 1
 /* source MAC address to match (as bytes in network order) */
@@ -8210,60 +10008,88 @@
 /* fields to include in match criteria */
 #define       MC_CMD_FILTER_OP_EXT_IN_MATCH_FIELDS_OFST 16
 #define       MC_CMD_FILTER_OP_EXT_IN_MATCH_FIELDS_LEN 4
+#define        MC_CMD_FILTER_OP_EXT_IN_MATCH_SRC_IP_OFST 16
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_SRC_IP_LBN 0
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_SRC_IP_WIDTH 1
+#define        MC_CMD_FILTER_OP_EXT_IN_MATCH_DST_IP_OFST 16
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_DST_IP_LBN 1
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_DST_IP_WIDTH 1
+#define        MC_CMD_FILTER_OP_EXT_IN_MATCH_SRC_MAC_OFST 16
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_SRC_MAC_LBN 2
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_SRC_MAC_WIDTH 1
+#define        MC_CMD_FILTER_OP_EXT_IN_MATCH_SRC_PORT_OFST 16
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_SRC_PORT_LBN 3
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_SRC_PORT_WIDTH 1
+#define        MC_CMD_FILTER_OP_EXT_IN_MATCH_DST_MAC_OFST 16
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_DST_MAC_LBN 4
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_DST_MAC_WIDTH 1
+#define        MC_CMD_FILTER_OP_EXT_IN_MATCH_DST_PORT_OFST 16
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_DST_PORT_LBN 5
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_DST_PORT_WIDTH 1
+#define        MC_CMD_FILTER_OP_EXT_IN_MATCH_ETHER_TYPE_OFST 16
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_ETHER_TYPE_LBN 6
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_ETHER_TYPE_WIDTH 1
+#define        MC_CMD_FILTER_OP_EXT_IN_MATCH_INNER_VLAN_OFST 16
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_INNER_VLAN_LBN 7
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_INNER_VLAN_WIDTH 1
+#define        MC_CMD_FILTER_OP_EXT_IN_MATCH_OUTER_VLAN_OFST 16
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_OUTER_VLAN_LBN 8
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_OUTER_VLAN_WIDTH 1
+#define        MC_CMD_FILTER_OP_EXT_IN_MATCH_IP_PROTO_OFST 16
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_IP_PROTO_LBN 9
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_IP_PROTO_WIDTH 1
+#define        MC_CMD_FILTER_OP_EXT_IN_MATCH_FWDEF0_OFST 16
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_FWDEF0_LBN 10
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_FWDEF0_WIDTH 1
+#define        MC_CMD_FILTER_OP_EXT_IN_MATCH_VNI_OR_VSID_OFST 16
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_VNI_OR_VSID_LBN 11
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_VNI_OR_VSID_WIDTH 1
+#define        MC_CMD_FILTER_OP_EXT_IN_MATCH_IFRM_SRC_IP_OFST 16
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_IFRM_SRC_IP_LBN 12
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_IFRM_SRC_IP_WIDTH 1
+#define        MC_CMD_FILTER_OP_EXT_IN_MATCH_IFRM_DST_IP_OFST 16
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_IFRM_DST_IP_LBN 13
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_IFRM_DST_IP_WIDTH 1
+#define        MC_CMD_FILTER_OP_EXT_IN_MATCH_IFRM_SRC_MAC_OFST 16
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_IFRM_SRC_MAC_LBN 14
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_IFRM_SRC_MAC_WIDTH 1
+#define        MC_CMD_FILTER_OP_EXT_IN_MATCH_IFRM_SRC_PORT_OFST 16
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_IFRM_SRC_PORT_LBN 15
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_IFRM_SRC_PORT_WIDTH 1
+#define        MC_CMD_FILTER_OP_EXT_IN_MATCH_IFRM_DST_MAC_OFST 16
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_IFRM_DST_MAC_LBN 16
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_IFRM_DST_MAC_WIDTH 1
+#define        MC_CMD_FILTER_OP_EXT_IN_MATCH_IFRM_DST_PORT_OFST 16
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_IFRM_DST_PORT_LBN 17
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_IFRM_DST_PORT_WIDTH 1
+#define        MC_CMD_FILTER_OP_EXT_IN_MATCH_IFRM_ETHER_TYPE_OFST 16
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_IFRM_ETHER_TYPE_LBN 18
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_IFRM_ETHER_TYPE_WIDTH 1
+#define        MC_CMD_FILTER_OP_EXT_IN_MATCH_IFRM_INNER_VLAN_OFST 16
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_IFRM_INNER_VLAN_LBN 19
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_IFRM_INNER_VLAN_WIDTH 1
+#define        MC_CMD_FILTER_OP_EXT_IN_MATCH_IFRM_OUTER_VLAN_OFST 16
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_IFRM_OUTER_VLAN_LBN 20
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_IFRM_OUTER_VLAN_WIDTH 1
+#define        MC_CMD_FILTER_OP_EXT_IN_MATCH_IFRM_IP_PROTO_OFST 16
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_IFRM_IP_PROTO_LBN 21
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_IFRM_IP_PROTO_WIDTH 1
+#define        MC_CMD_FILTER_OP_EXT_IN_MATCH_IFRM_FWDEF0_OFST 16
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_IFRM_FWDEF0_LBN 22
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_IFRM_FWDEF0_WIDTH 1
+#define        MC_CMD_FILTER_OP_EXT_IN_MATCH_IFRM_FWDEF1_OFST 16
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_IFRM_FWDEF1_LBN 23
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_IFRM_FWDEF1_WIDTH 1
+#define        MC_CMD_FILTER_OP_EXT_IN_MATCH_IFRM_UNKNOWN_MCAST_DST_OFST 16
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_IFRM_UNKNOWN_MCAST_DST_LBN 24
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_IFRM_UNKNOWN_MCAST_DST_WIDTH 1
+#define        MC_CMD_FILTER_OP_EXT_IN_MATCH_IFRM_UNKNOWN_UCAST_DST_OFST 16
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_IFRM_UNKNOWN_UCAST_DST_LBN 25
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_IFRM_UNKNOWN_UCAST_DST_WIDTH 1
+#define        MC_CMD_FILTER_OP_EXT_IN_MATCH_UNKNOWN_MCAST_DST_OFST 16
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_UNKNOWN_MCAST_DST_LBN 30
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_UNKNOWN_MCAST_DST_WIDTH 1
+#define        MC_CMD_FILTER_OP_EXT_IN_MATCH_UNKNOWN_UCAST_DST_OFST 16
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_UNKNOWN_UCAST_DST_LBN 31
 #define        MC_CMD_FILTER_OP_EXT_IN_MATCH_UNKNOWN_UCAST_DST_WIDTH 1
 /* receive destination */
@@ -8311,8 +10137,10 @@
 #define       MC_CMD_FILTER_OP_EXT_IN_TX_DEST_LEN 4
 /* enum: request default behaviour (based on filter type) */
 #define          MC_CMD_FILTER_OP_EXT_IN_TX_DEST_DEFAULT 0xffffffff
+#define        MC_CMD_FILTER_OP_EXT_IN_TX_DEST_MAC_OFST 40
 #define        MC_CMD_FILTER_OP_EXT_IN_TX_DEST_MAC_LBN 0
 #define        MC_CMD_FILTER_OP_EXT_IN_TX_DEST_MAC_WIDTH 1
+#define        MC_CMD_FILTER_OP_EXT_IN_TX_DEST_PM_OFST 40
 #define        MC_CMD_FILTER_OP_EXT_IN_TX_DEST_PM_LBN 1
 #define        MC_CMD_FILTER_OP_EXT_IN_TX_DEST_PM_WIDTH 1
 /* source MAC address to match (as bytes in network order) */
@@ -8348,8 +10176,10 @@
  */
 #define       MC_CMD_FILTER_OP_EXT_IN_VNI_OR_VSID_OFST 72
 #define       MC_CMD_FILTER_OP_EXT_IN_VNI_OR_VSID_LEN 4
+#define        MC_CMD_FILTER_OP_EXT_IN_VNI_VALUE_OFST 72
 #define        MC_CMD_FILTER_OP_EXT_IN_VNI_VALUE_LBN 0
 #define        MC_CMD_FILTER_OP_EXT_IN_VNI_VALUE_WIDTH 24
+#define        MC_CMD_FILTER_OP_EXT_IN_VNI_TYPE_OFST 72
 #define        MC_CMD_FILTER_OP_EXT_IN_VNI_TYPE_LBN 24
 #define        MC_CMD_FILTER_OP_EXT_IN_VNI_TYPE_WIDTH 8
 /* enum: Match VXLAN traffic with this VNI */
@@ -8358,8 +10188,10 @@
 #define          MC_CMD_FILTER_OP_EXT_IN_VNI_TYPE_GENEVE 0x1
 /* enum: Reserved for experimental development use */
 #define          MC_CMD_FILTER_OP_EXT_IN_VNI_TYPE_EXPERIMENTAL 0xfe
+#define        MC_CMD_FILTER_OP_EXT_IN_VSID_VALUE_OFST 72
 #define        MC_CMD_FILTER_OP_EXT_IN_VSID_VALUE_LBN 0
 #define        MC_CMD_FILTER_OP_EXT_IN_VSID_VALUE_WIDTH 24
+#define        MC_CMD_FILTER_OP_EXT_IN_VSID_TYPE_OFST 72
 #define        MC_CMD_FILTER_OP_EXT_IN_VSID_TYPE_LBN 24
 #define        MC_CMD_FILTER_OP_EXT_IN_VSID_TYPE_WIDTH 8
 /* enum: Match NVGRE traffic with this VSID */
@@ -8454,60 +10286,88 @@
 /* fields to include in match criteria */
 #define       MC_CMD_FILTER_OP_V3_IN_MATCH_FIELDS_OFST 16
 #define       MC_CMD_FILTER_OP_V3_IN_MATCH_FIELDS_LEN 4
+#define        MC_CMD_FILTER_OP_V3_IN_MATCH_SRC_IP_OFST 16
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_SRC_IP_LBN 0
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_SRC_IP_WIDTH 1
+#define        MC_CMD_FILTER_OP_V3_IN_MATCH_DST_IP_OFST 16
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_DST_IP_LBN 1
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_DST_IP_WIDTH 1
+#define        MC_CMD_FILTER_OP_V3_IN_MATCH_SRC_MAC_OFST 16
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_SRC_MAC_LBN 2
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_SRC_MAC_WIDTH 1
+#define        MC_CMD_FILTER_OP_V3_IN_MATCH_SRC_PORT_OFST 16
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_SRC_PORT_LBN 3
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_SRC_PORT_WIDTH 1
+#define        MC_CMD_FILTER_OP_V3_IN_MATCH_DST_MAC_OFST 16
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_DST_MAC_LBN 4
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_DST_MAC_WIDTH 1
+#define        MC_CMD_FILTER_OP_V3_IN_MATCH_DST_PORT_OFST 16
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_DST_PORT_LBN 5
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_DST_PORT_WIDTH 1
+#define        MC_CMD_FILTER_OP_V3_IN_MATCH_ETHER_TYPE_OFST 16
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_ETHER_TYPE_LBN 6
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_ETHER_TYPE_WIDTH 1
+#define        MC_CMD_FILTER_OP_V3_IN_MATCH_INNER_VLAN_OFST 16
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_INNER_VLAN_LBN 7
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_INNER_VLAN_WIDTH 1
+#define        MC_CMD_FILTER_OP_V3_IN_MATCH_OUTER_VLAN_OFST 16
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_OUTER_VLAN_LBN 8
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_OUTER_VLAN_WIDTH 1
+#define        MC_CMD_FILTER_OP_V3_IN_MATCH_IP_PROTO_OFST 16
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_IP_PROTO_LBN 9
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_IP_PROTO_WIDTH 1
+#define        MC_CMD_FILTER_OP_V3_IN_MATCH_FWDEF0_OFST 16
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_FWDEF0_LBN 10
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_FWDEF0_WIDTH 1
+#define        MC_CMD_FILTER_OP_V3_IN_MATCH_VNI_OR_VSID_OFST 16
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_VNI_OR_VSID_LBN 11
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_VNI_OR_VSID_WIDTH 1
+#define        MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_SRC_IP_OFST 16
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_SRC_IP_LBN 12
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_SRC_IP_WIDTH 1
+#define        MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_DST_IP_OFST 16
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_DST_IP_LBN 13
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_DST_IP_WIDTH 1
+#define        MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_SRC_MAC_OFST 16
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_SRC_MAC_LBN 14
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_SRC_MAC_WIDTH 1
+#define        MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_SRC_PORT_OFST 16
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_SRC_PORT_LBN 15
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_SRC_PORT_WIDTH 1
+#define        MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_DST_MAC_OFST 16
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_DST_MAC_LBN 16
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_DST_MAC_WIDTH 1
+#define        MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_DST_PORT_OFST 16
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_DST_PORT_LBN 17
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_DST_PORT_WIDTH 1
+#define        MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_ETHER_TYPE_OFST 16
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_ETHER_TYPE_LBN 18
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_ETHER_TYPE_WIDTH 1
+#define        MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_INNER_VLAN_OFST 16
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_INNER_VLAN_LBN 19
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_INNER_VLAN_WIDTH 1
+#define        MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_OUTER_VLAN_OFST 16
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_OUTER_VLAN_LBN 20
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_OUTER_VLAN_WIDTH 1
+#define        MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_IP_PROTO_OFST 16
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_IP_PROTO_LBN 21
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_IP_PROTO_WIDTH 1
+#define        MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_FWDEF0_OFST 16
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_FWDEF0_LBN 22
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_FWDEF0_WIDTH 1
+#define        MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_FWDEF1_OFST 16
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_FWDEF1_LBN 23
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_FWDEF1_WIDTH 1
+#define        MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_UNKNOWN_MCAST_DST_OFST 16
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_UNKNOWN_MCAST_DST_LBN 24
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_UNKNOWN_MCAST_DST_WIDTH 1
+#define        MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_UNKNOWN_UCAST_DST_OFST 16
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_UNKNOWN_UCAST_DST_LBN 25
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_UNKNOWN_UCAST_DST_WIDTH 1
+#define        MC_CMD_FILTER_OP_V3_IN_MATCH_UNKNOWN_MCAST_DST_OFST 16
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_UNKNOWN_MCAST_DST_LBN 30
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_UNKNOWN_MCAST_DST_WIDTH 1
+#define        MC_CMD_FILTER_OP_V3_IN_MATCH_UNKNOWN_UCAST_DST_OFST 16
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_UNKNOWN_UCAST_DST_LBN 31
 #define        MC_CMD_FILTER_OP_V3_IN_MATCH_UNKNOWN_UCAST_DST_WIDTH 1
 /* receive destination */
@@ -8555,8 +10415,10 @@
 #define       MC_CMD_FILTER_OP_V3_IN_TX_DEST_LEN 4
 /* enum: request default behaviour (based on filter type) */
 #define          MC_CMD_FILTER_OP_V3_IN_TX_DEST_DEFAULT 0xffffffff
+#define        MC_CMD_FILTER_OP_V3_IN_TX_DEST_MAC_OFST 40
 #define        MC_CMD_FILTER_OP_V3_IN_TX_DEST_MAC_LBN 0
 #define        MC_CMD_FILTER_OP_V3_IN_TX_DEST_MAC_WIDTH 1
+#define        MC_CMD_FILTER_OP_V3_IN_TX_DEST_PM_OFST 40
 #define        MC_CMD_FILTER_OP_V3_IN_TX_DEST_PM_LBN 1
 #define        MC_CMD_FILTER_OP_V3_IN_TX_DEST_PM_WIDTH 1
 /* source MAC address to match (as bytes in network order) */
@@ -8592,8 +10454,10 @@
  */
 #define       MC_CMD_FILTER_OP_V3_IN_VNI_OR_VSID_OFST 72
 #define       MC_CMD_FILTER_OP_V3_IN_VNI_OR_VSID_LEN 4
+#define        MC_CMD_FILTER_OP_V3_IN_VNI_VALUE_OFST 72
 #define        MC_CMD_FILTER_OP_V3_IN_VNI_VALUE_LBN 0
 #define        MC_CMD_FILTER_OP_V3_IN_VNI_VALUE_WIDTH 24
+#define        MC_CMD_FILTER_OP_V3_IN_VNI_TYPE_OFST 72
 #define        MC_CMD_FILTER_OP_V3_IN_VNI_TYPE_LBN 24
 #define        MC_CMD_FILTER_OP_V3_IN_VNI_TYPE_WIDTH 8
 /* enum: Match VXLAN traffic with this VNI */
@@ -8602,8 +10466,10 @@
 #define          MC_CMD_FILTER_OP_V3_IN_VNI_TYPE_GENEVE 0x1
 /* enum: Reserved for experimental development use */
 #define          MC_CMD_FILTER_OP_V3_IN_VNI_TYPE_EXPERIMENTAL 0xfe
+#define        MC_CMD_FILTER_OP_V3_IN_VSID_VALUE_OFST 72
 #define        MC_CMD_FILTER_OP_V3_IN_VSID_VALUE_LBN 0
 #define        MC_CMD_FILTER_OP_V3_IN_VSID_VALUE_WIDTH 24
+#define        MC_CMD_FILTER_OP_V3_IN_VSID_TYPE_OFST 72
 #define        MC_CMD_FILTER_OP_V3_IN_VSID_TYPE_LBN 24
 #define        MC_CMD_FILTER_OP_V3_IN_VSID_TYPE_WIDTH 8
 /* enum: Match NVGRE traffic with this VSID */
@@ -8693,7 +10559,10 @@
  * support the DPDK rte_flow "MARK" action.
  */
 #define          MC_CMD_FILTER_OP_V3_IN_MATCH_ACTION_MARK 0x2
-/* the mark value for MATCH_ACTION_MARK */
+/* the mark value for MATCH_ACTION_MARK. Requesting a value larger than the
+ * maximum (obtained from MC_CMD_GET_CAPABILITIES_V5/FILTER_ACTION_MARK_MAX)
+ * will cause the filter insertion to fail with EINVAL.
+ */
 #define       MC_CMD_FILTER_OP_V3_IN_MATCH_MARK_VALUE_OFST 176
 #define       MC_CMD_FILTER_OP_V3_IN_MATCH_MARK_VALUE_LEN 4
 
@@ -8741,6 +10610,7 @@
  * Get information related to the parser-dispatcher subsystem
  */
 #define MC_CMD_GET_PARSER_DISP_INFO 0xe4
+#undef MC_CMD_0xe4_PRIVILEGE_CTG
 
 #define MC_CMD_0xe4_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -8764,11 +10634,17 @@
  * frames (Medford only)
  */
 #define          MC_CMD_GET_PARSER_DISP_INFO_IN_OP_GET_SUPPORTED_ENCAP_RX_MATCHES 0x4
+/* enum: read the list of supported matches for the encapsulation detection
+ * rules inserted by MC_CMD_VNIC_ENCAP_RULE_ADD. (ef100 and later)
+ */
+#define          MC_CMD_GET_PARSER_DISP_INFO_IN_OP_GET_SUPPORTED_VNIC_ENCAP_MATCHES 0x5
 
 /* MC_CMD_GET_PARSER_DISP_INFO_OUT msgresponse */
 #define    MC_CMD_GET_PARSER_DISP_INFO_OUT_LENMIN 8
 #define    MC_CMD_GET_PARSER_DISP_INFO_OUT_LENMAX 252
+#define    MC_CMD_GET_PARSER_DISP_INFO_OUT_LENMAX_MCDI2 1020
 #define    MC_CMD_GET_PARSER_DISP_INFO_OUT_LEN(num) (8+4*(num))
+#define    MC_CMD_GET_PARSER_DISP_INFO_OUT_SUPPORTED_MATCHES_NUM(len) (((len)-8)/4)
 /* identifies the type of operation requested */
 #define       MC_CMD_GET_PARSER_DISP_INFO_OUT_OP_OFST 0
 #define       MC_CMD_GET_PARSER_DISP_INFO_OUT_OP_LEN 4
@@ -8784,6 +10660,7 @@
 #define       MC_CMD_GET_PARSER_DISP_INFO_OUT_SUPPORTED_MATCHES_LEN 4
 #define       MC_CMD_GET_PARSER_DISP_INFO_OUT_SUPPORTED_MATCHES_MINNUM 0
 #define       MC_CMD_GET_PARSER_DISP_INFO_OUT_SUPPORTED_MATCHES_MAXNUM 61
+#define       MC_CMD_GET_PARSER_DISP_INFO_OUT_SUPPORTED_MATCHES_MAXNUM_MCDI2 253
 
 /* MC_CMD_GET_PARSER_DISP_RESTRICTIONS_OUT msgresponse */
 #define    MC_CMD_GET_PARSER_DISP_RESTRICTIONS_OUT_LEN 8
@@ -8795,9 +10672,38 @@
 /* bitfield of filter insertion restrictions */
 #define       MC_CMD_GET_PARSER_DISP_RESTRICTIONS_OUT_RESTRICTION_FLAGS_OFST 4
 #define       MC_CMD_GET_PARSER_DISP_RESTRICTIONS_OUT_RESTRICTION_FLAGS_LEN 4
+#define        MC_CMD_GET_PARSER_DISP_RESTRICTIONS_OUT_DST_IP_MCAST_ONLY_OFST 4
 #define        MC_CMD_GET_PARSER_DISP_RESTRICTIONS_OUT_DST_IP_MCAST_ONLY_LBN 0
 #define        MC_CMD_GET_PARSER_DISP_RESTRICTIONS_OUT_DST_IP_MCAST_ONLY_WIDTH 1
 
+/* MC_CMD_GET_PARSER_DISP_VNIC_ENCAP_MATCHES_OUT msgresponse: This response is
+ * returned if a MC_CMD_GET_PARSER_DISP_INFO_IN request is sent with OP value
+ * OP_GET_SUPPORTED_VNIC_ENCAP_MATCHES. It contains information about the
+ * supported match types that can be used in the encapsulation detection rules
+ * inserted by MC_CMD_VNIC_ENCAP_RULE_ADD.
+ */
+#define    MC_CMD_GET_PARSER_DISP_VNIC_ENCAP_MATCHES_OUT_LENMIN 8
+#define    MC_CMD_GET_PARSER_DISP_VNIC_ENCAP_MATCHES_OUT_LENMAX 252
+#define    MC_CMD_GET_PARSER_DISP_VNIC_ENCAP_MATCHES_OUT_LENMAX_MCDI2 1020
+#define    MC_CMD_GET_PARSER_DISP_VNIC_ENCAP_MATCHES_OUT_LEN(num) (8+4*(num))
+#define    MC_CMD_GET_PARSER_DISP_VNIC_ENCAP_MATCHES_OUT_SUPPORTED_MATCHES_NUM(len) (((len)-8)/4)
+/* The op code OP_GET_SUPPORTED_VNIC_ENCAP_MATCHES is returned. */
+#define       MC_CMD_GET_PARSER_DISP_VNIC_ENCAP_MATCHES_OUT_OP_OFST 0
+#define       MC_CMD_GET_PARSER_DISP_VNIC_ENCAP_MATCHES_OUT_OP_LEN 4
+/*            Enum values, see field(s): */
+/*               MC_CMD_GET_PARSER_DISP_INFO_IN/OP */
+/* number of supported match types */
+#define       MC_CMD_GET_PARSER_DISP_VNIC_ENCAP_MATCHES_OUT_NUM_SUPPORTED_MATCHES_OFST 4
+#define       MC_CMD_GET_PARSER_DISP_VNIC_ENCAP_MATCHES_OUT_NUM_SUPPORTED_MATCHES_LEN 4
+/* array of supported match types (valid MATCH_FLAGS values for
+ * MC_CMD_VNIC_ENCAP_RULE_ADD) sorted in decreasing priority order
+ */
+#define       MC_CMD_GET_PARSER_DISP_VNIC_ENCAP_MATCHES_OUT_SUPPORTED_MATCHES_OFST 8
+#define       MC_CMD_GET_PARSER_DISP_VNIC_ENCAP_MATCHES_OUT_SUPPORTED_MATCHES_LEN 4
+#define       MC_CMD_GET_PARSER_DISP_VNIC_ENCAP_MATCHES_OUT_SUPPORTED_MATCHES_MINNUM 0
+#define       MC_CMD_GET_PARSER_DISP_VNIC_ENCAP_MATCHES_OUT_SUPPORTED_MATCHES_MAXNUM 61
+#define       MC_CMD_GET_PARSER_DISP_VNIC_ENCAP_MATCHES_OUT_SUPPORTED_MATCHES_MAXNUM_MCDI2 253
+
 
 /***********************************/
 /* MC_CMD_PARSER_DISP_RW
@@ -8809,6 +10715,7 @@
  * permitted.
  */
 #define MC_CMD_PARSER_DISP_RW 0xe5
+#undef MC_CMD_0xe5_PRIVILEGE_CTG
 
 #define MC_CMD_0xe5_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
@@ -8898,6 +10805,7 @@
  * Get number of PFs on the device.
  */
 #define MC_CMD_GET_PF_COUNT 0xb6
+#undef MC_CMD_0xb6_PRIVILEGE_CTG
 
 #define MC_CMD_0xb6_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -8932,6 +10840,7 @@
  * Get port assignment for current PCI function.
  */
 #define MC_CMD_GET_PORT_ASSIGNMENT 0xb8
+#undef MC_CMD_0xb8_PRIVILEGE_CTG
 
 #define MC_CMD_0xb8_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -8950,6 +10859,7 @@
  * Set port assignment for current PCI function.
  */
 #define MC_CMD_SET_PORT_ASSIGNMENT 0xb9
+#undef MC_CMD_0xb9_PRIVILEGE_CTG
 
 #define MC_CMD_0xb9_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
@@ -8968,6 +10878,7 @@
  * Allocate VIs for current PCI function.
  */
 #define MC_CMD_ALLOC_VIS 0x8b
+#undef MC_CMD_0x8b_PRIVILEGE_CTG
 
 #define MC_CMD_0x8b_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -9014,6 +10925,7 @@
  * but not freed.
  */
 #define MC_CMD_FREE_VIS 0x8c
+#undef MC_CMD_0x8c_PRIVILEGE_CTG
 
 #define MC_CMD_0x8c_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -9029,6 +10941,7 @@
  * Get SRIOV config for this PF.
  */
 #define MC_CMD_GET_SRIOV_CFG 0xba
+#undef MC_CMD_0xba_PRIVILEGE_CTG
 
 #define MC_CMD_0xba_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -9045,6 +10958,7 @@
 #define       MC_CMD_GET_SRIOV_CFG_OUT_VF_MAX_LEN 4
 #define       MC_CMD_GET_SRIOV_CFG_OUT_FLAGS_OFST 8
 #define       MC_CMD_GET_SRIOV_CFG_OUT_FLAGS_LEN 4
+#define        MC_CMD_GET_SRIOV_CFG_OUT_VF_ENABLED_OFST 8
 #define        MC_CMD_GET_SRIOV_CFG_OUT_VF_ENABLED_LBN 0
 #define        MC_CMD_GET_SRIOV_CFG_OUT_VF_ENABLED_WIDTH 1
 /* RID offset of first VF from PF. */
@@ -9060,6 +10974,7 @@
  * Set SRIOV config for this PF.
  */
 #define MC_CMD_SET_SRIOV_CFG 0xbb
+#undef MC_CMD_0xbb_PRIVILEGE_CTG
 
 #define MC_CMD_0xbb_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
@@ -9073,6 +10988,7 @@
 #define       MC_CMD_SET_SRIOV_CFG_IN_VF_MAX_LEN 4
 #define       MC_CMD_SET_SRIOV_CFG_IN_FLAGS_OFST 8
 #define       MC_CMD_SET_SRIOV_CFG_IN_FLAGS_LEN 4
+#define        MC_CMD_SET_SRIOV_CFG_IN_VF_ENABLED_OFST 8
 #define        MC_CMD_SET_SRIOV_CFG_IN_VF_ENABLED_LBN 0
 #define        MC_CMD_SET_SRIOV_CFG_IN_VF_ENABLED_WIDTH 1
 /* RID offset of first VF from PF, or 0 for no change, or
@@ -9096,6 +11012,7 @@
  * function.
  */
 #define MC_CMD_GET_VI_ALLOC_INFO 0x8d
+#undef MC_CMD_0x8d_PRIVILEGE_CTG
 
 #define MC_CMD_0x8d_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -9122,6 +11039,7 @@
  * For CmdClient use. Dump pertinent information on a specific absolute VI.
  */
 #define MC_CMD_DUMP_VI_STATE 0x8e
+#undef MC_CMD_0x8e_PRIVILEGE_CTG
 
 #define MC_CMD_0x8e_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -9164,10 +11082,13 @@
 /* Combined metadata field. */
 #define       MC_CMD_DUMP_VI_STATE_OUT_VI_EV_META_OFST 28
 #define       MC_CMD_DUMP_VI_STATE_OUT_VI_EV_META_LEN 4
+#define        MC_CMD_DUMP_VI_STATE_OUT_VI_EV_META_BUFS_BASE_OFST 28
 #define        MC_CMD_DUMP_VI_STATE_OUT_VI_EV_META_BUFS_BASE_LBN 0
 #define        MC_CMD_DUMP_VI_STATE_OUT_VI_EV_META_BUFS_BASE_WIDTH 16
+#define        MC_CMD_DUMP_VI_STATE_OUT_VI_EV_META_BUFS_NPAGES_OFST 28
 #define        MC_CMD_DUMP_VI_STATE_OUT_VI_EV_META_BUFS_NPAGES_LBN 16
 #define        MC_CMD_DUMP_VI_STATE_OUT_VI_EV_META_BUFS_NPAGES_WIDTH 8
+#define        MC_CMD_DUMP_VI_STATE_OUT_VI_EV_META_WKUP_REF_OFST 28
 #define        MC_CMD_DUMP_VI_STATE_OUT_VI_EV_META_WKUP_REF_LBN 24
 #define        MC_CMD_DUMP_VI_STATE_OUT_VI_EV_META_WKUP_REF_WIDTH 8
 /* TXDPCPU raw table data for queue. */
@@ -9190,14 +11111,19 @@
 #define       MC_CMD_DUMP_VI_STATE_OUT_VI_TX_META_LEN 8
 #define       MC_CMD_DUMP_VI_STATE_OUT_VI_TX_META_LO_OFST 56
 #define       MC_CMD_DUMP_VI_STATE_OUT_VI_TX_META_HI_OFST 60
+#define        MC_CMD_DUMP_VI_STATE_OUT_VI_TX_META_BUFS_BASE_OFST 56
 #define        MC_CMD_DUMP_VI_STATE_OUT_VI_TX_META_BUFS_BASE_LBN 0
 #define        MC_CMD_DUMP_VI_STATE_OUT_VI_TX_META_BUFS_BASE_WIDTH 16
+#define        MC_CMD_DUMP_VI_STATE_OUT_VI_TX_META_BUFS_NPAGES_OFST 56
 #define        MC_CMD_DUMP_VI_STATE_OUT_VI_TX_META_BUFS_NPAGES_LBN 16
 #define        MC_CMD_DUMP_VI_STATE_OUT_VI_TX_META_BUFS_NPAGES_WIDTH 8
+#define        MC_CMD_DUMP_VI_STATE_OUT_VI_TX_META_QSTATE_OFST 56
 #define        MC_CMD_DUMP_VI_STATE_OUT_VI_TX_META_QSTATE_LBN 24
 #define        MC_CMD_DUMP_VI_STATE_OUT_VI_TX_META_QSTATE_WIDTH 8
+#define        MC_CMD_DUMP_VI_STATE_OUT_VI_TX_META_WAITCOUNT_OFST 56
 #define        MC_CMD_DUMP_VI_STATE_OUT_VI_TX_META_WAITCOUNT_LBN 32
 #define        MC_CMD_DUMP_VI_STATE_OUT_VI_TX_META_WAITCOUNT_WIDTH 8
+#define        MC_CMD_DUMP_VI_STATE_OUT_VI_PADDING_OFST 56
 #define        MC_CMD_DUMP_VI_STATE_OUT_VI_PADDING_LBN 40
 #define        MC_CMD_DUMP_VI_STATE_OUT_VI_PADDING_WIDTH 24
 /* RXDPCPU raw table data for queue. */
@@ -9220,12 +11146,16 @@
 #define       MC_CMD_DUMP_VI_STATE_OUT_VI_RX_META_LEN 8
 #define       MC_CMD_DUMP_VI_STATE_OUT_VI_RX_META_LO_OFST 88
 #define       MC_CMD_DUMP_VI_STATE_OUT_VI_RX_META_HI_OFST 92
+#define        MC_CMD_DUMP_VI_STATE_OUT_VI_RX_META_BUFS_BASE_OFST 88
 #define        MC_CMD_DUMP_VI_STATE_OUT_VI_RX_META_BUFS_BASE_LBN 0
 #define        MC_CMD_DUMP_VI_STATE_OUT_VI_RX_META_BUFS_BASE_WIDTH 16
+#define        MC_CMD_DUMP_VI_STATE_OUT_VI_RX_META_BUFS_NPAGES_OFST 88
 #define        MC_CMD_DUMP_VI_STATE_OUT_VI_RX_META_BUFS_NPAGES_LBN 16
 #define        MC_CMD_DUMP_VI_STATE_OUT_VI_RX_META_BUFS_NPAGES_WIDTH 8
+#define        MC_CMD_DUMP_VI_STATE_OUT_VI_RX_META_QSTATE_OFST 88
 #define        MC_CMD_DUMP_VI_STATE_OUT_VI_RX_META_QSTATE_LBN 24
 #define        MC_CMD_DUMP_VI_STATE_OUT_VI_RX_META_QSTATE_WIDTH 8
+#define        MC_CMD_DUMP_VI_STATE_OUT_VI_RX_META_WAITCOUNT_OFST 88
 #define        MC_CMD_DUMP_VI_STATE_OUT_VI_RX_META_WAITCOUNT_LBN 32
 #define        MC_CMD_DUMP_VI_STATE_OUT_VI_RX_META_WAITCOUNT_WIDTH 8
 
@@ -9235,6 +11165,7 @@
  * Allocate a push I/O buffer for later use with a tx queue.
  */
 #define MC_CMD_ALLOC_PIOBUF 0x8f
+#undef MC_CMD_0x8f_PRIVILEGE_CTG
 
 #define MC_CMD_0x8f_PRIVILEGE_CTG SRIOV_CTG_ONLOAD
 
@@ -9253,6 +11184,7 @@
  * Free a push I/O buffer.
  */
 #define MC_CMD_FREE_PIOBUF 0x90
+#undef MC_CMD_0x90_PRIVILEGE_CTG
 
 #define MC_CMD_0x90_PRIVILEGE_CTG SRIOV_CTG_ONLOAD
 
@@ -9271,6 +11203,7 @@
  * Get TLP steering and ordering information for a VI.
  */
 #define MC_CMD_GET_VI_TLP_PROCESSING 0xb0
+#undef MC_CMD_0xb0_PRIVILEGE_CTG
 
 #define MC_CMD_0xb0_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -9309,6 +11242,7 @@
  * Set TLP steering and ordering information for a VI.
  */
 #define MC_CMD_SET_VI_TLP_PROCESSING 0xb1
+#undef MC_CMD_0xb1_PRIVILEGE_CTG
 
 #define MC_CMD_0xb1_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -9347,6 +11281,7 @@
  * Get global PCIe steering and transaction processing configuration.
  */
 #define MC_CMD_GET_TLP_PROCESSING_GLOBALS 0xbc
+#undef MC_CMD_0xbc_PRIVILEGE_CTG
 
 #define MC_CMD_0xbc_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
@@ -9372,38 +11307,55 @@
 /* Amalgamated TLP info word. */
 #define       MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_WORD_OFST 4
 #define       MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_WORD_LEN 4
+#define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_MISC_WTAG_EN_OFST 4
 #define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_MISC_WTAG_EN_LBN 0
 #define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_MISC_WTAG_EN_WIDTH 1
+#define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_MISC_SPARE_OFST 4
 #define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_MISC_SPARE_LBN 1
 #define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_MISC_SPARE_WIDTH 31
+#define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_IDO_DL_EN_OFST 4
 #define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_IDO_DL_EN_LBN 0
 #define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_IDO_DL_EN_WIDTH 1
+#define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_IDO_TX_EN_OFST 4
 #define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_IDO_TX_EN_LBN 1
 #define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_IDO_TX_EN_WIDTH 1
+#define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_IDO_EV_EN_OFST 4
 #define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_IDO_EV_EN_LBN 2
 #define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_IDO_EV_EN_WIDTH 1
+#define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_IDO_RX_EN_OFST 4
 #define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_IDO_RX_EN_LBN 3
 #define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_IDO_RX_EN_WIDTH 1
+#define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_IDO_SPARE_OFST 4
 #define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_IDO_SPARE_LBN 4
 #define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_IDO_SPARE_WIDTH 28
+#define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_RO_RXDMA_EN_OFST 4
 #define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_RO_RXDMA_EN_LBN 0
 #define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_RO_RXDMA_EN_WIDTH 1
+#define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_RO_TXDMA_EN_OFST 4
 #define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_RO_TXDMA_EN_LBN 1
 #define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_RO_TXDMA_EN_WIDTH 1
+#define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_RO_DL_EN_OFST 4
 #define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_RO_DL_EN_LBN 2
 #define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_RO_DL_EN_WIDTH 1
+#define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_RO_SPARE_OFST 4
 #define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_RO_SPARE_LBN 3
 #define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_RO_SPARE_WIDTH 29
+#define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_TPH_TYPE_MSIX_OFST 4
 #define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_TPH_TYPE_MSIX_LBN 0
 #define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_TPH_TYPE_MSIX_WIDTH 2
+#define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_TPH_TYPE_DL_OFST 4
 #define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_TPH_TYPE_DL_LBN 2
 #define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_TPH_TYPE_DL_WIDTH 2
+#define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_TPH_TYPE_TX_OFST 4
 #define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_TPH_TYPE_TX_LBN 4
 #define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_TPH_TYPE_TX_WIDTH 2
+#define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_TPH_TYPE_EV_OFST 4
 #define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_TPH_TYPE_EV_LBN 6
 #define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_TPH_TYPE_EV_WIDTH 2
+#define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_TPH_TYPE_RX_OFST 4
 #define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_TPH_TYPE_RX_LBN 8
 #define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_TPH_TYPE_RX_WIDTH 2
+#define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_TLP_TYPE_SPARE_OFST 4
 #define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_TLP_TYPE_SPARE_LBN 9
 #define        MC_CMD_GET_TLP_PROCESSING_GLOBALS_OUT_TLP_INFO_TLP_TYPE_SPARE_WIDTH 23
 
@@ -9413,6 +11365,7 @@
  * Set global PCIe steering and transaction processing configuration.
  */
 #define MC_CMD_SET_TLP_PROCESSING_GLOBALS 0xbd
+#undef MC_CMD_0xbd_PRIVILEGE_CTG
 
 #define MC_CMD_0xbd_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
@@ -9425,32 +11378,46 @@
 /* Amalgamated TLP info word. */
 #define       MC_CMD_SET_TLP_PROCESSING_GLOBALS_IN_TLP_INFO_WORD_OFST 4
 #define       MC_CMD_SET_TLP_PROCESSING_GLOBALS_IN_TLP_INFO_WORD_LEN 4
+#define        MC_CMD_SET_TLP_PROCESSING_GLOBALS_IN_TLP_INFO_MISC_WTAG_EN_OFST 4
 #define        MC_CMD_SET_TLP_PROCESSING_GLOBALS_IN_TLP_INFO_MISC_WTAG_EN_LBN 0
 #define        MC_CMD_SET_TLP_PROCESSING_GLOBALS_IN_TLP_INFO_MISC_WTAG_EN_WIDTH 1
+#define        MC_CMD_SET_TLP_PROCESSING_GLOBALS_IN_TLP_INFO_IDO_DL_EN_OFST 4
 #define        MC_CMD_SET_TLP_PROCESSING_GLOBALS_IN_TLP_INFO_IDO_DL_EN_LBN 0
 #define        MC_CMD_SET_TLP_PROCESSING_GLOBALS_IN_TLP_INFO_IDO_DL_EN_WIDTH 1
+#define        MC_CMD_SET_TLP_PROCESSING_GLOBALS_IN_TLP_INFO_IDO_TX_EN_OFST 4
 #define        MC_CMD_SET_TLP_PROCESSING_GLOBALS_IN_TLP_INFO_IDO_TX_EN_LBN 1
 #define        MC_CMD_SET_TLP_PROCESSING_GLOBALS_IN_TLP_INFO_IDO_TX_EN_WIDTH 1
+#define        MC_CMD_SET_TLP_PROCESSING_GLOBALS_IN_TLP_INFO_IDO_EV_EN_OFST 4
 #define        MC_CMD_SET_TLP_PROCESSING_GLOBALS_IN_TLP_INFO_IDO_EV_EN_LBN 2
 #define        MC_CMD_SET_TLP_PROCESSING_GLOBALS_IN_TLP_INFO_IDO_EV_EN_WIDTH 1
+#define        MC_CMD_SET_TLP_PROCESSING_GLOBALS_IN_TLP_INFO_IDO_RX_EN_OFST 4
 #define        MC_CMD_SET_TLP_PROCESSING_GLOBALS_IN_TLP_INFO_IDO_RX_EN_LBN 3
 #define        MC_CMD_SET_TLP_PROCESSING_GLOBALS_IN_TLP_INFO_IDO_RX_EN_WIDTH 1
+#define        MC_CMD_SET_TLP_PROCESSING_GLOBALS_IN_TLP_INFO_RO_RXDMA_EN_OFST 4
 #define        MC_CMD_SET_TLP_PROCESSING_GLOBALS_IN_TLP_INFO_RO_RXDMA_EN_LBN 0
 #define        MC_CMD_SET_TLP_PROCESSING_GLOBALS_IN_TLP_INFO_RO_RXDMA_EN_WIDTH 1
+#define        MC_CMD_SET_TLP_PROCESSING_GLOBALS_IN_TLP_INFO_RO_TXDMA_EN_OFST 4
 #define        MC_CMD_SET_TLP_PROCESSING_GLOBALS_IN_TLP_INFO_RO_TXDMA_EN_LBN 1
 #define        MC_CMD_SET_TLP_PROCESSING_GLOBALS_IN_TLP_INFO_RO_TXDMA_EN_WIDTH 1
+#define        MC_CMD_SET_TLP_PROCESSING_GLOBALS_IN_TLP_INFO_RO_DL_EN_OFST 4
 #define        MC_CMD_SET_TLP_PROCESSING_GLOBALS_IN_TLP_INFO_RO_DL_EN_LBN 2
 #define        MC_CMD_SET_TLP_PROCESSING_GLOBALS_IN_TLP_INFO_RO_DL_EN_WIDTH 1
+#define        MC_CMD_SET_TLP_PROCESSING_GLOBALS_IN_TLP_INFO_TPH_TYPE_MSIX_OFST 4
 #define        MC_CMD_SET_TLP_PROCESSING_GLOBALS_IN_TLP_INFO_TPH_TYPE_MSIX_LBN 0
 #define        MC_CMD_SET_TLP_PROCESSING_GLOBALS_IN_TLP_INFO_TPH_TYPE_MSIX_WIDTH 2
+#define        MC_CMD_SET_TLP_PROCESSING_GLOBALS_IN_TLP_INFO_TPH_TYPE_DL_OFST 4
 #define        MC_CMD_SET_TLP_PROCESSING_GLOBALS_IN_TLP_INFO_TPH_TYPE_DL_LBN 2
 #define        MC_CMD_SET_TLP_PROCESSING_GLOBALS_IN_TLP_INFO_TPH_TYPE_DL_WIDTH 2
+#define        MC_CMD_SET_TLP_PROCESSING_GLOBALS_IN_TLP_INFO_TPH_TYPE_TX_OFST 4
 #define        MC_CMD_SET_TLP_PROCESSING_GLOBALS_IN_TLP_INFO_TPH_TYPE_TX_LBN 4
 #define        MC_CMD_SET_TLP_PROCESSING_GLOBALS_IN_TLP_INFO_TPH_TYPE_TX_WIDTH 2
+#define        MC_CMD_SET_TLP_PROCESSING_GLOBALS_IN_TLP_INFO_TPH_TYPE_EV_OFST 4
 #define        MC_CMD_SET_TLP_PROCESSING_GLOBALS_IN_TLP_INFO_TPH_TYPE_EV_LBN 6
 #define        MC_CMD_SET_TLP_PROCESSING_GLOBALS_IN_TLP_INFO_TPH_TYPE_EV_WIDTH 2
+#define        MC_CMD_SET_TLP_PROCESSING_GLOBALS_IN_TLP_INFO_TPH_TYPE_RX_OFST 4
 #define        MC_CMD_SET_TLP_PROCESSING_GLOBALS_IN_TLP_INFO_TPH_TYPE_RX_LBN 8
 #define        MC_CMD_SET_TLP_PROCESSING_GLOBALS_IN_TLP_INFO_TPH_TYPE_RX_WIDTH 2
+#define        MC_CMD_SET_TLP_PROCESSING_GLOBALS_IN_TLP_INFO_SPARE_OFST 4
 #define        MC_CMD_SET_TLP_PROCESSING_GLOBALS_IN_TLP_INFO_SPARE_LBN 10
 #define        MC_CMD_SET_TLP_PROCESSING_GLOBALS_IN_TLP_INFO_SPARE_WIDTH 22
 
@@ -9463,6 +11430,7 @@
  * Download a new set of images to the satellite CPUs from the host.
  */
 #define MC_CMD_SATELLITE_DOWNLOAD 0x91
+#undef MC_CMD_0x91_PRIVILEGE_CTG
 
 #define MC_CMD_0x91_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
@@ -9486,7 +11454,9 @@
  */
 #define    MC_CMD_SATELLITE_DOWNLOAD_IN_LENMIN 20
 #define    MC_CMD_SATELLITE_DOWNLOAD_IN_LENMAX 252
+#define    MC_CMD_SATELLITE_DOWNLOAD_IN_LENMAX_MCDI2 1020
 #define    MC_CMD_SATELLITE_DOWNLOAD_IN_LEN(num) (16+4*(num))
+#define    MC_CMD_SATELLITE_DOWNLOAD_IN_CHUNK_DATA_NUM(len) (((len)-16)/4)
 /* Download phase. (Note: the IDLE phase is used internally and is never valid
  * in a command from the host.)
  */
@@ -9551,6 +11521,7 @@
 #define       MC_CMD_SATELLITE_DOWNLOAD_IN_CHUNK_DATA_LEN 4
 #define       MC_CMD_SATELLITE_DOWNLOAD_IN_CHUNK_DATA_MINNUM 1
 #define       MC_CMD_SATELLITE_DOWNLOAD_IN_CHUNK_DATA_MAXNUM 59
+#define       MC_CMD_SATELLITE_DOWNLOAD_IN_CHUNK_DATA_MAXNUM_MCDI2 251
 
 /* MC_CMD_SATELLITE_DOWNLOAD_OUT msgresponse */
 #define    MC_CMD_SATELLITE_DOWNLOAD_OUT_LEN 8
@@ -9586,6 +11557,7 @@
  * reference inherent device capabilities as opposed to current NVRAM config.
  */
 #define MC_CMD_GET_CAPABILITIES 0xbe
+#undef MC_CMD_0xbe_PRIVILEGE_CTG
 
 #define MC_CMD_0xbe_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -9597,62 +11569,91 @@
 /* First word of flags. */
 #define       MC_CMD_GET_CAPABILITIES_OUT_FLAGS1_OFST 0
 #define       MC_CMD_GET_CAPABILITIES_OUT_FLAGS1_LEN 4
+#define        MC_CMD_GET_CAPABILITIES_OUT_VPORT_RECONFIGURE_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_OUT_VPORT_RECONFIGURE_LBN 3
 #define        MC_CMD_GET_CAPABILITIES_OUT_VPORT_RECONFIGURE_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_OUT_TX_STRIPING_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_OUT_TX_STRIPING_LBN 4
 #define        MC_CMD_GET_CAPABILITIES_OUT_TX_STRIPING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_OUT_VADAPTOR_QUERY_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_OUT_VADAPTOR_QUERY_LBN 5
 #define        MC_CMD_GET_CAPABILITIES_OUT_VADAPTOR_QUERY_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_OUT_EVB_PORT_VLAN_RESTRICT_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_OUT_EVB_PORT_VLAN_RESTRICT_LBN 6
 #define        MC_CMD_GET_CAPABILITIES_OUT_EVB_PORT_VLAN_RESTRICT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_OUT_DRV_ATTACH_PREBOOT_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_OUT_DRV_ATTACH_PREBOOT_LBN 7
 #define        MC_CMD_GET_CAPABILITIES_OUT_DRV_ATTACH_PREBOOT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_OUT_RX_FORCE_EVENT_MERGING_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_OUT_RX_FORCE_EVENT_MERGING_LBN 8
 #define        MC_CMD_GET_CAPABILITIES_OUT_RX_FORCE_EVENT_MERGING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_OUT_SET_MAC_ENHANCED_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_OUT_SET_MAC_ENHANCED_LBN 9
 #define        MC_CMD_GET_CAPABILITIES_OUT_SET_MAC_ENHANCED_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_OUT_UNKNOWN_UCAST_DST_FILTER_ALWAYS_MULTI_RECIPIENT_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_OUT_UNKNOWN_UCAST_DST_FILTER_ALWAYS_MULTI_RECIPIENT_LBN 10
 #define        MC_CMD_GET_CAPABILITIES_OUT_UNKNOWN_UCAST_DST_FILTER_ALWAYS_MULTI_RECIPIENT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_OUT_VADAPTOR_PERMIT_SET_MAC_WHEN_FILTERS_INSTALLED_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_OUT_VADAPTOR_PERMIT_SET_MAC_WHEN_FILTERS_INSTALLED_LBN 11
 #define        MC_CMD_GET_CAPABILITIES_OUT_VADAPTOR_PERMIT_SET_MAC_WHEN_FILTERS_INSTALLED_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_OUT_TX_MAC_SECURITY_FILTERING_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_OUT_TX_MAC_SECURITY_FILTERING_LBN 12
 #define        MC_CMD_GET_CAPABILITIES_OUT_TX_MAC_SECURITY_FILTERING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_OUT_ADDITIONAL_RSS_MODES_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_OUT_ADDITIONAL_RSS_MODES_LBN 13
 #define        MC_CMD_GET_CAPABILITIES_OUT_ADDITIONAL_RSS_MODES_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_OUT_QBB_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_OUT_QBB_LBN 14
 #define        MC_CMD_GET_CAPABILITIES_OUT_QBB_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_OUT_RX_PACKED_STREAM_VAR_BUFFERS_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_OUT_RX_PACKED_STREAM_VAR_BUFFERS_LBN 15
 #define        MC_CMD_GET_CAPABILITIES_OUT_RX_PACKED_STREAM_VAR_BUFFERS_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_OUT_RX_RSS_LIMITED_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_OUT_RX_RSS_LIMITED_LBN 16
 #define        MC_CMD_GET_CAPABILITIES_OUT_RX_RSS_LIMITED_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_OUT_RX_PACKED_STREAM_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_OUT_RX_PACKED_STREAM_LBN 17
 #define        MC_CMD_GET_CAPABILITIES_OUT_RX_PACKED_STREAM_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_OUT_RX_INCLUDE_FCS_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_OUT_RX_INCLUDE_FCS_LBN 18
 #define        MC_CMD_GET_CAPABILITIES_OUT_RX_INCLUDE_FCS_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_OUT_TX_VLAN_INSERTION_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_OUT_TX_VLAN_INSERTION_LBN 19
 #define        MC_CMD_GET_CAPABILITIES_OUT_TX_VLAN_INSERTION_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_OUT_RX_VLAN_STRIPPING_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_OUT_RX_VLAN_STRIPPING_LBN 20
 #define        MC_CMD_GET_CAPABILITIES_OUT_RX_VLAN_STRIPPING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_OUT_TX_TSO_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_OUT_TX_TSO_LBN 21
 #define        MC_CMD_GET_CAPABILITIES_OUT_TX_TSO_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_OUT_RX_PREFIX_LEN_0_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_OUT_RX_PREFIX_LEN_0_LBN 22
 #define        MC_CMD_GET_CAPABILITIES_OUT_RX_PREFIX_LEN_0_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_OUT_RX_PREFIX_LEN_14_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_OUT_RX_PREFIX_LEN_14_LBN 23
 #define        MC_CMD_GET_CAPABILITIES_OUT_RX_PREFIX_LEN_14_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_OUT_RX_TIMESTAMP_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_OUT_RX_TIMESTAMP_LBN 24
 #define        MC_CMD_GET_CAPABILITIES_OUT_RX_TIMESTAMP_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_OUT_RX_BATCHING_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_OUT_RX_BATCHING_LBN 25
 #define        MC_CMD_GET_CAPABILITIES_OUT_RX_BATCHING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_OUT_MCAST_FILTER_CHAINING_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_OUT_MCAST_FILTER_CHAINING_LBN 26
 #define        MC_CMD_GET_CAPABILITIES_OUT_MCAST_FILTER_CHAINING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_OUT_PM_AND_RXDP_COUNTERS_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_OUT_PM_AND_RXDP_COUNTERS_LBN 27
 #define        MC_CMD_GET_CAPABILITIES_OUT_PM_AND_RXDP_COUNTERS_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_OUT_RX_DISABLE_SCATTER_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_OUT_RX_DISABLE_SCATTER_LBN 28
 #define        MC_CMD_GET_CAPABILITIES_OUT_RX_DISABLE_SCATTER_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_OUT_TX_MCAST_UDP_LOOPBACK_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_OUT_TX_MCAST_UDP_LOOPBACK_LBN 29
 #define        MC_CMD_GET_CAPABILITIES_OUT_TX_MCAST_UDP_LOOPBACK_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_OUT_EVB_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_OUT_EVB_LBN 30
 #define        MC_CMD_GET_CAPABILITIES_OUT_EVB_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_OUT_VXLAN_NVGRE_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_OUT_VXLAN_NVGRE_LBN 31
 #define        MC_CMD_GET_CAPABILITIES_OUT_VXLAN_NVGRE_WIDTH 1
 /* RxDPCPU firmware id. */
@@ -9713,8 +11714,10 @@
 #define          MC_CMD_GET_CAPABILITIES_OUT_TXDP_TEST_FW_CSR 0x103
 #define       MC_CMD_GET_CAPABILITIES_OUT_RXPD_FW_VERSION_OFST 8
 #define       MC_CMD_GET_CAPABILITIES_OUT_RXPD_FW_VERSION_LEN 2
+#define        MC_CMD_GET_CAPABILITIES_OUT_RXPD_FW_VERSION_REV_OFST 8
 #define        MC_CMD_GET_CAPABILITIES_OUT_RXPD_FW_VERSION_REV_LBN 0
 #define        MC_CMD_GET_CAPABILITIES_OUT_RXPD_FW_VERSION_REV_WIDTH 12
+#define        MC_CMD_GET_CAPABILITIES_OUT_RXPD_FW_VERSION_TYPE_OFST 8
 #define        MC_CMD_GET_CAPABILITIES_OUT_RXPD_FW_VERSION_TYPE_LBN 12
 #define        MC_CMD_GET_CAPABILITIES_OUT_RXPD_FW_VERSION_TYPE_WIDTH 4
 /* enum: reserved value - do not use (may indicate alternative interpretation
@@ -9725,6 +11728,9 @@
  * development only)
  */
 #define          MC_CMD_GET_CAPABILITIES_OUT_RXPD_FW_TYPE_FIRST_PKT 0x1
+/* enum: RX PD firmware for telemetry prototyping (Medford2 development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_OUT_RXPD_FW_TYPE_TESTFW_TELEMETRY 0x1
 /* enum: RX PD firmware with approximately Siena-compatible behaviour
  * (Huntington development only)
  */
@@ -9759,8 +11765,10 @@
 #define          MC_CMD_GET_CAPABILITIES_OUT_RXPD_FW_TYPE_TESTFW_ENCAP_PARSING_ONLY 0xf
 #define       MC_CMD_GET_CAPABILITIES_OUT_TXPD_FW_VERSION_OFST 10
 #define       MC_CMD_GET_CAPABILITIES_OUT_TXPD_FW_VERSION_LEN 2
+#define        MC_CMD_GET_CAPABILITIES_OUT_TXPD_FW_VERSION_REV_OFST 10
 #define        MC_CMD_GET_CAPABILITIES_OUT_TXPD_FW_VERSION_REV_LBN 0
 #define        MC_CMD_GET_CAPABILITIES_OUT_TXPD_FW_VERSION_REV_WIDTH 12
+#define        MC_CMD_GET_CAPABILITIES_OUT_TXPD_FW_VERSION_TYPE_OFST 10
 #define        MC_CMD_GET_CAPABILITIES_OUT_TXPD_FW_VERSION_TYPE_LBN 12
 #define        MC_CMD_GET_CAPABILITIES_OUT_TXPD_FW_VERSION_TYPE_WIDTH 4
 /* enum: reserved value - do not use (may indicate alternative interpretation
@@ -9771,6 +11779,9 @@
  * development only)
  */
 #define          MC_CMD_GET_CAPABILITIES_OUT_TXPD_FW_TYPE_FIRST_PKT 0x1
+/* enum: TX PD firmware for telemetry prototyping (Medford2 development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_OUT_TXPD_FW_TYPE_TESTFW_TELEMETRY 0x1
 /* enum: TX PD firmware with approximately Siena-compatible behaviour
  * (Huntington development only)
  */
@@ -9811,62 +11822,91 @@
 /* First word of flags. */
 #define       MC_CMD_GET_CAPABILITIES_V2_OUT_FLAGS1_OFST 0
 #define       MC_CMD_GET_CAPABILITIES_V2_OUT_FLAGS1_LEN 4
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_VPORT_RECONFIGURE_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_VPORT_RECONFIGURE_LBN 3
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_VPORT_RECONFIGURE_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_TX_STRIPING_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_TX_STRIPING_LBN 4
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_TX_STRIPING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_VADAPTOR_QUERY_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_VADAPTOR_QUERY_LBN 5
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_VADAPTOR_QUERY_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_EVB_PORT_VLAN_RESTRICT_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_EVB_PORT_VLAN_RESTRICT_LBN 6
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_EVB_PORT_VLAN_RESTRICT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_DRV_ATTACH_PREBOOT_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_DRV_ATTACH_PREBOOT_LBN 7
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_DRV_ATTACH_PREBOOT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_RX_FORCE_EVENT_MERGING_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_RX_FORCE_EVENT_MERGING_LBN 8
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_RX_FORCE_EVENT_MERGING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_SET_MAC_ENHANCED_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_SET_MAC_ENHANCED_LBN 9
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_SET_MAC_ENHANCED_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_UNKNOWN_UCAST_DST_FILTER_ALWAYS_MULTI_RECIPIENT_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_UNKNOWN_UCAST_DST_FILTER_ALWAYS_MULTI_RECIPIENT_LBN 10
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_UNKNOWN_UCAST_DST_FILTER_ALWAYS_MULTI_RECIPIENT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_VADAPTOR_PERMIT_SET_MAC_WHEN_FILTERS_INSTALLED_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_VADAPTOR_PERMIT_SET_MAC_WHEN_FILTERS_INSTALLED_LBN 11
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_VADAPTOR_PERMIT_SET_MAC_WHEN_FILTERS_INSTALLED_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_TX_MAC_SECURITY_FILTERING_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_TX_MAC_SECURITY_FILTERING_LBN 12
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_TX_MAC_SECURITY_FILTERING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_ADDITIONAL_RSS_MODES_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_ADDITIONAL_RSS_MODES_LBN 13
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_ADDITIONAL_RSS_MODES_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_QBB_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_QBB_LBN 14
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_QBB_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_RX_PACKED_STREAM_VAR_BUFFERS_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_RX_PACKED_STREAM_VAR_BUFFERS_LBN 15
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_RX_PACKED_STREAM_VAR_BUFFERS_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_RX_RSS_LIMITED_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_RX_RSS_LIMITED_LBN 16
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_RX_RSS_LIMITED_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_RX_PACKED_STREAM_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_RX_PACKED_STREAM_LBN 17
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_RX_PACKED_STREAM_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_RX_INCLUDE_FCS_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_RX_INCLUDE_FCS_LBN 18
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_RX_INCLUDE_FCS_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_TX_VLAN_INSERTION_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_TX_VLAN_INSERTION_LBN 19
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_TX_VLAN_INSERTION_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_RX_VLAN_STRIPPING_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_RX_VLAN_STRIPPING_LBN 20
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_RX_VLAN_STRIPPING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_TX_TSO_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_TX_TSO_LBN 21
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_TX_TSO_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_RX_PREFIX_LEN_0_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_RX_PREFIX_LEN_0_LBN 22
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_RX_PREFIX_LEN_0_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_RX_PREFIX_LEN_14_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_RX_PREFIX_LEN_14_LBN 23
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_RX_PREFIX_LEN_14_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_RX_TIMESTAMP_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_RX_TIMESTAMP_LBN 24
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_RX_TIMESTAMP_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_RX_BATCHING_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_RX_BATCHING_LBN 25
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_RX_BATCHING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_MCAST_FILTER_CHAINING_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_MCAST_FILTER_CHAINING_LBN 26
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_MCAST_FILTER_CHAINING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_PM_AND_RXDP_COUNTERS_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_PM_AND_RXDP_COUNTERS_LBN 27
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_PM_AND_RXDP_COUNTERS_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_RX_DISABLE_SCATTER_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_RX_DISABLE_SCATTER_LBN 28
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_RX_DISABLE_SCATTER_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_TX_MCAST_UDP_LOOPBACK_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_TX_MCAST_UDP_LOOPBACK_LBN 29
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_TX_MCAST_UDP_LOOPBACK_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_EVB_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_EVB_LBN 30
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_EVB_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_VXLAN_NVGRE_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_VXLAN_NVGRE_LBN 31
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_VXLAN_NVGRE_WIDTH 1
 /* RxDPCPU firmware id. */
@@ -9927,8 +11967,10 @@
 #define          MC_CMD_GET_CAPABILITIES_V2_OUT_TXDP_TEST_FW_CSR 0x103
 #define       MC_CMD_GET_CAPABILITIES_V2_OUT_RXPD_FW_VERSION_OFST 8
 #define       MC_CMD_GET_CAPABILITIES_V2_OUT_RXPD_FW_VERSION_LEN 2
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_RXPD_FW_VERSION_REV_OFST 8
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_RXPD_FW_VERSION_REV_LBN 0
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_RXPD_FW_VERSION_REV_WIDTH 12
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_RXPD_FW_VERSION_TYPE_OFST 8
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_RXPD_FW_VERSION_TYPE_LBN 12
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_RXPD_FW_VERSION_TYPE_WIDTH 4
 /* enum: reserved value - do not use (may indicate alternative interpretation
@@ -9939,6 +11981,9 @@
  * development only)
  */
 #define          MC_CMD_GET_CAPABILITIES_V2_OUT_RXPD_FW_TYPE_FIRST_PKT 0x1
+/* enum: RX PD firmware for telemetry prototyping (Medford2 development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V2_OUT_RXPD_FW_TYPE_TESTFW_TELEMETRY 0x1
 /* enum: RX PD firmware with approximately Siena-compatible behaviour
  * (Huntington development only)
  */
@@ -9973,8 +12018,10 @@
 #define          MC_CMD_GET_CAPABILITIES_V2_OUT_RXPD_FW_TYPE_TESTFW_ENCAP_PARSING_ONLY 0xf
 #define       MC_CMD_GET_CAPABILITIES_V2_OUT_TXPD_FW_VERSION_OFST 10
 #define       MC_CMD_GET_CAPABILITIES_V2_OUT_TXPD_FW_VERSION_LEN 2
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_TXPD_FW_VERSION_REV_OFST 10
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_TXPD_FW_VERSION_REV_LBN 0
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_TXPD_FW_VERSION_REV_WIDTH 12
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_TXPD_FW_VERSION_TYPE_OFST 10
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_TXPD_FW_VERSION_TYPE_LBN 12
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_TXPD_FW_VERSION_TYPE_WIDTH 4
 /* enum: reserved value - do not use (may indicate alternative interpretation
@@ -9985,6 +12032,9 @@
  * development only)
  */
 #define          MC_CMD_GET_CAPABILITIES_V2_OUT_TXPD_FW_TYPE_FIRST_PKT 0x1
+/* enum: TX PD firmware for telemetry prototyping (Medford2 development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V2_OUT_TXPD_FW_TYPE_TESTFW_TELEMETRY 0x1
 /* enum: TX PD firmware with approximately Siena-compatible behaviour
  * (Huntington development only)
  */
@@ -10019,58 +12069,110 @@
 /* Second word of flags. Not present on older firmware (check the length). */
 #define       MC_CMD_GET_CAPABILITIES_V2_OUT_FLAGS2_OFST 20
 #define       MC_CMD_GET_CAPABILITIES_V2_OUT_FLAGS2_LEN 4
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_TX_TSO_V2_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_TX_TSO_V2_LBN 0
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_TX_TSO_V2_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_TX_TSO_V2_ENCAP_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_TX_TSO_V2_ENCAP_LBN 1
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_TX_TSO_V2_ENCAP_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_EVQ_TIMER_CTRL_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_EVQ_TIMER_CTRL_LBN 2
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_EVQ_TIMER_CTRL_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_EVENT_CUT_THROUGH_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_EVENT_CUT_THROUGH_LBN 3
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_EVENT_CUT_THROUGH_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_RX_CUT_THROUGH_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_RX_CUT_THROUGH_LBN 4
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_RX_CUT_THROUGH_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_TX_VFIFO_ULL_MODE_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_TX_VFIFO_ULL_MODE_LBN 5
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_TX_VFIFO_ULL_MODE_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_MAC_STATS_40G_TX_SIZE_BINS_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_MAC_STATS_40G_TX_SIZE_BINS_LBN 6
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_MAC_STATS_40G_TX_SIZE_BINS_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_INIT_EVQ_TYPE_SUPPORTED_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_INIT_EVQ_TYPE_SUPPORTED_LBN 7
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_INIT_EVQ_TYPE_SUPPORTED_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_INIT_EVQ_V2_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_INIT_EVQ_V2_LBN 7
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_INIT_EVQ_V2_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_TX_MAC_TIMESTAMPING_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_TX_MAC_TIMESTAMPING_LBN 8
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_TX_MAC_TIMESTAMPING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_TX_TIMESTAMP_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_TX_TIMESTAMP_LBN 9
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_TX_TIMESTAMP_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_RX_SNIFF_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_RX_SNIFF_LBN 10
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_RX_SNIFF_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_TX_SNIFF_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_TX_SNIFF_LBN 11
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_TX_SNIFF_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_NVRAM_UPDATE_REPORT_VERIFY_RESULT_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_NVRAM_UPDATE_REPORT_VERIFY_RESULT_LBN 12
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_NVRAM_UPDATE_REPORT_VERIFY_RESULT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_MCDI_BACKGROUND_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_MCDI_BACKGROUND_LBN 13
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_MCDI_BACKGROUND_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_MCDI_DB_RETURN_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_MCDI_DB_RETURN_LBN 14
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_MCDI_DB_RETURN_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_CTPIO_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_CTPIO_LBN 15
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_CTPIO_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_TSA_SUPPORT_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_TSA_SUPPORT_LBN 16
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_TSA_SUPPORT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_TSA_BOUND_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_TSA_BOUND_LBN 17
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_TSA_BOUND_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_SF_ADAPTER_AUTHENTICATION_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_SF_ADAPTER_AUTHENTICATION_LBN 18
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_SF_ADAPTER_AUTHENTICATION_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_FILTER_ACTION_FLAG_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_FILTER_ACTION_FLAG_LBN 19
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_FILTER_ACTION_FLAG_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_FILTER_ACTION_MARK_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_FILTER_ACTION_MARK_LBN 20
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_FILTER_ACTION_MARK_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_EQUAL_STRIDE_SUPER_BUFFER_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_EQUAL_STRIDE_SUPER_BUFFER_LBN 21
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_EQUAL_STRIDE_SUPER_BUFFER_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_EQUAL_STRIDE_PACKED_STREAM_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_EQUAL_STRIDE_PACKED_STREAM_LBN 21
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_EQUAL_STRIDE_PACKED_STREAM_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_L3XUDP_SUPPORT_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_L3XUDP_SUPPORT_LBN 22
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_L3XUDP_SUPPORT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_FW_SUBVARIANT_NO_TX_CSUM_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_FW_SUBVARIANT_NO_TX_CSUM_LBN 23
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_FW_SUBVARIANT_NO_TX_CSUM_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_VI_SPREADING_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_VI_SPREADING_LBN 24
 #define        MC_CMD_GET_CAPABILITIES_V2_OUT_VI_SPREADING_WIDTH 1
-/* Number of FATSOv2 contexts per datapath supported by this NIC. Not present
- * on older firmware (check the length).
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_RXDP_HLB_IDLE_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_RXDP_HLB_IDLE_LBN 25
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_RXDP_HLB_IDLE_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_INIT_RXQ_NO_CONT_EV_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_INIT_RXQ_NO_CONT_EV_LBN 26
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_INIT_RXQ_NO_CONT_EV_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_INIT_RXQ_WITH_BUFFER_SIZE_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_INIT_RXQ_WITH_BUFFER_SIZE_LBN 27
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_INIT_RXQ_WITH_BUFFER_SIZE_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_BUNDLE_UPDATE_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_BUNDLE_UPDATE_LBN 28
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_BUNDLE_UPDATE_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_TX_TSO_V3_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_TX_TSO_V3_LBN 29
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_TX_TSO_V3_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_DYNAMIC_SENSORS_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_DYNAMIC_SENSORS_LBN 30
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_DYNAMIC_SENSORS_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_NVRAM_UPDATE_POLL_VERIFY_RESULT_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_NVRAM_UPDATE_POLL_VERIFY_RESULT_LBN 31
+#define        MC_CMD_GET_CAPABILITIES_V2_OUT_NVRAM_UPDATE_POLL_VERIFY_RESULT_WIDTH 1
+/* Number of FATSOv2 contexts per datapath supported by this NIC (when
+ * TX_TSO_V2 == 1). Not present on older firmware (check the length).
  */
 #define       MC_CMD_GET_CAPABILITIES_V2_OUT_TX_TSO_V2_N_CONTEXTS_OFST 24
 #define       MC_CMD_GET_CAPABILITIES_V2_OUT_TX_TSO_V2_N_CONTEXTS_LEN 2
@@ -10130,62 +12232,91 @@
 /* First word of flags. */
 #define       MC_CMD_GET_CAPABILITIES_V3_OUT_FLAGS1_OFST 0
 #define       MC_CMD_GET_CAPABILITIES_V3_OUT_FLAGS1_LEN 4
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_VPORT_RECONFIGURE_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_VPORT_RECONFIGURE_LBN 3
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_VPORT_RECONFIGURE_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_TX_STRIPING_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_TX_STRIPING_LBN 4
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_TX_STRIPING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_VADAPTOR_QUERY_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_VADAPTOR_QUERY_LBN 5
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_VADAPTOR_QUERY_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_EVB_PORT_VLAN_RESTRICT_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_EVB_PORT_VLAN_RESTRICT_LBN 6
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_EVB_PORT_VLAN_RESTRICT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_DRV_ATTACH_PREBOOT_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_DRV_ATTACH_PREBOOT_LBN 7
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_DRV_ATTACH_PREBOOT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_RX_FORCE_EVENT_MERGING_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_RX_FORCE_EVENT_MERGING_LBN 8
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_RX_FORCE_EVENT_MERGING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_SET_MAC_ENHANCED_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_SET_MAC_ENHANCED_LBN 9
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_SET_MAC_ENHANCED_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_UNKNOWN_UCAST_DST_FILTER_ALWAYS_MULTI_RECIPIENT_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_UNKNOWN_UCAST_DST_FILTER_ALWAYS_MULTI_RECIPIENT_LBN 10
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_UNKNOWN_UCAST_DST_FILTER_ALWAYS_MULTI_RECIPIENT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_VADAPTOR_PERMIT_SET_MAC_WHEN_FILTERS_INSTALLED_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_VADAPTOR_PERMIT_SET_MAC_WHEN_FILTERS_INSTALLED_LBN 11
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_VADAPTOR_PERMIT_SET_MAC_WHEN_FILTERS_INSTALLED_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_TX_MAC_SECURITY_FILTERING_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_TX_MAC_SECURITY_FILTERING_LBN 12
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_TX_MAC_SECURITY_FILTERING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_ADDITIONAL_RSS_MODES_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_ADDITIONAL_RSS_MODES_LBN 13
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_ADDITIONAL_RSS_MODES_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_QBB_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_QBB_LBN 14
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_QBB_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_RX_PACKED_STREAM_VAR_BUFFERS_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_RX_PACKED_STREAM_VAR_BUFFERS_LBN 15
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_RX_PACKED_STREAM_VAR_BUFFERS_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_RX_RSS_LIMITED_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_RX_RSS_LIMITED_LBN 16
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_RX_RSS_LIMITED_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_RX_PACKED_STREAM_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_RX_PACKED_STREAM_LBN 17
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_RX_PACKED_STREAM_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_RX_INCLUDE_FCS_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_RX_INCLUDE_FCS_LBN 18
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_RX_INCLUDE_FCS_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_TX_VLAN_INSERTION_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_TX_VLAN_INSERTION_LBN 19
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_TX_VLAN_INSERTION_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_RX_VLAN_STRIPPING_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_RX_VLAN_STRIPPING_LBN 20
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_RX_VLAN_STRIPPING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_TX_TSO_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_TX_TSO_LBN 21
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_TX_TSO_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_RX_PREFIX_LEN_0_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_RX_PREFIX_LEN_0_LBN 22
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_RX_PREFIX_LEN_0_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_RX_PREFIX_LEN_14_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_RX_PREFIX_LEN_14_LBN 23
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_RX_PREFIX_LEN_14_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_RX_TIMESTAMP_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_RX_TIMESTAMP_LBN 24
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_RX_TIMESTAMP_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_RX_BATCHING_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_RX_BATCHING_LBN 25
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_RX_BATCHING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_MCAST_FILTER_CHAINING_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_MCAST_FILTER_CHAINING_LBN 26
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_MCAST_FILTER_CHAINING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_PM_AND_RXDP_COUNTERS_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_PM_AND_RXDP_COUNTERS_LBN 27
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_PM_AND_RXDP_COUNTERS_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_RX_DISABLE_SCATTER_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_RX_DISABLE_SCATTER_LBN 28
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_RX_DISABLE_SCATTER_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_TX_MCAST_UDP_LOOPBACK_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_TX_MCAST_UDP_LOOPBACK_LBN 29
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_TX_MCAST_UDP_LOOPBACK_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_EVB_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_EVB_LBN 30
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_EVB_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_VXLAN_NVGRE_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_VXLAN_NVGRE_LBN 31
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_VXLAN_NVGRE_WIDTH 1
 /* RxDPCPU firmware id. */
@@ -10246,8 +12377,10 @@
 #define          MC_CMD_GET_CAPABILITIES_V3_OUT_TXDP_TEST_FW_CSR 0x103
 #define       MC_CMD_GET_CAPABILITIES_V3_OUT_RXPD_FW_VERSION_OFST 8
 #define       MC_CMD_GET_CAPABILITIES_V3_OUT_RXPD_FW_VERSION_LEN 2
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_RXPD_FW_VERSION_REV_OFST 8
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_RXPD_FW_VERSION_REV_LBN 0
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_RXPD_FW_VERSION_REV_WIDTH 12
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_RXPD_FW_VERSION_TYPE_OFST 8
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_RXPD_FW_VERSION_TYPE_LBN 12
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_RXPD_FW_VERSION_TYPE_WIDTH 4
 /* enum: reserved value - do not use (may indicate alternative interpretation
@@ -10258,6 +12391,9 @@
  * development only)
  */
 #define          MC_CMD_GET_CAPABILITIES_V3_OUT_RXPD_FW_TYPE_FIRST_PKT 0x1
+/* enum: RX PD firmware for telemetry prototyping (Medford2 development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V3_OUT_RXPD_FW_TYPE_TESTFW_TELEMETRY 0x1
 /* enum: RX PD firmware with approximately Siena-compatible behaviour
  * (Huntington development only)
  */
@@ -10292,8 +12428,10 @@
 #define          MC_CMD_GET_CAPABILITIES_V3_OUT_RXPD_FW_TYPE_TESTFW_ENCAP_PARSING_ONLY 0xf
 #define       MC_CMD_GET_CAPABILITIES_V3_OUT_TXPD_FW_VERSION_OFST 10
 #define       MC_CMD_GET_CAPABILITIES_V3_OUT_TXPD_FW_VERSION_LEN 2
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_TXPD_FW_VERSION_REV_OFST 10
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_TXPD_FW_VERSION_REV_LBN 0
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_TXPD_FW_VERSION_REV_WIDTH 12
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_TXPD_FW_VERSION_TYPE_OFST 10
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_TXPD_FW_VERSION_TYPE_LBN 12
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_TXPD_FW_VERSION_TYPE_WIDTH 4
 /* enum: reserved value - do not use (may indicate alternative interpretation
@@ -10304,6 +12442,9 @@
  * development only)
  */
 #define          MC_CMD_GET_CAPABILITIES_V3_OUT_TXPD_FW_TYPE_FIRST_PKT 0x1
+/* enum: TX PD firmware for telemetry prototyping (Medford2 development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V3_OUT_TXPD_FW_TYPE_TESTFW_TELEMETRY 0x1
 /* enum: TX PD firmware with approximately Siena-compatible behaviour
  * (Huntington development only)
  */
@@ -10338,58 +12479,110 @@
 /* Second word of flags. Not present on older firmware (check the length). */
 #define       MC_CMD_GET_CAPABILITIES_V3_OUT_FLAGS2_OFST 20
 #define       MC_CMD_GET_CAPABILITIES_V3_OUT_FLAGS2_LEN 4
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_TX_TSO_V2_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_TX_TSO_V2_LBN 0
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_TX_TSO_V2_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_TX_TSO_V2_ENCAP_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_TX_TSO_V2_ENCAP_LBN 1
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_TX_TSO_V2_ENCAP_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_EVQ_TIMER_CTRL_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_EVQ_TIMER_CTRL_LBN 2
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_EVQ_TIMER_CTRL_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_EVENT_CUT_THROUGH_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_EVENT_CUT_THROUGH_LBN 3
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_EVENT_CUT_THROUGH_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_RX_CUT_THROUGH_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_RX_CUT_THROUGH_LBN 4
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_RX_CUT_THROUGH_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_TX_VFIFO_ULL_MODE_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_TX_VFIFO_ULL_MODE_LBN 5
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_TX_VFIFO_ULL_MODE_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_MAC_STATS_40G_TX_SIZE_BINS_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_MAC_STATS_40G_TX_SIZE_BINS_LBN 6
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_MAC_STATS_40G_TX_SIZE_BINS_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_INIT_EVQ_TYPE_SUPPORTED_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_INIT_EVQ_TYPE_SUPPORTED_LBN 7
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_INIT_EVQ_TYPE_SUPPORTED_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_INIT_EVQ_V2_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_INIT_EVQ_V2_LBN 7
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_INIT_EVQ_V2_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_TX_MAC_TIMESTAMPING_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_TX_MAC_TIMESTAMPING_LBN 8
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_TX_MAC_TIMESTAMPING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_TX_TIMESTAMP_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_TX_TIMESTAMP_LBN 9
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_TX_TIMESTAMP_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_RX_SNIFF_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_RX_SNIFF_LBN 10
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_RX_SNIFF_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_TX_SNIFF_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_TX_SNIFF_LBN 11
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_TX_SNIFF_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_NVRAM_UPDATE_REPORT_VERIFY_RESULT_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_NVRAM_UPDATE_REPORT_VERIFY_RESULT_LBN 12
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_NVRAM_UPDATE_REPORT_VERIFY_RESULT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_MCDI_BACKGROUND_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_MCDI_BACKGROUND_LBN 13
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_MCDI_BACKGROUND_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_MCDI_DB_RETURN_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_MCDI_DB_RETURN_LBN 14
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_MCDI_DB_RETURN_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_CTPIO_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_CTPIO_LBN 15
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_CTPIO_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_TSA_SUPPORT_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_TSA_SUPPORT_LBN 16
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_TSA_SUPPORT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_TSA_BOUND_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_TSA_BOUND_LBN 17
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_TSA_BOUND_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_SF_ADAPTER_AUTHENTICATION_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_SF_ADAPTER_AUTHENTICATION_LBN 18
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_SF_ADAPTER_AUTHENTICATION_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_FILTER_ACTION_FLAG_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_FILTER_ACTION_FLAG_LBN 19
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_FILTER_ACTION_FLAG_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_FILTER_ACTION_MARK_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_FILTER_ACTION_MARK_LBN 20
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_FILTER_ACTION_MARK_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_EQUAL_STRIDE_SUPER_BUFFER_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_EQUAL_STRIDE_SUPER_BUFFER_LBN 21
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_EQUAL_STRIDE_SUPER_BUFFER_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_EQUAL_STRIDE_PACKED_STREAM_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_EQUAL_STRIDE_PACKED_STREAM_LBN 21
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_EQUAL_STRIDE_PACKED_STREAM_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_L3XUDP_SUPPORT_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_L3XUDP_SUPPORT_LBN 22
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_L3XUDP_SUPPORT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_FW_SUBVARIANT_NO_TX_CSUM_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_FW_SUBVARIANT_NO_TX_CSUM_LBN 23
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_FW_SUBVARIANT_NO_TX_CSUM_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_VI_SPREADING_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_VI_SPREADING_LBN 24
 #define        MC_CMD_GET_CAPABILITIES_V3_OUT_VI_SPREADING_WIDTH 1
-/* Number of FATSOv2 contexts per datapath supported by this NIC. Not present
- * on older firmware (check the length).
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_RXDP_HLB_IDLE_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_RXDP_HLB_IDLE_LBN 25
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_RXDP_HLB_IDLE_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_INIT_RXQ_NO_CONT_EV_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_INIT_RXQ_NO_CONT_EV_LBN 26
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_INIT_RXQ_NO_CONT_EV_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_INIT_RXQ_WITH_BUFFER_SIZE_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_INIT_RXQ_WITH_BUFFER_SIZE_LBN 27
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_INIT_RXQ_WITH_BUFFER_SIZE_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_BUNDLE_UPDATE_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_BUNDLE_UPDATE_LBN 28
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_BUNDLE_UPDATE_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_TX_TSO_V3_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_TX_TSO_V3_LBN 29
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_TX_TSO_V3_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_DYNAMIC_SENSORS_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_DYNAMIC_SENSORS_LBN 30
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_DYNAMIC_SENSORS_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_NVRAM_UPDATE_POLL_VERIFY_RESULT_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_NVRAM_UPDATE_POLL_VERIFY_RESULT_LBN 31
+#define        MC_CMD_GET_CAPABILITIES_V3_OUT_NVRAM_UPDATE_POLL_VERIFY_RESULT_WIDTH 1
+/* Number of FATSOv2 contexts per datapath supported by this NIC (when
+ * TX_TSO_V2 == 1). Not present on older firmware (check the length).
  */
 #define       MC_CMD_GET_CAPABILITIES_V3_OUT_TX_TSO_V2_N_CONTEXTS_OFST 24
 #define       MC_CMD_GET_CAPABILITIES_V3_OUT_TX_TSO_V2_N_CONTEXTS_LEN 2
@@ -10474,62 +12667,91 @@
 /* First word of flags. */
 #define       MC_CMD_GET_CAPABILITIES_V4_OUT_FLAGS1_OFST 0
 #define       MC_CMD_GET_CAPABILITIES_V4_OUT_FLAGS1_LEN 4
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_VPORT_RECONFIGURE_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_VPORT_RECONFIGURE_LBN 3
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_VPORT_RECONFIGURE_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_TX_STRIPING_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_TX_STRIPING_LBN 4
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_TX_STRIPING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_VADAPTOR_QUERY_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_VADAPTOR_QUERY_LBN 5
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_VADAPTOR_QUERY_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_EVB_PORT_VLAN_RESTRICT_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_EVB_PORT_VLAN_RESTRICT_LBN 6
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_EVB_PORT_VLAN_RESTRICT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_DRV_ATTACH_PREBOOT_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_DRV_ATTACH_PREBOOT_LBN 7
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_DRV_ATTACH_PREBOOT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_RX_FORCE_EVENT_MERGING_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_RX_FORCE_EVENT_MERGING_LBN 8
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_RX_FORCE_EVENT_MERGING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_SET_MAC_ENHANCED_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_SET_MAC_ENHANCED_LBN 9
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_SET_MAC_ENHANCED_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_UNKNOWN_UCAST_DST_FILTER_ALWAYS_MULTI_RECIPIENT_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_UNKNOWN_UCAST_DST_FILTER_ALWAYS_MULTI_RECIPIENT_LBN 10
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_UNKNOWN_UCAST_DST_FILTER_ALWAYS_MULTI_RECIPIENT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_VADAPTOR_PERMIT_SET_MAC_WHEN_FILTERS_INSTALLED_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_VADAPTOR_PERMIT_SET_MAC_WHEN_FILTERS_INSTALLED_LBN 11
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_VADAPTOR_PERMIT_SET_MAC_WHEN_FILTERS_INSTALLED_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_TX_MAC_SECURITY_FILTERING_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_TX_MAC_SECURITY_FILTERING_LBN 12
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_TX_MAC_SECURITY_FILTERING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_ADDITIONAL_RSS_MODES_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_ADDITIONAL_RSS_MODES_LBN 13
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_ADDITIONAL_RSS_MODES_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_QBB_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_QBB_LBN 14
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_QBB_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_RX_PACKED_STREAM_VAR_BUFFERS_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_RX_PACKED_STREAM_VAR_BUFFERS_LBN 15
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_RX_PACKED_STREAM_VAR_BUFFERS_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_RX_RSS_LIMITED_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_RX_RSS_LIMITED_LBN 16
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_RX_RSS_LIMITED_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_RX_PACKED_STREAM_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_RX_PACKED_STREAM_LBN 17
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_RX_PACKED_STREAM_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_RX_INCLUDE_FCS_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_RX_INCLUDE_FCS_LBN 18
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_RX_INCLUDE_FCS_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_TX_VLAN_INSERTION_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_TX_VLAN_INSERTION_LBN 19
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_TX_VLAN_INSERTION_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_RX_VLAN_STRIPPING_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_RX_VLAN_STRIPPING_LBN 20
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_RX_VLAN_STRIPPING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_TX_TSO_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_TX_TSO_LBN 21
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_TX_TSO_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_RX_PREFIX_LEN_0_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_RX_PREFIX_LEN_0_LBN 22
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_RX_PREFIX_LEN_0_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_RX_PREFIX_LEN_14_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_RX_PREFIX_LEN_14_LBN 23
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_RX_PREFIX_LEN_14_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_RX_TIMESTAMP_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_RX_TIMESTAMP_LBN 24
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_RX_TIMESTAMP_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_RX_BATCHING_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_RX_BATCHING_LBN 25
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_RX_BATCHING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_MCAST_FILTER_CHAINING_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_MCAST_FILTER_CHAINING_LBN 26
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_MCAST_FILTER_CHAINING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_PM_AND_RXDP_COUNTERS_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_PM_AND_RXDP_COUNTERS_LBN 27
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_PM_AND_RXDP_COUNTERS_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_RX_DISABLE_SCATTER_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_RX_DISABLE_SCATTER_LBN 28
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_RX_DISABLE_SCATTER_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_TX_MCAST_UDP_LOOPBACK_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_TX_MCAST_UDP_LOOPBACK_LBN 29
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_TX_MCAST_UDP_LOOPBACK_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_EVB_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_EVB_LBN 30
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_EVB_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_VXLAN_NVGRE_OFST 0
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_VXLAN_NVGRE_LBN 31
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_VXLAN_NVGRE_WIDTH 1
 /* RxDPCPU firmware id. */
@@ -10590,8 +12812,10 @@
 #define          MC_CMD_GET_CAPABILITIES_V4_OUT_TXDP_TEST_FW_CSR 0x103
 #define       MC_CMD_GET_CAPABILITIES_V4_OUT_RXPD_FW_VERSION_OFST 8
 #define       MC_CMD_GET_CAPABILITIES_V4_OUT_RXPD_FW_VERSION_LEN 2
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_RXPD_FW_VERSION_REV_OFST 8
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_RXPD_FW_VERSION_REV_LBN 0
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_RXPD_FW_VERSION_REV_WIDTH 12
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_RXPD_FW_VERSION_TYPE_OFST 8
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_RXPD_FW_VERSION_TYPE_LBN 12
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_RXPD_FW_VERSION_TYPE_WIDTH 4
 /* enum: reserved value - do not use (may indicate alternative interpretation
@@ -10602,6 +12826,9 @@
  * development only)
  */
 #define          MC_CMD_GET_CAPABILITIES_V4_OUT_RXPD_FW_TYPE_FIRST_PKT 0x1
+/* enum: RX PD firmware for telemetry prototyping (Medford2 development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V4_OUT_RXPD_FW_TYPE_TESTFW_TELEMETRY 0x1
 /* enum: RX PD firmware with approximately Siena-compatible behaviour
  * (Huntington development only)
  */
@@ -10636,8 +12863,10 @@
 #define          MC_CMD_GET_CAPABILITIES_V4_OUT_RXPD_FW_TYPE_TESTFW_ENCAP_PARSING_ONLY 0xf
 #define       MC_CMD_GET_CAPABILITIES_V4_OUT_TXPD_FW_VERSION_OFST 10
 #define       MC_CMD_GET_CAPABILITIES_V4_OUT_TXPD_FW_VERSION_LEN 2
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_TXPD_FW_VERSION_REV_OFST 10
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_TXPD_FW_VERSION_REV_LBN 0
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_TXPD_FW_VERSION_REV_WIDTH 12
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_TXPD_FW_VERSION_TYPE_OFST 10
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_TXPD_FW_VERSION_TYPE_LBN 12
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_TXPD_FW_VERSION_TYPE_WIDTH 4
 /* enum: reserved value - do not use (may indicate alternative interpretation
@@ -10648,6 +12877,9 @@
  * development only)
  */
 #define          MC_CMD_GET_CAPABILITIES_V4_OUT_TXPD_FW_TYPE_FIRST_PKT 0x1
+/* enum: TX PD firmware for telemetry prototyping (Medford2 development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V4_OUT_TXPD_FW_TYPE_TESTFW_TELEMETRY 0x1
 /* enum: TX PD firmware with approximately Siena-compatible behaviour
  * (Huntington development only)
  */
@@ -10682,58 +12914,110 @@
 /* Second word of flags. Not present on older firmware (check the length). */
 #define       MC_CMD_GET_CAPABILITIES_V4_OUT_FLAGS2_OFST 20
 #define       MC_CMD_GET_CAPABILITIES_V4_OUT_FLAGS2_LEN 4
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_TX_TSO_V2_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_TX_TSO_V2_LBN 0
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_TX_TSO_V2_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_TX_TSO_V2_ENCAP_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_TX_TSO_V2_ENCAP_LBN 1
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_TX_TSO_V2_ENCAP_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_EVQ_TIMER_CTRL_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_EVQ_TIMER_CTRL_LBN 2
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_EVQ_TIMER_CTRL_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_EVENT_CUT_THROUGH_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_EVENT_CUT_THROUGH_LBN 3
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_EVENT_CUT_THROUGH_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_RX_CUT_THROUGH_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_RX_CUT_THROUGH_LBN 4
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_RX_CUT_THROUGH_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_TX_VFIFO_ULL_MODE_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_TX_VFIFO_ULL_MODE_LBN 5
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_TX_VFIFO_ULL_MODE_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_MAC_STATS_40G_TX_SIZE_BINS_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_MAC_STATS_40G_TX_SIZE_BINS_LBN 6
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_MAC_STATS_40G_TX_SIZE_BINS_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_INIT_EVQ_TYPE_SUPPORTED_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_INIT_EVQ_TYPE_SUPPORTED_LBN 7
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_INIT_EVQ_TYPE_SUPPORTED_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_INIT_EVQ_V2_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_INIT_EVQ_V2_LBN 7
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_INIT_EVQ_V2_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_TX_MAC_TIMESTAMPING_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_TX_MAC_TIMESTAMPING_LBN 8
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_TX_MAC_TIMESTAMPING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_TX_TIMESTAMP_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_TX_TIMESTAMP_LBN 9
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_TX_TIMESTAMP_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_RX_SNIFF_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_RX_SNIFF_LBN 10
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_RX_SNIFF_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_TX_SNIFF_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_TX_SNIFF_LBN 11
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_TX_SNIFF_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_NVRAM_UPDATE_REPORT_VERIFY_RESULT_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_NVRAM_UPDATE_REPORT_VERIFY_RESULT_LBN 12
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_NVRAM_UPDATE_REPORT_VERIFY_RESULT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_MCDI_BACKGROUND_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_MCDI_BACKGROUND_LBN 13
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_MCDI_BACKGROUND_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_MCDI_DB_RETURN_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_MCDI_DB_RETURN_LBN 14
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_MCDI_DB_RETURN_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_CTPIO_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_CTPIO_LBN 15
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_CTPIO_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_TSA_SUPPORT_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_TSA_SUPPORT_LBN 16
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_TSA_SUPPORT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_TSA_BOUND_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_TSA_BOUND_LBN 17
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_TSA_BOUND_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_SF_ADAPTER_AUTHENTICATION_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_SF_ADAPTER_AUTHENTICATION_LBN 18
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_SF_ADAPTER_AUTHENTICATION_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_FILTER_ACTION_FLAG_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_FILTER_ACTION_FLAG_LBN 19
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_FILTER_ACTION_FLAG_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_FILTER_ACTION_MARK_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_FILTER_ACTION_MARK_LBN 20
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_FILTER_ACTION_MARK_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_EQUAL_STRIDE_SUPER_BUFFER_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_EQUAL_STRIDE_SUPER_BUFFER_LBN 21
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_EQUAL_STRIDE_SUPER_BUFFER_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_EQUAL_STRIDE_PACKED_STREAM_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_EQUAL_STRIDE_PACKED_STREAM_LBN 21
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_EQUAL_STRIDE_PACKED_STREAM_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_L3XUDP_SUPPORT_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_L3XUDP_SUPPORT_LBN 22
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_L3XUDP_SUPPORT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_FW_SUBVARIANT_NO_TX_CSUM_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_FW_SUBVARIANT_NO_TX_CSUM_LBN 23
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_FW_SUBVARIANT_NO_TX_CSUM_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_VI_SPREADING_OFST 20
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_VI_SPREADING_LBN 24
 #define        MC_CMD_GET_CAPABILITIES_V4_OUT_VI_SPREADING_WIDTH 1
-/* Number of FATSOv2 contexts per datapath supported by this NIC. Not present
- * on older firmware (check the length).
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_RXDP_HLB_IDLE_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_RXDP_HLB_IDLE_LBN 25
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_RXDP_HLB_IDLE_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_INIT_RXQ_NO_CONT_EV_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_INIT_RXQ_NO_CONT_EV_LBN 26
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_INIT_RXQ_NO_CONT_EV_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_INIT_RXQ_WITH_BUFFER_SIZE_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_INIT_RXQ_WITH_BUFFER_SIZE_LBN 27
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_INIT_RXQ_WITH_BUFFER_SIZE_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_BUNDLE_UPDATE_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_BUNDLE_UPDATE_LBN 28
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_BUNDLE_UPDATE_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_TX_TSO_V3_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_TX_TSO_V3_LBN 29
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_TX_TSO_V3_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_DYNAMIC_SENSORS_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_DYNAMIC_SENSORS_LBN 30
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_DYNAMIC_SENSORS_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_NVRAM_UPDATE_POLL_VERIFY_RESULT_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_NVRAM_UPDATE_POLL_VERIFY_RESULT_LBN 31
+#define        MC_CMD_GET_CAPABILITIES_V4_OUT_NVRAM_UPDATE_POLL_VERIFY_RESULT_WIDTH 1
+/* Number of FATSOv2 contexts per datapath supported by this NIC (when
+ * TX_TSO_V2 == 1). Not present on older firmware (check the length).
  */
 #define       MC_CMD_GET_CAPABILITIES_V4_OUT_TX_TSO_V2_N_CONTEXTS_OFST 24
 #define       MC_CMD_GET_CAPABILITIES_V4_OUT_TX_TSO_V2_N_CONTEXTS_LEN 2
@@ -10821,34 +13105,2450 @@
 #define       MC_CMD_GET_CAPABILITIES_V4_OUT_MAC_STATS_NUM_STATS_OFST 76
 #define       MC_CMD_GET_CAPABILITIES_V4_OUT_MAC_STATS_NUM_STATS_LEN 2
 
-
-/***********************************/
-/* MC_CMD_V2_EXTN
- * Encapsulation for a v2 extended command
- */
-#define MC_CMD_V2_EXTN 0x7f
-
-/* MC_CMD_V2_EXTN_IN msgrequest */
-#define    MC_CMD_V2_EXTN_IN_LEN 4
-/* the extended command number */
-#define       MC_CMD_V2_EXTN_IN_EXTENDED_CMD_LBN 0
-#define       MC_CMD_V2_EXTN_IN_EXTENDED_CMD_WIDTH 15
-#define       MC_CMD_V2_EXTN_IN_UNUSED_LBN 15
-#define       MC_CMD_V2_EXTN_IN_UNUSED_WIDTH 1
-/* the actual length of the encapsulated command (which is not in the v1
- * header)
- */
-#define       MC_CMD_V2_EXTN_IN_ACTUAL_LEN_LBN 16
-#define       MC_CMD_V2_EXTN_IN_ACTUAL_LEN_WIDTH 10
-#define       MC_CMD_V2_EXTN_IN_UNUSED2_LBN 26
-#define       MC_CMD_V2_EXTN_IN_UNUSED2_WIDTH 2
-/* Type of command/response */
-#define       MC_CMD_V2_EXTN_IN_MESSAGE_TYPE_LBN 28
-#define       MC_CMD_V2_EXTN_IN_MESSAGE_TYPE_WIDTH 4
-/* enum: MCDI command directed to or response originating from the MC. */
-#define          MC_CMD_V2_EXTN_IN_MCDI_MESSAGE_TYPE_MC 0x0
-/* enum: MCDI command directed to a TSA controller. MCDI responses of this type
- * are not defined.
+/* MC_CMD_GET_CAPABILITIES_V5_OUT msgresponse */
+#define    MC_CMD_GET_CAPABILITIES_V5_OUT_LEN 84
+/* First word of flags. */
+#define       MC_CMD_GET_CAPABILITIES_V5_OUT_FLAGS1_OFST 0
+#define       MC_CMD_GET_CAPABILITIES_V5_OUT_FLAGS1_LEN 4
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_VPORT_RECONFIGURE_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_VPORT_RECONFIGURE_LBN 3
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_VPORT_RECONFIGURE_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_TX_STRIPING_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_TX_STRIPING_LBN 4
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_TX_STRIPING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_VADAPTOR_QUERY_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_VADAPTOR_QUERY_LBN 5
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_VADAPTOR_QUERY_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_EVB_PORT_VLAN_RESTRICT_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_EVB_PORT_VLAN_RESTRICT_LBN 6
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_EVB_PORT_VLAN_RESTRICT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_DRV_ATTACH_PREBOOT_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_DRV_ATTACH_PREBOOT_LBN 7
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_DRV_ATTACH_PREBOOT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_RX_FORCE_EVENT_MERGING_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_RX_FORCE_EVENT_MERGING_LBN 8
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_RX_FORCE_EVENT_MERGING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_SET_MAC_ENHANCED_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_SET_MAC_ENHANCED_LBN 9
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_SET_MAC_ENHANCED_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_UNKNOWN_UCAST_DST_FILTER_ALWAYS_MULTI_RECIPIENT_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_UNKNOWN_UCAST_DST_FILTER_ALWAYS_MULTI_RECIPIENT_LBN 10
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_UNKNOWN_UCAST_DST_FILTER_ALWAYS_MULTI_RECIPIENT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_VADAPTOR_PERMIT_SET_MAC_WHEN_FILTERS_INSTALLED_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_VADAPTOR_PERMIT_SET_MAC_WHEN_FILTERS_INSTALLED_LBN 11
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_VADAPTOR_PERMIT_SET_MAC_WHEN_FILTERS_INSTALLED_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_TX_MAC_SECURITY_FILTERING_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_TX_MAC_SECURITY_FILTERING_LBN 12
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_TX_MAC_SECURITY_FILTERING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_ADDITIONAL_RSS_MODES_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_ADDITIONAL_RSS_MODES_LBN 13
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_ADDITIONAL_RSS_MODES_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_QBB_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_QBB_LBN 14
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_QBB_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_RX_PACKED_STREAM_VAR_BUFFERS_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_RX_PACKED_STREAM_VAR_BUFFERS_LBN 15
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_RX_PACKED_STREAM_VAR_BUFFERS_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_RX_RSS_LIMITED_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_RX_RSS_LIMITED_LBN 16
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_RX_RSS_LIMITED_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_RX_PACKED_STREAM_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_RX_PACKED_STREAM_LBN 17
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_RX_PACKED_STREAM_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_RX_INCLUDE_FCS_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_RX_INCLUDE_FCS_LBN 18
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_RX_INCLUDE_FCS_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_TX_VLAN_INSERTION_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_TX_VLAN_INSERTION_LBN 19
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_TX_VLAN_INSERTION_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_RX_VLAN_STRIPPING_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_RX_VLAN_STRIPPING_LBN 20
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_RX_VLAN_STRIPPING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_TX_TSO_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_TX_TSO_LBN 21
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_TX_TSO_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_RX_PREFIX_LEN_0_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_RX_PREFIX_LEN_0_LBN 22
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_RX_PREFIX_LEN_0_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_RX_PREFIX_LEN_14_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_RX_PREFIX_LEN_14_LBN 23
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_RX_PREFIX_LEN_14_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_RX_TIMESTAMP_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_RX_TIMESTAMP_LBN 24
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_RX_TIMESTAMP_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_RX_BATCHING_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_RX_BATCHING_LBN 25
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_RX_BATCHING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_MCAST_FILTER_CHAINING_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_MCAST_FILTER_CHAINING_LBN 26
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_MCAST_FILTER_CHAINING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_PM_AND_RXDP_COUNTERS_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_PM_AND_RXDP_COUNTERS_LBN 27
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_PM_AND_RXDP_COUNTERS_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_RX_DISABLE_SCATTER_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_RX_DISABLE_SCATTER_LBN 28
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_RX_DISABLE_SCATTER_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_TX_MCAST_UDP_LOOPBACK_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_TX_MCAST_UDP_LOOPBACK_LBN 29
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_TX_MCAST_UDP_LOOPBACK_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_EVB_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_EVB_LBN 30
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_EVB_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_VXLAN_NVGRE_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_VXLAN_NVGRE_LBN 31
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_VXLAN_NVGRE_WIDTH 1
+/* RxDPCPU firmware id. */
+#define       MC_CMD_GET_CAPABILITIES_V5_OUT_RX_DPCPU_FW_ID_OFST 4
+#define       MC_CMD_GET_CAPABILITIES_V5_OUT_RX_DPCPU_FW_ID_LEN 2
+/* enum: Standard RXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_RXDP 0x0
+/* enum: Low latency RXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_RXDP_LOW_LATENCY 0x1
+/* enum: Packed stream RXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_RXDP_PACKED_STREAM 0x2
+/* enum: Rules engine RXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_RXDP_RULES_ENGINE 0x5
+/* enum: DPDK RXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_RXDP_DPDK 0x6
+/* enum: BIST RXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_RXDP_BIST 0x10a
+/* enum: RXDP Test firmware image 1 */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_RXDP_TEST_FW_TO_MC_CUT_THROUGH 0x101
+/* enum: RXDP Test firmware image 2 */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_RXDP_TEST_FW_TO_MC_STORE_FORWARD 0x102
+/* enum: RXDP Test firmware image 3 */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_RXDP_TEST_FW_TO_MC_STORE_FORWARD_FIRST 0x103
+/* enum: RXDP Test firmware image 4 */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_RXDP_TEST_EVERY_EVENT_BATCHABLE 0x104
+/* enum: RXDP Test firmware image 5 */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_RXDP_TEST_BACKPRESSURE 0x105
+/* enum: RXDP Test firmware image 6 */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_RXDP_TEST_FW_PACKET_EDITS 0x106
+/* enum: RXDP Test firmware image 7 */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_RXDP_TEST_FW_RX_HDR_SPLIT 0x107
+/* enum: RXDP Test firmware image 8 */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_RXDP_TEST_FW_DISABLE_DL 0x108
+/* enum: RXDP Test firmware image 9 */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_RXDP_TEST_FW_DOORBELL_DELAY 0x10b
+/* enum: RXDP Test firmware image 10 */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_RXDP_TEST_FW_SLOW 0x10c
+/* TxDPCPU firmware id. */
+#define       MC_CMD_GET_CAPABILITIES_V5_OUT_TX_DPCPU_FW_ID_OFST 6
+#define       MC_CMD_GET_CAPABILITIES_V5_OUT_TX_DPCPU_FW_ID_LEN 2
+/* enum: Standard TXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_TXDP 0x0
+/* enum: Low latency TXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_TXDP_LOW_LATENCY 0x1
+/* enum: High packet rate TXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_TXDP_HIGH_PACKET_RATE 0x3
+/* enum: Rules engine TXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_TXDP_RULES_ENGINE 0x5
+/* enum: DPDK TXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_TXDP_DPDK 0x6
+/* enum: BIST TXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_TXDP_BIST 0x12d
+/* enum: TXDP Test firmware image 1 */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_TXDP_TEST_FW_TSO_EDIT 0x101
+/* enum: TXDP Test firmware image 2 */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_TXDP_TEST_FW_PACKET_EDITS 0x102
+/* enum: TXDP CSR bus test firmware */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_TXDP_TEST_FW_CSR 0x103
+#define       MC_CMD_GET_CAPABILITIES_V5_OUT_RXPD_FW_VERSION_OFST 8
+#define       MC_CMD_GET_CAPABILITIES_V5_OUT_RXPD_FW_VERSION_LEN 2
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_RXPD_FW_VERSION_REV_OFST 8
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_RXPD_FW_VERSION_REV_LBN 0
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_RXPD_FW_VERSION_REV_WIDTH 12
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_RXPD_FW_VERSION_TYPE_OFST 8
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_RXPD_FW_VERSION_TYPE_LBN 12
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_RXPD_FW_VERSION_TYPE_WIDTH 4
+/* enum: reserved value - do not use (may indicate alternative interpretation
+ * of REV field in future)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_RXPD_FW_TYPE_RESERVED 0x0
+/* enum: Trivial RX PD firmware for early Huntington development (Huntington
+ * development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_RXPD_FW_TYPE_FIRST_PKT 0x1
+/* enum: RX PD firmware for telemetry prototyping (Medford2 development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_RXPD_FW_TYPE_TESTFW_TELEMETRY 0x1
+/* enum: RX PD firmware with approximately Siena-compatible behaviour
+ * (Huntington development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_RXPD_FW_TYPE_SIENA_COMPAT 0x2
+/* enum: Full featured RX PD production firmware */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_RXPD_FW_TYPE_FULL_FEATURED 0x3
+/* enum: (deprecated original name for the FULL_FEATURED variant) */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_RXPD_FW_TYPE_VSWITCH 0x3
+/* enum: siena_compat variant RX PD firmware using PM rather than MAC
+ * (Huntington development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_RXPD_FW_TYPE_SIENA_COMPAT_PM 0x4
+/* enum: Low latency RX PD production firmware */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_RXPD_FW_TYPE_LOW_LATENCY 0x5
+/* enum: Packed stream RX PD production firmware */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_RXPD_FW_TYPE_PACKED_STREAM 0x6
+/* enum: RX PD firmware handling layer 2 only for high packet rate performance
+ * tests (Medford development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_RXPD_FW_TYPE_LAYER2_PERF 0x7
+/* enum: Rules engine RX PD production firmware */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_RXPD_FW_TYPE_RULES_ENGINE 0x8
+/* enum: Custom firmware variant (see SF-119495-PD and bug69716) */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_RXPD_FW_TYPE_L3XUDP 0x9
+/* enum: DPDK RX PD production firmware */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_RXPD_FW_TYPE_DPDK 0xa
+/* enum: RX PD firmware for GUE parsing prototype (Medford development only) */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_RXPD_FW_TYPE_TESTFW_GUE_PROTOTYPE 0xe
+/* enum: RX PD firmware parsing but not filtering network overlay tunnel
+ * encapsulations (Medford development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_RXPD_FW_TYPE_TESTFW_ENCAP_PARSING_ONLY 0xf
+#define       MC_CMD_GET_CAPABILITIES_V5_OUT_TXPD_FW_VERSION_OFST 10
+#define       MC_CMD_GET_CAPABILITIES_V5_OUT_TXPD_FW_VERSION_LEN 2
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_TXPD_FW_VERSION_REV_OFST 10
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_TXPD_FW_VERSION_REV_LBN 0
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_TXPD_FW_VERSION_REV_WIDTH 12
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_TXPD_FW_VERSION_TYPE_OFST 10
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_TXPD_FW_VERSION_TYPE_LBN 12
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_TXPD_FW_VERSION_TYPE_WIDTH 4
+/* enum: reserved value - do not use (may indicate alternative interpretation
+ * of REV field in future)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_TXPD_FW_TYPE_RESERVED 0x0
+/* enum: Trivial TX PD firmware for early Huntington development (Huntington
+ * development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_TXPD_FW_TYPE_FIRST_PKT 0x1
+/* enum: TX PD firmware for telemetry prototyping (Medford2 development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_TXPD_FW_TYPE_TESTFW_TELEMETRY 0x1
+/* enum: TX PD firmware with approximately Siena-compatible behaviour
+ * (Huntington development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_TXPD_FW_TYPE_SIENA_COMPAT 0x2
+/* enum: Full featured TX PD production firmware */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_TXPD_FW_TYPE_FULL_FEATURED 0x3
+/* enum: (deprecated original name for the FULL_FEATURED variant) */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_TXPD_FW_TYPE_VSWITCH 0x3
+/* enum: siena_compat variant TX PD firmware using PM rather than MAC
+ * (Huntington development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_TXPD_FW_TYPE_SIENA_COMPAT_PM 0x4
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_TXPD_FW_TYPE_LOW_LATENCY 0x5 /* enum */
+/* enum: TX PD firmware handling layer 2 only for high packet rate performance
+ * tests (Medford development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_TXPD_FW_TYPE_LAYER2_PERF 0x7
+/* enum: Rules engine TX PD production firmware */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_TXPD_FW_TYPE_RULES_ENGINE 0x8
+/* enum: Custom firmware variant (see SF-119495-PD and bug69716) */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_TXPD_FW_TYPE_L3XUDP 0x9
+/* enum: DPDK TX PD production firmware */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_TXPD_FW_TYPE_DPDK 0xa
+/* enum: RX PD firmware for GUE parsing prototype (Medford development only) */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_TXPD_FW_TYPE_TESTFW_GUE_PROTOTYPE 0xe
+/* Hardware capabilities of NIC */
+#define       MC_CMD_GET_CAPABILITIES_V5_OUT_HW_CAPABILITIES_OFST 12
+#define       MC_CMD_GET_CAPABILITIES_V5_OUT_HW_CAPABILITIES_LEN 4
+/* Licensed capabilities */
+#define       MC_CMD_GET_CAPABILITIES_V5_OUT_LICENSE_CAPABILITIES_OFST 16
+#define       MC_CMD_GET_CAPABILITIES_V5_OUT_LICENSE_CAPABILITIES_LEN 4
+/* Second word of flags. Not present on older firmware (check the length). */
+#define       MC_CMD_GET_CAPABILITIES_V5_OUT_FLAGS2_OFST 20
+#define       MC_CMD_GET_CAPABILITIES_V5_OUT_FLAGS2_LEN 4
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_TX_TSO_V2_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_TX_TSO_V2_LBN 0
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_TX_TSO_V2_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_TX_TSO_V2_ENCAP_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_TX_TSO_V2_ENCAP_LBN 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_TX_TSO_V2_ENCAP_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_EVQ_TIMER_CTRL_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_EVQ_TIMER_CTRL_LBN 2
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_EVQ_TIMER_CTRL_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_EVENT_CUT_THROUGH_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_EVENT_CUT_THROUGH_LBN 3
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_EVENT_CUT_THROUGH_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_RX_CUT_THROUGH_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_RX_CUT_THROUGH_LBN 4
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_RX_CUT_THROUGH_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_TX_VFIFO_ULL_MODE_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_TX_VFIFO_ULL_MODE_LBN 5
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_TX_VFIFO_ULL_MODE_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_MAC_STATS_40G_TX_SIZE_BINS_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_MAC_STATS_40G_TX_SIZE_BINS_LBN 6
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_MAC_STATS_40G_TX_SIZE_BINS_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_INIT_EVQ_TYPE_SUPPORTED_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_INIT_EVQ_TYPE_SUPPORTED_LBN 7
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_INIT_EVQ_TYPE_SUPPORTED_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_INIT_EVQ_V2_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_INIT_EVQ_V2_LBN 7
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_INIT_EVQ_V2_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_TX_MAC_TIMESTAMPING_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_TX_MAC_TIMESTAMPING_LBN 8
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_TX_MAC_TIMESTAMPING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_TX_TIMESTAMP_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_TX_TIMESTAMP_LBN 9
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_TX_TIMESTAMP_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_RX_SNIFF_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_RX_SNIFF_LBN 10
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_RX_SNIFF_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_TX_SNIFF_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_TX_SNIFF_LBN 11
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_TX_SNIFF_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_NVRAM_UPDATE_REPORT_VERIFY_RESULT_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_NVRAM_UPDATE_REPORT_VERIFY_RESULT_LBN 12
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_NVRAM_UPDATE_REPORT_VERIFY_RESULT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_MCDI_BACKGROUND_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_MCDI_BACKGROUND_LBN 13
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_MCDI_BACKGROUND_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_MCDI_DB_RETURN_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_MCDI_DB_RETURN_LBN 14
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_MCDI_DB_RETURN_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_CTPIO_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_CTPIO_LBN 15
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_CTPIO_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_TSA_SUPPORT_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_TSA_SUPPORT_LBN 16
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_TSA_SUPPORT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_TSA_BOUND_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_TSA_BOUND_LBN 17
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_TSA_BOUND_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_SF_ADAPTER_AUTHENTICATION_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_SF_ADAPTER_AUTHENTICATION_LBN 18
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_SF_ADAPTER_AUTHENTICATION_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_FILTER_ACTION_FLAG_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_FILTER_ACTION_FLAG_LBN 19
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_FILTER_ACTION_FLAG_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_FILTER_ACTION_MARK_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_FILTER_ACTION_MARK_LBN 20
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_FILTER_ACTION_MARK_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_EQUAL_STRIDE_SUPER_BUFFER_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_EQUAL_STRIDE_SUPER_BUFFER_LBN 21
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_EQUAL_STRIDE_SUPER_BUFFER_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_EQUAL_STRIDE_PACKED_STREAM_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_EQUAL_STRIDE_PACKED_STREAM_LBN 21
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_EQUAL_STRIDE_PACKED_STREAM_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_L3XUDP_SUPPORT_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_L3XUDP_SUPPORT_LBN 22
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_L3XUDP_SUPPORT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_FW_SUBVARIANT_NO_TX_CSUM_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_FW_SUBVARIANT_NO_TX_CSUM_LBN 23
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_FW_SUBVARIANT_NO_TX_CSUM_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_VI_SPREADING_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_VI_SPREADING_LBN 24
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_VI_SPREADING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_RXDP_HLB_IDLE_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_RXDP_HLB_IDLE_LBN 25
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_RXDP_HLB_IDLE_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_INIT_RXQ_NO_CONT_EV_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_INIT_RXQ_NO_CONT_EV_LBN 26
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_INIT_RXQ_NO_CONT_EV_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_INIT_RXQ_WITH_BUFFER_SIZE_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_INIT_RXQ_WITH_BUFFER_SIZE_LBN 27
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_INIT_RXQ_WITH_BUFFER_SIZE_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_BUNDLE_UPDATE_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_BUNDLE_UPDATE_LBN 28
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_BUNDLE_UPDATE_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_TX_TSO_V3_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_TX_TSO_V3_LBN 29
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_TX_TSO_V3_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_DYNAMIC_SENSORS_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_DYNAMIC_SENSORS_LBN 30
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_DYNAMIC_SENSORS_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_NVRAM_UPDATE_POLL_VERIFY_RESULT_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_NVRAM_UPDATE_POLL_VERIFY_RESULT_LBN 31
+#define        MC_CMD_GET_CAPABILITIES_V5_OUT_NVRAM_UPDATE_POLL_VERIFY_RESULT_WIDTH 1
+/* Number of FATSOv2 contexts per datapath supported by this NIC (when
+ * TX_TSO_V2 == 1). Not present on older firmware (check the length).
+ */
+#define       MC_CMD_GET_CAPABILITIES_V5_OUT_TX_TSO_V2_N_CONTEXTS_OFST 24
+#define       MC_CMD_GET_CAPABILITIES_V5_OUT_TX_TSO_V2_N_CONTEXTS_LEN 2
+/* One byte per PF containing the number of the external port assigned to this
+ * PF, indexed by PF number. Special values indicate that a PF is either not
+ * present or not assigned.
+ */
+#define       MC_CMD_GET_CAPABILITIES_V5_OUT_PFS_TO_PORTS_ASSIGNMENT_OFST 26
+#define       MC_CMD_GET_CAPABILITIES_V5_OUT_PFS_TO_PORTS_ASSIGNMENT_LEN 1
+#define       MC_CMD_GET_CAPABILITIES_V5_OUT_PFS_TO_PORTS_ASSIGNMENT_NUM 16
+/* enum: The caller is not permitted to access information on this PF. */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_ACCESS_NOT_PERMITTED 0xff
+/* enum: PF does not exist. */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_PF_NOT_PRESENT 0xfe
+/* enum: PF does exist but is not assigned to any external port. */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_PF_NOT_ASSIGNED 0xfd
+/* enum: This value indicates that PF is assigned, but it cannot be expressed
+ * in this field. It is intended for a possible future situation where a more
+ * complex scheme of PFs to ports mapping is being used. The future driver
+ * should look for a new field supporting the new scheme. The current/old
+ * driver should treat this value as PF_NOT_ASSIGNED.
+ */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_INCOMPATIBLE_ASSIGNMENT 0xfc
+/* One byte per PF containing the number of its VFs, indexed by PF number. A
+ * special value indicates that a PF is not present.
+ */
+#define       MC_CMD_GET_CAPABILITIES_V5_OUT_NUM_VFS_PER_PF_OFST 42
+#define       MC_CMD_GET_CAPABILITIES_V5_OUT_NUM_VFS_PER_PF_LEN 1
+#define       MC_CMD_GET_CAPABILITIES_V5_OUT_NUM_VFS_PER_PF_NUM 16
+/* enum: The caller is not permitted to access information on this PF. */
+/*               MC_CMD_GET_CAPABILITIES_V5_OUT_ACCESS_NOT_PERMITTED 0xff */
+/* enum: PF does not exist. */
+/*               MC_CMD_GET_CAPABILITIES_V5_OUT_PF_NOT_PRESENT 0xfe */
+/* Number of VIs available for each external port */
+#define       MC_CMD_GET_CAPABILITIES_V5_OUT_NUM_VIS_PER_PORT_OFST 58
+#define       MC_CMD_GET_CAPABILITIES_V5_OUT_NUM_VIS_PER_PORT_LEN 2
+#define       MC_CMD_GET_CAPABILITIES_V5_OUT_NUM_VIS_PER_PORT_NUM 4
+/* Size of RX descriptor cache expressed as binary logarithm The actual size
+ * equals (2 ^ RX_DESC_CACHE_SIZE)
+ */
+#define       MC_CMD_GET_CAPABILITIES_V5_OUT_RX_DESC_CACHE_SIZE_OFST 66
+#define       MC_CMD_GET_CAPABILITIES_V5_OUT_RX_DESC_CACHE_SIZE_LEN 1
+/* Size of TX descriptor cache expressed as binary logarithm The actual size
+ * equals (2 ^ TX_DESC_CACHE_SIZE)
+ */
+#define       MC_CMD_GET_CAPABILITIES_V5_OUT_TX_DESC_CACHE_SIZE_OFST 67
+#define       MC_CMD_GET_CAPABILITIES_V5_OUT_TX_DESC_CACHE_SIZE_LEN 1
+/* Total number of available PIO buffers */
+#define       MC_CMD_GET_CAPABILITIES_V5_OUT_NUM_PIO_BUFFS_OFST 68
+#define       MC_CMD_GET_CAPABILITIES_V5_OUT_NUM_PIO_BUFFS_LEN 2
+/* Size of a single PIO buffer */
+#define       MC_CMD_GET_CAPABILITIES_V5_OUT_SIZE_PIO_BUFF_OFST 70
+#define       MC_CMD_GET_CAPABILITIES_V5_OUT_SIZE_PIO_BUFF_LEN 2
+/* On chips later than Medford the amount of address space assigned to each VI
+ * is configurable. This is a global setting that the driver must query to
+ * discover the VI to address mapping. Cut-through PIO (CTPIO) is not available
+ * with 8k VI windows.
+ */
+#define       MC_CMD_GET_CAPABILITIES_V5_OUT_VI_WINDOW_MODE_OFST 72
+#define       MC_CMD_GET_CAPABILITIES_V5_OUT_VI_WINDOW_MODE_LEN 1
+/* enum: Each VI occupies 8k as on Huntington and Medford. PIO is at offset 4k.
+ * CTPIO is not mapped.
+ */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_VI_WINDOW_MODE_8K 0x0
+/* enum: Each VI occupies 16k. PIO is at offset 4k. CTPIO is at offset 12k. */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_VI_WINDOW_MODE_16K 0x1
+/* enum: Each VI occupies 64k. PIO is at offset 4k. CTPIO is at offset 12k. */
+#define          MC_CMD_GET_CAPABILITIES_V5_OUT_VI_WINDOW_MODE_64K 0x2
+/* Number of vFIFOs per adapter that can be used for VFIFO Stuffing
+ * (SF-115995-SW) in the present configuration of firmware and port mode.
+ */
+#define       MC_CMD_GET_CAPABILITIES_V5_OUT_VFIFO_STUFFING_NUM_VFIFOS_OFST 73
+#define       MC_CMD_GET_CAPABILITIES_V5_OUT_VFIFO_STUFFING_NUM_VFIFOS_LEN 1
+/* Number of buffers per adapter that can be used for VFIFO Stuffing
+ * (SF-115995-SW) in the present configuration of firmware and port mode.
+ */
+#define       MC_CMD_GET_CAPABILITIES_V5_OUT_VFIFO_STUFFING_NUM_CP_BUFFERS_OFST 74
+#define       MC_CMD_GET_CAPABILITIES_V5_OUT_VFIFO_STUFFING_NUM_CP_BUFFERS_LEN 2
+/* Entry count in the MAC stats array, including the final GENERATION_END
+ * entry. For MAC stats DMA, drivers should allocate a buffer large enough to
+ * hold at least this many 64-bit stats values, if they wish to receive all
+ * available stats. If the buffer is shorter than MAC_STATS_NUM_STATS * 8, the
+ * stats array returned will be truncated.
+ */
+#define       MC_CMD_GET_CAPABILITIES_V5_OUT_MAC_STATS_NUM_STATS_OFST 76
+#define       MC_CMD_GET_CAPABILITIES_V5_OUT_MAC_STATS_NUM_STATS_LEN 2
+/* Maximum supported value for MC_CMD_FILTER_OP_V3/MATCH_MARK_VALUE. This field
+ * will only be non-zero if MC_CMD_GET_CAPABILITIES/FILTER_ACTION_MARK is set.
+ */
+#define       MC_CMD_GET_CAPABILITIES_V5_OUT_FILTER_ACTION_MARK_MAX_OFST 80
+#define       MC_CMD_GET_CAPABILITIES_V5_OUT_FILTER_ACTION_MARK_MAX_LEN 4
+
+/* MC_CMD_GET_CAPABILITIES_V6_OUT msgresponse */
+#define    MC_CMD_GET_CAPABILITIES_V6_OUT_LEN 148
+/* First word of flags. */
+#define       MC_CMD_GET_CAPABILITIES_V6_OUT_FLAGS1_OFST 0
+#define       MC_CMD_GET_CAPABILITIES_V6_OUT_FLAGS1_LEN 4
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_VPORT_RECONFIGURE_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_VPORT_RECONFIGURE_LBN 3
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_VPORT_RECONFIGURE_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_TX_STRIPING_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_TX_STRIPING_LBN 4
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_TX_STRIPING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_VADAPTOR_QUERY_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_VADAPTOR_QUERY_LBN 5
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_VADAPTOR_QUERY_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_EVB_PORT_VLAN_RESTRICT_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_EVB_PORT_VLAN_RESTRICT_LBN 6
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_EVB_PORT_VLAN_RESTRICT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_DRV_ATTACH_PREBOOT_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_DRV_ATTACH_PREBOOT_LBN 7
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_DRV_ATTACH_PREBOOT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_RX_FORCE_EVENT_MERGING_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_RX_FORCE_EVENT_MERGING_LBN 8
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_RX_FORCE_EVENT_MERGING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_SET_MAC_ENHANCED_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_SET_MAC_ENHANCED_LBN 9
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_SET_MAC_ENHANCED_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_UNKNOWN_UCAST_DST_FILTER_ALWAYS_MULTI_RECIPIENT_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_UNKNOWN_UCAST_DST_FILTER_ALWAYS_MULTI_RECIPIENT_LBN 10
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_UNKNOWN_UCAST_DST_FILTER_ALWAYS_MULTI_RECIPIENT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_VADAPTOR_PERMIT_SET_MAC_WHEN_FILTERS_INSTALLED_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_VADAPTOR_PERMIT_SET_MAC_WHEN_FILTERS_INSTALLED_LBN 11
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_VADAPTOR_PERMIT_SET_MAC_WHEN_FILTERS_INSTALLED_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_TX_MAC_SECURITY_FILTERING_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_TX_MAC_SECURITY_FILTERING_LBN 12
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_TX_MAC_SECURITY_FILTERING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_ADDITIONAL_RSS_MODES_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_ADDITIONAL_RSS_MODES_LBN 13
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_ADDITIONAL_RSS_MODES_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_QBB_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_QBB_LBN 14
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_QBB_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_RX_PACKED_STREAM_VAR_BUFFERS_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_RX_PACKED_STREAM_VAR_BUFFERS_LBN 15
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_RX_PACKED_STREAM_VAR_BUFFERS_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_RX_RSS_LIMITED_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_RX_RSS_LIMITED_LBN 16
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_RX_RSS_LIMITED_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_RX_PACKED_STREAM_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_RX_PACKED_STREAM_LBN 17
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_RX_PACKED_STREAM_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_RX_INCLUDE_FCS_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_RX_INCLUDE_FCS_LBN 18
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_RX_INCLUDE_FCS_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_TX_VLAN_INSERTION_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_TX_VLAN_INSERTION_LBN 19
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_TX_VLAN_INSERTION_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_RX_VLAN_STRIPPING_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_RX_VLAN_STRIPPING_LBN 20
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_RX_VLAN_STRIPPING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_TX_TSO_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_TX_TSO_LBN 21
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_TX_TSO_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_RX_PREFIX_LEN_0_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_RX_PREFIX_LEN_0_LBN 22
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_RX_PREFIX_LEN_0_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_RX_PREFIX_LEN_14_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_RX_PREFIX_LEN_14_LBN 23
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_RX_PREFIX_LEN_14_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_RX_TIMESTAMP_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_RX_TIMESTAMP_LBN 24
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_RX_TIMESTAMP_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_RX_BATCHING_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_RX_BATCHING_LBN 25
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_RX_BATCHING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_MCAST_FILTER_CHAINING_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_MCAST_FILTER_CHAINING_LBN 26
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_MCAST_FILTER_CHAINING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_PM_AND_RXDP_COUNTERS_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_PM_AND_RXDP_COUNTERS_LBN 27
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_PM_AND_RXDP_COUNTERS_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_RX_DISABLE_SCATTER_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_RX_DISABLE_SCATTER_LBN 28
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_RX_DISABLE_SCATTER_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_TX_MCAST_UDP_LOOPBACK_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_TX_MCAST_UDP_LOOPBACK_LBN 29
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_TX_MCAST_UDP_LOOPBACK_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_EVB_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_EVB_LBN 30
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_EVB_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_VXLAN_NVGRE_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_VXLAN_NVGRE_LBN 31
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_VXLAN_NVGRE_WIDTH 1
+/* RxDPCPU firmware id. */
+#define       MC_CMD_GET_CAPABILITIES_V6_OUT_RX_DPCPU_FW_ID_OFST 4
+#define       MC_CMD_GET_CAPABILITIES_V6_OUT_RX_DPCPU_FW_ID_LEN 2
+/* enum: Standard RXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_RXDP 0x0
+/* enum: Low latency RXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_RXDP_LOW_LATENCY 0x1
+/* enum: Packed stream RXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_RXDP_PACKED_STREAM 0x2
+/* enum: Rules engine RXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_RXDP_RULES_ENGINE 0x5
+/* enum: DPDK RXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_RXDP_DPDK 0x6
+/* enum: BIST RXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_RXDP_BIST 0x10a
+/* enum: RXDP Test firmware image 1 */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_RXDP_TEST_FW_TO_MC_CUT_THROUGH 0x101
+/* enum: RXDP Test firmware image 2 */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_RXDP_TEST_FW_TO_MC_STORE_FORWARD 0x102
+/* enum: RXDP Test firmware image 3 */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_RXDP_TEST_FW_TO_MC_STORE_FORWARD_FIRST 0x103
+/* enum: RXDP Test firmware image 4 */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_RXDP_TEST_EVERY_EVENT_BATCHABLE 0x104
+/* enum: RXDP Test firmware image 5 */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_RXDP_TEST_BACKPRESSURE 0x105
+/* enum: RXDP Test firmware image 6 */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_RXDP_TEST_FW_PACKET_EDITS 0x106
+/* enum: RXDP Test firmware image 7 */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_RXDP_TEST_FW_RX_HDR_SPLIT 0x107
+/* enum: RXDP Test firmware image 8 */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_RXDP_TEST_FW_DISABLE_DL 0x108
+/* enum: RXDP Test firmware image 9 */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_RXDP_TEST_FW_DOORBELL_DELAY 0x10b
+/* enum: RXDP Test firmware image 10 */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_RXDP_TEST_FW_SLOW 0x10c
+/* TxDPCPU firmware id. */
+#define       MC_CMD_GET_CAPABILITIES_V6_OUT_TX_DPCPU_FW_ID_OFST 6
+#define       MC_CMD_GET_CAPABILITIES_V6_OUT_TX_DPCPU_FW_ID_LEN 2
+/* enum: Standard TXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_TXDP 0x0
+/* enum: Low latency TXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_TXDP_LOW_LATENCY 0x1
+/* enum: High packet rate TXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_TXDP_HIGH_PACKET_RATE 0x3
+/* enum: Rules engine TXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_TXDP_RULES_ENGINE 0x5
+/* enum: DPDK TXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_TXDP_DPDK 0x6
+/* enum: BIST TXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_TXDP_BIST 0x12d
+/* enum: TXDP Test firmware image 1 */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_TXDP_TEST_FW_TSO_EDIT 0x101
+/* enum: TXDP Test firmware image 2 */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_TXDP_TEST_FW_PACKET_EDITS 0x102
+/* enum: TXDP CSR bus test firmware */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_TXDP_TEST_FW_CSR 0x103
+#define       MC_CMD_GET_CAPABILITIES_V6_OUT_RXPD_FW_VERSION_OFST 8
+#define       MC_CMD_GET_CAPABILITIES_V6_OUT_RXPD_FW_VERSION_LEN 2
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_RXPD_FW_VERSION_REV_OFST 8
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_RXPD_FW_VERSION_REV_LBN 0
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_RXPD_FW_VERSION_REV_WIDTH 12
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_RXPD_FW_VERSION_TYPE_OFST 8
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_RXPD_FW_VERSION_TYPE_LBN 12
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_RXPD_FW_VERSION_TYPE_WIDTH 4
+/* enum: reserved value - do not use (may indicate alternative interpretation
+ * of REV field in future)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_RXPD_FW_TYPE_RESERVED 0x0
+/* enum: Trivial RX PD firmware for early Huntington development (Huntington
+ * development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_RXPD_FW_TYPE_FIRST_PKT 0x1
+/* enum: RX PD firmware for telemetry prototyping (Medford2 development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_RXPD_FW_TYPE_TESTFW_TELEMETRY 0x1
+/* enum: RX PD firmware with approximately Siena-compatible behaviour
+ * (Huntington development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_RXPD_FW_TYPE_SIENA_COMPAT 0x2
+/* enum: Full featured RX PD production firmware */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_RXPD_FW_TYPE_FULL_FEATURED 0x3
+/* enum: (deprecated original name for the FULL_FEATURED variant) */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_RXPD_FW_TYPE_VSWITCH 0x3
+/* enum: siena_compat variant RX PD firmware using PM rather than MAC
+ * (Huntington development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_RXPD_FW_TYPE_SIENA_COMPAT_PM 0x4
+/* enum: Low latency RX PD production firmware */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_RXPD_FW_TYPE_LOW_LATENCY 0x5
+/* enum: Packed stream RX PD production firmware */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_RXPD_FW_TYPE_PACKED_STREAM 0x6
+/* enum: RX PD firmware handling layer 2 only for high packet rate performance
+ * tests (Medford development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_RXPD_FW_TYPE_LAYER2_PERF 0x7
+/* enum: Rules engine RX PD production firmware */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_RXPD_FW_TYPE_RULES_ENGINE 0x8
+/* enum: Custom firmware variant (see SF-119495-PD and bug69716) */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_RXPD_FW_TYPE_L3XUDP 0x9
+/* enum: DPDK RX PD production firmware */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_RXPD_FW_TYPE_DPDK 0xa
+/* enum: RX PD firmware for GUE parsing prototype (Medford development only) */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_RXPD_FW_TYPE_TESTFW_GUE_PROTOTYPE 0xe
+/* enum: RX PD firmware parsing but not filtering network overlay tunnel
+ * encapsulations (Medford development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_RXPD_FW_TYPE_TESTFW_ENCAP_PARSING_ONLY 0xf
+#define       MC_CMD_GET_CAPABILITIES_V6_OUT_TXPD_FW_VERSION_OFST 10
+#define       MC_CMD_GET_CAPABILITIES_V6_OUT_TXPD_FW_VERSION_LEN 2
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_TXPD_FW_VERSION_REV_OFST 10
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_TXPD_FW_VERSION_REV_LBN 0
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_TXPD_FW_VERSION_REV_WIDTH 12
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_TXPD_FW_VERSION_TYPE_OFST 10
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_TXPD_FW_VERSION_TYPE_LBN 12
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_TXPD_FW_VERSION_TYPE_WIDTH 4
+/* enum: reserved value - do not use (may indicate alternative interpretation
+ * of REV field in future)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_TXPD_FW_TYPE_RESERVED 0x0
+/* enum: Trivial TX PD firmware for early Huntington development (Huntington
+ * development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_TXPD_FW_TYPE_FIRST_PKT 0x1
+/* enum: TX PD firmware for telemetry prototyping (Medford2 development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_TXPD_FW_TYPE_TESTFW_TELEMETRY 0x1
+/* enum: TX PD firmware with approximately Siena-compatible behaviour
+ * (Huntington development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_TXPD_FW_TYPE_SIENA_COMPAT 0x2
+/* enum: Full featured TX PD production firmware */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_TXPD_FW_TYPE_FULL_FEATURED 0x3
+/* enum: (deprecated original name for the FULL_FEATURED variant) */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_TXPD_FW_TYPE_VSWITCH 0x3
+/* enum: siena_compat variant TX PD firmware using PM rather than MAC
+ * (Huntington development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_TXPD_FW_TYPE_SIENA_COMPAT_PM 0x4
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_TXPD_FW_TYPE_LOW_LATENCY 0x5 /* enum */
+/* enum: TX PD firmware handling layer 2 only for high packet rate performance
+ * tests (Medford development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_TXPD_FW_TYPE_LAYER2_PERF 0x7
+/* enum: Rules engine TX PD production firmware */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_TXPD_FW_TYPE_RULES_ENGINE 0x8
+/* enum: Custom firmware variant (see SF-119495-PD and bug69716) */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_TXPD_FW_TYPE_L3XUDP 0x9
+/* enum: DPDK TX PD production firmware */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_TXPD_FW_TYPE_DPDK 0xa
+/* enum: RX PD firmware for GUE parsing prototype (Medford development only) */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_TXPD_FW_TYPE_TESTFW_GUE_PROTOTYPE 0xe
+/* Hardware capabilities of NIC */
+#define       MC_CMD_GET_CAPABILITIES_V6_OUT_HW_CAPABILITIES_OFST 12
+#define       MC_CMD_GET_CAPABILITIES_V6_OUT_HW_CAPABILITIES_LEN 4
+/* Licensed capabilities */
+#define       MC_CMD_GET_CAPABILITIES_V6_OUT_LICENSE_CAPABILITIES_OFST 16
+#define       MC_CMD_GET_CAPABILITIES_V6_OUT_LICENSE_CAPABILITIES_LEN 4
+/* Second word of flags. Not present on older firmware (check the length). */
+#define       MC_CMD_GET_CAPABILITIES_V6_OUT_FLAGS2_OFST 20
+#define       MC_CMD_GET_CAPABILITIES_V6_OUT_FLAGS2_LEN 4
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_TX_TSO_V2_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_TX_TSO_V2_LBN 0
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_TX_TSO_V2_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_TX_TSO_V2_ENCAP_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_TX_TSO_V2_ENCAP_LBN 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_TX_TSO_V2_ENCAP_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_EVQ_TIMER_CTRL_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_EVQ_TIMER_CTRL_LBN 2
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_EVQ_TIMER_CTRL_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_EVENT_CUT_THROUGH_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_EVENT_CUT_THROUGH_LBN 3
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_EVENT_CUT_THROUGH_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_RX_CUT_THROUGH_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_RX_CUT_THROUGH_LBN 4
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_RX_CUT_THROUGH_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_TX_VFIFO_ULL_MODE_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_TX_VFIFO_ULL_MODE_LBN 5
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_TX_VFIFO_ULL_MODE_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_MAC_STATS_40G_TX_SIZE_BINS_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_MAC_STATS_40G_TX_SIZE_BINS_LBN 6
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_MAC_STATS_40G_TX_SIZE_BINS_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_INIT_EVQ_TYPE_SUPPORTED_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_INIT_EVQ_TYPE_SUPPORTED_LBN 7
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_INIT_EVQ_TYPE_SUPPORTED_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_INIT_EVQ_V2_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_INIT_EVQ_V2_LBN 7
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_INIT_EVQ_V2_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_TX_MAC_TIMESTAMPING_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_TX_MAC_TIMESTAMPING_LBN 8
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_TX_MAC_TIMESTAMPING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_TX_TIMESTAMP_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_TX_TIMESTAMP_LBN 9
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_TX_TIMESTAMP_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_RX_SNIFF_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_RX_SNIFF_LBN 10
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_RX_SNIFF_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_TX_SNIFF_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_TX_SNIFF_LBN 11
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_TX_SNIFF_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_NVRAM_UPDATE_REPORT_VERIFY_RESULT_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_NVRAM_UPDATE_REPORT_VERIFY_RESULT_LBN 12
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_NVRAM_UPDATE_REPORT_VERIFY_RESULT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_MCDI_BACKGROUND_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_MCDI_BACKGROUND_LBN 13
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_MCDI_BACKGROUND_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_MCDI_DB_RETURN_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_MCDI_DB_RETURN_LBN 14
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_MCDI_DB_RETURN_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_CTPIO_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_CTPIO_LBN 15
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_CTPIO_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_TSA_SUPPORT_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_TSA_SUPPORT_LBN 16
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_TSA_SUPPORT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_TSA_BOUND_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_TSA_BOUND_LBN 17
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_TSA_BOUND_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_SF_ADAPTER_AUTHENTICATION_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_SF_ADAPTER_AUTHENTICATION_LBN 18
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_SF_ADAPTER_AUTHENTICATION_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_FILTER_ACTION_FLAG_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_FILTER_ACTION_FLAG_LBN 19
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_FILTER_ACTION_FLAG_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_FILTER_ACTION_MARK_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_FILTER_ACTION_MARK_LBN 20
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_FILTER_ACTION_MARK_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_EQUAL_STRIDE_SUPER_BUFFER_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_EQUAL_STRIDE_SUPER_BUFFER_LBN 21
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_EQUAL_STRIDE_SUPER_BUFFER_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_EQUAL_STRIDE_PACKED_STREAM_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_EQUAL_STRIDE_PACKED_STREAM_LBN 21
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_EQUAL_STRIDE_PACKED_STREAM_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_L3XUDP_SUPPORT_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_L3XUDP_SUPPORT_LBN 22
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_L3XUDP_SUPPORT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_FW_SUBVARIANT_NO_TX_CSUM_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_FW_SUBVARIANT_NO_TX_CSUM_LBN 23
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_FW_SUBVARIANT_NO_TX_CSUM_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_VI_SPREADING_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_VI_SPREADING_LBN 24
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_VI_SPREADING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_RXDP_HLB_IDLE_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_RXDP_HLB_IDLE_LBN 25
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_RXDP_HLB_IDLE_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_INIT_RXQ_NO_CONT_EV_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_INIT_RXQ_NO_CONT_EV_LBN 26
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_INIT_RXQ_NO_CONT_EV_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_INIT_RXQ_WITH_BUFFER_SIZE_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_INIT_RXQ_WITH_BUFFER_SIZE_LBN 27
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_INIT_RXQ_WITH_BUFFER_SIZE_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_BUNDLE_UPDATE_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_BUNDLE_UPDATE_LBN 28
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_BUNDLE_UPDATE_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_TX_TSO_V3_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_TX_TSO_V3_LBN 29
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_TX_TSO_V3_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_DYNAMIC_SENSORS_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_DYNAMIC_SENSORS_LBN 30
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_DYNAMIC_SENSORS_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_NVRAM_UPDATE_POLL_VERIFY_RESULT_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_NVRAM_UPDATE_POLL_VERIFY_RESULT_LBN 31
+#define        MC_CMD_GET_CAPABILITIES_V6_OUT_NVRAM_UPDATE_POLL_VERIFY_RESULT_WIDTH 1
+/* Number of FATSOv2 contexts per datapath supported by this NIC (when
+ * TX_TSO_V2 == 1). Not present on older firmware (check the length).
+ */
+#define       MC_CMD_GET_CAPABILITIES_V6_OUT_TX_TSO_V2_N_CONTEXTS_OFST 24
+#define       MC_CMD_GET_CAPABILITIES_V6_OUT_TX_TSO_V2_N_CONTEXTS_LEN 2
+/* One byte per PF containing the number of the external port assigned to this
+ * PF, indexed by PF number. Special values indicate that a PF is either not
+ * present or not assigned.
+ */
+#define       MC_CMD_GET_CAPABILITIES_V6_OUT_PFS_TO_PORTS_ASSIGNMENT_OFST 26
+#define       MC_CMD_GET_CAPABILITIES_V6_OUT_PFS_TO_PORTS_ASSIGNMENT_LEN 1
+#define       MC_CMD_GET_CAPABILITIES_V6_OUT_PFS_TO_PORTS_ASSIGNMENT_NUM 16
+/* enum: The caller is not permitted to access information on this PF. */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_ACCESS_NOT_PERMITTED 0xff
+/* enum: PF does not exist. */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_PF_NOT_PRESENT 0xfe
+/* enum: PF does exist but is not assigned to any external port. */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_PF_NOT_ASSIGNED 0xfd
+/* enum: This value indicates that PF is assigned, but it cannot be expressed
+ * in this field. It is intended for a possible future situation where a more
+ * complex scheme of PFs to ports mapping is being used. The future driver
+ * should look for a new field supporting the new scheme. The current/old
+ * driver should treat this value as PF_NOT_ASSIGNED.
+ */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_INCOMPATIBLE_ASSIGNMENT 0xfc
+/* One byte per PF containing the number of its VFs, indexed by PF number. A
+ * special value indicates that a PF is not present.
+ */
+#define       MC_CMD_GET_CAPABILITIES_V6_OUT_NUM_VFS_PER_PF_OFST 42
+#define       MC_CMD_GET_CAPABILITIES_V6_OUT_NUM_VFS_PER_PF_LEN 1
+#define       MC_CMD_GET_CAPABILITIES_V6_OUT_NUM_VFS_PER_PF_NUM 16
+/* enum: The caller is not permitted to access information on this PF. */
+/*               MC_CMD_GET_CAPABILITIES_V6_OUT_ACCESS_NOT_PERMITTED 0xff */
+/* enum: PF does not exist. */
+/*               MC_CMD_GET_CAPABILITIES_V6_OUT_PF_NOT_PRESENT 0xfe */
+/* Number of VIs available for each external port */
+#define       MC_CMD_GET_CAPABILITIES_V6_OUT_NUM_VIS_PER_PORT_OFST 58
+#define       MC_CMD_GET_CAPABILITIES_V6_OUT_NUM_VIS_PER_PORT_LEN 2
+#define       MC_CMD_GET_CAPABILITIES_V6_OUT_NUM_VIS_PER_PORT_NUM 4
+/* Size of RX descriptor cache expressed as binary logarithm The actual size
+ * equals (2 ^ RX_DESC_CACHE_SIZE)
+ */
+#define       MC_CMD_GET_CAPABILITIES_V6_OUT_RX_DESC_CACHE_SIZE_OFST 66
+#define       MC_CMD_GET_CAPABILITIES_V6_OUT_RX_DESC_CACHE_SIZE_LEN 1
+/* Size of TX descriptor cache expressed as binary logarithm The actual size
+ * equals (2 ^ TX_DESC_CACHE_SIZE)
+ */
+#define       MC_CMD_GET_CAPABILITIES_V6_OUT_TX_DESC_CACHE_SIZE_OFST 67
+#define       MC_CMD_GET_CAPABILITIES_V6_OUT_TX_DESC_CACHE_SIZE_LEN 1
+/* Total number of available PIO buffers */
+#define       MC_CMD_GET_CAPABILITIES_V6_OUT_NUM_PIO_BUFFS_OFST 68
+#define       MC_CMD_GET_CAPABILITIES_V6_OUT_NUM_PIO_BUFFS_LEN 2
+/* Size of a single PIO buffer */
+#define       MC_CMD_GET_CAPABILITIES_V6_OUT_SIZE_PIO_BUFF_OFST 70
+#define       MC_CMD_GET_CAPABILITIES_V6_OUT_SIZE_PIO_BUFF_LEN 2
+/* On chips later than Medford the amount of address space assigned to each VI
+ * is configurable. This is a global setting that the driver must query to
+ * discover the VI to address mapping. Cut-through PIO (CTPIO) is not available
+ * with 8k VI windows.
+ */
+#define       MC_CMD_GET_CAPABILITIES_V6_OUT_VI_WINDOW_MODE_OFST 72
+#define       MC_CMD_GET_CAPABILITIES_V6_OUT_VI_WINDOW_MODE_LEN 1
+/* enum: Each VI occupies 8k as on Huntington and Medford. PIO is at offset 4k.
+ * CTPIO is not mapped.
+ */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_VI_WINDOW_MODE_8K 0x0
+/* enum: Each VI occupies 16k. PIO is at offset 4k. CTPIO is at offset 12k. */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_VI_WINDOW_MODE_16K 0x1
+/* enum: Each VI occupies 64k. PIO is at offset 4k. CTPIO is at offset 12k. */
+#define          MC_CMD_GET_CAPABILITIES_V6_OUT_VI_WINDOW_MODE_64K 0x2
+/* Number of vFIFOs per adapter that can be used for VFIFO Stuffing
+ * (SF-115995-SW) in the present configuration of firmware and port mode.
+ */
+#define       MC_CMD_GET_CAPABILITIES_V6_OUT_VFIFO_STUFFING_NUM_VFIFOS_OFST 73
+#define       MC_CMD_GET_CAPABILITIES_V6_OUT_VFIFO_STUFFING_NUM_VFIFOS_LEN 1
+/* Number of buffers per adapter that can be used for VFIFO Stuffing
+ * (SF-115995-SW) in the present configuration of firmware and port mode.
+ */
+#define       MC_CMD_GET_CAPABILITIES_V6_OUT_VFIFO_STUFFING_NUM_CP_BUFFERS_OFST 74
+#define       MC_CMD_GET_CAPABILITIES_V6_OUT_VFIFO_STUFFING_NUM_CP_BUFFERS_LEN 2
+/* Entry count in the MAC stats array, including the final GENERATION_END
+ * entry. For MAC stats DMA, drivers should allocate a buffer large enough to
+ * hold at least this many 64-bit stats values, if they wish to receive all
+ * available stats. If the buffer is shorter than MAC_STATS_NUM_STATS * 8, the
+ * stats array returned will be truncated.
+ */
+#define       MC_CMD_GET_CAPABILITIES_V6_OUT_MAC_STATS_NUM_STATS_OFST 76
+#define       MC_CMD_GET_CAPABILITIES_V6_OUT_MAC_STATS_NUM_STATS_LEN 2
+/* Maximum supported value for MC_CMD_FILTER_OP_V3/MATCH_MARK_VALUE. This field
+ * will only be non-zero if MC_CMD_GET_CAPABILITIES/FILTER_ACTION_MARK is set.
+ */
+#define       MC_CMD_GET_CAPABILITIES_V6_OUT_FILTER_ACTION_MARK_MAX_OFST 80
+#define       MC_CMD_GET_CAPABILITIES_V6_OUT_FILTER_ACTION_MARK_MAX_LEN 4
+/* On devices where the INIT_RXQ_WITH_BUFFER_SIZE flag (in
+ * GET_CAPABILITIES_OUT_V2) is set, drivers have to specify a buffer size when
+ * they create an RX queue. Due to hardware limitations, only a small number of
+ * different buffer sizes may be available concurrently. Nonzero entries in
+ * this array are the sizes of buffers which the system guarantees will be
+ * available for use. If the list is empty, there are no limitations on
+ * concurrent buffer sizes.
+ */
+#define       MC_CMD_GET_CAPABILITIES_V6_OUT_GUARANTEED_RX_BUFFER_SIZES_OFST 84
+#define       MC_CMD_GET_CAPABILITIES_V6_OUT_GUARANTEED_RX_BUFFER_SIZES_LEN 4
+#define       MC_CMD_GET_CAPABILITIES_V6_OUT_GUARANTEED_RX_BUFFER_SIZES_NUM 16
+
+/* MC_CMD_GET_CAPABILITIES_V7_OUT msgresponse */
+#define    MC_CMD_GET_CAPABILITIES_V7_OUT_LEN 152
+/* First word of flags. */
+#define       MC_CMD_GET_CAPABILITIES_V7_OUT_FLAGS1_OFST 0
+#define       MC_CMD_GET_CAPABILITIES_V7_OUT_FLAGS1_LEN 4
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_VPORT_RECONFIGURE_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_VPORT_RECONFIGURE_LBN 3
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_VPORT_RECONFIGURE_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_TX_STRIPING_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_TX_STRIPING_LBN 4
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_TX_STRIPING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_VADAPTOR_QUERY_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_VADAPTOR_QUERY_LBN 5
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_VADAPTOR_QUERY_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_EVB_PORT_VLAN_RESTRICT_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_EVB_PORT_VLAN_RESTRICT_LBN 6
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_EVB_PORT_VLAN_RESTRICT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_DRV_ATTACH_PREBOOT_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_DRV_ATTACH_PREBOOT_LBN 7
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_DRV_ATTACH_PREBOOT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RX_FORCE_EVENT_MERGING_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RX_FORCE_EVENT_MERGING_LBN 8
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RX_FORCE_EVENT_MERGING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_SET_MAC_ENHANCED_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_SET_MAC_ENHANCED_LBN 9
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_SET_MAC_ENHANCED_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_UNKNOWN_UCAST_DST_FILTER_ALWAYS_MULTI_RECIPIENT_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_UNKNOWN_UCAST_DST_FILTER_ALWAYS_MULTI_RECIPIENT_LBN 10
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_UNKNOWN_UCAST_DST_FILTER_ALWAYS_MULTI_RECIPIENT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_VADAPTOR_PERMIT_SET_MAC_WHEN_FILTERS_INSTALLED_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_VADAPTOR_PERMIT_SET_MAC_WHEN_FILTERS_INSTALLED_LBN 11
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_VADAPTOR_PERMIT_SET_MAC_WHEN_FILTERS_INSTALLED_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_TX_MAC_SECURITY_FILTERING_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_TX_MAC_SECURITY_FILTERING_LBN 12
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_TX_MAC_SECURITY_FILTERING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_ADDITIONAL_RSS_MODES_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_ADDITIONAL_RSS_MODES_LBN 13
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_ADDITIONAL_RSS_MODES_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_QBB_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_QBB_LBN 14
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_QBB_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RX_PACKED_STREAM_VAR_BUFFERS_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RX_PACKED_STREAM_VAR_BUFFERS_LBN 15
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RX_PACKED_STREAM_VAR_BUFFERS_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RX_RSS_LIMITED_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RX_RSS_LIMITED_LBN 16
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RX_RSS_LIMITED_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RX_PACKED_STREAM_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RX_PACKED_STREAM_LBN 17
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RX_PACKED_STREAM_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RX_INCLUDE_FCS_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RX_INCLUDE_FCS_LBN 18
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RX_INCLUDE_FCS_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_TX_VLAN_INSERTION_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_TX_VLAN_INSERTION_LBN 19
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_TX_VLAN_INSERTION_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RX_VLAN_STRIPPING_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RX_VLAN_STRIPPING_LBN 20
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RX_VLAN_STRIPPING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_TX_TSO_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_TX_TSO_LBN 21
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_TX_TSO_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RX_PREFIX_LEN_0_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RX_PREFIX_LEN_0_LBN 22
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RX_PREFIX_LEN_0_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RX_PREFIX_LEN_14_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RX_PREFIX_LEN_14_LBN 23
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RX_PREFIX_LEN_14_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RX_TIMESTAMP_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RX_TIMESTAMP_LBN 24
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RX_TIMESTAMP_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RX_BATCHING_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RX_BATCHING_LBN 25
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RX_BATCHING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_MCAST_FILTER_CHAINING_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_MCAST_FILTER_CHAINING_LBN 26
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_MCAST_FILTER_CHAINING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_PM_AND_RXDP_COUNTERS_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_PM_AND_RXDP_COUNTERS_LBN 27
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_PM_AND_RXDP_COUNTERS_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RX_DISABLE_SCATTER_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RX_DISABLE_SCATTER_LBN 28
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RX_DISABLE_SCATTER_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_TX_MCAST_UDP_LOOPBACK_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_TX_MCAST_UDP_LOOPBACK_LBN 29
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_TX_MCAST_UDP_LOOPBACK_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_EVB_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_EVB_LBN 30
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_EVB_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_VXLAN_NVGRE_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_VXLAN_NVGRE_LBN 31
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_VXLAN_NVGRE_WIDTH 1
+/* RxDPCPU firmware id. */
+#define       MC_CMD_GET_CAPABILITIES_V7_OUT_RX_DPCPU_FW_ID_OFST 4
+#define       MC_CMD_GET_CAPABILITIES_V7_OUT_RX_DPCPU_FW_ID_LEN 2
+/* enum: Standard RXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_RXDP 0x0
+/* enum: Low latency RXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_RXDP_LOW_LATENCY 0x1
+/* enum: Packed stream RXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_RXDP_PACKED_STREAM 0x2
+/* enum: Rules engine RXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_RXDP_RULES_ENGINE 0x5
+/* enum: DPDK RXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_RXDP_DPDK 0x6
+/* enum: BIST RXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_RXDP_BIST 0x10a
+/* enum: RXDP Test firmware image 1 */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_RXDP_TEST_FW_TO_MC_CUT_THROUGH 0x101
+/* enum: RXDP Test firmware image 2 */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_RXDP_TEST_FW_TO_MC_STORE_FORWARD 0x102
+/* enum: RXDP Test firmware image 3 */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_RXDP_TEST_FW_TO_MC_STORE_FORWARD_FIRST 0x103
+/* enum: RXDP Test firmware image 4 */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_RXDP_TEST_EVERY_EVENT_BATCHABLE 0x104
+/* enum: RXDP Test firmware image 5 */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_RXDP_TEST_BACKPRESSURE 0x105
+/* enum: RXDP Test firmware image 6 */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_RXDP_TEST_FW_PACKET_EDITS 0x106
+/* enum: RXDP Test firmware image 7 */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_RXDP_TEST_FW_RX_HDR_SPLIT 0x107
+/* enum: RXDP Test firmware image 8 */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_RXDP_TEST_FW_DISABLE_DL 0x108
+/* enum: RXDP Test firmware image 9 */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_RXDP_TEST_FW_DOORBELL_DELAY 0x10b
+/* enum: RXDP Test firmware image 10 */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_RXDP_TEST_FW_SLOW 0x10c
+/* TxDPCPU firmware id. */
+#define       MC_CMD_GET_CAPABILITIES_V7_OUT_TX_DPCPU_FW_ID_OFST 6
+#define       MC_CMD_GET_CAPABILITIES_V7_OUT_TX_DPCPU_FW_ID_LEN 2
+/* enum: Standard TXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_TXDP 0x0
+/* enum: Low latency TXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_TXDP_LOW_LATENCY 0x1
+/* enum: High packet rate TXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_TXDP_HIGH_PACKET_RATE 0x3
+/* enum: Rules engine TXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_TXDP_RULES_ENGINE 0x5
+/* enum: DPDK TXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_TXDP_DPDK 0x6
+/* enum: BIST TXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_TXDP_BIST 0x12d
+/* enum: TXDP Test firmware image 1 */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_TXDP_TEST_FW_TSO_EDIT 0x101
+/* enum: TXDP Test firmware image 2 */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_TXDP_TEST_FW_PACKET_EDITS 0x102
+/* enum: TXDP CSR bus test firmware */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_TXDP_TEST_FW_CSR 0x103
+#define       MC_CMD_GET_CAPABILITIES_V7_OUT_RXPD_FW_VERSION_OFST 8
+#define       MC_CMD_GET_CAPABILITIES_V7_OUT_RXPD_FW_VERSION_LEN 2
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RXPD_FW_VERSION_REV_OFST 8
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RXPD_FW_VERSION_REV_LBN 0
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RXPD_FW_VERSION_REV_WIDTH 12
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RXPD_FW_VERSION_TYPE_OFST 8
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RXPD_FW_VERSION_TYPE_LBN 12
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RXPD_FW_VERSION_TYPE_WIDTH 4
+/* enum: reserved value - do not use (may indicate alternative interpretation
+ * of REV field in future)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_RXPD_FW_TYPE_RESERVED 0x0
+/* enum: Trivial RX PD firmware for early Huntington development (Huntington
+ * development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_RXPD_FW_TYPE_FIRST_PKT 0x1
+/* enum: RX PD firmware for telemetry prototyping (Medford2 development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_RXPD_FW_TYPE_TESTFW_TELEMETRY 0x1
+/* enum: RX PD firmware with approximately Siena-compatible behaviour
+ * (Huntington development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_RXPD_FW_TYPE_SIENA_COMPAT 0x2
+/* enum: Full featured RX PD production firmware */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_RXPD_FW_TYPE_FULL_FEATURED 0x3
+/* enum: (deprecated original name for the FULL_FEATURED variant) */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_RXPD_FW_TYPE_VSWITCH 0x3
+/* enum: siena_compat variant RX PD firmware using PM rather than MAC
+ * (Huntington development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_RXPD_FW_TYPE_SIENA_COMPAT_PM 0x4
+/* enum: Low latency RX PD production firmware */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_RXPD_FW_TYPE_LOW_LATENCY 0x5
+/* enum: Packed stream RX PD production firmware */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_RXPD_FW_TYPE_PACKED_STREAM 0x6
+/* enum: RX PD firmware handling layer 2 only for high packet rate performance
+ * tests (Medford development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_RXPD_FW_TYPE_LAYER2_PERF 0x7
+/* enum: Rules engine RX PD production firmware */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_RXPD_FW_TYPE_RULES_ENGINE 0x8
+/* enum: Custom firmware variant (see SF-119495-PD and bug69716) */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_RXPD_FW_TYPE_L3XUDP 0x9
+/* enum: DPDK RX PD production firmware */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_RXPD_FW_TYPE_DPDK 0xa
+/* enum: RX PD firmware for GUE parsing prototype (Medford development only) */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_RXPD_FW_TYPE_TESTFW_GUE_PROTOTYPE 0xe
+/* enum: RX PD firmware parsing but not filtering network overlay tunnel
+ * encapsulations (Medford development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_RXPD_FW_TYPE_TESTFW_ENCAP_PARSING_ONLY 0xf
+#define       MC_CMD_GET_CAPABILITIES_V7_OUT_TXPD_FW_VERSION_OFST 10
+#define       MC_CMD_GET_CAPABILITIES_V7_OUT_TXPD_FW_VERSION_LEN 2
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_TXPD_FW_VERSION_REV_OFST 10
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_TXPD_FW_VERSION_REV_LBN 0
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_TXPD_FW_VERSION_REV_WIDTH 12
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_TXPD_FW_VERSION_TYPE_OFST 10
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_TXPD_FW_VERSION_TYPE_LBN 12
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_TXPD_FW_VERSION_TYPE_WIDTH 4
+/* enum: reserved value - do not use (may indicate alternative interpretation
+ * of REV field in future)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_TXPD_FW_TYPE_RESERVED 0x0
+/* enum: Trivial TX PD firmware for early Huntington development (Huntington
+ * development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_TXPD_FW_TYPE_FIRST_PKT 0x1
+/* enum: TX PD firmware for telemetry prototyping (Medford2 development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_TXPD_FW_TYPE_TESTFW_TELEMETRY 0x1
+/* enum: TX PD firmware with approximately Siena-compatible behaviour
+ * (Huntington development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_TXPD_FW_TYPE_SIENA_COMPAT 0x2
+/* enum: Full featured TX PD production firmware */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_TXPD_FW_TYPE_FULL_FEATURED 0x3
+/* enum: (deprecated original name for the FULL_FEATURED variant) */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_TXPD_FW_TYPE_VSWITCH 0x3
+/* enum: siena_compat variant TX PD firmware using PM rather than MAC
+ * (Huntington development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_TXPD_FW_TYPE_SIENA_COMPAT_PM 0x4
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_TXPD_FW_TYPE_LOW_LATENCY 0x5 /* enum */
+/* enum: TX PD firmware handling layer 2 only for high packet rate performance
+ * tests (Medford development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_TXPD_FW_TYPE_LAYER2_PERF 0x7
+/* enum: Rules engine TX PD production firmware */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_TXPD_FW_TYPE_RULES_ENGINE 0x8
+/* enum: Custom firmware variant (see SF-119495-PD and bug69716) */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_TXPD_FW_TYPE_L3XUDP 0x9
+/* enum: DPDK TX PD production firmware */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_TXPD_FW_TYPE_DPDK 0xa
+/* enum: RX PD firmware for GUE parsing prototype (Medford development only) */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_TXPD_FW_TYPE_TESTFW_GUE_PROTOTYPE 0xe
+/* Hardware capabilities of NIC */
+#define       MC_CMD_GET_CAPABILITIES_V7_OUT_HW_CAPABILITIES_OFST 12
+#define       MC_CMD_GET_CAPABILITIES_V7_OUT_HW_CAPABILITIES_LEN 4
+/* Licensed capabilities */
+#define       MC_CMD_GET_CAPABILITIES_V7_OUT_LICENSE_CAPABILITIES_OFST 16
+#define       MC_CMD_GET_CAPABILITIES_V7_OUT_LICENSE_CAPABILITIES_LEN 4
+/* Second word of flags. Not present on older firmware (check the length). */
+#define       MC_CMD_GET_CAPABILITIES_V7_OUT_FLAGS2_OFST 20
+#define       MC_CMD_GET_CAPABILITIES_V7_OUT_FLAGS2_LEN 4
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_TX_TSO_V2_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_TX_TSO_V2_LBN 0
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_TX_TSO_V2_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_TX_TSO_V2_ENCAP_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_TX_TSO_V2_ENCAP_LBN 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_TX_TSO_V2_ENCAP_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_EVQ_TIMER_CTRL_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_EVQ_TIMER_CTRL_LBN 2
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_EVQ_TIMER_CTRL_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_EVENT_CUT_THROUGH_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_EVENT_CUT_THROUGH_LBN 3
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_EVENT_CUT_THROUGH_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RX_CUT_THROUGH_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RX_CUT_THROUGH_LBN 4
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RX_CUT_THROUGH_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_TX_VFIFO_ULL_MODE_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_TX_VFIFO_ULL_MODE_LBN 5
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_TX_VFIFO_ULL_MODE_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_MAC_STATS_40G_TX_SIZE_BINS_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_MAC_STATS_40G_TX_SIZE_BINS_LBN 6
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_MAC_STATS_40G_TX_SIZE_BINS_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_INIT_EVQ_TYPE_SUPPORTED_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_INIT_EVQ_TYPE_SUPPORTED_LBN 7
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_INIT_EVQ_TYPE_SUPPORTED_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_INIT_EVQ_V2_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_INIT_EVQ_V2_LBN 7
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_INIT_EVQ_V2_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_TX_MAC_TIMESTAMPING_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_TX_MAC_TIMESTAMPING_LBN 8
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_TX_MAC_TIMESTAMPING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_TX_TIMESTAMP_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_TX_TIMESTAMP_LBN 9
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_TX_TIMESTAMP_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RX_SNIFF_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RX_SNIFF_LBN 10
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RX_SNIFF_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_TX_SNIFF_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_TX_SNIFF_LBN 11
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_TX_SNIFF_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_NVRAM_UPDATE_REPORT_VERIFY_RESULT_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_NVRAM_UPDATE_REPORT_VERIFY_RESULT_LBN 12
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_NVRAM_UPDATE_REPORT_VERIFY_RESULT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_MCDI_BACKGROUND_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_MCDI_BACKGROUND_LBN 13
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_MCDI_BACKGROUND_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_MCDI_DB_RETURN_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_MCDI_DB_RETURN_LBN 14
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_MCDI_DB_RETURN_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_CTPIO_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_CTPIO_LBN 15
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_CTPIO_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_TSA_SUPPORT_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_TSA_SUPPORT_LBN 16
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_TSA_SUPPORT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_TSA_BOUND_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_TSA_BOUND_LBN 17
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_TSA_BOUND_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_SF_ADAPTER_AUTHENTICATION_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_SF_ADAPTER_AUTHENTICATION_LBN 18
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_SF_ADAPTER_AUTHENTICATION_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_FILTER_ACTION_FLAG_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_FILTER_ACTION_FLAG_LBN 19
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_FILTER_ACTION_FLAG_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_FILTER_ACTION_MARK_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_FILTER_ACTION_MARK_LBN 20
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_FILTER_ACTION_MARK_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_EQUAL_STRIDE_SUPER_BUFFER_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_EQUAL_STRIDE_SUPER_BUFFER_LBN 21
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_EQUAL_STRIDE_SUPER_BUFFER_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_EQUAL_STRIDE_PACKED_STREAM_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_EQUAL_STRIDE_PACKED_STREAM_LBN 21
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_EQUAL_STRIDE_PACKED_STREAM_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_L3XUDP_SUPPORT_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_L3XUDP_SUPPORT_LBN 22
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_L3XUDP_SUPPORT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_FW_SUBVARIANT_NO_TX_CSUM_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_FW_SUBVARIANT_NO_TX_CSUM_LBN 23
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_FW_SUBVARIANT_NO_TX_CSUM_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_VI_SPREADING_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_VI_SPREADING_LBN 24
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_VI_SPREADING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RXDP_HLB_IDLE_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RXDP_HLB_IDLE_LBN 25
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RXDP_HLB_IDLE_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_INIT_RXQ_NO_CONT_EV_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_INIT_RXQ_NO_CONT_EV_LBN 26
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_INIT_RXQ_NO_CONT_EV_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_INIT_RXQ_WITH_BUFFER_SIZE_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_INIT_RXQ_WITH_BUFFER_SIZE_LBN 27
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_INIT_RXQ_WITH_BUFFER_SIZE_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_BUNDLE_UPDATE_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_BUNDLE_UPDATE_LBN 28
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_BUNDLE_UPDATE_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_TX_TSO_V3_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_TX_TSO_V3_LBN 29
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_TX_TSO_V3_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_DYNAMIC_SENSORS_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_DYNAMIC_SENSORS_LBN 30
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_DYNAMIC_SENSORS_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_NVRAM_UPDATE_POLL_VERIFY_RESULT_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_NVRAM_UPDATE_POLL_VERIFY_RESULT_LBN 31
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_NVRAM_UPDATE_POLL_VERIFY_RESULT_WIDTH 1
+/* Number of FATSOv2 contexts per datapath supported by this NIC (when
+ * TX_TSO_V2 == 1). Not present on older firmware (check the length).
+ */
+#define       MC_CMD_GET_CAPABILITIES_V7_OUT_TX_TSO_V2_N_CONTEXTS_OFST 24
+#define       MC_CMD_GET_CAPABILITIES_V7_OUT_TX_TSO_V2_N_CONTEXTS_LEN 2
+/* One byte per PF containing the number of the external port assigned to this
+ * PF, indexed by PF number. Special values indicate that a PF is either not
+ * present or not assigned.
+ */
+#define       MC_CMD_GET_CAPABILITIES_V7_OUT_PFS_TO_PORTS_ASSIGNMENT_OFST 26
+#define       MC_CMD_GET_CAPABILITIES_V7_OUT_PFS_TO_PORTS_ASSIGNMENT_LEN 1
+#define       MC_CMD_GET_CAPABILITIES_V7_OUT_PFS_TO_PORTS_ASSIGNMENT_NUM 16
+/* enum: The caller is not permitted to access information on this PF. */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_ACCESS_NOT_PERMITTED 0xff
+/* enum: PF does not exist. */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_PF_NOT_PRESENT 0xfe
+/* enum: PF does exist but is not assigned to any external port. */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_PF_NOT_ASSIGNED 0xfd
+/* enum: This value indicates that PF is assigned, but it cannot be expressed
+ * in this field. It is intended for a possible future situation where a more
+ * complex scheme of PFs to ports mapping is being used. The future driver
+ * should look for a new field supporting the new scheme. The current/old
+ * driver should treat this value as PF_NOT_ASSIGNED.
+ */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_INCOMPATIBLE_ASSIGNMENT 0xfc
+/* One byte per PF containing the number of its VFs, indexed by PF number. A
+ * special value indicates that a PF is not present.
+ */
+#define       MC_CMD_GET_CAPABILITIES_V7_OUT_NUM_VFS_PER_PF_OFST 42
+#define       MC_CMD_GET_CAPABILITIES_V7_OUT_NUM_VFS_PER_PF_LEN 1
+#define       MC_CMD_GET_CAPABILITIES_V7_OUT_NUM_VFS_PER_PF_NUM 16
+/* enum: The caller is not permitted to access information on this PF. */
+/*               MC_CMD_GET_CAPABILITIES_V7_OUT_ACCESS_NOT_PERMITTED 0xff */
+/* enum: PF does not exist. */
+/*               MC_CMD_GET_CAPABILITIES_V7_OUT_PF_NOT_PRESENT 0xfe */
+/* Number of VIs available for each external port */
+#define       MC_CMD_GET_CAPABILITIES_V7_OUT_NUM_VIS_PER_PORT_OFST 58
+#define       MC_CMD_GET_CAPABILITIES_V7_OUT_NUM_VIS_PER_PORT_LEN 2
+#define       MC_CMD_GET_CAPABILITIES_V7_OUT_NUM_VIS_PER_PORT_NUM 4
+/* Size of RX descriptor cache expressed as binary logarithm The actual size
+ * equals (2 ^ RX_DESC_CACHE_SIZE)
+ */
+#define       MC_CMD_GET_CAPABILITIES_V7_OUT_RX_DESC_CACHE_SIZE_OFST 66
+#define       MC_CMD_GET_CAPABILITIES_V7_OUT_RX_DESC_CACHE_SIZE_LEN 1
+/* Size of TX descriptor cache expressed as binary logarithm The actual size
+ * equals (2 ^ TX_DESC_CACHE_SIZE)
+ */
+#define       MC_CMD_GET_CAPABILITIES_V7_OUT_TX_DESC_CACHE_SIZE_OFST 67
+#define       MC_CMD_GET_CAPABILITIES_V7_OUT_TX_DESC_CACHE_SIZE_LEN 1
+/* Total number of available PIO buffers */
+#define       MC_CMD_GET_CAPABILITIES_V7_OUT_NUM_PIO_BUFFS_OFST 68
+#define       MC_CMD_GET_CAPABILITIES_V7_OUT_NUM_PIO_BUFFS_LEN 2
+/* Size of a single PIO buffer */
+#define       MC_CMD_GET_CAPABILITIES_V7_OUT_SIZE_PIO_BUFF_OFST 70
+#define       MC_CMD_GET_CAPABILITIES_V7_OUT_SIZE_PIO_BUFF_LEN 2
+/* On chips later than Medford the amount of address space assigned to each VI
+ * is configurable. This is a global setting that the driver must query to
+ * discover the VI to address mapping. Cut-through PIO (CTPIO) is not available
+ * with 8k VI windows.
+ */
+#define       MC_CMD_GET_CAPABILITIES_V7_OUT_VI_WINDOW_MODE_OFST 72
+#define       MC_CMD_GET_CAPABILITIES_V7_OUT_VI_WINDOW_MODE_LEN 1
+/* enum: Each VI occupies 8k as on Huntington and Medford. PIO is at offset 4k.
+ * CTPIO is not mapped.
+ */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_VI_WINDOW_MODE_8K 0x0
+/* enum: Each VI occupies 16k. PIO is at offset 4k. CTPIO is at offset 12k. */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_VI_WINDOW_MODE_16K 0x1
+/* enum: Each VI occupies 64k. PIO is at offset 4k. CTPIO is at offset 12k. */
+#define          MC_CMD_GET_CAPABILITIES_V7_OUT_VI_WINDOW_MODE_64K 0x2
+/* Number of vFIFOs per adapter that can be used for VFIFO Stuffing
+ * (SF-115995-SW) in the present configuration of firmware and port mode.
+ */
+#define       MC_CMD_GET_CAPABILITIES_V7_OUT_VFIFO_STUFFING_NUM_VFIFOS_OFST 73
+#define       MC_CMD_GET_CAPABILITIES_V7_OUT_VFIFO_STUFFING_NUM_VFIFOS_LEN 1
+/* Number of buffers per adapter that can be used for VFIFO Stuffing
+ * (SF-115995-SW) in the present configuration of firmware and port mode.
+ */
+#define       MC_CMD_GET_CAPABILITIES_V7_OUT_VFIFO_STUFFING_NUM_CP_BUFFERS_OFST 74
+#define       MC_CMD_GET_CAPABILITIES_V7_OUT_VFIFO_STUFFING_NUM_CP_BUFFERS_LEN 2
+/* Entry count in the MAC stats array, including the final GENERATION_END
+ * entry. For MAC stats DMA, drivers should allocate a buffer large enough to
+ * hold at least this many 64-bit stats values, if they wish to receive all
+ * available stats. If the buffer is shorter than MAC_STATS_NUM_STATS * 8, the
+ * stats array returned will be truncated.
+ */
+#define       MC_CMD_GET_CAPABILITIES_V7_OUT_MAC_STATS_NUM_STATS_OFST 76
+#define       MC_CMD_GET_CAPABILITIES_V7_OUT_MAC_STATS_NUM_STATS_LEN 2
+/* Maximum supported value for MC_CMD_FILTER_OP_V3/MATCH_MARK_VALUE. This field
+ * will only be non-zero if MC_CMD_GET_CAPABILITIES/FILTER_ACTION_MARK is set.
+ */
+#define       MC_CMD_GET_CAPABILITIES_V7_OUT_FILTER_ACTION_MARK_MAX_OFST 80
+#define       MC_CMD_GET_CAPABILITIES_V7_OUT_FILTER_ACTION_MARK_MAX_LEN 4
+/* On devices where the INIT_RXQ_WITH_BUFFER_SIZE flag (in
+ * GET_CAPABILITIES_OUT_V2) is set, drivers have to specify a buffer size when
+ * they create an RX queue. Due to hardware limitations, only a small number of
+ * different buffer sizes may be available concurrently. Nonzero entries in
+ * this array are the sizes of buffers which the system guarantees will be
+ * available for use. If the list is empty, there are no limitations on
+ * concurrent buffer sizes.
+ */
+#define       MC_CMD_GET_CAPABILITIES_V7_OUT_GUARANTEED_RX_BUFFER_SIZES_OFST 84
+#define       MC_CMD_GET_CAPABILITIES_V7_OUT_GUARANTEED_RX_BUFFER_SIZES_LEN 4
+#define       MC_CMD_GET_CAPABILITIES_V7_OUT_GUARANTEED_RX_BUFFER_SIZES_NUM 16
+/* Third word of flags. Not present on older firmware (check the length). */
+#define       MC_CMD_GET_CAPABILITIES_V7_OUT_FLAGS3_OFST 148
+#define       MC_CMD_GET_CAPABILITIES_V7_OUT_FLAGS3_LEN 4
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_WOL_ETHERWAKE_OFST 148
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_WOL_ETHERWAKE_LBN 0
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_WOL_ETHERWAKE_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RSS_EVEN_SPREADING_OFST 148
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RSS_EVEN_SPREADING_LBN 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RSS_EVEN_SPREADING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RSS_SELECTABLE_TABLE_SIZE_OFST 148
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RSS_SELECTABLE_TABLE_SIZE_LBN 2
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RSS_SELECTABLE_TABLE_SIZE_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_MAE_SUPPORTED_OFST 148
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_MAE_SUPPORTED_LBN 3
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_MAE_SUPPORTED_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_VDPA_SUPPORTED_OFST 148
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_VDPA_SUPPORTED_LBN 4
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_VDPA_SUPPORTED_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RX_VLAN_STRIPPING_PER_ENCAP_RULE_OFST 148
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RX_VLAN_STRIPPING_PER_ENCAP_RULE_LBN 5
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_RX_VLAN_STRIPPING_PER_ENCAP_RULE_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_EXTENDED_WIDTH_EVQS_SUPPORTED_OFST 148
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_EXTENDED_WIDTH_EVQS_SUPPORTED_LBN 6
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_EXTENDED_WIDTH_EVQS_SUPPORTED_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_UNSOL_EV_CREDIT_SUPPORTED_OFST 148
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_UNSOL_EV_CREDIT_SUPPORTED_LBN 7
+#define        MC_CMD_GET_CAPABILITIES_V7_OUT_UNSOL_EV_CREDIT_SUPPORTED_WIDTH 1
+
+/* MC_CMD_GET_CAPABILITIES_V8_OUT msgresponse */
+#define    MC_CMD_GET_CAPABILITIES_V8_OUT_LEN 160
+/* First word of flags. */
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_FLAGS1_OFST 0
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_FLAGS1_LEN 4
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_VPORT_RECONFIGURE_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_VPORT_RECONFIGURE_LBN 3
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_VPORT_RECONFIGURE_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_TX_STRIPING_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_TX_STRIPING_LBN 4
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_TX_STRIPING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_VADAPTOR_QUERY_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_VADAPTOR_QUERY_LBN 5
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_VADAPTOR_QUERY_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_EVB_PORT_VLAN_RESTRICT_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_EVB_PORT_VLAN_RESTRICT_LBN 6
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_EVB_PORT_VLAN_RESTRICT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_DRV_ATTACH_PREBOOT_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_DRV_ATTACH_PREBOOT_LBN 7
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_DRV_ATTACH_PREBOOT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RX_FORCE_EVENT_MERGING_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RX_FORCE_EVENT_MERGING_LBN 8
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RX_FORCE_EVENT_MERGING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_SET_MAC_ENHANCED_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_SET_MAC_ENHANCED_LBN 9
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_SET_MAC_ENHANCED_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_UNKNOWN_UCAST_DST_FILTER_ALWAYS_MULTI_RECIPIENT_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_UNKNOWN_UCAST_DST_FILTER_ALWAYS_MULTI_RECIPIENT_LBN 10
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_UNKNOWN_UCAST_DST_FILTER_ALWAYS_MULTI_RECIPIENT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_VADAPTOR_PERMIT_SET_MAC_WHEN_FILTERS_INSTALLED_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_VADAPTOR_PERMIT_SET_MAC_WHEN_FILTERS_INSTALLED_LBN 11
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_VADAPTOR_PERMIT_SET_MAC_WHEN_FILTERS_INSTALLED_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_TX_MAC_SECURITY_FILTERING_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_TX_MAC_SECURITY_FILTERING_LBN 12
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_TX_MAC_SECURITY_FILTERING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_ADDITIONAL_RSS_MODES_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_ADDITIONAL_RSS_MODES_LBN 13
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_ADDITIONAL_RSS_MODES_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_QBB_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_QBB_LBN 14
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_QBB_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RX_PACKED_STREAM_VAR_BUFFERS_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RX_PACKED_STREAM_VAR_BUFFERS_LBN 15
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RX_PACKED_STREAM_VAR_BUFFERS_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RX_RSS_LIMITED_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RX_RSS_LIMITED_LBN 16
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RX_RSS_LIMITED_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RX_PACKED_STREAM_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RX_PACKED_STREAM_LBN 17
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RX_PACKED_STREAM_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RX_INCLUDE_FCS_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RX_INCLUDE_FCS_LBN 18
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RX_INCLUDE_FCS_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_TX_VLAN_INSERTION_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_TX_VLAN_INSERTION_LBN 19
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_TX_VLAN_INSERTION_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RX_VLAN_STRIPPING_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RX_VLAN_STRIPPING_LBN 20
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RX_VLAN_STRIPPING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_TX_TSO_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_TX_TSO_LBN 21
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_TX_TSO_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RX_PREFIX_LEN_0_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RX_PREFIX_LEN_0_LBN 22
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RX_PREFIX_LEN_0_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RX_PREFIX_LEN_14_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RX_PREFIX_LEN_14_LBN 23
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RX_PREFIX_LEN_14_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RX_TIMESTAMP_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RX_TIMESTAMP_LBN 24
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RX_TIMESTAMP_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RX_BATCHING_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RX_BATCHING_LBN 25
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RX_BATCHING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_MCAST_FILTER_CHAINING_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_MCAST_FILTER_CHAINING_LBN 26
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_MCAST_FILTER_CHAINING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_PM_AND_RXDP_COUNTERS_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_PM_AND_RXDP_COUNTERS_LBN 27
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_PM_AND_RXDP_COUNTERS_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RX_DISABLE_SCATTER_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RX_DISABLE_SCATTER_LBN 28
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RX_DISABLE_SCATTER_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_TX_MCAST_UDP_LOOPBACK_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_TX_MCAST_UDP_LOOPBACK_LBN 29
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_TX_MCAST_UDP_LOOPBACK_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_EVB_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_EVB_LBN 30
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_EVB_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_VXLAN_NVGRE_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_VXLAN_NVGRE_LBN 31
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_VXLAN_NVGRE_WIDTH 1
+/* RxDPCPU firmware id. */
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_RX_DPCPU_FW_ID_OFST 4
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_RX_DPCPU_FW_ID_LEN 2
+/* enum: Standard RXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_RXDP 0x0
+/* enum: Low latency RXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_RXDP_LOW_LATENCY 0x1
+/* enum: Packed stream RXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_RXDP_PACKED_STREAM 0x2
+/* enum: Rules engine RXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_RXDP_RULES_ENGINE 0x5
+/* enum: DPDK RXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_RXDP_DPDK 0x6
+/* enum: BIST RXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_RXDP_BIST 0x10a
+/* enum: RXDP Test firmware image 1 */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_RXDP_TEST_FW_TO_MC_CUT_THROUGH 0x101
+/* enum: RXDP Test firmware image 2 */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_RXDP_TEST_FW_TO_MC_STORE_FORWARD 0x102
+/* enum: RXDP Test firmware image 3 */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_RXDP_TEST_FW_TO_MC_STORE_FORWARD_FIRST 0x103
+/* enum: RXDP Test firmware image 4 */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_RXDP_TEST_EVERY_EVENT_BATCHABLE 0x104
+/* enum: RXDP Test firmware image 5 */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_RXDP_TEST_BACKPRESSURE 0x105
+/* enum: RXDP Test firmware image 6 */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_RXDP_TEST_FW_PACKET_EDITS 0x106
+/* enum: RXDP Test firmware image 7 */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_RXDP_TEST_FW_RX_HDR_SPLIT 0x107
+/* enum: RXDP Test firmware image 8 */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_RXDP_TEST_FW_DISABLE_DL 0x108
+/* enum: RXDP Test firmware image 9 */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_RXDP_TEST_FW_DOORBELL_DELAY 0x10b
+/* enum: RXDP Test firmware image 10 */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_RXDP_TEST_FW_SLOW 0x10c
+/* TxDPCPU firmware id. */
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_TX_DPCPU_FW_ID_OFST 6
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_TX_DPCPU_FW_ID_LEN 2
+/* enum: Standard TXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_TXDP 0x0
+/* enum: Low latency TXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_TXDP_LOW_LATENCY 0x1
+/* enum: High packet rate TXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_TXDP_HIGH_PACKET_RATE 0x3
+/* enum: Rules engine TXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_TXDP_RULES_ENGINE 0x5
+/* enum: DPDK TXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_TXDP_DPDK 0x6
+/* enum: BIST TXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_TXDP_BIST 0x12d
+/* enum: TXDP Test firmware image 1 */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_TXDP_TEST_FW_TSO_EDIT 0x101
+/* enum: TXDP Test firmware image 2 */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_TXDP_TEST_FW_PACKET_EDITS 0x102
+/* enum: TXDP CSR bus test firmware */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_TXDP_TEST_FW_CSR 0x103
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_RXPD_FW_VERSION_OFST 8
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_RXPD_FW_VERSION_LEN 2
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RXPD_FW_VERSION_REV_OFST 8
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RXPD_FW_VERSION_REV_LBN 0
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RXPD_FW_VERSION_REV_WIDTH 12
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RXPD_FW_VERSION_TYPE_OFST 8
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RXPD_FW_VERSION_TYPE_LBN 12
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RXPD_FW_VERSION_TYPE_WIDTH 4
+/* enum: reserved value - do not use (may indicate alternative interpretation
+ * of REV field in future)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_RXPD_FW_TYPE_RESERVED 0x0
+/* enum: Trivial RX PD firmware for early Huntington development (Huntington
+ * development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_RXPD_FW_TYPE_FIRST_PKT 0x1
+/* enum: RX PD firmware for telemetry prototyping (Medford2 development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_RXPD_FW_TYPE_TESTFW_TELEMETRY 0x1
+/* enum: RX PD firmware with approximately Siena-compatible behaviour
+ * (Huntington development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_RXPD_FW_TYPE_SIENA_COMPAT 0x2
+/* enum: Full featured RX PD production firmware */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_RXPD_FW_TYPE_FULL_FEATURED 0x3
+/* enum: (deprecated original name for the FULL_FEATURED variant) */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_RXPD_FW_TYPE_VSWITCH 0x3
+/* enum: siena_compat variant RX PD firmware using PM rather than MAC
+ * (Huntington development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_RXPD_FW_TYPE_SIENA_COMPAT_PM 0x4
+/* enum: Low latency RX PD production firmware */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_RXPD_FW_TYPE_LOW_LATENCY 0x5
+/* enum: Packed stream RX PD production firmware */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_RXPD_FW_TYPE_PACKED_STREAM 0x6
+/* enum: RX PD firmware handling layer 2 only for high packet rate performance
+ * tests (Medford development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_RXPD_FW_TYPE_LAYER2_PERF 0x7
+/* enum: Rules engine RX PD production firmware */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_RXPD_FW_TYPE_RULES_ENGINE 0x8
+/* enum: Custom firmware variant (see SF-119495-PD and bug69716) */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_RXPD_FW_TYPE_L3XUDP 0x9
+/* enum: DPDK RX PD production firmware */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_RXPD_FW_TYPE_DPDK 0xa
+/* enum: RX PD firmware for GUE parsing prototype (Medford development only) */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_RXPD_FW_TYPE_TESTFW_GUE_PROTOTYPE 0xe
+/* enum: RX PD firmware parsing but not filtering network overlay tunnel
+ * encapsulations (Medford development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_RXPD_FW_TYPE_TESTFW_ENCAP_PARSING_ONLY 0xf
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_TXPD_FW_VERSION_OFST 10
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_TXPD_FW_VERSION_LEN 2
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_TXPD_FW_VERSION_REV_OFST 10
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_TXPD_FW_VERSION_REV_LBN 0
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_TXPD_FW_VERSION_REV_WIDTH 12
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_TXPD_FW_VERSION_TYPE_OFST 10
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_TXPD_FW_VERSION_TYPE_LBN 12
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_TXPD_FW_VERSION_TYPE_WIDTH 4
+/* enum: reserved value - do not use (may indicate alternative interpretation
+ * of REV field in future)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_TXPD_FW_TYPE_RESERVED 0x0
+/* enum: Trivial TX PD firmware for early Huntington development (Huntington
+ * development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_TXPD_FW_TYPE_FIRST_PKT 0x1
+/* enum: TX PD firmware for telemetry prototyping (Medford2 development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_TXPD_FW_TYPE_TESTFW_TELEMETRY 0x1
+/* enum: TX PD firmware with approximately Siena-compatible behaviour
+ * (Huntington development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_TXPD_FW_TYPE_SIENA_COMPAT 0x2
+/* enum: Full featured TX PD production firmware */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_TXPD_FW_TYPE_FULL_FEATURED 0x3
+/* enum: (deprecated original name for the FULL_FEATURED variant) */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_TXPD_FW_TYPE_VSWITCH 0x3
+/* enum: siena_compat variant TX PD firmware using PM rather than MAC
+ * (Huntington development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_TXPD_FW_TYPE_SIENA_COMPAT_PM 0x4
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_TXPD_FW_TYPE_LOW_LATENCY 0x5 /* enum */
+/* enum: TX PD firmware handling layer 2 only for high packet rate performance
+ * tests (Medford development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_TXPD_FW_TYPE_LAYER2_PERF 0x7
+/* enum: Rules engine TX PD production firmware */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_TXPD_FW_TYPE_RULES_ENGINE 0x8
+/* enum: Custom firmware variant (see SF-119495-PD and bug69716) */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_TXPD_FW_TYPE_L3XUDP 0x9
+/* enum: DPDK TX PD production firmware */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_TXPD_FW_TYPE_DPDK 0xa
+/* enum: RX PD firmware for GUE parsing prototype (Medford development only) */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_TXPD_FW_TYPE_TESTFW_GUE_PROTOTYPE 0xe
+/* Hardware capabilities of NIC */
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_HW_CAPABILITIES_OFST 12
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_HW_CAPABILITIES_LEN 4
+/* Licensed capabilities */
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_LICENSE_CAPABILITIES_OFST 16
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_LICENSE_CAPABILITIES_LEN 4
+/* Second word of flags. Not present on older firmware (check the length). */
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_FLAGS2_OFST 20
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_FLAGS2_LEN 4
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_TX_TSO_V2_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_TX_TSO_V2_LBN 0
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_TX_TSO_V2_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_TX_TSO_V2_ENCAP_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_TX_TSO_V2_ENCAP_LBN 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_TX_TSO_V2_ENCAP_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_EVQ_TIMER_CTRL_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_EVQ_TIMER_CTRL_LBN 2
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_EVQ_TIMER_CTRL_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_EVENT_CUT_THROUGH_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_EVENT_CUT_THROUGH_LBN 3
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_EVENT_CUT_THROUGH_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RX_CUT_THROUGH_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RX_CUT_THROUGH_LBN 4
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RX_CUT_THROUGH_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_TX_VFIFO_ULL_MODE_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_TX_VFIFO_ULL_MODE_LBN 5
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_TX_VFIFO_ULL_MODE_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_MAC_STATS_40G_TX_SIZE_BINS_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_MAC_STATS_40G_TX_SIZE_BINS_LBN 6
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_MAC_STATS_40G_TX_SIZE_BINS_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_INIT_EVQ_TYPE_SUPPORTED_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_INIT_EVQ_TYPE_SUPPORTED_LBN 7
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_INIT_EVQ_TYPE_SUPPORTED_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_INIT_EVQ_V2_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_INIT_EVQ_V2_LBN 7
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_INIT_EVQ_V2_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_TX_MAC_TIMESTAMPING_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_TX_MAC_TIMESTAMPING_LBN 8
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_TX_MAC_TIMESTAMPING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_TX_TIMESTAMP_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_TX_TIMESTAMP_LBN 9
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_TX_TIMESTAMP_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RX_SNIFF_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RX_SNIFF_LBN 10
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RX_SNIFF_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_TX_SNIFF_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_TX_SNIFF_LBN 11
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_TX_SNIFF_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_NVRAM_UPDATE_REPORT_VERIFY_RESULT_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_NVRAM_UPDATE_REPORT_VERIFY_RESULT_LBN 12
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_NVRAM_UPDATE_REPORT_VERIFY_RESULT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_MCDI_BACKGROUND_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_MCDI_BACKGROUND_LBN 13
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_MCDI_BACKGROUND_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_MCDI_DB_RETURN_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_MCDI_DB_RETURN_LBN 14
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_MCDI_DB_RETURN_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_CTPIO_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_CTPIO_LBN 15
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_CTPIO_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_TSA_SUPPORT_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_TSA_SUPPORT_LBN 16
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_TSA_SUPPORT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_TSA_BOUND_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_TSA_BOUND_LBN 17
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_TSA_BOUND_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_SF_ADAPTER_AUTHENTICATION_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_SF_ADAPTER_AUTHENTICATION_LBN 18
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_SF_ADAPTER_AUTHENTICATION_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_FILTER_ACTION_FLAG_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_FILTER_ACTION_FLAG_LBN 19
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_FILTER_ACTION_FLAG_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_FILTER_ACTION_MARK_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_FILTER_ACTION_MARK_LBN 20
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_FILTER_ACTION_MARK_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_EQUAL_STRIDE_SUPER_BUFFER_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_EQUAL_STRIDE_SUPER_BUFFER_LBN 21
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_EQUAL_STRIDE_SUPER_BUFFER_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_EQUAL_STRIDE_PACKED_STREAM_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_EQUAL_STRIDE_PACKED_STREAM_LBN 21
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_EQUAL_STRIDE_PACKED_STREAM_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_L3XUDP_SUPPORT_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_L3XUDP_SUPPORT_LBN 22
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_L3XUDP_SUPPORT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_FW_SUBVARIANT_NO_TX_CSUM_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_FW_SUBVARIANT_NO_TX_CSUM_LBN 23
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_FW_SUBVARIANT_NO_TX_CSUM_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_VI_SPREADING_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_VI_SPREADING_LBN 24
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_VI_SPREADING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RXDP_HLB_IDLE_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RXDP_HLB_IDLE_LBN 25
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RXDP_HLB_IDLE_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_INIT_RXQ_NO_CONT_EV_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_INIT_RXQ_NO_CONT_EV_LBN 26
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_INIT_RXQ_NO_CONT_EV_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_INIT_RXQ_WITH_BUFFER_SIZE_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_INIT_RXQ_WITH_BUFFER_SIZE_LBN 27
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_INIT_RXQ_WITH_BUFFER_SIZE_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_BUNDLE_UPDATE_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_BUNDLE_UPDATE_LBN 28
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_BUNDLE_UPDATE_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_TX_TSO_V3_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_TX_TSO_V3_LBN 29
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_TX_TSO_V3_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_DYNAMIC_SENSORS_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_DYNAMIC_SENSORS_LBN 30
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_DYNAMIC_SENSORS_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_NVRAM_UPDATE_POLL_VERIFY_RESULT_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_NVRAM_UPDATE_POLL_VERIFY_RESULT_LBN 31
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_NVRAM_UPDATE_POLL_VERIFY_RESULT_WIDTH 1
+/* Number of FATSOv2 contexts per datapath supported by this NIC (when
+ * TX_TSO_V2 == 1). Not present on older firmware (check the length).
+ */
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_TX_TSO_V2_N_CONTEXTS_OFST 24
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_TX_TSO_V2_N_CONTEXTS_LEN 2
+/* One byte per PF containing the number of the external port assigned to this
+ * PF, indexed by PF number. Special values indicate that a PF is either not
+ * present or not assigned.
+ */
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_PFS_TO_PORTS_ASSIGNMENT_OFST 26
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_PFS_TO_PORTS_ASSIGNMENT_LEN 1
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_PFS_TO_PORTS_ASSIGNMENT_NUM 16
+/* enum: The caller is not permitted to access information on this PF. */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_ACCESS_NOT_PERMITTED 0xff
+/* enum: PF does not exist. */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_PF_NOT_PRESENT 0xfe
+/* enum: PF does exist but is not assigned to any external port. */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_PF_NOT_ASSIGNED 0xfd
+/* enum: This value indicates that PF is assigned, but it cannot be expressed
+ * in this field. It is intended for a possible future situation where a more
+ * complex scheme of PFs to ports mapping is being used. The future driver
+ * should look for a new field supporting the new scheme. The current/old
+ * driver should treat this value as PF_NOT_ASSIGNED.
+ */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_INCOMPATIBLE_ASSIGNMENT 0xfc
+/* One byte per PF containing the number of its VFs, indexed by PF number. A
+ * special value indicates that a PF is not present.
+ */
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_NUM_VFS_PER_PF_OFST 42
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_NUM_VFS_PER_PF_LEN 1
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_NUM_VFS_PER_PF_NUM 16
+/* enum: The caller is not permitted to access information on this PF. */
+/*               MC_CMD_GET_CAPABILITIES_V8_OUT_ACCESS_NOT_PERMITTED 0xff */
+/* enum: PF does not exist. */
+/*               MC_CMD_GET_CAPABILITIES_V8_OUT_PF_NOT_PRESENT 0xfe */
+/* Number of VIs available for each external port */
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_NUM_VIS_PER_PORT_OFST 58
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_NUM_VIS_PER_PORT_LEN 2
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_NUM_VIS_PER_PORT_NUM 4
+/* Size of RX descriptor cache expressed as binary logarithm The actual size
+ * equals (2 ^ RX_DESC_CACHE_SIZE)
+ */
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_RX_DESC_CACHE_SIZE_OFST 66
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_RX_DESC_CACHE_SIZE_LEN 1
+/* Size of TX descriptor cache expressed as binary logarithm The actual size
+ * equals (2 ^ TX_DESC_CACHE_SIZE)
+ */
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_TX_DESC_CACHE_SIZE_OFST 67
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_TX_DESC_CACHE_SIZE_LEN 1
+/* Total number of available PIO buffers */
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_NUM_PIO_BUFFS_OFST 68
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_NUM_PIO_BUFFS_LEN 2
+/* Size of a single PIO buffer */
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_SIZE_PIO_BUFF_OFST 70
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_SIZE_PIO_BUFF_LEN 2
+/* On chips later than Medford the amount of address space assigned to each VI
+ * is configurable. This is a global setting that the driver must query to
+ * discover the VI to address mapping. Cut-through PIO (CTPIO) is not available
+ * with 8k VI windows.
+ */
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_VI_WINDOW_MODE_OFST 72
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_VI_WINDOW_MODE_LEN 1
+/* enum: Each VI occupies 8k as on Huntington and Medford. PIO is at offset 4k.
+ * CTPIO is not mapped.
+ */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_VI_WINDOW_MODE_8K 0x0
+/* enum: Each VI occupies 16k. PIO is at offset 4k. CTPIO is at offset 12k. */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_VI_WINDOW_MODE_16K 0x1
+/* enum: Each VI occupies 64k. PIO is at offset 4k. CTPIO is at offset 12k. */
+#define          MC_CMD_GET_CAPABILITIES_V8_OUT_VI_WINDOW_MODE_64K 0x2
+/* Number of vFIFOs per adapter that can be used for VFIFO Stuffing
+ * (SF-115995-SW) in the present configuration of firmware and port mode.
+ */
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_VFIFO_STUFFING_NUM_VFIFOS_OFST 73
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_VFIFO_STUFFING_NUM_VFIFOS_LEN 1
+/* Number of buffers per adapter that can be used for VFIFO Stuffing
+ * (SF-115995-SW) in the present configuration of firmware and port mode.
+ */
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_VFIFO_STUFFING_NUM_CP_BUFFERS_OFST 74
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_VFIFO_STUFFING_NUM_CP_BUFFERS_LEN 2
+/* Entry count in the MAC stats array, including the final GENERATION_END
+ * entry. For MAC stats DMA, drivers should allocate a buffer large enough to
+ * hold at least this many 64-bit stats values, if they wish to receive all
+ * available stats. If the buffer is shorter than MAC_STATS_NUM_STATS * 8, the
+ * stats array returned will be truncated.
+ */
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_MAC_STATS_NUM_STATS_OFST 76
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_MAC_STATS_NUM_STATS_LEN 2
+/* Maximum supported value for MC_CMD_FILTER_OP_V3/MATCH_MARK_VALUE. This field
+ * will only be non-zero if MC_CMD_GET_CAPABILITIES/FILTER_ACTION_MARK is set.
+ */
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_FILTER_ACTION_MARK_MAX_OFST 80
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_FILTER_ACTION_MARK_MAX_LEN 4
+/* On devices where the INIT_RXQ_WITH_BUFFER_SIZE flag (in
+ * GET_CAPABILITIES_OUT_V2) is set, drivers have to specify a buffer size when
+ * they create an RX queue. Due to hardware limitations, only a small number of
+ * different buffer sizes may be available concurrently. Nonzero entries in
+ * this array are the sizes of buffers which the system guarantees will be
+ * available for use. If the list is empty, there are no limitations on
+ * concurrent buffer sizes.
+ */
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_GUARANTEED_RX_BUFFER_SIZES_OFST 84
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_GUARANTEED_RX_BUFFER_SIZES_LEN 4
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_GUARANTEED_RX_BUFFER_SIZES_NUM 16
+/* Third word of flags. Not present on older firmware (check the length). */
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_FLAGS3_OFST 148
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_FLAGS3_LEN 4
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_WOL_ETHERWAKE_OFST 148
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_WOL_ETHERWAKE_LBN 0
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_WOL_ETHERWAKE_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RSS_EVEN_SPREADING_OFST 148
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RSS_EVEN_SPREADING_LBN 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RSS_EVEN_SPREADING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RSS_SELECTABLE_TABLE_SIZE_OFST 148
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RSS_SELECTABLE_TABLE_SIZE_LBN 2
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RSS_SELECTABLE_TABLE_SIZE_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_MAE_SUPPORTED_OFST 148
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_MAE_SUPPORTED_LBN 3
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_MAE_SUPPORTED_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_VDPA_SUPPORTED_OFST 148
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_VDPA_SUPPORTED_LBN 4
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_VDPA_SUPPORTED_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RX_VLAN_STRIPPING_PER_ENCAP_RULE_OFST 148
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RX_VLAN_STRIPPING_PER_ENCAP_RULE_LBN 5
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_RX_VLAN_STRIPPING_PER_ENCAP_RULE_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_EXTENDED_WIDTH_EVQS_SUPPORTED_OFST 148
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_EXTENDED_WIDTH_EVQS_SUPPORTED_LBN 6
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_EXTENDED_WIDTH_EVQS_SUPPORTED_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_UNSOL_EV_CREDIT_SUPPORTED_OFST 148
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_UNSOL_EV_CREDIT_SUPPORTED_LBN 7
+#define        MC_CMD_GET_CAPABILITIES_V8_OUT_UNSOL_EV_CREDIT_SUPPORTED_WIDTH 1
+/* These bits are reserved for communicating test-specific capabilities to
+ * host-side test software. All production drivers should treat this field as
+ * opaque.
+ */
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_TEST_RESERVED_OFST 152
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_TEST_RESERVED_LEN 8
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_TEST_RESERVED_LO_OFST 152
+#define       MC_CMD_GET_CAPABILITIES_V8_OUT_TEST_RESERVED_HI_OFST 156
+
+/* MC_CMD_GET_CAPABILITIES_V9_OUT msgresponse */
+#define    MC_CMD_GET_CAPABILITIES_V9_OUT_LEN 184
+/* First word of flags. */
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_FLAGS1_OFST 0
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_FLAGS1_LEN 4
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_VPORT_RECONFIGURE_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_VPORT_RECONFIGURE_LBN 3
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_VPORT_RECONFIGURE_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_TX_STRIPING_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_TX_STRIPING_LBN 4
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_TX_STRIPING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_VADAPTOR_QUERY_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_VADAPTOR_QUERY_LBN 5
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_VADAPTOR_QUERY_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_EVB_PORT_VLAN_RESTRICT_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_EVB_PORT_VLAN_RESTRICT_LBN 6
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_EVB_PORT_VLAN_RESTRICT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_DRV_ATTACH_PREBOOT_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_DRV_ATTACH_PREBOOT_LBN 7
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_DRV_ATTACH_PREBOOT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RX_FORCE_EVENT_MERGING_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RX_FORCE_EVENT_MERGING_LBN 8
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RX_FORCE_EVENT_MERGING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_SET_MAC_ENHANCED_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_SET_MAC_ENHANCED_LBN 9
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_SET_MAC_ENHANCED_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_UNKNOWN_UCAST_DST_FILTER_ALWAYS_MULTI_RECIPIENT_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_UNKNOWN_UCAST_DST_FILTER_ALWAYS_MULTI_RECIPIENT_LBN 10
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_UNKNOWN_UCAST_DST_FILTER_ALWAYS_MULTI_RECIPIENT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_VADAPTOR_PERMIT_SET_MAC_WHEN_FILTERS_INSTALLED_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_VADAPTOR_PERMIT_SET_MAC_WHEN_FILTERS_INSTALLED_LBN 11
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_VADAPTOR_PERMIT_SET_MAC_WHEN_FILTERS_INSTALLED_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_TX_MAC_SECURITY_FILTERING_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_TX_MAC_SECURITY_FILTERING_LBN 12
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_TX_MAC_SECURITY_FILTERING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_ADDITIONAL_RSS_MODES_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_ADDITIONAL_RSS_MODES_LBN 13
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_ADDITIONAL_RSS_MODES_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_QBB_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_QBB_LBN 14
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_QBB_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RX_PACKED_STREAM_VAR_BUFFERS_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RX_PACKED_STREAM_VAR_BUFFERS_LBN 15
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RX_PACKED_STREAM_VAR_BUFFERS_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RX_RSS_LIMITED_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RX_RSS_LIMITED_LBN 16
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RX_RSS_LIMITED_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RX_PACKED_STREAM_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RX_PACKED_STREAM_LBN 17
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RX_PACKED_STREAM_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RX_INCLUDE_FCS_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RX_INCLUDE_FCS_LBN 18
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RX_INCLUDE_FCS_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_TX_VLAN_INSERTION_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_TX_VLAN_INSERTION_LBN 19
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_TX_VLAN_INSERTION_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RX_VLAN_STRIPPING_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RX_VLAN_STRIPPING_LBN 20
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RX_VLAN_STRIPPING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_TX_TSO_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_TX_TSO_LBN 21
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_TX_TSO_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RX_PREFIX_LEN_0_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RX_PREFIX_LEN_0_LBN 22
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RX_PREFIX_LEN_0_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RX_PREFIX_LEN_14_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RX_PREFIX_LEN_14_LBN 23
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RX_PREFIX_LEN_14_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RX_TIMESTAMP_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RX_TIMESTAMP_LBN 24
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RX_TIMESTAMP_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RX_BATCHING_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RX_BATCHING_LBN 25
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RX_BATCHING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_MCAST_FILTER_CHAINING_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_MCAST_FILTER_CHAINING_LBN 26
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_MCAST_FILTER_CHAINING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_PM_AND_RXDP_COUNTERS_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_PM_AND_RXDP_COUNTERS_LBN 27
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_PM_AND_RXDP_COUNTERS_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RX_DISABLE_SCATTER_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RX_DISABLE_SCATTER_LBN 28
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RX_DISABLE_SCATTER_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_TX_MCAST_UDP_LOOPBACK_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_TX_MCAST_UDP_LOOPBACK_LBN 29
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_TX_MCAST_UDP_LOOPBACK_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_EVB_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_EVB_LBN 30
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_EVB_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_VXLAN_NVGRE_OFST 0
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_VXLAN_NVGRE_LBN 31
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_VXLAN_NVGRE_WIDTH 1
+/* RxDPCPU firmware id. */
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_RX_DPCPU_FW_ID_OFST 4
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_RX_DPCPU_FW_ID_LEN 2
+/* enum: Standard RXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_RXDP 0x0
+/* enum: Low latency RXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_RXDP_LOW_LATENCY 0x1
+/* enum: Packed stream RXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_RXDP_PACKED_STREAM 0x2
+/* enum: Rules engine RXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_RXDP_RULES_ENGINE 0x5
+/* enum: DPDK RXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_RXDP_DPDK 0x6
+/* enum: BIST RXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_RXDP_BIST 0x10a
+/* enum: RXDP Test firmware image 1 */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_RXDP_TEST_FW_TO_MC_CUT_THROUGH 0x101
+/* enum: RXDP Test firmware image 2 */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_RXDP_TEST_FW_TO_MC_STORE_FORWARD 0x102
+/* enum: RXDP Test firmware image 3 */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_RXDP_TEST_FW_TO_MC_STORE_FORWARD_FIRST 0x103
+/* enum: RXDP Test firmware image 4 */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_RXDP_TEST_EVERY_EVENT_BATCHABLE 0x104
+/* enum: RXDP Test firmware image 5 */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_RXDP_TEST_BACKPRESSURE 0x105
+/* enum: RXDP Test firmware image 6 */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_RXDP_TEST_FW_PACKET_EDITS 0x106
+/* enum: RXDP Test firmware image 7 */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_RXDP_TEST_FW_RX_HDR_SPLIT 0x107
+/* enum: RXDP Test firmware image 8 */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_RXDP_TEST_FW_DISABLE_DL 0x108
+/* enum: RXDP Test firmware image 9 */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_RXDP_TEST_FW_DOORBELL_DELAY 0x10b
+/* enum: RXDP Test firmware image 10 */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_RXDP_TEST_FW_SLOW 0x10c
+/* TxDPCPU firmware id. */
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_TX_DPCPU_FW_ID_OFST 6
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_TX_DPCPU_FW_ID_LEN 2
+/* enum: Standard TXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_TXDP 0x0
+/* enum: Low latency TXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_TXDP_LOW_LATENCY 0x1
+/* enum: High packet rate TXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_TXDP_HIGH_PACKET_RATE 0x3
+/* enum: Rules engine TXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_TXDP_RULES_ENGINE 0x5
+/* enum: DPDK TXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_TXDP_DPDK 0x6
+/* enum: BIST TXDP firmware */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_TXDP_BIST 0x12d
+/* enum: TXDP Test firmware image 1 */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_TXDP_TEST_FW_TSO_EDIT 0x101
+/* enum: TXDP Test firmware image 2 */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_TXDP_TEST_FW_PACKET_EDITS 0x102
+/* enum: TXDP CSR bus test firmware */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_TXDP_TEST_FW_CSR 0x103
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_RXPD_FW_VERSION_OFST 8
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_RXPD_FW_VERSION_LEN 2
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RXPD_FW_VERSION_REV_OFST 8
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RXPD_FW_VERSION_REV_LBN 0
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RXPD_FW_VERSION_REV_WIDTH 12
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RXPD_FW_VERSION_TYPE_OFST 8
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RXPD_FW_VERSION_TYPE_LBN 12
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RXPD_FW_VERSION_TYPE_WIDTH 4
+/* enum: reserved value - do not use (may indicate alternative interpretation
+ * of REV field in future)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_RXPD_FW_TYPE_RESERVED 0x0
+/* enum: Trivial RX PD firmware for early Huntington development (Huntington
+ * development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_RXPD_FW_TYPE_FIRST_PKT 0x1
+/* enum: RX PD firmware for telemetry prototyping (Medford2 development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_RXPD_FW_TYPE_TESTFW_TELEMETRY 0x1
+/* enum: RX PD firmware with approximately Siena-compatible behaviour
+ * (Huntington development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_RXPD_FW_TYPE_SIENA_COMPAT 0x2
+/* enum: Full featured RX PD production firmware */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_RXPD_FW_TYPE_FULL_FEATURED 0x3
+/* enum: (deprecated original name for the FULL_FEATURED variant) */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_RXPD_FW_TYPE_VSWITCH 0x3
+/* enum: siena_compat variant RX PD firmware using PM rather than MAC
+ * (Huntington development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_RXPD_FW_TYPE_SIENA_COMPAT_PM 0x4
+/* enum: Low latency RX PD production firmware */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_RXPD_FW_TYPE_LOW_LATENCY 0x5
+/* enum: Packed stream RX PD production firmware */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_RXPD_FW_TYPE_PACKED_STREAM 0x6
+/* enum: RX PD firmware handling layer 2 only for high packet rate performance
+ * tests (Medford development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_RXPD_FW_TYPE_LAYER2_PERF 0x7
+/* enum: Rules engine RX PD production firmware */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_RXPD_FW_TYPE_RULES_ENGINE 0x8
+/* enum: Custom firmware variant (see SF-119495-PD and bug69716) */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_RXPD_FW_TYPE_L3XUDP 0x9
+/* enum: DPDK RX PD production firmware */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_RXPD_FW_TYPE_DPDK 0xa
+/* enum: RX PD firmware for GUE parsing prototype (Medford development only) */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_RXPD_FW_TYPE_TESTFW_GUE_PROTOTYPE 0xe
+/* enum: RX PD firmware parsing but not filtering network overlay tunnel
+ * encapsulations (Medford development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_RXPD_FW_TYPE_TESTFW_ENCAP_PARSING_ONLY 0xf
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_TXPD_FW_VERSION_OFST 10
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_TXPD_FW_VERSION_LEN 2
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_TXPD_FW_VERSION_REV_OFST 10
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_TXPD_FW_VERSION_REV_LBN 0
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_TXPD_FW_VERSION_REV_WIDTH 12
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_TXPD_FW_VERSION_TYPE_OFST 10
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_TXPD_FW_VERSION_TYPE_LBN 12
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_TXPD_FW_VERSION_TYPE_WIDTH 4
+/* enum: reserved value - do not use (may indicate alternative interpretation
+ * of REV field in future)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_TXPD_FW_TYPE_RESERVED 0x0
+/* enum: Trivial TX PD firmware for early Huntington development (Huntington
+ * development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_TXPD_FW_TYPE_FIRST_PKT 0x1
+/* enum: TX PD firmware for telemetry prototyping (Medford2 development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_TXPD_FW_TYPE_TESTFW_TELEMETRY 0x1
+/* enum: TX PD firmware with approximately Siena-compatible behaviour
+ * (Huntington development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_TXPD_FW_TYPE_SIENA_COMPAT 0x2
+/* enum: Full featured TX PD production firmware */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_TXPD_FW_TYPE_FULL_FEATURED 0x3
+/* enum: (deprecated original name for the FULL_FEATURED variant) */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_TXPD_FW_TYPE_VSWITCH 0x3
+/* enum: siena_compat variant TX PD firmware using PM rather than MAC
+ * (Huntington development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_TXPD_FW_TYPE_SIENA_COMPAT_PM 0x4
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_TXPD_FW_TYPE_LOW_LATENCY 0x5 /* enum */
+/* enum: TX PD firmware handling layer 2 only for high packet rate performance
+ * tests (Medford development only)
+ */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_TXPD_FW_TYPE_LAYER2_PERF 0x7
+/* enum: Rules engine TX PD production firmware */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_TXPD_FW_TYPE_RULES_ENGINE 0x8
+/* enum: Custom firmware variant (see SF-119495-PD and bug69716) */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_TXPD_FW_TYPE_L3XUDP 0x9
+/* enum: DPDK TX PD production firmware */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_TXPD_FW_TYPE_DPDK 0xa
+/* enum: RX PD firmware for GUE parsing prototype (Medford development only) */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_TXPD_FW_TYPE_TESTFW_GUE_PROTOTYPE 0xe
+/* Hardware capabilities of NIC */
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_HW_CAPABILITIES_OFST 12
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_HW_CAPABILITIES_LEN 4
+/* Licensed capabilities */
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_LICENSE_CAPABILITIES_OFST 16
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_LICENSE_CAPABILITIES_LEN 4
+/* Second word of flags. Not present on older firmware (check the length). */
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_FLAGS2_OFST 20
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_FLAGS2_LEN 4
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_TX_TSO_V2_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_TX_TSO_V2_LBN 0
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_TX_TSO_V2_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_TX_TSO_V2_ENCAP_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_TX_TSO_V2_ENCAP_LBN 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_TX_TSO_V2_ENCAP_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_EVQ_TIMER_CTRL_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_EVQ_TIMER_CTRL_LBN 2
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_EVQ_TIMER_CTRL_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_EVENT_CUT_THROUGH_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_EVENT_CUT_THROUGH_LBN 3
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_EVENT_CUT_THROUGH_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RX_CUT_THROUGH_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RX_CUT_THROUGH_LBN 4
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RX_CUT_THROUGH_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_TX_VFIFO_ULL_MODE_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_TX_VFIFO_ULL_MODE_LBN 5
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_TX_VFIFO_ULL_MODE_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_MAC_STATS_40G_TX_SIZE_BINS_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_MAC_STATS_40G_TX_SIZE_BINS_LBN 6
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_MAC_STATS_40G_TX_SIZE_BINS_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_INIT_EVQ_TYPE_SUPPORTED_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_INIT_EVQ_TYPE_SUPPORTED_LBN 7
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_INIT_EVQ_TYPE_SUPPORTED_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_INIT_EVQ_V2_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_INIT_EVQ_V2_LBN 7
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_INIT_EVQ_V2_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_TX_MAC_TIMESTAMPING_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_TX_MAC_TIMESTAMPING_LBN 8
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_TX_MAC_TIMESTAMPING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_TX_TIMESTAMP_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_TX_TIMESTAMP_LBN 9
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_TX_TIMESTAMP_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RX_SNIFF_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RX_SNIFF_LBN 10
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RX_SNIFF_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_TX_SNIFF_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_TX_SNIFF_LBN 11
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_TX_SNIFF_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_NVRAM_UPDATE_REPORT_VERIFY_RESULT_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_NVRAM_UPDATE_REPORT_VERIFY_RESULT_LBN 12
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_NVRAM_UPDATE_REPORT_VERIFY_RESULT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_MCDI_BACKGROUND_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_MCDI_BACKGROUND_LBN 13
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_MCDI_BACKGROUND_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_MCDI_DB_RETURN_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_MCDI_DB_RETURN_LBN 14
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_MCDI_DB_RETURN_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_CTPIO_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_CTPIO_LBN 15
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_CTPIO_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_TSA_SUPPORT_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_TSA_SUPPORT_LBN 16
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_TSA_SUPPORT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_TSA_BOUND_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_TSA_BOUND_LBN 17
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_TSA_BOUND_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_SF_ADAPTER_AUTHENTICATION_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_SF_ADAPTER_AUTHENTICATION_LBN 18
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_SF_ADAPTER_AUTHENTICATION_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_FILTER_ACTION_FLAG_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_FILTER_ACTION_FLAG_LBN 19
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_FILTER_ACTION_FLAG_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_FILTER_ACTION_MARK_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_FILTER_ACTION_MARK_LBN 20
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_FILTER_ACTION_MARK_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_EQUAL_STRIDE_SUPER_BUFFER_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_EQUAL_STRIDE_SUPER_BUFFER_LBN 21
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_EQUAL_STRIDE_SUPER_BUFFER_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_EQUAL_STRIDE_PACKED_STREAM_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_EQUAL_STRIDE_PACKED_STREAM_LBN 21
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_EQUAL_STRIDE_PACKED_STREAM_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_L3XUDP_SUPPORT_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_L3XUDP_SUPPORT_LBN 22
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_L3XUDP_SUPPORT_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_FW_SUBVARIANT_NO_TX_CSUM_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_FW_SUBVARIANT_NO_TX_CSUM_LBN 23
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_FW_SUBVARIANT_NO_TX_CSUM_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_VI_SPREADING_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_VI_SPREADING_LBN 24
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_VI_SPREADING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RXDP_HLB_IDLE_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RXDP_HLB_IDLE_LBN 25
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RXDP_HLB_IDLE_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_INIT_RXQ_NO_CONT_EV_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_INIT_RXQ_NO_CONT_EV_LBN 26
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_INIT_RXQ_NO_CONT_EV_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_INIT_RXQ_WITH_BUFFER_SIZE_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_INIT_RXQ_WITH_BUFFER_SIZE_LBN 27
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_INIT_RXQ_WITH_BUFFER_SIZE_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_BUNDLE_UPDATE_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_BUNDLE_UPDATE_LBN 28
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_BUNDLE_UPDATE_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_TX_TSO_V3_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_TX_TSO_V3_LBN 29
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_TX_TSO_V3_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_DYNAMIC_SENSORS_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_DYNAMIC_SENSORS_LBN 30
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_DYNAMIC_SENSORS_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_NVRAM_UPDATE_POLL_VERIFY_RESULT_OFST 20
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_NVRAM_UPDATE_POLL_VERIFY_RESULT_LBN 31
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_NVRAM_UPDATE_POLL_VERIFY_RESULT_WIDTH 1
+/* Number of FATSOv2 contexts per datapath supported by this NIC (when
+ * TX_TSO_V2 == 1). Not present on older firmware (check the length).
+ */
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_TX_TSO_V2_N_CONTEXTS_OFST 24
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_TX_TSO_V2_N_CONTEXTS_LEN 2
+/* One byte per PF containing the number of the external port assigned to this
+ * PF, indexed by PF number. Special values indicate that a PF is either not
+ * present or not assigned.
+ */
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_PFS_TO_PORTS_ASSIGNMENT_OFST 26
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_PFS_TO_PORTS_ASSIGNMENT_LEN 1
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_PFS_TO_PORTS_ASSIGNMENT_NUM 16
+/* enum: The caller is not permitted to access information on this PF. */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_ACCESS_NOT_PERMITTED 0xff
+/* enum: PF does not exist. */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_PF_NOT_PRESENT 0xfe
+/* enum: PF does exist but is not assigned to any external port. */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_PF_NOT_ASSIGNED 0xfd
+/* enum: This value indicates that PF is assigned, but it cannot be expressed
+ * in this field. It is intended for a possible future situation where a more
+ * complex scheme of PFs to ports mapping is being used. The future driver
+ * should look for a new field supporting the new scheme. The current/old
+ * driver should treat this value as PF_NOT_ASSIGNED.
+ */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_INCOMPATIBLE_ASSIGNMENT 0xfc
+/* One byte per PF containing the number of its VFs, indexed by PF number. A
+ * special value indicates that a PF is not present.
+ */
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_NUM_VFS_PER_PF_OFST 42
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_NUM_VFS_PER_PF_LEN 1
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_NUM_VFS_PER_PF_NUM 16
+/* enum: The caller is not permitted to access information on this PF. */
+/*               MC_CMD_GET_CAPABILITIES_V9_OUT_ACCESS_NOT_PERMITTED 0xff */
+/* enum: PF does not exist. */
+/*               MC_CMD_GET_CAPABILITIES_V9_OUT_PF_NOT_PRESENT 0xfe */
+/* Number of VIs available for each external port */
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_NUM_VIS_PER_PORT_OFST 58
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_NUM_VIS_PER_PORT_LEN 2
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_NUM_VIS_PER_PORT_NUM 4
+/* Size of RX descriptor cache expressed as binary logarithm The actual size
+ * equals (2 ^ RX_DESC_CACHE_SIZE)
+ */
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_RX_DESC_CACHE_SIZE_OFST 66
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_RX_DESC_CACHE_SIZE_LEN 1
+/* Size of TX descriptor cache expressed as binary logarithm The actual size
+ * equals (2 ^ TX_DESC_CACHE_SIZE)
+ */
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_TX_DESC_CACHE_SIZE_OFST 67
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_TX_DESC_CACHE_SIZE_LEN 1
+/* Total number of available PIO buffers */
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_NUM_PIO_BUFFS_OFST 68
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_NUM_PIO_BUFFS_LEN 2
+/* Size of a single PIO buffer */
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_SIZE_PIO_BUFF_OFST 70
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_SIZE_PIO_BUFF_LEN 2
+/* On chips later than Medford the amount of address space assigned to each VI
+ * is configurable. This is a global setting that the driver must query to
+ * discover the VI to address mapping. Cut-through PIO (CTPIO) is not available
+ * with 8k VI windows.
+ */
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_VI_WINDOW_MODE_OFST 72
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_VI_WINDOW_MODE_LEN 1
+/* enum: Each VI occupies 8k as on Huntington and Medford. PIO is at offset 4k.
+ * CTPIO is not mapped.
+ */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_VI_WINDOW_MODE_8K 0x0
+/* enum: Each VI occupies 16k. PIO is at offset 4k. CTPIO is at offset 12k. */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_VI_WINDOW_MODE_16K 0x1
+/* enum: Each VI occupies 64k. PIO is at offset 4k. CTPIO is at offset 12k. */
+#define          MC_CMD_GET_CAPABILITIES_V9_OUT_VI_WINDOW_MODE_64K 0x2
+/* Number of vFIFOs per adapter that can be used for VFIFO Stuffing
+ * (SF-115995-SW) in the present configuration of firmware and port mode.
+ */
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_VFIFO_STUFFING_NUM_VFIFOS_OFST 73
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_VFIFO_STUFFING_NUM_VFIFOS_LEN 1
+/* Number of buffers per adapter that can be used for VFIFO Stuffing
+ * (SF-115995-SW) in the present configuration of firmware and port mode.
+ */
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_VFIFO_STUFFING_NUM_CP_BUFFERS_OFST 74
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_VFIFO_STUFFING_NUM_CP_BUFFERS_LEN 2
+/* Entry count in the MAC stats array, including the final GENERATION_END
+ * entry. For MAC stats DMA, drivers should allocate a buffer large enough to
+ * hold at least this many 64-bit stats values, if they wish to receive all
+ * available stats. If the buffer is shorter than MAC_STATS_NUM_STATS * 8, the
+ * stats array returned will be truncated.
+ */
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_MAC_STATS_NUM_STATS_OFST 76
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_MAC_STATS_NUM_STATS_LEN 2
+/* Maximum supported value for MC_CMD_FILTER_OP_V3/MATCH_MARK_VALUE. This field
+ * will only be non-zero if MC_CMD_GET_CAPABILITIES/FILTER_ACTION_MARK is set.
+ */
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_FILTER_ACTION_MARK_MAX_OFST 80
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_FILTER_ACTION_MARK_MAX_LEN 4
+/* On devices where the INIT_RXQ_WITH_BUFFER_SIZE flag (in
+ * GET_CAPABILITIES_OUT_V2) is set, drivers have to specify a buffer size when
+ * they create an RX queue. Due to hardware limitations, only a small number of
+ * different buffer sizes may be available concurrently. Nonzero entries in
+ * this array are the sizes of buffers which the system guarantees will be
+ * available for use. If the list is empty, there are no limitations on
+ * concurrent buffer sizes.
+ */
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_GUARANTEED_RX_BUFFER_SIZES_OFST 84
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_GUARANTEED_RX_BUFFER_SIZES_LEN 4
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_GUARANTEED_RX_BUFFER_SIZES_NUM 16
+/* Third word of flags. Not present on older firmware (check the length). */
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_FLAGS3_OFST 148
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_FLAGS3_LEN 4
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_WOL_ETHERWAKE_OFST 148
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_WOL_ETHERWAKE_LBN 0
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_WOL_ETHERWAKE_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RSS_EVEN_SPREADING_OFST 148
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RSS_EVEN_SPREADING_LBN 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RSS_EVEN_SPREADING_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RSS_SELECTABLE_TABLE_SIZE_OFST 148
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RSS_SELECTABLE_TABLE_SIZE_LBN 2
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RSS_SELECTABLE_TABLE_SIZE_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_MAE_SUPPORTED_OFST 148
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_MAE_SUPPORTED_LBN 3
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_MAE_SUPPORTED_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_VDPA_SUPPORTED_OFST 148
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_VDPA_SUPPORTED_LBN 4
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_VDPA_SUPPORTED_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RX_VLAN_STRIPPING_PER_ENCAP_RULE_OFST 148
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RX_VLAN_STRIPPING_PER_ENCAP_RULE_LBN 5
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_RX_VLAN_STRIPPING_PER_ENCAP_RULE_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_EXTENDED_WIDTH_EVQS_SUPPORTED_OFST 148
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_EXTENDED_WIDTH_EVQS_SUPPORTED_LBN 6
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_EXTENDED_WIDTH_EVQS_SUPPORTED_WIDTH 1
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_UNSOL_EV_CREDIT_SUPPORTED_OFST 148
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_UNSOL_EV_CREDIT_SUPPORTED_LBN 7
+#define        MC_CMD_GET_CAPABILITIES_V9_OUT_UNSOL_EV_CREDIT_SUPPORTED_WIDTH 1
+/* These bits are reserved for communicating test-specific capabilities to
+ * host-side test software. All production drivers should treat this field as
+ * opaque.
+ */
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_TEST_RESERVED_OFST 152
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_TEST_RESERVED_LEN 8
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_TEST_RESERVED_LO_OFST 152
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_TEST_RESERVED_HI_OFST 156
+/* The minimum size (in table entries) of indirection table to be allocated
+ * from the pool for an RSS context. Note that the table size used must be a
+ * power of 2.
+ */
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_RSS_MIN_INDIRECTION_TABLE_SIZE_OFST 160
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_RSS_MIN_INDIRECTION_TABLE_SIZE_LEN 4
+/* The maximum size (in table entries) of indirection table to be allocated
+ * from the pool for an RSS context. Note that the table size used must be a
+ * power of 2.
+ */
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_RSS_MAX_INDIRECTION_TABLE_SIZE_OFST 164
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_RSS_MAX_INDIRECTION_TABLE_SIZE_LEN 4
+/* The maximum number of queues that can be used by an RSS context in exclusive
+ * mode. In exclusive mode the context has a configurable indirection table and
+ * a configurable RSS key.
+ */
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_RSS_MAX_INDIRECTION_QUEUES_OFST 168
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_RSS_MAX_INDIRECTION_QUEUES_LEN 4
+/* The maximum number of queues that can be used by an RSS context in even-
+ * spreading mode. In even-spreading mode the context has no indirection table
+ * but it does have a configurable RSS key.
+ */
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_RSS_MAX_EVEN_SPREADING_QUEUES_OFST 172
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_RSS_MAX_EVEN_SPREADING_QUEUES_LEN 4
+/* The total number of RSS contexts supported. Note that the number of
+ * available contexts using indirection tables is also limited by the
+ * availability of indirection table space allocated from a common pool.
+ */
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_RSS_NUM_CONTEXTS_OFST 176
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_RSS_NUM_CONTEXTS_LEN 4
+/* The total amount of indirection table space that can be shared between RSS
+ * contexts.
+ */
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_RSS_TABLE_POOL_SIZE_OFST 180
+#define       MC_CMD_GET_CAPABILITIES_V9_OUT_RSS_TABLE_POOL_SIZE_LEN 4
+
+
+/***********************************/
+/* MC_CMD_V2_EXTN
+ * Encapsulation for a v2 extended command
+ */
+#define MC_CMD_V2_EXTN 0x7f
+
+/* MC_CMD_V2_EXTN_IN msgrequest */
+#define    MC_CMD_V2_EXTN_IN_LEN 4
+/* the extended command number */
+#define       MC_CMD_V2_EXTN_IN_EXTENDED_CMD_LBN 0
+#define       MC_CMD_V2_EXTN_IN_EXTENDED_CMD_WIDTH 15
+#define       MC_CMD_V2_EXTN_IN_UNUSED_LBN 15
+#define       MC_CMD_V2_EXTN_IN_UNUSED_WIDTH 1
+/* the actual length of the encapsulated command (which is not in the v1
+ * header)
+ */
+#define       MC_CMD_V2_EXTN_IN_ACTUAL_LEN_LBN 16
+#define       MC_CMD_V2_EXTN_IN_ACTUAL_LEN_WIDTH 10
+#define       MC_CMD_V2_EXTN_IN_UNUSED2_LBN 26
+#define       MC_CMD_V2_EXTN_IN_UNUSED2_WIDTH 2
+/* Type of command/response */
+#define       MC_CMD_V2_EXTN_IN_MESSAGE_TYPE_LBN 28
+#define       MC_CMD_V2_EXTN_IN_MESSAGE_TYPE_WIDTH 4
+/* enum: MCDI command directed to or response originating from the MC. */
+#define          MC_CMD_V2_EXTN_IN_MCDI_MESSAGE_TYPE_MC 0x0
+/* enum: MCDI command directed to a TSA controller. MCDI responses of this type
+ * are not defined.
  */
 #define          MC_CMD_V2_EXTN_IN_MCDI_MESSAGE_TYPE_TSA 0x1
 
@@ -10858,6 +15558,7 @@
  * Allocate a pacer bucket (for qau rp or a snapper test)
  */
 #define MC_CMD_TCM_BUCKET_ALLOC 0xb2
+#undef MC_CMD_0xb2_PRIVILEGE_CTG
 
 #define MC_CMD_0xb2_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -10876,6 +15577,7 @@
  * Free a pacer bucket
  */
 #define MC_CMD_TCM_BUCKET_FREE 0xb3
+#undef MC_CMD_0xb3_PRIVILEGE_CTG
 
 #define MC_CMD_0xb3_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -10894,6 +15596,7 @@
  * Initialise pacer bucket with a given rate
  */
 #define MC_CMD_TCM_BUCKET_INIT 0xb4
+#undef MC_CMD_0xb4_PRIVILEGE_CTG
 
 #define MC_CMD_0xb4_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -10927,6 +15630,7 @@
  * Initialise txq in pacer with given options or set options
  */
 #define MC_CMD_TCM_TXQ_INIT 0xb5
+#undef MC_CMD_0xb5_PRIVILEGE_CTG
 
 #define MC_CMD_0xb5_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -10941,10 +15645,13 @@
 /* bitmask of the priority queues this txq is inserted into when inserted. */
 #define       MC_CMD_TCM_TXQ_INIT_IN_PQ_FLAGS_OFST 8
 #define       MC_CMD_TCM_TXQ_INIT_IN_PQ_FLAGS_LEN 4
+#define        MC_CMD_TCM_TXQ_INIT_IN_PQ_FLAG_GUARANTEED_OFST 8
 #define        MC_CMD_TCM_TXQ_INIT_IN_PQ_FLAG_GUARANTEED_LBN 0
 #define        MC_CMD_TCM_TXQ_INIT_IN_PQ_FLAG_GUARANTEED_WIDTH 1
+#define        MC_CMD_TCM_TXQ_INIT_IN_PQ_FLAG_NORMAL_OFST 8
 #define        MC_CMD_TCM_TXQ_INIT_IN_PQ_FLAG_NORMAL_LBN 1
 #define        MC_CMD_TCM_TXQ_INIT_IN_PQ_FLAG_NORMAL_WIDTH 1
+#define        MC_CMD_TCM_TXQ_INIT_IN_PQ_FLAG_LOW_OFST 8
 #define        MC_CMD_TCM_TXQ_INIT_IN_PQ_FLAG_LOW_LBN 2
 #define        MC_CMD_TCM_TXQ_INIT_IN_PQ_FLAG_LOW_WIDTH 1
 /* the reaction point (RP) bucket */
@@ -10975,10 +15682,13 @@
 /* bitmask of the priority queues this txq is inserted into when inserted. */
 #define       MC_CMD_TCM_TXQ_INIT_EXT_IN_PQ_FLAGS_OFST 8
 #define       MC_CMD_TCM_TXQ_INIT_EXT_IN_PQ_FLAGS_LEN 4
+#define        MC_CMD_TCM_TXQ_INIT_EXT_IN_PQ_FLAG_GUARANTEED_OFST 8
 #define        MC_CMD_TCM_TXQ_INIT_EXT_IN_PQ_FLAG_GUARANTEED_LBN 0
 #define        MC_CMD_TCM_TXQ_INIT_EXT_IN_PQ_FLAG_GUARANTEED_WIDTH 1
+#define        MC_CMD_TCM_TXQ_INIT_EXT_IN_PQ_FLAG_NORMAL_OFST 8
 #define        MC_CMD_TCM_TXQ_INIT_EXT_IN_PQ_FLAG_NORMAL_LBN 1
 #define        MC_CMD_TCM_TXQ_INIT_EXT_IN_PQ_FLAG_NORMAL_WIDTH 1
+#define        MC_CMD_TCM_TXQ_INIT_EXT_IN_PQ_FLAG_LOW_OFST 8
 #define        MC_CMD_TCM_TXQ_INIT_EXT_IN_PQ_FLAG_LOW_LBN 2
 #define        MC_CMD_TCM_TXQ_INIT_EXT_IN_PQ_FLAG_LOW_WIDTH 1
 /* the reaction point (RP) bucket */
@@ -11010,6 +15720,7 @@
  * Link a push I/O buffer to a TxQ
  */
 #define MC_CMD_LINK_PIOBUF 0x92
+#undef MC_CMD_0x92_PRIVILEGE_CTG
 
 #define MC_CMD_0x92_PRIVILEGE_CTG SRIOV_CTG_ONLOAD
 
@@ -11031,6 +15742,7 @@
  * Unlink a push I/O buffer from a TxQ
  */
 #define MC_CMD_UNLINK_PIOBUF 0x93
+#undef MC_CMD_0x93_PRIVILEGE_CTG
 
 #define MC_CMD_0x93_PRIVILEGE_CTG SRIOV_CTG_ONLOAD
 
@@ -11049,6 +15761,7 @@
  * allocate and initialise a v-switch.
  */
 #define MC_CMD_VSWITCH_ALLOC 0x94
+#undef MC_CMD_0x94_PRIVILEGE_CTG
 
 #define MC_CMD_0x94_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -11073,6 +15786,7 @@
 /* Flags controlling v-port creation */
 #define       MC_CMD_VSWITCH_ALLOC_IN_FLAGS_OFST 8
 #define       MC_CMD_VSWITCH_ALLOC_IN_FLAGS_LEN 4
+#define        MC_CMD_VSWITCH_ALLOC_IN_FLAG_AUTO_PORT_OFST 8
 #define        MC_CMD_VSWITCH_ALLOC_IN_FLAG_AUTO_PORT_LBN 0
 #define        MC_CMD_VSWITCH_ALLOC_IN_FLAG_AUTO_PORT_WIDTH 1
 /* The number of VLAN tags to allow for attached v-ports. For VLAN aggregators,
@@ -11094,6 +15808,7 @@
  * de-allocate a v-switch.
  */
 #define MC_CMD_VSWITCH_FREE 0x95
+#undef MC_CMD_0x95_PRIVILEGE_CTG
 
 #define MC_CMD_0x95_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -11114,6 +15829,7 @@
  * not, then the command returns ENOENT).
  */
 #define MC_CMD_VSWITCH_QUERY 0x63
+#undef MC_CMD_0x63_PRIVILEGE_CTG
 
 #define MC_CMD_0x63_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -11132,6 +15848,7 @@
  * allocate a v-port.
  */
 #define MC_CMD_VPORT_ALLOC 0x96
+#undef MC_CMD_0x96_PRIVILEGE_CTG
 
 #define MC_CMD_0x96_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -11164,8 +15881,10 @@
 /* Flags controlling v-port creation */
 #define       MC_CMD_VPORT_ALLOC_IN_FLAGS_OFST 8
 #define       MC_CMD_VPORT_ALLOC_IN_FLAGS_LEN 4
+#define        MC_CMD_VPORT_ALLOC_IN_FLAG_AUTO_PORT_OFST 8
 #define        MC_CMD_VPORT_ALLOC_IN_FLAG_AUTO_PORT_LBN 0
 #define        MC_CMD_VPORT_ALLOC_IN_FLAG_AUTO_PORT_WIDTH 1
+#define        MC_CMD_VPORT_ALLOC_IN_FLAG_VLAN_RESTRICT_OFST 8
 #define        MC_CMD_VPORT_ALLOC_IN_FLAG_VLAN_RESTRICT_LBN 1
 #define        MC_CMD_VPORT_ALLOC_IN_FLAG_VLAN_RESTRICT_WIDTH 1
 /* The number of VLAN tags to insert/remove. An error will be returned if
@@ -11177,8 +15896,10 @@
 /* The actual VLAN tags to insert/remove */
 #define       MC_CMD_VPORT_ALLOC_IN_VLAN_TAGS_OFST 16
 #define       MC_CMD_VPORT_ALLOC_IN_VLAN_TAGS_LEN 4
+#define        MC_CMD_VPORT_ALLOC_IN_VLAN_TAG_0_OFST 16
 #define        MC_CMD_VPORT_ALLOC_IN_VLAN_TAG_0_LBN 0
 #define        MC_CMD_VPORT_ALLOC_IN_VLAN_TAG_0_WIDTH 16
+#define        MC_CMD_VPORT_ALLOC_IN_VLAN_TAG_1_OFST 16
 #define        MC_CMD_VPORT_ALLOC_IN_VLAN_TAG_1_LBN 16
 #define        MC_CMD_VPORT_ALLOC_IN_VLAN_TAG_1_WIDTH 16
 
@@ -11194,6 +15915,7 @@
  * de-allocate a v-port.
  */
 #define MC_CMD_VPORT_FREE 0x97
+#undef MC_CMD_0x97_PRIVILEGE_CTG
 
 #define MC_CMD_0x97_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -11212,6 +15934,7 @@
  * allocate a v-adaptor.
  */
 #define MC_CMD_VADAPTOR_ALLOC 0x98
+#undef MC_CMD_0x98_PRIVILEGE_CTG
 
 #define MC_CMD_0x98_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -11223,8 +15946,10 @@
 /* Flags controlling v-adaptor creation */
 #define       MC_CMD_VADAPTOR_ALLOC_IN_FLAGS_OFST 8
 #define       MC_CMD_VADAPTOR_ALLOC_IN_FLAGS_LEN 4
+#define        MC_CMD_VADAPTOR_ALLOC_IN_FLAG_AUTO_VADAPTOR_OFST 8
 #define        MC_CMD_VADAPTOR_ALLOC_IN_FLAG_AUTO_VADAPTOR_LBN 0
 #define        MC_CMD_VADAPTOR_ALLOC_IN_FLAG_AUTO_VADAPTOR_WIDTH 1
+#define        MC_CMD_VADAPTOR_ALLOC_IN_FLAG_PERMIT_SET_MAC_WHEN_FILTERS_INSTALLED_OFST 8
 #define        MC_CMD_VADAPTOR_ALLOC_IN_FLAG_PERMIT_SET_MAC_WHEN_FILTERS_INSTALLED_LBN 1
 #define        MC_CMD_VADAPTOR_ALLOC_IN_FLAG_PERMIT_SET_MAC_WHEN_FILTERS_INSTALLED_WIDTH 1
 /* The number of VLAN tags to strip on receive */
@@ -11236,8 +15961,10 @@
 /* The actual VLAN tags to insert/remove */
 #define       MC_CMD_VADAPTOR_ALLOC_IN_VLAN_TAGS_OFST 20
 #define       MC_CMD_VADAPTOR_ALLOC_IN_VLAN_TAGS_LEN 4
+#define        MC_CMD_VADAPTOR_ALLOC_IN_VLAN_TAG_0_OFST 20
 #define        MC_CMD_VADAPTOR_ALLOC_IN_VLAN_TAG_0_LBN 0
 #define        MC_CMD_VADAPTOR_ALLOC_IN_VLAN_TAG_0_WIDTH 16
+#define        MC_CMD_VADAPTOR_ALLOC_IN_VLAN_TAG_1_OFST 20
 #define        MC_CMD_VADAPTOR_ALLOC_IN_VLAN_TAG_1_LBN 16
 #define        MC_CMD_VADAPTOR_ALLOC_IN_VLAN_TAG_1_WIDTH 16
 /* The MAC address to assign to this v-adaptor */
@@ -11255,6 +15982,7 @@
  * de-allocate a v-adaptor.
  */
 #define MC_CMD_VADAPTOR_FREE 0x99
+#undef MC_CMD_0x99_PRIVILEGE_CTG
 
 #define MC_CMD_0x99_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -11273,6 +16001,7 @@
  * assign a new MAC address to a v-adaptor.
  */
 #define MC_CMD_VADAPTOR_SET_MAC 0x5d
+#undef MC_CMD_0x5d_PRIVILEGE_CTG
 
 #define MC_CMD_0x5d_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -11294,6 +16023,7 @@
  * read the MAC address assigned to a v-adaptor.
  */
 #define MC_CMD_VADAPTOR_GET_MAC 0x5e
+#undef MC_CMD_0x5e_PRIVILEGE_CTG
 
 #define MC_CMD_0x5e_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -11315,6 +16045,7 @@
  * read some config of v-adaptor.
  */
 #define MC_CMD_VADAPTOR_QUERY 0x61
+#undef MC_CMD_0x61_PRIVILEGE_CTG
 
 #define MC_CMD_0x61_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -11342,6 +16073,7 @@
  * assign a port to a PCI function.
  */
 #define MC_CMD_EVB_PORT_ASSIGN 0x9a
+#undef MC_CMD_0x9a_PRIVILEGE_CTG
 
 #define MC_CMD_0x9a_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -11353,8 +16085,10 @@
 /* The target function to modify. */
 #define       MC_CMD_EVB_PORT_ASSIGN_IN_FUNCTION_OFST 4
 #define       MC_CMD_EVB_PORT_ASSIGN_IN_FUNCTION_LEN 4
+#define        MC_CMD_EVB_PORT_ASSIGN_IN_PF_OFST 4
 #define        MC_CMD_EVB_PORT_ASSIGN_IN_PF_LBN 0
 #define        MC_CMD_EVB_PORT_ASSIGN_IN_PF_WIDTH 16
+#define        MC_CMD_EVB_PORT_ASSIGN_IN_VF_OFST 4
 #define        MC_CMD_EVB_PORT_ASSIGN_IN_VF_LBN 16
 #define        MC_CMD_EVB_PORT_ASSIGN_IN_VF_WIDTH 16
 
@@ -11367,6 +16101,7 @@
  * Assign the 64 bit region addresses.
  */
 #define MC_CMD_RDWR_A64_REGIONS 0x9b
+#undef MC_CMD_0x9b_PRIVILEGE_CTG
 
 #define MC_CMD_0x9b_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
@@ -11405,6 +16140,7 @@
  * Allocate an Onload stack ID.
  */
 #define MC_CMD_ONLOAD_STACK_ALLOC 0x9c
+#undef MC_CMD_0x9c_PRIVILEGE_CTG
 
 #define MC_CMD_0x9c_PRIVILEGE_CTG SRIOV_CTG_ONLOAD
 
@@ -11426,6 +16162,7 @@
  * Free an Onload stack ID.
  */
 #define MC_CMD_ONLOAD_STACK_FREE 0x9d
+#undef MC_CMD_0x9d_PRIVILEGE_CTG
 
 #define MC_CMD_0x9d_PRIVILEGE_CTG SRIOV_CTG_ONLOAD
 
@@ -11444,6 +16181,7 @@
  * Allocate an RSS context.
  */
 #define MC_CMD_RSS_CONTEXT_ALLOC 0x9e
+#undef MC_CMD_0x9e_PRIVILEGE_CTG
 
 #define MC_CMD_0x9e_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -11464,12 +16202,68 @@
  * changed. For this mode, NUM_QUEUES must 2, 4, 8, 16, 32 or 64.
  */
 #define          MC_CMD_RSS_CONTEXT_ALLOC_IN_TYPE_SHARED 0x1
-/* Number of queues spanned by this context, in the range 1-64; valid offsets
- * in the indirection table will be in the range 0 to NUM_QUEUES-1.
+/* enum: Allocate a context to spread evenly across an arbitrary number of
+ * queues. No indirection table space is allocated for this context. (EF100 and
+ * later)
+ */
+#define          MC_CMD_RSS_CONTEXT_ALLOC_IN_TYPE_EVEN_SPREADING 0x2
+/* Number of queues spanned by this context. For exclusive contexts this must
+ * be in the range 1 to RSS_MAX_INDIRECTION_QUEUES, where
+ * RSS_MAX_INDIRECTION_QUEUES is queried from MC_CMD_GET_CAPABILITIES_V9 or if
+ * V9 is not supported then RSS_MAX_INDIRECTION_QUEUES is 64. Valid entries in
+ * the indirection table will be in the range 0 to NUM_QUEUES-1. For even-
+ * spreading contexts this must be in the range 1 to
+ * RSS_MAX_EVEN_SPREADING_QUEUES as queried from MC_CMD_GET_CAPABILITIES. Note
+ * that specifying NUM_QUEUES = 1 will not perform any spreading but may still
+ * be useful as a way of obtaining the Toeplitz hash.
  */
 #define       MC_CMD_RSS_CONTEXT_ALLOC_IN_NUM_QUEUES_OFST 8
 #define       MC_CMD_RSS_CONTEXT_ALLOC_IN_NUM_QUEUES_LEN 4
 
+/* MC_CMD_RSS_CONTEXT_ALLOC_V2_IN msgrequest */
+#define    MC_CMD_RSS_CONTEXT_ALLOC_V2_IN_LEN 16
+/* The handle of the owning upstream port */
+#define       MC_CMD_RSS_CONTEXT_ALLOC_V2_IN_UPSTREAM_PORT_ID_OFST 0
+#define       MC_CMD_RSS_CONTEXT_ALLOC_V2_IN_UPSTREAM_PORT_ID_LEN 4
+/* The type of context to allocate */
+#define       MC_CMD_RSS_CONTEXT_ALLOC_V2_IN_TYPE_OFST 4
+#define       MC_CMD_RSS_CONTEXT_ALLOC_V2_IN_TYPE_LEN 4
+/* enum: Allocate a context for exclusive use. The key and indirection table
+ * must be explicitly configured.
+ */
+#define          MC_CMD_RSS_CONTEXT_ALLOC_V2_IN_TYPE_EXCLUSIVE 0x0
+/* enum: Allocate a context for shared use; this will spread across a range of
+ * queues, but the key and indirection table are pre-configured and may not be
+ * changed. For this mode, NUM_QUEUES must 2, 4, 8, 16, 32 or 64.
+ */
+#define          MC_CMD_RSS_CONTEXT_ALLOC_V2_IN_TYPE_SHARED 0x1
+/* enum: Allocate a context to spread evenly across an arbitrary number of
+ * queues. No indirection table space is allocated for this context. (EF100 and
+ * later)
+ */
+#define          MC_CMD_RSS_CONTEXT_ALLOC_V2_IN_TYPE_EVEN_SPREADING 0x2
+/* Number of queues spanned by this context. For exclusive contexts this must
+ * be in the range 1 to RSS_MAX_INDIRECTION_QUEUES, where
+ * RSS_MAX_INDIRECTION_QUEUES is queried from MC_CMD_GET_CAPABILITIES_V9 or if
+ * V9 is not supported then RSS_MAX_INDIRECTION_QUEUES is 64. Valid entries in
+ * the indirection table will be in the range 0 to NUM_QUEUES-1. For even-
+ * spreading contexts this must be in the range 1 to
+ * RSS_MAX_EVEN_SPREADING_QUEUES as queried from MC_CMD_GET_CAPABILITIES. Note
+ * that specifying NUM_QUEUES = 1 will not perform any spreading but may still
+ * be useful as a way of obtaining the Toeplitz hash.
+ */
+#define       MC_CMD_RSS_CONTEXT_ALLOC_V2_IN_NUM_QUEUES_OFST 8
+#define       MC_CMD_RSS_CONTEXT_ALLOC_V2_IN_NUM_QUEUES_LEN 4
+/* Size of indirection table to be allocated to this context from the pool.
+ * Must be a power of 2. The minimum and maximum table size can be queried
+ * using MC_CMD_GET_CAPABILITIES_V9. If there is not enough space remaining in
+ * the common pool to allocate the requested table size, due to allocating
+ * table space to other RSS contexts, then the command will fail with
+ * MC_CMD_ERR_ENOSPC.
+ */
+#define       MC_CMD_RSS_CONTEXT_ALLOC_V2_IN_INDIRECTION_TABLE_SIZE_OFST 12
+#define       MC_CMD_RSS_CONTEXT_ALLOC_V2_IN_INDIRECTION_TABLE_SIZE_LEN 4
+
 /* MC_CMD_RSS_CONTEXT_ALLOC_OUT msgresponse */
 #define    MC_CMD_RSS_CONTEXT_ALLOC_OUT_LEN 4
 /* The handle of the new RSS context. This should be considered opaque to the
@@ -11487,6 +16281,7 @@
  * Free an RSS context.
  */
 #define MC_CMD_RSS_CONTEXT_FREE 0x9f
+#undef MC_CMD_0x9f_PRIVILEGE_CTG
 
 #define MC_CMD_0x9f_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -11505,6 +16300,7 @@
  * Set the Toeplitz hash key for an RSS context.
  */
 #define MC_CMD_RSS_CONTEXT_SET_KEY 0xa0
+#undef MC_CMD_0xa0_PRIVILEGE_CTG
 
 #define MC_CMD_0xa0_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -11526,6 +16322,7 @@
  * Get the Toeplitz hash key for an RSS context.
  */
 #define MC_CMD_RSS_CONTEXT_GET_KEY 0xa1
+#undef MC_CMD_0xa1_PRIVILEGE_CTG
 
 #define MC_CMD_0xa1_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -11544,9 +16341,12 @@
 
 /***********************************/
 /* MC_CMD_RSS_CONTEXT_SET_TABLE
- * Set the indirection table for an RSS context.
+ * Set the indirection table for an RSS context. This command should only be
+ * used with indirection tables containing 128 entries, which is the default
+ * when the RSS context is allocated without specifying a table size.
  */
 #define MC_CMD_RSS_CONTEXT_SET_TABLE 0xa2
+#undef MC_CMD_0xa2_PRIVILEGE_CTG
 
 #define MC_CMD_0xa2_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -11565,9 +16365,12 @@
 
 /***********************************/
 /* MC_CMD_RSS_CONTEXT_GET_TABLE
- * Get the indirection table for an RSS context.
+ * Get the indirection table for an RSS context. This command should only be
+ * used with indirection tables containing 128 entries, which is the default
+ * when the RSS context is allocated without specifying a table size.
  */
 #define MC_CMD_RSS_CONTEXT_GET_TABLE 0xa3
+#undef MC_CMD_0xa3_PRIVILEGE_CTG
 
 #define MC_CMD_0xa3_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -11584,11 +16387,99 @@
 #define       MC_CMD_RSS_CONTEXT_GET_TABLE_OUT_INDIRECTION_TABLE_LEN 128
 
 
+/***********************************/
+/* MC_CMD_RSS_CONTEXT_WRITE_TABLE
+ * Write a portion of a selectable-size indirection table for an RSS context.
+ * This command must be used instead of MC_CMD_RSS_CONTEXT_SET_TABLE if the
+ * RSS_SELECTABLE_TABLE_SIZE bit is set in MC_CMD_GET_CAPABILITIES.
+ */
+#define MC_CMD_RSS_CONTEXT_WRITE_TABLE 0x13e
+#undef MC_CMD_0x13e_PRIVILEGE_CTG
+
+#define MC_CMD_0x13e_PRIVILEGE_CTG SRIOV_CTG_GENERAL
+
+/* MC_CMD_RSS_CONTEXT_WRITE_TABLE_IN msgrequest */
+#define    MC_CMD_RSS_CONTEXT_WRITE_TABLE_IN_LENMIN 8
+#define    MC_CMD_RSS_CONTEXT_WRITE_TABLE_IN_LENMAX 252
+#define    MC_CMD_RSS_CONTEXT_WRITE_TABLE_IN_LENMAX_MCDI2 1020
+#define    MC_CMD_RSS_CONTEXT_WRITE_TABLE_IN_LEN(num) (4+4*(num))
+#define    MC_CMD_RSS_CONTEXT_WRITE_TABLE_IN_ENTRIES_NUM(len) (((len)-4)/4)
+/* The handle of the RSS context */
+#define       MC_CMD_RSS_CONTEXT_WRITE_TABLE_IN_RSS_CONTEXT_ID_OFST 0
+#define       MC_CMD_RSS_CONTEXT_WRITE_TABLE_IN_RSS_CONTEXT_ID_LEN 4
+/* An array of index-value pairs to be written to the table. Structure is
+ * MC_CMD_RSS_CONTEXT_WRITE_TABLE_ENTRY.
+ */
+#define       MC_CMD_RSS_CONTEXT_WRITE_TABLE_IN_ENTRIES_OFST 4
+#define       MC_CMD_RSS_CONTEXT_WRITE_TABLE_IN_ENTRIES_LEN 4
+#define       MC_CMD_RSS_CONTEXT_WRITE_TABLE_IN_ENTRIES_MINNUM 1
+#define       MC_CMD_RSS_CONTEXT_WRITE_TABLE_IN_ENTRIES_MAXNUM 62
+#define       MC_CMD_RSS_CONTEXT_WRITE_TABLE_IN_ENTRIES_MAXNUM_MCDI2 254
+
+/* MC_CMD_RSS_CONTEXT_WRITE_TABLE_OUT msgresponse */
+#define    MC_CMD_RSS_CONTEXT_WRITE_TABLE_OUT_LEN 0
+
+/* MC_CMD_RSS_CONTEXT_WRITE_TABLE_ENTRY structuredef */
+#define    MC_CMD_RSS_CONTEXT_WRITE_TABLE_ENTRY_LEN 4
+/* The index of the table entry to be written. */
+#define       MC_CMD_RSS_CONTEXT_WRITE_TABLE_ENTRY_INDEX_OFST 0
+#define       MC_CMD_RSS_CONTEXT_WRITE_TABLE_ENTRY_INDEX_LEN 2
+#define       MC_CMD_RSS_CONTEXT_WRITE_TABLE_ENTRY_INDEX_LBN 0
+#define       MC_CMD_RSS_CONTEXT_WRITE_TABLE_ENTRY_INDEX_WIDTH 16
+/* The value to write into the table entry. */
+#define       MC_CMD_RSS_CONTEXT_WRITE_TABLE_ENTRY_VALUE_OFST 2
+#define       MC_CMD_RSS_CONTEXT_WRITE_TABLE_ENTRY_VALUE_LEN 2
+#define       MC_CMD_RSS_CONTEXT_WRITE_TABLE_ENTRY_VALUE_LBN 16
+#define       MC_CMD_RSS_CONTEXT_WRITE_TABLE_ENTRY_VALUE_WIDTH 16
+
+
+/***********************************/
+/* MC_CMD_RSS_CONTEXT_READ_TABLE
+ * Read a portion of a selectable-size indirection table for an RSS context.
+ * This command must be used instead of MC_CMD_RSS_CONTEXT_GET_TABLE if the
+ * RSS_SELECTABLE_TABLE_SIZE bit is set in MC_CMD_GET_CAPABILITIES.
+ */
+#define MC_CMD_RSS_CONTEXT_READ_TABLE 0x13f
+#undef MC_CMD_0x13f_PRIVILEGE_CTG
+
+#define MC_CMD_0x13f_PRIVILEGE_CTG SRIOV_CTG_GENERAL
+
+/* MC_CMD_RSS_CONTEXT_READ_TABLE_IN msgrequest */
+#define    MC_CMD_RSS_CONTEXT_READ_TABLE_IN_LENMIN 6
+#define    MC_CMD_RSS_CONTEXT_READ_TABLE_IN_LENMAX 252
+#define    MC_CMD_RSS_CONTEXT_READ_TABLE_IN_LENMAX_MCDI2 1020
+#define    MC_CMD_RSS_CONTEXT_READ_TABLE_IN_LEN(num) (4+2*(num))
+#define    MC_CMD_RSS_CONTEXT_READ_TABLE_IN_INDICES_NUM(len) (((len)-4)/2)
+/* The handle of the RSS context */
+#define       MC_CMD_RSS_CONTEXT_READ_TABLE_IN_RSS_CONTEXT_ID_OFST 0
+#define       MC_CMD_RSS_CONTEXT_READ_TABLE_IN_RSS_CONTEXT_ID_LEN 4
+/* An array containing the indices of the entries to be read. */
+#define       MC_CMD_RSS_CONTEXT_READ_TABLE_IN_INDICES_OFST 4
+#define       MC_CMD_RSS_CONTEXT_READ_TABLE_IN_INDICES_LEN 2
+#define       MC_CMD_RSS_CONTEXT_READ_TABLE_IN_INDICES_MINNUM 1
+#define       MC_CMD_RSS_CONTEXT_READ_TABLE_IN_INDICES_MAXNUM 124
+#define       MC_CMD_RSS_CONTEXT_READ_TABLE_IN_INDICES_MAXNUM_MCDI2 508
+
+/* MC_CMD_RSS_CONTEXT_READ_TABLE_OUT msgresponse */
+#define    MC_CMD_RSS_CONTEXT_READ_TABLE_OUT_LENMIN 2
+#define    MC_CMD_RSS_CONTEXT_READ_TABLE_OUT_LENMAX 252
+#define    MC_CMD_RSS_CONTEXT_READ_TABLE_OUT_LENMAX_MCDI2 1020
+#define    MC_CMD_RSS_CONTEXT_READ_TABLE_OUT_LEN(num) (0+2*(num))
+#define    MC_CMD_RSS_CONTEXT_READ_TABLE_OUT_DATA_NUM(len) (((len)-0)/2)
+/* A buffer containing the requested entries read from the table. */
+#define       MC_CMD_RSS_CONTEXT_READ_TABLE_OUT_DATA_OFST 0
+#define       MC_CMD_RSS_CONTEXT_READ_TABLE_OUT_DATA_LEN 2
+#define       MC_CMD_RSS_CONTEXT_READ_TABLE_OUT_DATA_MINNUM 1
+#define       MC_CMD_RSS_CONTEXT_READ_TABLE_OUT_DATA_MAXNUM 126
+#define       MC_CMD_RSS_CONTEXT_READ_TABLE_OUT_DATA_MAXNUM_MCDI2 510
+
+
 /***********************************/
 /* MC_CMD_RSS_CONTEXT_SET_FLAGS
  * Set various control flags for an RSS context.
  */
 #define MC_CMD_RSS_CONTEXT_SET_FLAGS 0xe1
+#undef MC_CMD_0xe1_PRIVILEGE_CTG
 
 #define MC_CMD_0xe1_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -11611,26 +16502,37 @@
  */
 #define       MC_CMD_RSS_CONTEXT_SET_FLAGS_IN_FLAGS_OFST 4
 #define       MC_CMD_RSS_CONTEXT_SET_FLAGS_IN_FLAGS_LEN 4
+#define        MC_CMD_RSS_CONTEXT_SET_FLAGS_IN_TOEPLITZ_IPV4_EN_OFST 4
 #define        MC_CMD_RSS_CONTEXT_SET_FLAGS_IN_TOEPLITZ_IPV4_EN_LBN 0
 #define        MC_CMD_RSS_CONTEXT_SET_FLAGS_IN_TOEPLITZ_IPV4_EN_WIDTH 1
+#define        MC_CMD_RSS_CONTEXT_SET_FLAGS_IN_TOEPLITZ_TCPV4_EN_OFST 4
 #define        MC_CMD_RSS_CONTEXT_SET_FLAGS_IN_TOEPLITZ_TCPV4_EN_LBN 1
 #define        MC_CMD_RSS_CONTEXT_SET_FLAGS_IN_TOEPLITZ_TCPV4_EN_WIDTH 1
+#define        MC_CMD_RSS_CONTEXT_SET_FLAGS_IN_TOEPLITZ_IPV6_EN_OFST 4
 #define        MC_CMD_RSS_CONTEXT_SET_FLAGS_IN_TOEPLITZ_IPV6_EN_LBN 2
 #define        MC_CMD_RSS_CONTEXT_SET_FLAGS_IN_TOEPLITZ_IPV6_EN_WIDTH 1
+#define        MC_CMD_RSS_CONTEXT_SET_FLAGS_IN_TOEPLITZ_TCPV6_EN_OFST 4
 #define        MC_CMD_RSS_CONTEXT_SET_FLAGS_IN_TOEPLITZ_TCPV6_EN_LBN 3
 #define        MC_CMD_RSS_CONTEXT_SET_FLAGS_IN_TOEPLITZ_TCPV6_EN_WIDTH 1
+#define        MC_CMD_RSS_CONTEXT_SET_FLAGS_IN_RESERVED_OFST 4
 #define        MC_CMD_RSS_CONTEXT_SET_FLAGS_IN_RESERVED_LBN 4
 #define        MC_CMD_RSS_CONTEXT_SET_FLAGS_IN_RESERVED_WIDTH 4
+#define        MC_CMD_RSS_CONTEXT_SET_FLAGS_IN_TCP_IPV4_RSS_MODE_OFST 4
 #define        MC_CMD_RSS_CONTEXT_SET_FLAGS_IN_TCP_IPV4_RSS_MODE_LBN 8
 #define        MC_CMD_RSS_CONTEXT_SET_FLAGS_IN_TCP_IPV4_RSS_MODE_WIDTH 4
+#define        MC_CMD_RSS_CONTEXT_SET_FLAGS_IN_UDP_IPV4_RSS_MODE_OFST 4
 #define        MC_CMD_RSS_CONTEXT_SET_FLAGS_IN_UDP_IPV4_RSS_MODE_LBN 12
 #define        MC_CMD_RSS_CONTEXT_SET_FLAGS_IN_UDP_IPV4_RSS_MODE_WIDTH 4
+#define        MC_CMD_RSS_CONTEXT_SET_FLAGS_IN_OTHER_IPV4_RSS_MODE_OFST 4
 #define        MC_CMD_RSS_CONTEXT_SET_FLAGS_IN_OTHER_IPV4_RSS_MODE_LBN 16
 #define        MC_CMD_RSS_CONTEXT_SET_FLAGS_IN_OTHER_IPV4_RSS_MODE_WIDTH 4
+#define        MC_CMD_RSS_CONTEXT_SET_FLAGS_IN_TCP_IPV6_RSS_MODE_OFST 4
 #define        MC_CMD_RSS_CONTEXT_SET_FLAGS_IN_TCP_IPV6_RSS_MODE_LBN 20
 #define        MC_CMD_RSS_CONTEXT_SET_FLAGS_IN_TCP_IPV6_RSS_MODE_WIDTH 4
+#define        MC_CMD_RSS_CONTEXT_SET_FLAGS_IN_UDP_IPV6_RSS_MODE_OFST 4
 #define        MC_CMD_RSS_CONTEXT_SET_FLAGS_IN_UDP_IPV6_RSS_MODE_LBN 24
 #define        MC_CMD_RSS_CONTEXT_SET_FLAGS_IN_UDP_IPV6_RSS_MODE_WIDTH 4
+#define        MC_CMD_RSS_CONTEXT_SET_FLAGS_IN_OTHER_IPV6_RSS_MODE_OFST 4
 #define        MC_CMD_RSS_CONTEXT_SET_FLAGS_IN_OTHER_IPV6_RSS_MODE_LBN 28
 #define        MC_CMD_RSS_CONTEXT_SET_FLAGS_IN_OTHER_IPV6_RSS_MODE_WIDTH 4
 
@@ -11643,6 +16545,7 @@
  * Get various control flags for an RSS context.
  */
 #define MC_CMD_RSS_CONTEXT_GET_FLAGS 0xe2
+#undef MC_CMD_0xe2_PRIVILEGE_CTG
 
 #define MC_CMD_0xe2_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -11669,26 +16572,37 @@
  */
 #define       MC_CMD_RSS_CONTEXT_GET_FLAGS_OUT_FLAGS_OFST 4
 #define       MC_CMD_RSS_CONTEXT_GET_FLAGS_OUT_FLAGS_LEN 4
+#define        MC_CMD_RSS_CONTEXT_GET_FLAGS_OUT_TOEPLITZ_IPV4_EN_OFST 4
 #define        MC_CMD_RSS_CONTEXT_GET_FLAGS_OUT_TOEPLITZ_IPV4_EN_LBN 0
 #define        MC_CMD_RSS_CONTEXT_GET_FLAGS_OUT_TOEPLITZ_IPV4_EN_WIDTH 1
+#define        MC_CMD_RSS_CONTEXT_GET_FLAGS_OUT_TOEPLITZ_TCPV4_EN_OFST 4
 #define        MC_CMD_RSS_CONTEXT_GET_FLAGS_OUT_TOEPLITZ_TCPV4_EN_LBN 1
 #define        MC_CMD_RSS_CONTEXT_GET_FLAGS_OUT_TOEPLITZ_TCPV4_EN_WIDTH 1
+#define        MC_CMD_RSS_CONTEXT_GET_FLAGS_OUT_TOEPLITZ_IPV6_EN_OFST 4
 #define        MC_CMD_RSS_CONTEXT_GET_FLAGS_OUT_TOEPLITZ_IPV6_EN_LBN 2
 #define        MC_CMD_RSS_CONTEXT_GET_FLAGS_OUT_TOEPLITZ_IPV6_EN_WIDTH 1
+#define        MC_CMD_RSS_CONTEXT_GET_FLAGS_OUT_TOEPLITZ_TCPV6_EN_OFST 4
 #define        MC_CMD_RSS_CONTEXT_GET_FLAGS_OUT_TOEPLITZ_TCPV6_EN_LBN 3
 #define        MC_CMD_RSS_CONTEXT_GET_FLAGS_OUT_TOEPLITZ_TCPV6_EN_WIDTH 1
+#define        MC_CMD_RSS_CONTEXT_GET_FLAGS_OUT_RESERVED_OFST 4
 #define        MC_CMD_RSS_CONTEXT_GET_FLAGS_OUT_RESERVED_LBN 4
 #define        MC_CMD_RSS_CONTEXT_GET_FLAGS_OUT_RESERVED_WIDTH 4
+#define        MC_CMD_RSS_CONTEXT_GET_FLAGS_OUT_TCP_IPV4_RSS_MODE_OFST 4
 #define        MC_CMD_RSS_CONTEXT_GET_FLAGS_OUT_TCP_IPV4_RSS_MODE_LBN 8
 #define        MC_CMD_RSS_CONTEXT_GET_FLAGS_OUT_TCP_IPV4_RSS_MODE_WIDTH 4
+#define        MC_CMD_RSS_CONTEXT_GET_FLAGS_OUT_UDP_IPV4_RSS_MODE_OFST 4
 #define        MC_CMD_RSS_CONTEXT_GET_FLAGS_OUT_UDP_IPV4_RSS_MODE_LBN 12
 #define        MC_CMD_RSS_CONTEXT_GET_FLAGS_OUT_UDP_IPV4_RSS_MODE_WIDTH 4
+#define        MC_CMD_RSS_CONTEXT_GET_FLAGS_OUT_OTHER_IPV4_RSS_MODE_OFST 4
 #define        MC_CMD_RSS_CONTEXT_GET_FLAGS_OUT_OTHER_IPV4_RSS_MODE_LBN 16
 #define        MC_CMD_RSS_CONTEXT_GET_FLAGS_OUT_OTHER_IPV4_RSS_MODE_WIDTH 4
+#define        MC_CMD_RSS_CONTEXT_GET_FLAGS_OUT_TCP_IPV6_RSS_MODE_OFST 4
 #define        MC_CMD_RSS_CONTEXT_GET_FLAGS_OUT_TCP_IPV6_RSS_MODE_LBN 20
 #define        MC_CMD_RSS_CONTEXT_GET_FLAGS_OUT_TCP_IPV6_RSS_MODE_WIDTH 4
+#define        MC_CMD_RSS_CONTEXT_GET_FLAGS_OUT_UDP_IPV6_RSS_MODE_OFST 4
 #define        MC_CMD_RSS_CONTEXT_GET_FLAGS_OUT_UDP_IPV6_RSS_MODE_LBN 24
 #define        MC_CMD_RSS_CONTEXT_GET_FLAGS_OUT_UDP_IPV6_RSS_MODE_WIDTH 4
+#define        MC_CMD_RSS_CONTEXT_GET_FLAGS_OUT_OTHER_IPV6_RSS_MODE_OFST 4
 #define        MC_CMD_RSS_CONTEXT_GET_FLAGS_OUT_OTHER_IPV6_RSS_MODE_LBN 28
 #define        MC_CMD_RSS_CONTEXT_GET_FLAGS_OUT_OTHER_IPV6_RSS_MODE_WIDTH 4
 
@@ -11698,6 +16612,7 @@
  * Allocate a .1p mapping.
  */
 #define MC_CMD_DOT1P_MAPPING_ALLOC 0xa4
+#undef MC_CMD_0xa4_PRIVILEGE_CTG
 
 #define MC_CMD_0xa4_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
@@ -11730,6 +16645,7 @@
  * Free a .1p mapping.
  */
 #define MC_CMD_DOT1P_MAPPING_FREE 0xa5
+#undef MC_CMD_0xa5_PRIVILEGE_CTG
 
 #define MC_CMD_0xa5_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
@@ -11748,6 +16664,7 @@
  * Set the mapping table for a .1p mapping.
  */
 #define MC_CMD_DOT1P_MAPPING_SET_TABLE 0xa6
+#undef MC_CMD_0xa6_PRIVILEGE_CTG
 
 #define MC_CMD_0xa6_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
@@ -11771,6 +16688,7 @@
  * Get the mapping table for a .1p mapping.
  */
 #define MC_CMD_DOT1P_MAPPING_GET_TABLE 0xa7
+#undef MC_CMD_0xa7_PRIVILEGE_CTG
 
 #define MC_CMD_0xa7_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
@@ -11794,6 +16712,7 @@
  * Get Interrupt Vector config for this PF.
  */
 #define MC_CMD_GET_VECTOR_CFG 0xbf
+#undef MC_CMD_0xbf_PRIVILEGE_CTG
 
 #define MC_CMD_0xbf_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -11818,6 +16737,7 @@
  * Set Interrupt Vector config for this PF.
  */
 #define MC_CMD_SET_VECTOR_CFG 0xc0
+#undef MC_CMD_0xc0_PRIVILEGE_CTG
 
 #define MC_CMD_0xc0_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -11844,6 +16764,7 @@
  * Add a MAC address to a v-port
  */
 #define MC_CMD_VPORT_ADD_MAC_ADDRESS 0xa8
+#undef MC_CMD_0xa8_PRIVILEGE_CTG
 
 #define MC_CMD_0xa8_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -11865,6 +16786,7 @@
  * Delete a MAC address from a v-port
  */
 #define MC_CMD_VPORT_DEL_MAC_ADDRESS 0xa9
+#undef MC_CMD_0xa9_PRIVILEGE_CTG
 
 #define MC_CMD_0xa9_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -11886,6 +16808,7 @@
  * Delete a MAC address from a v-port
  */
 #define MC_CMD_VPORT_GET_MAC_ADDRESSES 0xaa
+#undef MC_CMD_0xaa_PRIVILEGE_CTG
 
 #define MC_CMD_0xaa_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -11898,7 +16821,9 @@
 /* MC_CMD_VPORT_GET_MAC_ADDRESSES_OUT msgresponse */
 #define    MC_CMD_VPORT_GET_MAC_ADDRESSES_OUT_LENMIN 4
 #define    MC_CMD_VPORT_GET_MAC_ADDRESSES_OUT_LENMAX 250
+#define    MC_CMD_VPORT_GET_MAC_ADDRESSES_OUT_LENMAX_MCDI2 1018
 #define    MC_CMD_VPORT_GET_MAC_ADDRESSES_OUT_LEN(num) (4+6*(num))
+#define    MC_CMD_VPORT_GET_MAC_ADDRESSES_OUT_MACADDR_NUM(len) (((len)-4)/6)
 /* The number of MAC addresses returned */
 #define       MC_CMD_VPORT_GET_MAC_ADDRESSES_OUT_MACADDR_COUNT_OFST 0
 #define       MC_CMD_VPORT_GET_MAC_ADDRESSES_OUT_MACADDR_COUNT_LEN 4
@@ -11907,6 +16832,7 @@
 #define       MC_CMD_VPORT_GET_MAC_ADDRESSES_OUT_MACADDR_LEN 6
 #define       MC_CMD_VPORT_GET_MAC_ADDRESSES_OUT_MACADDR_MINNUM 0
 #define       MC_CMD_VPORT_GET_MAC_ADDRESSES_OUT_MACADDR_MAXNUM 41
+#define       MC_CMD_VPORT_GET_MAC_ADDRESSES_OUT_MACADDR_MAXNUM_MCDI2 169
 
 
 /***********************************/
@@ -11916,6 +16842,7 @@
  * function will be reset before applying the changes.
  */
 #define MC_CMD_VPORT_RECONFIGURE 0xeb
+#undef MC_CMD_0xeb_PRIVILEGE_CTG
 
 #define MC_CMD_0xeb_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -11927,8 +16854,10 @@
 /* Flags requesting what should be changed. */
 #define       MC_CMD_VPORT_RECONFIGURE_IN_FLAGS_OFST 4
 #define       MC_CMD_VPORT_RECONFIGURE_IN_FLAGS_LEN 4
+#define        MC_CMD_VPORT_RECONFIGURE_IN_REPLACE_VLAN_TAGS_OFST 4
 #define        MC_CMD_VPORT_RECONFIGURE_IN_REPLACE_VLAN_TAGS_LBN 0
 #define        MC_CMD_VPORT_RECONFIGURE_IN_REPLACE_VLAN_TAGS_WIDTH 1
+#define        MC_CMD_VPORT_RECONFIGURE_IN_REPLACE_MACADDRS_OFST 4
 #define        MC_CMD_VPORT_RECONFIGURE_IN_REPLACE_MACADDRS_LBN 1
 #define        MC_CMD_VPORT_RECONFIGURE_IN_REPLACE_MACADDRS_WIDTH 1
 /* The number of VLAN tags to insert/remove. An error will be returned if
@@ -11940,8 +16869,10 @@
 /* The actual VLAN tags to insert/remove */
 #define       MC_CMD_VPORT_RECONFIGURE_IN_VLAN_TAGS_OFST 12
 #define       MC_CMD_VPORT_RECONFIGURE_IN_VLAN_TAGS_LEN 4
+#define        MC_CMD_VPORT_RECONFIGURE_IN_VLAN_TAG_0_OFST 12
 #define        MC_CMD_VPORT_RECONFIGURE_IN_VLAN_TAG_0_LBN 0
 #define        MC_CMD_VPORT_RECONFIGURE_IN_VLAN_TAG_0_WIDTH 16
+#define        MC_CMD_VPORT_RECONFIGURE_IN_VLAN_TAG_1_OFST 12
 #define        MC_CMD_VPORT_RECONFIGURE_IN_VLAN_TAG_1_LBN 16
 #define        MC_CMD_VPORT_RECONFIGURE_IN_VLAN_TAG_1_WIDTH 16
 /* The number of MAC addresses to add */
@@ -11956,6 +16887,7 @@
 #define    MC_CMD_VPORT_RECONFIGURE_OUT_LEN 4
 #define       MC_CMD_VPORT_RECONFIGURE_OUT_FLAGS_OFST 0
 #define       MC_CMD_VPORT_RECONFIGURE_OUT_FLAGS_LEN 4
+#define        MC_CMD_VPORT_RECONFIGURE_OUT_RESET_DONE_OFST 0
 #define        MC_CMD_VPORT_RECONFIGURE_OUT_RESET_DONE_LBN 0
 #define        MC_CMD_VPORT_RECONFIGURE_OUT_RESET_DONE_WIDTH 1
 
@@ -11965,6 +16897,7 @@
  * read some config of v-port.
  */
 #define MC_CMD_EVB_PORT_QUERY 0x62
+#undef MC_CMD_0x62_PRIVILEGE_CTG
 
 #define MC_CMD_0x62_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -11994,6 +16927,7 @@
  * lifted in future.
  */
 #define MC_CMD_DUMP_BUFTBL_ENTRIES 0xab
+#undef MC_CMD_0xab_PRIVILEGE_CTG
 
 #define MC_CMD_0xab_PRIVILEGE_CTG SRIOV_CTG_INSECURE
 
@@ -12009,12 +16943,15 @@
 /* MC_CMD_DUMP_BUFTBL_ENTRIES_OUT msgresponse */
 #define    MC_CMD_DUMP_BUFTBL_ENTRIES_OUT_LENMIN 12
 #define    MC_CMD_DUMP_BUFTBL_ENTRIES_OUT_LENMAX 252
+#define    MC_CMD_DUMP_BUFTBL_ENTRIES_OUT_LENMAX_MCDI2 1020
 #define    MC_CMD_DUMP_BUFTBL_ENTRIES_OUT_LEN(num) (0+12*(num))
+#define    MC_CMD_DUMP_BUFTBL_ENTRIES_OUT_ENTRY_NUM(len) (((len)-0)/12)
 /* Raw buffer table entries, layed out as BUFTBL_ENTRY. */
 #define       MC_CMD_DUMP_BUFTBL_ENTRIES_OUT_ENTRY_OFST 0
 #define       MC_CMD_DUMP_BUFTBL_ENTRIES_OUT_ENTRY_LEN 12
 #define       MC_CMD_DUMP_BUFTBL_ENTRIES_OUT_ENTRY_MINNUM 1
 #define       MC_CMD_DUMP_BUFTBL_ENTRIES_OUT_ENTRY_MAXNUM 21
+#define       MC_CMD_DUMP_BUFTBL_ENTRIES_OUT_ENTRY_MAXNUM_MCDI2 85
 
 
 /***********************************/
@@ -12022,6 +16959,7 @@
  * Set global RXDP configuration settings
  */
 #define MC_CMD_SET_RXDP_CONFIG 0xc1
+#undef MC_CMD_0xc1_PRIVILEGE_CTG
 
 #define MC_CMD_0xc1_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
@@ -12029,8 +16967,10 @@
 #define    MC_CMD_SET_RXDP_CONFIG_IN_LEN 4
 #define       MC_CMD_SET_RXDP_CONFIG_IN_DATA_OFST 0
 #define       MC_CMD_SET_RXDP_CONFIG_IN_DATA_LEN 4
+#define        MC_CMD_SET_RXDP_CONFIG_IN_PAD_HOST_DMA_OFST 0
 #define        MC_CMD_SET_RXDP_CONFIG_IN_PAD_HOST_DMA_LBN 0
 #define        MC_CMD_SET_RXDP_CONFIG_IN_PAD_HOST_DMA_WIDTH 1
+#define        MC_CMD_SET_RXDP_CONFIG_IN_PAD_HOST_LEN_OFST 0
 #define        MC_CMD_SET_RXDP_CONFIG_IN_PAD_HOST_LEN_LBN 1
 #define        MC_CMD_SET_RXDP_CONFIG_IN_PAD_HOST_LEN_WIDTH 2
 /* enum: pad to 64 bytes */
@@ -12049,6 +16989,7 @@
  * Get global RXDP configuration settings
  */
 #define MC_CMD_GET_RXDP_CONFIG 0xc2
+#undef MC_CMD_0xc2_PRIVILEGE_CTG
 
 #define MC_CMD_0xc2_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -12059,8 +17000,10 @@
 #define    MC_CMD_GET_RXDP_CONFIG_OUT_LEN 4
 #define       MC_CMD_GET_RXDP_CONFIG_OUT_DATA_OFST 0
 #define       MC_CMD_GET_RXDP_CONFIG_OUT_DATA_LEN 4
+#define        MC_CMD_GET_RXDP_CONFIG_OUT_PAD_HOST_DMA_OFST 0
 #define        MC_CMD_GET_RXDP_CONFIG_OUT_PAD_HOST_DMA_LBN 0
 #define        MC_CMD_GET_RXDP_CONFIG_OUT_PAD_HOST_DMA_WIDTH 1
+#define        MC_CMD_GET_RXDP_CONFIG_OUT_PAD_HOST_LEN_OFST 0
 #define        MC_CMD_GET_RXDP_CONFIG_OUT_PAD_HOST_LEN_LBN 1
 #define        MC_CMD_GET_RXDP_CONFIG_OUT_PAD_HOST_LEN_WIDTH 2
 /*             Enum values, see field(s): */
@@ -12072,6 +17015,7 @@
  * Return the system and PDCPU clock frequencies.
  */
 #define MC_CMD_GET_CLOCK 0xac
+#undef MC_CMD_0xac_PRIVILEGE_CTG
 
 #define MC_CMD_0xac_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -12093,6 +17037,7 @@
  * Control the system and DPCPU clock frequencies. Changes are lost reboot.
  */
 #define MC_CMD_SET_CLOCK 0xad
+#undef MC_CMD_0xad_PRIVILEGE_CTG
 
 #define MC_CMD_0xad_PRIVILEGE_CTG SRIOV_CTG_INSECURE
 
@@ -12178,6 +17123,7 @@
  * Send an arbitrary DPCPU message.
  */
 #define MC_CMD_DPCPU_RPC 0xae
+#undef MC_CMD_0xae_PRIVILEGE_CTG
 
 #define MC_CMD_0xae_PRIVILEGE_CTG SRIOV_CTG_INSECURE
 
@@ -12206,6 +17152,7 @@
  */
 #define       MC_CMD_DPCPU_RPC_IN_DATA_OFST 4
 #define       MC_CMD_DPCPU_RPC_IN_DATA_LEN 32
+#define        MC_CMD_DPCPU_RPC_IN_HDR_CMD_CMDNUM_OFST 4
 #define        MC_CMD_DPCPU_RPC_IN_HDR_CMD_CMDNUM_LBN 8
 #define        MC_CMD_DPCPU_RPC_IN_HDR_CMD_CMDNUM_WIDTH 8
 #define          MC_CMD_DPCPU_RPC_IN_CMDNUM_TXDPCPU_READ 0x6 /* enum */
@@ -12217,14 +17164,19 @@
 #define          MC_CMD_DPCPU_RPC_IN_CMDNUM_RXDPCPU_SELF_TEST 0x4a /* enum */
 #define          MC_CMD_DPCPU_RPC_IN_CMDNUM_RXDPCPU_CSR_ACCESS 0x4c /* enum */
 #define          MC_CMD_DPCPU_RPC_IN_CMDNUM_RXDPCPU_SET_MC_REPLAY_CNTXT 0x4d /* enum */
+#define        MC_CMD_DPCPU_RPC_IN_HDR_CMD_REQ_OBJID_OFST 4
 #define        MC_CMD_DPCPU_RPC_IN_HDR_CMD_REQ_OBJID_LBN 16
 #define        MC_CMD_DPCPU_RPC_IN_HDR_CMD_REQ_OBJID_WIDTH 16
+#define        MC_CMD_DPCPU_RPC_IN_HDR_CMD_REQ_ADDR_OFST 4
 #define        MC_CMD_DPCPU_RPC_IN_HDR_CMD_REQ_ADDR_LBN 16
 #define        MC_CMD_DPCPU_RPC_IN_HDR_CMD_REQ_ADDR_WIDTH 16
+#define        MC_CMD_DPCPU_RPC_IN_HDR_CMD_REQ_COUNT_OFST 4
 #define        MC_CMD_DPCPU_RPC_IN_HDR_CMD_REQ_COUNT_LBN 48
 #define        MC_CMD_DPCPU_RPC_IN_HDR_CMD_REQ_COUNT_WIDTH 16
+#define        MC_CMD_DPCPU_RPC_IN_CSR_ACCESS_INFO_OFST 4
 #define        MC_CMD_DPCPU_RPC_IN_CSR_ACCESS_INFO_LBN 16
 #define        MC_CMD_DPCPU_RPC_IN_CSR_ACCESS_INFO_WIDTH 240
+#define        MC_CMD_DPCPU_RPC_IN_CSR_ACCESS_CMD_OFST 4
 #define        MC_CMD_DPCPU_RPC_IN_CSR_ACCESS_CMD_LBN 16
 #define        MC_CMD_DPCPU_RPC_IN_CSR_ACCESS_CMD_WIDTH 16
 #define          MC_CMD_DPCPU_RPC_IN_CSR_ACCESS_CMD_STOP_RETURN_RESULT 0x0 /* enum */
@@ -12232,17 +17184,22 @@
 #define          MC_CMD_DPCPU_RPC_IN_CSR_ACCESS_CMD_START_WRITE 0x2 /* enum */
 #define          MC_CMD_DPCPU_RPC_IN_CSR_ACCESS_CMD_START_WRITE_READ 0x3 /* enum */
 #define          MC_CMD_DPCPU_RPC_IN_CSR_ACCESS_CMD_START_PIPELINED_READ 0x4 /* enum */
+#define        MC_CMD_DPCPU_RPC_IN_CSR_ACCESS_START_DELAY_OFST 4
 #define        MC_CMD_DPCPU_RPC_IN_CSR_ACCESS_START_DELAY_LBN 48
 #define        MC_CMD_DPCPU_RPC_IN_CSR_ACCESS_START_DELAY_WIDTH 16
+#define        MC_CMD_DPCPU_RPC_IN_CSR_ACCESS_RPT_COUNT_OFST 4
 #define        MC_CMD_DPCPU_RPC_IN_CSR_ACCESS_RPT_COUNT_LBN 64
 #define        MC_CMD_DPCPU_RPC_IN_CSR_ACCESS_RPT_COUNT_WIDTH 16
+#define        MC_CMD_DPCPU_RPC_IN_CSR_ACCESS_GAP_DELAY_OFST 4
 #define        MC_CMD_DPCPU_RPC_IN_CSR_ACCESS_GAP_DELAY_LBN 80
 #define        MC_CMD_DPCPU_RPC_IN_CSR_ACCESS_GAP_DELAY_WIDTH 16
+#define        MC_CMD_DPCPU_RPC_IN_MC_REPLAY_MODE_OFST 4
 #define        MC_CMD_DPCPU_RPC_IN_MC_REPLAY_MODE_LBN 16
 #define        MC_CMD_DPCPU_RPC_IN_MC_REPLAY_MODE_WIDTH 16
 #define          MC_CMD_DPCPU_RPC_IN_MC_REPLAY_MODE_CUT_THROUGH 0x1 /* enum */
 #define          MC_CMD_DPCPU_RPC_IN_MC_REPLAY_MODE_STORE_FORWARD 0x2 /* enum */
 #define          MC_CMD_DPCPU_RPC_IN_MC_REPLAY_MODE_STORE_FORWARD_FIRST 0x3 /* enum */
+#define        MC_CMD_DPCPU_RPC_IN_MC_REPLAY_CNTXT_OFST 4
 #define        MC_CMD_DPCPU_RPC_IN_MC_REPLAY_CNTXT_LBN 64
 #define        MC_CMD_DPCPU_RPC_IN_MC_REPLAY_CNTXT_WIDTH 16
 #define       MC_CMD_DPCPU_RPC_IN_WDATA_OFST 12
@@ -12261,8 +17218,10 @@
 /* DATA */
 #define       MC_CMD_DPCPU_RPC_OUT_DATA_OFST 4
 #define       MC_CMD_DPCPU_RPC_OUT_DATA_LEN 32
+#define        MC_CMD_DPCPU_RPC_OUT_HDR_CMD_RESP_ERRCODE_OFST 4
 #define        MC_CMD_DPCPU_RPC_OUT_HDR_CMD_RESP_ERRCODE_LBN 32
 #define        MC_CMD_DPCPU_RPC_OUT_HDR_CMD_RESP_ERRCODE_WIDTH 16
+#define        MC_CMD_DPCPU_RPC_OUT_CSR_ACCESS_READ_COUNT_OFST 4
 #define        MC_CMD_DPCPU_RPC_OUT_CSR_ACCESS_READ_COUNT_LBN 48
 #define        MC_CMD_DPCPU_RPC_OUT_CSR_ACCESS_READ_COUNT_WIDTH 16
 #define       MC_CMD_DPCPU_RPC_OUT_RDATA_OFST 12
@@ -12282,6 +17241,7 @@
  * Trigger an interrupt by prodding the BIU.
  */
 #define MC_CMD_TRIGGER_INTERRUPT 0xe3
+#undef MC_CMD_0xe3_PRIVILEGE_CTG
 
 #define MC_CMD_0xe3_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -12300,6 +17260,7 @@
  * Special operations to support (for now) shmboot.
  */
 #define MC_CMD_SHMBOOT_OP 0xe6
+#undef MC_CMD_0xe6_PRIVILEGE_CTG
 
 #define MC_CMD_0xe6_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
@@ -12320,6 +17281,7 @@
  * Read multiple 64bit words from capture block memory
  */
 #define MC_CMD_CAP_BLK_READ 0xe7
+#undef MC_CMD_0xe7_PRIVILEGE_CTG
 
 #define MC_CMD_0xe7_PRIVILEGE_CTG SRIOV_CTG_INSECURE
 
@@ -12335,13 +17297,16 @@
 /* MC_CMD_CAP_BLK_READ_OUT msgresponse */
 #define    MC_CMD_CAP_BLK_READ_OUT_LENMIN 8
 #define    MC_CMD_CAP_BLK_READ_OUT_LENMAX 248
+#define    MC_CMD_CAP_BLK_READ_OUT_LENMAX_MCDI2 1016
 #define    MC_CMD_CAP_BLK_READ_OUT_LEN(num) (0+8*(num))
+#define    MC_CMD_CAP_BLK_READ_OUT_BUFFER_NUM(len) (((len)-0)/8)
 #define       MC_CMD_CAP_BLK_READ_OUT_BUFFER_OFST 0
 #define       MC_CMD_CAP_BLK_READ_OUT_BUFFER_LEN 8
 #define       MC_CMD_CAP_BLK_READ_OUT_BUFFER_LO_OFST 0
 #define       MC_CMD_CAP_BLK_READ_OUT_BUFFER_HI_OFST 4
 #define       MC_CMD_CAP_BLK_READ_OUT_BUFFER_MINNUM 1
 #define       MC_CMD_CAP_BLK_READ_OUT_BUFFER_MAXNUM 31
+#define       MC_CMD_CAP_BLK_READ_OUT_BUFFER_MAXNUM_MCDI2 127
 
 
 /***********************************/
@@ -12349,6 +17314,7 @@
  * Take a dump of the DUT state
  */
 #define MC_CMD_DUMP_DO 0xe8
+#undef MC_CMD_0xe8_PRIVILEGE_CTG
 
 #define MC_CMD_0xe8_PRIVILEGE_CTG SRIOV_CTG_INSECURE
 
@@ -12428,6 +17394,7 @@
  * Configure unsolicited dumps
  */
 #define MC_CMD_DUMP_CONFIGURE_UNSOLICITED 0xe9
+#undef MC_CMD_0xe9_PRIVILEGE_CTG
 
 #define MC_CMD_0xe9_PRIVILEGE_CTG SRIOV_CTG_INSECURE
 
@@ -12496,6 +17463,7 @@
  * the parameter is out of range.
  */
 #define MC_CMD_SET_PSU 0xea
+#undef MC_CMD_0xea_PRIVILEGE_CTG
 
 #define MC_CMD_0xea_PRIVILEGE_CTG SRIOV_CTG_INSECURE
 
@@ -12521,6 +17489,7 @@
  * Get function information. PF and VF number.
  */
 #define MC_CMD_GET_FUNCTION_INFO 0xec
+#undef MC_CMD_0xec_PRIVILEGE_CTG
 
 #define MC_CMD_0xec_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -12542,6 +17511,7 @@
  * reboot.
  */
 #define MC_CMD_ENABLE_OFFLINE_BIST 0xed
+#undef MC_CMD_0xed_PRIVILEGE_CTG
 
 #define MC_CMD_0xed_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
@@ -12559,13 +17529,16 @@
  * forget.
  */
 #define MC_CMD_UART_SEND_DATA 0xee
+#undef MC_CMD_0xee_PRIVILEGE_CTG
 
 #define MC_CMD_0xee_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
 /* MC_CMD_UART_SEND_DATA_OUT msgrequest */
 #define    MC_CMD_UART_SEND_DATA_OUT_LENMIN 16
 #define    MC_CMD_UART_SEND_DATA_OUT_LENMAX 252
+#define    MC_CMD_UART_SEND_DATA_OUT_LENMAX_MCDI2 1020
 #define    MC_CMD_UART_SEND_DATA_OUT_LEN(num) (16+1*(num))
+#define    MC_CMD_UART_SEND_DATA_OUT_DATA_NUM(len) (((len)-16)/1)
 /* CRC32 over OFFSET, LENGTH, RESERVED, DATA */
 #define       MC_CMD_UART_SEND_DATA_OUT_CHECKSUM_OFST 0
 #define       MC_CMD_UART_SEND_DATA_OUT_CHECKSUM_LEN 4
@@ -12582,6 +17555,7 @@
 #define       MC_CMD_UART_SEND_DATA_OUT_DATA_LEN 1
 #define       MC_CMD_UART_SEND_DATA_OUT_DATA_MINNUM 0
 #define       MC_CMD_UART_SEND_DATA_OUT_DATA_MAXNUM 236
+#define       MC_CMD_UART_SEND_DATA_OUT_DATA_MAXNUM_MCDI2 1004
 
 /* MC_CMD_UART_SEND_DATA_IN msgresponse */
 #define    MC_CMD_UART_SEND_DATA_IN_LEN 0
@@ -12593,6 +17567,7 @@
  * subject to change and not currently implemented.
  */
 #define MC_CMD_UART_RECV_DATA 0xef
+#undef MC_CMD_0xef_PRIVILEGE_CTG
 
 #define MC_CMD_0xef_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -12614,7 +17589,9 @@
 /* MC_CMD_UART_RECV_DATA_IN msgresponse */
 #define    MC_CMD_UART_RECV_DATA_IN_LENMIN 16
 #define    MC_CMD_UART_RECV_DATA_IN_LENMAX 252
+#define    MC_CMD_UART_RECV_DATA_IN_LENMAX_MCDI2 1020
 #define    MC_CMD_UART_RECV_DATA_IN_LEN(num) (16+1*(num))
+#define    MC_CMD_UART_RECV_DATA_IN_DATA_NUM(len) (((len)-16)/1)
 /* CRC32 over RESERVED1, RESERVED2, RESERVED3, DATA */
 #define       MC_CMD_UART_RECV_DATA_IN_CHECKSUM_OFST 0
 #define       MC_CMD_UART_RECV_DATA_IN_CHECKSUM_LEN 4
@@ -12631,6 +17608,7 @@
 #define       MC_CMD_UART_RECV_DATA_IN_DATA_LEN 1
 #define       MC_CMD_UART_RECV_DATA_IN_DATA_MINNUM 0
 #define       MC_CMD_UART_RECV_DATA_IN_DATA_MAXNUM 236
+#define       MC_CMD_UART_RECV_DATA_IN_DATA_MAXNUM_MCDI2 1004
 
 
 /***********************************/
@@ -12638,6 +17616,7 @@
  * Read data programmed into the device One-Time-Programmable (OTP) Fuses
  */
 #define MC_CMD_READ_FUSES 0xf0
+#undef MC_CMD_0xf0_PRIVILEGE_CTG
 
 #define MC_CMD_0xf0_PRIVILEGE_CTG SRIOV_CTG_INSECURE
 
@@ -12653,7 +17632,9 @@
 /* MC_CMD_READ_FUSES_OUT msgresponse */
 #define    MC_CMD_READ_FUSES_OUT_LENMIN 4
 #define    MC_CMD_READ_FUSES_OUT_LENMAX 252
+#define    MC_CMD_READ_FUSES_OUT_LENMAX_MCDI2 1020
 #define    MC_CMD_READ_FUSES_OUT_LEN(num) (4+1*(num))
+#define    MC_CMD_READ_FUSES_OUT_DATA_NUM(len) (((len)-4)/1)
 /* Length of returned OTP data in bytes */
 #define       MC_CMD_READ_FUSES_OUT_LENGTH_OFST 0
 #define       MC_CMD_READ_FUSES_OUT_LENGTH_LEN 4
@@ -12662,6 +17643,7 @@
 #define       MC_CMD_READ_FUSES_OUT_DATA_LEN 1
 #define       MC_CMD_READ_FUSES_OUT_DATA_MINNUM 0
 #define       MC_CMD_READ_FUSES_OUT_DATA_MAXNUM 248
+#define       MC_CMD_READ_FUSES_OUT_DATA_MAXNUM_MCDI2 1016
 
 
 /***********************************/
@@ -12669,13 +17651,16 @@
  * Get or set KR Serdes RXEQ and TX Driver settings
  */
 #define MC_CMD_KR_TUNE 0xf1
+#undef MC_CMD_0xf1_PRIVILEGE_CTG
 
 #define MC_CMD_0xf1_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
 /* MC_CMD_KR_TUNE_IN msgrequest */
 #define    MC_CMD_KR_TUNE_IN_LENMIN 4
 #define    MC_CMD_KR_TUNE_IN_LENMAX 252
+#define    MC_CMD_KR_TUNE_IN_LENMAX_MCDI2 1020
 #define    MC_CMD_KR_TUNE_IN_LEN(num) (4+4*(num))
+#define    MC_CMD_KR_TUNE_IN_KR_TUNE_ARGS_NUM(len) (((len)-4)/4)
 /* Requested operation */
 #define       MC_CMD_KR_TUNE_IN_KR_TUNE_OP_OFST 0
 #define       MC_CMD_KR_TUNE_IN_KR_TUNE_OP_LEN 1
@@ -12712,6 +17697,7 @@
 #define       MC_CMD_KR_TUNE_IN_KR_TUNE_ARGS_LEN 4
 #define       MC_CMD_KR_TUNE_IN_KR_TUNE_ARGS_MINNUM 0
 #define       MC_CMD_KR_TUNE_IN_KR_TUNE_ARGS_MAXNUM 62
+#define       MC_CMD_KR_TUNE_IN_KR_TUNE_ARGS_MAXNUM_MCDI2 254
 
 /* MC_CMD_KR_TUNE_OUT msgresponse */
 #define    MC_CMD_KR_TUNE_OUT_LEN 0
@@ -12728,12 +17714,16 @@
 /* MC_CMD_KR_TUNE_RXEQ_GET_OUT msgresponse */
 #define    MC_CMD_KR_TUNE_RXEQ_GET_OUT_LENMIN 4
 #define    MC_CMD_KR_TUNE_RXEQ_GET_OUT_LENMAX 252
+#define    MC_CMD_KR_TUNE_RXEQ_GET_OUT_LENMAX_MCDI2 1020
 #define    MC_CMD_KR_TUNE_RXEQ_GET_OUT_LEN(num) (0+4*(num))
+#define    MC_CMD_KR_TUNE_RXEQ_GET_OUT_PARAM_NUM(len) (((len)-0)/4)
 /* RXEQ Parameter */
 #define       MC_CMD_KR_TUNE_RXEQ_GET_OUT_PARAM_OFST 0
 #define       MC_CMD_KR_TUNE_RXEQ_GET_OUT_PARAM_LEN 4
 #define       MC_CMD_KR_TUNE_RXEQ_GET_OUT_PARAM_MINNUM 1
 #define       MC_CMD_KR_TUNE_RXEQ_GET_OUT_PARAM_MAXNUM 63
+#define       MC_CMD_KR_TUNE_RXEQ_GET_OUT_PARAM_MAXNUM_MCDI2 255
+#define        MC_CMD_KR_TUNE_RXEQ_GET_OUT_PARAM_ID_OFST 0
 #define        MC_CMD_KR_TUNE_RXEQ_GET_OUT_PARAM_ID_LBN 0
 #define        MC_CMD_KR_TUNE_RXEQ_GET_OUT_PARAM_ID_WIDTH 8
 /* enum: Attenuation (0-15, Huntington) */
@@ -12822,6 +17812,45 @@
 #define          MC_CMD_KR_TUNE_RXEQ_GET_OUT_CDR_PVT 0x20
 /* enum: CDR integral loop code (Medford2) */
 #define          MC_CMD_KR_TUNE_RXEQ_GET_OUT_CDR_INTEG 0x21
+/* enum: CTLE Boost stages - retimer lineside (Medford2 with DS250x retimer - 4
+ * stages, 2 bits per stage)
+ */
+#define          MC_CMD_KR_TUNE_RXEQ_GET_OUT_BOOST_RT_LS 0x22
+/* enum: DFE Tap1 - retimer lineside (Medford2 with DS250x retimer (-31 - 31))
+ */
+#define          MC_CMD_KR_TUNE_RXEQ_GET_OUT_DFE_TAP1_RT_LS 0x23
+/* enum: DFE Tap2 - retimer lineside (Medford2 with DS250x retimer (-15 - 15))
+ */
+#define          MC_CMD_KR_TUNE_RXEQ_GET_OUT_DFE_TAP2_RT_LS 0x24
+/* enum: DFE Tap3 - retimer lineside (Medford2 with DS250x retimer (-15 - 15))
+ */
+#define          MC_CMD_KR_TUNE_RXEQ_GET_OUT_DFE_TAP3_RT_LS 0x25
+/* enum: DFE Tap4 - retimer lineside (Medford2 with DS250x retimer (-15 - 15))
+ */
+#define          MC_CMD_KR_TUNE_RXEQ_GET_OUT_DFE_TAP4_RT_LS 0x26
+/* enum: DFE Tap5 - retimer lineside (Medford2 with DS250x retimer (-15 - 15))
+ */
+#define          MC_CMD_KR_TUNE_RXEQ_GET_OUT_DFE_TAP5_RT_LS 0x27
+/* enum: CTLE Boost stages - retimer hostside (Medford2 with DS250x retimer - 4
+ * stages, 2 bits per stage)
+ */
+#define          MC_CMD_KR_TUNE_RXEQ_GET_OUT_BOOST_RT_HS 0x28
+/* enum: DFE Tap1 - retimer hostside (Medford2 with DS250x retimer (-31 - 31))
+ */
+#define          MC_CMD_KR_TUNE_RXEQ_GET_OUT_DFE_TAP1_RT_HS 0x29
+/* enum: DFE Tap2 - retimer hostside (Medford2 with DS250x retimer (-15 - 15))
+ */
+#define          MC_CMD_KR_TUNE_RXEQ_GET_OUT_DFE_TAP2_RT_HS 0x2a
+/* enum: DFE Tap3 - retimer hostside (Medford2 with DS250x retimer (-15 - 15))
+ */
+#define          MC_CMD_KR_TUNE_RXEQ_GET_OUT_DFE_TAP3_RT_HS 0x2b
+/* enum: DFE Tap4 - retimer hostside (Medford2 with DS250x retimer (-15 - 15))
+ */
+#define          MC_CMD_KR_TUNE_RXEQ_GET_OUT_DFE_TAP4_RT_HS 0x2c
+/* enum: DFE Tap5 - retimer hostside (Medford2 with DS250x retimer (-15 - 15))
+ */
+#define          MC_CMD_KR_TUNE_RXEQ_GET_OUT_DFE_TAP5_RT_HS 0x2d
+#define        MC_CMD_KR_TUNE_RXEQ_GET_OUT_PARAM_LANE_OFST 0
 #define        MC_CMD_KR_TUNE_RXEQ_GET_OUT_PARAM_LANE_LBN 8
 #define        MC_CMD_KR_TUNE_RXEQ_GET_OUT_PARAM_LANE_WIDTH 3
 #define          MC_CMD_KR_TUNE_RXEQ_GET_OUT_LANE_0 0x0 /* enum */
@@ -12829,19 +17858,25 @@
 #define          MC_CMD_KR_TUNE_RXEQ_GET_OUT_LANE_2 0x2 /* enum */
 #define          MC_CMD_KR_TUNE_RXEQ_GET_OUT_LANE_3 0x3 /* enum */
 #define          MC_CMD_KR_TUNE_RXEQ_GET_OUT_LANE_ALL 0x4 /* enum */
+#define        MC_CMD_KR_TUNE_RXEQ_GET_OUT_PARAM_AUTOCAL_OFST 0
 #define        MC_CMD_KR_TUNE_RXEQ_GET_OUT_PARAM_AUTOCAL_LBN 11
 #define        MC_CMD_KR_TUNE_RXEQ_GET_OUT_PARAM_AUTOCAL_WIDTH 1
+#define        MC_CMD_KR_TUNE_RXEQ_GET_OUT_RESERVED_OFST 0
 #define        MC_CMD_KR_TUNE_RXEQ_GET_OUT_RESERVED_LBN 12
 #define        MC_CMD_KR_TUNE_RXEQ_GET_OUT_RESERVED_WIDTH 4
+#define        MC_CMD_KR_TUNE_RXEQ_GET_OUT_PARAM_INITIAL_OFST 0
 #define        MC_CMD_KR_TUNE_RXEQ_GET_OUT_PARAM_INITIAL_LBN 16
 #define        MC_CMD_KR_TUNE_RXEQ_GET_OUT_PARAM_INITIAL_WIDTH 8
+#define        MC_CMD_KR_TUNE_RXEQ_GET_OUT_PARAM_CURRENT_OFST 0
 #define        MC_CMD_KR_TUNE_RXEQ_GET_OUT_PARAM_CURRENT_LBN 24
 #define        MC_CMD_KR_TUNE_RXEQ_GET_OUT_PARAM_CURRENT_WIDTH 8
 
 /* MC_CMD_KR_TUNE_RXEQ_SET_IN msgrequest */
 #define    MC_CMD_KR_TUNE_RXEQ_SET_IN_LENMIN 8
 #define    MC_CMD_KR_TUNE_RXEQ_SET_IN_LENMAX 252
+#define    MC_CMD_KR_TUNE_RXEQ_SET_IN_LENMAX_MCDI2 1020
 #define    MC_CMD_KR_TUNE_RXEQ_SET_IN_LEN(num) (4+4*(num))
+#define    MC_CMD_KR_TUNE_RXEQ_SET_IN_PARAM_NUM(len) (((len)-4)/4)
 /* Requested operation */
 #define       MC_CMD_KR_TUNE_RXEQ_SET_IN_KR_TUNE_OP_OFST 0
 #define       MC_CMD_KR_TUNE_RXEQ_SET_IN_KR_TUNE_OP_LEN 1
@@ -12853,20 +17888,27 @@
 #define       MC_CMD_KR_TUNE_RXEQ_SET_IN_PARAM_LEN 4
 #define       MC_CMD_KR_TUNE_RXEQ_SET_IN_PARAM_MINNUM 1
 #define       MC_CMD_KR_TUNE_RXEQ_SET_IN_PARAM_MAXNUM 62
+#define       MC_CMD_KR_TUNE_RXEQ_SET_IN_PARAM_MAXNUM_MCDI2 254
+#define        MC_CMD_KR_TUNE_RXEQ_SET_IN_PARAM_ID_OFST 4
 #define        MC_CMD_KR_TUNE_RXEQ_SET_IN_PARAM_ID_LBN 0
 #define        MC_CMD_KR_TUNE_RXEQ_SET_IN_PARAM_ID_WIDTH 8
 /*             Enum values, see field(s): */
 /*                MC_CMD_KR_TUNE_RXEQ_GET_OUT/PARAM_ID */
+#define        MC_CMD_KR_TUNE_RXEQ_SET_IN_PARAM_LANE_OFST 4
 #define        MC_CMD_KR_TUNE_RXEQ_SET_IN_PARAM_LANE_LBN 8
 #define        MC_CMD_KR_TUNE_RXEQ_SET_IN_PARAM_LANE_WIDTH 3
 /*             Enum values, see field(s): */
 /*                MC_CMD_KR_TUNE_RXEQ_GET_OUT/PARAM_LANE */
+#define        MC_CMD_KR_TUNE_RXEQ_SET_IN_PARAM_AUTOCAL_OFST 4
 #define        MC_CMD_KR_TUNE_RXEQ_SET_IN_PARAM_AUTOCAL_LBN 11
 #define        MC_CMD_KR_TUNE_RXEQ_SET_IN_PARAM_AUTOCAL_WIDTH 1
+#define        MC_CMD_KR_TUNE_RXEQ_SET_IN_RESERVED_OFST 4
 #define        MC_CMD_KR_TUNE_RXEQ_SET_IN_RESERVED_LBN 12
 #define        MC_CMD_KR_TUNE_RXEQ_SET_IN_RESERVED_WIDTH 4
+#define        MC_CMD_KR_TUNE_RXEQ_SET_IN_PARAM_INITIAL_OFST 4
 #define        MC_CMD_KR_TUNE_RXEQ_SET_IN_PARAM_INITIAL_LBN 16
 #define        MC_CMD_KR_TUNE_RXEQ_SET_IN_PARAM_INITIAL_WIDTH 8
+#define        MC_CMD_KR_TUNE_RXEQ_SET_IN_RESERVED2_OFST 4
 #define        MC_CMD_KR_TUNE_RXEQ_SET_IN_RESERVED2_LBN 24
 #define        MC_CMD_KR_TUNE_RXEQ_SET_IN_RESERVED2_WIDTH 8
 
@@ -12885,12 +17927,16 @@
 /* MC_CMD_KR_TUNE_TXEQ_GET_OUT msgresponse */
 #define    MC_CMD_KR_TUNE_TXEQ_GET_OUT_LENMIN 4
 #define    MC_CMD_KR_TUNE_TXEQ_GET_OUT_LENMAX 252
+#define    MC_CMD_KR_TUNE_TXEQ_GET_OUT_LENMAX_MCDI2 1020
 #define    MC_CMD_KR_TUNE_TXEQ_GET_OUT_LEN(num) (0+4*(num))
+#define    MC_CMD_KR_TUNE_TXEQ_GET_OUT_PARAM_NUM(len) (((len)-0)/4)
 /* TXEQ Parameter */
 #define       MC_CMD_KR_TUNE_TXEQ_GET_OUT_PARAM_OFST 0
 #define       MC_CMD_KR_TUNE_TXEQ_GET_OUT_PARAM_LEN 4
 #define       MC_CMD_KR_TUNE_TXEQ_GET_OUT_PARAM_MINNUM 1
 #define       MC_CMD_KR_TUNE_TXEQ_GET_OUT_PARAM_MAXNUM 63
+#define       MC_CMD_KR_TUNE_TXEQ_GET_OUT_PARAM_MAXNUM_MCDI2 255
+#define        MC_CMD_KR_TUNE_TXEQ_GET_OUT_PARAM_ID_OFST 0
 #define        MC_CMD_KR_TUNE_TXEQ_GET_OUT_PARAM_ID_LBN 0
 #define        MC_CMD_KR_TUNE_TXEQ_GET_OUT_PARAM_ID_WIDTH 8
 /* enum: TX Amplitude (Huntington, Medford, Medford2) */
@@ -12915,10 +17961,23 @@
 #define          MC_CMD_KR_TUNE_TXEQ_GET_OUT_TX_RT_SET 0x9
 /* enum: TX Amplitude Fine control (Medford) */
 #define          MC_CMD_KR_TUNE_TXEQ_GET_OUT_TX_LEV_FINE 0xa
-/* enum: Pre-shoot Tap (Medford, Medford2) */
+/* enum: Pre-cursor Tap (Medford, Medford2) */
 #define          MC_CMD_KR_TUNE_TXEQ_GET_OUT_TAP_ADV 0xb
-/* enum: De-emphasis Tap (Medford, Medford2) */
+/* enum: Post-cursor Tap (Medford, Medford2) */
 #define          MC_CMD_KR_TUNE_TXEQ_GET_OUT_TAP_DLY 0xc
+/* enum: TX Amplitude (Retimer Lineside) */
+#define          MC_CMD_KR_TUNE_TXEQ_GET_OUT_TX_LEV_RT_LS 0xd
+/* enum: Pre-cursor Tap (Retimer Lineside) */
+#define          MC_CMD_KR_TUNE_TXEQ_GET_OUT_TAP_ADV_RT_LS 0xe
+/* enum: Post-cursor Tap (Retimer Lineside) */
+#define          MC_CMD_KR_TUNE_TXEQ_GET_OUT_TAP_DLY_RT_LS 0xf
+/* enum: TX Amplitude (Retimer Hostside) */
+#define          MC_CMD_KR_TUNE_TXEQ_GET_OUT_TX_LEV_RT_HS 0x10
+/* enum: Pre-cursor Tap (Retimer Hostside) */
+#define          MC_CMD_KR_TUNE_TXEQ_GET_OUT_TAP_ADV_RT_HS 0x11
+/* enum: Post-cursor Tap (Retimer Hostside) */
+#define          MC_CMD_KR_TUNE_TXEQ_GET_OUT_TAP_DLY_RT_HS 0x12
+#define        MC_CMD_KR_TUNE_TXEQ_GET_OUT_PARAM_LANE_OFST 0
 #define        MC_CMD_KR_TUNE_TXEQ_GET_OUT_PARAM_LANE_LBN 8
 #define        MC_CMD_KR_TUNE_TXEQ_GET_OUT_PARAM_LANE_WIDTH 3
 #define          MC_CMD_KR_TUNE_TXEQ_GET_OUT_LANE_0 0x0 /* enum */
@@ -12926,17 +17985,22 @@
 #define          MC_CMD_KR_TUNE_TXEQ_GET_OUT_LANE_2 0x2 /* enum */
 #define          MC_CMD_KR_TUNE_TXEQ_GET_OUT_LANE_3 0x3 /* enum */
 #define          MC_CMD_KR_TUNE_TXEQ_GET_OUT_LANE_ALL 0x4 /* enum */
+#define        MC_CMD_KR_TUNE_TXEQ_GET_OUT_RESERVED_OFST 0
 #define        MC_CMD_KR_TUNE_TXEQ_GET_OUT_RESERVED_LBN 11
 #define        MC_CMD_KR_TUNE_TXEQ_GET_OUT_RESERVED_WIDTH 5
+#define        MC_CMD_KR_TUNE_TXEQ_GET_OUT_PARAM_INITIAL_OFST 0
 #define        MC_CMD_KR_TUNE_TXEQ_GET_OUT_PARAM_INITIAL_LBN 16
 #define        MC_CMD_KR_TUNE_TXEQ_GET_OUT_PARAM_INITIAL_WIDTH 8
+#define        MC_CMD_KR_TUNE_TXEQ_GET_OUT_RESERVED2_OFST 0
 #define        MC_CMD_KR_TUNE_TXEQ_GET_OUT_RESERVED2_LBN 24
 #define        MC_CMD_KR_TUNE_TXEQ_GET_OUT_RESERVED2_WIDTH 8
 
 /* MC_CMD_KR_TUNE_TXEQ_SET_IN msgrequest */
 #define    MC_CMD_KR_TUNE_TXEQ_SET_IN_LENMIN 8
 #define    MC_CMD_KR_TUNE_TXEQ_SET_IN_LENMAX 252
+#define    MC_CMD_KR_TUNE_TXEQ_SET_IN_LENMAX_MCDI2 1020
 #define    MC_CMD_KR_TUNE_TXEQ_SET_IN_LEN(num) (4+4*(num))
+#define    MC_CMD_KR_TUNE_TXEQ_SET_IN_PARAM_NUM(len) (((len)-4)/4)
 /* Requested operation */
 #define       MC_CMD_KR_TUNE_TXEQ_SET_IN_KR_TUNE_OP_OFST 0
 #define       MC_CMD_KR_TUNE_TXEQ_SET_IN_KR_TUNE_OP_LEN 1
@@ -12948,18 +18012,24 @@
 #define       MC_CMD_KR_TUNE_TXEQ_SET_IN_PARAM_LEN 4
 #define       MC_CMD_KR_TUNE_TXEQ_SET_IN_PARAM_MINNUM 1
 #define       MC_CMD_KR_TUNE_TXEQ_SET_IN_PARAM_MAXNUM 62
+#define       MC_CMD_KR_TUNE_TXEQ_SET_IN_PARAM_MAXNUM_MCDI2 254
+#define        MC_CMD_KR_TUNE_TXEQ_SET_IN_PARAM_ID_OFST 4
 #define        MC_CMD_KR_TUNE_TXEQ_SET_IN_PARAM_ID_LBN 0
 #define        MC_CMD_KR_TUNE_TXEQ_SET_IN_PARAM_ID_WIDTH 8
 /*             Enum values, see field(s): */
 /*                MC_CMD_KR_TUNE_TXEQ_GET_OUT/PARAM_ID */
+#define        MC_CMD_KR_TUNE_TXEQ_SET_IN_PARAM_LANE_OFST 4
 #define        MC_CMD_KR_TUNE_TXEQ_SET_IN_PARAM_LANE_LBN 8
 #define        MC_CMD_KR_TUNE_TXEQ_SET_IN_PARAM_LANE_WIDTH 3
 /*             Enum values, see field(s): */
 /*                MC_CMD_KR_TUNE_TXEQ_GET_OUT/PARAM_LANE */
+#define        MC_CMD_KR_TUNE_TXEQ_SET_IN_RESERVED_OFST 4
 #define        MC_CMD_KR_TUNE_TXEQ_SET_IN_RESERVED_LBN 11
 #define        MC_CMD_KR_TUNE_TXEQ_SET_IN_RESERVED_WIDTH 5
+#define        MC_CMD_KR_TUNE_TXEQ_SET_IN_PARAM_INITIAL_OFST 4
 #define        MC_CMD_KR_TUNE_TXEQ_SET_IN_PARAM_INITIAL_LBN 16
 #define        MC_CMD_KR_TUNE_TXEQ_SET_IN_PARAM_INITIAL_WIDTH 8
+#define        MC_CMD_KR_TUNE_TXEQ_SET_IN_RESERVED2_OFST 4
 #define        MC_CMD_KR_TUNE_TXEQ_SET_IN_RESERVED2_LBN 24
 #define        MC_CMD_KR_TUNE_TXEQ_SET_IN_RESERVED2_WIDTH 8
 
@@ -13000,8 +18070,10 @@
 #define       MC_CMD_KR_TUNE_START_EYE_PLOT_V2_IN_KR_TUNE_RSVD_LEN 3
 #define       MC_CMD_KR_TUNE_START_EYE_PLOT_V2_IN_LANE_OFST 4
 #define       MC_CMD_KR_TUNE_START_EYE_PLOT_V2_IN_LANE_LEN 4
+#define        MC_CMD_KR_TUNE_START_EYE_PLOT_V2_IN_LANE_NUM_OFST 4
 #define        MC_CMD_KR_TUNE_START_EYE_PLOT_V2_IN_LANE_NUM_LBN 0
 #define        MC_CMD_KR_TUNE_START_EYE_PLOT_V2_IN_LANE_NUM_WIDTH 8
+#define        MC_CMD_KR_TUNE_START_EYE_PLOT_V2_IN_LANE_ABS_REL_OFST 4
 #define        MC_CMD_KR_TUNE_START_EYE_PLOT_V2_IN_LANE_ABS_REL_LBN 31
 #define        MC_CMD_KR_TUNE_START_EYE_PLOT_V2_IN_LANE_ABS_REL_WIDTH 1
 /* Scan duration / cycle count */
@@ -13023,11 +18095,14 @@
 /* MC_CMD_KR_TUNE_POLL_EYE_PLOT_OUT msgresponse */
 #define    MC_CMD_KR_TUNE_POLL_EYE_PLOT_OUT_LENMIN 0
 #define    MC_CMD_KR_TUNE_POLL_EYE_PLOT_OUT_LENMAX 252
+#define    MC_CMD_KR_TUNE_POLL_EYE_PLOT_OUT_LENMAX_MCDI2 1020
 #define    MC_CMD_KR_TUNE_POLL_EYE_PLOT_OUT_LEN(num) (0+2*(num))
+#define    MC_CMD_KR_TUNE_POLL_EYE_PLOT_OUT_SAMPLES_NUM(len) (((len)-0)/2)
 #define       MC_CMD_KR_TUNE_POLL_EYE_PLOT_OUT_SAMPLES_OFST 0
 #define       MC_CMD_KR_TUNE_POLL_EYE_PLOT_OUT_SAMPLES_LEN 2
 #define       MC_CMD_KR_TUNE_POLL_EYE_PLOT_OUT_SAMPLES_MINNUM 0
 #define       MC_CMD_KR_TUNE_POLL_EYE_PLOT_OUT_SAMPLES_MAXNUM 126
+#define       MC_CMD_KR_TUNE_POLL_EYE_PLOT_OUT_SAMPLES_MAXNUM_MCDI2 510
 
 /* MC_CMD_KR_TUNE_READ_FOM_IN msgrequest */
 #define    MC_CMD_KR_TUNE_READ_FOM_IN_LEN 8
@@ -13039,8 +18114,10 @@
 #define       MC_CMD_KR_TUNE_READ_FOM_IN_KR_TUNE_RSVD_LEN 3
 #define       MC_CMD_KR_TUNE_READ_FOM_IN_LANE_OFST 4
 #define       MC_CMD_KR_TUNE_READ_FOM_IN_LANE_LEN 4
+#define        MC_CMD_KR_TUNE_READ_FOM_IN_LANE_NUM_OFST 4
 #define        MC_CMD_KR_TUNE_READ_FOM_IN_LANE_NUM_LBN 0
 #define        MC_CMD_KR_TUNE_READ_FOM_IN_LANE_NUM_WIDTH 8
+#define        MC_CMD_KR_TUNE_READ_FOM_IN_LANE_ABS_REL_OFST 4
 #define        MC_CMD_KR_TUNE_READ_FOM_IN_LANE_ABS_REL_LBN 31
 #define        MC_CMD_KR_TUNE_READ_FOM_IN_LANE_ABS_REL_WIDTH 1
 
@@ -13130,13 +18207,16 @@
  * Get or set PCIE Serdes RXEQ and TX Driver settings
  */
 #define MC_CMD_PCIE_TUNE 0xf2
+#undef MC_CMD_0xf2_PRIVILEGE_CTG
 
 #define MC_CMD_0xf2_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
 /* MC_CMD_PCIE_TUNE_IN msgrequest */
 #define    MC_CMD_PCIE_TUNE_IN_LENMIN 4
 #define    MC_CMD_PCIE_TUNE_IN_LENMAX 252
+#define    MC_CMD_PCIE_TUNE_IN_LENMAX_MCDI2 1020
 #define    MC_CMD_PCIE_TUNE_IN_LEN(num) (4+4*(num))
+#define    MC_CMD_PCIE_TUNE_IN_PCIE_TUNE_ARGS_NUM(len) (((len)-4)/4)
 /* Requested operation */
 #define       MC_CMD_PCIE_TUNE_IN_PCIE_TUNE_OP_OFST 0
 #define       MC_CMD_PCIE_TUNE_IN_PCIE_TUNE_OP_LEN 1
@@ -13165,6 +18245,7 @@
 #define       MC_CMD_PCIE_TUNE_IN_PCIE_TUNE_ARGS_LEN 4
 #define       MC_CMD_PCIE_TUNE_IN_PCIE_TUNE_ARGS_MINNUM 0
 #define       MC_CMD_PCIE_TUNE_IN_PCIE_TUNE_ARGS_MAXNUM 62
+#define       MC_CMD_PCIE_TUNE_IN_PCIE_TUNE_ARGS_MAXNUM_MCDI2 254
 
 /* MC_CMD_PCIE_TUNE_OUT msgresponse */
 #define    MC_CMD_PCIE_TUNE_OUT_LEN 0
@@ -13181,12 +18262,16 @@
 /* MC_CMD_PCIE_TUNE_RXEQ_GET_OUT msgresponse */
 #define    MC_CMD_PCIE_TUNE_RXEQ_GET_OUT_LENMIN 4
 #define    MC_CMD_PCIE_TUNE_RXEQ_GET_OUT_LENMAX 252
+#define    MC_CMD_PCIE_TUNE_RXEQ_GET_OUT_LENMAX_MCDI2 1020
 #define    MC_CMD_PCIE_TUNE_RXEQ_GET_OUT_LEN(num) (0+4*(num))
+#define    MC_CMD_PCIE_TUNE_RXEQ_GET_OUT_PARAM_NUM(len) (((len)-0)/4)
 /* RXEQ Parameter */
 #define       MC_CMD_PCIE_TUNE_RXEQ_GET_OUT_PARAM_OFST 0
 #define       MC_CMD_PCIE_TUNE_RXEQ_GET_OUT_PARAM_LEN 4
 #define       MC_CMD_PCIE_TUNE_RXEQ_GET_OUT_PARAM_MINNUM 1
 #define       MC_CMD_PCIE_TUNE_RXEQ_GET_OUT_PARAM_MAXNUM 63
+#define       MC_CMD_PCIE_TUNE_RXEQ_GET_OUT_PARAM_MAXNUM_MCDI2 255
+#define        MC_CMD_PCIE_TUNE_RXEQ_GET_OUT_PARAM_ID_OFST 0
 #define        MC_CMD_PCIE_TUNE_RXEQ_GET_OUT_PARAM_ID_LBN 0
 #define        MC_CMD_PCIE_TUNE_RXEQ_GET_OUT_PARAM_ID_WIDTH 8
 /* enum: Attenuation (0-15) */
@@ -13211,6 +18296,7 @@
 #define          MC_CMD_PCIE_TUNE_RXEQ_GET_OUT_CTLE_EQC 0x9
 /* enum: CTLE EQ Resistor (DC Gain) */
 #define          MC_CMD_PCIE_TUNE_RXEQ_GET_OUT_CTLE_EQRES 0xa
+#define        MC_CMD_PCIE_TUNE_RXEQ_GET_OUT_PARAM_LANE_OFST 0
 #define        MC_CMD_PCIE_TUNE_RXEQ_GET_OUT_PARAM_LANE_LBN 8
 #define        MC_CMD_PCIE_TUNE_RXEQ_GET_OUT_PARAM_LANE_WIDTH 5
 #define          MC_CMD_PCIE_TUNE_RXEQ_GET_OUT_LANE_0 0x0 /* enum */
@@ -13230,17 +18316,22 @@
 #define          MC_CMD_PCIE_TUNE_RXEQ_GET_OUT_LANE_14 0xe /* enum */
 #define          MC_CMD_PCIE_TUNE_RXEQ_GET_OUT_LANE_15 0xf /* enum */
 #define          MC_CMD_PCIE_TUNE_RXEQ_GET_OUT_LANE_ALL 0x10 /* enum */
+#define        MC_CMD_PCIE_TUNE_RXEQ_GET_OUT_PARAM_AUTOCAL_OFST 0
 #define        MC_CMD_PCIE_TUNE_RXEQ_GET_OUT_PARAM_AUTOCAL_LBN 13
 #define        MC_CMD_PCIE_TUNE_RXEQ_GET_OUT_PARAM_AUTOCAL_WIDTH 1
+#define        MC_CMD_PCIE_TUNE_RXEQ_GET_OUT_RESERVED_OFST 0
 #define        MC_CMD_PCIE_TUNE_RXEQ_GET_OUT_RESERVED_LBN 14
 #define        MC_CMD_PCIE_TUNE_RXEQ_GET_OUT_RESERVED_WIDTH 10
+#define        MC_CMD_PCIE_TUNE_RXEQ_GET_OUT_PARAM_CURRENT_OFST 0
 #define        MC_CMD_PCIE_TUNE_RXEQ_GET_OUT_PARAM_CURRENT_LBN 24
 #define        MC_CMD_PCIE_TUNE_RXEQ_GET_OUT_PARAM_CURRENT_WIDTH 8
 
 /* MC_CMD_PCIE_TUNE_RXEQ_SET_IN msgrequest */
 #define    MC_CMD_PCIE_TUNE_RXEQ_SET_IN_LENMIN 8
 #define    MC_CMD_PCIE_TUNE_RXEQ_SET_IN_LENMAX 252
+#define    MC_CMD_PCIE_TUNE_RXEQ_SET_IN_LENMAX_MCDI2 1020
 #define    MC_CMD_PCIE_TUNE_RXEQ_SET_IN_LEN(num) (4+4*(num))
+#define    MC_CMD_PCIE_TUNE_RXEQ_SET_IN_PARAM_NUM(len) (((len)-4)/4)
 /* Requested operation */
 #define       MC_CMD_PCIE_TUNE_RXEQ_SET_IN_PCIE_TUNE_OP_OFST 0
 #define       MC_CMD_PCIE_TUNE_RXEQ_SET_IN_PCIE_TUNE_OP_LEN 1
@@ -13252,20 +18343,27 @@
 #define       MC_CMD_PCIE_TUNE_RXEQ_SET_IN_PARAM_LEN 4
 #define       MC_CMD_PCIE_TUNE_RXEQ_SET_IN_PARAM_MINNUM 1
 #define       MC_CMD_PCIE_TUNE_RXEQ_SET_IN_PARAM_MAXNUM 62
+#define       MC_CMD_PCIE_TUNE_RXEQ_SET_IN_PARAM_MAXNUM_MCDI2 254
+#define        MC_CMD_PCIE_TUNE_RXEQ_SET_IN_PARAM_ID_OFST 4
 #define        MC_CMD_PCIE_TUNE_RXEQ_SET_IN_PARAM_ID_LBN 0
 #define        MC_CMD_PCIE_TUNE_RXEQ_SET_IN_PARAM_ID_WIDTH 8
 /*             Enum values, see field(s): */
 /*                MC_CMD_PCIE_TUNE_RXEQ_GET_OUT/PARAM_ID */
+#define        MC_CMD_PCIE_TUNE_RXEQ_SET_IN_PARAM_LANE_OFST 4
 #define        MC_CMD_PCIE_TUNE_RXEQ_SET_IN_PARAM_LANE_LBN 8
 #define        MC_CMD_PCIE_TUNE_RXEQ_SET_IN_PARAM_LANE_WIDTH 5
 /*             Enum values, see field(s): */
 /*                MC_CMD_PCIE_TUNE_RXEQ_GET_OUT/PARAM_LANE */
+#define        MC_CMD_PCIE_TUNE_RXEQ_SET_IN_PARAM_AUTOCAL_OFST 4
 #define        MC_CMD_PCIE_TUNE_RXEQ_SET_IN_PARAM_AUTOCAL_LBN 13
 #define        MC_CMD_PCIE_TUNE_RXEQ_SET_IN_PARAM_AUTOCAL_WIDTH 1
+#define        MC_CMD_PCIE_TUNE_RXEQ_SET_IN_RESERVED_OFST 4
 #define        MC_CMD_PCIE_TUNE_RXEQ_SET_IN_RESERVED_LBN 14
 #define        MC_CMD_PCIE_TUNE_RXEQ_SET_IN_RESERVED_WIDTH 2
+#define        MC_CMD_PCIE_TUNE_RXEQ_SET_IN_PARAM_INITIAL_OFST 4
 #define        MC_CMD_PCIE_TUNE_RXEQ_SET_IN_PARAM_INITIAL_LBN 16
 #define        MC_CMD_PCIE_TUNE_RXEQ_SET_IN_PARAM_INITIAL_WIDTH 8
+#define        MC_CMD_PCIE_TUNE_RXEQ_SET_IN_RESERVED2_OFST 4
 #define        MC_CMD_PCIE_TUNE_RXEQ_SET_IN_RESERVED2_LBN 24
 #define        MC_CMD_PCIE_TUNE_RXEQ_SET_IN_RESERVED2_WIDTH 8
 
@@ -13284,12 +18382,16 @@
 /* MC_CMD_PCIE_TUNE_TXEQ_GET_OUT msgresponse */
 #define    MC_CMD_PCIE_TUNE_TXEQ_GET_OUT_LENMIN 4
 #define    MC_CMD_PCIE_TUNE_TXEQ_GET_OUT_LENMAX 252
+#define    MC_CMD_PCIE_TUNE_TXEQ_GET_OUT_LENMAX_MCDI2 1020
 #define    MC_CMD_PCIE_TUNE_TXEQ_GET_OUT_LEN(num) (0+4*(num))
+#define    MC_CMD_PCIE_TUNE_TXEQ_GET_OUT_PARAM_NUM(len) (((len)-0)/4)
 /* RXEQ Parameter */
 #define       MC_CMD_PCIE_TUNE_TXEQ_GET_OUT_PARAM_OFST 0
 #define       MC_CMD_PCIE_TUNE_TXEQ_GET_OUT_PARAM_LEN 4
 #define       MC_CMD_PCIE_TUNE_TXEQ_GET_OUT_PARAM_MINNUM 1
 #define       MC_CMD_PCIE_TUNE_TXEQ_GET_OUT_PARAM_MAXNUM 63
+#define       MC_CMD_PCIE_TUNE_TXEQ_GET_OUT_PARAM_MAXNUM_MCDI2 255
+#define        MC_CMD_PCIE_TUNE_TXEQ_GET_OUT_PARAM_ID_OFST 0
 #define        MC_CMD_PCIE_TUNE_TXEQ_GET_OUT_PARAM_ID_LBN 0
 #define        MC_CMD_PCIE_TUNE_TXEQ_GET_OUT_PARAM_ID_WIDTH 8
 /* enum: TxMargin (PIPE) */
@@ -13302,12 +18404,15 @@
 #define          MC_CMD_PCIE_TUNE_TXEQ_GET_OUT_C0 0x3
 /* enum: De-emphasis coefficient C(+1) (PIPE) */
 #define          MC_CMD_PCIE_TUNE_TXEQ_GET_OUT_CP1 0x4
+#define        MC_CMD_PCIE_TUNE_TXEQ_GET_OUT_PARAM_LANE_OFST 0
 #define        MC_CMD_PCIE_TUNE_TXEQ_GET_OUT_PARAM_LANE_LBN 8
 #define        MC_CMD_PCIE_TUNE_TXEQ_GET_OUT_PARAM_LANE_WIDTH 4
 /*             Enum values, see field(s): */
 /*                MC_CMD_PCIE_TUNE_RXEQ_GET_OUT/PARAM_LANE */
+#define        MC_CMD_PCIE_TUNE_TXEQ_GET_OUT_RESERVED_OFST 0
 #define        MC_CMD_PCIE_TUNE_TXEQ_GET_OUT_RESERVED_LBN 12
 #define        MC_CMD_PCIE_TUNE_TXEQ_GET_OUT_RESERVED_WIDTH 12
+#define        MC_CMD_PCIE_TUNE_TXEQ_GET_OUT_PARAM_CURRENT_OFST 0
 #define        MC_CMD_PCIE_TUNE_TXEQ_GET_OUT_PARAM_CURRENT_LBN 24
 #define        MC_CMD_PCIE_TUNE_TXEQ_GET_OUT_PARAM_CURRENT_WIDTH 8
 
@@ -13337,11 +18442,14 @@
 /* MC_CMD_PCIE_TUNE_POLL_EYE_PLOT_OUT msgresponse */
 #define    MC_CMD_PCIE_TUNE_POLL_EYE_PLOT_OUT_LENMIN 0
 #define    MC_CMD_PCIE_TUNE_POLL_EYE_PLOT_OUT_LENMAX 252
+#define    MC_CMD_PCIE_TUNE_POLL_EYE_PLOT_OUT_LENMAX_MCDI2 1020
 #define    MC_CMD_PCIE_TUNE_POLL_EYE_PLOT_OUT_LEN(num) (0+2*(num))
+#define    MC_CMD_PCIE_TUNE_POLL_EYE_PLOT_OUT_SAMPLES_NUM(len) (((len)-0)/2)
 #define       MC_CMD_PCIE_TUNE_POLL_EYE_PLOT_OUT_SAMPLES_OFST 0
 #define       MC_CMD_PCIE_TUNE_POLL_EYE_PLOT_OUT_SAMPLES_LEN 2
 #define       MC_CMD_PCIE_TUNE_POLL_EYE_PLOT_OUT_SAMPLES_MINNUM 0
 #define       MC_CMD_PCIE_TUNE_POLL_EYE_PLOT_OUT_SAMPLES_MAXNUM 126
+#define       MC_CMD_PCIE_TUNE_POLL_EYE_PLOT_OUT_SAMPLES_MAXNUM_MCDI2 510
 
 /* MC_CMD_PCIE_TUNE_BIST_SQUARE_WAVE_IN msgrequest */
 #define    MC_CMD_PCIE_TUNE_BIST_SQUARE_WAVE_IN_LEN 0
@@ -13356,6 +18464,7 @@
  * - not used for V3 licensing
  */
 #define MC_CMD_LICENSING 0xf3
+#undef MC_CMD_0xf3_PRIVILEGE_CTG
 
 #define MC_CMD_0xf3_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -13411,6 +18520,7 @@
  * - V3 licensing (Medford)
  */
 #define MC_CMD_LICENSING_V3 0xd0
+#undef MC_CMD_0xd0_PRIVILEGE_CTG
 
 #define MC_CMD_0xd0_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -13480,6 +18590,7 @@
  * partition - V3 licensing (Medford)
  */
 #define MC_CMD_LICENSING_GET_ID_V3 0xd1
+#undef MC_CMD_0xd1_PRIVILEGE_CTG
 
 #define MC_CMD_0xd1_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -13489,7 +18600,9 @@
 /* MC_CMD_LICENSING_GET_ID_V3_OUT msgresponse */
 #define    MC_CMD_LICENSING_GET_ID_V3_OUT_LENMIN 8
 #define    MC_CMD_LICENSING_GET_ID_V3_OUT_LENMAX 252
+#define    MC_CMD_LICENSING_GET_ID_V3_OUT_LENMAX_MCDI2 1020
 #define    MC_CMD_LICENSING_GET_ID_V3_OUT_LEN(num) (8+1*(num))
+#define    MC_CMD_LICENSING_GET_ID_V3_OUT_LICENSE_ID_NUM(len) (((len)-8)/1)
 /* type of license (eg 3) */
 #define       MC_CMD_LICENSING_GET_ID_V3_OUT_LICENSE_TYPE_OFST 0
 #define       MC_CMD_LICENSING_GET_ID_V3_OUT_LICENSE_TYPE_LEN 4
@@ -13501,6 +18614,7 @@
 #define       MC_CMD_LICENSING_GET_ID_V3_OUT_LICENSE_ID_LEN 1
 #define       MC_CMD_LICENSING_GET_ID_V3_OUT_LICENSE_ID_MINNUM 0
 #define       MC_CMD_LICENSING_GET_ID_V3_OUT_LICENSE_ID_MAXNUM 244
+#define       MC_CMD_LICENSING_GET_ID_V3_OUT_LICENSE_ID_MAXNUM_MCDI2 1012
 
 
 /***********************************/
@@ -13509,6 +18623,7 @@
  * This will fail on a single-core system.
  */
 #define MC_CMD_MC2MC_PROXY 0xf4
+#undef MC_CMD_0xf4_PRIVILEGE_CTG
 
 #define MC_CMD_0xf4_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -13526,6 +18641,7 @@
  * or a reboot of the MC.) Not used for V3 licensing
  */
 #define MC_CMD_GET_LICENSED_APP_STATE 0xf5
+#undef MC_CMD_0xf5_PRIVILEGE_CTG
 
 #define MC_CMD_0xf5_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -13553,6 +18669,7 @@
  * operation or a reboot of the MC.) Used for V3 licensing (Medford)
  */
 #define MC_CMD_GET_LICENSED_V3_APP_STATE 0xd2
+#undef MC_CMD_0xd2_PRIVILEGE_CTG
 
 #define MC_CMD_0xd2_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -13579,11 +18696,12 @@
 
 /***********************************/
 /* MC_CMD_GET_LICENSED_V3_FEATURE_STATES
- * Query the state of one or more licensed features. (Note that the actual
+ * Query the state of an one or more licensed features. (Note that the actual
  * state may be invalidated by the MC_CMD_LICENSING_V3 OP_UPDATE_LICENSE
  * operation or a reboot of the MC.) Used for V3 licensing (Medford)
  */
 #define MC_CMD_GET_LICENSED_V3_FEATURE_STATES 0xd3
+#undef MC_CMD_0xd3_PRIVILEGE_CTG
 
 #define MC_CMD_0xd3_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -13612,13 +18730,16 @@
  * licensing.
  */
 #define MC_CMD_LICENSED_APP_OP 0xf6
+#undef MC_CMD_0xf6_PRIVILEGE_CTG
 
 #define MC_CMD_0xf6_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
 /* MC_CMD_LICENSED_APP_OP_IN msgrequest */
 #define    MC_CMD_LICENSED_APP_OP_IN_LENMIN 8
 #define    MC_CMD_LICENSED_APP_OP_IN_LENMAX 252
+#define    MC_CMD_LICENSED_APP_OP_IN_LENMAX_MCDI2 1020
 #define    MC_CMD_LICENSED_APP_OP_IN_LEN(num) (8+4*(num))
+#define    MC_CMD_LICENSED_APP_OP_IN_ARGS_NUM(len) (((len)-8)/4)
 /* application ID */
 #define       MC_CMD_LICENSED_APP_OP_IN_APP_ID_OFST 0
 #define       MC_CMD_LICENSED_APP_OP_IN_APP_ID_LEN 4
@@ -13634,16 +18755,20 @@
 #define       MC_CMD_LICENSED_APP_OP_IN_ARGS_LEN 4
 #define       MC_CMD_LICENSED_APP_OP_IN_ARGS_MINNUM 0
 #define       MC_CMD_LICENSED_APP_OP_IN_ARGS_MAXNUM 61
+#define       MC_CMD_LICENSED_APP_OP_IN_ARGS_MAXNUM_MCDI2 253
 
 /* MC_CMD_LICENSED_APP_OP_OUT msgresponse */
 #define    MC_CMD_LICENSED_APP_OP_OUT_LENMIN 0
 #define    MC_CMD_LICENSED_APP_OP_OUT_LENMAX 252
+#define    MC_CMD_LICENSED_APP_OP_OUT_LENMAX_MCDI2 1020
 #define    MC_CMD_LICENSED_APP_OP_OUT_LEN(num) (0+4*(num))
+#define    MC_CMD_LICENSED_APP_OP_OUT_RESULT_NUM(len) (((len)-0)/4)
 /* result specific to this particular operation */
 #define       MC_CMD_LICENSED_APP_OP_OUT_RESULT_OFST 0
 #define       MC_CMD_LICENSED_APP_OP_OUT_RESULT_LEN 4
 #define       MC_CMD_LICENSED_APP_OP_OUT_RESULT_MINNUM 0
 #define       MC_CMD_LICENSED_APP_OP_OUT_RESULT_MAXNUM 63
+#define       MC_CMD_LICENSED_APP_OP_OUT_RESULT_MAXNUM_MCDI2 255
 
 /* MC_CMD_LICENSED_APP_OP_VALIDATE_IN msgrequest */
 #define    MC_CMD_LICENSED_APP_OP_VALIDATE_IN_LEN 72
@@ -13688,6 +18813,7 @@
  * (Medford)
  */
 #define MC_CMD_LICENSED_V3_VALIDATE_APP 0xd4
+#undef MC_CMD_0xd4_PRIVILEGE_CTG
 
 #define MC_CMD_0xd4_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -13740,6 +18866,7 @@
  * Mask features - V3 licensing (Medford)
  */
 #define MC_CMD_LICENSED_V3_MASK_FEATURES 0xd5
+#undef MC_CMD_0xd5_PRIVILEGE_CTG
 
 #define MC_CMD_0xd5_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
@@ -13771,6 +18898,7 @@
  * erased when the adapter is power cycled
  */
 #define MC_CMD_LICENSING_V3_TEMPORARY 0xd6
+#undef MC_CMD_0xd6_PRIVILEGE_CTG
 
 #define MC_CMD_0xd6_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
@@ -13840,6 +18968,7 @@
  * delivered to a specific queue, or a set of queues with RSS.
  */
 #define MC_CMD_SET_PORT_SNIFF_CONFIG 0xf7
+#undef MC_CMD_0xf7_PRIVILEGE_CTG
 
 #define MC_CMD_0xf7_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
@@ -13848,8 +18977,10 @@
 /* configuration flags */
 #define       MC_CMD_SET_PORT_SNIFF_CONFIG_IN_FLAGS_OFST 0
 #define       MC_CMD_SET_PORT_SNIFF_CONFIG_IN_FLAGS_LEN 4
+#define        MC_CMD_SET_PORT_SNIFF_CONFIG_IN_ENABLE_OFST 0
 #define        MC_CMD_SET_PORT_SNIFF_CONFIG_IN_ENABLE_LBN 0
 #define        MC_CMD_SET_PORT_SNIFF_CONFIG_IN_ENABLE_WIDTH 1
+#define        MC_CMD_SET_PORT_SNIFF_CONFIG_IN_PROMISCUOUS_OFST 0
 #define        MC_CMD_SET_PORT_SNIFF_CONFIG_IN_PROMISCUOUS_LBN 1
 #define        MC_CMD_SET_PORT_SNIFF_CONFIG_IN_PROMISCUOUS_WIDTH 1
 /* receive queue handle (for RSS mode, this is the base queue) */
@@ -13880,6 +19011,7 @@
  * the configuration.
  */
 #define MC_CMD_GET_PORT_SNIFF_CONFIG 0xf8
+#undef MC_CMD_0xf8_PRIVILEGE_CTG
 
 #define MC_CMD_0xf8_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -13891,8 +19023,10 @@
 /* configuration flags */
 #define       MC_CMD_GET_PORT_SNIFF_CONFIG_OUT_FLAGS_OFST 0
 #define       MC_CMD_GET_PORT_SNIFF_CONFIG_OUT_FLAGS_LEN 4
+#define        MC_CMD_GET_PORT_SNIFF_CONFIG_OUT_ENABLE_OFST 0
 #define        MC_CMD_GET_PORT_SNIFF_CONFIG_OUT_ENABLE_LBN 0
 #define        MC_CMD_GET_PORT_SNIFF_CONFIG_OUT_ENABLE_WIDTH 1
+#define        MC_CMD_GET_PORT_SNIFF_CONFIG_OUT_PROMISCUOUS_OFST 0
 #define        MC_CMD_GET_PORT_SNIFF_CONFIG_OUT_PROMISCUOUS_LBN 1
 #define        MC_CMD_GET_PORT_SNIFF_CONFIG_OUT_PROMISCUOUS_WIDTH 1
 /* receiving queue handle (for RSS mode, this is the base queue) */
@@ -13915,13 +19049,16 @@
  * Change configuration related to the parser-dispatcher subsystem.
  */
 #define MC_CMD_SET_PARSER_DISP_CONFIG 0xf9
+#undef MC_CMD_0xf9_PRIVILEGE_CTG
 
 #define MC_CMD_0xf9_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
 /* MC_CMD_SET_PARSER_DISP_CONFIG_IN msgrequest */
 #define    MC_CMD_SET_PARSER_DISP_CONFIG_IN_LENMIN 12
 #define    MC_CMD_SET_PARSER_DISP_CONFIG_IN_LENMAX 252
+#define    MC_CMD_SET_PARSER_DISP_CONFIG_IN_LENMAX_MCDI2 1020
 #define    MC_CMD_SET_PARSER_DISP_CONFIG_IN_LEN(num) (8+4*(num))
+#define    MC_CMD_SET_PARSER_DISP_CONFIG_IN_VALUE_NUM(len) (((len)-8)/4)
 /* the type of configuration setting to change */
 #define       MC_CMD_SET_PARSER_DISP_CONFIG_IN_TYPE_OFST 0
 #define       MC_CMD_SET_PARSER_DISP_CONFIG_IN_TYPE_LEN 4
@@ -13946,6 +19083,7 @@
 #define       MC_CMD_SET_PARSER_DISP_CONFIG_IN_VALUE_LEN 4
 #define       MC_CMD_SET_PARSER_DISP_CONFIG_IN_VALUE_MINNUM 1
 #define       MC_CMD_SET_PARSER_DISP_CONFIG_IN_VALUE_MAXNUM 61
+#define       MC_CMD_SET_PARSER_DISP_CONFIG_IN_VALUE_MAXNUM_MCDI2 253
 
 /* MC_CMD_SET_PARSER_DISP_CONFIG_OUT msgresponse */
 #define    MC_CMD_SET_PARSER_DISP_CONFIG_OUT_LEN 0
@@ -13956,6 +19094,7 @@
  * Read configuration related to the parser-dispatcher subsystem.
  */
 #define MC_CMD_GET_PARSER_DISP_CONFIG 0xfa
+#undef MC_CMD_0xfa_PRIVILEGE_CTG
 
 #define MC_CMD_0xfa_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -13975,7 +19114,9 @@
 /* MC_CMD_GET_PARSER_DISP_CONFIG_OUT msgresponse */
 #define    MC_CMD_GET_PARSER_DISP_CONFIG_OUT_LENMIN 4
 #define    MC_CMD_GET_PARSER_DISP_CONFIG_OUT_LENMAX 252
+#define    MC_CMD_GET_PARSER_DISP_CONFIG_OUT_LENMAX_MCDI2 1020
 #define    MC_CMD_GET_PARSER_DISP_CONFIG_OUT_LEN(num) (0+4*(num))
+#define    MC_CMD_GET_PARSER_DISP_CONFIG_OUT_VALUE_NUM(len) (((len)-0)/4)
 /* current value: the details depend on the type of configuration setting being
  * read
  */
@@ -13983,6 +19124,7 @@
 #define       MC_CMD_GET_PARSER_DISP_CONFIG_OUT_VALUE_LEN 4
 #define       MC_CMD_GET_PARSER_DISP_CONFIG_OUT_VALUE_MINNUM 1
 #define       MC_CMD_GET_PARSER_DISP_CONFIG_OUT_VALUE_MAXNUM 63
+#define       MC_CMD_GET_PARSER_DISP_CONFIG_OUT_VALUE_MAXNUM_MCDI2 255
 
 
 /***********************************/
@@ -13996,6 +19138,7 @@
  * dedicated as TX sniff receivers.
  */
 #define MC_CMD_SET_TX_PORT_SNIFF_CONFIG 0xfb
+#undef MC_CMD_0xfb_PRIVILEGE_CTG
 
 #define MC_CMD_0xfb_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
@@ -14004,6 +19147,7 @@
 /* configuration flags */
 #define       MC_CMD_SET_TX_PORT_SNIFF_CONFIG_IN_FLAGS_OFST 0
 #define       MC_CMD_SET_TX_PORT_SNIFF_CONFIG_IN_FLAGS_LEN 4
+#define        MC_CMD_SET_TX_PORT_SNIFF_CONFIG_IN_ENABLE_OFST 0
 #define        MC_CMD_SET_TX_PORT_SNIFF_CONFIG_IN_ENABLE_LBN 0
 #define        MC_CMD_SET_TX_PORT_SNIFF_CONFIG_IN_ENABLE_WIDTH 1
 /* receive queue handle (for RSS mode, this is the base queue) */
@@ -14034,6 +19178,7 @@
  * the configuration.
  */
 #define MC_CMD_GET_TX_PORT_SNIFF_CONFIG 0xfc
+#undef MC_CMD_0xfc_PRIVILEGE_CTG
 
 #define MC_CMD_0xfc_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -14045,6 +19190,7 @@
 /* configuration flags */
 #define       MC_CMD_GET_TX_PORT_SNIFF_CONFIG_OUT_FLAGS_OFST 0
 #define       MC_CMD_GET_TX_PORT_SNIFF_CONFIG_OUT_FLAGS_LEN 4
+#define        MC_CMD_GET_TX_PORT_SNIFF_CONFIG_OUT_ENABLE_OFST 0
 #define        MC_CMD_GET_TX_PORT_SNIFF_CONFIG_OUT_ENABLE_LBN 0
 #define        MC_CMD_GET_TX_PORT_SNIFF_CONFIG_OUT_ENABLE_WIDTH 1
 /* receiving queue handle (for RSS mode, this is the base queue) */
@@ -14067,6 +19213,7 @@
  * Per queue rx error stats.
  */
 #define MC_CMD_RMON_STATS_RX_ERRORS 0xfe
+#undef MC_CMD_0xfe_PRIVILEGE_CTG
 
 #define MC_CMD_0xfe_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -14077,6 +19224,7 @@
 #define       MC_CMD_RMON_STATS_RX_ERRORS_IN_RX_QUEUE_LEN 4
 #define       MC_CMD_RMON_STATS_RX_ERRORS_IN_FLAGS_OFST 4
 #define       MC_CMD_RMON_STATS_RX_ERRORS_IN_FLAGS_LEN 4
+#define        MC_CMD_RMON_STATS_RX_ERRORS_IN_RST_OFST 4
 #define        MC_CMD_RMON_STATS_RX_ERRORS_IN_RST_LBN 0
 #define        MC_CMD_RMON_STATS_RX_ERRORS_IN_RST_WIDTH 1
 
@@ -14097,6 +19245,7 @@
  * Find out about available PCIE resources
  */
 #define MC_CMD_GET_PCIE_RESOURCE_INFO 0xfd
+#undef MC_CMD_0xfd_PRIVILEGE_CTG
 
 #define MC_CMD_0xfd_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -14135,6 +19284,7 @@
  * Find out about available port modes
  */
 #define MC_CMD_GET_PORT_MODES 0xff
+#undef MC_CMD_0xff_PRIVILEGE_CTG
 
 #define MC_CMD_0xff_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -14143,7 +19293,9 @@
 
 /* MC_CMD_GET_PORT_MODES_OUT msgresponse */
 #define    MC_CMD_GET_PORT_MODES_OUT_LEN 12
-/* Bitmask of port modes available on the board (indexed by TLV_PORT_MODE_*) */
+/* Bitmask of port modes available on the board (indexed by TLV_PORT_MODE_*)
+ * that are supported for customer use in production firmware.
+ */
 #define       MC_CMD_GET_PORT_MODES_OUT_MODES_OFST 0
 #define       MC_CMD_GET_PORT_MODES_OUT_MODES_LEN 4
 /* Default (canonical) board mode */
@@ -14153,12 +19305,66 @@
 #define       MC_CMD_GET_PORT_MODES_OUT_CURRENT_MODE_OFST 8
 #define       MC_CMD_GET_PORT_MODES_OUT_CURRENT_MODE_LEN 4
 
+/* MC_CMD_GET_PORT_MODES_OUT_V2 msgresponse */
+#define    MC_CMD_GET_PORT_MODES_OUT_V2_LEN 16
+/* Bitmask of port modes available on the board (indexed by TLV_PORT_MODE_*)
+ * that are supported for customer use in production firmware.
+ */
+#define       MC_CMD_GET_PORT_MODES_OUT_V2_MODES_OFST 0
+#define       MC_CMD_GET_PORT_MODES_OUT_V2_MODES_LEN 4
+/* Default (canonical) board mode */
+#define       MC_CMD_GET_PORT_MODES_OUT_V2_DEFAULT_MODE_OFST 4
+#define       MC_CMD_GET_PORT_MODES_OUT_V2_DEFAULT_MODE_LEN 4
+/* Current board mode */
+#define       MC_CMD_GET_PORT_MODES_OUT_V2_CURRENT_MODE_OFST 8
+#define       MC_CMD_GET_PORT_MODES_OUT_V2_CURRENT_MODE_LEN 4
+/* Bitmask of engineering port modes available on the board (indexed by
+ * TLV_PORT_MODE_*). A superset of MC_CMD_GET_PORT_MODES_OUT/MODES that
+ * contains all modes implemented in firmware for a particular board. Modes
+ * listed in MODES are considered production modes and should be exposed in
+ * userland tools. Modes listed in in ENGINEERING_MODES, but not in MODES
+ * should be considered hidden (not to be exposed in userland tools) and for
+ * engineering use only. There are no other semantic differences and any mode
+ * listed in either MODES or ENGINEERING_MODES can be set on the board.
+ */
+#define       MC_CMD_GET_PORT_MODES_OUT_V2_ENGINEERING_MODES_OFST 12
+#define       MC_CMD_GET_PORT_MODES_OUT_V2_ENGINEERING_MODES_LEN 4
+
+
+/***********************************/
+/* MC_CMD_OVERRIDE_PORT_MODE
+ * Override flash config port mode for subsequent MC reboot(s). Override data
+ * is stored in the presistent data section of DMEM and activated on next MC
+ * warm reboot. A cold reboot resets the override. It is assumed that a
+ * sufficient number of PFs are available and that port mapping is valid for
+ * the new port mode, as the override does not affect PF configuration.
+ */
+#define MC_CMD_OVERRIDE_PORT_MODE 0x137
+#undef MC_CMD_0x137_PRIVILEGE_CTG
+
+#define MC_CMD_0x137_PRIVILEGE_CTG SRIOV_CTG_ADMIN
+
+/* MC_CMD_OVERRIDE_PORT_MODE_IN msgrequest */
+#define    MC_CMD_OVERRIDE_PORT_MODE_IN_LEN 8
+#define       MC_CMD_OVERRIDE_PORT_MODE_IN_FLAGS_OFST 0
+#define       MC_CMD_OVERRIDE_PORT_MODE_IN_FLAGS_LEN 4
+#define        MC_CMD_OVERRIDE_PORT_MODE_IN_ENABLE_OFST 0
+#define        MC_CMD_OVERRIDE_PORT_MODE_IN_ENABLE_LBN 0
+#define        MC_CMD_OVERRIDE_PORT_MODE_IN_ENABLE_WIDTH 1
+/* New mode (TLV_PORT_MODE_*) to set, if override enabled */
+#define       MC_CMD_OVERRIDE_PORT_MODE_IN_MODE_OFST 4
+#define       MC_CMD_OVERRIDE_PORT_MODE_IN_MODE_LEN 4
+
+/* MC_CMD_OVERRIDE_PORT_MODE_OUT msgresponse */
+#define    MC_CMD_OVERRIDE_PORT_MODE_OUT_LEN 0
+
 
 /***********************************/
 /* MC_CMD_READ_ATB
  * Sample voltages on the ATB
  */
 #define MC_CMD_READ_ATB 0x100
+#undef MC_CMD_0x100_PRIVILEGE_CTG
 
 #define MC_CMD_0x100_PRIVILEGE_CTG SRIOV_CTG_INSECURE
 
@@ -14188,6 +19394,7 @@
  * enums here must correspond with those in MC_CMD_WORKAROUND.
  */
 #define MC_CMD_GET_WORKAROUNDS 0x59
+#undef MC_CMD_0x59_PRIVILEGE_CTG
 
 #define MC_CMD_0x59_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -14224,6 +19431,7 @@
  * Read/set privileges of an arbitrary PCIe function
  */
 #define MC_CMD_PRIVILEGE_MASK 0x5a
+#undef MC_CMD_0x5a_PRIVILEGE_CTG
 
 #define MC_CMD_0x5a_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -14234,8 +19442,10 @@
  */
 #define       MC_CMD_PRIVILEGE_MASK_IN_FUNCTION_OFST 0
 #define       MC_CMD_PRIVILEGE_MASK_IN_FUNCTION_LEN 4
+#define        MC_CMD_PRIVILEGE_MASK_IN_FUNCTION_PF_OFST 0
 #define        MC_CMD_PRIVILEGE_MASK_IN_FUNCTION_PF_LBN 0
 #define        MC_CMD_PRIVILEGE_MASK_IN_FUNCTION_PF_WIDTH 16
+#define        MC_CMD_PRIVILEGE_MASK_IN_FUNCTION_VF_OFST 0
 #define        MC_CMD_PRIVILEGE_MASK_IN_FUNCTION_VF_LBN 16
 #define        MC_CMD_PRIVILEGE_MASK_IN_FUNCTION_VF_WIDTH 16
 #define          MC_CMD_PRIVILEGE_MASK_IN_VF_NULL 0xffff /* enum */
@@ -14274,6 +19484,12 @@
  * are not permitted on secure adapters regardless of the privilege mask.
  */
 #define          MC_CMD_PRIVILEGE_MASK_IN_GRP_INSECURE 0x4000
+/* enum: Trusted Server Adapter (TSA) / ServerLock. Privilege for
+ * administrator-level operations that are not allowed from the local host once
+ * an adapter has Bound to a remote ServerLock Controller (see doxbox
+ * SF-117064-DG for background).
+ */
+#define          MC_CMD_PRIVILEGE_MASK_IN_GRP_ADMIN_TSA_UNBOUND 0x8000
 /* enum: Set this bit to indicate that a new privilege mask is to be set,
  * otherwise the command will only read the existing mask.
  */
@@ -14291,6 +19507,7 @@
  * Read/set link state mode of a VF
  */
 #define MC_CMD_LINK_STATE_MODE 0x5c
+#undef MC_CMD_0x5c_PRIVILEGE_CTG
 
 #define MC_CMD_0x5c_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -14301,8 +19518,10 @@
  */
 #define       MC_CMD_LINK_STATE_MODE_IN_FUNCTION_OFST 0
 #define       MC_CMD_LINK_STATE_MODE_IN_FUNCTION_LEN 4
+#define        MC_CMD_LINK_STATE_MODE_IN_FUNCTION_PF_OFST 0
 #define        MC_CMD_LINK_STATE_MODE_IN_FUNCTION_PF_LBN 0
 #define        MC_CMD_LINK_STATE_MODE_IN_FUNCTION_PF_WIDTH 16
+#define        MC_CMD_LINK_STATE_MODE_IN_FUNCTION_VF_OFST 0
 #define        MC_CMD_LINK_STATE_MODE_IN_FUNCTION_VF_LBN 16
 #define        MC_CMD_LINK_STATE_MODE_IN_FUNCTION_VF_WIDTH 16
 /* New link state mode to be set */
@@ -14327,6 +19546,7 @@
  * parameter to MC_CMD_INIT_RXQ.
  */
 #define MC_CMD_GET_SNAPSHOT_LENGTH 0x101
+#undef MC_CMD_0x101_PRIVILEGE_CTG
 
 #define MC_CMD_0x101_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -14348,6 +19568,7 @@
  * Additional fuse diagnostics
  */
 #define MC_CMD_FUSE_DIAGS 0x102
+#undef MC_CMD_0x102_PRIVILEGE_CTG
 
 #define MC_CMD_0x102_PRIVILEGE_CTG SRIOV_CTG_INSECURE
 
@@ -14401,6 +19622,7 @@
  * included in one of the masks provided.
  */
 #define MC_CMD_PRIVILEGE_MODIFY 0x60
+#undef MC_CMD_0x60_PRIVILEGE_CTG
 
 #define MC_CMD_0x60_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
@@ -14418,8 +19640,10 @@
 /* For VFS_OF_PF specify the PF, for ONE specify the target function */
 #define       MC_CMD_PRIVILEGE_MODIFY_IN_FUNCTION_OFST 4
 #define       MC_CMD_PRIVILEGE_MODIFY_IN_FUNCTION_LEN 4
+#define        MC_CMD_PRIVILEGE_MODIFY_IN_FUNCTION_PF_OFST 4
 #define        MC_CMD_PRIVILEGE_MODIFY_IN_FUNCTION_PF_LBN 0
 #define        MC_CMD_PRIVILEGE_MODIFY_IN_FUNCTION_PF_WIDTH 16
+#define        MC_CMD_PRIVILEGE_MODIFY_IN_FUNCTION_VF_OFST 4
 #define        MC_CMD_PRIVILEGE_MODIFY_IN_FUNCTION_VF_LBN 16
 #define        MC_CMD_PRIVILEGE_MODIFY_IN_FUNCTION_VF_WIDTH 16
 /* Privileges to be added to the target functions. For privilege definitions
@@ -14442,6 +19666,7 @@
  * Read XPM memory
  */
 #define MC_CMD_XPM_READ_BYTES 0x103
+#undef MC_CMD_0x103_PRIVILEGE_CTG
 
 #define MC_CMD_0x103_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
@@ -14457,12 +19682,15 @@
 /* MC_CMD_XPM_READ_BYTES_OUT msgresponse */
 #define    MC_CMD_XPM_READ_BYTES_OUT_LENMIN 0
 #define    MC_CMD_XPM_READ_BYTES_OUT_LENMAX 252
+#define    MC_CMD_XPM_READ_BYTES_OUT_LENMAX_MCDI2 1020
 #define    MC_CMD_XPM_READ_BYTES_OUT_LEN(num) (0+1*(num))
+#define    MC_CMD_XPM_READ_BYTES_OUT_DATA_NUM(len) (((len)-0)/1)
 /* Data */
 #define       MC_CMD_XPM_READ_BYTES_OUT_DATA_OFST 0
 #define       MC_CMD_XPM_READ_BYTES_OUT_DATA_LEN 1
 #define       MC_CMD_XPM_READ_BYTES_OUT_DATA_MINNUM 0
 #define       MC_CMD_XPM_READ_BYTES_OUT_DATA_MAXNUM 252
+#define       MC_CMD_XPM_READ_BYTES_OUT_DATA_MAXNUM_MCDI2 1020
 
 
 /***********************************/
@@ -14470,13 +19698,16 @@
  * Write XPM memory
  */
 #define MC_CMD_XPM_WRITE_BYTES 0x104
+#undef MC_CMD_0x104_PRIVILEGE_CTG
 
 #define MC_CMD_0x104_PRIVILEGE_CTG SRIOV_CTG_INSECURE
 
 /* MC_CMD_XPM_WRITE_BYTES_IN msgrequest */
 #define    MC_CMD_XPM_WRITE_BYTES_IN_LENMIN 8
 #define    MC_CMD_XPM_WRITE_BYTES_IN_LENMAX 252
+#define    MC_CMD_XPM_WRITE_BYTES_IN_LENMAX_MCDI2 1020
 #define    MC_CMD_XPM_WRITE_BYTES_IN_LEN(num) (8+1*(num))
+#define    MC_CMD_XPM_WRITE_BYTES_IN_DATA_NUM(len) (((len)-8)/1)
 /* Start address (byte) */
 #define       MC_CMD_XPM_WRITE_BYTES_IN_ADDR_OFST 0
 #define       MC_CMD_XPM_WRITE_BYTES_IN_ADDR_LEN 4
@@ -14488,6 +19719,7 @@
 #define       MC_CMD_XPM_WRITE_BYTES_IN_DATA_LEN 1
 #define       MC_CMD_XPM_WRITE_BYTES_IN_DATA_MINNUM 0
 #define       MC_CMD_XPM_WRITE_BYTES_IN_DATA_MAXNUM 244
+#define       MC_CMD_XPM_WRITE_BYTES_IN_DATA_MAXNUM_MCDI2 1012
 
 /* MC_CMD_XPM_WRITE_BYTES_OUT msgresponse */
 #define    MC_CMD_XPM_WRITE_BYTES_OUT_LEN 0
@@ -14498,6 +19730,7 @@
  * Read XPM sector
  */
 #define MC_CMD_XPM_READ_SECTOR 0x105
+#undef MC_CMD_0x105_PRIVILEGE_CTG
 
 #define MC_CMD_0x105_PRIVILEGE_CTG SRIOV_CTG_INSECURE
 
@@ -14513,7 +19746,9 @@
 /* MC_CMD_XPM_READ_SECTOR_OUT msgresponse */
 #define    MC_CMD_XPM_READ_SECTOR_OUT_LENMIN 4
 #define    MC_CMD_XPM_READ_SECTOR_OUT_LENMAX 36
+#define    MC_CMD_XPM_READ_SECTOR_OUT_LENMAX_MCDI2 36
 #define    MC_CMD_XPM_READ_SECTOR_OUT_LEN(num) (4+1*(num))
+#define    MC_CMD_XPM_READ_SECTOR_OUT_DATA_NUM(len) (((len)-4)/1)
 /* Sector type */
 #define       MC_CMD_XPM_READ_SECTOR_OUT_TYPE_OFST 0
 #define       MC_CMD_XPM_READ_SECTOR_OUT_TYPE_LEN 4
@@ -14527,6 +19762,7 @@
 #define       MC_CMD_XPM_READ_SECTOR_OUT_DATA_LEN 1
 #define       MC_CMD_XPM_READ_SECTOR_OUT_DATA_MINNUM 0
 #define       MC_CMD_XPM_READ_SECTOR_OUT_DATA_MAXNUM 32
+#define       MC_CMD_XPM_READ_SECTOR_OUT_DATA_MAXNUM_MCDI2 32
 
 
 /***********************************/
@@ -14534,13 +19770,16 @@
  * Write XPM sector
  */
 #define MC_CMD_XPM_WRITE_SECTOR 0x106
+#undef MC_CMD_0x106_PRIVILEGE_CTG
 
 #define MC_CMD_0x106_PRIVILEGE_CTG SRIOV_CTG_INSECURE
 
 /* MC_CMD_XPM_WRITE_SECTOR_IN msgrequest */
 #define    MC_CMD_XPM_WRITE_SECTOR_IN_LENMIN 12
 #define    MC_CMD_XPM_WRITE_SECTOR_IN_LENMAX 44
+#define    MC_CMD_XPM_WRITE_SECTOR_IN_LENMAX_MCDI2 44
 #define    MC_CMD_XPM_WRITE_SECTOR_IN_LEN(num) (12+1*(num))
+#define    MC_CMD_XPM_WRITE_SECTOR_IN_DATA_NUM(len) (((len)-12)/1)
 /* If writing fails due to an uncorrectable error, try up to RETRIES following
  * sectors (or until no more space available). If 0, only one write attempt is
  * made. Note that uncorrectable errors are unlikely, thanks to XPM self-repair
@@ -14563,6 +19802,7 @@
 #define       MC_CMD_XPM_WRITE_SECTOR_IN_DATA_LEN 1
 #define       MC_CMD_XPM_WRITE_SECTOR_IN_DATA_MINNUM 0
 #define       MC_CMD_XPM_WRITE_SECTOR_IN_DATA_MAXNUM 32
+#define       MC_CMD_XPM_WRITE_SECTOR_IN_DATA_MAXNUM_MCDI2 32
 
 /* MC_CMD_XPM_WRITE_SECTOR_OUT msgresponse */
 #define    MC_CMD_XPM_WRITE_SECTOR_OUT_LEN 4
@@ -14576,6 +19816,7 @@
  * Invalidate XPM sector
  */
 #define MC_CMD_XPM_INVALIDATE_SECTOR 0x107
+#undef MC_CMD_0x107_PRIVILEGE_CTG
 
 #define MC_CMD_0x107_PRIVILEGE_CTG SRIOV_CTG_INSECURE
 
@@ -14594,6 +19835,7 @@
  * Blank-check XPM memory and report bad locations
  */
 #define MC_CMD_XPM_BLANK_CHECK 0x108
+#undef MC_CMD_0x108_PRIVILEGE_CTG
 
 #define MC_CMD_0x108_PRIVILEGE_CTG SRIOV_CTG_INSECURE
 
@@ -14609,7 +19851,9 @@
 /* MC_CMD_XPM_BLANK_CHECK_OUT msgresponse */
 #define    MC_CMD_XPM_BLANK_CHECK_OUT_LENMIN 4
 #define    MC_CMD_XPM_BLANK_CHECK_OUT_LENMAX 252
+#define    MC_CMD_XPM_BLANK_CHECK_OUT_LENMAX_MCDI2 1020
 #define    MC_CMD_XPM_BLANK_CHECK_OUT_LEN(num) (4+2*(num))
+#define    MC_CMD_XPM_BLANK_CHECK_OUT_BAD_ADDR_NUM(len) (((len)-4)/2)
 /* Total number of bad (non-blank) locations */
 #define       MC_CMD_XPM_BLANK_CHECK_OUT_BAD_COUNT_OFST 0
 #define       MC_CMD_XPM_BLANK_CHECK_OUT_BAD_COUNT_LEN 4
@@ -14620,6 +19864,7 @@
 #define       MC_CMD_XPM_BLANK_CHECK_OUT_BAD_ADDR_LEN 2
 #define       MC_CMD_XPM_BLANK_CHECK_OUT_BAD_ADDR_MINNUM 0
 #define       MC_CMD_XPM_BLANK_CHECK_OUT_BAD_ADDR_MAXNUM 124
+#define       MC_CMD_XPM_BLANK_CHECK_OUT_BAD_ADDR_MAXNUM_MCDI2 508
 
 
 /***********************************/
@@ -14627,6 +19872,7 @@
  * Blank-check and repair XPM memory
  */
 #define MC_CMD_XPM_REPAIR 0x109
+#undef MC_CMD_0x109_PRIVILEGE_CTG
 
 #define MC_CMD_0x109_PRIVILEGE_CTG SRIOV_CTG_INSECURE
 
@@ -14649,6 +19895,7 @@
  * be performed on an unprogrammed part.
  */
 #define MC_CMD_XPM_DECODER_TEST 0x10a
+#undef MC_CMD_0x10a_PRIVILEGE_CTG
 
 #define MC_CMD_0x10a_PRIVILEGE_CTG SRIOV_CTG_INSECURE
 
@@ -14668,6 +19915,7 @@
  * first available location to use, or fail with ENOSPC if none left.
  */
 #define MC_CMD_XPM_WRITE_TEST 0x10b
+#undef MC_CMD_0x10b_PRIVILEGE_CTG
 
 #define MC_CMD_0x10b_PRIVILEGE_CTG SRIOV_CTG_INSECURE
 
@@ -14688,6 +19936,7 @@
  * does match, otherwise it will respond with success before it jumps to IMEM.
  */
 #define MC_CMD_EXEC_SIGNED 0x10c
+#undef MC_CMD_0x10c_PRIVILEGE_CTG
 
 #define MC_CMD_0x10c_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
@@ -14717,6 +19966,7 @@
  * MC_CMD_EXEC_SIGNED.
  */
 #define MC_CMD_PREPARE_SIGNED 0x10d
+#undef MC_CMD_0x10d_PRIVILEGE_CTG
 
 #define MC_CMD_0x10d_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
@@ -14761,16 +20011,20 @@
  * cause all functions to see a reset. (Available on Medford only.)
  */
 #define MC_CMD_SET_TUNNEL_ENCAP_UDP_PORTS 0x117
+#undef MC_CMD_0x117_PRIVILEGE_CTG
 
 #define MC_CMD_0x117_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
 /* MC_CMD_SET_TUNNEL_ENCAP_UDP_PORTS_IN msgrequest */
 #define    MC_CMD_SET_TUNNEL_ENCAP_UDP_PORTS_IN_LENMIN 4
 #define    MC_CMD_SET_TUNNEL_ENCAP_UDP_PORTS_IN_LENMAX 68
+#define    MC_CMD_SET_TUNNEL_ENCAP_UDP_PORTS_IN_LENMAX_MCDI2 68
 #define    MC_CMD_SET_TUNNEL_ENCAP_UDP_PORTS_IN_LEN(num) (4+4*(num))
+#define    MC_CMD_SET_TUNNEL_ENCAP_UDP_PORTS_IN_ENTRIES_NUM(len) (((len)-4)/4)
 /* Flags */
 #define       MC_CMD_SET_TUNNEL_ENCAP_UDP_PORTS_IN_FLAGS_OFST 0
 #define       MC_CMD_SET_TUNNEL_ENCAP_UDP_PORTS_IN_FLAGS_LEN 2
+#define        MC_CMD_SET_TUNNEL_ENCAP_UDP_PORTS_IN_UNLOADING_OFST 0
 #define        MC_CMD_SET_TUNNEL_ENCAP_UDP_PORTS_IN_UNLOADING_LBN 0
 #define        MC_CMD_SET_TUNNEL_ENCAP_UDP_PORTS_IN_UNLOADING_WIDTH 1
 /* The number of entries in the ENTRIES array */
@@ -14783,12 +20037,14 @@
 #define       MC_CMD_SET_TUNNEL_ENCAP_UDP_PORTS_IN_ENTRIES_LEN 4
 #define       MC_CMD_SET_TUNNEL_ENCAP_UDP_PORTS_IN_ENTRIES_MINNUM 0
 #define       MC_CMD_SET_TUNNEL_ENCAP_UDP_PORTS_IN_ENTRIES_MAXNUM 16
+#define       MC_CMD_SET_TUNNEL_ENCAP_UDP_PORTS_IN_ENTRIES_MAXNUM_MCDI2 16
 
 /* MC_CMD_SET_TUNNEL_ENCAP_UDP_PORTS_OUT msgresponse */
 #define    MC_CMD_SET_TUNNEL_ENCAP_UDP_PORTS_OUT_LEN 2
 /* Flags */
 #define       MC_CMD_SET_TUNNEL_ENCAP_UDP_PORTS_OUT_FLAGS_OFST 0
 #define       MC_CMD_SET_TUNNEL_ENCAP_UDP_PORTS_OUT_FLAGS_LEN 2
+#define        MC_CMD_SET_TUNNEL_ENCAP_UDP_PORTS_OUT_RESETTING_OFST 0
 #define        MC_CMD_SET_TUNNEL_ENCAP_UDP_PORTS_OUT_RESETTING_LBN 0
 #define        MC_CMD_SET_TUNNEL_ENCAP_UDP_PORTS_OUT_RESETTING_WIDTH 1
 
@@ -14801,6 +20057,7 @@
  * priority.
  */
 #define MC_CMD_RX_BALANCING 0x118
+#undef MC_CMD_0x118_PRIVILEGE_CTG
 
 #define MC_CMD_0x118_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
@@ -14829,13 +20086,16 @@
  * if the tag is already present.
  */
 #define MC_CMD_NVRAM_PRIVATE_APPEND 0x11c
+#undef MC_CMD_0x11c_PRIVILEGE_CTG
 
 #define MC_CMD_0x11c_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
 /* MC_CMD_NVRAM_PRIVATE_APPEND_IN msgrequest */
 #define    MC_CMD_NVRAM_PRIVATE_APPEND_IN_LENMIN 9
 #define    MC_CMD_NVRAM_PRIVATE_APPEND_IN_LENMAX 252
+#define    MC_CMD_NVRAM_PRIVATE_APPEND_IN_LENMAX_MCDI2 1020
 #define    MC_CMD_NVRAM_PRIVATE_APPEND_IN_LEN(num) (8+1*(num))
+#define    MC_CMD_NVRAM_PRIVATE_APPEND_IN_DATA_BUFFER_NUM(len) (((len)-8)/1)
 /* The tag to be appended */
 #define       MC_CMD_NVRAM_PRIVATE_APPEND_IN_TAG_OFST 0
 #define       MC_CMD_NVRAM_PRIVATE_APPEND_IN_TAG_LEN 4
@@ -14847,6 +20107,7 @@
 #define       MC_CMD_NVRAM_PRIVATE_APPEND_IN_DATA_BUFFER_LEN 1
 #define       MC_CMD_NVRAM_PRIVATE_APPEND_IN_DATA_BUFFER_MINNUM 1
 #define       MC_CMD_NVRAM_PRIVATE_APPEND_IN_DATA_BUFFER_MAXNUM 244
+#define       MC_CMD_NVRAM_PRIVATE_APPEND_IN_DATA_BUFFER_MAXNUM_MCDI2 1012
 
 /* MC_CMD_NVRAM_PRIVATE_APPEND_OUT msgresponse */
 #define    MC_CMD_NVRAM_PRIVATE_APPEND_OUT_LEN 0
@@ -14859,6 +20120,7 @@
  * correctly at ATE.
  */
 #define MC_CMD_XPM_VERIFY_CONTENTS 0x11b
+#undef MC_CMD_0x11b_PRIVILEGE_CTG
 
 #define MC_CMD_0x11b_PRIVILEGE_CTG SRIOV_CTG_ADMIN
 
@@ -14871,7 +20133,9 @@
 /* MC_CMD_XPM_VERIFY_CONTENTS_OUT msgresponse */
 #define    MC_CMD_XPM_VERIFY_CONTENTS_OUT_LENMIN 12
 #define    MC_CMD_XPM_VERIFY_CONTENTS_OUT_LENMAX 252
+#define    MC_CMD_XPM_VERIFY_CONTENTS_OUT_LENMAX_MCDI2 1020
 #define    MC_CMD_XPM_VERIFY_CONTENTS_OUT_LEN(num) (12+1*(num))
+#define    MC_CMD_XPM_VERIFY_CONTENTS_OUT_SIGNATURE_NUM(len) (((len)-12)/1)
 /* Number of sectors found (test builds only) */
 #define       MC_CMD_XPM_VERIFY_CONTENTS_OUT_NUM_SECTORS_OFST 0
 #define       MC_CMD_XPM_VERIFY_CONTENTS_OUT_NUM_SECTORS_LEN 4
@@ -14886,6 +20150,7 @@
 #define       MC_CMD_XPM_VERIFY_CONTENTS_OUT_SIGNATURE_LEN 1
 #define       MC_CMD_XPM_VERIFY_CONTENTS_OUT_SIGNATURE_MINNUM 0
 #define       MC_CMD_XPM_VERIFY_CONTENTS_OUT_SIGNATURE_MAXNUM 240
+#define       MC_CMD_XPM_VERIFY_CONTENTS_OUT_SIGNATURE_MAXNUM_MCDI2 1008
 
 
 /***********************************/
@@ -14898,6 +20163,7 @@
  * and TMR_RELOAD_ACT_NS).
  */
 #define MC_CMD_SET_EVQ_TMR 0x120
+#undef MC_CMD_0x120_PRIVILEGE_CTG
 
 #define MC_CMD_0x120_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -14935,6 +20201,7 @@
  * Query properties about the event queue timers.
  */
 #define MC_CMD_GET_EVQ_TMR_PROPERTIES 0x122
+#undef MC_CMD_0x122_PRIVILEGE_CTG
 
 #define MC_CMD_0x122_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -15003,6 +20270,7 @@
  * non used switch buffers.
  */
 #define MC_CMD_ALLOCATE_TX_VFIFO_CP 0x11d
+#undef MC_CMD_0x11d_PRIVILEGE_CTG
 
 #define MC_CMD_0x11d_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -15054,6 +20322,7 @@
  * previously allocated common pools.
  */
 #define MC_CMD_ALLOCATE_TX_VFIFO_VFIFO 0x11e
+#undef MC_CMD_0x11e_PRIVILEGE_CTG
 
 #define MC_CMD_0x11e_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -15106,6 +20375,7 @@
  * ready to be re-used.
  */
 #define MC_CMD_TEARDOWN_TX_VFIFO_VF 0x11f
+#undef MC_CMD_0x11f_PRIVILEGE_CTG
 
 #define MC_CMD_0x11f_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -15125,6 +20395,7 @@
  * it ready to be re-used.
  */
 #define MC_CMD_DEALLOCATE_TX_VFIFO_CP 0x121
+#undef MC_CMD_0x121_PRIVILEGE_CTG
 
 #define MC_CMD_0x121_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -15144,6 +20415,7 @@
  * not yet assigned.
  */
 #define MC_CMD_SWITCH_GET_UNASSIGNED_BUFFERS 0x124
+#undef MC_CMD_0x124_PRIVILEGE_CTG
 
 #define MC_CMD_0x124_PRIVILEGE_CTG SRIOV_CTG_GENERAL
 
@@ -15160,4 +20432,1537 @@
 #define       MC_CMD_SWITCH_GET_UNASSIGNED_BUFFERS_OUT_ENG_LEN 4
 
 
+/***********************************/
+/* MC_CMD_SUC_VERSION
+ * Get the version of the SUC
+ */
+#define MC_CMD_SUC_VERSION 0x134
+#undef MC_CMD_0x134_PRIVILEGE_CTG
+
+#define MC_CMD_0x134_PRIVILEGE_CTG SRIOV_CTG_GENERAL
+
+/* MC_CMD_SUC_VERSION_IN msgrequest */
+#define    MC_CMD_SUC_VERSION_IN_LEN 0
+
+/* MC_CMD_SUC_VERSION_OUT msgresponse */
+#define    MC_CMD_SUC_VERSION_OUT_LEN 24
+/* The SUC firmware version as four numbers - a.b.c.d */
+#define       MC_CMD_SUC_VERSION_OUT_VERSION_OFST 0
+#define       MC_CMD_SUC_VERSION_OUT_VERSION_LEN 4
+#define       MC_CMD_SUC_VERSION_OUT_VERSION_NUM 4
+/* The date, in seconds since the Unix epoch, when the firmware image was
+ * built.
+ */
+#define       MC_CMD_SUC_VERSION_OUT_BUILD_DATE_OFST 16
+#define       MC_CMD_SUC_VERSION_OUT_BUILD_DATE_LEN 4
+/* The ID of the SUC chip. This is specific to the platform but typically
+ * indicates family, memory sizes etc. See SF-116728-SW for further details.
+ */
+#define       MC_CMD_SUC_VERSION_OUT_CHIP_ID_OFST 20
+#define       MC_CMD_SUC_VERSION_OUT_CHIP_ID_LEN 4
+
+/* MC_CMD_SUC_BOOT_VERSION_IN msgrequest: Get the version of the SUC boot
+ * loader.
+ */
+#define    MC_CMD_SUC_BOOT_VERSION_IN_LEN 4
+#define       MC_CMD_SUC_BOOT_VERSION_IN_MAGIC_OFST 0
+#define       MC_CMD_SUC_BOOT_VERSION_IN_MAGIC_LEN 4
+/* enum: Requests the SUC boot version. */
+#define          MC_CMD_SUC_VERSION_GET_BOOT_VERSION 0xb007700b
+
+/* MC_CMD_SUC_BOOT_VERSION_OUT msgresponse */
+#define    MC_CMD_SUC_BOOT_VERSION_OUT_LEN 4
+/* The SUC boot version */
+#define       MC_CMD_SUC_BOOT_VERSION_OUT_VERSION_OFST 0
+#define       MC_CMD_SUC_BOOT_VERSION_OUT_VERSION_LEN 4
+
+
+/***********************************/
+/* MC_CMD_GET_RX_PREFIX_ID
+ * This command is part of the mechanism for configuring the format of the RX
+ * packet prefix. It takes as input a bitmask of the fields the host would like
+ * to be in the prefix. If the hardware supports RX prefixes with that
+ * combination of fields, then this command returns a list of prefix-ids,
+ * opaque identifiers suitable for use in the RX_PREFIX_ID field of a
+ * MC_CMD_INIT_RXQ_V5_IN message. If the combination of fields is not
+ * supported, returns ENOTSUP. If the firmware can't create any new prefix-ids
+ * due to resource constraints, returns ENOSPC.
+ */
+#define MC_CMD_GET_RX_PREFIX_ID 0x13b
+#undef MC_CMD_0x13b_PRIVILEGE_CTG
+
+#define MC_CMD_0x13b_PRIVILEGE_CTG SRIOV_CTG_GENERAL
+
+/* MC_CMD_GET_RX_PREFIX_ID_IN msgrequest */
+#define    MC_CMD_GET_RX_PREFIX_ID_IN_LEN 8
+/* Field bitmask. */
+#define       MC_CMD_GET_RX_PREFIX_ID_IN_FIELDS_OFST 0
+#define       MC_CMD_GET_RX_PREFIX_ID_IN_FIELDS_LEN 8
+#define       MC_CMD_GET_RX_PREFIX_ID_IN_FIELDS_LO_OFST 0
+#define       MC_CMD_GET_RX_PREFIX_ID_IN_FIELDS_HI_OFST 4
+#define        MC_CMD_GET_RX_PREFIX_ID_IN_LENGTH_OFST 0
+#define        MC_CMD_GET_RX_PREFIX_ID_IN_LENGTH_LBN 0
+#define        MC_CMD_GET_RX_PREFIX_ID_IN_LENGTH_WIDTH 1
+#define        MC_CMD_GET_RX_PREFIX_ID_IN_RSS_HASH_VALID_OFST 0
+#define        MC_CMD_GET_RX_PREFIX_ID_IN_RSS_HASH_VALID_LBN 1
+#define        MC_CMD_GET_RX_PREFIX_ID_IN_RSS_HASH_VALID_WIDTH 1
+#define        MC_CMD_GET_RX_PREFIX_ID_IN_USER_FLAG_OFST 0
+#define        MC_CMD_GET_RX_PREFIX_ID_IN_USER_FLAG_LBN 2
+#define        MC_CMD_GET_RX_PREFIX_ID_IN_USER_FLAG_WIDTH 1
+#define        MC_CMD_GET_RX_PREFIX_ID_IN_CLASS_OFST 0
+#define        MC_CMD_GET_RX_PREFIX_ID_IN_CLASS_LBN 3
+#define        MC_CMD_GET_RX_PREFIX_ID_IN_CLASS_WIDTH 1
+#define        MC_CMD_GET_RX_PREFIX_ID_IN_PARTIAL_TSTAMP_OFST 0
+#define        MC_CMD_GET_RX_PREFIX_ID_IN_PARTIAL_TSTAMP_LBN 4
+#define        MC_CMD_GET_RX_PREFIX_ID_IN_PARTIAL_TSTAMP_WIDTH 1
+#define        MC_CMD_GET_RX_PREFIX_ID_IN_RSS_HASH_OFST 0
+#define        MC_CMD_GET_RX_PREFIX_ID_IN_RSS_HASH_LBN 5
+#define        MC_CMD_GET_RX_PREFIX_ID_IN_RSS_HASH_WIDTH 1
+#define        MC_CMD_GET_RX_PREFIX_ID_IN_USER_MARK_OFST 0
+#define        MC_CMD_GET_RX_PREFIX_ID_IN_USER_MARK_LBN 6
+#define        MC_CMD_GET_RX_PREFIX_ID_IN_USER_MARK_WIDTH 1
+#define        MC_CMD_GET_RX_PREFIX_ID_IN_INGRESS_VPORT_OFST 0
+#define        MC_CMD_GET_RX_PREFIX_ID_IN_INGRESS_VPORT_LBN 7
+#define        MC_CMD_GET_RX_PREFIX_ID_IN_INGRESS_VPORT_WIDTH 1
+#define        MC_CMD_GET_RX_PREFIX_ID_IN_CSUM_FRAME_OFST 0
+#define        MC_CMD_GET_RX_PREFIX_ID_IN_CSUM_FRAME_LBN 8
+#define        MC_CMD_GET_RX_PREFIX_ID_IN_CSUM_FRAME_WIDTH 1
+#define        MC_CMD_GET_RX_PREFIX_ID_IN_VLAN_STRIP_TCI_OFST 0
+#define        MC_CMD_GET_RX_PREFIX_ID_IN_VLAN_STRIP_TCI_LBN 9
+#define        MC_CMD_GET_RX_PREFIX_ID_IN_VLAN_STRIP_TCI_WIDTH 1
+
+/* MC_CMD_GET_RX_PREFIX_ID_OUT msgresponse */
+#define    MC_CMD_GET_RX_PREFIX_ID_OUT_LENMIN 8
+#define    MC_CMD_GET_RX_PREFIX_ID_OUT_LENMAX 252
+#define    MC_CMD_GET_RX_PREFIX_ID_OUT_LENMAX_MCDI2 1020
+#define    MC_CMD_GET_RX_PREFIX_ID_OUT_LEN(num) (4+4*(num))
+#define    MC_CMD_GET_RX_PREFIX_ID_OUT_RX_PREFIX_ID_NUM(len) (((len)-4)/4)
+/* Number of prefix-ids returned */
+#define       MC_CMD_GET_RX_PREFIX_ID_OUT_NUM_RX_PREFIX_IDS_OFST 0
+#define       MC_CMD_GET_RX_PREFIX_ID_OUT_NUM_RX_PREFIX_IDS_LEN 4
+/* Opaque prefix identifiers which can be passed into MC_CMD_INIT_RXQ_V5 or
+ * MC_CMD_QUERY_PREFIX_ID
+ */
+#define       MC_CMD_GET_RX_PREFIX_ID_OUT_RX_PREFIX_ID_OFST 4
+#define       MC_CMD_GET_RX_PREFIX_ID_OUT_RX_PREFIX_ID_LEN 4
+#define       MC_CMD_GET_RX_PREFIX_ID_OUT_RX_PREFIX_ID_MINNUM 1
+#define       MC_CMD_GET_RX_PREFIX_ID_OUT_RX_PREFIX_ID_MAXNUM 62
+#define       MC_CMD_GET_RX_PREFIX_ID_OUT_RX_PREFIX_ID_MAXNUM_MCDI2 254
+
+/* RX_PREFIX_FIELD_INFO structuredef: Information about a single RX prefix
+ * field
+ */
+#define    RX_PREFIX_FIELD_INFO_LEN 4
+/* The offset of the field from the start of the prefix, in bits */
+#define       RX_PREFIX_FIELD_INFO_OFFSET_BITS_OFST 0
+#define       RX_PREFIX_FIELD_INFO_OFFSET_BITS_LEN 2
+#define       RX_PREFIX_FIELD_INFO_OFFSET_BITS_LBN 0
+#define       RX_PREFIX_FIELD_INFO_OFFSET_BITS_WIDTH 16
+/* The width of the field, in bits */
+#define       RX_PREFIX_FIELD_INFO_WIDTH_BITS_OFST 2
+#define       RX_PREFIX_FIELD_INFO_WIDTH_BITS_LEN 1
+#define       RX_PREFIX_FIELD_INFO_WIDTH_BITS_LBN 16
+#define       RX_PREFIX_FIELD_INFO_WIDTH_BITS_WIDTH 8
+/* The type of the field. These enum values are in the same order as the fields
+ * in the MC_CMD_GET_RX_PREFIX_ID_IN bitmask
+ */
+#define       RX_PREFIX_FIELD_INFO_TYPE_OFST 3
+#define       RX_PREFIX_FIELD_INFO_TYPE_LEN 1
+#define          RX_PREFIX_FIELD_INFO_LENGTH 0x0 /* enum */
+#define          RX_PREFIX_FIELD_INFO_RSS_HASH_VALID 0x1 /* enum */
+#define          RX_PREFIX_FIELD_INFO_USER_FLAG 0x2 /* enum */
+#define          RX_PREFIX_FIELD_INFO_CLASS 0x3 /* enum */
+#define          RX_PREFIX_FIELD_INFO_PARTIAL_TSTAMP 0x4 /* enum */
+#define          RX_PREFIX_FIELD_INFO_RSS_HASH 0x5 /* enum */
+#define          RX_PREFIX_FIELD_INFO_USER_MARK 0x6 /* enum */
+#define          RX_PREFIX_FIELD_INFO_INGRESS_VPORT 0x7 /* enum */
+#define          RX_PREFIX_FIELD_INFO_CSUM_FRAME 0x8 /* enum */
+#define          RX_PREFIX_FIELD_INFO_VLAN_STRIP_TCI 0x9 /* enum */
+#define       RX_PREFIX_FIELD_INFO_TYPE_LBN 24
+#define       RX_PREFIX_FIELD_INFO_TYPE_WIDTH 8
+
+/* RX_PREFIX_FIXED_RESPONSE structuredef: Information about an RX prefix in
+ * which every field has a fixed offset and width
+ */
+#define    RX_PREFIX_FIXED_RESPONSE_LENMIN 4
+#define    RX_PREFIX_FIXED_RESPONSE_LENMAX 252
+#define    RX_PREFIX_FIXED_RESPONSE_LENMAX_MCDI2 1020
+#define    RX_PREFIX_FIXED_RESPONSE_LEN(num) (4+4*(num))
+#define    RX_PREFIX_FIXED_RESPONSE_FIELDS_NUM(len) (((len)-4)/4)
+/* Length of the RX prefix in bytes */
+#define       RX_PREFIX_FIXED_RESPONSE_PREFIX_LENGTH_BYTES_OFST 0
+#define       RX_PREFIX_FIXED_RESPONSE_PREFIX_LENGTH_BYTES_LEN 1
+#define       RX_PREFIX_FIXED_RESPONSE_PREFIX_LENGTH_BYTES_LBN 0
+#define       RX_PREFIX_FIXED_RESPONSE_PREFIX_LENGTH_BYTES_WIDTH 8
+/* Number of fields present in the prefix */
+#define       RX_PREFIX_FIXED_RESPONSE_FIELD_COUNT_OFST 1
+#define       RX_PREFIX_FIXED_RESPONSE_FIELD_COUNT_LEN 1
+#define       RX_PREFIX_FIXED_RESPONSE_FIELD_COUNT_LBN 8
+#define       RX_PREFIX_FIXED_RESPONSE_FIELD_COUNT_WIDTH 8
+#define       RX_PREFIX_FIXED_RESPONSE_RESERVED_OFST 2
+#define       RX_PREFIX_FIXED_RESPONSE_RESERVED_LEN 2
+#define       RX_PREFIX_FIXED_RESPONSE_RESERVED_LBN 16
+#define       RX_PREFIX_FIXED_RESPONSE_RESERVED_WIDTH 16
+/* Array of RX_PREFIX_FIELD_INFO structures, of length FIELD_COUNT */
+#define       RX_PREFIX_FIXED_RESPONSE_FIELDS_OFST 4
+#define       RX_PREFIX_FIXED_RESPONSE_FIELDS_LEN 4
+#define       RX_PREFIX_FIXED_RESPONSE_FIELDS_MINNUM 0
+#define       RX_PREFIX_FIXED_RESPONSE_FIELDS_MAXNUM 62
+#define       RX_PREFIX_FIXED_RESPONSE_FIELDS_MAXNUM_MCDI2 254
+#define       RX_PREFIX_FIXED_RESPONSE_FIELDS_LBN 32
+#define       RX_PREFIX_FIXED_RESPONSE_FIELDS_WIDTH 32
+
+
+/***********************************/
+/* MC_CMD_QUERY_RX_PREFIX_ID
+ * This command takes an RX prefix id (obtained from MC_CMD_GET_RX_PREFIX_ID)
+ * and returns a description of the RX prefix of packets delievered to an RXQ
+ * created with that prefix id
+ */
+#define MC_CMD_QUERY_RX_PREFIX_ID 0x13c
+#undef MC_CMD_0x13c_PRIVILEGE_CTG
+
+#define MC_CMD_0x13c_PRIVILEGE_CTG SRIOV_CTG_GENERAL
+
+/* MC_CMD_QUERY_RX_PREFIX_ID_IN msgrequest */
+#define    MC_CMD_QUERY_RX_PREFIX_ID_IN_LEN 4
+/* Prefix id to query */
+#define       MC_CMD_QUERY_RX_PREFIX_ID_IN_RX_PREFIX_ID_OFST 0
+#define       MC_CMD_QUERY_RX_PREFIX_ID_IN_RX_PREFIX_ID_LEN 4
+
+/* MC_CMD_QUERY_RX_PREFIX_ID_OUT msgresponse */
+#define    MC_CMD_QUERY_RX_PREFIX_ID_OUT_LENMIN 4
+#define    MC_CMD_QUERY_RX_PREFIX_ID_OUT_LENMAX 252
+#define    MC_CMD_QUERY_RX_PREFIX_ID_OUT_LENMAX_MCDI2 1020
+#define    MC_CMD_QUERY_RX_PREFIX_ID_OUT_LEN(num) (4+1*(num))
+#define    MC_CMD_QUERY_RX_PREFIX_ID_OUT_RESPONSE_NUM(len) (((len)-4)/1)
+/* An enum describing the structure of this response. */
+#define       MC_CMD_QUERY_RX_PREFIX_ID_OUT_RESPONSE_TYPE_OFST 0
+#define       MC_CMD_QUERY_RX_PREFIX_ID_OUT_RESPONSE_TYPE_LEN 1
+/* enum: The response is of format RX_PREFIX_FIXED_RESPONSE */
+#define          MC_CMD_QUERY_RX_PREFIX_ID_OUT_RESPONSE_TYPE_FIXED 0x0
+#define       MC_CMD_QUERY_RX_PREFIX_ID_OUT_RESERVED_OFST 1
+#define       MC_CMD_QUERY_RX_PREFIX_ID_OUT_RESERVED_LEN 3
+/* The response. Its format is as defined by the RESPONSE_TYPE value */
+#define       MC_CMD_QUERY_RX_PREFIX_ID_OUT_RESPONSE_OFST 4
+#define       MC_CMD_QUERY_RX_PREFIX_ID_OUT_RESPONSE_LEN 1
+#define       MC_CMD_QUERY_RX_PREFIX_ID_OUT_RESPONSE_MINNUM 0
+#define       MC_CMD_QUERY_RX_PREFIX_ID_OUT_RESPONSE_MAXNUM 248
+#define       MC_CMD_QUERY_RX_PREFIX_ID_OUT_RESPONSE_MAXNUM_MCDI2 1016
+
+
+/***********************************/
+/* MC_CMD_BUNDLE
+ * A command to perform various bundle-related operations on insecure cards.
+ */
+#define MC_CMD_BUNDLE 0x13d
+#undef MC_CMD_0x13d_PRIVILEGE_CTG
+
+#define MC_CMD_0x13d_PRIVILEGE_CTG SRIOV_CTG_INSECURE
+
+/* MC_CMD_BUNDLE_IN msgrequest */
+#define    MC_CMD_BUNDLE_IN_LEN 4
+/* Sub-command code */
+#define       MC_CMD_BUNDLE_IN_OP_OFST 0
+#define       MC_CMD_BUNDLE_IN_OP_LEN 4
+/* enum: Get the current host access mode set on component partitions. */
+#define          MC_CMD_BUNDLE_IN_OP_COMPONENT_ACCESS_GET 0x0
+/* enum: Set the host access mode set on component partitions. */
+#define          MC_CMD_BUNDLE_IN_OP_COMPONENT_ACCESS_SET 0x1
+
+/* MC_CMD_BUNDLE_OP_COMPONENT_ACCESS_GET_IN msgrequest: Retrieve the current
+ * access mode on component partitions such as MC_FIRMWARE, SUC_FIRMWARE and
+ * EXPANSION_UEFI. This command only works on engineering (insecure) cards. On
+ * secure adapters, this command returns MC_CMD_ERR_EPERM.
+ */
+#define    MC_CMD_BUNDLE_OP_COMPONENT_ACCESS_GET_IN_LEN 4
+/* Sub-command code. Must be OP_COMPONENT_ACCESS_GET. */
+#define       MC_CMD_BUNDLE_OP_COMPONENT_ACCESS_GET_IN_OP_OFST 0
+#define       MC_CMD_BUNDLE_OP_COMPONENT_ACCESS_GET_IN_OP_LEN 4
+
+/* MC_CMD_BUNDLE_OP_COMPONENT_ACCESS_GET_OUT msgresponse: Returns the access
+ * control mode.
+ */
+#define    MC_CMD_BUNDLE_OP_COMPONENT_ACCESS_GET_OUT_LEN 4
+/* Access mode of component partitions. */
+#define       MC_CMD_BUNDLE_OP_COMPONENT_ACCESS_GET_OUT_ACCESS_MODE_OFST 0
+#define       MC_CMD_BUNDLE_OP_COMPONENT_ACCESS_GET_OUT_ACCESS_MODE_LEN 4
+/* enum: Component partitions are read-only from the host. */
+#define          MC_CMD_BUNDLE_COMPONENTS_READ_ONLY 0x0
+/* enum: Component partitions can read read-from written-to by the host. */
+#define          MC_CMD_BUNDLE_COMPONENTS_READ_WRITE 0x1
+
+/* MC_CMD_BUNDLE_OP_COMPONENT_ACCESS_SET_IN msgrequest: The component
+ * partitions such as MC_FIRMWARE, SUC_FIRMWARE, EXPANSION_UEFI are set as
+ * read-only on firmware built with bundle support. This command marks these
+ * partitions as read/writeable. The access status set by this command does not
+ * persist across MC reboots. This command only works on engineering (insecure)
+ * cards. On secure adapters, this command returns MC_CMD_ERR_EPERM.
+ */
+#define    MC_CMD_BUNDLE_OP_COMPONENT_ACCESS_SET_IN_LEN 8
+/* Sub-command code. Must be OP_COMPONENT_ACCESS_SET. */
+#define       MC_CMD_BUNDLE_OP_COMPONENT_ACCESS_SET_IN_OP_OFST 0
+#define       MC_CMD_BUNDLE_OP_COMPONENT_ACCESS_SET_IN_OP_LEN 4
+/* Access mode of component partitions. */
+#define       MC_CMD_BUNDLE_OP_COMPONENT_ACCESS_SET_IN_ACCESS_MODE_OFST 4
+#define       MC_CMD_BUNDLE_OP_COMPONENT_ACCESS_SET_IN_ACCESS_MODE_LEN 4
+/*            Enum values, see field(s): */
+/*               MC_CMD_BUNDLE_OP_COMPONENT_ACCESS_GET_OUT/ACCESS_MODE */
+
+/* MC_CMD_BUNDLE_OP_COMPONENT_ACCESS_SET_OUT msgresponse */
+#define    MC_CMD_BUNDLE_OP_COMPONENT_ACCESS_SET_OUT_LEN 0
+
+
+/***********************************/
+/* MC_CMD_GET_VPD
+ * Read all VPD starting from a given address
+ */
+#define MC_CMD_GET_VPD 0x165
+#undef MC_CMD_0x165_PRIVILEGE_CTG
+
+#define MC_CMD_0x165_PRIVILEGE_CTG SRIOV_CTG_GENERAL
+
+/* MC_CMD_GET_VPD_IN msgresponse */
+#define    MC_CMD_GET_VPD_IN_LEN 4
+/* VPD address to start from. In case VPD is longer than MCDI buffer
+ * (unlikely), user can make multiple calls with different starting addresses.
+ */
+#define       MC_CMD_GET_VPD_IN_ADDR_OFST 0
+#define       MC_CMD_GET_VPD_IN_ADDR_LEN 4
+
+/* MC_CMD_GET_VPD_OUT msgresponse */
+#define    MC_CMD_GET_VPD_OUT_LENMIN 0
+#define    MC_CMD_GET_VPD_OUT_LENMAX 252
+#define    MC_CMD_GET_VPD_OUT_LENMAX_MCDI2 1020
+#define    MC_CMD_GET_VPD_OUT_LEN(num) (0+1*(num))
+#define    MC_CMD_GET_VPD_OUT_DATA_NUM(len) (((len)-0)/1)
+/* VPD data returned. */
+#define       MC_CMD_GET_VPD_OUT_DATA_OFST 0
+#define       MC_CMD_GET_VPD_OUT_DATA_LEN 1
+#define       MC_CMD_GET_VPD_OUT_DATA_MINNUM 0
+#define       MC_CMD_GET_VPD_OUT_DATA_MAXNUM 252
+#define       MC_CMD_GET_VPD_OUT_DATA_MAXNUM_MCDI2 1020
+
+
+/***********************************/
+/* MC_CMD_GET_NCSI_INFO
+ * Provide information about the NC-SI stack
+ */
+#define MC_CMD_GET_NCSI_INFO 0x167
+#undef MC_CMD_0x167_PRIVILEGE_CTG
+
+#define MC_CMD_0x167_PRIVILEGE_CTG SRIOV_CTG_GENERAL
+
+/* MC_CMD_GET_NCSI_INFO_IN msgrequest */
+#define    MC_CMD_GET_NCSI_INFO_IN_LEN 8
+/* Operation to be performed */
+#define       MC_CMD_GET_NCSI_INFO_IN_OP_OFST 0
+#define       MC_CMD_GET_NCSI_INFO_IN_OP_LEN 4
+/* enum: Information on the link settings. */
+#define          MC_CMD_GET_NCSI_INFO_IN_OP_LINK 0x0
+/* enum: Statistics associated with the channel */
+#define          MC_CMD_GET_NCSI_INFO_IN_OP_STATISTICS 0x1
+/* The NC-SI channel on which the operation is to be performed */
+#define       MC_CMD_GET_NCSI_INFO_IN_CHANNEL_OFST 4
+#define       MC_CMD_GET_NCSI_INFO_IN_CHANNEL_LEN 4
+
+/* MC_CMD_GET_NCSI_INFO_LINK_OUT msgresponse */
+#define    MC_CMD_GET_NCSI_INFO_LINK_OUT_LEN 12
+/* Settings as received from BMC. */
+#define       MC_CMD_GET_NCSI_INFO_LINK_OUT_SETTINGS_OFST 0
+#define       MC_CMD_GET_NCSI_INFO_LINK_OUT_SETTINGS_LEN 4
+/* Advertised capabilities applied to channel. */
+#define       MC_CMD_GET_NCSI_INFO_LINK_OUT_ADV_CAP_OFST 4
+#define       MC_CMD_GET_NCSI_INFO_LINK_OUT_ADV_CAP_LEN 4
+/* General status */
+#define       MC_CMD_GET_NCSI_INFO_LINK_OUT_STATUS_OFST 8
+#define       MC_CMD_GET_NCSI_INFO_LINK_OUT_STATUS_LEN 4
+#define        MC_CMD_GET_NCSI_INFO_LINK_OUT_STATE_OFST 8
+#define        MC_CMD_GET_NCSI_INFO_LINK_OUT_STATE_LBN 0
+#define        MC_CMD_GET_NCSI_INFO_LINK_OUT_STATE_WIDTH 2
+#define        MC_CMD_GET_NCSI_INFO_LINK_OUT_ENABLE_OFST 8
+#define        MC_CMD_GET_NCSI_INFO_LINK_OUT_ENABLE_LBN 2
+#define        MC_CMD_GET_NCSI_INFO_LINK_OUT_ENABLE_WIDTH 1
+#define        MC_CMD_GET_NCSI_INFO_LINK_OUT_NETWORK_TX_OFST 8
+#define        MC_CMD_GET_NCSI_INFO_LINK_OUT_NETWORK_TX_LBN 3
+#define        MC_CMD_GET_NCSI_INFO_LINK_OUT_NETWORK_TX_WIDTH 1
+#define        MC_CMD_GET_NCSI_INFO_LINK_OUT_ATTACHED_OFST 8
+#define        MC_CMD_GET_NCSI_INFO_LINK_OUT_ATTACHED_LBN 4
+#define        MC_CMD_GET_NCSI_INFO_LINK_OUT_ATTACHED_WIDTH 1
+
+/* MC_CMD_GET_NCSI_INFO_STATISTICS_OUT msgresponse */
+#define    MC_CMD_GET_NCSI_INFO_STATISTICS_OUT_LEN 28
+/* The number of NC-SI commands received. */
+#define       MC_CMD_GET_NCSI_INFO_STATISTICS_OUT_NCSI_CMDS_RX_OFST 0
+#define       MC_CMD_GET_NCSI_INFO_STATISTICS_OUT_NCSI_CMDS_RX_LEN 4
+/* The number of NC-SI commands dropped. */
+#define       MC_CMD_GET_NCSI_INFO_STATISTICS_OUT_NCSI_PKTS_DROPPED_OFST 4
+#define       MC_CMD_GET_NCSI_INFO_STATISTICS_OUT_NCSI_PKTS_DROPPED_LEN 4
+/* The number of invalid NC-SI commands received. */
+#define       MC_CMD_GET_NCSI_INFO_STATISTICS_OUT_NCSI_CMD_TYPE_ERRS_OFST 8
+#define       MC_CMD_GET_NCSI_INFO_STATISTICS_OUT_NCSI_CMD_TYPE_ERRS_LEN 4
+/* The number of checksum errors seen. */
+#define       MC_CMD_GET_NCSI_INFO_STATISTICS_OUT_NCSI_CMD_CSUM_ERRS_OFST 12
+#define       MC_CMD_GET_NCSI_INFO_STATISTICS_OUT_NCSI_CMD_CSUM_ERRS_LEN 4
+/* The number of NC-SI requests received. */
+#define       MC_CMD_GET_NCSI_INFO_STATISTICS_OUT_NCSI_RX_PKTS_OFST 16
+#define       MC_CMD_GET_NCSI_INFO_STATISTICS_OUT_NCSI_RX_PKTS_LEN 4
+/* The number of NC-SI responses sent (includes AENs) */
+#define       MC_CMD_GET_NCSI_INFO_STATISTICS_OUT_NCSI_TX_PKTS_OFST 20
+#define       MC_CMD_GET_NCSI_INFO_STATISTICS_OUT_NCSI_TX_PKTS_LEN 4
+/* The number of NC-SI AENs sent */
+#define       MC_CMD_GET_NCSI_INFO_STATISTICS_OUT_AENS_SENT_OFST 24
+#define       MC_CMD_GET_NCSI_INFO_STATISTICS_OUT_AENS_SENT_LEN 4
+
+
+/* CLOCK_INFO structuredef: Information about a single hardware clock */
+#define    CLOCK_INFO_LEN 28
+/* Enumeration that uniquely identifies the clock */
+#define       CLOCK_INFO_CLOCK_ID_OFST 0
+#define       CLOCK_INFO_CLOCK_ID_LEN 2
+/* enum: The Riverhead CMC (card MC) */
+#define          CLOCK_INFO_CLOCK_CMC 0x0
+/* enum: The Riverhead NMC (network MC) */
+#define          CLOCK_INFO_CLOCK_NMC 0x1
+/* enum: The Riverhead SDNET slice main logic */
+#define          CLOCK_INFO_CLOCK_SDNET 0x2
+/* enum: The Riverhead SDNET LUT */
+#define          CLOCK_INFO_CLOCK_SDNET_LUT 0x3
+/* enum: The Riverhead SDNET control logic */
+#define          CLOCK_INFO_CLOCK_SDNET_CTRL 0x4
+/* enum: The Riverhead Streaming SubSystem */
+#define          CLOCK_INFO_CLOCK_SSS 0x5
+/* enum: The Riverhead network MAC and associated CSR registers */
+#define          CLOCK_INFO_CLOCK_MAC 0x6
+#define       CLOCK_INFO_CLOCK_ID_LBN 0
+#define       CLOCK_INFO_CLOCK_ID_WIDTH 16
+/* Assorted flags */
+#define       CLOCK_INFO_FLAGS_OFST 2
+#define       CLOCK_INFO_FLAGS_LEN 2
+#define        CLOCK_INFO_SETTABLE_OFST 2
+#define        CLOCK_INFO_SETTABLE_LBN 0
+#define        CLOCK_INFO_SETTABLE_WIDTH 1
+#define       CLOCK_INFO_FLAGS_LBN 16
+#define       CLOCK_INFO_FLAGS_WIDTH 16
+/* The frequency in HZ */
+#define       CLOCK_INFO_FREQUENCY_OFST 4
+#define       CLOCK_INFO_FREQUENCY_LEN 8
+#define       CLOCK_INFO_FREQUENCY_LO_OFST 4
+#define       CLOCK_INFO_FREQUENCY_HI_OFST 8
+#define       CLOCK_INFO_FREQUENCY_LBN 32
+#define       CLOCK_INFO_FREQUENCY_WIDTH 64
+/* Human-readable ASCII name for clock, with NUL termination */
+#define       CLOCK_INFO_NAME_OFST 12
+#define       CLOCK_INFO_NAME_LEN 1
+#define       CLOCK_INFO_NAME_NUM 16
+#define       CLOCK_INFO_NAME_LBN 96
+#define       CLOCK_INFO_NAME_WIDTH 8
+
+
+/***********************************/
+/* MC_CMD_GET_CLOCKS_INFO
+ * Get information about the device clocks
+ */
+#define MC_CMD_GET_CLOCKS_INFO 0x166
+#undef MC_CMD_0x166_PRIVILEGE_CTG
+
+#define MC_CMD_0x166_PRIVILEGE_CTG SRIOV_CTG_GENERAL
+
+/* MC_CMD_GET_CLOCKS_INFO_IN msgrequest */
+#define    MC_CMD_GET_CLOCKS_INFO_IN_LEN 0
+
+/* MC_CMD_GET_CLOCKS_INFO_OUT msgresponse */
+#define    MC_CMD_GET_CLOCKS_INFO_OUT_LENMIN 0
+#define    MC_CMD_GET_CLOCKS_INFO_OUT_LENMAX 252
+#define    MC_CMD_GET_CLOCKS_INFO_OUT_LENMAX_MCDI2 1008
+#define    MC_CMD_GET_CLOCKS_INFO_OUT_LEN(num) (0+28*(num))
+#define    MC_CMD_GET_CLOCKS_INFO_OUT_INFOS_NUM(len) (((len)-0)/28)
+/* An array of CLOCK_INFO structures. */
+#define       MC_CMD_GET_CLOCKS_INFO_OUT_INFOS_OFST 0
+#define       MC_CMD_GET_CLOCKS_INFO_OUT_INFOS_LEN 28
+#define       MC_CMD_GET_CLOCKS_INFO_OUT_INFOS_MINNUM 0
+#define       MC_CMD_GET_CLOCKS_INFO_OUT_INFOS_MAXNUM 9
+#define       MC_CMD_GET_CLOCKS_INFO_OUT_INFOS_MAXNUM_MCDI2 36
+
+
+/***********************************/
+/* MC_CMD_VNIC_ENCAP_RULE_ADD
+ * Add a rule for detecting encapsulations in the VNIC stage. Currently this only affects checksum validation in VNIC RX - on TX the send descriptor explicitly specifies encapsulation. These rules are per-VNIC, i.e. only apply to the current driver. If a rule matches, then the packet is considered to have the corresponding encapsulation type, and the inner packet is parsed. It is up to the driver to ensure that overlapping rules are not inserted. (If a packet would match multiple rules, a random one of them will be used.) A rule with the exact same match criteria may not be inserted twice (EALREADY). Only a limited number MATCH_FLAGS values are supported, use MC_CMD_GET_PARSER_DISP_INFO with OP OP_GET_SUPPORTED_VNIC_ENCAP_RULE_MATCHES to get a list of supported combinations. Each driver may only have a limited set of active rules - returns ENOSPC if the caller's table is full.
+ */
+#define MC_CMD_VNIC_ENCAP_RULE_ADD 0x16d
+#undef MC_CMD_0x16d_PRIVILEGE_CTG
+
+#define MC_CMD_0x16d_PRIVILEGE_CTG SRIOV_CTG_GENERAL
+
+/* MC_CMD_VNIC_ENCAP_RULE_ADD_IN msgrequest */
+#define    MC_CMD_VNIC_ENCAP_RULE_ADD_IN_LEN 36
+/* Set to MAE_MPORT_SELECTOR_ASSIGNED. In the future this may be relaxed. */
+#define       MC_CMD_VNIC_ENCAP_RULE_ADD_IN_MPORT_SELECTOR_OFST 0
+#define       MC_CMD_VNIC_ENCAP_RULE_ADD_IN_MPORT_SELECTOR_LEN 4
+/* Any non-zero bits other than the ones named below or an unsupported
+ * combination will cause the NIC to return EOPNOTSUPP. In the future more
+ * flags may be added.
+ */
+#define       MC_CMD_VNIC_ENCAP_RULE_ADD_IN_MATCH_FLAGS_OFST 4
+#define       MC_CMD_VNIC_ENCAP_RULE_ADD_IN_MATCH_FLAGS_LEN 4
+#define        MC_CMD_VNIC_ENCAP_RULE_ADD_IN_MATCH_ETHER_TYPE_OFST 4
+#define        MC_CMD_VNIC_ENCAP_RULE_ADD_IN_MATCH_ETHER_TYPE_LBN 0
+#define        MC_CMD_VNIC_ENCAP_RULE_ADD_IN_MATCH_ETHER_TYPE_WIDTH 1
+#define        MC_CMD_VNIC_ENCAP_RULE_ADD_IN_MATCH_OUTER_VLAN_OFST 4
+#define        MC_CMD_VNIC_ENCAP_RULE_ADD_IN_MATCH_OUTER_VLAN_LBN 1
+#define        MC_CMD_VNIC_ENCAP_RULE_ADD_IN_MATCH_OUTER_VLAN_WIDTH 1
+#define        MC_CMD_VNIC_ENCAP_RULE_ADD_IN_MATCH_DST_IP_OFST 4
+#define        MC_CMD_VNIC_ENCAP_RULE_ADD_IN_MATCH_DST_IP_LBN 2
+#define        MC_CMD_VNIC_ENCAP_RULE_ADD_IN_MATCH_DST_IP_WIDTH 1
+#define        MC_CMD_VNIC_ENCAP_RULE_ADD_IN_MATCH_IP_PROTO_OFST 4
+#define        MC_CMD_VNIC_ENCAP_RULE_ADD_IN_MATCH_IP_PROTO_LBN 3
+#define        MC_CMD_VNIC_ENCAP_RULE_ADD_IN_MATCH_IP_PROTO_WIDTH 1
+#define        MC_CMD_VNIC_ENCAP_RULE_ADD_IN_MATCH_DST_PORT_OFST 4
+#define        MC_CMD_VNIC_ENCAP_RULE_ADD_IN_MATCH_DST_PORT_LBN 4
+#define        MC_CMD_VNIC_ENCAP_RULE_ADD_IN_MATCH_DST_PORT_WIDTH 1
+/* Only if MATCH_ETHER_TYPE is set. Ethertype value as bytes in network order.
+ * Currently only IPv4 (0x0800) and IPv6 (0x86DD) ethertypes may be used.
+ */
+#define       MC_CMD_VNIC_ENCAP_RULE_ADD_IN_ETHER_TYPE_OFST 8
+#define       MC_CMD_VNIC_ENCAP_RULE_ADD_IN_ETHER_TYPE_LEN 2
+/* Only if MATCH_OUTER_VLAN is set. VID value as bytes in network order.
+ * (Deprecated)
+ */
+#define       MC_CMD_VNIC_ENCAP_RULE_ADD_IN_OUTER_VLAN_LBN 80
+#define       MC_CMD_VNIC_ENCAP_RULE_ADD_IN_OUTER_VLAN_WIDTH 12
+/* Only if MATCH_OUTER_VLAN is set. Aligned wrapper for OUTER_VLAN_VID. */
+#define       MC_CMD_VNIC_ENCAP_RULE_ADD_IN_OUTER_VLAN_WORD_OFST 10
+#define       MC_CMD_VNIC_ENCAP_RULE_ADD_IN_OUTER_VLAN_WORD_LEN 2
+#define        MC_CMD_VNIC_ENCAP_RULE_ADD_IN_OUTER_VLAN_VID_OFST 10
+#define        MC_CMD_VNIC_ENCAP_RULE_ADD_IN_OUTER_VLAN_VID_LBN 0
+#define        MC_CMD_VNIC_ENCAP_RULE_ADD_IN_OUTER_VLAN_VID_WIDTH 12
+/* Only if MATCH_DST_IP is set. IP address as bytes in network order. In the
+ * case of IPv4, the IP should be in the first 4 bytes and all other bytes
+ * should be zero.
+ */
+#define       MC_CMD_VNIC_ENCAP_RULE_ADD_IN_DST_IP_OFST 12
+#define       MC_CMD_VNIC_ENCAP_RULE_ADD_IN_DST_IP_LEN 16
+/* Only if MATCH_IP_PROTO is set. Currently only UDP proto (17) may be used. */
+#define       MC_CMD_VNIC_ENCAP_RULE_ADD_IN_IP_PROTO_OFST 28
+#define       MC_CMD_VNIC_ENCAP_RULE_ADD_IN_IP_PROTO_LEN 1
+/* Actions that should be applied to packets match the rule. */
+#define       MC_CMD_VNIC_ENCAP_RULE_ADD_IN_ACTION_FLAGS_OFST 29
+#define       MC_CMD_VNIC_ENCAP_RULE_ADD_IN_ACTION_FLAGS_LEN 1
+#define        MC_CMD_VNIC_ENCAP_RULE_ADD_IN_STRIP_OUTER_VLAN_OFST 29
+#define        MC_CMD_VNIC_ENCAP_RULE_ADD_IN_STRIP_OUTER_VLAN_LBN 0
+#define        MC_CMD_VNIC_ENCAP_RULE_ADD_IN_STRIP_OUTER_VLAN_WIDTH 1
+/* Only if MATCH_DST_PORT is set. Port number as bytes in network order. */
+#define       MC_CMD_VNIC_ENCAP_RULE_ADD_IN_DST_PORT_OFST 30
+#define       MC_CMD_VNIC_ENCAP_RULE_ADD_IN_DST_PORT_LEN 2
+/* Resulting encapsulation type, as per MAE_MCDI_ENCAP_TYPE enumeration. */
+#define       MC_CMD_VNIC_ENCAP_RULE_ADD_IN_ENCAP_TYPE_OFST 32
+#define       MC_CMD_VNIC_ENCAP_RULE_ADD_IN_ENCAP_TYPE_LEN 4
+
+/* MC_CMD_VNIC_ENCAP_RULE_ADD_OUT msgresponse */
+#define    MC_CMD_VNIC_ENCAP_RULE_ADD_OUT_LEN 4
+/* Handle to inserted rule. Used for removing the rule. */
+#define       MC_CMD_VNIC_ENCAP_RULE_ADD_OUT_HANDLE_OFST 0
+#define       MC_CMD_VNIC_ENCAP_RULE_ADD_OUT_HANDLE_LEN 4
+
+
+/***********************************/
+/* MC_CMD_VNIC_ENCAP_RULE_REMOVE
+ * Remove a VNIC encapsulation rule. Packets which would have previously matched the rule will then be considered as unencapsulated. Returns EALREADY if the input HANDLE doesn't correspond to an existing rule.
+ */
+#define MC_CMD_VNIC_ENCAP_RULE_REMOVE 0x16e
+#undef MC_CMD_0x16e_PRIVILEGE_CTG
+
+#define MC_CMD_0x16e_PRIVILEGE_CTG SRIOV_CTG_GENERAL
+
+/* MC_CMD_VNIC_ENCAP_RULE_REMOVE_IN msgrequest */
+#define    MC_CMD_VNIC_ENCAP_RULE_REMOVE_IN_LEN 4
+/* Handle which was returned by MC_CMD_VNIC_ENCAP_RULE_ADD. */
+#define       MC_CMD_VNIC_ENCAP_RULE_REMOVE_IN_HANDLE_OFST 0
+#define       MC_CMD_VNIC_ENCAP_RULE_REMOVE_IN_HANDLE_LEN 4
+
+/* MC_CMD_VNIC_ENCAP_RULE_REMOVE_OUT msgresponse */
+#define    MC_CMD_VNIC_ENCAP_RULE_REMOVE_OUT_LEN 0
+
+/* FUNCTION_PERSONALITY structuredef: The meanings of the personalities are
+ * defined in SF-120734-TC with more information in SF-122717-TC.
+ */
+#define    FUNCTION_PERSONALITY_LEN 4
+#define       FUNCTION_PERSONALITY_ID_OFST 0
+#define       FUNCTION_PERSONALITY_ID_LEN 4
+/* enum: Function has no assigned personality */
+#define          FUNCTION_PERSONALITY_NULL 0x0
+/* enum: Function has an EF100-style function control window and VI windows
+ * with both EF100 and vDPA doorbells.
+ */
+#define          FUNCTION_PERSONALITY_EF100 0x1
+/* enum: Function has virtio net device configuration registers and doorbells
+ * for virtio queue pairs.
+ */
+#define          FUNCTION_PERSONALITY_VIRTIO_NET 0x2
+/* enum: Function has virtio block device configuration registers and a
+ * doorbell for a single virtqueue.
+ */
+#define          FUNCTION_PERSONALITY_VIRTIO_BLK 0x3
+/* enum: Function is a Xilinx acceleration device - management function */
+#define          FUNCTION_PERSONALITY_ACCEL_MGMT 0x4
+/* enum: Function is a Xilinx acceleration device - user function */
+#define          FUNCTION_PERSONALITY_ACCEL_USR 0x5
+#define       FUNCTION_PERSONALITY_ID_LBN 0
+#define       FUNCTION_PERSONALITY_ID_WIDTH 32
+
+
+/***********************************/
+/* MC_CMD_VIRTIO_GET_FEATURES
+ * Get a list of the virtio features supported by the device.
+ */
+#define MC_CMD_VIRTIO_GET_FEATURES 0x168
+#undef MC_CMD_0x168_PRIVILEGE_CTG
+
+#define MC_CMD_0x168_PRIVILEGE_CTG SRIOV_CTG_GENERAL
+
+/* MC_CMD_VIRTIO_GET_FEATURES_IN msgrequest */
+#define    MC_CMD_VIRTIO_GET_FEATURES_IN_LEN 4
+/* Type of device to get features for. Matches the device id as defined by the
+ * virtio spec.
+ */
+#define       MC_CMD_VIRTIO_GET_FEATURES_IN_DEVICE_ID_OFST 0
+#define       MC_CMD_VIRTIO_GET_FEATURES_IN_DEVICE_ID_LEN 4
+/* enum: Reserved. Do not use. */
+#define          MC_CMD_VIRTIO_GET_FEATURES_IN_RESERVED 0x0
+/* enum: Net device. */
+#define          MC_CMD_VIRTIO_GET_FEATURES_IN_NET 0x1
+/* enum: Block device. */
+#define          MC_CMD_VIRTIO_GET_FEATURES_IN_BLOCK 0x2
+
+/* MC_CMD_VIRTIO_GET_FEATURES_OUT msgresponse */
+#define    MC_CMD_VIRTIO_GET_FEATURES_OUT_LEN 8
+/* Features supported by the device. The result is a bitfield in the format of
+ * the feature bits of the specified device type as defined in the virtIO 1.1
+ * specification ( https://docs.oasis-
+ * open.org/virtio/virtio/v1.1/csprd01/virtio-v1.1-csprd01.pdf )
+ */
+#define       MC_CMD_VIRTIO_GET_FEATURES_OUT_FEATURES_OFST 0
+#define       MC_CMD_VIRTIO_GET_FEATURES_OUT_FEATURES_LEN 8
+#define       MC_CMD_VIRTIO_GET_FEATURES_OUT_FEATURES_LO_OFST 0
+#define       MC_CMD_VIRTIO_GET_FEATURES_OUT_FEATURES_HI_OFST 4
+
+
+/***********************************/
+/* MC_CMD_VIRTIO_TEST_FEATURES
+ * Query whether a given set of features is supported. Fails with ENOSUP if the
+ * driver requests a feature the device doesn't support. Fails with EINVAL if
+ * the driver fails to request a feature which the device requires.
+ */
+#define MC_CMD_VIRTIO_TEST_FEATURES 0x169
+#undef MC_CMD_0x169_PRIVILEGE_CTG
+
+#define MC_CMD_0x169_PRIVILEGE_CTG SRIOV_CTG_GENERAL
+
+/* MC_CMD_VIRTIO_TEST_FEATURES_IN msgrequest */
+#define    MC_CMD_VIRTIO_TEST_FEATURES_IN_LEN 16
+/* Type of device to test features for. Matches the device id as defined by the
+ * virtio spec.
+ */
+#define       MC_CMD_VIRTIO_TEST_FEATURES_IN_DEVICE_ID_OFST 0
+#define       MC_CMD_VIRTIO_TEST_FEATURES_IN_DEVICE_ID_LEN 4
+/*            Enum values, see field(s): */
+/*               MC_CMD_VIRTIO_GET_FEATURES/MC_CMD_VIRTIO_GET_FEATURES_IN/DEVICE_ID */
+#define       MC_CMD_VIRTIO_TEST_FEATURES_IN_RESERVED_OFST 4
+#define       MC_CMD_VIRTIO_TEST_FEATURES_IN_RESERVED_LEN 4
+/* Features requested. Same format as the returned value from
+ * MC_CMD_VIRTIO_GET_FEATURES.
+ */
+#define       MC_CMD_VIRTIO_TEST_FEATURES_IN_FEATURES_OFST 8
+#define       MC_CMD_VIRTIO_TEST_FEATURES_IN_FEATURES_LEN 8
+#define       MC_CMD_VIRTIO_TEST_FEATURES_IN_FEATURES_LO_OFST 8
+#define       MC_CMD_VIRTIO_TEST_FEATURES_IN_FEATURES_HI_OFST 12
+
+/* MC_CMD_VIRTIO_TEST_FEATURES_OUT msgresponse */
+#define    MC_CMD_VIRTIO_TEST_FEATURES_OUT_LEN 0
+
+
+/***********************************/
+/* MC_CMD_VIRTIO_INIT_QUEUE
+ * Create a virtio virtqueue. Fails with EALREADY if the queue already exists.
+ * Fails with ENOSUP if a feature is requested that isn't supported. Fails with
+ * EINVAL if a required feature isn't requested, or any other parameter is
+ * invalid.
+ */
+#define MC_CMD_VIRTIO_INIT_QUEUE 0x16a
+#undef MC_CMD_0x16a_PRIVILEGE_CTG
+
+#define MC_CMD_0x16a_PRIVILEGE_CTG SRIOV_CTG_GENERAL
+
+/* MC_CMD_VIRTIO_INIT_QUEUE_REQ msgrequest */
+#define    MC_CMD_VIRTIO_INIT_QUEUE_REQ_LEN 68
+/* Type of virtqueue to create. A network rxq and a txq can exist at the same
+ * time on a single VI.
+ */
+#define       MC_CMD_VIRTIO_INIT_QUEUE_REQ_QUEUE_TYPE_OFST 0
+#define       MC_CMD_VIRTIO_INIT_QUEUE_REQ_QUEUE_TYPE_LEN 1
+/* enum: A network device receive queue */
+#define          MC_CMD_VIRTIO_INIT_QUEUE_REQ_NET_RXQ 0x0
+/* enum: A network device transmit queue */
+#define          MC_CMD_VIRTIO_INIT_QUEUE_REQ_NET_TXQ 0x1
+/* enum: A block device request queue */
+#define          MC_CMD_VIRTIO_INIT_QUEUE_REQ_BLOCK 0x2
+#define       MC_CMD_VIRTIO_INIT_QUEUE_REQ_RESERVED_OFST 1
+#define       MC_CMD_VIRTIO_INIT_QUEUE_REQ_RESERVED_LEN 1
+/* If the calling function is a PF and this field is not VF_NULL, create the
+ * queue on the specified child VF instead of on the PF.
+ */
+#define       MC_CMD_VIRTIO_INIT_QUEUE_REQ_TARGET_VF_OFST 2
+#define       MC_CMD_VIRTIO_INIT_QUEUE_REQ_TARGET_VF_LEN 2
+/* enum: No VF, create queue on the PF. */
+#define          MC_CMD_VIRTIO_INIT_QUEUE_REQ_VF_NULL 0xffff
+/* Desired instance. This is the function-local index of the associated VI, not
+ * the virtqueue number as counted by the virtqueue spec.
+ */
+#define       MC_CMD_VIRTIO_INIT_QUEUE_REQ_INSTANCE_OFST 4
+#define       MC_CMD_VIRTIO_INIT_QUEUE_REQ_INSTANCE_LEN 4
+/* Queue size, in entries. Must be a power of two. */
+#define       MC_CMD_VIRTIO_INIT_QUEUE_REQ_SIZE_OFST 8
+#define       MC_CMD_VIRTIO_INIT_QUEUE_REQ_SIZE_LEN 4
+/* Flags */
+#define       MC_CMD_VIRTIO_INIT_QUEUE_REQ_FLAGS_OFST 12
+#define       MC_CMD_VIRTIO_INIT_QUEUE_REQ_FLAGS_LEN 4
+#define        MC_CMD_VIRTIO_INIT_QUEUE_REQ_USE_PASID_OFST 12
+#define        MC_CMD_VIRTIO_INIT_QUEUE_REQ_USE_PASID_LBN 0
+#define        MC_CMD_VIRTIO_INIT_QUEUE_REQ_USE_PASID_WIDTH 1
+/* Address of the descriptor table in the virtqueue. */
+#define       MC_CMD_VIRTIO_INIT_QUEUE_REQ_DESC_TBL_ADDR_OFST 16
+#define       MC_CMD_VIRTIO_INIT_QUEUE_REQ_DESC_TBL_ADDR_LEN 8
+#define       MC_CMD_VIRTIO_INIT_QUEUE_REQ_DESC_TBL_ADDR_LO_OFST 16
+#define       MC_CMD_VIRTIO_INIT_QUEUE_REQ_DESC_TBL_ADDR_HI_OFST 20
+/* Address of the available ring in the virtqueue. */
+#define       MC_CMD_VIRTIO_INIT_QUEUE_REQ_AVAIL_RING_ADDR_OFST 24
+#define       MC_CMD_VIRTIO_INIT_QUEUE_REQ_AVAIL_RING_ADDR_LEN 8
+#define       MC_CMD_VIRTIO_INIT_QUEUE_REQ_AVAIL_RING_ADDR_LO_OFST 24
+#define       MC_CMD_VIRTIO_INIT_QUEUE_REQ_AVAIL_RING_ADDR_HI_OFST 28
+/* Address of the used ring in the virtqueue. */
+#define       MC_CMD_VIRTIO_INIT_QUEUE_REQ_USED_RING_ADDR_OFST 32
+#define       MC_CMD_VIRTIO_INIT_QUEUE_REQ_USED_RING_ADDR_LEN 8
+#define       MC_CMD_VIRTIO_INIT_QUEUE_REQ_USED_RING_ADDR_LO_OFST 32
+#define       MC_CMD_VIRTIO_INIT_QUEUE_REQ_USED_RING_ADDR_HI_OFST 36
+/* PASID to use on PCIe transactions involving this queue. Ignored if the
+ * USE_PASID flag is not set.
+ */
+#define       MC_CMD_VIRTIO_INIT_QUEUE_REQ_PASID_OFST 40
+#define       MC_CMD_VIRTIO_INIT_QUEUE_REQ_PASID_LEN 4
+/* Which MSIX vector to use for this virtqueue, or NO_VECTOR if MSIX should not
+ * be used.
+ */
+#define       MC_CMD_VIRTIO_INIT_QUEUE_REQ_MSIX_VECTOR_OFST 44
+#define       MC_CMD_VIRTIO_INIT_QUEUE_REQ_MSIX_VECTOR_LEN 2
+/* enum: Do not enable interrupts for this virtqueue */
+#define          MC_CMD_VIRTIO_INIT_QUEUE_REQ_NO_VECTOR 0xffff
+#define       MC_CMD_VIRTIO_INIT_QUEUE_REQ_RESERVED2_OFST 46
+#define       MC_CMD_VIRTIO_INIT_QUEUE_REQ_RESERVED2_LEN 2
+/* Virtio features to apply to this queue. Same format as the in the virtio
+ * spec and in the return from MC_CMD_VIRTIO_GET_FEATURES. Must be a subset of
+ * the features returned from MC_CMD_VIRTIO_GET_FEATURES. Features are per-
+ * queue because with vDPA multiple queues on the same function can be passed
+ * through to different virtual hosts as independent devices.
+ */
+#define       MC_CMD_VIRTIO_INIT_QUEUE_REQ_FEATURES_OFST 48
+#define       MC_CMD_VIRTIO_INIT_QUEUE_REQ_FEATURES_LEN 8
+#define       MC_CMD_VIRTIO_INIT_QUEUE_REQ_FEATURES_LO_OFST 48
+#define       MC_CMD_VIRTIO_INIT_QUEUE_REQ_FEATURES_HI_OFST 52
+/*            Enum values, see field(s): */
+/*               MC_CMD_VIRTIO_GET_FEATURES/MC_CMD_VIRTIO_GET_FEATURES_OUT/FEATURES */
+/* The inital producer index for this queue's used ring. If this queue is being
+ * created to be migrated into, this should be the FINAL_PIDX value returned by
+ * MC_CMD_VIRTIO_FINI_QUEUE of the queue being migrated from. Otherwise, it
+ * should be zero.
+ */
+#define       MC_CMD_VIRTIO_INIT_QUEUE_REQ_INITIAL_PIDX_OFST 56
+#define       MC_CMD_VIRTIO_INIT_QUEUE_REQ_INITIAL_PIDX_LEN 4
+/* The inital consumer index for this queue's available ring. If this queue is
+ * being created to be migrated into, this should be the FINAL_CIDX value
+ * returned by MC_CMD_VIRTIO_FINI_QUEUE of the queue being migrated from.
+ * Otherwise, it should be zero.
+ */
+#define       MC_CMD_VIRTIO_INIT_QUEUE_REQ_INITIAL_CIDX_OFST 60
+#define       MC_CMD_VIRTIO_INIT_QUEUE_REQ_INITIAL_CIDX_LEN 4
+/* A MAE_MPORT_SELECTOR defining which mport this queue should be associated
+ * with. Use MAE_MPORT_SELECTOR_ASSIGNED to request the default mport for the
+ * function this queue is being created on.
+ */
+#define       MC_CMD_VIRTIO_INIT_QUEUE_REQ_MPORT_SELECTOR_OFST 64
+#define       MC_CMD_VIRTIO_INIT_QUEUE_REQ_MPORT_SELECTOR_LEN 4
+
+/* MC_CMD_VIRTIO_INIT_QUEUE_RESP msgresponse */
+#define    MC_CMD_VIRTIO_INIT_QUEUE_RESP_LEN 0
+
+
+/***********************************/
+/* MC_CMD_VIRTIO_FINI_QUEUE
+ * Destroy a virtio virtqueue
+ */
+#define MC_CMD_VIRTIO_FINI_QUEUE 0x16b
+#undef MC_CMD_0x16b_PRIVILEGE_CTG
+
+#define MC_CMD_0x16b_PRIVILEGE_CTG SRIOV_CTG_GENERAL
+
+/* MC_CMD_VIRTIO_FINI_QUEUE_REQ msgrequest */
+#define    MC_CMD_VIRTIO_FINI_QUEUE_REQ_LEN 8
+/* Type of virtqueue to destroy. */
+#define       MC_CMD_VIRTIO_FINI_QUEUE_REQ_QUEUE_TYPE_OFST 0
+#define       MC_CMD_VIRTIO_FINI_QUEUE_REQ_QUEUE_TYPE_LEN 1
+/*            Enum values, see field(s): */
+/*               MC_CMD_VIRTIO_INIT_QUEUE/MC_CMD_VIRTIO_INIT_QUEUE_REQ/QUEUE_TYPE */
+#define       MC_CMD_VIRTIO_FINI_QUEUE_REQ_RESERVED_OFST 1
+#define       MC_CMD_VIRTIO_FINI_QUEUE_REQ_RESERVED_LEN 1
+/* If the calling function is a PF and this field is not VF_NULL, destroy the
+ * queue on the specified child VF instead of on the PF.
+ */
+#define       MC_CMD_VIRTIO_FINI_QUEUE_REQ_TARGET_VF_OFST 2
+#define       MC_CMD_VIRTIO_FINI_QUEUE_REQ_TARGET_VF_LEN 2
+/* enum: No VF, destroy the queue on the PF. */
+#define          MC_CMD_VIRTIO_FINI_QUEUE_REQ_VF_NULL 0xffff
+/* Instance to destroy */
+#define       MC_CMD_VIRTIO_FINI_QUEUE_REQ_INSTANCE_OFST 4
+#define       MC_CMD_VIRTIO_FINI_QUEUE_REQ_INSTANCE_LEN 4
+
+/* MC_CMD_VIRTIO_FINI_QUEUE_RESP msgresponse */
+#define    MC_CMD_VIRTIO_FINI_QUEUE_RESP_LEN 8
+/* The producer index of the used ring when the queue was stopped. */
+#define       MC_CMD_VIRTIO_FINI_QUEUE_RESP_FINAL_PIDX_OFST 0
+#define       MC_CMD_VIRTIO_FINI_QUEUE_RESP_FINAL_PIDX_LEN 4
+/* The consumer index of the available ring when the queue was stopped. */
+#define       MC_CMD_VIRTIO_FINI_QUEUE_RESP_FINAL_CIDX_OFST 4
+#define       MC_CMD_VIRTIO_FINI_QUEUE_RESP_FINAL_CIDX_LEN 4
+
+
+/***********************************/
+/* MC_CMD_VIRTIO_GET_DOORBELL_OFFSET
+ * Get the offset in the BAR of the doorbells for a VI. Doesn't require the
+ * queue(s) to be allocated.
+ */
+#define MC_CMD_VIRTIO_GET_DOORBELL_OFFSET 0x16c
+#undef MC_CMD_0x16c_PRIVILEGE_CTG
+
+#define MC_CMD_0x16c_PRIVILEGE_CTG SRIOV_CTG_GENERAL
+
+/* MC_CMD_VIRTIO_GET_DOORBELL_OFFSET_REQ msgrequest */
+#define    MC_CMD_VIRTIO_GET_DOORBELL_OFFSET_REQ_LEN 8
+/* Type of device to get information for. Matches the device id as defined by
+ * the virtio spec.
+ */
+#define       MC_CMD_VIRTIO_GET_DOORBELL_OFFSET_REQ_DEVICE_ID_OFST 0
+#define       MC_CMD_VIRTIO_GET_DOORBELL_OFFSET_REQ_DEVICE_ID_LEN 1
+/*            Enum values, see field(s): */
+/*               MC_CMD_VIRTIO_GET_FEATURES/MC_CMD_VIRTIO_GET_FEATURES_IN/DEVICE_ID */
+#define       MC_CMD_VIRTIO_GET_DOORBELL_OFFSET_REQ_RESERVED_OFST 1
+#define       MC_CMD_VIRTIO_GET_DOORBELL_OFFSET_REQ_RESERVED_LEN 1
+/* If the calling function is a PF and this field is not VF_NULL, query the VI
+ * on the specified child VF instead of on the PF.
+ */
+#define       MC_CMD_VIRTIO_GET_DOORBELL_OFFSET_REQ_TARGET_VF_OFST 2
+#define       MC_CMD_VIRTIO_GET_DOORBELL_OFFSET_REQ_TARGET_VF_LEN 2
+/* enum: No VF, query the PF. */
+#define          MC_CMD_VIRTIO_GET_DOORBELL_OFFSET_REQ_VF_NULL 0xffff
+/* VI instance to query */
+#define       MC_CMD_VIRTIO_GET_DOORBELL_OFFSET_REQ_INSTANCE_OFST 4
+#define       MC_CMD_VIRTIO_GET_DOORBELL_OFFSET_REQ_INSTANCE_LEN 4
+
+/* MC_CMD_VIRTIO_GET_NET_DOORBELL_OFFSET_RESP msgresponse */
+#define    MC_CMD_VIRTIO_GET_NET_DOORBELL_OFFSET_RESP_LEN 8
+/* Offset of RX doorbell in BAR */
+#define       MC_CMD_VIRTIO_GET_NET_DOORBELL_OFFSET_RESP_RX_DBL_OFFSET_OFST 0
+#define       MC_CMD_VIRTIO_GET_NET_DOORBELL_OFFSET_RESP_RX_DBL_OFFSET_LEN 4
+/* Offset of TX doorbell in BAR */
+#define       MC_CMD_VIRTIO_GET_NET_DOORBELL_OFFSET_RESP_TX_DBL_OFFSET_OFST 4
+#define       MC_CMD_VIRTIO_GET_NET_DOORBELL_OFFSET_RESP_TX_DBL_OFFSET_LEN 4
+
+/* MC_CMD_VIRTIO_GET_BLOCK_DOORBELL_OFFSET_RESP msgresponse */
+#define    MC_CMD_VIRTIO_GET_BLOCK_DOORBELL_OFFSET_RESP_LEN 4
+/* Offset of request doorbell in BAR */
+#define       MC_CMD_VIRTIO_GET_BLOCK_DOORBELL_OFFSET_RESP_DBL_OFFSET_OFST 0
+#define       MC_CMD_VIRTIO_GET_BLOCK_DOORBELL_OFFSET_RESP_DBL_OFFSET_LEN 4
+
+/* PCIE_FUNCTION structuredef: Structure representing a PCIe function ID
+ * (interface/PF/VF tuple)
+ */
+#define    PCIE_FUNCTION_LEN 8
+/* PCIe PF function number */
+#define       PCIE_FUNCTION_PF_OFST 0
+#define       PCIE_FUNCTION_PF_LEN 2
+/* enum: Wildcard value representing any available function (e.g in resource
+ * allocation requests)
+ */
+#define          PCIE_FUNCTION_PF_ANY 0xfffe
+/* enum: Value representing invalid (null) function */
+#define          PCIE_FUNCTION_PF_NULL 0xffff
+#define       PCIE_FUNCTION_PF_LBN 0
+#define       PCIE_FUNCTION_PF_WIDTH 16
+/* PCIe VF Function number (PF relative) */
+#define       PCIE_FUNCTION_VF_OFST 2
+#define       PCIE_FUNCTION_VF_LEN 2
+/* enum: Wildcard value representing any available function (e.g in resource
+ * allocation requests)
+ */
+#define          PCIE_FUNCTION_VF_ANY 0xfffe
+/* enum: Function is a PF (when PF != PF_NULL) or invalid function (when PF ==
+ * PF_NULL)
+ */
+#define          PCIE_FUNCTION_VF_NULL 0xffff
+#define       PCIE_FUNCTION_VF_LBN 16
+#define       PCIE_FUNCTION_VF_WIDTH 16
+/* PCIe interface of the function */
+#define       PCIE_FUNCTION_INTF_OFST 4
+#define       PCIE_FUNCTION_INTF_LEN 4
+/* enum: Host PCIe interface */
+#define          PCIE_FUNCTION_INTF_HOST 0x0
+/* enum: Application Processor interface */
+#define          PCIE_FUNCTION_INTF_AP 0x1
+#define       PCIE_FUNCTION_INTF_LBN 32
+#define       PCIE_FUNCTION_INTF_WIDTH 32
+
+
+/***********************************/
+/* MC_CMD_DESC_PROXY_FUNC_CREATE
+ * Descriptor proxy functions are abstract devices that forward all request
+ * submitted to the host PCIe function (descriptors submitted to Virtio or
+ * EF100 queues) to be handled on another function (most commonly on the
+ * embedded Application Processor), via EF100 descriptor proxy, memory-to-
+ * memory and descriptor-to-completion mechanisms. Primary user is Virtio-blk
+ * subsystem, see SF-122927-TC. This function allocates a new descriptor proxy
+ * function on the host and assigns a user-defined label. The actual function
+ * configuration is not persisted until the caller configures it with
+ * MC_CMD_DESC_PROXY_FUNC_CONFIG_SET_IN and commits with
+ * MC_CMD_DESC_PROXY_FUNC_COMMIT_IN.
+ */
+#define MC_CMD_DESC_PROXY_FUNC_CREATE 0x172
+#undef MC_CMD_0x172_PRIVILEGE_CTG
+
+#define MC_CMD_0x172_PRIVILEGE_CTG SRIOV_CTG_ADMIN
+
+/* MC_CMD_DESC_PROXY_FUNC_CREATE_IN msgrequest */
+#define    MC_CMD_DESC_PROXY_FUNC_CREATE_IN_LEN 52
+/* PCIe Function ID to allocate (as struct PCIE_FUNCTION). Set to
+ * {PF_ANY,VF_ANY,interface} for "any available function" Set to
+ * {PF_ANY,VF_NULL,interface} for "any available PF"
+ */
+#define       MC_CMD_DESC_PROXY_FUNC_CREATE_IN_FUNC_OFST 0
+#define       MC_CMD_DESC_PROXY_FUNC_CREATE_IN_FUNC_LEN 8
+#define       MC_CMD_DESC_PROXY_FUNC_CREATE_IN_FUNC_LO_OFST 0
+#define       MC_CMD_DESC_PROXY_FUNC_CREATE_IN_FUNC_HI_OFST 4
+/* The personality to set. The meanings of the personalities are defined in
+ * SF-120734-TC with more information in SF-122717-TC. At present, we only
+ * support proxying for VIRTIO_BLK
+ */
+#define       MC_CMD_DESC_PROXY_FUNC_CREATE_IN_PERSONALITY_OFST 8
+#define       MC_CMD_DESC_PROXY_FUNC_CREATE_IN_PERSONALITY_LEN 4
+/*            Enum values, see field(s): */
+/*               FUNCTION_PERSONALITY/ID */
+/* User-defined label (zero-terminated ASCII string) to uniquely identify the
+ * function
+ */
+#define       MC_CMD_DESC_PROXY_FUNC_CREATE_IN_LABEL_OFST 12
+#define       MC_CMD_DESC_PROXY_FUNC_CREATE_IN_LABEL_LEN 40
+
+/* MC_CMD_DESC_PROXY_FUNC_CREATE_OUT msgresponse */
+#define    MC_CMD_DESC_PROXY_FUNC_CREATE_OUT_LEN 12
+/* Handle to the descriptor proxy function */
+#define       MC_CMD_DESC_PROXY_FUNC_CREATE_OUT_HANDLE_OFST 0
+#define       MC_CMD_DESC_PROXY_FUNC_CREATE_OUT_HANDLE_LEN 4
+/* Allocated function ID (as struct PCIE_FUNCTION) */
+#define       MC_CMD_DESC_PROXY_FUNC_CREATE_OUT_FUNC_OFST 4
+#define       MC_CMD_DESC_PROXY_FUNC_CREATE_OUT_FUNC_LEN 8
+#define       MC_CMD_DESC_PROXY_FUNC_CREATE_OUT_FUNC_LO_OFST 4
+#define       MC_CMD_DESC_PROXY_FUNC_CREATE_OUT_FUNC_HI_OFST 8
+
+
+/***********************************/
+/* MC_CMD_DESC_PROXY_FUNC_DESTROY
+ * Remove an existing descriptor proxy function. Underlying function
+ * personality and configuration reverts back to factory default. Function
+ * configuration is committed immediately to specified store and any function
+ * ownership is released.
+ */
+#define MC_CMD_DESC_PROXY_FUNC_DESTROY 0x173
+#undef MC_CMD_0x173_PRIVILEGE_CTG
+
+#define MC_CMD_0x173_PRIVILEGE_CTG SRIOV_CTG_ADMIN
+
+/* MC_CMD_DESC_PROXY_FUNC_DESTROY_IN msgrequest */
+#define    MC_CMD_DESC_PROXY_FUNC_DESTROY_IN_LEN 44
+/* User-defined label (zero-terminated ASCII string) to uniquely identify the
+ * function
+ */
+#define       MC_CMD_DESC_PROXY_FUNC_DESTROY_IN_LABEL_OFST 0
+#define       MC_CMD_DESC_PROXY_FUNC_DESTROY_IN_LABEL_LEN 40
+/* Store from which to remove function configuration */
+#define       MC_CMD_DESC_PROXY_FUNC_DESTROY_IN_STORE_OFST 40
+#define       MC_CMD_DESC_PROXY_FUNC_DESTROY_IN_STORE_LEN 4
+/*            Enum values, see field(s): */
+/*               MC_CMD_DESC_PROXY_FUNC_COMMIT/MC_CMD_DESC_PROXY_FUNC_COMMIT_IN/STORE */
+
+/* MC_CMD_DESC_PROXY_FUNC_DESTROY_OUT msgresponse */
+#define    MC_CMD_DESC_PROXY_FUNC_DESTROY_OUT_LEN 0
+
+/* VIRTIO_BLK_CONFIG structuredef: Virtio block device configuration. See
+ * Virtio specification v1.1, Sections 5.2.3 and 6 for definition of feature
+ * bits. See Virtio specification v1.1, Section 5.2.4 (struct
+ * virtio_blk_config) for definition of remaining configuration fields
+ */
+#define    VIRTIO_BLK_CONFIG_LEN 68
+/* Virtio block device features to advertise, per Virtio 1.1, 5.2.3 and 6 */
+#define       VIRTIO_BLK_CONFIG_FEATURES_OFST 0
+#define       VIRTIO_BLK_CONFIG_FEATURES_LEN 8
+#define       VIRTIO_BLK_CONFIG_FEATURES_LO_OFST 0
+#define       VIRTIO_BLK_CONFIG_FEATURES_HI_OFST 4
+#define        VIRTIO_BLK_CONFIG_VIRTIO_BLK_F_BARRIER_OFST 0
+#define        VIRTIO_BLK_CONFIG_VIRTIO_BLK_F_BARRIER_LBN 0
+#define        VIRTIO_BLK_CONFIG_VIRTIO_BLK_F_BARRIER_WIDTH 1
+#define        VIRTIO_BLK_CONFIG_VIRTIO_BLK_F_SIZE_MAX_OFST 0
+#define        VIRTIO_BLK_CONFIG_VIRTIO_BLK_F_SIZE_MAX_LBN 1
+#define        VIRTIO_BLK_CONFIG_VIRTIO_BLK_F_SIZE_MAX_WIDTH 1
+#define        VIRTIO_BLK_CONFIG_VIRTIO_BLK_F_SEG_MAX_OFST 0
+#define        VIRTIO_BLK_CONFIG_VIRTIO_BLK_F_SEG_MAX_LBN 2
+#define        VIRTIO_BLK_CONFIG_VIRTIO_BLK_F_SEG_MAX_WIDTH 1
+#define        VIRTIO_BLK_CONFIG_VIRTIO_BLK_F_GEOMETRY_OFST 0
+#define        VIRTIO_BLK_CONFIG_VIRTIO_BLK_F_GEOMETRY_LBN 4
+#define        VIRTIO_BLK_CONFIG_VIRTIO_BLK_F_GEOMETRY_WIDTH 1
+#define        VIRTIO_BLK_CONFIG_VIRTIO_BLK_F_RO_OFST 0
+#define        VIRTIO_BLK_CONFIG_VIRTIO_BLK_F_RO_LBN 5
+#define        VIRTIO_BLK_CONFIG_VIRTIO_BLK_F_RO_WIDTH 1
+#define        VIRTIO_BLK_CONFIG_VIRTIO_BLK_F_BLK_SIZE_OFST 0
+#define        VIRTIO_BLK_CONFIG_VIRTIO_BLK_F_BLK_SIZE_LBN 6
+#define        VIRTIO_BLK_CONFIG_VIRTIO_BLK_F_BLK_SIZE_WIDTH 1
+#define        VIRTIO_BLK_CONFIG_VIRTIO_BLK_F_SCSI_OFST 0
+#define        VIRTIO_BLK_CONFIG_VIRTIO_BLK_F_SCSI_LBN 7
+#define        VIRTIO_BLK_CONFIG_VIRTIO_BLK_F_SCSI_WIDTH 1
+#define        VIRTIO_BLK_CONFIG_VIRTIO_BLK_F_FLUSH_OFST 0
+#define        VIRTIO_BLK_CONFIG_VIRTIO_BLK_F_FLUSH_LBN 9
+#define        VIRTIO_BLK_CONFIG_VIRTIO_BLK_F_FLUSH_WIDTH 1
+#define        VIRTIO_BLK_CONFIG_VIRTIO_BLK_F_TOPOLOGY_OFST 0
+#define        VIRTIO_BLK_CONFIG_VIRTIO_BLK_F_TOPOLOGY_LBN 10
+#define        VIRTIO_BLK_CONFIG_VIRTIO_BLK_F_TOPOLOGY_WIDTH 1
+#define        VIRTIO_BLK_CONFIG_VIRTIO_BLK_F_CONFIG_WCE_OFST 0
+#define        VIRTIO_BLK_CONFIG_VIRTIO_BLK_F_CONFIG_WCE_LBN 11
+#define        VIRTIO_BLK_CONFIG_VIRTIO_BLK_F_CONFIG_WCE_WIDTH 1
+#define        VIRTIO_BLK_CONFIG_VIRTIO_BLK_F_MQ_OFST 0
+#define        VIRTIO_BLK_CONFIG_VIRTIO_BLK_F_MQ_LBN 12
+#define        VIRTIO_BLK_CONFIG_VIRTIO_BLK_F_MQ_WIDTH 1
+#define        VIRTIO_BLK_CONFIG_VIRTIO_BLK_F_DISCARD_OFST 0
+#define        VIRTIO_BLK_CONFIG_VIRTIO_BLK_F_DISCARD_LBN 13
+#define        VIRTIO_BLK_CONFIG_VIRTIO_BLK_F_DISCARD_WIDTH 1
+#define        VIRTIO_BLK_CONFIG_VIRTIO_BLK_F_WRITE_ZEROES_OFST 0
+#define        VIRTIO_BLK_CONFIG_VIRTIO_BLK_F_WRITE_ZEROES_LBN 14
+#define        VIRTIO_BLK_CONFIG_VIRTIO_BLK_F_WRITE_ZEROES_WIDTH 1
+#define        VIRTIO_BLK_CONFIG_VIRTIO_F_RING_INDIRECT_DESC_OFST 0
+#define        VIRTIO_BLK_CONFIG_VIRTIO_F_RING_INDIRECT_DESC_LBN 28
+#define        VIRTIO_BLK_CONFIG_VIRTIO_F_RING_INDIRECT_DESC_WIDTH 1
+#define        VIRTIO_BLK_CONFIG_VIRTIO_F_RING_EVENT_IDX_OFST 0
+#define        VIRTIO_BLK_CONFIG_VIRTIO_F_RING_EVENT_IDX_LBN 29
+#define        VIRTIO_BLK_CONFIG_VIRTIO_F_RING_EVENT_IDX_WIDTH 1
+#define        VIRTIO_BLK_CONFIG_VIRTIO_F_VERSION_1_OFST 0
+#define        VIRTIO_BLK_CONFIG_VIRTIO_F_VERSION_1_LBN 32
+#define        VIRTIO_BLK_CONFIG_VIRTIO_F_VERSION_1_WIDTH 1
+#define        VIRTIO_BLK_CONFIG_VIRTIO_F_ACCESS_PLATFORM_OFST 0
+#define        VIRTIO_BLK_CONFIG_VIRTIO_F_ACCESS_PLATFORM_LBN 33
+#define        VIRTIO_BLK_CONFIG_VIRTIO_F_ACCESS_PLATFORM_WIDTH 1
+#define        VIRTIO_BLK_CONFIG_VIRTIO_F_RING_PACKED_OFST 0
+#define        VIRTIO_BLK_CONFIG_VIRTIO_F_RING_PACKED_LBN 34
+#define        VIRTIO_BLK_CONFIG_VIRTIO_F_RING_PACKED_WIDTH 1
+#define        VIRTIO_BLK_CONFIG_VIRTIO_F_IN_ORDER_OFST 0
+#define        VIRTIO_BLK_CONFIG_VIRTIO_F_IN_ORDER_LBN 35
+#define        VIRTIO_BLK_CONFIG_VIRTIO_F_IN_ORDER_WIDTH 1
+#define        VIRTIO_BLK_CONFIG_VIRTIO_F_ORDER_PLATFORM_OFST 0
+#define        VIRTIO_BLK_CONFIG_VIRTIO_F_ORDER_PLATFORM_LBN 36
+#define        VIRTIO_BLK_CONFIG_VIRTIO_F_ORDER_PLATFORM_WIDTH 1
+#define        VIRTIO_BLK_CONFIG_VIRTIO_F_SR_IOV_OFST 0
+#define        VIRTIO_BLK_CONFIG_VIRTIO_F_SR_IOV_LBN 37
+#define        VIRTIO_BLK_CONFIG_VIRTIO_F_SR_IOV_WIDTH 1
+#define        VIRTIO_BLK_CONFIG_VIRTIO_F_NOTIFICATION_DATA_OFST 0
+#define        VIRTIO_BLK_CONFIG_VIRTIO_F_NOTIFICATION_DATA_LBN 38
+#define        VIRTIO_BLK_CONFIG_VIRTIO_F_NOTIFICATION_DATA_WIDTH 1
+#define       VIRTIO_BLK_CONFIG_FEATURES_LBN 0
+#define       VIRTIO_BLK_CONFIG_FEATURES_WIDTH 64
+/* The capacity of the device (expressed in 512-byte sectors) */
+#define       VIRTIO_BLK_CONFIG_CAPACITY_OFST 8
+#define       VIRTIO_BLK_CONFIG_CAPACITY_LEN 8
+#define       VIRTIO_BLK_CONFIG_CAPACITY_LO_OFST 8
+#define       VIRTIO_BLK_CONFIG_CAPACITY_HI_OFST 12
+#define       VIRTIO_BLK_CONFIG_CAPACITY_LBN 64
+#define       VIRTIO_BLK_CONFIG_CAPACITY_WIDTH 64
+/* Maximum size of any single segment. Only valid when VIRTIO_BLK_F_SIZE_MAX is
+ * set.
+ */
+#define       VIRTIO_BLK_CONFIG_SIZE_MAX_OFST 16
+#define       VIRTIO_BLK_CONFIG_SIZE_MAX_LEN 4
+#define       VIRTIO_BLK_CONFIG_SIZE_MAX_LBN 128
+#define       VIRTIO_BLK_CONFIG_SIZE_MAX_WIDTH 32
+/* Maximum number of segments in a request. Only valid when
+ * VIRTIO_BLK_F_SEG_MAX is set.
+ */
+#define       VIRTIO_BLK_CONFIG_SEG_MAX_OFST 20
+#define       VIRTIO_BLK_CONFIG_SEG_MAX_LEN 4
+#define       VIRTIO_BLK_CONFIG_SEG_MAX_LBN 160
+#define       VIRTIO_BLK_CONFIG_SEG_MAX_WIDTH 32
+/* Disk-style geometry - cylinders. Only valid when VIRTIO_BLK_F_GEOMETRY is
+ * set.
+ */
+#define       VIRTIO_BLK_CONFIG_CYLINDERS_OFST 24
+#define       VIRTIO_BLK_CONFIG_CYLINDERS_LEN 2
+#define       VIRTIO_BLK_CONFIG_CYLINDERS_LBN 192
+#define       VIRTIO_BLK_CONFIG_CYLINDERS_WIDTH 16
+/* Disk-style geometry - heads. Only valid when VIRTIO_BLK_F_GEOMETRY is set.
+ */
+#define       VIRTIO_BLK_CONFIG_HEADS_OFST 26
+#define       VIRTIO_BLK_CONFIG_HEADS_LEN 1
+#define       VIRTIO_BLK_CONFIG_HEADS_LBN 208
+#define       VIRTIO_BLK_CONFIG_HEADS_WIDTH 8
+/* Disk-style geometry - sectors. Only valid when VIRTIO_BLK_F_GEOMETRY is set.
+ */
+#define       VIRTIO_BLK_CONFIG_SECTORS_OFST 27
+#define       VIRTIO_BLK_CONFIG_SECTORS_LEN 1
+#define       VIRTIO_BLK_CONFIG_SECTORS_LBN 216
+#define       VIRTIO_BLK_CONFIG_SECTORS_WIDTH 8
+/* Block size of disk. Only valid when VIRTIO_BLK_F_BLK_SIZE is set. */
+#define       VIRTIO_BLK_CONFIG_BLK_SIZE_OFST 28
+#define       VIRTIO_BLK_CONFIG_BLK_SIZE_LEN 4
+#define       VIRTIO_BLK_CONFIG_BLK_SIZE_LBN 224
+#define       VIRTIO_BLK_CONFIG_BLK_SIZE_WIDTH 32
+/* Block topology - number of logical blocks per physical block (log2). Only
+ * valid when VIRTIO_BLK_F_TOPOLOGY is set.
+ */
+#define       VIRTIO_BLK_CONFIG_PHYSICAL_BLOCK_EXP_OFST 32
+#define       VIRTIO_BLK_CONFIG_PHYSICAL_BLOCK_EXP_LEN 1
+#define       VIRTIO_BLK_CONFIG_PHYSICAL_BLOCK_EXP_LBN 256
+#define       VIRTIO_BLK_CONFIG_PHYSICAL_BLOCK_EXP_WIDTH 8
+/* Block topology - offset of first aligned logical block. Only valid when
+ * VIRTIO_BLK_F_TOPOLOGY is set.
+ */
+#define       VIRTIO_BLK_CONFIG_ALIGNMENT_OFFSET_OFST 33
+#define       VIRTIO_BLK_CONFIG_ALIGNMENT_OFFSET_LEN 1
+#define       VIRTIO_BLK_CONFIG_ALIGNMENT_OFFSET_LBN 264
+#define       VIRTIO_BLK_CONFIG_ALIGNMENT_OFFSET_WIDTH 8
+/* Block topology - suggested minimum I/O size in blocks. Only valid when
+ * VIRTIO_BLK_F_TOPOLOGY is set.
+ */
+#define       VIRTIO_BLK_CONFIG_MIN_IO_SIZE_OFST 34
+#define       VIRTIO_BLK_CONFIG_MIN_IO_SIZE_LEN 2
+#define       VIRTIO_BLK_CONFIG_MIN_IO_SIZE_LBN 272
+#define       VIRTIO_BLK_CONFIG_MIN_IO_SIZE_WIDTH 16
+/* Block topology - optimal (suggested maximum) I/O size in blocks. Only valid
+ * when VIRTIO_BLK_F_TOPOLOGY is set.
+ */
+#define       VIRTIO_BLK_CONFIG_OPT_IO_SIZE_OFST 36
+#define       VIRTIO_BLK_CONFIG_OPT_IO_SIZE_LEN 4
+#define       VIRTIO_BLK_CONFIG_OPT_IO_SIZE_LBN 288
+#define       VIRTIO_BLK_CONFIG_OPT_IO_SIZE_WIDTH 32
+/* Unused, set to zero. Note that virtio_blk_config.writeback is volatile and
+ * not carried in config data.
+ */
+#define       VIRTIO_BLK_CONFIG_UNUSED0_OFST 40
+#define       VIRTIO_BLK_CONFIG_UNUSED0_LEN 2
+#define       VIRTIO_BLK_CONFIG_UNUSED0_LBN 320
+#define       VIRTIO_BLK_CONFIG_UNUSED0_WIDTH 16
+/* Number of queues. Only valid if the VIRTIO_BLK_F_MQ feature is negotiated.
+ */
+#define       VIRTIO_BLK_CONFIG_NUM_QUEUES_OFST 42
+#define       VIRTIO_BLK_CONFIG_NUM_QUEUES_LEN 2
+#define       VIRTIO_BLK_CONFIG_NUM_QUEUES_LBN 336
+#define       VIRTIO_BLK_CONFIG_NUM_QUEUES_WIDTH 16
+/* Maximum discard sectors size, in 512-byte units. Only valid if
+ * VIRTIO_BLK_F_DISCARD is set.
+ */
+#define       VIRTIO_BLK_CONFIG_MAX_DISCARD_SECTORS_OFST 44
+#define       VIRTIO_BLK_CONFIG_MAX_DISCARD_SECTORS_LEN 4
+#define       VIRTIO_BLK_CONFIG_MAX_DISCARD_SECTORS_LBN 352
+#define       VIRTIO_BLK_CONFIG_MAX_DISCARD_SECTORS_WIDTH 32
+/* Maximum discard segment number. Only valid if VIRTIO_BLK_F_DISCARD is set.
+ */
+#define       VIRTIO_BLK_CONFIG_MAX_DISCARD_SEG_OFST 48
+#define       VIRTIO_BLK_CONFIG_MAX_DISCARD_SEG_LEN 4
+#define       VIRTIO_BLK_CONFIG_MAX_DISCARD_SEG_LBN 384
+#define       VIRTIO_BLK_CONFIG_MAX_DISCARD_SEG_WIDTH 32
+/* Discard sector alignment, in 512-byte units. Only valid if
+ * VIRTIO_BLK_F_DISCARD is set.
+ */
+#define       VIRTIO_BLK_CONFIG_DISCARD_SECTOR_ALIGNMENT_OFST 52
+#define       VIRTIO_BLK_CONFIG_DISCARD_SECTOR_ALIGNMENT_LEN 4
+#define       VIRTIO_BLK_CONFIG_DISCARD_SECTOR_ALIGNMENT_LBN 416
+#define       VIRTIO_BLK_CONFIG_DISCARD_SECTOR_ALIGNMENT_WIDTH 32
+/* Maximum write zeroes sectors size, in 512-byte units. Only valid if
+ * VIRTIO_BLK_F_WRITE_ZEROES is set.
+ */
+#define       VIRTIO_BLK_CONFIG_MAX_WRITE_ZEROES_SECTORS_OFST 56
+#define       VIRTIO_BLK_CONFIG_MAX_WRITE_ZEROES_SECTORS_LEN 4
+#define       VIRTIO_BLK_CONFIG_MAX_WRITE_ZEROES_SECTORS_LBN 448
+#define       VIRTIO_BLK_CONFIG_MAX_WRITE_ZEROES_SECTORS_WIDTH 32
+/* Maximum write zeroes segment number. Only valid if VIRTIO_BLK_F_WRITE_ZEROES
+ * is set.
+ */
+#define       VIRTIO_BLK_CONFIG_MAX_WRITE_ZEROES_SEG_OFST 60
+#define       VIRTIO_BLK_CONFIG_MAX_WRITE_ZEROES_SEG_LEN 4
+#define       VIRTIO_BLK_CONFIG_MAX_WRITE_ZEROES_SEG_LBN 480
+#define       VIRTIO_BLK_CONFIG_MAX_WRITE_ZEROES_SEG_WIDTH 32
+/* Write zeroes request can result in deallocating one or more sectors. Only
+ * valid if VIRTIO_BLK_F_WRITE_ZEROES is set.
+ */
+#define       VIRTIO_BLK_CONFIG_WRITE_ZEROES_MAY_UNMAP_OFST 64
+#define       VIRTIO_BLK_CONFIG_WRITE_ZEROES_MAY_UNMAP_LEN 1
+#define       VIRTIO_BLK_CONFIG_WRITE_ZEROES_MAY_UNMAP_LBN 512
+#define       VIRTIO_BLK_CONFIG_WRITE_ZEROES_MAY_UNMAP_WIDTH 8
+/* Unused, set to zero. */
+#define       VIRTIO_BLK_CONFIG_UNUSED1_OFST 65
+#define       VIRTIO_BLK_CONFIG_UNUSED1_LEN 3
+#define       VIRTIO_BLK_CONFIG_UNUSED1_LBN 520
+#define       VIRTIO_BLK_CONFIG_UNUSED1_WIDTH 24
+
+
+/***********************************/
+/* MC_CMD_DESC_PROXY_FUNC_CONFIG_SET
+ * Set configuration for an existing descriptor proxy function. Configuration
+ * data must match function personality. The actual function configuration is
+ * not persisted until the caller commits with MC_CMD_DESC_PROXY_FUNC_COMMIT_IN
+ */
+#define MC_CMD_DESC_PROXY_FUNC_CONFIG_SET 0x174
+#undef MC_CMD_0x174_PRIVILEGE_CTG
+
+#define MC_CMD_0x174_PRIVILEGE_CTG SRIOV_CTG_ADMIN
+
+/* MC_CMD_DESC_PROXY_FUNC_CONFIG_SET_IN msgrequest */
+#define    MC_CMD_DESC_PROXY_FUNC_CONFIG_SET_IN_LENMIN 20
+#define    MC_CMD_DESC_PROXY_FUNC_CONFIG_SET_IN_LENMAX 252
+#define    MC_CMD_DESC_PROXY_FUNC_CONFIG_SET_IN_LENMAX_MCDI2 1020
+#define    MC_CMD_DESC_PROXY_FUNC_CONFIG_SET_IN_LEN(num) (20+1*(num))
+#define    MC_CMD_DESC_PROXY_FUNC_CONFIG_SET_IN_CONFIG_NUM(len) (((len)-20)/1)
+/* Handle to descriptor proxy function (as returned by
+ * MC_CMD_DESC_PROXY_FUNC_OPEN)
+ */
+#define       MC_CMD_DESC_PROXY_FUNC_CONFIG_SET_IN_HANDLE_OFST 0
+#define       MC_CMD_DESC_PROXY_FUNC_CONFIG_SET_IN_HANDLE_LEN 4
+/* Reserved for future extension, set to zero. */
+#define       MC_CMD_DESC_PROXY_FUNC_CONFIG_SET_IN_RESERVED_OFST 4
+#define       MC_CMD_DESC_PROXY_FUNC_CONFIG_SET_IN_RESERVED_LEN 16
+/* Configuration data. Format of configuration data is determined implicitly
+ * from function personality referred to by HANDLE. Currently, only supported
+ * format is VIRTIO_BLK_CONFIG.
+ */
+#define       MC_CMD_DESC_PROXY_FUNC_CONFIG_SET_IN_CONFIG_OFST 20
+#define       MC_CMD_DESC_PROXY_FUNC_CONFIG_SET_IN_CONFIG_LEN 1
+#define       MC_CMD_DESC_PROXY_FUNC_CONFIG_SET_IN_CONFIG_MINNUM 0
+#define       MC_CMD_DESC_PROXY_FUNC_CONFIG_SET_IN_CONFIG_MAXNUM 232
+#define       MC_CMD_DESC_PROXY_FUNC_CONFIG_SET_IN_CONFIG_MAXNUM_MCDI2 1000
+
+/* MC_CMD_DESC_PROXY_FUNC_CONFIG_SET_OUT msgresponse */
+#define    MC_CMD_DESC_PROXY_FUNC_CONFIG_SET_OUT_LEN 0
+
+
+/***********************************/
+/* MC_CMD_DESC_PROXY_FUNC_COMMIT
+ * Commit function configuration to non-volatile or volatile store. Once
+ * configuration is applied to hardware (which may happen immediately or on
+ * next function/device reset) a DESC_PROXY_FUNC_CONFIG_SET MCDI event will be
+ * delivered to callers MCDI event queue.
+ */
+#define MC_CMD_DESC_PROXY_FUNC_COMMIT 0x175
+#undef MC_CMD_0x175_PRIVILEGE_CTG
+
+#define MC_CMD_0x175_PRIVILEGE_CTG SRIOV_CTG_ADMIN
+
+/* MC_CMD_DESC_PROXY_FUNC_COMMIT_IN msgrequest */
+#define    MC_CMD_DESC_PROXY_FUNC_COMMIT_IN_LEN 8
+/* Handle to descriptor proxy function (as returned by
+ * MC_CMD_DESC_PROXY_FUNC_OPEN)
+ */
+#define       MC_CMD_DESC_PROXY_FUNC_COMMIT_IN_HANDLE_OFST 0
+#define       MC_CMD_DESC_PROXY_FUNC_COMMIT_IN_HANDLE_LEN 4
+#define       MC_CMD_DESC_PROXY_FUNC_COMMIT_IN_STORE_OFST 4
+#define       MC_CMD_DESC_PROXY_FUNC_COMMIT_IN_STORE_LEN 4
+/* enum: Store into non-volatile (dynamic) config */
+#define          MC_CMD_DESC_PROXY_FUNC_COMMIT_IN_NON_VOLATILE 0x0
+/* enum: Store into volatile (ephemeral) config */
+#define          MC_CMD_DESC_PROXY_FUNC_COMMIT_IN_VOLATILE 0x1
+
+/* MC_CMD_DESC_PROXY_FUNC_COMMIT_OUT msgresponse */
+#define    MC_CMD_DESC_PROXY_FUNC_COMMIT_OUT_LEN 4
+/* Generation count to be delivered in an event once configuration becomes live
+ */
+#define       MC_CMD_DESC_PROXY_FUNC_COMMIT_OUT_CONFIG_GENERATION_OFST 0
+#define       MC_CMD_DESC_PROXY_FUNC_COMMIT_OUT_CONFIG_GENERATION_LEN 4
+
+
+/***********************************/
+/* MC_CMD_DESC_PROXY_FUNC_OPEN
+ * Retrieve a handle for an existing descriptor proxy function. Returns an
+ * integer handle, valid until function is deallocated, MC rebooted or power-
+ * cycle. Returns ENODEV if no function with given label exists.
+ */
+#define MC_CMD_DESC_PROXY_FUNC_OPEN 0x176
+#undef MC_CMD_0x176_PRIVILEGE_CTG
+
+#define MC_CMD_0x176_PRIVILEGE_CTG SRIOV_CTG_ADMIN
+
+/* MC_CMD_DESC_PROXY_FUNC_OPEN_IN msgrequest */
+#define    MC_CMD_DESC_PROXY_FUNC_OPEN_IN_LEN 40
+/* User-defined label (zero-terminated ASCII string) to uniquely identify the
+ * function
+ */
+#define       MC_CMD_DESC_PROXY_FUNC_OPEN_IN_LABEL_OFST 0
+#define       MC_CMD_DESC_PROXY_FUNC_OPEN_IN_LABEL_LEN 40
+
+/* MC_CMD_DESC_PROXY_FUNC_OPEN_OUT msgresponse */
+#define    MC_CMD_DESC_PROXY_FUNC_OPEN_OUT_LENMIN 40
+#define    MC_CMD_DESC_PROXY_FUNC_OPEN_OUT_LENMAX 252
+#define    MC_CMD_DESC_PROXY_FUNC_OPEN_OUT_LENMAX_MCDI2 1020
+#define    MC_CMD_DESC_PROXY_FUNC_OPEN_OUT_LEN(num) (40+1*(num))
+#define    MC_CMD_DESC_PROXY_FUNC_OPEN_OUT_CONFIG_NUM(len) (((len)-40)/1)
+/* Handle to the descriptor proxy function */
+#define       MC_CMD_DESC_PROXY_FUNC_OPEN_OUT_HANDLE_OFST 0
+#define       MC_CMD_DESC_PROXY_FUNC_OPEN_OUT_HANDLE_LEN 4
+/* PCIe Function ID (as struct PCIE_FUNCTION) */
+#define       MC_CMD_DESC_PROXY_FUNC_OPEN_OUT_FUNC_OFST 4
+#define       MC_CMD_DESC_PROXY_FUNC_OPEN_OUT_FUNC_LEN 8
+#define       MC_CMD_DESC_PROXY_FUNC_OPEN_OUT_FUNC_LO_OFST 4
+#define       MC_CMD_DESC_PROXY_FUNC_OPEN_OUT_FUNC_HI_OFST 8
+/* Function personality */
+#define       MC_CMD_DESC_PROXY_FUNC_OPEN_OUT_PERSONALITY_OFST 12
+#define       MC_CMD_DESC_PROXY_FUNC_OPEN_OUT_PERSONALITY_LEN 4
+/*            Enum values, see field(s): */
+/*               FUNCTION_PERSONALITY/ID */
+/* Function configuration state */
+#define       MC_CMD_DESC_PROXY_FUNC_OPEN_OUT_CONFIG_STATUS_OFST 16
+#define       MC_CMD_DESC_PROXY_FUNC_OPEN_OUT_CONFIG_STATUS_LEN 4
+/* enum: Function configuration is visible to the host (live) */
+#define          MC_CMD_DESC_PROXY_FUNC_OPEN_OUT_LIVE 0x0
+/* enum: Function configuration is pending reset */
+#define          MC_CMD_DESC_PROXY_FUNC_OPEN_OUT_PENDING 0x1
+/* Generation count to be delivered in an event once the configuration becomes
+ * live (if status is "pending")
+ */
+#define       MC_CMD_DESC_PROXY_FUNC_OPEN_OUT_CONFIG_GENERATION_OFST 20
+#define       MC_CMD_DESC_PROXY_FUNC_OPEN_OUT_CONFIG_GENERATION_LEN 4
+/* Reserved for future extension, set to zero. */
+#define       MC_CMD_DESC_PROXY_FUNC_OPEN_OUT_RESERVED_OFST 24
+#define       MC_CMD_DESC_PROXY_FUNC_OPEN_OUT_RESERVED_LEN 16
+/* Configuration data corresponding to function personality. Currently, only
+ * supported format is VIRTIO_BLK_CONFIG
+ */
+#define       MC_CMD_DESC_PROXY_FUNC_OPEN_OUT_CONFIG_OFST 40
+#define       MC_CMD_DESC_PROXY_FUNC_OPEN_OUT_CONFIG_LEN 1
+#define       MC_CMD_DESC_PROXY_FUNC_OPEN_OUT_CONFIG_MINNUM 0
+#define       MC_CMD_DESC_PROXY_FUNC_OPEN_OUT_CONFIG_MAXNUM 212
+#define       MC_CMD_DESC_PROXY_FUNC_OPEN_OUT_CONFIG_MAXNUM_MCDI2 980
+
+
+/***********************************/
+/* MC_CMD_DESC_PROXY_FUNC_CLOSE
+ * Releases a handle for an open descriptor proxy function. If proxying was
+ * enabled on the device, the caller is expected to gracefully stop it using
+ * MC_CMD_DESC_PROXY_FUNC_DISABLE prior to calling this function. Closing an
+ * active device without disabling proxying will result in forced close, which
+ * will put the device into a failed state and signal the host driver of the
+ * error (for virtio, DEVICE_NEEDS_RESET flag would be set on the host side)
+ */
+#define MC_CMD_DESC_PROXY_FUNC_CLOSE 0x1a1
+#undef MC_CMD_0x1a1_PRIVILEGE_CTG
+
+#define MC_CMD_0x1a1_PRIVILEGE_CTG SRIOV_CTG_ADMIN
+
+/* MC_CMD_DESC_PROXY_FUNC_CLOSE_IN msgrequest */
+#define    MC_CMD_DESC_PROXY_FUNC_CLOSE_IN_LEN 4
+/* Handle to the descriptor proxy function */
+#define       MC_CMD_DESC_PROXY_FUNC_CLOSE_IN_HANDLE_OFST 0
+#define       MC_CMD_DESC_PROXY_FUNC_CLOSE_IN_HANDLE_LEN 4
+
+/* MC_CMD_DESC_PROXY_FUNC_CLOSE_OUT msgresponse */
+#define    MC_CMD_DESC_PROXY_FUNC_CLOSE_OUT_LEN 0
+
+/* DESC_PROXY_FUNC_MAP structuredef */
+#define    DESC_PROXY_FUNC_MAP_LEN 52
+/* PCIe function ID (as struct PCIE_FUNCTION) */
+#define       DESC_PROXY_FUNC_MAP_FUNC_OFST 0
+#define       DESC_PROXY_FUNC_MAP_FUNC_LEN 8
+#define       DESC_PROXY_FUNC_MAP_FUNC_LO_OFST 0
+#define       DESC_PROXY_FUNC_MAP_FUNC_HI_OFST 4
+#define       DESC_PROXY_FUNC_MAP_FUNC_LBN 0
+#define       DESC_PROXY_FUNC_MAP_FUNC_WIDTH 64
+/* Function personality */
+#define       DESC_PROXY_FUNC_MAP_PERSONALITY_OFST 8
+#define       DESC_PROXY_FUNC_MAP_PERSONALITY_LEN 4
+/*            Enum values, see field(s): */
+/*               FUNCTION_PERSONALITY/ID */
+#define       DESC_PROXY_FUNC_MAP_PERSONALITY_LBN 64
+#define       DESC_PROXY_FUNC_MAP_PERSONALITY_WIDTH 32
+/* User-defined label (zero-terminated ASCII string) to uniquely identify the
+ * function
+ */
+#define       DESC_PROXY_FUNC_MAP_LABEL_OFST 12
+#define       DESC_PROXY_FUNC_MAP_LABEL_LEN 40
+#define       DESC_PROXY_FUNC_MAP_LABEL_LBN 96
+#define       DESC_PROXY_FUNC_MAP_LABEL_WIDTH 320
+
+
+/***********************************/
+/* MC_CMD_DESC_PROXY_FUNC_ENUM
+ * Enumerate existing descriptor proxy functions
+ */
+#define MC_CMD_DESC_PROXY_FUNC_ENUM 0x177
+#undef MC_CMD_0x177_PRIVILEGE_CTG
+
+#define MC_CMD_0x177_PRIVILEGE_CTG SRIOV_CTG_ADMIN
+
+/* MC_CMD_DESC_PROXY_FUNC_ENUM_IN msgrequest */
+#define    MC_CMD_DESC_PROXY_FUNC_ENUM_IN_LEN 4
+/* Starting index, set to 0 on first request. See
+ * MC_CMD_DESC_PROXY_FUNC_ENUM_OUT/FLAGS.
+ */
+#define       MC_CMD_DESC_PROXY_FUNC_ENUM_IN_START_IDX_OFST 0
+#define       MC_CMD_DESC_PROXY_FUNC_ENUM_IN_START_IDX_LEN 4
+
+/* MC_CMD_DESC_PROXY_FUNC_ENUM_OUT msgresponse */
+#define    MC_CMD_DESC_PROXY_FUNC_ENUM_OUT_LENMIN 4
+#define    MC_CMD_DESC_PROXY_FUNC_ENUM_OUT_LENMAX 212
+#define    MC_CMD_DESC_PROXY_FUNC_ENUM_OUT_LENMAX_MCDI2 992
+#define    MC_CMD_DESC_PROXY_FUNC_ENUM_OUT_LEN(num) (4+52*(num))
+#define    MC_CMD_DESC_PROXY_FUNC_ENUM_OUT_FUNC_MAP_NUM(len) (((len)-4)/52)
+#define       MC_CMD_DESC_PROXY_FUNC_ENUM_OUT_FLAGS_OFST 0
+#define       MC_CMD_DESC_PROXY_FUNC_ENUM_OUT_FLAGS_LEN 4
+#define        MC_CMD_DESC_PROXY_FUNC_ENUM_OUT_MORE_DATA_OFST 0
+#define        MC_CMD_DESC_PROXY_FUNC_ENUM_OUT_MORE_DATA_LBN 0
+#define        MC_CMD_DESC_PROXY_FUNC_ENUM_OUT_MORE_DATA_WIDTH 1
+/* Function map, as array of DESC_PROXY_FUNC_MAP */
+#define       MC_CMD_DESC_PROXY_FUNC_ENUM_OUT_FUNC_MAP_OFST 4
+#define       MC_CMD_DESC_PROXY_FUNC_ENUM_OUT_FUNC_MAP_LEN 52
+#define       MC_CMD_DESC_PROXY_FUNC_ENUM_OUT_FUNC_MAP_MINNUM 0
+#define       MC_CMD_DESC_PROXY_FUNC_ENUM_OUT_FUNC_MAP_MAXNUM 4
+#define       MC_CMD_DESC_PROXY_FUNC_ENUM_OUT_FUNC_MAP_MAXNUM_MCDI2 19
+
+
+/***********************************/
+/* MC_CMD_DESC_PROXY_FUNC_ENABLE
+ * Enable descriptor proxying for function into target event queue. Returns VI
+ * allocation info for the proxy source function, so that the caller can map
+ * absolute VI IDs from descriptor proxy events back to the originating
+ * function.
+ */
+#define MC_CMD_DESC_PROXY_FUNC_ENABLE 0x178
+#undef MC_CMD_0x178_PRIVILEGE_CTG
+
+#define MC_CMD_0x178_PRIVILEGE_CTG SRIOV_CTG_ADMIN
+
+/* MC_CMD_DESC_PROXY_FUNC_ENABLE_IN msgrequest */
+#define    MC_CMD_DESC_PROXY_FUNC_ENABLE_IN_LEN 8
+/* Handle to descriptor proxy function (as returned by
+ * MC_CMD_DESC_PROXY_FUNC_OPEN)
+ */
+#define       MC_CMD_DESC_PROXY_FUNC_ENABLE_IN_HANDLE_OFST 0
+#define       MC_CMD_DESC_PROXY_FUNC_ENABLE_IN_HANDLE_LEN 4
+/* Descriptor proxy sink queue (caller function relative). Must be extended
+ * width event queue
+ */
+#define       MC_CMD_DESC_PROXY_FUNC_ENABLE_IN_TARGET_EVQ_OFST 4
+#define       MC_CMD_DESC_PROXY_FUNC_ENABLE_IN_TARGET_EVQ_LEN 4
+
+/* MC_CMD_DESC_PROXY_FUNC_ENABLE_OUT msgresponse */
+#define    MC_CMD_DESC_PROXY_FUNC_ENABLE_OUT_LEN 8
+/* The number of VIs allocated on the function */
+#define       MC_CMD_DESC_PROXY_FUNC_ENABLE_OUT_VI_COUNT_OFST 0
+#define       MC_CMD_DESC_PROXY_FUNC_ENABLE_OUT_VI_COUNT_LEN 4
+/* The base absolute VI number allocated to the function. */
+#define       MC_CMD_DESC_PROXY_FUNC_ENABLE_OUT_VI_BASE_OFST 4
+#define       MC_CMD_DESC_PROXY_FUNC_ENABLE_OUT_VI_BASE_LEN 4
+
+
+/***********************************/
+/* MC_CMD_DESC_PROXY_FUNC_DISABLE
+ * Disable descriptor proxying for function
+ */
+#define MC_CMD_DESC_PROXY_FUNC_DISABLE 0x179
+#undef MC_CMD_0x179_PRIVILEGE_CTG
+
+#define MC_CMD_0x179_PRIVILEGE_CTG SRIOV_CTG_ADMIN
+
+/* MC_CMD_DESC_PROXY_FUNC_DISABLE_IN msgrequest */
+#define    MC_CMD_DESC_PROXY_FUNC_DISABLE_IN_LEN 4
+/* Handle to descriptor proxy function (as returned by
+ * MC_CMD_DESC_PROXY_FUNC_OPEN)
+ */
+#define       MC_CMD_DESC_PROXY_FUNC_DISABLE_IN_HANDLE_OFST 0
+#define       MC_CMD_DESC_PROXY_FUNC_DISABLE_IN_HANDLE_LEN 4
+
+/* MC_CMD_DESC_PROXY_FUNC_DISABLE_OUT msgresponse */
+#define    MC_CMD_DESC_PROXY_FUNC_DISABLE_OUT_LEN 0
+
+
+/***********************************/
+/* MC_CMD_GET_ADDR_SPC_ID
+ * Get Address space identifier for use in mem2mem descriptors for a given
+ * target. See SF-120734-TC for details on ADDR_SPC_IDs and mem2mem
+ * descriptors.
+ */
+#define MC_CMD_GET_ADDR_SPC_ID 0x1a0
+#undef MC_CMD_0x1a0_PRIVILEGE_CTG
+
+#define MC_CMD_0x1a0_PRIVILEGE_CTG SRIOV_CTG_ADMIN
+
+/* MC_CMD_GET_ADDR_SPC_ID_IN msgrequest */
+#define    MC_CMD_GET_ADDR_SPC_ID_IN_LEN 16
+/* Resource type to get ADDR_SPC_ID for */
+#define       MC_CMD_GET_ADDR_SPC_ID_IN_TYPE_OFST 0
+#define       MC_CMD_GET_ADDR_SPC_ID_IN_TYPE_LEN 4
+/* enum: Address space ID for host/AP memory DMA over the same interface this
+ * MCDI was called on
+ */
+#define          MC_CMD_GET_ADDR_SPC_ID_IN_SELF 0x0
+/* enum: Address space ID for host/AP memory DMA via PCI interface and function
+ * specified by FUNC
+ */
+#define          MC_CMD_GET_ADDR_SPC_ID_IN_PCI_FUNC 0x1
+/* enum: Address space ID for host/AP memory DMA via PCI interface and function
+ * specified by FUNC with PASID value specified by PASID
+ */
+#define          MC_CMD_GET_ADDR_SPC_ID_IN_PCI_FUNC_PASID 0x2
+/* enum: Address space ID for host/AP memory DMA via PCI interface and function
+ * specified by FUNC with PASID value of relative VI specified by VI
+ */
+#define          MC_CMD_GET_ADDR_SPC_ID_IN_REL_VI 0x3
+/* enum: Address space ID for host/AP memory DMA via PCI interface, function
+ * and PASID value of absolute VI specified by VI
+ */
+#define          MC_CMD_GET_ADDR_SPC_ID_IN_ABS_VI 0x4
+/* enum: Address space ID for host memory DMA via PCI interface and function of
+ * descriptor proxy function specified by HANDLE
+ */
+#define          MC_CMD_GET_ADDR_SPC_ID_IN_DESC_PROXY_HANDLE 0x5
+/* enum: Address space ID for DMA to/from MC memory */
+#define          MC_CMD_GET_ADDR_SPC_ID_IN_MC_MEM 0x6
+/* enum: Address space ID for DMA to/from other SmartNIC memory (on-chip, DDR)
+ */
+#define          MC_CMD_GET_ADDR_SPC_ID_IN_NIC_MEM 0x7
+/* PCIe Function ID (as struct PCIE_FUNCTION). Only valid if TYPE is PCI_FUNC,
+ * PCI_FUNC_PASID or REL_VI.
+ */
+#define       MC_CMD_GET_ADDR_SPC_ID_IN_FUNC_OFST 4
+#define       MC_CMD_GET_ADDR_SPC_ID_IN_FUNC_LEN 8
+#define       MC_CMD_GET_ADDR_SPC_ID_IN_FUNC_LO_OFST 4
+#define       MC_CMD_GET_ADDR_SPC_ID_IN_FUNC_HI_OFST 8
+/* PASID value. Only valid if TYPE is PCI_FUNC_PASID. */
+#define       MC_CMD_GET_ADDR_SPC_ID_IN_PASID_OFST 12
+#define       MC_CMD_GET_ADDR_SPC_ID_IN_PASID_LEN 4
+/* Relative or absolute VI number. Only valid if TYPE is REL_VI or ABS_VI */
+#define       MC_CMD_GET_ADDR_SPC_ID_IN_VI_OFST 12
+#define       MC_CMD_GET_ADDR_SPC_ID_IN_VI_LEN 4
+/* Descriptor proxy function handle. Only valid if TYPE is DESC_PROXY_HANDLE.
+ */
+#define       MC_CMD_GET_ADDR_SPC_ID_IN_HANDLE_OFST 4
+#define       MC_CMD_GET_ADDR_SPC_ID_IN_HANDLE_LEN 4
+
+/* MC_CMD_GET_ADDR_SPC_ID_OUT msgresponse */
+#define    MC_CMD_GET_ADDR_SPC_ID_OUT_LEN 8
+/* Address Space ID for the requested target. Only the lower 36 bits are valid
+ * in the current SmartNIC implementation.
+ */
+#define       MC_CMD_GET_ADDR_SPC_ID_OUT_ADDR_SPC_ID_OFST 0
+#define       MC_CMD_GET_ADDR_SPC_ID_OUT_ADDR_SPC_ID_LEN 8
+#define       MC_CMD_GET_ADDR_SPC_ID_OUT_ADDR_SPC_ID_LO_OFST 0
+#define       MC_CMD_GET_ADDR_SPC_ID_OUT_ADDR_SPC_ID_HI_OFST 4
+
+
 #endif /* MCDI_PCOL_H */

