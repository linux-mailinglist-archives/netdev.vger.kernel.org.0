Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30E8C3B2178
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 22:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbhFWUC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 16:02:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:56040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229818AbhFWUCX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 16:02:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3E880611C1;
        Wed, 23 Jun 2021 20:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624478405;
        bh=q7tS2UGCz+ZSJts7KDTgmVDNxuQWcUIDdXF/kvFF2ws=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nniOm8LDee/BN1XYyvC6vbLejxujVOOztQkV9t7YnTuEN3R1wTX5fofa7ZosnhmJl
         5VpPpoT53POQFMoF3P4/mA6/Wy0D+dIFLgfQk641AawO7x1pqUEcL7fUXnN+CXtLg1
         hSx5X1ovHZP/pougm1i7KTpR0queDn+NRrvDupM5+pDFS1NwSFiM23GiCbmlyqrSUy
         sY60f5vCd/rpgX1sNjWKTlRU3V0Ht4wkR6e81No4u2cAC1LZuRBhwhO9U6spztlANg
         mUlpkOHNs/MShCK67cno6gcrawxAsbXDGZlgj0GLJSmUYenEJjSFRogA6pN42LGbCo
         daf5UhgyOUXsw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2DEC360A71;
        Wed, 23 Jun 2021 20:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [pull request][net-next] mlx5 net-next 2021-06-22
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162447840518.26653.13937217527797447649.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Jun 2021 20:00:05 +0000
References: <20210622224300.498116-1-saeed@kernel.org>
In-Reply-To: <20210622224300.498116-1-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (refs/heads/master):

On Tue, 22 Jun 2021 15:43:00 -0700 you wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> Hi Dave, Jakub,
> 
> This series includes only commits that been already reviewed on netdev
> ML, hence this pr is not followed by the patches to avoid noise.
> 
> [...]

Here is the summary with links:
  - [pull,request,net-next] mlx5 net-next 2021-06-22
    https://git.kernel.org/netdev/net-next/c/fe87797bf245

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


