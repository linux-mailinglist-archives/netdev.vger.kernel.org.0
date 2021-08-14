Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0849C3EC246
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 13:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238199AbhHNLKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 07:10:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237914AbhHNLKe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Aug 2021 07:10:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2523160F36;
        Sat, 14 Aug 2021 11:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628939406;
        bh=aBU6dWQ2IKty6RaQTb9WpDdzwoX1BUKU09U+8zYkOFY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=t3gMUjsVp1ny8cUGGnzDVsETLjaRCrE4wUmCk3yT2SilCDM+D/mJ5dYlCRhTJo/SP
         ttRTemNqJcDlZIbiBY6BKWFr06ym8yDGJNzTO55jFqIjVrXu9GFjoQPiD1sMKEtpSB
         4nwINgqfgxLc7clOVCuIHdlmy/zGq/SF8DLrSHOVpxJMbEds3UPsyT0oNQmhjtMmAZ
         j4Zfo+f5m4KKl2SvNgaqljQEjlDydy9EJimAZp4+uHL3KB1dcDAFf1cVUmZfhFwHAg
         jyWsuCCf19Dr+UC8LL8ltPbzetdSEZhTSV1qotrkNgPMpcjfRdSNTuJd+kAARmif3v
         odJuSpTr+pR2A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1874260A9C;
        Sat, 14 Aug 2021 11:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/8] mptcp: Improve use of backup subflows
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162893940609.15993.1576871199881701981.git-patchwork-notify@kernel.org>
Date:   Sat, 14 Aug 2021 11:10:06 +0000
References: <20210813221548.111990-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20210813221548.111990-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev,
        pabeni@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 13 Aug 2021 15:15:40 -0700 you wrote:
> Multipath TCP combines multiple TCP subflows in to one stream, and the
> MPTCP-level socket must decide which subflow to use when sending (or
> resending) chunks of data. The choice of the "best" subflow to transmit
> on can vary depending on the priority (normal or backup) for each
> subflow and how well the subflow is performing.
> 
> In order to improve MPTCP performance when some subflows are failing,
> this patch set changes how backup subflows are utilized and introduces
> tracking of "stale" subflows that are still connected but not making
> progress.
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] mptcp: more accurate timeout
    https://git.kernel.org/netdev/net-next/c/33d41c9cd74c
  - [net-next,2/8] mptcp: less aggressive retransmission strategy
    https://git.kernel.org/netdev/net-next/c/71b7dec27f34
  - [net-next,3/8] mptcp: handle pending data on closed subflow
    https://git.kernel.org/netdev/net-next/c/1e1d9d6f119c
  - [net-next,4/8] mptcp: cleanup sysctl data and helpers
    https://git.kernel.org/netdev/net-next/c/6da14d74e2bd
  - [net-next,5/8] mptcp: faster active backup recovery
    https://git.kernel.org/netdev/net-next/c/ff5a0b421cb2
  - [net-next,6/8] mptcp: add mibs for stale subflows processing
    https://git.kernel.org/netdev/net-next/c/fc1b4e3b6274
  - [net-next,7/8] mptcp: backup flag from incoming MPJ ack option
    https://git.kernel.org/netdev/net-next/c/0460ce229f5b
  - [net-next,8/8] selftests: mptcp: add testcase for active-back
    https://git.kernel.org/netdev/net-next/c/7d1e6f163904

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


