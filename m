Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8025B8CFE
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 18:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiINQ3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 12:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiINQ2S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 12:28:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E500844EA
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 09:27:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FC26619A5
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 16:27:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 202DFC433C1;
        Wed, 14 Sep 2022 16:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663172853;
        bh=g8F41O8qds/2t2nbQUaJJ9tNTSGWBY+JVi0T4PfGJe0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mVKbwcCWDW8LSzxoKD/lDAH+1Agzm4W+IgT9VMwU3pKhL7wgHzIq+/IMZ6szu275h
         w5YpPb2yXqJOFFu/iaDDijhML6OmFsY71iVjZGT926hvT7rKSYJ9aHwNeKWyYB+rnI
         pAVBx00rgoft1peJppvkNYyt24CQZ2sDbQuIoCz7vlZ6pYIk1dxuzjrbrOFvykllNV
         rsjJTJy8jPNVhDq6H+ushpYjpCbQrJoCSBeuHPGoQfLkb++SF5irXNpAFtrJrHDl8j
         G1OBb5JgcVFHewun8pokEAXR93IEen7aiZXTR1cfQ/Lv22SE3JT92sEOLJzzsZGJM7
         Vf3YnoNycrKJg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next V2 02/10] net/mlx5: Fix fields name prefix in MACsec
Date:   Wed, 14 Sep 2022 17:27:05 +0100
Message-Id: <20220914162713.203571-3-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220914162713.203571-1-saeed@kernel.org>
References: <20220914162713.203571-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

