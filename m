Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98BBD34F59B
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 02:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233090AbhCaAuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 20:50:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:37808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232883AbhCaAuK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 20:50:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D2817619DB;
        Wed, 31 Mar 2021 00:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617151809;
        bh=Rj5kyax0oRrJSwxVrB0DmuTHLjaUVZ3Fldy1o44zbL0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Tg0u0BGSJ3ebPr/9e0LjULwbZkStsHepj5puNpfPWY+8kX73I6pgWTHno966sp9rG
         m81OH1ZjGD+KBmOEPof+8qEaDtBmmqGC7Ay5tjhZD8/U/iTiUDr76PFR84IzBf/3cX
         FQA3G1LqWhg2Er6X1IPF196w5H2sX/8f/atsPRxy9BlEdvXa73dnDgToDTqe3BuRFL
         QENvKdfVwPK827oV+DXjjF+/hX5GbJgPBtaAObEzzW/Kuvi5VmrYuQNWCjVuXT0LW+
         B1OPEkE30TyRWJcV+kWvFhnHhNxHE457kJLCPvfXqfSgcA7sosGA72O/Q2b8AEhleA
         fkBXAGjR8WAeQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CD16C60A56;
        Wed, 31 Mar 2021 00:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] MPTCP: Allow initial subflow to be disconnected
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161715180983.15741.2464125249248249842.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Mar 2021 00:50:09 +0000
References: <20210331000856.117636-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20210331000856.117636-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 30 Mar 2021 17:08:50 -0700 you wrote:
> An MPTCP connection is aggregated from multiple TCP subflows, and can
> involve multiple IP addresses on either peer. The addresses used in the
> initial subflow connection are assigned address id 0 on each side of the
> link. More addresses can be added and shared with the peer using address
> IDs of 1 or larger. MPTCP in Linux shares non-zero address IDs across
> all MPTCP connections in a net namespace, which allows userspace to
> manage subflow connections across a number of sockets. However, this
> makes the address with id 0 a special case, since the IP address
> associated with id 0 is potentially different for each socket.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] mptcp: remove all subflows involving id 0 address
    https://git.kernel.org/netdev/net-next/c/774c8a8dcb3c
  - [net-next,2/6] mptcp: unify RM_ADDR and RM_SUBFLOW receiving
    https://git.kernel.org/netdev/net-next/c/9f12e97bf16c
  - [net-next,3/6] mptcp: remove id 0 address
    https://git.kernel.org/netdev/net-next/c/740d798e8767
  - [net-next,4/6] selftests: mptcp: avoid calling pm_nl_ctl with bad IDs
    https://git.kernel.org/netdev/net-next/c/6254ad408820
  - [net-next,5/6] selftests: mptcp: add addr argument for del_addr
    https://git.kernel.org/netdev/net-next/c/2d121c9a882a
  - [net-next,6/6] selftests: mptcp: remove id 0 address testcases
    https://git.kernel.org/netdev/net-next/c/5e287fe76149

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


