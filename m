Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 053F056BDDE
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 18:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238252AbiGHPW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 11:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237631AbiGHPW6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 11:22:58 -0400
Received: from smtpbg.qq.com (biz-43-154-54-12.mail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3416A72EDB;
        Fri,  8 Jul 2022 08:22:54 -0700 (PDT)
X-QQ-mid: bizesmtp66t1657293744tscsuizl
Received: from localhost.localdomain ( [182.148.15.249])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Fri, 08 Jul 2022 23:22:22 +0800 (CST)
X-QQ-SSF: 01000000002000B0C000B00A0000000
X-QQ-FEAT: ZHw8t61CvCHMAMPtAtbrBFuZ0WRYes5hobwX9e1IGMf/Om6Zyzkd5MNGEFuNW
        ZbidcFmM6MjQ/pt0LSWbASuSyHjpamxg1H1Zkcgirh4Eus6qt8hCT90W8/s7bCm1fHkBq/8
        Kw6SuUAnWD/EHUeaZcUeJ5m1vyHagGDGfYktYFVXJpcqPA4I29739IE3JaDCSbcZ9LN2tiQ
        XBvYtqpvyG30b1wx1pwZ7/kzeM0rb35eIgzE3BZiKifVwVRaVne3TB46Lzfi25dsJKaCw1g
        ycALaqZam3J0X63szr/oPiqDXBQUHdWcfoCmpmCVQsYe91iiEvNMaYyivWuN0K9EK9VmgDR
        DUqtrSY1XYbDMhKrhqtChphUYcX4quuoQgTPUIV+b8uhRE73bs=
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] net/ipa: fix repeated words in comments
Date:   Fri,  8 Jul 2022 23:22:15 +0800
Message-Id: <20220708152215.57295-1-yuanjilin@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr4
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,RDNS_DYNAMIC,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 Delete the redundant word 'the'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/ipa/gsi_trans.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/gsi_trans.c b/drivers/net/ipa/gsi_trans.c
index 55f8fe7d2668..5c6874d25548 100644
--- a/drivers/net/ipa/gsi_trans.c
+++ b/drivers/net/ipa/gsi_trans.c
@@ -351,7 +351,7 @@ struct gsi_trans *gsi_channel_trans_alloc(struct gsi *gsi, u32 channel_id,
 	if (!gsi_trans_tre_reserve(trans_info, tre_count))
 		return NULL;
 
-	/* Allocate and initialize non-zero fields in the the transaction */
+	/* Allocate and initialize non-zero fields in the transaction */
 	trans = gsi_trans_pool_alloc(&trans_info->pool, 1);
 	trans->gsi = gsi;
 	trans->channel_id = channel_id;
@@ -685,7 +685,7 @@ int gsi_trans_read_byte(struct gsi *gsi, u32 channel_id, dma_addr_t addr)
 	if (!gsi_trans_tre_reserve(trans_info, 1))
 		return -EBUSY;
 
-	/* Now fill the the reserved TRE and tell the hardware */
+	/* Now fill the reserved TRE and tell the hardware */
 
 	dest_tre = gsi_ring_virt(ring, ring->index);
 	gsi_trans_tre_fill(dest_tre, addr, 1, true, false, IPA_CMD_NONE);
-- 
2.36.1

