Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71BD332FE47
	for <lists+netdev@lfdr.de>; Sun,  7 Mar 2021 02:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbhCGBKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Mar 2021 20:10:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:58694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229801AbhCGBKJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Mar 2021 20:10:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 2BBC3650BB;
        Sun,  7 Mar 2021 01:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615079409;
        bh=D79dnA2w8+WJUsJ1wD407bTwhi+OREGS0D/TodV7AIg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PXExKo49RckYthExZ0bKs4zoQBf7mtq+VomJKUqDqsFqqILNBo8wqlPONJRUkYPox
         2FFhbmD41u2x2qWv8ZVeC42jIN1SzxU/hArt++wPe+xbFgIPZF8tejLeUJ2E9sz/Rx
         Jp/KnErUIm0EDRJ9t9boDev/YabnGu774af9z0CPMhDfQmG+BhZtFn9GFgg0OU5Y9v
         VEH+not0pbqWpKvByL32JJXjfsqx1bq4hhxdt6+T5+j5/tVI8+TvKINr6X/1KrXLyH
         MCtrpCc57ZBeCQiyzxdVTbFn0vVmLsJMYEVkNxy7QQelVumWt5JCWQ1ksOwUhPOJ5d
         cY2sjhQcILIhw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2098860A13;
        Sun,  7 Mar 2021 01:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/9] uapi: nfnetlink_cthelper.h: fix userspace compilation
 error
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161507940912.3181.18144112634448949963.git-patchwork-notify@kernel.org>
Date:   Sun, 07 Mar 2021 01:10:09 +0000
References: <20210306121223.28711-2-pablo@netfilter.org>
In-Reply-To: <20210306121223.28711-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Sat,  6 Mar 2021 13:12:15 +0100 you wrote:
> From: "Dmitry V. Levin" <ldv@altlinux.org>
> 
> Apparently, <linux/netfilter/nfnetlink_cthelper.h> and
> <linux/netfilter/nfnetlink_acct.h> could not be included into the same
> compilation unit because of a cut-and-paste typo in the former header.
> 
> Fixes: 12f7a505331e6 ("netfilter: add user-space connection tracking helper infrastructure")
> Cc: <stable@vger.kernel.org> # v3.6
> Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [...]

Here is the summary with links:
  - [net,1/9] uapi: nfnetlink_cthelper.h: fix userspace compilation error
    https://git.kernel.org/netdev/net/c/c33cb0020ee6
  - [net,2/9] netfilter: conntrack: Remove a double space in a log message
    https://git.kernel.org/netdev/net/c/c57ea2d7d81f
  - [net,3/9] netfilter: nf_nat: undo erroneous tcp edemux lookup
    https://git.kernel.org/netdev/net/c/03a3ca37e4c6
  - [net,4/9] netfilter: conntrack: avoid misleading 'invalid' in log message
    https://git.kernel.org/netdev/net/c/07b5a76e1892
  - [net,5/9] selftests: netfilter: test nat port clash resolution interaction with tcp early demux
    https://git.kernel.org/netdev/net/c/c2c16ccba2f5
  - [net,6/9] netfilter: x_tables: gpf inside xt_find_revision()
    https://git.kernel.org/netdev/net/c/8e24edddad15
  - [net,7/9] netfilter: nftables: disallow updates on table ownership
    https://git.kernel.org/netdev/net/c/9cc0001a18b4
  - [net,8/9] netfilter: nftables: fix possible double hook unregistration with table owner
    https://git.kernel.org/netdev/net/c/2888b080d05c
  - [net,9/9] netfilter: nftables: bogus check for netlink portID with table owner
    https://git.kernel.org/netdev/net/c/bd1777b3a88f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


