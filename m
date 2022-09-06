Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85A055ADEEB
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 07:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232774AbiIFFVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 01:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232672AbiIFFVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 01:21:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F24B6CF7E
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 22:21:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4622161296
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 05:21:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9662FC433D6;
        Tue,  6 Sep 2022 05:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662441702;
        bh=K3X8hQghhNMg1oLtrx27pUOr1lEiEB+YbtJ1sj/FnSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O4DbU4aoVXdCAIdz/2GiQl38UKWjwQWP3NogPcvrP4xfpK1yVMwkmTgIycHJpjRjm
         HrQfb/n4z1b/Kp9mKHH3K5QVDp0TrVm0t7mPa9BjU1rXFVjPxARA5cOruiDrNrhCRD
         dLyavv/UCA4Cv0SISt4AHNK7HiWDIfn8jXiSfpi3vzFOVzYK7sjPD0mQCU5Bn5kHaS
         l6zlLj+atsMKzEFf0JKDgTMUQl6V6BkJ9PJyDs054vCUm2oQMfsHMNtRzY6kd1ngE2
         q94xhvvjwlNjPbYtU6E01sO7Ky2Ko9mT6TX5ckSXpTgtk/zAnFP28wHXPD9Dcrc3oH
         /FrVej2RkSLng==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Lior Nahmanson <liorna@nvidia.com>
Subject: [PATCH net-next V2 04/17] net/mlx5: Removed esp_id from struct mlx5_flow_act
Date:   Mon,  5 Sep 2022 22:21:16 -0700
Message-Id: <20220906052129.104507-5-saeed@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220906052129.104507-1-saeed@kernel.org>
References: <20220906052129.104507-1-saeed@kernel.org>
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

From: Lior Nahmanson <liorna@nvidia.com>

esp_id is no longer in used

Signed-off-by: Lior Nahmanson <liorna@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/fs.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index 8e73c377da2c..920cbc9524ad 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -245,7 +245,6 @@ struct mlx5_flow_act {
 	struct mlx5_pkt_reformat *pkt_reformat;
 	union {
 		u32 ipsec_obj_id;
-		uintptr_t esp_id;
 	};
 	u32 flags;
 	struct mlx5_fs_vlan vlan[MLX5_FS_VLAN_DEPTH];
-- 
2.37.2

