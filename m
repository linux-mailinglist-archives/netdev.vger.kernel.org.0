Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7873A47E9CA
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 01:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245402AbhLXAKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 19:10:21 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:50530 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbhLXAKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 19:10:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E5859CE20D6;
        Fri, 24 Dec 2021 00:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3E3CAC36AE9;
        Fri, 24 Dec 2021 00:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640304617;
        bh=nkbZOVTp1xJ8jLLzxUXls9INFJEy9rFvr80BhsSlD5s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=g+WcQBYAT+83DO6ZwIO+KmuAs17fVI6lvxBn08k2zGXg+pztaRFVN32cLuOX/biT0
         uM5DT68SldXXHN202EogkPEm2nsj8vpn20rjtvfw0O4sbGPPbX6DWnMRqgYT/Nj52p
         HKuouJy1LcPIO4NQHnwsbWXd3cP+WCGcOUMPhAgwz6CW/6x+/OoXdOBIK5o9HvovFm
         y/Tf8qqC4yY1BQ8VlS73dFq5wviCqAns7L86xbztyTF10dG/Or9CVkrUvEOOIizzn4
         R3tj7sKnJ5u4oM+nq7cnSG7zRDzpXUc57rfsfdswAlNztxPNUkimPZgyXpaacl/EC/
         L9UlJ6dNpfwOA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1B3EFEAC06E;
        Fri, 24 Dec 2021 00:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] Networking for 5.16-rc7
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164030461710.24547.14085106241025596381.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Dec 2021 00:10:17 +0000
References: <20211223184316.3916057-1-kuba@kernel.org>
In-Reply-To: <20211223184316.3916057-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        pablo@netfilter.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Linus Torvalds <torvalds@linux-foundation.org>:

On Thu, 23 Dec 2021 10:43:16 -0800 you wrote:
> Hi Linus!
> 
> The following changes since commit 6441998e2e37131b0a4c310af9156d79d3351c16:
> 
>   Merge tag 'audit-pr-20211216' of git://git.kernel.org/pub/scm/linux/kernel/git/pcmoore/audit (2021-12-16 15:24:46 -0800)
> 
> are available in the Git repository at:
> 
> [...]

Here is the summary with links:
  - [GIT,PULL] Networking for 5.16-rc7
    https://git.kernel.org/netdev/net/c/76657eaef4a7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


