Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9334961E569
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 19:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbiKFS4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 13:56:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbiKFS4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 13:56:50 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88CE3E0CC;
        Sun,  6 Nov 2022 10:56:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 06F43CE0E13;
        Sun,  6 Nov 2022 18:56:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DA91C433D6;
        Sun,  6 Nov 2022 18:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667761006;
        bh=XcaDx53ZZHUc0l8ILKX5RE1+LHLJaPD85TpWG4xZmSE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j6IzSq3k0h5KjSirg/QJ8lx6E8Apm+NQX1Doljh7fIZYFotY2ymGtw+EJyRSqw5af
         8sMP+xaZUHm3uCnPffidyUOPMYOTLhb6sQ0tvyBko/ZUNIXYT8F4FMxTHjQEB/3GD5
         VPs4rvvDitbDYaj0DDpptcRXk/03xHbrgWCePFILnKGto864G4qKMssz1iOTb912za
         fn2ouqiN74KaDOpPNmDEFXXXXkZoCUdMPTF2ICrrlXjcH7B9/McQDXC0tafpfft0qR
         sCfkTP/GaAgM9Ya1+bvJ9AAqtsGNtB1BZL159zPrfyeRm7M/MW+KqbaPIcV0cQLdYa
         laPBcOUceGQlA==
Date:   Sun, 6 Nov 2022 20:56:41 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     zhang.songyi@zte.com.cn
Cc:     saeedm@nvidia.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, kliteyn@nvidia.com,
        shunh@nvidia.com, rongweil@nvidia.com, valex@nvidia.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, jiang.xuexin@zte.com.cn,
        xue.zhihong@zte.com.cn
Subject: Re: [PATCH linux-next] net/mlx5: remove redundant ret variable
Message-ID: <Y2gDaRc3t7WiWoTT@unreal>
References: <202211022150403300510@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202211022150403300510@zte.com.cn>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 02, 2022 at 09:50:40PM +0800, zhang.songyi@zte.com.cn wrote:
> From 74562e313cf9a1b96c7030f27964f826a0c2572d Mon Sep 17 00:00:00 2001
> From: zhang songyi <zhang.songyi@zte.com.cn>
> Date: Wed, 2 Nov 2022 20:48:08 +0800
> Subject: [PATCH linux-next] net/mlx5: remove redundant ret variable

Subject line should be "[PATCH net-next] ..." for all net patches.
And please use git send-email utility to send the patches.

Thanks

> 
> Return value from mlx5dr_send_postsend_action() directly instead of taking
> this in another redundant variable.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: zhang songyi <zhang.songyi@zte.com.cn>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
> index a4476cb4c3b3..fd2d31cdbcf9 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
> @@ -724,7 +724,6 @@ int mlx5dr_send_postsend_action(struct mlx5dr_domain *dmn,
>                 struct mlx5dr_action *action)
>  {
>     struct postsend_info send_info = {};
> -   int ret;
> 
>     send_info.write.addr = (uintptr_t)action->rewrite->data;
>     send_info.write.length = action->rewrite->num_of_actions *
> @@ -734,9 +733,7 @@ int mlx5dr_send_postsend_action(struct mlx5dr_domain *dmn,
>         mlx5dr_icm_pool_get_chunk_mr_addr(action->rewrite->chunk);
>     send_info.rkey = mlx5dr_icm_pool_get_chunk_rkey(action->rewrite->chunk);
> 
> -   ret = dr_postsend_icm_data(dmn, &send_info);
> -
> -   return ret;
> +   return dr_postsend_icm_data(dmn, &send_info);
>  }
> 
>  static int dr_modify_qp_rst2init(struct mlx5_core_dev *mdev,
> --
> 2.15.2
