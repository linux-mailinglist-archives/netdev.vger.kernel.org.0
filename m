Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B89E2B1F95
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbgKMQHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:07:09 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:38221 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726969AbgKMQHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 11:07:05 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 309D45C01A5;
        Fri, 13 Nov 2020 11:07:04 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 13 Nov 2020 11:07:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=4v/8fXNSFWj8rrXsbZks3s0BOYd5apceI0bzYzKcJCE=; b=VNRizCik
        ZXDtrNqIah6F1iDSmctk1cRpg9arFP8kYisHeKcIUP4coEp+63y3/c40M4a0kpOI
        rfxXxOUN5jNCpMnZwqfwazujYUsEKJK0ZWgWekTGstF+HByjNWkBw4REEcmxllx7
        r/yEWC9KblCQgtv/hZppZ5gb8ZEtnAiLzPafSJQ5f7QijM370iYen/+SkYhOTHxC
        1Xi6MTZlabAemQnehjw0f/rDTDDBwtcHfVVTE+6OLh7Rng+UoBSZpJDdgqtuEXxn
        r45tfbcLxXybDD9Q/aSiGfHs//YG76RiAEUPj+Put+G1b4uDeji8CAW4rPymGO4s
        1ImRSqu1DQeDDg==
X-ME-Sender: <xms:KK-uX3XSiid6wT-nrDReRbSnllbzC4ULJ6FdugAj8a3DPQAcJJxuDg>
    <xme:KK-uX_nVAlEtNsKrojPRwXQTDh9BIATfB_BLMKVv3GhygT3Xn_DYAOAmRfHvgtBWW
    TNmeLq8nO98zBc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddvhedgkeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehgedrudeg
    jeenucevlhhushhtvghrufhiiigvpeduvdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:KK-uXzYpXzFcNv2kuMfbZPCfGYHaPBpvq7KtRtNrmRukIogdHH9x2g>
    <xmx:KK-uXyV8NptTemFKAZ-dZODMC2mnIlCvnpD7iqkCARGx2LRSxQAv0g>
    <xmx:KK-uXxneG87UNnO1E0mojU9RcWUt7j95AMy8yBg8bHs0afeChm5TNA>
    <xmx:KK-uX3jQQQycntY5CPb9jknv0GjzSkaikjAfP14vudU76YdtqsA-dQ>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 259FD3280059;
        Fri, 13 Nov 2020 11:07:01 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 15/15] mlxsw: spectrum_router: Remove outdated comment
Date:   Fri, 13 Nov 2020 18:05:59 +0200
Message-Id: <20201113160559.22148-16-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201113160559.22148-1-idosch@idosch.org>
References: <20201113160559.22148-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Since commit 21151f64a458 ("mlxsw: Add new FIB entry type for reject
routes") this comment is no longer correct. Remove it.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index ca9f7d06eab1..a2e81ad5790f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -5621,12 +5621,6 @@ static void mlxsw_sp_fib6_entry_type_set(struct mlxsw_sp *mlxsw_sp,
 					 struct mlxsw_sp_fib_entry *fib_entry,
 					 const struct fib6_info *rt)
 {
-	/* Packets hitting RTF_REJECT routes need to be discarded by the
-	 * stack. We can rely on their destination device not having a
-	 * RIF (it's the loopback device) and can thus use action type
-	 * local, which will cause them to be trapped with a lower
-	 * priority than packets that need to be locally received.
-	 */
 	if (rt->fib6_flags & (RTF_LOCAL | RTF_ANYCAST))
 		fib_entry->type = MLXSW_SP_FIB_ENTRY_TYPE_TRAP;
 	else if (rt->fib6_type == RTN_BLACKHOLE)
-- 
2.28.0

