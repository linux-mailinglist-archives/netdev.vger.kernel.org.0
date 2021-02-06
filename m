Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9196C312051
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 23:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbhBFWkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 17:40:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:47344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229536AbhBFWks (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 17:40:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 367F564E89;
        Sat,  6 Feb 2021 22:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612651208;
        bh=DZ9B6P/GCh03qH0ix5l653uGX+Xjzp0/HFwuA7WuHJY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qP24FOc03/nZlMsZvpciy39YtCU+Vdiv1sLdr1EUgKsOKpBOzbwbVK0Y6ul9sJaKz
         Wdmwovn2iIBj9hOXGLj8585yuvylGx0vcXGb6es1IDrPLe/GQaJv/Q2xgEq9ztpcxe
         SQS/orgUIHbbsMIDd8oqDx/MFiaCiI0Ai1wJjlfjl8VQnLSmmbHHO6+J1oOqVbUHH5
         hpmojLPmdjYe6PtiuOFUuoa3v4MoewQQYmpifAk+U7QhkJMnnIrsnR+P/+Ic6VkRmZ
         d/8o6TzKK26nUAvj3Xa6AGO2z7pFwr7UgtQq/U/0dh6z0LYoGA+rFNV3UqJZQ4W/aG
         wYHU4LTweyEAg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 23288609F7;
        Sat,  6 Feb 2021 22:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] mptcp: Misc. updates for tests & lock annotation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161265120814.6465.3567605708356954276.git-patchwork-notify@kernel.org>
Date:   Sat, 06 Feb 2021 22:40:08 +0000
References: <20210204232330.202441-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20210204232330.202441-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mptcp@lists.01.org, matthieu.baerts@tessares.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu,  4 Feb 2021 15:23:28 -0800 you wrote:
> Here are two fixes we've collected in the mptcp tree.
> 
> Patch 1 refactors a MPTCP selftest script to allow running a subset of
> the tests.
> 
> Patch 2 adds some locking & might_sleep assertations.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] selftests: mptcp: add command line arguments for mptcp_join.sh
    https://git.kernel.org/netdev/net-next/c/1002b89f23ea
  - [net-next,2/2] mptcp: pm: add lockdep assertions
    https://git.kernel.org/netdev/net-next/c/3abc05d9ef6f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


