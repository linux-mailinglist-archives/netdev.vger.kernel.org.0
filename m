Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED99D48173A
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 23:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231986AbhL2WUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 17:20:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231259AbhL2WUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 17:20:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D7FCC061574;
        Wed, 29 Dec 2021 14:20:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C07AE614C7;
        Wed, 29 Dec 2021 22:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 249C9C36AE9;
        Wed, 29 Dec 2021 22:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640816410;
        bh=hjQAZLb14OJobDPleSQaofwFXchb/C4eBEa+U9p+ttc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Oik0sPGUriGqzI8p2ImomrRWct0hF9V/m4lZO7KxzZ8xNX2kRj59hoPVoOhQE+lZH
         O6EEJwO2vCBOtk4wd4gVN7XgrHx3vevoIhV9jVkWMsnPLUSl2wTDFi/z+CKV1X+qbY
         H27Gv8nY2kHXvzqK1ikzUSGeRtIxLg152g1Bbwvt0LU3242MLOherO96NefOwzBCDO
         miuUQz3ODjkAT2wTX86GGL/d6Uz+D6IyZj0psqcwlw/2rI5M7LES4Pi9IUN90nKqZc
         ZJ5IKxBvta9Gg+JwVD/dfllsT6eR9xdCd8IWDvA/d8L6vHrLMCBx1dLkkjC0Dft1kN
         +axquupsYItnQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 08B7AC395E5;
        Wed, 29 Dec 2021 22:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] net: bridge: mcast: add and enforce query interval
 minimum
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164081641003.5072.12853974016606114194.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Dec 2021 22:20:10 +0000
References: <20211227172116.320768-1-nikolay@nvidia.com>
In-Reply-To: <20211227172116.320768-1-nikolay@nvidia.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        stable@vger.kernel.org, herbert@gondor.apana.org.au,
        roopa@nvidia.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 27 Dec 2021 19:21:14 +0200 you wrote:
> Hi,
> This set adds and enforces 1 second minimum value for bridge multicast
> query and startup query intervals in order to avoid rearming the timers
> too often which could lock and crash the host. I doubt anyone is using
> such low values or anything lower than 1 second, so it seems like a good
> minimum. In order to be compatible if the value is lower then it is
> overwritten and a log message is emitted, since we can't return an error
> at this point.
> 
> [...]

Here is the summary with links:
  - [net,1/2] net: bridge: mcast: add and enforce query interval minimum
    https://git.kernel.org/netdev/net/c/99b40610956a
  - [net,2/2] net: bridge: mcast: add and enforce startup query interval minimum
    https://git.kernel.org/netdev/net/c/f83a112bd91a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


