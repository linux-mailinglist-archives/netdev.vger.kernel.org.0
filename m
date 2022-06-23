Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 453BB557694
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 11:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbiFWJ12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 05:27:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230461AbiFWJ1V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 05:27:21 -0400
Received: from mail.nfschina.com (unknown [IPv6:2400:dd01:100f:2:72e2:84ff:fe10:5f45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A740743AE2;
        Thu, 23 Jun 2022 02:27:20 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 646EC1E80D05;
        Thu, 23 Jun 2022 17:27:01 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id xuDYrVjpIURz; Thu, 23 Jun 2022 17:26:58 +0800 (CST)
Received: from localhost.localdomain (unknown [112.64.61.33])
        (Authenticated sender: jiaming@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 3D8CE1E80CCC;
        Thu, 23 Jun 2022 17:26:58 +0800 (CST)
From:   Zhang Jiaming <jiaming@nfschina.com>
To:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        liqiong@nfschina.com, renyu@nfschina.com,
        Zhang Jiaming <jiaming@nfschina.com>
Subject: [PATCH] esp6: Fix spelling mistake
Date:   Thu, 23 Jun 2022 17:27:12 +0800
Message-Id: <20220623092712.12696-1-jiaming@nfschina.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change 'accomodate' to 'accommodate'.

Signed-off-by: Zhang Jiaming <jiaming@nfschina.com>
---
 net/ipv6/esp6.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index 36e1d0f8dd06..8220923a12f7 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -343,7 +343,7 @@ static struct ip_esp_hdr *esp_output_set_esn(struct sk_buff *skb,
 					     struct esp_output_extra *extra)
 {
 	/* For ESN we move the header forward by 4 bytes to
-	 * accomodate the high bits.  We will move it back after
+	 * accommodate the high bits.  We will move it back after
 	 * encryption.
 	 */
 	if ((x->props.flags & XFRM_STATE_ESN)) {
@@ -896,7 +896,7 @@ static void esp_input_set_header(struct sk_buff *skb, __be32 *seqhi)
 	struct xfrm_state *x = xfrm_input_state(skb);
 
 	/* For ESN we move the header forward by 4 bytes to
-	 * accomodate the high bits.  We will move it back after
+	 * accommodate the high bits.  We will move it back after
 	 * decryption.
 	 */
 	if ((x->props.flags & XFRM_STATE_ESN)) {
-- 
2.25.1

