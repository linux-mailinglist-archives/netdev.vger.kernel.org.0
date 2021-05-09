Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 626FE377735
	for <lists+netdev@lfdr.de>; Sun,  9 May 2021 17:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbhEIPS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 May 2021 11:18:56 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:57117 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229742AbhEIPSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 May 2021 11:18:50 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 473595C00E8;
        Sun,  9 May 2021 11:17:47 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 09 May 2021 11:17:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=HnYM3YFDguEtJ9ledM3u2v9DjvwED9e+rWR6VVrgon4=; b=jSwCSdxz
        MZvmF1WALi+PH4Vzjf3WjTr1dVK/DmOXn1wKMY3ytHxdCfvucnbj6xFhdb+2vBlQ
        ZB79o3sz6lMZTrmCz0Zd6TMb3Z50dwisBiJpI5Ze+M8FB5vxbwYc4jynkWtNpItu
        IEBRrcF1p5q53uaXCAOdogz09RObBxwIHKAQZcnDWHC1Cy7UiYZRtVbXHTiKUf6h
        ECxm4EN6sZ2/XmxA+iphONlnLYujxLGQ4dVu6Eo2m3jiA/OEkhER9LDlydvtZWBR
        rTVPHDH8CY2Lh9GNMgvR24NSrXDnKulOJ06imhENoTFrhhc7LsOa59IxnrLa6p+O
        khhoV6h2SP3W4g==
X-ME-Sender: <xms:G_2XYOixNiNUv519goPSxAlHPiM6e5QVp-Kw7x1nMHPKImY5TKzRhw>
    <xme:G_2XYPBL9psYW2yViSZmOYuaTQUXdVSqjU1IiTywy77MLnXLJ949RWMEDnK3sJhF5
    gK38CgbaWC_YGU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegiedgkeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeduleefrdegjedrudeihedrvdeh
    udenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:G_2XYGFNuMiWRKdU2LArEMPVVySah5vsZlN4w_c7rJuLYUbSPe6z4A>
    <xmx:G_2XYHSETcQ7s2zhkeoT27rVRCjB0j5rRF85xVFCPKmBuwgRff-lYQ>
    <xmx:G_2XYLxhNSlEGRifcfJiW11zS4TC2GbJZ7s_E57_1YEWHYHUZ0thjQ>
    <xmx:G_2XYClh1Kakt1K_TAzxEAIRK2SfaXDfR9SD1_DkIOAl-pXxzTBQuA>
Received: from shredder.mellanox.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun,  9 May 2021 11:17:44 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        petrm@nvidia.com, roopa@nvidia.com, nikolay@nvidia.com,
        ssuryaextr@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next v2 04/10] ipv6: Use a more suitable label name
Date:   Sun,  9 May 2021 18:16:09 +0300
Message-Id: <20210509151615.200608-5-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210509151615.200608-1-idosch@idosch.org>
References: <20210509151615.200608-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The 'out_timer' label was added in commit 63152fc0de4d ("[NETNS][IPV6]
ip6_fib - gc timer per namespace") when the timer was allocated on the
heap.

Commit 417f28bb3407 ("netns: dont alloc ipv6 fib timer list") removed
the allocation, but kept the label name.

Rename it to a more suitable name.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv6/ip6_fib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 679699e953f1..33d2d6a4e28c 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -2362,7 +2362,7 @@ static int __net_init fib6_net_init(struct net *net)
 
 	net->ipv6.rt6_stats = kzalloc(sizeof(*net->ipv6.rt6_stats), GFP_KERNEL);
 	if (!net->ipv6.rt6_stats)
-		goto out_timer;
+		goto out_notifier;
 
 	/* Avoid false sharing : Use at least a full cache line */
 	size = max_t(size_t, size, L1_CACHE_BYTES);
@@ -2407,7 +2407,7 @@ static int __net_init fib6_net_init(struct net *net)
 	kfree(net->ipv6.fib_table_hash);
 out_rt6_stats:
 	kfree(net->ipv6.rt6_stats);
-out_timer:
+out_notifier:
 	fib6_notifier_exit(net);
 	return -ENOMEM;
 }
-- 
2.31.1

