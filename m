Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E93D482461
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 15:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbhLaOkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 09:40:19 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46338 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbhLaOkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 09:40:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF341617BF
        for <netdev@vger.kernel.org>; Fri, 31 Dec 2021 14:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 52B87C36AEF;
        Fri, 31 Dec 2021 14:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640961617;
        bh=nLLYNMJoeMjDm4xiyf484CvQAL7TiZvv/7JfUGeA8Uc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=moSWg6qCWWe+kraTVB4whATSmiqpe60AsHt9nvNKcNlyFZONSkQMlnJU8eJaAvcDy
         +m2ZTkJkTpzwLzpl9Wa7DzwpMuZYEiZAWxIVBaTgpBXFgV9jZqTMB8/+TaUSwZVw7+
         vdsLwZfIMA3SvoqNrwPRA9mnonky2Gogz1kR43j5wEkxzp17mSwESdZe+4yng8UUMx
         eXulpB4/ktHUfuqOzuD6DuWb861rltSVjSiXR9LJNWhQhao0pEPAbLybTwXFJCt3wr
         vOX8oC2QM+ubq5jmFnj6LWZUmoZe18T/4qSK6Oec8jiSUDgD1hY8RkofVyTXq1vu9f
         v42ZV7p0vkOtg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 418B4C395E6;
        Fri, 31 Dec 2021 14:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next v2 01/16] net/mlx5: DR, Fix error flow in creating matcher
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164096161726.2091.18391624146727383760.git-patchwork-notify@kernel.org>
Date:   Fri, 31 Dec 2021 14:40:17 +0000
References: <20211231082038.106490-2-saeed@kernel.org>
In-Reply-To: <20211231082038.106490-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        kliteyn@nvidia.com, saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Saeed Mahameed <saeedm@nvidia.com>:

On Fri, 31 Dec 2021 00:20:23 -0800 you wrote:
> From: Yevgeny Kliteynik <kliteyn@nvidia.com>
> 
> The error code of nic matcher init functions wasn't checked.
> This patch improves the matcher init function and fix error flow bug:
> the handling of match parameter is moved into a separate function
> and error flow is simplified.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,01/16] net/mlx5: DR, Fix error flow in creating matcher
    https://git.kernel.org/netdev/net-next/c/84dfac39c61f
  - [net-next,v2,02/16] net/mlx5: DR, Fix lower case macro prefix "mlx5_" to "MLX5_"
    https://git.kernel.org/netdev/net-next/c/c3fb0e280b4c
  - [net-next,v2,03/16] net/mlx5: DR, Remove unused struct member in matcher
    https://git.kernel.org/netdev/net-next/c/32e9bd585307
  - [net-next,v2,04/16] net/mlx5: DR, Rename list field in matcher struct to list_node
    https://git.kernel.org/netdev/net-next/c/08fac109f7bb
  - [net-next,v2,05/16] net/mlx5: DR, Add check for flex parser ID value
    https://git.kernel.org/netdev/net-next/c/89cdba3224f0
  - [net-next,v2,06/16] net/mlx5: DR, Add missing reserved fields to dr_match_param
    https://git.kernel.org/netdev/net-next/c/7766c9b922fe
  - [net-next,v2,07/16] net/mlx5: DR, Add support for dumping steering info
    https://git.kernel.org/netdev/net-next/c/9222f0b27da2
  - [net-next,v2,08/16] net/mlx5: DR, Add support for UPLINK destination type
    https://git.kernel.org/netdev/net-next/c/e3a0f40b2f90
  - [net-next,v2,09/16] net/mlx5: DR, Warn on failure to destroy objects due to refcount
    https://git.kernel.org/netdev/net-next/c/b54128275ef8
  - [net-next,v2,10/16] net/mlx5: Add misc5 flow table match parameters
    https://git.kernel.org/netdev/net-next/c/0f2a6c3b9219
  - [net-next,v2,11/16] net/mlx5: DR, Add misc5 to match_param structs
    https://git.kernel.org/netdev/net-next/c/8c2b4fee9c4b
  - [net-next,v2,12/16] net/mlx5: DR, Support matching on tunnel headers 0 and 1
    https://git.kernel.org/netdev/net-next/c/09753babaf46
  - [net-next,v2,13/16] net/mlx5: DR, Add support for matching on geneve_tlv_option_0_exist field
    https://git.kernel.org/netdev/net-next/c/f59464e257bd
  - [net-next,v2,14/16] net/mlx5: DR, Improve steering for empty or RX/TX-only matchers
    https://git.kernel.org/netdev/net-next/c/cc2295cd54e4
  - [net-next,v2,15/16] net/mlx5: DR, Ignore modify TTL if device doesn't support it
    https://git.kernel.org/netdev/net-next/c/4ff725e1d4ad
  - [net-next,v2,16/16] net/mlx5: Set SMFS as a default steering mode if device supports it
    https://git.kernel.org/netdev/net-next/c/aa36c94853b2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


