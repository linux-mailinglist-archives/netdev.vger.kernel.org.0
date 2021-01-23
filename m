Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39BF33012A7
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 04:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbhAWDbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 22:31:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:47390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726598AbhAWDax (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 22:30:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 81DE523B6E;
        Sat, 23 Jan 2021 03:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611372611;
        bh=emEG2JJeWXpGyUY/R0ttteHtguWhOa7Jj3xARj3QmiM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=n/UvyuBTNOvqTTGviwqkrkXp4vzsIOA4OGFm92OuDvWg2ZkHRHP2TJAW7XbB9C33c
         LBuZFDjn+emJhf3RiWt/39l+MOD5c+WQDR13BnEKYIxuFk5rw9ZCuYK4hSSyZKIrws
         rn9RrlsqDqhww4f35Cd9wgsY670uHYkFrrynLkiZDao/DpMasaysHAxeNZqcebrQBw
         amqAufj5ZIZUapDjo5na6lmkU4HvEpgEcM/iEDk8cQ98eSXiNKXVO+Rv2znLj4yla7
         YfFFUrf3cGlwo4eIFxzgl6YYDwaILANzAAaX7Ptt1zLvjyLBn6y7Yih961mQZBtHKS
         MCnBMiYLKlt1g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7F03D604EC;
        Sat, 23 Jan 2021 03:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/5] mptcp: re-enable sndbuf autotune
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161137261151.31547.3569870182293776976.git-patchwork-notify@kernel.org>
Date:   Sat, 23 Jan 2021 03:30:11 +0000
References: <cover.1611153172.git.pabeni@redhat.com>
In-Reply-To: <cover.1611153172.git.pabeni@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mptcp@lists.01.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 20 Jan 2021 15:39:09 +0100 you wrote:
> The sendbuffer autotuning was unintentionally disabled as a
> side effect of the recent workqueue removal refactor. These
> patches re-enable id, with some extra care: with autotuning
> enable/large send buffer we need a more accurate packet
> scheduler to be able to use efficiently the available
> subflow bandwidth, especially when the subflows have
> different capacities.
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/5] mptcp: always graft subflow socket to parent
    https://git.kernel.org/netdev/net-next/c/866f26f2a9c3
  - [v2,net-next,2/5] mptcp: re-enable sndbuf autotune
    https://git.kernel.org/netdev/net-next/c/5cf92bbadc58
  - [v2,net-next,3/5] mptcp: do not queue excessive data on subflows
    https://git.kernel.org/netdev/net-next/c/ec369c3a337f
  - [v2,net-next,4/5] mptcp: schedule work for better snd subflow selection
    https://git.kernel.org/netdev/net-next/c/40dc9416cc95
  - [v2,net-next,5/5] mptcp: implement delegated actions
    https://git.kernel.org/netdev/net-next/c/b19bc2945b40

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


