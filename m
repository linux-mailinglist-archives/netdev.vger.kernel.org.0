Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1DE84BAC36
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 23:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343762AbiBQWDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 17:03:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343757AbiBQWDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 17:03:18 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B21AF606EA
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 14:03:03 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id p23so6176942pgj.2
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 14:03:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xgM661NLrkQQIxwVuW6GOr66Aj7/zlrjSXJDGhsTVQw=;
        b=g1TwXHavscXYPjk9WGovrma7Tu+IUwwoEP22XqPT980krCLMyNg5Xr7h1vZKuA+ar+
         v5qjg/cofBVpjLu7NDuJSeuRt74ls0v7RVLWcgODWjNcsuJEv1mnJQxKnYuXpwxsbg0u
         4SwDQPeuzexBN63wDr82RlQ0TRuSV2zpNv5nqvJILCMiiVBfwMZocx2YMrRF3bRI9h4Q
         TH0SZSheLy2NgbWWrCjH7LIBaWJE3Wr25aJux4BLybrgBLKqzCevvDBpPUyoPX0+S0ve
         zR9xtnlzppxrDt0uXPNqOdDXN8xG0IEhRbd8pIn/bwkHKh9zfKAKPxMI9LrrTo9nvban
         EpOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xgM661NLrkQQIxwVuW6GOr66Aj7/zlrjSXJDGhsTVQw=;
        b=c0jDZph8HgTyPMUuIkRTlL9+WDG5kTxSeIc34tm9DaBNZa2EbeSTnXv6wp4O6kVqST
         6Idqx9Oh9rQAKs7CuSXPcDcBKMfxJZOzjmxMMQ2KmBSwRp9yJARshVJdYksWPRdFHq/n
         gfQ0YXa4HF3yBTM9N9PidU97G8bPDVMBaDV1oW+BHRG1+nL8yrS0+OkBB9kAawX5bcD8
         Y8WXNMs22NrMBZKoZbAP5z6STXNlQeRqOfizpc1z+fsT2k1QARTxRevomqo0U/IJv1RR
         KTQ0YGA3L7S3lx9iYr4nkN1HwfGHq5PYTwk0chXDSI2cLoW1b8bIOvUzefQkOUsHXW7O
         ODIQ==
X-Gm-Message-State: AOAM532ggEExY05ye9nwlUxWWf5Zm6JELBjNdvFolFMu8GQ0F3qmmQ1F
        8SIOKGeB0OtblKjzMHi+pBQNbBSs2OU98g==
X-Google-Smtp-Source: ABdhPJwysRtY62Dw0oi+8bcui26rNaxl5bWcAYpMfPwSv/WfQFVn2BE2+Os9/lQEdnBl+cJejqCVkw==
X-Received: by 2002:a05:6a00:2387:b0:4e0:5414:da5c with SMTP id f7-20020a056a00238700b004e05414da5cmr4953014pfc.85.1645135383238;
        Thu, 17 Feb 2022 14:03:03 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id 16sm516119pfm.200.2022.02.17.14.03.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 14:03:02 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 4/4] ionic: clean up comments and whitespace
Date:   Thu, 17 Feb 2022 14:02:52 -0800
Message-Id: <20220217220252.52293-5-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220217220252.52293-1-snelson@pensando.io>
References: <20220217220252.52293-1-snelson@pensando.io>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix up some checkpatch complaints that have crept in:
doubled words words, mispellled words, doubled lines.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_if.h    | 6 +++---
 drivers/net/ethernet/pensando/ionic/ionic_stats.c | 1 -
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c  | 1 -
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_if.h b/drivers/net/ethernet/pensando/ionic/ionic_if.h
index 278610ed7227..4a90f611c611 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_if.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_if.h
@@ -759,7 +759,7 @@ enum ionic_txq_desc_opcode {
  *                   IONIC_TXQ_DESC_OPCODE_CSUM_HW:
  *                      Offload 16-bit checksum computation to hardware.
  *                      If @csum_l3 is set then the packet's L3 checksum is
- *                      updated. Similarly, if @csum_l4 is set the the L4
+ *                      updated. Similarly, if @csum_l4 is set the L4
  *                      checksum is updated. If @encap is set then encap header
  *                      checksums are also updated.
  *
@@ -1368,9 +1368,9 @@ union ionic_port_config {
  * @status:             link status (enum ionic_port_oper_status)
  * @id:                 port id
  * @speed:              link speed (in Mbps)
- * @link_down_count:    number of times link went from from up to down
+ * @link_down_count:    number of times link went from up to down
  * @fec_type:           fec type (enum ionic_port_fec_type)
- * @xcvr:               tranceiver status
+ * @xcvr:               transceiver status
  */
 struct ionic_port_status {
 	__le32 id;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_stats.c b/drivers/net/ethernet/pensando/ionic/ionic_stats.c
index fd6806b4a1b9..9859a4432985 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_stats.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_stats.c
@@ -151,7 +151,6 @@ static const struct ionic_stat_desc ionic_rx_stats_desc[] = {
 	IONIC_RX_STAT_DESC(vlan_stripped),
 };
 
-
 #define IONIC_NUM_LIF_STATS ARRAY_SIZE(ionic_lif_stats_desc)
 #define IONIC_NUM_PORT_STATS ARRAY_SIZE(ionic_port_stats_desc)
 #define IONIC_NUM_TX_STATS ARRAY_SIZE(ionic_tx_stats_desc)
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index d197a70a49c9..f54035455ad6 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -10,7 +10,6 @@
 #include "ionic_lif.h"
 #include "ionic_txrx.h"
 
-
 static inline void ionic_txq_post(struct ionic_queue *q, bool ring_dbell,
 				  ionic_desc_cb cb_func, void *cb_arg)
 {
-- 
2.17.1

