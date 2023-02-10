Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A52386929FB
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 23:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233485AbjBJWTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 17:19:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233848AbjBJWS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 17:18:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B4B7E8F7
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 14:18:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8115AB825E3
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 22:18:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F05DC4339B;
        Fri, 10 Feb 2023 22:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676067515;
        bh=7p/VweGh+T1n2WHN8cJ7s+Mik8FE7dMxf3Sj7E6W++I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YP+vnrADsjsSucFlZ+pAfPmBo7R/8TAo91iuSu1XLoLnRRtfl7X6ktBpWNiaafKNT
         2zuRiTAHo+gzEnBJYSgOVfDlJnJmXQS+/gOkVaFu32jtpT6P9kyeO6qN9cwwfk2dDA
         zoQFrJbL/SUGorMqm9hHsMw7UAugEs4whK5jLZOJxqtcmKa3BgNBCRYyK2yr6dcfpq
         z4WanENt3drf8HIEILPtLlSZ3SArILFtHv4Olz2kiJJYAShsIdnB+RHrlQFol6a0XZ
         R1+WKv8ePjGp8BS5Ku9+Qrf/MDst7fWz8VfqcuJTqfztK1XEcZnNmwSbhj02xkQKBs
         Hve5FVYKZya2w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>
Subject: [net-next 07/15] net/mlx5e: TC, Remove redundant parse_attr argument
Date:   Fri, 10 Feb 2023 14:18:13 -0800
Message-Id: <20230210221821.271571-8-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230210221821.271571-1-saeed@kernel.org>
References: <20230210221821.271571-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

The parse_attr argument is not being used in
actions_match_supported_fdb(). remove it.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 780b2aa2ace1..7c714f4059c9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3650,7 +3650,6 @@ static bool modify_header_match_supported(struct mlx5e_priv *priv,
 
 static bool
 actions_match_supported_fdb(struct mlx5e_priv *priv,
-			    struct mlx5e_tc_flow_parse_attr *parse_attr,
 			    struct mlx5e_tc_flow *flow,
 			    struct netlink_ext_ack *extack)
 {
@@ -3699,7 +3698,7 @@ actions_match_supported(struct mlx5e_priv *priv,
 		return false;
 
 	if (mlx5e_is_eswitch_flow(flow) &&
-	    !actions_match_supported_fdb(priv, parse_attr, flow, extack))
+	    !actions_match_supported_fdb(priv, flow, extack))
 		return false;
 
 	return true;
-- 
2.39.1

