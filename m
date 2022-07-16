Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC5E579FE3
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 15:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238763AbiGSNl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 09:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238571AbiGSNlg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 09:41:36 -0400
Received: from smtpbg.qq.com (unknown [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AE2526AF4;
        Tue, 19 Jul 2022 05:55:22 -0700 (PDT)
X-QQ-mid: bizesmtp86t1658234867t6uaq9bf
Received: from localhost.localdomain ( [171.223.96.21])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 19 Jul 2022 20:47:45 +0800 (CST)
X-QQ-SSF: 01000000002000F0U000C00A0000020
X-QQ-FEAT: DoD8xN2rKowR1K2YM4LBgEIAehxjQQLjdS1F1k4Tyn4AJPsybMR/RW9e3MIQX
        hrqoV79v49JKT++J1hPdUIxatetbwmfqzNrwXU7cqCwC6psQsafwXnwrFMY/c8l9VB/hzlI
        3A168olSV8ITLJ79G8ljiiYExO29Zp96A2mn5+EeT/gfFp6g1CE18997aT52W6UDGr3Vs4l
        Z6dw8JDQ2UGwkzQF1ZYlb0fAy5qynlcUV5lHJfaVjP235e9r7kc5Sd624K3+/GbvviomckM
        U0/xH0OfTtgzsHRYb5ijWe91p0N9hcPEL7h2N1OyBcBWCdEhGqrz0Yeag5WVg7gduGL3jUX
        wiB9Tlli4hYkvQD3s3Z6CA5SvwYi9QEg7k9QAd3vclHPqcyAstBNQYQic8Uogq+usqBFSGS
        gyVoIzUIwlw=
X-QQ-GoodBg: 0
From:   Jason Wang <wangborong@cdjrlc.com>
To:     davem@davemloft.net
Cc:     sgarzare@redhat.com, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Wang <wangborong@cdjrlc.com>
Subject: [PATCH] vsock/vmci: Fix comment typo
Date:   Sat, 16 Jul 2022 12:45:49 +0800
Message-Id: <20220716044549.44057-1-wangborong@cdjrlc.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr6
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,SPF_PASS,
        T_SPF_HELO_TEMPERROR autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The double `that' is duplicated in the comment, remove one.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
---
 net/vmw_vsock/vmci_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
index b14f0ed7427b..842c94286d31 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -951,7 +951,7 @@ static int vmci_transport_recv_listen(struct sock *sk,
 	 * for ourself or any previous connection requests that we received.
 	 * If it's the latter, we try to find a socket in our list of pending
 	 * connections and, if we do, call the appropriate handler for the
-	 * state that that socket is in.  Otherwise we try to service the
+	 * state that socket is in.  Otherwise we try to service the
 	 * connection request.
 	 */
 	pending = vmci_transport_get_pending(sk, pkt);
-- 
2.35.1

