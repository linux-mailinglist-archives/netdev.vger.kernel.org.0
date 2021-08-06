Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9CB3E2779
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 11:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244658AbhHFJkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 05:40:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:38032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244627AbhHFJkV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 05:40:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E470160F35;
        Fri,  6 Aug 2021 09:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628242805;
        bh=GT2KIQmNxds6QEypRmaFme4sbojfA4Zx2BJDXQkj5E0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NnZT4hoAIaYSixQQqINXHol8HUvST3NfCF/kayOVMq7PHw2MoGwWOaeZZCxCyoaeS
         /mT1YktcIZMqx+t2T6YvUXZL7tIIcSFl6FkcrnGfZfhuKamK8mwCBkI3PcdymJaKaP
         zaA7Z/808zX6tC71kcb1Vjacx9DVRn4UZgcCI0oOq0zRQSrLWRdKxOmaAERmHK84cI
         FFLUhHr1mZyQJ3u1u6mEfvUODHVlQCzS33uibssr0zblex2WnK9dGprrbkYNuvglLR
         jvBOidRO9EHP4H2Px9FcmHJDdW7nkVXpXtUhhlAvAzRUZE48vdnXS7anHAfxMLk/X1
         8jT1T8BJ9T23g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D679660A7C;
        Fri,  6 Aug 2021 09:40:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] netdevsim: Protect both reload_down and reload_up
 paths
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162824280587.22626.8486102911300607412.git-patchwork-notify@kernel.org>
Date:   Fri, 06 Aug 2021 09:40:05 +0000
References: <bf73a78a5074d1c5bcc787e586b7d6dd8dee2d10.1628174048.git.leonro@nvidia.com>
In-Reply-To: <bf73a78a5074d1c5bcc787e586b7d6dd8dee2d10.1628174048.git.leonro@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, leonro@nvidia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu,  5 Aug 2021 17:34:28 +0300 you wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Don't progress with adding and deleting ports as long as devlink
> reload is running.
> 
> Fixes: 23809a726c0d ("netdevsim: Forbid devlink reload when adding or deleting ports")
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next] netdevsim: Protect both reload_down and reload_up paths
    https://git.kernel.org/netdev/net-next/c/5c0418ed1610

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


