Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7A673CF8DB
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 13:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236024AbhGTKuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 06:50:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:44444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237897AbhGTKt0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 06:49:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0646D60FF2;
        Tue, 20 Jul 2021 11:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626780605;
        bh=JyufMXr5dAtrmUI+bavrkHjAoD6luLCTAALyAqRLbkc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TIJoM9vEFPmsmrJ5PF8afDLc64vdKDNENTom7c0G7nPc38+palhNoVVEUrQo2c0oT
         5S5lLnl+Kr6NjUCwYFNRploVjLheRtdUB+355HNFz2gAhaVK7wd2h3GVmR38+t1/ah
         JFd0HNvHQnnz4vSzO7miSTqu2l/beJVPNAgkLPp+JJV77JZL2p8+6aoVYUUIrym02v
         nqN7lUCpv9/mS1vZ1bkzvOdWAzolFYInCI44xe4yFaNrhP/PoOyq6quQFITlxCq94l
         1mougjy3Ft9EgfFcBuFB6PuCjPxHg3z7YqhTg/IQagvMhOLmXl4/AH5mPzxKLVJPx9
         zgtsKrGcp7OJw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id ECC3C60A4E;
        Tue, 20 Jul 2021 11:30:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/tcp_fastopen: remove tcp_fastopen_ctx_lock
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162678060496.25865.16134624249926173120.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Jul 2021 11:30:04 +0000
References: <20210719101107.3203943-1-eric.dumazet@gmail.com>
In-Reply-To: <20210719101107.3203943-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, weiwan@google.com, ycheng@google.com,
        ncardwell@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 19 Jul 2021 03:11:07 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Remove the (per netns) spinlock in favor of xchg() atomic operations.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Wei Wang <weiwan@google.com>
> Cc: Yuchung Cheng <ycheng@google.com>
> Cc: Neal Cardwell <ncardwell@google.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net/tcp_fastopen: remove tcp_fastopen_ctx_lock
    https://git.kernel.org/netdev/net-next/c/e93abb840a2c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


