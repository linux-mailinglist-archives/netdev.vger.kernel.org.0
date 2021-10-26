Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5A4943B2AF
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 14:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232718AbhJZMwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 08:52:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:51168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235896AbhJZMwb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 08:52:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6937861040;
        Tue, 26 Oct 2021 12:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635252607;
        bh=f4Tn906leEyLU5WbFC8sITQhhMZ2LEhJMLqs3VF1jXE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dI5/9L1M+75SIHYdjbXwDYS0V5j/03+Rs7ecUKy/iZx4V8tKrWrNAEZURvtnqqxI8
         a05GIvAios43WbL/gKtqRWMZ3menAKItAVQjO+wbMjeSa2Zj4QlE86M3NH64tql2Jy
         sk2nbL/9li8oxwEvzhlFWbHW+ECx3Q17feOvZS+qaIzS/9D4cWjY7l4XpLR4jyvhS1
         jP+lUT4fCL78eODZ0w2hylZwsma3PZ2OUcoYUjKJOBGVonhtZ56Lpjd9DNahzHBKvb
         ohOzZZUlVDcy46eqqYWTyW1hOpsPdQc6UxcMDBZ7u8Qye/Nc7Q5slWS8BHxDXm4JDW
         3fIAFlBk9ah4Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 63696609CC;
        Tue, 26 Oct 2021 12:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: annotate data-race in neigh_output()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163525260740.9181.15970509864261843327.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Oct 2021 12:50:07 +0000
References: <20211025181555.673034-1-eric.dumazet@gmail.com>
In-Reply-To: <20211025181555.673034-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, syzkaller@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 25 Oct 2021 11:15:55 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> neigh_output() reads n->nud_state and hh->hh_len locklessly.
> 
> This is fine, but we need to add annotations and document this.
> 
> We evaluate skip_cache first to avoid reading these fields
> if the cache has to by bypassed.
> 
> [...]

Here is the summary with links:
  - [net-next] net: annotate data-race in neigh_output()
    https://git.kernel.org/netdev/net-next/c/d18785e21386

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


