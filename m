Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B35B56BC0E
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 17:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238435AbiGHOzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 10:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237623AbiGHOzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 10:55:11 -0400
Received: from smtpbg.qq.com (unknown [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D272DA84;
        Fri,  8 Jul 2022 07:55:01 -0700 (PDT)
X-QQ-mid: bizesmtp78t1657292055t0bkdp6x
Received: from localhost.localdomain ( [182.148.15.249])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Fri, 08 Jul 2022 22:53:23 +0800 (CST)
X-QQ-SSF: 01000000002000B0C000B00A0000000
X-QQ-FEAT: pi5xsqT0CkQabcklx8t3nrcNlPS4BmpcwzP5drei+BR5GC85R8nLknIOV0rmS
        6Iqhhz4Yf6c/pXmTPZRuKPUyzohl6VmfYEnMV4W/BvvWK6zk8kG8avGdj/2WA5dNTeIKOar
        oDpqQS8ws612+ycucAWgJ6USI5F6Si+txUinPXJ2lCLEDA6/rNLxa8rrWTOnp04aHdDDHUl
        x98wvwzcDrFJ+YKdtfMPADgY/vwGAkXhinrJjMhBIMyRh8L2dHSpqCSiFWtE29Nrgkmfkbo
        t8GTybgZeJtKNJuVjkayPACjBvh6jzd+1pmba01DsOusgjIA/Pr0PKoe8Ju85Rauh2AdQrr
        vAQLgikwLF/a1H2nDKufDjvyLFJe059tpY64L6W
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     romieu@fr.zoreil.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] ethernet/via: fix repeated words in comments
Date:   Fri,  8 Jul 2022 22:53:04 +0800
Message-Id: <20220708145304.31102-1-yuanjilin@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr4
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 Delete the redundant word 'driver'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/ethernet/via/via-velocity.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/via/via-velocity.h b/drivers/net/ethernet/via/via-velocity.h
index c02a9654dce6..ffdac6fac054 100644
--- a/drivers/net/ethernet/via/via-velocity.h
+++ b/drivers/net/ethernet/via/via-velocity.h
@@ -938,7 +938,7 @@ enum  velocity_owner {
 #define IMR_MASK_VALUE      0x0013FB0FUL	/* initial value of IMR
 						   ignore MIBFI,RACEI to
 						   reduce intr. frequency
-						   NOTE.... do not enable NoBuf int mask at driver driver
+						   NOTE.... do not enable NoBuf int mask at driver
 						      when (1) NoBuf -> RxThreshold = SF
 							   (2) OK    -> RxThreshold = original value
 						 */
-- 
2.36.1

