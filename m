Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8F3C3A36AB
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 23:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbhFJVwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 17:52:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:56236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230313AbhFJVwE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 17:52:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0CE0261419;
        Thu, 10 Jun 2021 21:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623361806;
        bh=Y0DguIRmoFPW9TbDsIspKOg73j+FJjyfEoBa7Pgpm8Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FxE69p64dKPvHBEnJvj8Uq04Gt9CF5anZkJ08fPtVIy6LXZxc/NP+5IqZcGnT1J8+
         ArvSfuPxDeFZNBm9v6iaHjorNbiEE2WO8FPxNkcFKM4MEQyNOSlNiEKTfSN4jZnxpq
         XgE6vdOldMTYvkagvOk3XiCAEJWboWUDNJ/tpMm/Oh63grl9FVm7eFzM51H9A6wmZe
         IZ9Kn3pn2c0PCki/EXjKsmEvINZ0zj1uSqoKAR/T4hJ+G8zRqVrvkG6mFLYKPs3WP4
         Iz2I92hwyz+jIONY1/7aEwUSQrsH4vyIwJ2A6fFVGRtCXfoMkwiIqEn3YiptQpsr1d
         4ZhXvKV98GOzQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0428D60CE4;
        Thu, 10 Jun 2021 21:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] inet: annotate date races around sk->sk_txhash
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162336180601.29138.6074843762704065991.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Jun 2021 21:50:06 +0000
References: <20210610144411.1414221-1-eric.dumazet@gmail.com>
In-Reply-To: <20210610144411.1414221-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, syzkaller@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 10 Jun 2021 07:44:11 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> UDP sendmsg() path can be lockless, it is possible for another
> thread to re-connect an change sk->sk_txhash under us.
> 
> There is no serious impact, but we can use READ_ONCE()/WRITE_ONCE()
> pair to document the race.
> 
> [...]

Here is the summary with links:
  - [net] inet: annotate date races around sk->sk_txhash
    https://git.kernel.org/netdev/net/c/b71eaed8c04f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


