Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A071C56CA13
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 16:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbiGIObZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 10:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiGIObV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 10:31:21 -0400
Received: from smtpbg.qq.com (unknown [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13AFD2AE13;
        Sat,  9 Jul 2022 07:31:13 -0700 (PDT)
X-QQ-Spam: true
X-QQ-mid: bizesmtp76t1657375436tuee7vo6
Received: from localhost.localdomain ( [182.148.15.109])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sat, 09 Jul 2022 22:03:53 +0800 (CST)
X-QQ-SSF: 01000000002000B0C000C00A0000000
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     gregory.greenman@intel.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        keescook@chromium.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] wifi: api: fix repeated words in comments
Date:   Sat,  9 Jul 2022 22:03:47 +0800
Message-Id: <20220709140347.52290-1-yuanjilin@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 Delete the redundant word 'the'.
 Delete the redundant word 'to'.
 Delete the redundant word 'be'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/power.h      | 2 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/time-event.h | 2 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h         | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/power.h b/drivers/net/wireless/intel/iwlwifi/fw/api/power.h
index f92cac1da764..d05a8e2fab30 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/power.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/power.h
@@ -575,7 +575,7 @@ struct iwl_sar_offset_mapping_cmd {
  *      regardless of whether its temerature has been changed.
  * @bf_enable_beacon_filter: 1, beacon filtering is enabled; 0, disabled.
  * @bf_debug_flag: beacon filtering debug configuration
- * @bf_escape_timer: Send beacons to to driver if no beacons were passed
+ * @bf_escape_timer: Send beacons to driver if no beacons were passed
  *      for a specific period of time. Units: Beacons.
  * @ba_escape_timer: Fully receive and parse beacon if no beacons were passed
  *      for a longer period of time then this escape-timeout. Units: Beacons.
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/time-event.h b/drivers/net/wireless/intel/iwlwifi/fw/api/time-event.h
index 904cd78a9fa0..019bf23ebffc 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/time-event.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/time-event.h
@@ -359,7 +359,7 @@ struct iwl_hs20_roc_res {
  *	listen mode. Will be fragmented. Valid only on the P2P Device MAC.
  *	Valid only on the P2P Device MAC. The firmware will take into account
  *	the duration, the interval and the repetition count.
- * @SESSION_PROTECT_CONF_P2P_GO_NEGOTIATION: Schedule the P2P Device to be be
+ * @SESSION_PROTECT_CONF_P2P_GO_NEGOTIATION: Schedule the P2P Device to be
  *	able to run the GO Negotiation. Will not be fragmented and not
  *	repetitive. Valid only on the P2P Device MAC. Only the duration will
  *	be taken into account.
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h b/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
index ecc6706f66ed..194de9545989 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
@@ -200,7 +200,7 @@ enum iwl_tx_offload_assist_bz {
  *	cleared. Combination of RATE_MCS_*
  * @sta_id: index of destination station in FW station table
  * @sec_ctl: security control, TX_CMD_SEC_*
- * @initial_rate_index: index into the the rate table for initial TX attempt.
+ * @initial_rate_index: index into the rate table for initial TX attempt.
  *	Applied if TX_CMD_FLG_STA_RATE_MSK is set, normally 0 for data frames.
  * @reserved2: reserved
  * @key: security key
@@ -858,7 +858,7 @@ struct iwl_extended_beacon_notif {
 
 /**
  * enum iwl_dump_control - dump (flush) control flags
- * @DUMP_TX_FIFO_FLUSH: Dump MSDUs until the the FIFO is empty
+ * @DUMP_TX_FIFO_FLUSH: Dump MSDUs until the FIFO is empty
  *	and the TFD queues are empty.
  */
 enum iwl_dump_control {
-- 
2.36.1

