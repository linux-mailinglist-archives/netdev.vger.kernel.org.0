Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A90EB3AA497
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 21:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232978AbhFPTwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 15:52:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:55112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230402AbhFPTwL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 15:52:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EB7D26135C;
        Wed, 16 Jun 2021 19:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623873005;
        bh=bJtVT2M+B8DHVvYnVFiIXqrsqMmkxLclKXa/WLigXXQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Sg29COUURaEIn+O/hIZvxZ5/iHfIZREV1fxuBz/lwuVSJztpgdS64B79YB6IQmUp7
         N//Cf5OXhSODUtMcTnO03p8K1wZp63tOQQ6vICE/yE+f/O9HdhlWu1aX8mIImfhuZl
         AFm662K7YCBaO8yPE9XDYuBe90Vaq2eCddki6WcVQCokaG/7RuC+/gFxHvwWLVGtE7
         rlC+H/vlo8tTFLqDZvalrkoEcpopygpv8LeQ/svHTz1J+HhAUqtjUc/irLLR6ZHVGp
         zcdu+tSe1TnJzBxCtp6hA8Ky5DeImvt5n30x9/oMNH8B9HG2SU+CUjZwuSZr7IlemA
         f/E7AxOFSfKDQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E28EB60C29;
        Wed, 16 Jun 2021 19:50:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: can 2021-06-16
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162387300492.13042.9681987049571047223.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Jun 2021 19:50:04 +0000
References: <20210616110152.2456765-1-mkl@pengutronix.de>
In-Reply-To: <20210616110152.2456765-1-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Wed, 16 Jun 2021 13:01:48 +0200 you wrote:
> Hello Jakub, hello David,
> 
> this is a pull request of 4 patches for net/master.
> 
> The first patch is by Oleksij Rempel and fixes a Use-after-Free found
> by syzbot in the j1939 stack.
> 
> [...]

Here is the summary with links:
  - pull-request: can 2021-06-16
    https://git.kernel.org/netdev/net/c/e82a35aead2f
  - [net,2/4] can: bcm/raw/isotp: use per module netdevice notifier
    https://git.kernel.org/netdev/net/c/8d0caedb7596
  - [net,3/4] can: bcm: fix infoleak in struct bcm_msg_head
    https://git.kernel.org/netdev/net/c/5e87ddbe3942
  - [net,4/4] can: mcba_usb: fix memory leak in mcba_usb
    https://git.kernel.org/netdev/net/c/91c02557174b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


