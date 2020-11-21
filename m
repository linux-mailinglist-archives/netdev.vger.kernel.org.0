Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F22B2BBC77
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 04:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbgKUDAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 22:00:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:51784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726738AbgKUDAH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 22:00:07 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605927607;
        bh=u2DlComS5YCJTMgiWI+02sfiJtg3EVYssWD5iE6y1R8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LdtNyj8QBcvnnMjiwezJCTR3LL6Nv7hFSZ+U8XhL9j9rSGFxYcdbnXS8xauJtYnE5
         DXnOwwRxqNAdK6Wo5e5Otjc6oaI4t7L62sKq/NFagABS10P96ILe4lFS6Js5zwGvsa
         5QNMw17L/ISK8h0HlYAIdVzyP4zPPl6QCRH3O+Rg=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] net: ipa: platform-specific clock and
 interconnect rates
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160592760708.22843.17515762593640344543.git-patchwork-notify@kernel.org>
Date:   Sat, 21 Nov 2020 03:00:07 +0000
References: <20201119224041.16066-1-elder@linaro.org>
In-Reply-To: <20201119224041.16066-1-elder@linaro.org>
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

On Thu, 19 Nov 2020 16:40:38 -0600 you wrote:
> This series changes the way the IPA core clock rate and the
> bandwidth parameters for interconnects are specified.  Previously
> these were specified with hard-wired constants, with the same values
> used for the SDM845 and SC7180 platforms.  Now these parameters are
> recorded in platform-specific configuration data.
> 
> For the SC7180 this means we use an all-new core clock rate and
> interconnect parameters.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net: ipa: define clock and interconnect data
    https://git.kernel.org/netdev/net-next/c/dfccb8b13c0c
  - [net-next,2/3] net: ipa: populate clock and interconnect data
    https://git.kernel.org/netdev/net-next/c/f08c99226458
  - [net-next,3/3] net: ipa: use config data for clocking
    https://git.kernel.org/netdev/net-next/c/91d02f955150

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


