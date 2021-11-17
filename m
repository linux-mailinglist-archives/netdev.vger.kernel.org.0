Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFE07454561
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 12:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232489AbhKQLNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 06:13:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:34966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236662AbhKQLNJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 06:13:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9D30661B42;
        Wed, 17 Nov 2021 11:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637147410;
        bh=X556GCHI/1b7X99CF1krK+22gU3o4vWbs2Xw6D0hlO0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Hh9kETTX0Oywsg4+JzKGHecg9jcdWDJtPOY0FIKsH1GqJ44BAn90YboWKEBsjwaHu
         N5Pt6923IuXRaTecz6DDP2PydXAB36u5g2Ug9OoTfHpfCGnrH0rpZ6o/Kwywcuz1lT
         uKEQOkyCep+dxSNDaK5alYIjQHWWNqhWpz9OJdwmFpJIdlTnQlBy0Yv3oZ8QbarN7z
         HWwdhMWZUye1h4kwAgHxU6TViJNQ1psYlTSn0Yi+uHVbenLulytdPr1tRGdWodI0Kj
         EeGYlof39yxh7WjwS8ghObpgBMKi6LCJV8nFEvnISGvXU+smlZ8woqGky2OpKAIYWJ
         P9by9hATjRKOA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8D96860A54;
        Wed, 17 Nov 2021 11:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net 01/12] net/mlx5e: kTLS, Fix crash in RX resync flow
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163714741057.4387.4775709366803372497.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Nov 2021 11:10:10 +0000
References: <20211116202321.283874-2-saeed@kernel.org>
In-Reply-To: <20211116202321.283874-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        tariqt@nvidia.com, maximmi@nvidia.com, saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Saeed Mahameed <saeedm@nvidia.com>:

On Tue, 16 Nov 2021 12:23:10 -0800 you wrote:
> From: Tariq Toukan <tariqt@nvidia.com>
> 
> For the TLS RX resync flow, we maintain a list of TLS contexts
> that require some attention, to communicate their resync information
> to the HW.
> Here we fix list corruptions, by protecting the entries against
> movements coming from resync_handle_seq_match(), until their resync
> handling in napi is fully completed.
> 
> [...]

Here is the summary with links:
  - [net,01/12] net/mlx5e: kTLS, Fix crash in RX resync flow
    https://git.kernel.org/netdev/net/c/cc4a9cc03faa
  - [net,02/12] net/mlx5e: Wait for concurrent flow deletion during neigh/fib events
    https://git.kernel.org/netdev/net/c/362980eada85
  - [net,03/12] net/mlx5: E-Switch, Fix resetting of encap mode when entering switchdev
    https://git.kernel.org/netdev/net/c/d7751d647618
  - [net,04/12] net/mlx5e: nullify cq->dbg pointer in mlx5_debug_cq_remove()
    https://git.kernel.org/netdev/net/c/76ded29d3fcd
  - [net,05/12] net/mlx5: DR, Handle eswitch manager and uplink vports separately
    https://git.kernel.org/netdev/net/c/9091b821aaa4
  - [net,06/12] net/mlx5: DR, Fix check for unsupported fields in match param
    https://git.kernel.org/netdev/net/c/455832d49666
  - [net,07/12] net/mlx5: Update error handler for UCTX and UMEM
    https://git.kernel.org/netdev/net/c/ba50cd9451f6
  - [net,08/12] net/mlx5: E-Switch, rebuild lag only when needed
    https://git.kernel.org/netdev/net/c/2eb0cb31bc4c
  - [net,09/12] net/mlx5: Fix flow counters SF bulk query len
    https://git.kernel.org/netdev/net/c/38a54cae6f76
  - [net,10/12] net/mlx5e: CT, Fix multiple allocations and memleak of mod acts
    https://git.kernel.org/netdev/net/c/806401c20a0f
  - [net,11/12] net/mlx5: Lag, update tracker when state change event received
    https://git.kernel.org/netdev/net/c/ae396d85c01c
  - [net,12/12] net/mlx5: E-Switch, return error if encap isn't supported
    https://git.kernel.org/netdev/net/c/c4c3176739df

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


