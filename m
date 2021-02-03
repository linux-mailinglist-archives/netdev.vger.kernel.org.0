Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27A9730D132
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 03:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbhBCCAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 21:00:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:39808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229902AbhBCCAv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 21:00:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id DA55B64F72;
        Wed,  3 Feb 2021 02:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612317610;
        bh=AXX0SjOn7X7EVCBvkQs8eC1I9Np7utuUcOHkHs7WF50=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=flwWs6lXEEyEJm2K5T30yJXKCr4+l5jld2LjiFJA22P3yje+XkiVtAC+XcraNgYcB
         fY3TnCMLy0bdYdDK11+c1Ptox+ccrZsxUmFeKH6dFT28aHift3US7V1yazi4kBz532
         NvWM3sl7qxpaN3h57qE5bxzoQkU1SUea2cLCjcH44QLueD1CToAfxJQl8b0h3rWS7w
         04tpmmxyiuhxx8GaHZLl8a1AY7USG+KldV80xAbZdT7KNJFejIYxQLDp0jTw6nKeHm
         PS3fZAox+ul1A8lCGQqsZNJXYVpnOnzIkXE/Rvyj1ubh5ODfpHX1yK8he1UNEredVP
         4jlzIvnwyCBWA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C7576609D9;
        Wed,  3 Feb 2021 02:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] mptcp: fix length of MP_PRIO suboption
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161231761081.3354.9559043365132728665.git-patchwork-notify@kernel.org>
Date:   Wed, 03 Feb 2021 02:00:10 +0000
References: <846cdd41e6ad6ec88ef23fee1552ab39c2f5a3d1.1612184361.git.dcaratti@redhat.com>
In-Reply-To: <846cdd41e6ad6ec88ef23fee1552ab39c2f5a3d1.1612184361.git.dcaratti@redhat.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        davem@davemloft.net, kuba@kernel.org, geliangtang@gmail.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon,  1 Feb 2021 14:05:26 +0100 you wrote:
> With version 0 of the protocol it was legal to encode the 'Subflow Id' in
> the MP_PRIO suboption, to specify which subflow would change its 'Backup'
> flag. This has been removed from v1 specification: thus, according to RFC
> 8684 §3.3.8, the resulting 'Length' for MP_PRIO changed from 4 to 3 byte.
> 
> Current Linux generates / parses MP_PRIO according to the old spec, using
> 'Length' equal to 4, and hardcoding 1 as 'Subflow Id'; RFC compliance can
> improve if we change 'Length' in other to become 3, leaving a 'Nop' after
> the MP_PRIO suboption. In this way the kernel will emit and accept *only*
> MP_PRIO suboptions that are compliant to version 1 of the MPTCP protocol.
> 
> [...]

Here is the summary with links:
  - [net-next,v3] mptcp: fix length of MP_PRIO suboption
    https://git.kernel.org/netdev/net-next/c/ec99a470c7d5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


