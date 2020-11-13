Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20CE82B2942
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 00:40:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbgKMXkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 18:40:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:53184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726042AbgKMXkI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 18:40:08 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605310805;
        bh=j8MvHDQWSQ78A3stNi/OAK+xDFDcfVUCJVBtmDWG68I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tfWvGL+roiSRWy+KRU2XG/KGmtyJO0p2duebVX5l+J5dp1zBxEYMwknb7Ht77lM5+
         AMR4vIxA9zXsI5P3Zp/ZUchHv8kLRNhcB0/bwlSOJIEokZVvhidzUgz2lXddSwS/iy
         x7uHGbYnRVlhq/WCqwhuEL2uFsw2wB15K6FCXvE4=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: ipa: two fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160531080582.10871.8898055303919120485.git-patchwork-notify@kernel.org>
Date:   Fri, 13 Nov 2020 23:40:05 +0000
References: <20201112121157.19784-1-elder@linaro.org>
In-Reply-To: <20201112121157.19784-1-elder@linaro.org>
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

On Thu, 12 Nov 2020 06:11:55 -0600 you wrote:
> This small series makes two fixes to the IPA code:
>   - While reviewing something else I found that one of the resource
>     limits on the SDM845 used the wrong value.  The first patch
>     fixes this.  The correct value allocates more resources of this
>     type for IPA to use, and otherwise does not change behavior.
>   - When the IPA-resident microcontroller starts up it generates an
>     event, which triggers an AP interrupt.  The event merely
>     provides some information for logging, which we don't support.
>     We already ignore the event, and that's harmless.  So this
>     patch explicitly ignores it rather than issuing a warning when
>     it occurs.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: ipa: fix source packet contexts limit
    https://git.kernel.org/netdev/net-next/c/3ce6da1b2e47
  - [net-next,2/2] net: ipa: ignore the microcontroller log event
    https://git.kernel.org/netdev/net-next/c/0a5096ec2a35

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


