Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB0A3423FEE
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 16:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238842AbhJFOWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 10:22:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:35292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231356AbhJFOV7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 10:21:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 796B161175;
        Wed,  6 Oct 2021 14:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633530007;
        bh=rbT74djIOv887x+6qf4XDuom29y/QFERlFVyc9goXcs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mvqwzXuwTYvOEcNWUbnRi03m2K6BsF456RtNM9AeNu6jbD28Jr1A3ajsvKngeZc4r
         xdMi+rspquAxzcysoABhgxovJXI3Hn/XmUzOv61kEAtrEwQGw8nDJ752PKscQZ2erm
         Igof7g9MzTmBQ1HmLOnyERldpYv8Cnbs3M+/jNm1oSk2Y56KOtAo0i8mQrghbu1fZ8
         ZXkEvqaak0jbmeehB7pc7Uul0H5NbJjbqbdvvjn8ENaoKZwE8vGd9QyEqnBAg8S2ZG
         sxoual4yEJGn1syCbKys9pm47YlnFahlGR+xaJJoePJZPgwZ76Vgtl6Jeai2jTmapo
         T5zs4X9iEJ7UA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6A1B460A44;
        Wed,  6 Oct 2021 14:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] gve: report 64bit tx_bytes counter from
 gve_handle_report_stats()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163353000743.15249.1126847831709512915.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Oct 2021 14:20:07 +0000
References: <20211006010138.3215494-1-eric.dumazet@gmail.com>
In-Reply-To: <20211006010138.3215494-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, yangchun@google.com, kuozhao@google.com,
        awogbemila@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue,  5 Oct 2021 18:01:38 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Each tx queue maintains a 64bit counter for bytes, there is
> no reason to truncate this to 32bit (or this has not been
> documented)
> 
> Fixes: 24aeb56f2d38 ("gve: Add Gvnic stats AQ command and ethtool show/set-priv-flags.")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Yangchun Fu <yangchun@google.com>
> Cc: Kuo Zhao <kuozhao@google.com>
> Cc: David Awogbemila <awogbemila@google.com>
> 
> [...]

Here is the summary with links:
  - [net] gve: report 64bit tx_bytes counter from gve_handle_report_stats()
    https://git.kernel.org/netdev/net/c/17c37d748f2b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


