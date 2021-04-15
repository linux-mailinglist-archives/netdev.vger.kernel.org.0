Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34C4436168A
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 01:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235900AbhDOXud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 19:50:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:49700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235240AbhDOXuc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 19:50:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4380861153;
        Thu, 15 Apr 2021 23:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618530609;
        bh=CGLsy7g5xBuBNWRqNok55hvD4Q6QwTm7nPRRssUt/1U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KY7lXG68vqegum+zrSlE6xff2bgr+mK7W/M9LJh+oFxB37gCXOa2kexBaRHDCvFoD
         5s3hgdsHrWdab+8gaYESUMZVuGIKu4l9hj8S/1RY3Pb/ODvZjLrY1b12yGFhWy1lPT
         SayaIcbDKjozXOg6+cKtEq77ruMb+0bAxxhsqprybSBNC5KMlvgicD9FC6edJQL7Zl
         SKQlRSQQcxhYSjeHVIMaqG3Oy1UJbpE82958rmCWWNnbSBQYxZAdU1OycHKfw4fo2N
         B6QSAcFEwuSSHtK/AUrkP8RDRXa18dLVl3rRbZv3xGDu6DHKB/GlS67Y8xJ/L1xnOd
         PuceSgRxHXIoQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 33F3E60CD4;
        Thu, 15 Apr 2021 23:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net 1/3] net/mlx5: Fix setting of devlink traps in switchdev mode
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161853060920.30410.7488943298285569296.git-patchwork-notify@kernel.org>
Date:   Thu, 15 Apr 2021 23:50:09 +0000
References: <20210414231610.136376-2-saeed@kernel.org>
In-Reply-To: <20210414231610.136376-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        tariqt@nvidia.com, ayal@nvidia.com, moshe@nvidia.com,
        roid@nvidia.com, saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Wed, 14 Apr 2021 16:16:08 -0700 you wrote:
> From: Aya Levin <ayal@nvidia.com>
> 
> Prevent setting of devlink traps on the uplink while in switchdev mode.
> In this mode, it is the SW switch responsibility to handle both packets
> with a mismatch in destination MAC or VLAN ID. Therefore, there are no
> flow steering tables to trap undesirable packets and driver crashes upon
> setting a trap.
> 
> [...]

Here is the summary with links:
  - [net,1/3] net/mlx5: Fix setting of devlink traps in switchdev mode
    https://git.kernel.org/netdev/net/c/41bafb31dcd5
  - [net,2/3] net/mlx5e: Fix setting of RS FEC mode
    https://git.kernel.org/netdev/net/c/7a320c9db3e7
  - [net,3/3] net/mlx5e: fix ingress_ifindex check in mlx5e_flower_parse_meta
    https://git.kernel.org/netdev/net/c/e3e0f9b27970

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


