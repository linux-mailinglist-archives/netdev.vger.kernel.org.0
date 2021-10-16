Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60C66430109
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 10:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239888AbhJPIER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 04:04:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:55588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239864AbhJPICc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Oct 2021 04:02:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 025C661244;
        Sat, 16 Oct 2021 08:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634371215;
        bh=ZEPn5OsqZu5MnpAkh37F3xxeNxYG4z8TyOIfCOg1IfY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TkUORlTK2am4sGHkKqgSj4/QAbrXkAVAoPDOGvgc1vkL5ft2GmQ3p5URnZezZvWts
         g3A4tuZES9juuHJKLedv+bD5NdFTXjed9xKDTvye+VJq7F8J/X1irPcjOg8I3GFpn3
         9XosoTi74HyWyadFYNsYjLzGN5oAAvr3C830GTBJhH35zupLBdm34tOiouPawPMyUd
         JdSoD3NpnXuO1gfKPCeWWPZQwn2Jr+Iq325sMyMX8DueTCD+2ekzsi5ocwZwx6Nfa+
         GPDypn6bk8OhDZzfSmBpZib4SigFl2Xe75eAxWt6Ngbq/oy9fo1qZt+c0uvuTJIc49
         RYmXODtAUhOQQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EC18F60A45;
        Sat, 16 Oct 2021 08:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] mptcp: A few fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163437121496.28528.18174688104216932985.git-patchwork-notify@kernel.org>
Date:   Sat, 16 Oct 2021 08:00:14 +0000
References: <20211015230552.24119-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20211015230552.24119-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 15 Oct 2021 16:05:49 -0700 you wrote:
> This set has three separate changes for the net-next tree:
> 
> Patch 1 guarantees safe handling and a warning if a NULL value is
> encountered when gathering subflow data for the MPTCP_SUBFLOW_ADDRS
> socket option.
> 
> Patch 2 increases the default number of subflows allowed per MPTCP
> connection.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] mptcp: Avoid NULL dereference in mptcp_getsockopt_subflow_addrs()
    https://git.kernel.org/netdev/net-next/c/29211e7db28a
  - [net-next,2/3] mptcp: increase default max additional subflows to 2
    https://git.kernel.org/netdev/net-next/c/72bcbc46a5c3
  - [net-next,3/3] mptcp: Make mptcp_pm_nl_mp_prio_send_ack() static
    https://git.kernel.org/netdev/net-next/c/3828c514726f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


