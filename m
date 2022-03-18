Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9984E4DD8A5
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 12:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235569AbiCRLBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 07:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbiCRLBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 07:01:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BFC42D7AA7
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 04:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C7B1B821A7
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 11:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EFA0BC340F0;
        Fri, 18 Mar 2022 11:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647601215;
        bh=e9y/fBbX3UzldW1PqMzTWXANijaKr2i4vQrft82Qs3U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rkPBydLVd687fKFKNLifZ5raLJ+viLRzhY70EPG5NDn2Wt/5d4EmCNPG2xYLDbrUP
         DJawjZIxnzQxRzfSwhvlm8H8k4QGIMKzamuuRS5bGz5STvWf77wcREyU0CK0dfTHbR
         Pu4dyMqqvETB2HObEMrY26WxPgvmngos8Sv8WZ0Ec91pY66oKWThFJujHmMfgt/Ekc
         9TPrpnsQ8FtWPH7XkM7pu+v4NlxN7IP75fgAII+8Z5MzttZ7l7Ti2jH3LlF5xGUg5s
         yBtJDUbJXWtaRLwOgP3zt+Ej8w+Sj/7MGHbnDgE+caUmVc2Opibk4C6P4/lTGwjOOu
         psCSWMjbrKmRQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DE37DF0383F;
        Fri, 18 Mar 2022 11:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/15] net/mlx5e: Validate MTU when building non-linear
 legacy RQ fragments info
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164760121490.15393.8414807688995866762.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Mar 2022 11:00:14 +0000
References: <20220317185424.287982-2-saeed@kernel.org>
In-Reply-To: <20220317185424.287982-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        maximmi@nvidia.com, tariqt@nvidia.com, saeedm@nvidia.com
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Saeed Mahameed <saeedm@nvidia.com>:

On Thu, 17 Mar 2022 11:54:10 -0700 you wrote:
> From: Maxim Mikityanskiy <maximmi@nvidia.com>
> 
> mlx5e_build_rq_frags_info() assumes that MTU is not bigger than
> PAGE_SIZE * MLX5E_MAX_RX_FRAGS, which is 16K for 4K pages. Currently,
> the firmware limits MTU to 10K, so the assumption doesn't lead to a bug.
> 
> This commits adds an additional driver check for reliability, since the
> firmware boundary might be changed.
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] net/mlx5e: Validate MTU when building non-linear legacy RQ fragments info
    https://git.kernel.org/netdev/net-next/c/7c3b4df594b6
  - [net-next,02/15] net/mlx5e: Add headroom only to the first fragment in legacy RQ
    https://git.kernel.org/netdev/net-next/c/c3cce0fff3a3
  - [net-next,03/15] net/mlx5e: Build SKB in place over the first fragment in non-linear legacy RQ
    https://git.kernel.org/netdev/net-next/c/8d35fb57fd90
  - [net-next,04/15] net/mlx5e: RX, Test the XDP program existence out of the handler
    https://git.kernel.org/netdev/net-next/c/e26eceb90b01
  - [net-next,05/15] net/mlx5e: Drop the len output parameter from mlx5e_xdp_handle
    https://git.kernel.org/netdev/net-next/c/064990d0b65f
  - [net-next,06/15] net/mlx5e: Drop cqe_bcnt32 from mlx5e_skb_from_cqe_mpwrq_linear
    https://git.kernel.org/netdev/net-next/c/998923932f13
  - [net-next,07/15] net/mlx5: DR, Adjust structure member to reduce memory hole
    https://git.kernel.org/netdev/net-next/c/8f8533650325
  - [net-next,08/15] net/mlx5: DR, Remove mr_addr rkey from struct mlx5dr_icm_chunk
    https://git.kernel.org/netdev/net-next/c/003f4f9acb05
  - [net-next,09/15] net/mlx5: DR, Remove icm_addr from mlx5dr_icm_chunk to reduce memory
    https://git.kernel.org/netdev/net-next/c/5c4f9b6e91e8
  - [net-next,10/15] net/mlx5: DR, Remove num_of_entries byte_size from struct mlx5_dr_icm_chunk
    https://git.kernel.org/netdev/net-next/c/f51bb5179300
  - [net-next,11/15] net/mlx5: DR, Remove 4 members from mlx5dr_ste_htbl to reduce memory
    https://git.kernel.org/netdev/net-next/c/597534bd5633
  - [net-next,12/15] net/mlx5: DR, Remove hw_ste from mlx5dr_ste to reduce memory
    https://git.kernel.org/netdev/net-next/c/0d7f1595bb96
  - [net-next,13/15] net/mlx5: CT: Remove extra rhashtable remove on tuple entries
    https://git.kernel.org/netdev/net-next/c/ebf04231cf14
  - [net-next,14/15] net/mlx5: Remove unused exported contiguous coherent buffer allocation API
    https://git.kernel.org/netdev/net-next/c/4206fe40b2c0
  - [net-next,15/15] net/mlx5: Remove unused fill page array API function
    https://git.kernel.org/netdev/net-next/c/770c9a3a01af

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


