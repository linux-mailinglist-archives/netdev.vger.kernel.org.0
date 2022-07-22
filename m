Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4CD557DC89
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 10:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234746AbiGVIgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 04:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235066AbiGVIgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 04:36:08 -0400
Received: from mail-m974.mail.163.com (mail-m974.mail.163.com [123.126.97.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0F4C930F;
        Fri, 22 Jul 2022 01:36:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=gDnvx
        N3EUKuK0M9fJJMz6oVgcemRIUzoLMmBDl69xs4=; b=MvEiMlaZOJ7ub90d/jSjb
        q/isILIofYeOVoW3l7k4JOzKN1d2C11aqCGYkHWCwdjdG6jGXXpk6Yo79LORkahV
        veatotGNAQmtvwIXFjHbxqPoMPdmP9c7TaRYdIx/SgFFx54zTjMM6SfxHcxGCewa
        Y5ZU+zoQE82MLrQC5XztUY=
Received: from localhost.localdomain (unknown [112.97.59.29])
        by smtp4 (Coremail) with SMTP id HNxpCgCny8QmYdpinwd4QA--.6833S2;
        Fri, 22 Jul 2022 16:34:48 +0800 (CST)
From:   Slark Xiao <slark_xiao@163.com>
To:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, gregory.greenman@intel.com
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Slark Xiao <slark_xiao@163.com>
Subject: [PATCH] iwlwifi: Fix typo 'the the' in comment
Date:   Fri, 22 Jul 2022 16:34:44 +0800
Message-Id: <20220722083444.75126-1-slark_xiao@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: HNxpCgCny8QmYdpinwd4QA--.6833S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7ZFyDCw47CFy5ZrW8Cw4DJwb_yoW8ZF18pa
        yUuFZFgr15tan8Ka48ta1xCF98W3W5tw4qkFWDtwn8ZFs3Jw1Sqr129Fy5Gw10krW5J3Wa
        kF1jyF15AFn5trDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pEg4fNUUUUU=
X-Originating-IP: [112.97.59.29]
X-CM-SenderInfo: xvod2y5b0lt0i6rwjhhfrp/xtbBDQhGZFaEKBskOgAAsY
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace 'the the' with 'the' in the comment.

Signed-off-by: Slark Xiao <slark_xiao@163.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h    | 4 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

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
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
index a3cefbc43e80..abf8585bf3bd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
@@ -29,7 +29,7 @@ u8 iwl_mvm_get_channel_width(struct cfg80211_chan_def *chandef)
 
 /*
  * Maps the driver specific control channel position (relative to the center
- * freq) definitions to the the fw values
+ * freq) definitions to the fw values
  */
 u8 iwl_mvm_get_ctrl_pos(struct cfg80211_chan_def *chandef)
 {
-- 
2.25.1

