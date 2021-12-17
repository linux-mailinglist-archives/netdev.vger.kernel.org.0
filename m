Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFE0547895C
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 12:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235194AbhLQLAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 06:00:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235165AbhLQLAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 06:00:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE3A8C06173E;
        Fri, 17 Dec 2021 03:00:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 981CCB82793;
        Fri, 17 Dec 2021 11:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 34192C36AEA;
        Fri, 17 Dec 2021 11:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639738811;
        bh=FAiZPX3NutRx5szY1SNt30UH3643hwlmhU8iAuLK5SI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Wi2XQv/7oIGHohUfSMr3VIei8kiThnZlRf1JtkY8cf5L5Bni2gg0oerszIZODMod9
         pWvCg5khLCQ+nqHR89xV50NoT6xfVHOFxPC+iKeD4TBPfTgDBULioOa8UMz6wYDNK9
         ppuDSWn6xxInlGR6Km20cMwgNuZ3nITdnpyR0efhIihbn+cSGGxENKpAf9CmXL3w1x
         zsx00GhIHZTGR24wS4WStt/U6DmNKwFmUPSih4rwXRveSL3ShEBXghoyTIvoMKGdKO
         GvbOrUjHLy62oQHTEHqF3SQkx/qVZf/b0dISpmanxxbU2V4wFNe5Qxi7XYN1/WJZXH
         YRZ0+Jfh3ScsA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1EAEF60A39;
        Fri, 17 Dec 2021 11:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/3] netfilter: nf_tables: fix use-after-free in
 nft_set_catchall_destroy()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163973881112.21643.5395709598532631747.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Dec 2021 11:00:11 +0000
References: <20211217085303.363401-2-pablo@netfilter.org>
In-Reply-To: <20211217085303.363401-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Fri, 17 Dec 2021 09:53:01 +0100 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> We need to use list_for_each_entry_safe() iterator
> because we can not access @catchall after kfree_rcu() call.
> 
> syzbot reported:
> 
> [...]

Here is the summary with links:
  - [net,1/3] netfilter: nf_tables: fix use-after-free in nft_set_catchall_destroy()
    https://git.kernel.org/netdev/net/c/0f7d9b31ce7a
  - [net,2/3] netfilter: fix regression in looped (broad|multi)cast's MAC handling
    https://git.kernel.org/netdev/net/c/ebb966d3bdfe
  - [net,3/3] netfilter: ctnetlink: remove expired entries first
    https://git.kernel.org/netdev/net/c/76f12e632a15

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


