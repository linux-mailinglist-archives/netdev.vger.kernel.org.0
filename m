Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53FE66DC54B
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 11:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbjDJJnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 05:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjDJJnP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 05:43:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC035B83;
        Mon, 10 Apr 2023 02:43:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A2BF61177;
        Mon, 10 Apr 2023 09:43:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58761C433D2;
        Mon, 10 Apr 2023 09:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681119783;
        bh=GyhEHiJkt5kFXmysrQx6eDNO7cufe6HICtq92px6MeM=;
        h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
        b=Az92kMDCAdZ5WOIQezcZ+vMZPLHWfFLWAF+4sghjjvFAheF6E6n6LeaZM7Xs6d9Dk
         8ZWWL7eiIBVaHfwEAAvn5+H/blnYBvMwCFSE97o8f3ZNN1VVxm5XlmY3bpUU/aO/j2
         26mf7jvoW2sRmSsUYRL2YoAsHMFpJMnwHJ5zFoJYavei+5vVHr8PUPdHNrztAo0HIJ
         VWpPbQj6RvcpGJye5mDJxBw+Yr7yUyMujHvkjc6+yvCjanIjsi6jK0ngxm6xphQSoM
         ZXgfnANejbNqWDIVHP9QTjykeu5BeF2AkiOR5I+U1yZf9axtxEF3gyJ72XELJ1lS6N
         ZKijXrkUmB3yQ==
From:   Simon Horman <horms@kernel.org>
Date:   Mon, 10 Apr 2023 11:42:38 +0200
Subject: [PATCH nf-next 4/4] ipvs: Correct spelling in comments
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230409-ipvs-cleanup-v1-4-98cdc242feb0@kernel.org>
References: <20230409-ipvs-cleanup-v1-0-98cdc242feb0@kernel.org>
In-Reply-To: <20230409-ipvs-cleanup-v1-0-98cdc242feb0@kernel.org>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, lvs-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Correct some spelling errors flagged by codespell and found by inspection.

Signed-off-by: Simon Horman <horms@kernel.org>
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

