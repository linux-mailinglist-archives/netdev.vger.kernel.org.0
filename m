Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 326C3457EE0
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 16:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237574AbhKTPXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Nov 2021 10:23:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:40120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230038AbhKTPXM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Nov 2021 10:23:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id C775160EB6;
        Sat, 20 Nov 2021 15:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637421608;
        bh=xiYPXNCbIW7opw9+/odGLhCI2GrHIioW7Qi0gbuFvvA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LprZtN204IKe4MyxdJvFDpqKerZzsKqJD5GEuu5x9n4qoKTUwmGdg9HFYdxegT69R
         LT7KDgPJXZN8yhMU0MJAqKKmKf7qANaZ8coZ4q0lcGEu/gnJKFwSNZKalJHh6d+AQm
         i2dVwD8wnsYygLGjCbTiA2dSQTW5dMCd+iz32+RBaG3IvN0JPcOjpYtGySuqafVfc0
         eqpyGKQ5Js2s9bZJurdh9N4V3xzpRR1ExWS0HBBhN3ejzI+lUB8+V7JGMPaReMqIzG
         DX+NBvZGchzUfVKZwYWXUTB4nJzw1aCjFH7/jMkEc3E3kO9h+O/VzSClYoZxTa6ibj
         CGS7pUeul81zg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B78A46096E;
        Sat, 20 Nov 2021 15:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] af_unix: fix regression in read after shutdown
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163742160874.26850.6419902452041932137.git-patchwork-notify@kernel.org>
Date:   Sat, 20 Nov 2021 15:20:08 +0000
References: <20211119120521.18813-1-vincent.whitchurch@axis.com>
In-Reply-To: <20211119120521.18813-1-vincent.whitchurch@axis.com>
To:     Vincent Whitchurch <vincent.whitchurch@axis.com>
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kernel@axis.com,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        jiang.wang@bytedance.com, casey@schaufler-ca.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 19 Nov 2021 13:05:21 +0100 you wrote:
> On kernels before v5.15, calling read() on a unix socket after
> shutdown(SHUT_RD) or shutdown(SHUT_RDWR) would return the data
> previously written or EOF.  But now, while read() after
> shutdown(SHUT_RD) still behaves the same way, read() after
> shutdown(SHUT_RDWR) always fails with -EINVAL.
> 
> This behaviour change was apparently inadvertently introduced as part of
> a bug fix for a different regression caused by the commit adding sockmap
> support to af_unix, commit 94531cfcbe79c359 ("af_unix: Add
> unix_stream_proto for sockmap").  Those commits, for unclear reasons,
> started setting the socket state to TCP_CLOSE on shutdown(SHUT_RDWR),
> while this state change had previously only been done in
> unix_release_sock().
> 
> [...]

Here is the summary with links:
  - af_unix: fix regression in read after shutdown
    https://git.kernel.org/netdev/net/c/f9390b249c90

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


