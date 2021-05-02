Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67C58370DE9
	for <lists+netdev@lfdr.de>; Sun,  2 May 2021 18:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbhEBQZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 12:25:43 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:60007 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230110AbhEBQZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 12:25:42 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id D33CF5C011D;
        Sun,  2 May 2021 12:24:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sun, 02 May 2021 12:24:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=ITr0G8uhtUCwuwYSwWJ1AQ4TdX9N04JeQxH9SYTVO2w=; b=OlN4c5vN
        Qc4V5Oi1SdSPGtomuC5+ZWURsQppCe9P+RSmKWIfvlNuxjvTSdkbeqJOINcbewUP
        zg1tSo8rVGgqxNNQtyTSd17upN0nhJhqT3rRFEp30QQ5SCkax/uimu2uUN4U3feh
        Rk9JyyskPJGEVoyuYUWCVn5PLdfRmcSU3Bibf6CxTXByF8VjxdfqDDZwt1jsdQSo
        HPv0DLY0ELvVVkC4XSpl+ldvESdu8Qrbrw6srnO8WHpUij7QTIUB+LrkN4oCqhA5
        Yt1uaKh2n+SKnrL0DqN6XlWeGfbBx/iDJdIDqDzJrG0EKhC1OoHq19w09ZksA3IO
        8fwajdoAyc1QJg==
X-ME-Sender: <xms:UtKOYBVfSN9UmaPxypLEV9ZTFltZthuCI8LRkBVvyGpIhkUXb7nSGw>
    <xme:UtKOYBl2jzx-HoBx1Hz2L6MoEAV0KEbtDbshzcSzwL68R9Iy6exx6w-hz5x-BjbTM
    EkfKcH8nLNanLg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefvddgtdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeduleefrdegjedrudeihedrvdeh
    udenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:UtKOYNYWnDENSE0Ul1uDqWhrN65b-Tv0zcTAzzBq-PwUIbcBNSGZlg>
    <xmx:UtKOYEVpJULBHiXHoeTLkoPFU6Ve9-hmhwW6XClaL5Eol1bsvik2kg>
    <xmx:UtKOYLmUYeRNH5tg-L14pSsnhpdevOfrfyh7Apf3pEoLQ27a8ImpPQ>
    <xmx:UtKOYJazD-PygXHv2ehVLKoCz6FZjgkV92iBzOVqFHah8evK_P2riA>
Received: from shredder.mellanox.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun,  2 May 2021 12:24:48 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        petrm@nvidia.com, roopa@nvidia.com, nikolay@nvidia.com,
        ssuryaextr@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 04/10] ipv6: Use a more suitable label name
Date:   Sun,  2 May 2021 19:22:51 +0300
Message-Id: <20210502162257.3472453-5-idosch@idosch.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502162257.3472453-1-idosch@idosch.org>
References: <20210502162257.3472453-1-idosch@idosch.org>
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
2.30.2

