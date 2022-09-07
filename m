Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF605AFAEE
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 06:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiIGECJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 00:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbiIGECH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 00:02:07 -0400
Received: from bg4.exmail.qq.com (bg4.exmail.qq.com [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D9E13F0A;
        Tue,  6 Sep 2022 21:02:05 -0700 (PDT)
X-QQ-mid: bizesmtp91t1662523300th8gw99j
Received: from localhost.localdomain ( [182.148.14.0])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 07 Sep 2022 12:01:39 +0800 (CST)
X-QQ-SSF: 01000000000000D0F000000A0000000
X-QQ-FEAT: E6I1Azoq+XoZrCGr77r6YSeX1adgXL4aKbV1yyQww2j+L1jWz0XU8/nvLQJQ0
        5s/+oqJDrShF7CPjgbVWLn1p5Ww6R3tH94JF6/OlRcwCWvzJ7Csz0v/EFeLSH+1igQbzWmv
        qselOm8L+x36cgHzrGoQln0EZYi6U659jSIQEZHtdQD7oXDD6zLlGIFm+BEipGfs2XDAcJX
        KAkee0A6nDs0uUPVZxjnY7qAKz304/jtOl0ZVn5kE3giHrkrI9wHgWwYQvsHG+6cCflwY9t
        ArgUWwrsA/ZxrLJQK/orkqVs8tCY5qyfvmFovxUSiXpJ4QJ7Eb9aZcQj5cDltKWTVGacUAV
        BR4EMQwQdmt++aTxA8NMlL02unVBwn0vvrKs/0YjMxN5Mo9Oxc=
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     sgarzare@redhat.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] vsock/vmci: fix repeated words in comments
Date:   Wed,  7 Sep 2022 12:01:31 +0800
Message-Id: <20220907040131.52975-1-yuanjilin@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr4
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,RCVD_IN_PBL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete the redundant word 'that'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
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
2.36.1


