Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8DB2494ADA
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 10:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240540AbiATJgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 04:36:03 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47408 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237441AbiATJgC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 04:36:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5687660023;
        Thu, 20 Jan 2022 09:36:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AAA05C340E3;
        Thu, 20 Jan 2022 09:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642671361;
        bh=Sw7dY4UqhVnbrcdw+2/HnvkUz97oA+g8rSgYwhLCVpw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cruU2VX8+QRVOQRjWZITJx+PtGlYmBP9v5aozQErjvpHHlCvwUB5OZwtPvhW/jvII
         8tAn7VfjooDLcf5HGFFV7Dq8PioAVWa9GAQTtXdd0MfNYqzOZvzibzRVldUx25NzGQ
         DjffSk0e9kBfM90FvVZlkiaxp7HziSI8vHS3cSzMQps+XY2dNbvXEvgEzroW/bvGeK
         E6XPg+PjNFCUhGPPJKNWjjwp1H7rm4sjS22cnklfp0sd9Zfq8L6IV2r+RamBQw7yry
         wjLEiVfqwWYZNVd8HWFAMOyHXZcCCY0IKHZEw5Plq4MQ6mV8HOAfWoGDybOKRK6VOK
         bucQez+IfLQdA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 945BDF6079B;
        Thu, 20 Jan 2022 09:36:01 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] Networking for 5.17-rc1
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164267136160.6560.3997159638009767273.git-patchwork-notify@kernel.org>
Date:   Thu, 20 Jan 2022 09:36:01 +0000
References: <20220119182611.400333-1-kuba@kernel.org>
In-Reply-To: <20220119182611.400333-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Linus Torvalds <torvalds@linux-foundation.org>:

On Wed, 19 Jan 2022 10:26:11 -0800 you wrote:
> Hi Linus!
> 
> Quite a handful of old regression fixes but of those all are pre-5.16.
> 
> The following changes since commit fe8152b38d3a994c4c6fdbc0cd6551d569a5715a:
> 
>   Merge tag 'devprop-5.17-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm (2022-01-10 20:48:19 -0800)
> 
> [...]

Here is the summary with links:
  - [GIT,PULL] Networking for 5.17-rc1
    https://git.kernel.org/netdev/net/c/fa2e1ba3e9e3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


