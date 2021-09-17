Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D82440F924
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 15:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241360AbhIQNbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 09:31:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:58170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232849AbhIQNb3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 09:31:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EFAF361212;
        Fri, 17 Sep 2021 13:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631885408;
        bh=zm094aRqy+4vI0QqLOBv0c63n7m2LO0A3/OzaYXXIBk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rQg6pNcZfQ9rMWib7HmYn+6sECUHQmfdjoJXl0rYW056oz7Eatj6anYnNPdVbSiKu
         2a6x+bMs6IO3/+JhZN1H9SzgLXQfcjxCxcD9zBxvsT7fFmnoUJkokvMxrI1jEe100r
         GN37au1sJFHpGPojVDTX/RKroje4GFp/Z8EGNFzY2H79WWYRwivA8MUAs3HpYSmWZo
         Xz1JZ3eznEAdKS7rDd0WGMepFavJV2USG4Em0Ydwn26LfoLGxq5Q72ri4np5FF0GW0
         lqfgsR4iDAZRZSbazlF0/bzTBPThcjLKFSi/UePp2H+aIHNsl4NbhdXZYKOPGLKqkU
         j1jLHoe08A+2w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E96DC609AD;
        Fri, 17 Sep 2021 13:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] devlink: Delete not-used devlink APIs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163188540795.4005.1956590146571309439.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Sep 2021 13:30:07 +0000
References: <a45674a8cb1c1e0133811d95756357b787673e52.1631788678.git.leonro@nvidia.com>
In-Reply-To: <a45674a8cb1c1e0133811d95756357b787673e52.1631788678.git.leonro@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, leonro@nvidia.com,
        jiri@nvidia.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 16 Sep 2021 13:38:33 +0300 you wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Devlink core exported generously the functions calls that were used
> by netdevsim tests or not used at all.
> 
> Delete such APIs with one exception - devlink_alloc_ns(). That function
> should be spared from deleting because it is a special form of devlink_alloc()
> needed for the netdevsim.
> 
> [...]

Here is the summary with links:
  - [net-next] devlink: Delete not-used devlink APIs
    https://git.kernel.org/netdev/net-next/c/6db9350a9db3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


