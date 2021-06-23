Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0003B2226
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 23:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbhFWVCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 17:02:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:53082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229759AbhFWVCW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 17:02:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C82B1611C9;
        Wed, 23 Jun 2021 21:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624482004;
        bh=w0IqsTms+4ZGzhKDpT91oCiD++vSRwOYUWpCKU0qcio=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SJXewC5F3VkwgvSS0uHSca5E5mG6vcn6lc4O83GDt80+xn1k7zJoRUlbq5z++0F7y
         +FIJy2JI98pZvt3EYbE4WLqLnlyN+VejUnAf63jRtup/cqh2FSMmNTWOb7FJN9eqzV
         0m2KV8FbrrE8mDSQWmeuhPu2F9OQTkb9nH4B3HRU7j+DrDz9N5GBUiMow9qH8IBZbY
         tAMEO37I5cJtt39LVjDAvE3OfN31SjqAwGj/5C4KYYQSdEhVdBEAWlSgpZhlpOC02c
         GPWor5xH9/7tkPNMM3JIS4OvbZBkTKvkLb+7Wmvk+cnUu4rTsfPCCr+9726cdJfGtZ
         arRtrpaeM5HvQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BC48D6094F;
        Wed, 23 Jun 2021 21:00:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/tls: Remove the __TLS_DEC_STATS() macro.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162448200476.24119.2272209798103737013.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Jun 2021 21:00:04 +0000
References: <20210623060634.1909-1-kuniyu@amazon.co.jp>
In-Reply-To: <20210623060634.1909-1-kuniyu@amazon.co.jp>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        borisp@nvidia.com, john.fastabend@gmail.com, daniel@iogearbox.net,
        kuba@kernel.org, davem@davemloft.net, kuni1840@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 23 Jun 2021 15:06:34 +0900 you wrote:
> The commit d26b698dd3cd ("net/tls: add skeleton of MIB statistics")
> introduced __TLS_DEC_STATS(), but it is not used and __SNMP_DEC_STATS() is
> not defined also. Let's remove it.
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> ---
> The commit d26b698dd3cd does not contain a bug, so I think Fixes tag is not
> necessary and post this to net-next. But if the tag is needed, I'll respin
> to the net tree with the tag, so please let me know.
> 
> [...]

Here is the summary with links:
  - [net-next] net/tls: Remove the __TLS_DEC_STATS() macro.
    https://git.kernel.org/netdev/net-next/c/10ed7ce42b13

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


