Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C50163453DD
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 01:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbhCWAal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 20:30:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:41214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230370AbhCWAaK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 20:30:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 96BFC61992;
        Tue, 23 Mar 2021 00:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616459409;
        bh=NC2BseJlNGlD3XNemZtjbZ97hdI4Vf/cnWVrXP5a9+I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mtAAdKgArdRA+QL37rkjP5rN4gzIGxlusrTVqrc35wyrx/5KA+jIbO0R9a0gXNrRm
         QRaU5XEBT2Lq9JTfydz6HUVDu8Xh076o7M2AVftVso0A0LVWFyFsCG/QQaOqewK+fO
         0zeIcamffDfLvj/C4muYB5OSP3KiJK2eBql6ZCZcuCYSesHZn7249vjXPtvuaLWfe5
         2eNP2UbUqPVAy8nOnspay5Jf2fXfCMc+dr9rYT6Qtk4EdJUNfgKwR2Sr5A+CDomrHQ
         Zua1Rx4V2JGlDOPhYUWNDZl31LJkF2rJe9BZNbEVDEOg1L3U6g7y2dPYLizwQSJZmY
         zvlffTo3zuVtw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 88071609E8;
        Tue, 23 Mar 2021 00:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net 1/6] net/mlx5: Add back multicast stats for uplink representor
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161645940955.31154.4831886572798026614.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Mar 2021 00:30:09 +0000
References: <20210322202524.68886-2-saeed@kernel.org>
In-Reply-To: <20210322202524.68886-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        huyn@nvidia.com, danielj@nvidia.com, saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Mon, 22 Mar 2021 13:25:19 -0700 you wrote:
> From: Huy Nguyen <huyn@nvidia.com>
> 
> The multicast counter got removed from uplink representor due to the
> cited patch.
> 
> Fixes: 47c97e6b10a1 ("net/mlx5e: Fix multicast counter not up-to-date in "ip -s"")
> Signed-off-by: Huy Nguyen <huyn@nvidia.com>
> Reviewed-by: Daniel Jurgens <danielj@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net,1/6] net/mlx5: Add back multicast stats for uplink representor
    https://git.kernel.org/netdev/net/c/a07231084da2
  - [net,2/6] net/mlx5e: Allow to match on MPLS parameters only for MPLS over UDP
    https://git.kernel.org/netdev/net/c/7d6c86e3ccb5
  - [net,3/6] net/mlx5e: Offload tuple rewrite for non-CT flows
    https://git.kernel.org/netdev/net/c/96b5b4585843
  - [net,4/6] net/mlx5e: Fix error path for ethtool set-priv-flag
    https://git.kernel.org/netdev/net/c/4eacfe72e3e0
  - [net,5/6] net/mlx5e: Fix division by 0 in mlx5e_select_queue
    https://git.kernel.org/netdev/net/c/846d6da1fcdb
  - [net,6/6] net/mlx5: SF, do not use ecpu bit for vhca state processing
    https://git.kernel.org/netdev/net/c/7c1ef1959b6f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


