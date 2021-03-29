Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFE9734DC90
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 01:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbhC2Xkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 19:40:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:42060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230248AbhC2XkM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 19:40:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2C4F561997;
        Mon, 29 Mar 2021 23:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617061212;
        bh=6c6p/K+R2gO7iA+JZoL8DeYj7Bpzn7aO8LnvgQmXGfg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hl00URewKF/EVCwlp03+q3+cGgblcKVTcjZ9HHjA94FzQQENgNH9l31QQtpzFtqNz
         iTltVX/ZwMAVlS0fEUdqRT0hcjDhDAn+LR145aAPqmmkU3GCv1/q+NGhtzMTg7uTOr
         Q/LwTG7TEmhu47hsWoyS7pkzOA/SL7NlpqgdEe02jtLpdDUF3L83+R/t5VL3ua7xMd
         mYih5umz4nl99WegHv38fpp45sPO4nyvQAibURAugQ5mS1zww5pEiUefjkMeLM96Mf
         lqZGit+2FLJ/YtO8WopGjJ2A8j07R6VictGEPuC3Dd8R2/Z6Q6q43E8P2GkEdWBBev
         3EtRfjwe+9cOA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1DCFB60A1B;
        Mon, 29 Mar 2021 23:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ip6_vti: proper dev_{hold|put} in ndo_[un]init
 methods
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161706121211.22281.11947480877422671543.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Mar 2021 23:40:12 +0000
References: <20210329191254.137053-1-eric.dumazet@gmail.com>
In-Reply-To: <20210329191254.137053-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 29 Mar 2021 12:12:54 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> After adopting CONFIG_PCPU_DEV_REFCNT=n option, syzbot was able to trigger
> a warning [1]
> 
> Issue here is that:
> 
> [...]

Here is the summary with links:
  - [net-next] ip6_vti: proper dev_{hold|put} in ndo_[un]init methods
    https://git.kernel.org/netdev/net-next/c/40cb881b5aaa

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


