Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C51D579FAB
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 15:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236118AbiGSNbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 09:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236202AbiGSN24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 09:28:56 -0400
Received: from smtpbg.qq.com (biz-43-154-54-12.mail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7363F3B;
        Tue, 19 Jul 2022 05:45:10 -0700 (PDT)
X-QQ-mid: bizesmtp87t1658234618tow9aldu
Received: from localhost.localdomain ( [171.223.96.21])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 19 Jul 2022 20:43:36 +0800 (CST)
X-QQ-SSF: 01000000002000F0U000C00A0000020
X-QQ-FEAT: DoD8xN2rKozQC/kjGZt735i/xZHRjUYTGwuqaur9oE6jomqBMNjqvkBQ7sNPD
        y5C4OKaeQ5UvEGQlxWShEut3pfCk+bKPAa65GNpdKEMiAUgli1hmFKWCphVFXBMEMZNk3Oz
        GiMFskcamGoTKVL4HfX+HhnxUx4xeP8Ku3zmxSzFwTfwHurG/6KN+Vzrh/v5K0j6vMubz6Z
        CQ00stvh/dJ3tNEBiCy9dp4bWv6zUNeyaTW01Ucy77cmeC10WYhzIxA5R8UsMHEhp9m37md
        tl1do1NDC6TF5riPf/MAlSdTlaUwDQT6byxY7w1BzM/CM18CjYIn82R0C5LgofHJoHqynxm
        c5e8VwVRsZEJ5kGBZ/YGULrUd/Yxa1xAi+A2SoGcjHPUAKZS2xtrLXRMuMU8/HAjT3Kc4jQ
        H2isXTaajBY=
X-QQ-GoodBg: 0
From:   Jason Wang <wangborong@cdjrlc.com>
To:     edumazet@google.com
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Wang <wangborong@cdjrlc.com>
Subject: [PATCH] net: llc: Fix comment typo
Date:   Sat, 16 Jul 2022 12:41:39 +0800
Message-Id: <20220716044139.43330-1-wangborong@cdjrlc.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr6
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,RDNS_DYNAMIC,
        SPF_PASS,T_SPF_HELO_TEMPERROR autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The double `all' is duplicated in the comment, remove one.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
---
 net/llc/llc_conn.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/llc/llc_conn.c b/net/llc/llc_conn.c
index 912aa9bd5e29..ce5d154c94f5 100644
--- a/net/llc/llc_conn.c
+++ b/net/llc/llc_conn.c
@@ -198,7 +198,7 @@ void llc_conn_rtn_pdu(struct sock *sk, struct sk_buff *skb)
 }
 
 /**
- *	llc_conn_resend_i_pdu_as_cmd - resend all all unacknowledged I PDUs
+ *	llc_conn_resend_i_pdu_as_cmd - resend all unacknowledged I PDUs
  *	@sk: active connection
  *	@nr: NR
  *	@first_p_bit: p_bit value of first pdu
-- 
2.35.1

