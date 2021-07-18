Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C355F3CC9EF
	for <lists+netdev@lfdr.de>; Sun, 18 Jul 2021 18:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbhGRQxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 12:53:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:43308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229462AbhGRQxD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Jul 2021 12:53:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1DAB7611AC;
        Sun, 18 Jul 2021 16:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626627005;
        bh=JurD5D7pfuCrz+tCB3Kzs1ObQ3U+2K4fomNqLmFEISA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AoP9oq0RC7igTw0BohIhODZmJYq6IQksEbdMg1dNDJUgiYAu8bg8HFUMToVKE8DiJ
         8pq8n08NC7/lFJTX4wQ72vUlMOb5Xdj2thB81MXZwF2/ZacK/4+UThiWBTdpcwN37u
         Sp24ovpPFUTWIdUrgY/k9zQa/19/CaFXgyc0VncXoY/TZ7R2g9+xUis4ptEYQ4iCRO
         p3UU/qr03CPocSLIZoSl1R7h50w0n8atfq/U0bzDJewGXhqF9Ndw0BJdxEQzEtAOZF
         CHsuw60c1opwFwk25h0CA1O2ODSzSY4tWJmocjXdxSKgeqVSNVXhLrydBHqF16/dQ1
         ifqA5jYuHQCgg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 130D460C2A;
        Sun, 18 Jul 2021 16:50:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: Fix zero-copy head len calculation.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162662700507.19662.10699892246676349862.git-patchwork-notify@kernel.org>
Date:   Sun, 18 Jul 2021 16:50:05 +0000
References: <20210715235900.1715962-1-pravin.ovn@gmail.com>
In-Reply-To: <20210715235900.1715962-1-pravin.ovn@gmail.com>
To:     Pravin B Shelar <pravin.ovn@gmail.com>
Cc:     netdev@vger.kernel.org, pbshelar@fb.com, pshelar@ovn.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 15 Jul 2021 16:59:00 -0700 you wrote:
> From: Pravin B Shelar <pshelar@ovn.org>
> 
> In some cases skb head could be locked and entire header
> data is pulled from skb. When skb_zerocopy() called in such cases,
> following BUG is triggered. This patch fixes it by copying entire
> skb in such cases.
> This could be optimized incase this is performance bottleneck.
> 
> [...]

Here is the summary with links:
  - net: Fix zero-copy head len calculation.
    https://git.kernel.org/netdev/net/c/a17ad0961706

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


