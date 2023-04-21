Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6B86EB56D
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 01:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233731AbjDUXCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 19:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233784AbjDUXCa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 19:02:30 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 091092710;
        Fri, 21 Apr 2023 16:02:25 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next 14/20] ipvs: Correct spelling in comments
Date:   Sat, 22 Apr 2023 01:02:05 +0200
Message-Id: <20230421230211.214635-15-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230421230211.214635-1-pablo@netfilter.org>
References: <20230421230211.214635-1-pablo@netfilter.org>
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

From: Simon Horman <horms@kernel.org>

Correct some spelling errors flagged by codespell and found by inspection.

Signed-off-by: Simon Horman <horms@kernel.org>
Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/ip_vs.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index a3adc246ee31..ff406ef4fd4a 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -584,7 +584,7 @@ struct ip_vs_conn {
 	spinlock_t              lock;           /* lock for state transition */
 	volatile __u16          state;          /* state info */
 	volatile __u16          old_state;      /* old state, to be used for
-						 * state transition triggerd
+						 * state transition triggered
 						 * synchronization
 						 */
 	__u32			fwmark;		/* Fire wall mark from skb */
@@ -635,7 +635,7 @@ struct ip_vs_service_user_kern {
 	u16			protocol;
 	union nf_inet_addr	addr;		/* virtual ip address */
 	__be16			port;
-	u32			fwmark;		/* firwall mark of service */
+	u32			fwmark;		/* firewall mark of service */
 
 	/* virtual service options */
 	char			*sched_name;
@@ -1036,7 +1036,7 @@ struct netns_ipvs {
 	struct ipvs_sync_daemon_cfg	bcfg;	/* Backup Configuration */
 	/* net name space ptr */
 	struct net		*net;            /* Needed by timer routines */
-	/* Number of heterogeneous destinations, needed becaus heterogeneous
+	/* Number of heterogeneous destinations, needed because heterogeneous
 	 * are not supported when synchronization is enabled.
 	 */
 	unsigned int		mixed_address_family_dests;
-- 
2.30.2

