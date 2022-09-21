Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 573E95DAC35
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 20:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbiIUSLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 14:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbiIUSLF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 14:11:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1410B5302B
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 11:11:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D92CB83275
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 18:11:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1666CC433B5;
        Wed, 21 Sep 2022 18:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663783861;
        bh=g8F41O8qds/2t2nbQUaJJ9tNTSGWBY+JVi0T4PfGJe0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UfgEz8+Oo/WbnxjRzQnOcMtS/F8PtmxLQsHgYuWI6exyx+NTM5NqEDNtjz2wg/31o
         SbkFe4hE9BLrpyXbp5an7H1ET7yLw/O3EwyikTtvpWcKQ7aevUGlFUzAfqRv5v8usQ
         0jPrcuWEhR1tbE4xX1pcqPvfBZmyIRCK6VdqpLQs39K5QuUD1hD1FeXaElPpP/24O3
         o7lfw6awVENqygrhvWTNnBwm6AqnDSgXaHVKN/YjsynQ/Z8KkgU02L6LdNrtlf4Dbn
         NjOsiZCC5StRbH45dYgUNS3Cz21RrqpdADiy+u0mPYqWX8C0mDlD61MFohqT9VEhyP
         51y0NH5bQs14A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next V3 02/10] net/mlx5: Fix fields name prefix in MACsec
Date:   Wed, 21 Sep 2022 11:10:46 -0700
Message-Id: <20220921181054.40249-3-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921181054.40249-1-saeed@kernel.org>
References: <20220921181054.40249-1-saeed@kernel.org>
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

From: Emeel Hakim <ehakim@nvidia.com>

Fix ifc fields name to be consistent with the device spec document.

Fixes: 8385c51ff5bc ("net/mlx5: Introduce MACsec Connect-X offload hardware bits and structures")
Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 8decbf9a7bdd..da0ed11fcebd 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -11585,15 +11585,15 @@ struct mlx5_ifc_macsec_offload_obj_bits {
 
 	u8    confidentiality_en[0x1];
 	u8    reserved_at_41[0x1];
-	u8    esn_en[0x1];
-	u8    esn_overlap[0x1];
+	u8    epn_en[0x1];
+	u8    epn_overlap[0x1];
 	u8    reserved_at_44[0x2];
 	u8    confidentiality_offset[0x2];
 	u8    reserved_at_48[0x4];
 	u8    aso_return_reg[0x4];
 	u8    reserved_at_50[0x10];
 
-	u8    esn_msb[0x20];
+	u8    epn_msb[0x20];
 
 	u8    reserved_at_80[0x8];
 	u8    dekn[0x18];
-- 
2.37.3

