Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57AE04DE8EE
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 16:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243412AbiCSPLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 11:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242398AbiCSPLh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 11:11:37 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1485953E22
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 08:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5AEFCCE0EFE
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 15:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 97F0DC340EE;
        Sat, 19 Mar 2022 15:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647702613;
        bh=q3jmP/6Yfkg2e85/hyVrJasNObdcsjl3Eq4JUERKR7Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AQRM91vtp4V4aVj4SJUYwAKBirq1MUxQw6DwFZHS3R0qyJzIF3pZEg9SUkq+nVMq6
         c8z1Aigil1M9y5szrxwGGLFQm/qVhALi2XrH77zggoLbTqj8M+BNZBKlXenUuMUS0z
         3nnHTlOzDKTbEUtlZGHi5Km54nyW/oqpiEvhi+OPWxRBWft5n+1PJXkDTTvpx1ln2Q
         uvZPUAoY5z9MofLtsNzG8fd0wXUSMKJ6Yi1vSJOYCySx670ZeXts5YlxGpSfXS8CTl
         oE4QBINPUa41VRgZTDwy3qKkyX6Ti62Jou9LWJnUUj1rM2Ssf9lSIPDhNXELyrJVTM
         I6GvKy6QZXugQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7D023F0383F;
        Sat, 19 Mar 2022 15:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/15] net/mlx5e: Prepare non-linear legacy RQ for XDP
 multi buffer support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164770261350.11599.638180997535686593.git-patchwork-notify@kernel.org>
Date:   Sat, 19 Mar 2022 15:10:13 +0000
References: <20220318205248.33367-2-saeed@kernel.org>
In-Reply-To: <20220318205248.33367-2-saeed@kernel.org>
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

On Fri, 18 Mar 2022 13:52:34 -0700 you wrote:
> From: Maxim Mikityanskiy <maximmi@nvidia.com>
> 
> mlx5e_skb_from_cqe_nonlinear creates an xdp_buff first, putting the
> first fragment as the linear part, and the rest of fragments as
> fragments to struct skb_shared_info in the tailroom. Then it creates an
> SKB in place, based on the xdp_buff. The XDP program is not called in
> this commit yet.
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] net/mlx5e: Prepare non-linear legacy RQ for XDP multi buffer support
    https://git.kernel.org/netdev/net-next/c/4e8231f1c22d
  - [net-next,02/15] net/mlx5e: Use fragments of the same size in non-linear legacy RQ with XDP
    https://git.kernel.org/netdev/net-next/c/9cb9482ef10e
  - [net-next,03/15] net/mlx5e: Use page-sized fragments with XDP multi buffer
    https://git.kernel.org/netdev/net-next/c/d51f4a4cca6f
  - [net-next,04/15] net/mlx5e: Add XDP multi buffer support to the non-linear legacy RQ
    https://git.kernel.org/netdev/net-next/c/ea5d49bdae8b
  - [net-next,05/15] net/mlx5e: Store DMA address inside struct page
    https://git.kernel.org/netdev/net-next/c/ddc87e7d4775
  - [net-next,06/15] net/mlx5e: Move mlx5e_xdpi_fifo_push out of xmit_xdp_frame
    https://git.kernel.org/netdev/net-next/c/49529a172685
  - [net-next,07/15] net/mlx5e: Remove assignment of inline_hdr.sz on XDP TX
    https://git.kernel.org/netdev/net-next/c/c090451633f8
  - [net-next,08/15] net/mlx5e: Don't prefill WQEs in XDP SQ in the multi buffer mode
    https://git.kernel.org/netdev/net-next/c/9ded70fa1d81
  - [net-next,09/15] net/mlx5e: Implement sending multi buffer XDP frames
    https://git.kernel.org/netdev/net-next/c/39a1665d16a2
  - [net-next,10/15] net/mlx5e: Unindent the else-block in mlx5e_xmit_xdp_buff
    https://git.kernel.org/netdev/net-next/c/fbeed25bcc45
  - [net-next,11/15] net/mlx5e: Support multi buffer XDP_TX
    https://git.kernel.org/netdev/net-next/c/a48ad58cec18
  - [net-next,12/15] net/mlx5e: Permit XDP with non-linear legacy RQ
    https://git.kernel.org/netdev/net-next/c/1b8a10bbfe77
  - [net-next,13/15] net/mlx5e: Remove MLX5E_XDP_TX_DS_COUNT
    https://git.kernel.org/netdev/net-next/c/08c34e95422b
  - [net-next,14/15] net/mlx5e: Statify function mlx5_cmd_trigger_completions
    https://git.kernel.org/netdev/net-next/c/60796198b44f
  - [net-next,15/15] net/mlx5e: HTB, remove unused function declaration
    https://git.kernel.org/netdev/net-next/c/5dc2b581cd2c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


