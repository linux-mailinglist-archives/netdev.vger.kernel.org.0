Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3553D315AC2
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 01:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235133AbhBJALC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 19:11:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:59210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234655AbhBJABw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 19:01:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 1AA1C64E3E;
        Wed, 10 Feb 2021 00:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612915207;
        bh=x5pgBcqbG3lwUZrHwM0Zz0D9SDwqthOib1BhLMs1HPQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=D3tX3VjKrna1kkiMcIW0c4CH+I3rkFSWqMH0F5F0fnKljkkB+P02OI8TLHK1tAffq
         iFq+M+7T12jD4FSozx9an0OP+YWsGu6Vj7+23bxoH2IhR5lJ9Y47WW5wWIxM9TjUxH
         gsn2wOzkLtJSvgjSTHFx8C9NEZmcbR3f1ZVWdkydDuzjQyadIdbW2gdqK3LzlFR7gJ
         3exzwH4vtYM7DMcP54JYkEOoLkMG8rP+y9CDhxrNIgmWgzXYQfmRCedSqknPffp5/Q
         RfR/uUEjDAJpdP5tY2WMBi1Z8pUR5IPvy+523RPM8RJvfH6QKcBgeroJrETLX4pTWU
         WIryiw8/O/TEQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0888B609E2;
        Wed, 10 Feb 2021 00:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] netfilter: conntrack: skip identical origin tuple in
 same zone only
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161291520703.5175.1064410390675705112.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Feb 2021 00:00:07 +0000
References: <20210209213511.23298-2-pablo@netfilter.org>
In-Reply-To: <20210209213511.23298-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Tue,  9 Feb 2021 22:35:10 +0100 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> The origin skip check needs to re-test the zone. Else, we might skip
> a colliding tuple in the reply direction.
> 
> This only occurs when using 'directional zones' where origin tuples
> reside in different zones but the reply tuples share the same zone.
> 
> [...]

Here is the summary with links:
  - [net,1/2] netfilter: conntrack: skip identical origin tuple in same zone only
    https://git.kernel.org/netdev/net/c/07998281c268
  - [net,2/2] netfilter: nftables: relax check for stateful expressions in set definition
    https://git.kernel.org/netdev/net/c/664899e85c13

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


