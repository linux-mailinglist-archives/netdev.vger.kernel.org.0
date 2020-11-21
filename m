Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7082BBC75
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 04:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbgKUDAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 22:00:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:51770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725785AbgKUDAH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 22:00:07 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605927607;
        bh=SGJrEhEZ1y8SLxeAJd/YsxY4PERIf/1xje2EzYx3/Fk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=0wt+a6h7E51ZImI+GBBRWYcll+l+3lhJhZeaaHiGzLCfGGsUu8ZxuI5+TDPzIH8pm
         sQjVvho2GNL6YCckEoMH5PIKxfvT1m3l2UAIL1Dks6vwOPoADZ1iLi/ebFuZ/GLnGy
         /z7XARZQ00CrIB1hIjPkV6nXATK9s0ww1JtDJpKg=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] net: ipa: add a driver shutdown callback
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160592760704.22843.591870279571575772.git-patchwork-notify@kernel.org>
Date:   Sat, 21 Nov 2020 03:00:07 +0000
References: <20201119224929.23819-1-elder@linaro.org>
In-Reply-To: <20201119224929.23819-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, evgreen@chromium.org,
        subashab@codeaurora.org, cpratapa@codeaurora.org,
        bjorn.andersson@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 19 Nov 2020 16:49:23 -0600 you wrote:
> The final patch in this series adds a driver shutdown callback for
> the IPA driver.  The patches leading up to that address some issues
> encountered while ensuring that callback worked as expected:
>   - The first just reports a little more information when channels
>     or event rings are in unexpected states
>   - The second patch recognizes a condition where an as-yet-unused
>     channel does not require a reset during teardown
>   - The third patch explicitly ignores a certain error condition,
>     because it can't be avoided, and is harmless if it occurs
>   - The fourth properly handles requests to retry a channel HALT
>     request
>   - The fifth makes a second attempt to stop modem activity during
>     shutdown if it's busy
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] net: ipa: print channel/event ring number on error
    https://git.kernel.org/netdev/net-next/c/f8d3bdd561a7
  - [net-next,2/6] net: ipa: don't reset an ALLOCATED channel
    https://git.kernel.org/netdev/net-next/c/5d28913d4ee6
  - [net-next,3/6] net: ipa: ignore CHANNEL_NOT_RUNNING errors
    https://git.kernel.org/netdev/net-next/c/f849afcc8c3b
  - [net-next,4/6] net: ipa: support retries on generic GSI commands
    https://git.kernel.org/netdev/net-next/c/1136145660f3
  - [net-next,5/6] net: ipa: retry modem stop if busy
    https://git.kernel.org/netdev/net-next/c/7c80e83829db
  - [net-next,6/6] net: ipa: add driver shutdown callback
    https://git.kernel.org/netdev/net-next/c/ae1d72f9779f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


