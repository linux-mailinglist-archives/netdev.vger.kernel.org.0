Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 582EB479AC7
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 13:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233022AbhLRMkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 07:40:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41236 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231977AbhLRMkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 07:40:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9FF67B8090C;
        Sat, 18 Dec 2021 12:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 59F3DC36AE9;
        Sat, 18 Dec 2021 12:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639831210;
        bh=Trl7jHTB+8QuTzkro1rMa+4fIXjgNwzXXAh/9idte5E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c85CcT7g7kaeiDgA+iD9ygldGqLHJmJ8MkU0yZdEDQj/YRwuQvzMhb6681sQu5GgU
         dVAJ7r2dTife8gRIfEw2afnwrLSRAwcDHClO7EMH5yxMJ+LRMvMXcEAUJhXagmSa6G
         Ttu8pPKURCRYyiBKtt4leev1TKEcF8jMkxsSAPtCYUsUDZTrqCNPXGpicWpuR0uG/t
         O+VQk8oaL178xqPqWyg7LaLvYZTc8kes5+hARNKI0+OZmhSidO54LXWUb7seWhzJd0
         0sdOKzwvhBoqkZlOPRBS4+gs4ZgJGucpukkiq8qyEZLNr1HmsGNb09A2Vjj1wmmPH6
         zYQ3mE0Nx+0XQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 386A260AA5;
        Sat, 18 Dec 2021 12:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v0] hamradio: improve the incomplete fix to avoid NPD
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163983121022.1461.3449970746025868709.git-patchwork-notify@kernel.org>
Date:   Sat, 18 Dec 2021 12:40:10 +0000
References: <20211217021356.27322-1-linma@zju.edu.cn>
In-Reply-To: <20211217021356.27322-1-linma@zju.edu.cn>
To:     Lin Ma <linma@zju.edu.cn>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jirislaby@kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 17 Dec 2021 10:13:56 +0800 you wrote:
> The previous commit 3e0588c291d6 ("hamradio: defer ax25 kfree after
> unregister_netdev") reorder the kfree operations and unregister_netdev
> operation to prevent UAF.
> 
> This commit improves the previous one by also deferring the nullify of
> the ax->tty pointer. Otherwise, a NULL pointer dereference bug occurs.
> Partial of the stack trace is shown below.
> 
> [...]

Here is the summary with links:
  - [v0] hamradio: improve the incomplete fix to avoid NPD
    https://git.kernel.org/netdev/net/c/b2f37aead1b8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


