Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 614112FCAF3
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 07:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728766AbhATGNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 01:13:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:43416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726635AbhATGKt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 01:10:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 907682313A;
        Wed, 20 Jan 2021 06:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611123008;
        bh=vEqLKtkR2irkXTsSsj1E2hW06805HjoSjJN44anLjLM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=B+/dvd6U0UR0r8wlh6Nc68MRiP6MOJFmr4AfuepSGAd9mgiAhjvKmvx6zLTQBZz4H
         LsarkFngBu9LEO8FGWU9pI0dRNLbjTmdOpc/5dE9E4tMqFIpo/+u5RgOh+okUX1suF
         OKj7jUls3AVMPXqgiyE4qOC3jA9StknV+hqzjO9X8VotlWXp7h98FnH/0D0jjHUPxC
         5nj1gJNsYI48mFjeEouZQuke0yjxjxMAl2Aa/eyDn8vgHYjLTtksHZXZLUd+EiZJVM
         j+JxzQml3KQQeisEvIP1RdXdeP0YF7Q/YbAk/7Jm17D+e5Qfv6KKp/FqEYZnkwxcCq
         a+wi+k+J2Bvsw==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 7C15C60591;
        Wed, 20 Jan 2021 06:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tcp: fix TCP socket rehash stats mis-accounting
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161112300850.30718.6755558846838498048.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Jan 2021 06:10:08 +0000
References: <20210119192619.1848270-1-ycheng@google.com>
In-Reply-To: <20210119192619.1848270-1-ycheng@google.com>
To:     Yuchung Cheng <ycheng@google.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        ncardwell@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 19 Jan 2021 11:26:19 -0800 you wrote:
> The previous commit 32efcc06d2a1 ("tcp: export count for rehash attempts")
> would mis-account rehashing SNMP and socket stats:
> 
>   a. During handshake of an active open, only counts the first
>      SYN timeout
> 
>   b. After handshake of passive and active open, stop updating
>      after (roughly) TCP_RETRIES1 recurring RTOs
> 
> [...]

Here is the summary with links:
  - [net] tcp: fix TCP socket rehash stats mis-accounting
    https://git.kernel.org/netdev/net/c/9c30ae8398b0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


