Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2E235772A
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 23:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbhDGVuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 17:50:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:48066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229510AbhDGVuU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 17:50:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B42FD610CC;
        Wed,  7 Apr 2021 21:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617832210;
        bh=JFy0+jZ4D7NTKxD4TKawfvHRmH3FfjzAbLHYQMGTO1Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qVCSXVhLYkKoCbBtWD+5QIVbUy4N1VhM8yIMNj3uhXqMrkRYSZhlj880ZwmdgyEey
         glYPer6VAFUlQyngFZrCKUh8V0/CzR5klo5kT/zLE2r+knTVkoyPsn4iPA/YZBVa5j
         c8ZkPFvJihGrTKBY19RAViMA89LjpKaubcNYb5b4Vk84mquCp9WXA9kDR4LbzhmF6E
         rZTGURFVxq0PylzV0sL8VaCr0QrsAyzQfX4Bz3bopx5kMDMbhDl53oxKc4BbUx9gd7
         sBiAuQNPOJENv74sEl4s1U7m0lT3Q/CLUuVW5B+XfZZe14XU3rXNso5S/LPd1scumj
         Ii6tKpPX6h/xQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A3CB560A71;
        Wed,  7 Apr 2021 21:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/13] net/mlx5: E-switch,
 Move vport table functions to a new file
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161783221066.30231.12083412945072924908.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Apr 2021 21:50:10 +0000
References: <20210407045421.148987-2-saeed@kernel.org>
In-Reply-To: <20210407045421.148987-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        cmi@nvidia.com, ozsh@nvidia.com, mbloch@nvidia.com,
        saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue,  6 Apr 2021 21:54:09 -0700 you wrote:
> From: Chris Mi <cmi@nvidia.com>
> 
> Currently, the vport table functions are in common eswitch offload
> file. This file is too big. Move the vport table create, delete and
> lookup functions to a separate file. Put the file in esw directory.
> 
> Pre-step for generalizing its functionality for serving both the
> mirroring and the sample features.
> 
> [...]

Here is the summary with links:
  - [net-next,01/13] net/mlx5: E-switch, Move vport table functions to a new file
    https://git.kernel.org/netdev/net-next/c/4c7f40287aa5
  - [net-next,02/13] net/mlx5: E-switch, Rename functions to follow naming convention.
    https://git.kernel.org/netdev/net-next/c/0a9e2307870b
  - [net-next,03/13] net/mlx5: E-switch, Generalize per vport table API
    https://git.kernel.org/netdev/net-next/c/c796bb7cd230
  - [net-next,04/13] net/mlx5: E-switch, Set per vport table default group number
    https://git.kernel.org/netdev/net-next/c/c1904360dde8
  - [net-next,05/13] net/mlx5: Map register values to restore objects
    https://git.kernel.org/netdev/net-next/c/a91d98a0a2b8
  - [net-next,06/13] net/mlx5: Instantiate separate mapping objects for FDB and NIC tables
    https://git.kernel.org/netdev/net-next/c/c935568271b5
  - [net-next,07/13] net/mlx5e: TC, Parse sample action
    https://git.kernel.org/netdev/net-next/c/41c2fd949803
  - [net-next,08/13] net/mlx5e: TC, Add sampler termination table API
    https://git.kernel.org/netdev/net-next/c/2a9ab10a5689
  - [net-next,09/13] net/mlx5e: TC, Add sampler object API
    https://git.kernel.org/netdev/net-next/c/11ecd6c60b4e
  - [net-next,10/13] net/mlx5e: TC, Add sampler restore handle API
    https://git.kernel.org/netdev/net-next/c/36a3196256bf
  - [net-next,11/13] net/mlx5e: TC, Refactor tc update skb function
    https://git.kernel.org/netdev/net-next/c/7319a1cc3ca9
  - [net-next,12/13] net/mlx5e: TC, Handle sampled packets
    https://git.kernel.org/netdev/net-next/c/be9dc0047450
  - [net-next,13/13] net/mlx5e: TC, Add support to offload sample action
    https://git.kernel.org/netdev/net-next/c/f94d6389f6a8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


