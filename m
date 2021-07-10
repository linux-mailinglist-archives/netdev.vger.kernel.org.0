Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63C073C2CAD
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 03:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbhGJBwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 21:52:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:35624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229703AbhGJBws (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 21:52:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5E84461380;
        Sat, 10 Jul 2021 01:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625881804;
        bh=0Yhz7yAl6Bh6zU7uAzi1wSm1TqBShjzHPRxajVwVFsQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=k4b108BjoNAHE3tS7MGDgYZCKUl3Fujnl6xkjgumhkOoxc7ylZl/3wgkLQBOx2rSx
         tbhnQ/bcf5so9WY1RORmx504FuY0OoNypaydFOYTtMHsktuUrV57179LZqSB0ava/9
         QDtYQoU5rLMHEwukDDXpeOFL4mXthGEWOfjV0Z89pa3B+2ms9uyfqrnvu+jyPvs1yH
         jI6qyBqA3N3wcg4W0xmuNZztE+vFDVNofAAVrP/G9GaC+xmx0u48/xKD/izsnof6oD
         53oBHIMzta+mcsrMpQVJGWXmB2S/V78neyt7PxnaWTNqCyqUyImPyD6wkriynlW+is
         6N8P+PmkEh2kw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 51CBE60A38;
        Sat, 10 Jul 2021 01:50:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/6] mptcp: Connection and accounting fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162588180432.5438.17537000783979929322.git-patchwork-notify@kernel.org>
Date:   Sat, 10 Jul 2021 01:50:04 +0000
References: <20210710002051.216010-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20210710002051.216010-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        matthieu.baerts@tessares.net, pabeni@redhat.com, fw@strlen.de,
        geliangtang@gmail.com, mptcp@lists.linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Fri,  9 Jul 2021 17:20:45 -0700 you wrote:
> Here are some miscellaneous fixes for MPTCP:
> 
> Patch 1 modifies an MPTCP hash so it doesn't depend on one of skb->dev
> and skb->sk being non-NULL.
> 
> Patch 2 removes an extra destructor call when rejecting a join due to
> port mismatch.
> 
> [...]

Here is the summary with links:
  - [net,1/6] mptcp: fix warning in __skb_flow_dissect() when do syn cookie for subflow join
    https://git.kernel.org/netdev/net/c/0c71929b5893
  - [net,2/6] mptcp: remove redundant req destruct in subflow_check_req()
    https://git.kernel.org/netdev/net/c/030d37bd1cd2
  - [net,3/6] mptcp: fix syncookie process if mptcp can not_accept new subflow
    https://git.kernel.org/netdev/net/c/8547ea5f52dd
  - [net,4/6] mptcp: avoid processing packet if a subflow reset
    https://git.kernel.org/netdev/net/c/6787b7e350d3
  - [net,5/6] selftests: mptcp: fix case multiple subflows limited by server
    https://git.kernel.org/netdev/net/c/a7da441621c7
  - [net,6/6] mptcp: properly account bulk freed memory
    https://git.kernel.org/netdev/net/c/ce599c516386

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


