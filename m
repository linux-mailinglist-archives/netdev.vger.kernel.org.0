Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 209375F0F3F
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 17:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbiI3Pu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 11:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiI3Pu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 11:50:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6506B13DE5
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 08:50:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4CA95B82955
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 15:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EC48AC433D6;
        Fri, 30 Sep 2022 15:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664553020;
        bh=c7I1f9EQkxXfIJ6457b0khFLku9hE/I/FU1pFR3LVrE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bwHAJFWJJo1UU3a/1qB4lHvATgUNd8/XGOrKYq224hARDj4hM74phCD79q4cUSzR1
         8fdXxAZjVxQ9euMImKZx5PX7wBIchgNCVZbspFYOqY+B4r+jp17e5/kKcV5NxVoCFQ
         16Msk3DrwOH9a5/4AQFNgbNKq2ESVHDCxi91/6EP11mjbGDBpyrdQ6ILcpo71ZItsk
         XVdj8siMrAXwXkegx0kQvROnE7UBQZpIFn83ZtG3gehrUrXCHRsb3teJqLgjdYePc/
         SdnedgcDhWCvQL8HN3eXyZ9i10xXO/BFqXYktBZhVPJLIySwXFhwBw9gC9SmFlozQl
         5TmD3o3LqjB5g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D1E53C395DA;
        Fri, 30 Sep 2022 15:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/16] mlx5 xsk updates part2 2022-09-28
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166455301985.20431.12735826339485678085.git-patchwork-notify@kernel.org>
Date:   Fri, 30 Sep 2022 15:50:19 +0000
References: <20220929072156.93299-1-saeed@kernel.org>
In-Reply-To: <20220929072156.93299-1-saeed@kernel.org>
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

On Thu, 29 Sep 2022 00:21:40 -0700 you wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> XSK buffer improvements, This is part #2 of 4 parts series.
> 
>  1) Expose xsk min chunk size to drivers, to allow the driver to adjust to a
>    better buffer stride size
> 
> [...]

Here is the summary with links:
  - [net-next,01/16] xsk: Expose min chunk size to drivers
    https://git.kernel.org/netdev/net-next/c/9ca66afe73da
  - [net-next,02/16] net/mlx5e: Use runtime page_shift for striding RQ
    https://git.kernel.org/netdev/net-next/c/e5a3cc83d540
  - [net-next,03/16] net/mlx5e: xsk: Use XSK frame size as striding RQ page size
    https://git.kernel.org/netdev/net-next/c/fa5573359aae
  - [net-next,04/16] net/mlx5e: Keep a separate MKey for striding RQ
    https://git.kernel.org/netdev/net-next/c/ecc7ad2eab35
  - [net-next,05/16] net/mlx5: Add MLX5_FLEXIBLE_INLEN to safely calculate cmd inlen
    https://git.kernel.org/netdev/net-next/c/c4418f349554
  - [net-next,06/16] net/mlx5e: xsk: Use KSM for unaligned XSK
    https://git.kernel.org/netdev/net-next/c/6470d2e7e8ed
  - [net-next,07/16] xsk: Remove unused xsk_buff_discard
    https://git.kernel.org/netdev/net-next/c/f2f167583601
  - [net-next,08/16] net/mlx5e: Fix calculations for ICOSQ size
    https://git.kernel.org/netdev/net-next/c/0b9c86c78586
  - [net-next,09/16] net/mlx5e: Optimize the page cache reducing its size 2x
    https://git.kernel.org/netdev/net-next/c/707f908e31d7
  - [net-next,10/16] net/mlx5e: Rename mlx5e_dma_info to prepare for removal of DMA address
    https://git.kernel.org/netdev/net-next/c/79008676d533
  - [net-next,11/16] net/mlx5e: Remove DMA address from mlx5e_alloc_unit
    https://git.kernel.org/netdev/net-next/c/6bdeb963822a
  - [net-next,12/16] net/mlx5e: Convert struct mlx5e_alloc_unit to a union
    https://git.kernel.org/netdev/net-next/c/672db0243349
  - [net-next,13/16] net/mlx5e: xsk: Remove mlx5e_xsk_page_alloc_pool
    https://git.kernel.org/netdev/net-next/c/2d0765f78c13
  - [net-next,14/16] net/mlx5e: Split out channel (de)activation in rx_res
    https://git.kernel.org/netdev/net-next/c/d32c225316d4
  - [net-next,15/16] net/mlx5e: Move repeating clear_bit in mlx5e_rx_reporter_err_rq_cqe_recover
    https://git.kernel.org/netdev/net-next/c/e64d71d055ca
  - [net-next,16/16] net/mlx5e: Clean up and fix error flows in mlx5e_alloc_rq
    https://git.kernel.org/netdev/net-next/c/8f5ed1c140f8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


