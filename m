Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 215D74D3C3A
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 22:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237129AbiCIVja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 16:39:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238421AbiCIVjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 16:39:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D83C9F541A
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 13:38:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AF8C61B0D
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 21:38:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14E20C36AE2;
        Wed,  9 Mar 2022 21:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646861892;
        bh=r3ci2m1KBoIIZZ0C4iRIHiZTzWgrpM2/f/PhtkwIqhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YmkLy1oK2aiU4YYsJ1iETO6T3M+9AC/GlfiRRMHlnd3gWj950HIRqbBo5tNYJGnuD
         VP6wzEo/XCZKniWK/0EMyJTRQ22NhdtzKHCgSziVImoiJQCIv5dBbadaLzF2gshGvp
         S3iJTtrV2OmUgotpEH3sFzSQMzrX4kXegfOM+bmNiYY3P/Aap6c2FbnrPnpyflsoNo
         /1E/cwbqynkNc6tGCaQP3i/ayihr4VWrixLTBKiTXuxFvhQFbXSHlxwolYu1ZXj5F2
         oz9sFWWxQ99gQnsUDJgn2RIoyaLyEZqjdkzFVxLKOVObqsUFv3pTuu+CAkCHOQks6M
         7MiQ5EB+R65mw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 12/16] net/mlx5: DR, Remove unneeded comments
Date:   Wed,  9 Mar 2022 13:37:51 -0800
Message-Id: <20220309213755.610202-13-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309213755.610202-1-saeed@kernel.org>
References: <20220309213755.610202-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Remove two comments that were erroneously left in the code.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
index d248a428f872..0326ab67c978 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
@@ -1079,8 +1079,8 @@ static void dr_ste_v1_build_eth_l2_src_or_dst_bit_mask(struct mlx5dr_match_param
 	DR_STE_SET_TAG(eth_l2_src_v1, bit_mask, first_vlan_id, mask, first_vid);
 	DR_STE_SET_TAG(eth_l2_src_v1, bit_mask, first_cfi, mask, first_cfi);
 	DR_STE_SET_TAG(eth_l2_src_v1, bit_mask, first_priority, mask, first_prio);
-	DR_STE_SET_TAG(eth_l2_src_v1, bit_mask, ip_fragmented, mask, frag); // ?
-	DR_STE_SET_TAG(eth_l2_src_v1, bit_mask, l3_ethertype, mask, ethertype); // ?
+	DR_STE_SET_TAG(eth_l2_src_v1, bit_mask, ip_fragmented, mask, frag);
+	DR_STE_SET_TAG(eth_l2_src_v1, bit_mask, l3_ethertype, mask, ethertype);
 	DR_STE_SET_ONES(eth_l2_src_v1, bit_mask, l3_type, mask, ip_version);
 
 	if (mask->svlan_tag || mask->cvlan_tag) {
-- 
2.35.1

