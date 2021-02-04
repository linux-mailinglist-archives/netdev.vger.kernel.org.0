Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 032EF30EB5A
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 05:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232798AbhBDEBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 23:01:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:33436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231475AbhBDEAv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 23:00:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id D499264F65;
        Thu,  4 Feb 2021 04:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612411208;
        bh=qqDcHdTENZVjyWYjvOxwOvYYxvPFCKKqcKSd3kVNFus=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lNTHQfZ7uyiycJMwuKnSXjHxCf9wYW1v+nYI3xSfaWra2maJCeVIV2QRpRseO8Pcs
         EaRw4iJfyCwQmUQl8EXnTSHcE1uGTzTvMU/P46EoPID9THn1qMt1b7ml3plSlf7gbb
         MizpWH1WQRdlOaSErAsxbvxgbO0LoiU2UhkQRJvpGORs/DmmQ+Ym59BJGRPiujtD2s
         /0MEwhybCRulJfHd6msoJbnVKtLozpGvmBbY97iwOmB8GhW4xxBebttKTbdOyPGKWv
         qyPiyut6lB8xpLP18r38+6TSwX0M+cqC/UGwKImeHmIfWq8vSyn2x7+OSgJNHpZrm6
         SCK//QHX6ltfw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C3602609EE;
        Thu,  4 Feb 2021 04:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tcp: use a smaller percpu_counter batch size for
 sk_alloc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161241120879.9496.5809684422287396150.git-patchwork-notify@kernel.org>
Date:   Thu, 04 Feb 2021 04:00:08 +0000
References: <20210202193408.1171634-1-weiwan@google.com>
In-Reply-To: <20210202193408.1171634-1-weiwan@google.com>
To:     Wei Wang <weiwan@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, soheil@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue,  2 Feb 2021 11:34:08 -0800 you wrote:
> Currently, a percpu_counter with the default batch size (2*nr_cpus) is
> used to record the total # of active sockets per protocol. This means
> sk_sockets_allocated_read_positive() could be off by +/-2*(nr_cpus^2).
> This under/over-estimation could lead to wrong memory suppression
> conditions in __sk_raise_mem_allocated().
> Fix this by using a more reasonable fixed batch size of 16.
> 
> [...]

Here is the summary with links:
  - [net-next] tcp: use a smaller percpu_counter batch size for sk_alloc
    https://git.kernel.org/netdev/net-next/c/f5a5589c7250

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


