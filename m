Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41AA7418117
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 12:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244454AbhIYKlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 06:41:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:43656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237469AbhIYKln (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 06:41:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 617B161041;
        Sat, 25 Sep 2021 10:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632566409;
        bh=KdXe+7JL4i+wsQItX1IQqBsoUnBXaxZp3DQjAStl/s0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OUanBE/Uc16M/9j/KyRNgyVy/pdmUcariZHH7uVjJCR8o43I0IE9LEn/c+OGIRDAh
         mPvqtu/Q4jur41YKSxmaiDErPHZz62NNc0q/e9dKlFKUr0cy6pSsf+wNcRzlDfVuvg
         9AmZMHTSHXqDBJIee/3yzDn8GmHOTX7GaMuT1MEQtA8c9EyhHu7ILRU7J7JML53Iv3
         eCXIEYD0I3pYv0OyI5CTPBmk3c+WsK7bmMYbgLRwFGu5c8M/ekI0sfvNFh7xCmIYl4
         fXeSbFuVKUR81WIR/37VnqZ94ZSFCHgjxl5aQB0mdigXOzZ88F4vtrJG9d4VTdfjb6
         rxf51T/z+tuxg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 58B7560989;
        Sat, 25 Sep 2021 10:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] mptcp: Miscellaneous fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163256640935.24365.17356076433637422358.git-patchwork-notify@kernel.org>
Date:   Sat, 25 Sep 2021 10:40:09 +0000
References: <20210924211238.162509-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20210924211238.162509-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev,
        pabeni@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 24 Sep 2021 14:12:33 -0700 you wrote:
> Here are five changes we've collected and tested in the mptcp-tree:
> 
> Patch 1 changes handling of the MPTCP-level snd_next value during the
> recovery phase after a subflow link failure.
> 
> Patches 2 and 3 are some small refactoring changes to replace some
> open-coded bits.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] mptcp: do not shrink snd_nxt when recovering
    https://git.kernel.org/netdev/net-next/c/0d199e4363b4
  - [net-next,2/5] mptcp: use OPTIONS_MPTCP_MPC
    https://git.kernel.org/netdev/net-next/c/13ac17a32bf1
  - [net-next,3/5] mptcp: use lockdep_assert_held_once() instead of open-coding it
    https://git.kernel.org/netdev/net-next/c/765ff425528f
  - [net-next,4/5] mptcp: remove tx_pending_data
    https://git.kernel.org/netdev/net-next/c/9e65b6a5aaa3
  - [net-next,5/5] mptcp: re-arm retransmit timer if data is pending
    https://git.kernel.org/netdev/net-next/c/3241a9c02934

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


