Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD2737742E
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 23:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbhEHVdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 17:33:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:58090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhEHVdp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 May 2021 17:33:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3272F613EC;
        Sat,  8 May 2021 21:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620509563;
        bh=gmy0sR5qkhlEEqs/xi2NUq6jyVQa9NyZ6OeCRoXpvmo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=erbFK8QyTz+zdFF+1u2ILjZzSj3eKD1cjwgZrHAseArMrbCc41Bt64J3aylsnoyJl
         t0O1WY5wMSsg2/716HKVXmLA+7Qc/4E+Jr/m7sOBX+qqUgF2ryzdWHgUmcR+1IsPlP
         gbdOcXTnecwLmuSgH+N/TWLV9/ZE4A38tUi7POy4hk0PUh7VRaQd3A8aw1xStAP5ap
         +Y4NKWBecHSEg0oQ7KPdze8G+DOEpovGdalHFa7XKpQDnCrZGuOYntATWtd+xFy693
         wkrRElMCKmgcSamKET9v4hX4yH4MzKLpF08zRnOxEg2G3MO9UiWSOJ+AgIoPCGBJFQ
         EEv5b27yddeRA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2797B60A0E;
        Sat,  8 May 2021 21:32:43 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] Networking for 5.13-rc1
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162050956315.23140.140148249384447687.git-patchwork-notify@kernel.org>
Date:   Sat, 08 May 2021 21:32:43 +0000
References: <20210508005952.3236141-1-kuba@kernel.org>
In-Reply-To: <20210508005952.3236141-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Fri,  7 May 2021 17:59:52 -0700 you wrote:
> The following changes since commit 9d31d2338950293ec19d9b095fbaa9030899dcb4:
> 
>   Merge tag 'net-next-5.13' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next (2021-04-29 11:57:23 -0700)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.13-rc1
> 
> [...]

Here is the summary with links:
  - [GIT,PULL] Networking for 5.13-rc1
    https://git.kernel.org/netdev/net/c/fc858a523108

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


