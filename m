Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33F163D5050
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 00:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbhGYV3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 17:29:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:57422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229531AbhGYV3f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Jul 2021 17:29:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 35FBA60F11;
        Sun, 25 Jul 2021 22:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627251005;
        bh=QBSE7rRqRKN0MGGDMjyQA0/NyP43efo5OSUF1vG2eGU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c+mAbQVeFZLvQChv6k81R3xzcKNHtjqA2tBdTCVfU3OOoczjVgs0gkiHUQiLV9+6O
         83Dx/LrlLX4oxOsKqZlXxYyv+t71c7HWhZCgSDG/p9KxvY1dGI3OVolX7WlklXehcc
         fjJVfu/WBwZlHsThk7Kq3qqtqTP8LEq3lwIuc/Hgzxro9QUhhEUPJOpE4wYhxk4CDa
         eE4UfgJF/YEzWXZEqymP9Ibn7Rg/+zda6Ji3voOUjQDIglqb4m/mfWgByapyER5S5H
         eCOdMjUDbR2Z2JOpX600brcUObGPf3g2GV5WnhorKS6jSHwLbiomkubxCIXXQEPKnV
         r3fOgV9CIeqVg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 29D5360A3A;
        Sun, 25 Jul 2021 22:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv2 net 0/2] sctp: improve the pmtu probe in Search Complete
 state
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162725100516.14953.14806239089098913539.git-patchwork-notify@kernel.org>
Date:   Sun, 25 Jul 2021 22:10:05 +0000
References: <cover.1627234857.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1627234857.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Sun, 25 Jul 2021 13:42:49 -0400 you wrote:
> Timo recently suggested to use the loss of (data) packets as
> indication to send pmtu probe for Search Complete state, which
> should also be implied by RFC8899. This patchset is to change
> the current one that is doing probe with current pmtu all the
> time.
> 
> v1->v2:
>   - see Patch 2/2.
> 
> [...]

Here is the summary with links:
  - [PATCHv2,net,1/2] sctp: improve the code for pmtu probe send and recv update
    https://git.kernel.org/netdev/net/c/058e6e0ed0ea
  - [PATCHv2,net,2/2] sctp: send pmtu probe only if packet loss in Search Complete state
    https://git.kernel.org/netdev/net/c/eacf078cf4c7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


