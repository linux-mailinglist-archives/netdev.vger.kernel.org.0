Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A184AF27D
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 23:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbfIJVL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 17:11:56 -0400
Received: from gateway31.websitewelcome.com ([192.185.143.39]:34407 "EHLO
        gateway31.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725770AbfIJVL4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 17:11:56 -0400
X-Greylist: delayed 1358 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Sep 2019 17:11:55 EDT
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway31.websitewelcome.com (Postfix) with ESMTP id 16F8E34A03
        for <netdev@vger.kernel.org>; Tue, 10 Sep 2019 15:49:17 -0500 (CDT)
Received: from gator3278.hostgator.com ([198.57.247.242])
        by cmsmtp with SMTP
        id 7n4eiKMlyiQer7n4eibFey; Tue, 10 Sep 2019 15:49:17 -0500
X-Authority-Reason: nr=8
Received: from 89-69-237-178.dynamic.chello.pl ([89.69.237.178]:39390 helo=comp.lan)
        by gator3278.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <arkadiusz@drabczyk.org>)
        id 1i7n4d-003thB-Sc; Tue, 10 Sep 2019 15:49:16 -0500
From:   Arkadiusz Drabczyk <arkadiusz@drabczyk.org>
To:     vishal@chelsio.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] cxgb4: Fix spelling typos
Date:   Tue, 10 Sep 2019 22:49:01 +0200
Message-Id: <20190910204901.11741-1-arkadiusz@drabczyk.org>
X-Mailer: git-send-email 2.9.0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator3278.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - drabczyk.org
X-BWhitelist: no
X-Source-IP: 89.69.237.178
X-Source-L: No
X-Exim-ID: 1i7n4d-003thB-Sc
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 89-69-237-178.dynamic.chello.pl (comp.lan) [89.69.237.178]:39390
X-Source-Auth: arkadiusz@drabczyk.org
X-Email-Count: 2
X-Source-Cap: cmt1bXZicmg7cmt1bXZicmg7Z2F0b3IzMjc4Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix several spelling typos in comments in t4_hw.c.

Signed-off-by: Arkadiusz Drabczyk <arkadiusz@drabczyk.org>
---
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index f7fc553..f2a7824 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -329,7 +329,7 @@ int t4_wr_mbox_meat_timeout(struct adapter *adap, int mbox, const void *cmd,
 	for (i = 0; ; i += ms) {
 		/* If we've waited too long, return a busy indication.  This
 		 * really ought to be based on our initial position in the
-		 * mailbox access list but this is a start.  We very rearely
+		 * mailbox access list but this is a start.  We very rarely
 		 * contend on access to the mailbox ...
 		 */
 		pcie_fw = t4_read_reg(adap, PCIE_FW_A);
@@ -606,7 +606,7 @@ void t4_memory_rw_residual(struct adapter *adap, u32 off, u32 addr, u8 *buf,
  *
  *	Reads/writes an [almost] arbitrary memory region in the firmware: the
  *	firmware memory address and host buffer must be aligned on 32-bit
- *	boudaries; the length may be arbitrary.  The memory is transferred as
+ *	boundaries; the length may be arbitrary.  The memory is transferred as
  *	a raw byte sequence from/to the firmware's memory.  If this memory
  *	contains data structures which contain multi-byte integers, it's the
  *	caller's responsibility to perform appropriate byte order conversions.
@@ -3774,7 +3774,7 @@ int t4_phy_fw_ver(struct adapter *adap, int *phy_fw_ver)
  *	A negative error number will be returned if an error occurs.  If
  *	version number support is available and there's no need to upgrade
  *	the firmware, 0 will be returned.  If firmware is successfully
- *	transferred to the adapter, 1 will be retured.
+ *	transferred to the adapter, 1 will be returned.
  *
  *	NOTE: some adapters only have local RAM to store the PHY firmware.  As
  *	a result, a RESET of the adapter would cause that RAM to lose its
@@ -3808,7 +3808,7 @@ int t4_load_phy_fw(struct adapter *adap,
 	}
 
 	/* Ask the firmware where it wants us to copy the PHY firmware image.
-	 * The size of the file requires a special version of the READ coommand
+	 * The size of the file requires a special version of the READ command
 	 * which will pass the file size via the values field in PARAMS_CMD and
 	 * retrieve the return value from firmware and place it in the same
 	 * buffer values
@@ -4082,7 +4082,7 @@ static inline fw_port_cap32_t cc_to_fwcap_pause(enum cc_pause cc_pause)
 		fw_pause |= FW_PORT_CAP32_FORCE_PAUSE;
 
 	/* Translate orthogonal Pause controls into IEEE 802.3 Pause,
-	 * Asymetrical Pause for use in reporting to upper layer OS code, etc.
+	 * Asymmetrical Pause for use in reporting to upper layer OS code, etc.
 	 * Note that these bits are ignored in L1 Configure commands.
 	 */
 	if (cc_pause & PAUSE_RX) {
@@ -4151,7 +4151,7 @@ fw_port_cap32_t t4_link_acaps(struct adapter *adapter, unsigned int port,
 	/* Convert Common Code Forward Error Control settings into the
 	 * Firmware's API.  If the current Requested FEC has "Automatic"
 	 * (IEEE 802.3) specified, then we use whatever the Firmware
-	 * sent us as part of it's IEEE 802.3-based interpratation of
+	 * sent us as part of its IEEE 802.3-based interpretation of
 	 * the Transceiver Module EPROM FEC parameters.  Otherwise we
 	 * use whatever is in the current Requested FEC settings.
 	 */
@@ -4248,7 +4248,7 @@ int t4_link_l1cfg_core(struct adapter *adapter, unsigned int mbox,
 
 	/* Unfortunately, even if the Requested Port Capabilities "fit" within
 	 * the Physical Port Capabilities, some combinations of features may
-	 * still not be leagal.  For example, 40Gb/s and Reed-Solomon Forward
+	 * still not be legal.  For example, 40Gb/s and Reed-Solomon Forward
 	 * Error Correction.  So if the Firmware rejects the L1 Configure
 	 * request, flag that here.
 	 */
@@ -6797,7 +6797,7 @@ int t4_sge_ctxt_flush(struct adapter *adap, unsigned int mbox, int ctxt_type)
 }
 
 /**
- *	t4_read_sge_dbqtimers - reag SGE Doorbell Queue Timer values
+ *	t4_read_sge_dbqtimers - read SGE Doorbell Queue Timer values
  *	@adap - the adapter
  *	@ndbqtimers: size of the provided SGE Doorbell Queue Timer table
  *	@dbqtimers: SGE Doorbell Queue Timer table
@@ -6925,8 +6925,8 @@ int t4_fw_hello(struct adapter *adap, unsigned int mbox, unsigned int evt_mbox,
 			waiting -= 50;
 
 			/*
-			 * If neither Error nor Initialialized are indicated
-			 * by the firmware keep waiting till we exaust our
+			 * If neither Error nor Initialized are indicated
+			 * by the firmware keep waiting till we exhaust our
 			 * timeout ... and then retry if we haven't exhausted
 			 * our retries ...
 			 */
@@ -7238,7 +7238,7 @@ int t4_fl_pkt_align(struct adapter *adap)
 	 * separately.  The actual Ingress Packet Data alignment boundary
 	 * within Packed Buffer Mode is the maximum of these two
 	 * specifications.  (Note that it makes no real practical sense to
-	 * have the Pading Boudary be larger than the Packing Boundary but you
+	 * have the Padding Boundary be larger than the Packing Boundary but you
 	 * could set the chip up that way and, in fact, legacy T4 code would
 	 * end doing this because it would initialize the Padding Boundary and
 	 * leave the Packing Boundary initialized to 0 (16 bytes).)
@@ -8973,10 +8973,10 @@ static int t4_get_flash_params(struct adapter *adap)
 			goto found;
 		}
 
-	/* Decode Flash part size.  The code below looks repetative with
+	/* Decode Flash part size.  The code below looks repetitive with
 	 * common encodings, but that's not guaranteed in the JEDEC
-	 * specification for the Read JADEC ID command.  The only thing that
-	 * we're guaranteed by the JADEC specification is where the
+	 * specification for the Read JEDEC ID command.  The only thing that
+	 * we're guaranteed by the JEDEC specification is where the
 	 * Manufacturer ID is in the returned result.  After that each
 	 * Manufacturer ~could~ encode things completely differently.
 	 * Note, all Flash parts must have 64KB sectors.
@@ -9317,7 +9317,7 @@ int t4_init_devlog_params(struct adapter *adap)
 	struct fw_devlog_cmd devlog_cmd;
 	int ret;
 
-	/* If we're dealing with newer firmware, the Device Log Paramerters
+	/* If we're dealing with newer firmware, the Device Log Parameters
 	 * are stored in a designated register which allows us to access the
 	 * Device Log even if we can't talk to the firmware.
 	 */
-- 
2.9.0

