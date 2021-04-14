Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51E6E35FD61
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 23:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233874AbhDNVkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 17:40:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:37992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231389AbhDNVke (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 17:40:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8CC2B61177;
        Wed, 14 Apr 2021 21:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618436412;
        bh=k+ri7fhw3yU+8tJJePqNcUEEtXTVCfnzt9mQOtYfYgY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Zi0ZT6CB7+KSpPIutxfvhlWBJO5N6Gh27uDXxnYTGgQPKVBJsGcXwe3kkY2Is85b3
         acXwAa5Hu5PRDsFBR51kuSlgTm7uzUi5ROexItiMVdXrrld3RgyA9hRqNpwDqJ1/ds
         GVvJQZ6Ye0BkQ+3wuaiOmB4TIzfSCELFQvQdzAHwDwflXUrPqCuixy6LQqrgMj10H+
         aPoSwecqFkVg4nlLlClchB/8E18nlZDKm4MPMRMZiqUHw0A7q/9LLulqpuDbxvJeQJ
         uTsAKbrFWDcOSSFGVMcnwuw+fpz5q8AaJqP8urgcfRE9P3PqJFpYVnewiHbgBEM0Ub
         w7FSBU9jiJu4Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7E69760CD2;
        Wed, 14 Apr 2021 21:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next V2 01/16] net/mlx5: E-Switch,
 let user to enable disable metadata
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161843641251.17301.15085195167282482641.git-patchwork-notify@kernel.org>
Date:   Wed, 14 Apr 2021 21:40:12 +0000
References: <20210414180605.111070-2-saeed@kernel.org>
In-Reply-To: <20210414180605.111070-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        tariqt@nvidia.com, parav@nvidia.com, roid@nvidia.com,
        vuhuong@nvidia.com, saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 14 Apr 2021 11:05:50 -0700 you wrote:
> From: Parav Pandit <parav@nvidia.com>
> 
> Currently each packet inserted in eswitch is tagged with a internal
> metadata to indicate source vport. Metadata tagging is not always
> needed. Metadata insertion is needed for multi-port RoCE, failover
> between representors and stacked devices. In many other cases,
> metadata enablement is not needed.
> 
> [...]

Here is the summary with links:
  - [net-next,V2,01/16] net/mlx5: E-Switch, let user to enable disable metadata
    https://git.kernel.org/netdev/net-next/c/7bf481d7e75a
  - [net-next,V2,02/16] net/mlx5: E-Switch, Skip querying SF enabled bits
    https://git.kernel.org/netdev/net-next/c/7d5ae4789192
  - [net-next,V2,03/16] net/mlx5: E-Switch, Make vport number u16
    https://git.kernel.org/netdev/net-next/c/6308a5f06be0
  - [net-next,V2,04/16] net/mlx5: E-Switch Make cleanup sequence mirror of init
    https://git.kernel.org/netdev/net-next/c/13795553a84d
  - [net-next,V2,05/16] net/mlx5: E-Switch, Convert a macro to a helper routine
    https://git.kernel.org/netdev/net-next/c/b16f2bb6b6ca
  - [net-next,V2,06/16] net/mlx5: E-Switch, Move legacy code to a individual file
    https://git.kernel.org/netdev/net-next/c/b55b35382e51
  - [net-next,V2,07/16] net/mlx5: E-Switch, Initialize eswitch acls ns when eswitch is enabled
    https://git.kernel.org/netdev/net-next/c/57b92bdd9e14
  - [net-next,V2,08/16] net/mlx5: SF, Use device pointer directly
    https://git.kernel.org/netdev/net-next/c/6e74e6ea1b64
  - [net-next,V2,09/16] net/mlx5: SF, Reuse stored hardware function id
    https://git.kernel.org/netdev/net-next/c/a74ed24c437e
  - [net-next,V2,10/16] net/mlx5: DR, Use variably sized data structures for different actions
    https://git.kernel.org/netdev/net-next/c/9dac2966c531
  - [net-next,V2,11/16] net/mlx5: DR, Alloc cmd buffer with kvzalloc() instead of kzalloc()
    https://git.kernel.org/netdev/net-next/c/b7f86258a264
  - [net-next,V2,12/16] net/mlx5: Fix bit-wise and with zero
    https://git.kernel.org/netdev/net-next/c/82c3ba31c370
  - [net-next,V2,13/16] net/mlx5: Add a blank line after declarations
    https://git.kernel.org/netdev/net-next/c/02f47c04c36c
  - [net-next,V2,14/16] net/mlx5: Remove return statement exist at the end of void function
    https://git.kernel.org/netdev/net-next/c/9dee115bc147
  - [net-next,V2,15/16] net/mlx5: Replace spaces with tab at the start of a line
    https://git.kernel.org/netdev/net-next/c/31450b435fe6
  - [net-next,V2,16/16] net/mlx5e: Fix RQ creation flow for queues which doesn't support XDP
    https://git.kernel.org/netdev/net-next/c/5b232ea94c90

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


