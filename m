Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1CA15B51FD
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 01:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbiIKXli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 19:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiIKXlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 19:41:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8026275C0
        for <netdev@vger.kernel.org>; Sun, 11 Sep 2022 16:41:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3A6FB80AE9
        for <netdev@vger.kernel.org>; Sun, 11 Sep 2022 23:41:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17FD8C4347C;
        Sun, 11 Sep 2022 23:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662939686;
        bh=g8F41O8qds/2t2nbQUaJJ9tNTSGWBY+JVi0T4PfGJe0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RkMFZLEcSgflhOBhHVD5QSRUEEPzQOOeLDrC1+AEK+FiZH+wNjMmOlFj4tG42Rqin
         MrZthv+1oAsWN2PUHpIjObSAfHaDeF+ATKivzjtfyMqwxSoJVvpVicnJeXwo1msQWI
         0p8DkWxrgPaMU13tG9UOOLLXZAQV4EknUwEnhqeahSHc6u1dHRJsUsSV0cHQyYspWE
         r51gL4aYNTVSRlh4kABBWHa9UsTaFdGY9H2QQKf4eE+Rgdty5yFDgTRNMvKAcSzo9U
         BI4NhA4ifsYBQ5NNHABtH3ryZZ5CZUOIV2yn0nRm6rvtnJV57bW39KBCNaz1lR8FXp
         T2zRzng5cp/YQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next 02/10] net/mlx5: Fix fields name prefix in MACsec
Date:   Mon, 12 Sep 2022 00:40:51 +0100
Message-Id: <20220911234059.98624-3-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220911234059.98624-1-saeed@kernel.org>
References: <20220911234059.98624-1-saeed@kernel.org>
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

