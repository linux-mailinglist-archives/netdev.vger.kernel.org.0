Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3472F319862
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 03:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbhBLCut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 21:50:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:49374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229547AbhBLCus (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 21:50:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 4696C64DFF;
        Fri, 12 Feb 2021 02:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613098208;
        bh=GbRAnFuLJAYgcnue0WAJUrIBl1d9nbUNn9bwWn/eq+U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hmHua4h2t7Gu4Q+Y3s2aWgU8WXMVVldAB2/zPLGcF+De5jQd15ne/X7SxArlwaUSQ
         85eGXIg99s2t7UQ/CzXY64t+AVWxue3cxZMv1oEpWHINWBRGZoMat+TkS0HgFgk6Zl
         pV53GBnKUL3YZtDU9RjkSJd3MXKSnpn05jbmu67qV48B5gpUd/jn0Ny3sJECht9RQW
         tHtZ0KWo4cSXYOENrIDv+h2wPiekusOKiEf3/RKEaq01rfySeQRvva1B+YKvMG5qZm
         odN35x/70wru/NZREMaSfnU9uCJbyH9Ng2brTy9/TpR0Tlla1woghWFd6yzDjdntFy
         tdjP0Gvcx20PA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 386E960951;
        Fri, 12 Feb 2021 02:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/6] mptcp: Miscellaneous fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161309820822.25329.1992173657859048208.git-patchwork-notify@kernel.org>
Date:   Fri, 12 Feb 2021 02:50:08 +0000
References: <20210211233042.304878-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20210211233042.304878-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mptcp@lists.01.org, matthieu.baerts@tessares.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Thu, 11 Feb 2021 15:30:36 -0800 you wrote:
> Here are some MPTCP fixes for the -net tree, addressing various issues
> we have seen thanks to syzkaller and other testing:
> 
> Patch 1 correctly propagates errors at connection time and for TCP
> fallback connections.
> 
> Patch 2 sets the expected poll() events on SEND_SHUTDOWN.
> 
> [...]

Here is the summary with links:
  - [net,1/6] mptcp: deliver ssk errors to msk
    https://git.kernel.org/netdev/net/c/15cc10453398
  - [net,2/6] mptcp: fix poll after shutdown
    https://git.kernel.org/netdev/net/c/dd913410b0a4
  - [net,3/6] mptcp: fix spurious retransmissions
    https://git.kernel.org/netdev/net/c/64b9cea7a0af
  - [net,4/6] mptcp: init mptcp request socket earlier
    https://git.kernel.org/netdev/net/c/d8b59efa6406
  - [net,5/6] mptcp: better msk receive window updates
    https://git.kernel.org/netdev/net/c/e3859603ba13
  - [net,6/6] mptcp: add a missing retransmission timer scheduling
    https://git.kernel.org/netdev/net/c/d09d818ec2ed

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


