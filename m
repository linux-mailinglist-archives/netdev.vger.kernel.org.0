Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0739C58E293
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 00:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbiHIWGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 18:06:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbiHIWFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 18:05:47 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C4D93DFC6;
        Tue,  9 Aug 2022 15:05:44 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 5/8] netfilter: ip6t_LOG: Fix a typo in a comment
Date:   Wed, 10 Aug 2022 00:05:29 +0200
Message-Id: <20220809220532.130240-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220809220532.130240-1-pablo@netfilter.org>
References: <20220809220532.130240-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

s/_IPT_LOG_H/_IP6T_LOG_H/

While at it add some surrounding space to ease reading.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter_ipv6/ip6t_LOG.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter_ipv6/ip6t_LOG.h b/include/uapi/linux/netfilter_ipv6/ip6t_LOG.h
index 23e91a9c2583..0b7b16dbdec2 100644
--- a/include/uapi/linux/netfilter_ipv6/ip6t_LOG.h
+++ b/include/uapi/linux/netfilter_ipv6/ip6t_LOG.h
@@ -17,4 +17,4 @@ struct ip6t_log_info {
 	char prefix[30];
 };
 
-#endif /*_IPT_LOG_H*/
+#endif /* _IP6T_LOG_H */
-- 
2.30.2

