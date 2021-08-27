Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF0F53F96AA
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 11:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244573AbhH0JLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 05:11:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233099AbhH0JLQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 05:11:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E4BDA60FF2;
        Fri, 27 Aug 2021 09:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630055427;
        bh=DN8SIhnC2OBFgSTBBAck+YIIlkBIE+R7YpdeCAGBxew=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=D2S6+5npob4kv0D/t4Wts6b34+ZgePD8zFLMhmTIh7BgQO4ZN7vxl1f4Nww3tKRzE
         GWcM5UtzxAjVQ8LLCiGSDW50JPH3I4i49+l2857+Sk4nV4ZZh49TknjJKKxv5cKoBF
         9w2LGp48Js74mJyyYNTxwh3g5sW7P5eMFXUQxgRUWsKQFdUrxVBiHM3b8EtmOBg6Ab
         em7JOUfwOOTyoLz3C7ZeXe8XKzRAVjxPkcJbABEpOJ7GCrdQ72YGFjP7fDmV+LoeMe
         Wd13faGgdevqc2OWUT9FB1oAh8Xmb/meugWtBcwXZv8gdjtzUlhHlwj+xKWFvQ4WsG
         tn/lK6QQBQPlg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DF7EC60A27;
        Fri, 27 Aug 2021 09:10:27 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] mptcp: Optimize received options handling
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163005542791.19735.1536175440276667634.git-patchwork-notify@kernel.org>
Date:   Fri, 27 Aug 2021 09:10:27 +0000
References: <20210827004455.286754-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20210827004455.286754-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev,
        pabeni@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 26 Aug 2021 17:44:49 -0700 you wrote:
> These patches optimize received MPTCP option handling in terms of both
> storage and fewer conditionals to evaluate in common cases, and also add
> a couple of cleanup patches.
> 
> Patches 1 and 5 do some cleanup in checksum option parsing and
> clarification of lock handling.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] mptcp: do not set unconditionally csum_reqd on incoming opt
    https://git.kernel.org/netdev/net-next/c/8d548ea1dd15
  - [net-next,2/5] mptcp: better binary layout for mptcp_options_received
    https://git.kernel.org/netdev/net-next/c/a086aebae0eb
  - [net-next,3/5] mptcp: consolidate in_opt sub-options fields in a bitmask
    https://git.kernel.org/netdev/net-next/c/74c7dfbee3e1
  - [net-next,4/5] mptcp: optimize the input options processing
    https://git.kernel.org/netdev/net-next/c/f6c2ef59bcc7
  - [net-next,5/5] mptcp: make the locking tx schema more readable
    https://git.kernel.org/netdev/net-next/c/9758f40e90f7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


