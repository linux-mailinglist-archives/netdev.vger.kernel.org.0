Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4943D135D
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 18:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232116AbhGUP3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 11:29:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:54340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231732AbhGUP33 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 11:29:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 01F4661248;
        Wed, 21 Jul 2021 16:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626883806;
        bh=Pg7H/umzlvnoHz+MpoMegh8jJcUFnM/82BDXIQojjCw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=I47R9nMBO3HKk1C1POjOBUlUfhVIkVAtmy8rT1+BqAtJgGxg0y+AoC+ptHqvqnTzA
         +MypRYcZno61mGsS8wKSBW9Q1UbiP6DATaAWrv7nLsX9cr5wZ3tfymtWImEXWHrxBE
         2SD4Q1JRKDN1WVxH+H7N0YxVTbfon/CFa8yifmFzGlpTBMxTj69FNgyzByVcNrwmw5
         P2NqmiTX2V6LS0BEXYjL7kiNj7JVT86T+qnhfgVg8QcsrWlkKLEYXN5xHIO6krd4mS
         jweXu672R0sz7C4XQk2e4vxM2/U0oEvNbj3zSMUL2NKIYxtQcQB8qfD/P8gzDK9gFd
         ckq/zdBmbDaEA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EC18360D2F;
        Wed, 21 Jul 2021 16:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tcp: avoid indirect call in tcp_new_space()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162688380596.30339.2184077317042584936.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Jul 2021 16:10:05 +0000
References: <20210721090614.68297-1-eric.dumazet@gmail.com>
In-Reply-To: <20210721090614.68297-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 21 Jul 2021 02:06:14 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> For tcp sockets, sk->sk_write_space is most probably sk_stream_write_space().
> 
> Other sk->sk_write_space() calls in TCP are slow path and do not deserve
> any change.
> 
> [...]

Here is the summary with links:
  - [net-next] tcp: avoid indirect call in tcp_new_space()
    https://git.kernel.org/netdev/net-next/c/739b2adf99e9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


