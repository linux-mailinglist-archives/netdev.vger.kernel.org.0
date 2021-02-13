Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81E6C31A8DE
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 01:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbhBMAkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 19:40:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:55828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229648AbhBMAkt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 19:40:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id C664064EA1;
        Sat, 13 Feb 2021 00:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613176808;
        bh=JsjM7b4v+8Ljj1itguWtLwm4FEQ6akpMd8J/+7yuo7U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=I+3d4y18V2FNsrT4B2D/ZUNMex601If2GK+E3uCWrC0yPIXC/kCrXRUPqGl92GDOF
         b8aj+E1n6l69hZCXo8kUM19k+YyEGHQh+058M07ApAUStoPZ7bvYmo9pQlULQG3R1I
         XqIIFnmPguV1j5uPdg1nmeC5Hru2vZorNXyrcRPlmRLySkUoB4QIhbSuAkBkFgXB2H
         Vu0MSh4l2tHBBNrk5E/F0l46LUcGyxYJBTNin/XT1cXP92Wx1sNMyVBPS0HP5dBtQN
         tKU+qhQLEo5gwiVQ0dSb88rsjFzbDzLOYn7Rny1WcyNK4fRnD/JTWtkeLQXbz9pWfP
         0hJFc35+Csr3w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B3B3260A2F;
        Sat, 13 Feb 2021 00:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] mptcp: Selftest enhancement and fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161317680873.1512.11792332135664461831.git-patchwork-notify@kernel.org>
Date:   Sat, 13 Feb 2021 00:40:08 +0000
References: <20210212232030.377261-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20210212232030.377261-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mptcp@lists.01.org, matthieu.baerts@tessares.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 12 Feb 2021 15:20:26 -0800 you wrote:
> This is a collection of selftest updates from the MPTCP tree.
> 
> Patch 1 uses additional 'ss' command line parameters and 'nstat' to
> improve output when certain MPTCP tests fail.
> 
> Patches 2 & 3 fix a copy/paste error and some output formatting.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] selftests: mptcp: dump more info on errors
    https://git.kernel.org/netdev/net-next/c/767389c8dd55
  - [net-next,2/4] selftests: mptcp: fix ACKRX debug message
    https://git.kernel.org/netdev/net-next/c/f384221a3817
  - [net-next,3/4] selftests: mptcp: display warnings on one line
    https://git.kernel.org/netdev/net-next/c/45759a871593
  - [net-next,4/4] selftests: mptcp: fail if not enough SYN/3rd ACK
    https://git.kernel.org/netdev/net-next/c/5f88117f2565

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


