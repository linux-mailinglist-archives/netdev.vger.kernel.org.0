Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 544BD5F1F80
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 22:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbiJAUlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 16:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiJAUlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 16:41:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C8324C61F
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 13:40:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B62B2B80923
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 20:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 755B6C433D7;
        Sat,  1 Oct 2022 20:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664656818;
        bh=273lW9UVV4o+kJc3X/wdsUTY0elTKU5QXfJMSpCqEqc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=a9bnimhC9GPgSXk8/zxteErVYqTau1alIBgGV7zlbFWEuFrVbkWavQewoDRcA1+24
         CTCjogEykXL+HjvJd0kbo3l1NEastKeTQD5F7ODZ3LboWa9xlW7PCppRl5iF1xcEab
         xF5suEaHEDawhgAbCbhnQ4CAsOzPiLaMxXwWAZ7FpphYssLM+jpaxjh/THiz6RUtIF
         j0OeKOoZapBtNO766alNVPIbEAAqPqhExeQz6gChMB9oSgIaQdSjm1/8bjetHe4J0o
         pHVHsqs1BdD7AgKiNJz+XVignEG7YWMRBh4q7vzXBUTMXzNB61hEazGKqQcZuJ47Ei
         7j+ltSFXZpOkw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 59BD1E4D013;
        Sat,  1 Oct 2022 20:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/16] mlx5 xsk updates part3 2022-09-30
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166465681836.29087.4279285983955394531.git-patchwork-notify@kernel.org>
Date:   Sat, 01 Oct 2022 20:40:18 +0000
References: <20220930162903.62262-1-saeed@kernel.org>
In-Reply-To: <20220930162903.62262-1-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        tariqt@nvidia.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 30 Sep 2022 09:28:47 -0700 you wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> The gist of this 4 part series is in this patchset's last patch
> 
> This series contains performance optimizations. XSK starts using the
> batching allocator, and XSK data path gets separated from the regular
> RX, allowing to drop some branches not relevant for non-XSK use cases.
> Some minor optimizations for indirect calls and need_wakeup are also
> included.
> 
> [...]

Here is the summary with links:
  - [net-next,01/16] net/mlx5e: xsk: Use mlx5e_trigger_napi_icosq for XSK wakeup
    https://git.kernel.org/netdev/net-next/c/d54d7194ba48
  - [net-next,02/16] net/mlx5e: xsk: Drop the check for XSK state in mlx5e_xsk_wakeup
    https://git.kernel.org/netdev/net-next/c/8cbcafcee191
  - [net-next,03/16] net/mlx5e: Introduce wqe_index_mask for legacy RQ
    https://git.kernel.org/netdev/net-next/c/a064c609849b
  - [net-next,04/16] net/mlx5e: Make the wqe_index_mask calculation more exact
    https://git.kernel.org/netdev/net-next/c/5758c3145b88
  - [net-next,05/16] net/mlx5e: Use partial batches in legacy RQ
    https://git.kernel.org/netdev/net-next/c/42847fed5552
  - [net-next,06/16] net/mlx5e: xsk: Use partial batches in legacy RQ with XSK
    https://git.kernel.org/netdev/net-next/c/3f5fe0b2e606
  - [net-next,07/16] net/mlx5e: Remove the outer loop when allocating legacy RQ WQEs
    https://git.kernel.org/netdev/net-next/c/0b4822323745
  - [net-next,08/16] net/mlx5e: xsk: Split out WQE allocation for legacy XSK RQ
    https://git.kernel.org/netdev/net-next/c/a2e5ba242c33
  - [net-next,09/16] net/mlx5e: xsk: Use xsk_buff_alloc_batch on legacy RQ
    https://git.kernel.org/netdev/net-next/c/259bbc64367a
  - [net-next,10/16] net/mlx5e: xsk: Use xsk_buff_alloc_batch on striding RQ
    https://git.kernel.org/netdev/net-next/c/cf544517c469
  - [net-next,11/16] net/mlx5e: Use non-XSK page allocator in SHAMPO
    https://git.kernel.org/netdev/net-next/c/132857d9124c
  - [net-next,12/16] net/mlx5e: Call mlx5e_page_release_dynamic directly where possible
    https://git.kernel.org/netdev/net-next/c/96d37d861a09
  - [net-next,13/16] net/mlx5e: Optimize RQ page deallocation
    https://git.kernel.org/netdev/net-next/c/ddb7afeee28b
  - [net-next,14/16] net/mlx5e: xsk: Support XDP metadata on XSK RQs
    https://git.kernel.org/netdev/net-next/c/a752b2edb5c1
  - [net-next,15/16] net/mlx5e: Introduce the mlx5e_flush_rq function
    https://git.kernel.org/netdev/net-next/c/d9ba64deb2f1
  - [net-next,16/16] net/mlx5e: xsk: Use queue indices starting from 0 for XSK queues
    https://git.kernel.org/netdev/net-next/c/3db4c85cde7a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


