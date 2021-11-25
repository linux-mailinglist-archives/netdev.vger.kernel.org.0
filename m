Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB4545D272
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 02:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344903AbhKYBfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 20:35:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:34616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346750AbhKYBdU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 20:33:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id DA8EB610FE;
        Thu, 25 Nov 2021 01:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637803809;
        bh=esfcfqlPyNsDmFVaf8fzNX+OYkVqNLV2j9I+SWjlNMs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oLm3Lo9QLRj+ZcRjDemhcvnNGk62PWRwcRbvdUbBaJlFk/7ZoOqE9jvSgt7zosOtV
         YJwagN9m0eaMqe8nnlpP05ICDUfx1z5iAkh+Va3cbAfyOi+9fXzP5BcsA0rwan4vG5
         iA9gzhZ+PrU2NoYPCiTL3bHzh28GVnQhFKxPepz5esH41HQTNq894e75yOMAZFMFid
         rNnaziskFsALO6o+R1bEStSb2JOIYYGUgA+ozZQEOy+x0rwphOl2hIAhr1zYVqDQMg
         rjUaa+h1hhtS3XpM+7Q9TEb7SLpiWaGF/5FfSj82jqpAy0K9u3WcomzS6esT6D2xpT
         IF84Zz503ldTQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D3E5D60A21;
        Thu, 25 Nov 2021 01:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] gro: remove redundant rcu_read_lock
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163780380986.5226.16079879965622025793.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Nov 2021 01:30:09 +0000
References: <20211123225608.2155163-1-eric.dumazet@gmail.com>
In-Reply-To: <20211123225608.2155163-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 23 Nov 2021 14:56:06 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Recent trees got an increase of rcu_read_{lock|unlock} costs,
> it is time to get rid of the not needed pairs.
> 
> Eric Dumazet (2):
>   gro: remove rcu_read_lock/rcu_read_unlock from gro_receive handlers
>   gro: remove rcu_read_lock/rcu_read_unlock from gro_complete handlers
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] gro: remove rcu_read_lock/rcu_read_unlock from gro_receive handlers
    https://git.kernel.org/netdev/net-next/c/fc1ca3348a74
  - [net-next,2/2] gro: remove rcu_read_lock/rcu_read_unlock from gro_complete handlers
    https://git.kernel.org/netdev/net-next/c/627b94f75b82

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


