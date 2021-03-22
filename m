Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFA4F344A0C
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 17:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231544AbhCVQAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 12:00:30 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:38233 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230338AbhCVP7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 11:59:46 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id CADC35C01D6;
        Mon, 22 Mar 2021 11:59:45 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 22 Mar 2021 11:59:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=PVWP1eQfPxAvNT1aYQ829XILpb73AevIqQFjOW1AVh4=; b=omlteiIu
        CjKf7711mxUo8XnpazJb9FAsKChzotErHdtYI/w+3UC2s/EvKqQP+L6ZxgDLGPBP
        yDXvHvPI38eZ/zKDIg1aW5YMfC1HvlUOkH1r3ma9I/lUZ7DOiUQfCIVkYZluYk6k
        kOSTd6TDCmN0EXmz2Vzg/O7h9m7B/kUDos5EHiozJaLCeAKEZR5dRwheQ2zXDvgS
        9sSFSDQD/2ydVDKuohm/GEDk4DRtK3FaaDLe0UVJTDwVxHlHacfv4epmrpF6Rjao
        YAMd+twenb7z8xgwfmHqxju8n1XxKwvhKXAyu5IeRkCJXtQeJd3+i12Wg1qfIXbz
        aPai59ucYiHECA==
X-ME-Sender: <xms:8b5YYF7MN_bqxheVxa5yB9NFmPh6xStFL3MRA09ndDZqhRL5xNyDSg>
    <xme:8b5YYC6U_Cl_kIdb5tgCKaEwNwn1rqQFhNAb6PpOUVM-GNb8c7SRi_YStZTSchtXL
    _4qVYdHzqkF1cs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeggedgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:8b5YYMfDdEO5AfoZLi2trGQPWz5bhwWr4NH7GI7rSTlFr6XWQtzRxw>
    <xmx:8b5YYOKR8_KAWwGaXqij7ThvQI4Tqs2nAvb1GuqyEHPkfWcfQX-u1A>
    <xmx:8b5YYJLtYfsaP1Bn3uAN5tJr3UfL--DCKSTQh-LF5ab0LSUZGFq95Q>
    <xmx:8b5YYGGY9ftNAF_BD6xsIpKn-XmPpOpLXGYfNuEpEgqttiHJ7S4siQ>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id EF5E11080057;
        Mon, 22 Mar 2021 11:59:43 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 04/14] mlxsw: spectrum_router: Adjust comments on nexthop fields
Date:   Mon, 22 Mar 2021 17:58:45 +0200
Message-Id: <20210322155855.3164151-5-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210322155855.3164151-1-idosch@idosch.org>
References: <20210322155855.3164151-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The comments assume that nexthops are simple Ethernet nexthops
that are programmed to forward packets to the associated neighbour. This
is no longer the case, as both IPinIP and blackhole nexthops are now
supported.

Adjust the comments to reflect these changes.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c    | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index b7358cf611c1..bdf519b569b6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -2862,14 +2862,14 @@ struct mlxsw_sp_nexthop {
 	int norm_nh_weight;
 	int num_adj_entries;
 	struct mlxsw_sp_rif *rif;
-	u8 should_offload:1, /* set indicates this neigh is connected and
-			      * should be put to KVD linear area of this group.
+	u8 should_offload:1, /* set indicates this nexthop should be written
+			      * to the adjacency table.
 			      */
-	   offloaded:1, /* set in case the neigh is actually put into
-			 * KVD linear area of this group.
+	   offloaded:1, /* set indicates this nexthop was written to the
+			 * adjacency table.
 			 */
-	   update:1, /* set indicates that MAC of this neigh should be
-		      * updated in HW
+	   update:1, /* set indicates this nexthop should be updated in the
+		      * adjacency table (f.e., its MAC changed).
 		      */
 	   discard:1; /* nexthop is programmed to discard packets */
 	enum mlxsw_sp_nexthop_type type;
-- 
2.29.2

