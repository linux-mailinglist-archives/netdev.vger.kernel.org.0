Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA9F34270F
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 21:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbhCSUk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 16:40:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:59676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230186AbhCSUkJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 16:40:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EA9C56197B;
        Fri, 19 Mar 2021 20:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616186409;
        bh=IiSQAzcCUqMk4YPQ7dcHQq1y5f7pFB0xQx3HrhWwu6s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RfAoxhueuWFuvvKO6taOucNajEzEI2WQjb50BBJiHltvdpk/M1+oCJ+zPWg06Y8Vp
         l5HrLO9OSHnNrC2QikONO5hwWHmoWVpAh92YKBSLsptvXwXQPum1NcM89GdLGGa7Sy
         6LT89k4xY040/80MGwwbzWTaRlNijT9uUxzGDMsVmKCcz+U1rI2hXPti7Oh8W80gW2
         FEqlwDIyO62bsooYEBgFf3yoXLBWTWuLjHWgRGJGI3nNU1QVLrxD7CH7tex23XYZrN
         eVe8RJOO7jvVb5w/+t95OqQt1M1zkLkjExC9ImwbwqyN8EpsgTZziE5Fy2xYqRzqPk
         /8FRtM42p9lxw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E1588626EC;
        Fri, 19 Mar 2021 20:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] net: ipa: update configuration data
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161618640891.3803.15579900708987919124.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Mar 2021 20:40:08 +0000
References: <20210319152422.1803714-1-elder@linaro.org>
In-Reply-To: <20210319152422.1803714-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 19 Mar 2021 10:24:17 -0500 you wrote:
> Each IPA version has a "data" file defining how various things are
> configured.  This series gathers a few updates to this information:
>   - The first patch makes all configuration data constant
>   - The second fixes an incorrect (but seemingly harmless) value
>   - The third simplifies things a bit by using implicit zero
>     initialization for memory regions that are empty
>   - The fourth adds definitions for memory regions that exist but
>     are not yet used
>   - The fifth use configuration data rather than conditional code to
>     set some bus parameters
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] net: ipa: make all configuration data constant
    https://git.kernel.org/netdev/net-next/c/e4a9f45b0be5
  - [net-next,2/5] net: ipa: fix canary count for SC7180 UC_INFO region
    https://git.kernel.org/netdev/net-next/c/22e3b314302c
  - [net-next,3/5] net: ipa: don't define empty memory regions
    https://git.kernel.org/netdev/net-next/c/8f692169b138
  - [net-next,4/5] net: ipa: define some new memory regions
    https://git.kernel.org/netdev/net-next/c/2ef88644e5d4
  - [net-next,5/5] net: ipa: define QSB limits in configuration data
    https://git.kernel.org/netdev/net-next/c/37537fa8e973

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


