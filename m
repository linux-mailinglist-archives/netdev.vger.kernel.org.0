Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E81AA5F3A5F
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 02:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiJDAKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 20:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiJDAKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 20:10:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C048F120AA
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 17:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E48861225
        for <netdev@vger.kernel.org>; Tue,  4 Oct 2022 00:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B83D9C433D6;
        Tue,  4 Oct 2022 00:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664842218;
        bh=164uy1iNGHEqPHlq/CgxF3j1DxWBUH4pimqe0SrMSo0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=j5SPPoM9FhP3Psj990c1LObbSLTZGqikCtnhaQD9NAs5i6FVl/bw2ogrLM7kLb7El
         OAwYUDHeCTjU0/9HyWqfJGd29WvojJBfW1tbjfwqHOEqwjEKRhpRXvBlXt3KxDkRwv
         tn9Glc9L1c0R6Kz2DVy3NIBp/XMIJm+gUysTIW+3UPx7g+8CwoeDs2X+jgOK00ySA6
         6Sz9MmB++vOxuMe+tnsnMu7YaOPXJiLJIuuYF8s0CAxYYQHe3TJcFOlDomH4O9ZZfE
         UFu8Gr6cIS9HwilV3wtJbjd0kIw61AVCe5um/VK1DzVhLmsSXo2ntLRTJ/gf0q4waV
         x91I707nRZ34A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 97BB6E49FA7;
        Tue,  4 Oct 2022 00:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/15] ] mlx5 xsk updates part4 and more
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166484221860.7651.2840728770658860381.git-patchwork-notify@kernel.org>
Date:   Tue, 04 Oct 2022 00:10:18 +0000
References: <20221002045632.291612-1-saeed@kernel.org>
In-Reply-To: <20221002045632.291612-1-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        tariqt@nvidia.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sat,  1 Oct 2022 21:56:17 -0700 you wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> 1) Final part of xsk improvements,
> in this series Maxim continues to improve xsk implementation
>  a) XSK Busy polling support
>  b) Use KLM to avoid Frame overrun in unaligned mode
>  c) Optimize unaligned more for certain frame sizes
>  d) Other straight forward minor optimizations.
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] net/mlx5e: xsk: Flush RQ on XSK activation to save memory
    https://git.kernel.org/netdev/net-next/c/082a9edf12fe
  - [net-next,02/15] net/mlx5e: xsk: Set napi_id to support busy polling
    https://git.kernel.org/netdev/net-next/c/a2740f529da2
  - [net-next,03/15] net/mlx5e: xsk: Include XSK skb_from_cqe callbacks in INDIRECT_CALL
    https://git.kernel.org/netdev/net-next/c/1ca6492ec964
  - [net-next,04/15] net/mlx5e: xsk: Improve need_wakeup logic
    https://git.kernel.org/netdev/net-next/c/cfb4d09c30c9
  - [net-next,05/15] net/mlx5e: xsk: Use umr_mode to calculate striding RQ parameters
    https://git.kernel.org/netdev/net-next/c/168723c1f8d6
  - [net-next,06/15] net/mlx5e: Improve MTT/KSM alignment
    https://git.kernel.org/netdev/net-next/c/9f123f740428
  - [net-next,07/15] net/mlx5e: xsk: Use KLM to protect frame overrun in unaligned mode
    https://git.kernel.org/netdev/net-next/c/139213451046
  - [net-next,08/15] net/mlx5e: xsk: Print a warning in slow configurations
    https://git.kernel.org/netdev/net-next/c/c6f0420468fb
  - [net-next,09/15] net/mlx5e: xsk: Optimize for unaligned mode with 3072-byte frames
    https://git.kernel.org/netdev/net-next/c/c2c9e31dfa4f
  - [net-next,10/15] net/mlx5e: Expose rx_oversize_pkts_buffer counter
    https://git.kernel.org/netdev/net-next/c/16ab85e78439
  - [net-next,11/15] net/mlx5: Start health poll at earlier stage of driver load
    https://git.kernel.org/netdev/net-next/c/9b98d395b85d
  - [net-next,12/15] net/mlx5: Set default grace period based on function type
    https://git.kernel.org/netdev/net-next/c/1330bd9884ef
  - [net-next,13/15] net/mlx5: E-Switch, Allow offloading fwd dest flow table with vport
    https://git.kernel.org/netdev/net-next/c/8c9cc1eb90c1
  - [net-next,14/15] net/mlx5: E-switch, Don't update group if qos is not enabled
    https://git.kernel.org/netdev/net-next/c/909ffe462a18
  - [net-next,15/15] net/mlx5: E-Switch, Return EBUSY if can't get mode lock
    https://git.kernel.org/netdev/net-next/c/794131c40850

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


