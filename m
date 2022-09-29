Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBE055EEEE2
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 09:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235240AbiI2HXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 03:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234996AbiI2HW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 03:22:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D99421162FF
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:22:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA18D61F88
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 07:22:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 048EBC433D6;
        Thu, 29 Sep 2022 07:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664436165;
        bh=7y4Pu/hyWN7nSfYePC3jmmPK7FdNtu11dehV1BidDdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dXXjz3Ko1DN1AT2QY+OJHlelPbrIuxsi8eVlEy1/QPh+rPjp4c8tjl2RgV4I7gQT9
         rC7UDtxBhYD4/F8Vh2QFUdEopLJF+21OpVSlo5xUgFz9p6JOvC9jt72kM7wmyerpxz
         0jXO5Gz2Ur8SRbixS5EkQRKHneb7B+AKcND8wuPbg9upPndIJYcNE+R6u4ROzblOGh
         NrhgH9h4/fOeYp9JZfF2y8YWej2j7HWyWrHbUoLbVJz4/HQVJv/8vCvQcXrh7huy1q
         Z91vW27gqdUy52vQyg5U09expovkoTZLrEnnuuTwJH3w9VvBoyf/GfRIEfzJFCJf+2
         o8F1Zdb6I0r3A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH net-next 07/16] xsk: Remove unused xsk_buff_discard
Date:   Thu, 29 Sep 2022 00:21:47 -0700
Message-Id: <20220929072156.93299-8-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220929072156.93299-1-saeed@kernel.org>
References: <20220929072156.93299-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

The previous commit removed the last usage of xsk_buff_discard in mlx5e,
so the function that is no longer used can be removed.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
CC: "Björn Töpel" <bjorn@kernel.org>
CC: Magnus Karlsson <magnus.karlsson@intel.com>
CC: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/net/xdp_sock_drv.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
index 6406faa3d57d..9c0d860609ba 100644
--- a/include/net/xdp_sock_drv.h
+++ b/include/net/xdp_sock_drv.h
@@ -107,13 +107,6 @@ static inline void xsk_buff_free(struct xdp_buff *xdp)
 	xp_free(xskb);
 }
 
-static inline void xsk_buff_discard(struct xdp_buff *xdp)
-{
-	struct xdp_buff_xsk *xskb = container_of(xdp, struct xdp_buff_xsk, xdp);
-
-	xp_release(xskb);
-}
-
 static inline void xsk_buff_set_size(struct xdp_buff *xdp, u32 size)
 {
 	xdp->data = xdp->data_hard_start + XDP_PACKET_HEADROOM;
-- 
2.37.3

