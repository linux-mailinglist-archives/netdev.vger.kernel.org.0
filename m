Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91DB240BE05
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 05:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235700AbhIODL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 23:11:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:55896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229888AbhIODLZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 23:11:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1A14561216;
        Wed, 15 Sep 2021 03:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631675407;
        bh=NP81zxZ2T2LyWE2h8Socya3mbavsFzhvOfRA46C1NNw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aWYA8RT82bqsNDyZ8gexmS0cE6TJ0NmNa7KAuu05IjKwDVRLNFLGG7JUOz6mqPxQN
         ykpT8fK3ej2HYL+LRpqvnL2F+jgbz/w+7EleIvsCEn4bwrmoJKEOnSKxO20Md8UCcN
         X+Zyj4F6rIzxNuU1OeR00sYs6ZUSSkqSbkhEzWMQD5icaG67NuHdSrA2ld0gnleqWB
         bY4aNVtAQM/4xddoqwqcHInmS7ehWtDyxyJQUiPqY7TQLonNxuyEXSzYM1UO37bCmz
         +eNvscQH6qQ/QmC9u1AKMCxU+cwg53so7G4PSYWTqveCEq5OHwch+kqrIXaOASBIJF
         Ar5LIS3WuQZgg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 13AA560970;
        Wed, 15 Sep 2021 03:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: tag_rtl4_a: Drop bit 9 from egress frames
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163167540707.9269.153077674035924218.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Sep 2021 03:10:07 +0000
References: <20210913143156.1264570-1-linus.walleij@linaro.org>
In-Reply-To: <20210913143156.1264570-1-linus.walleij@linaro.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 13 Sep 2021 16:31:56 +0200 you wrote:
> This drops the code setting bit 9 on egress frames on the
> Realtek "type A" (RTL8366RB) frames.
> 
> This bit was set on ingress frames for unknown reason,
> and was set on egress frames as the format of ingress
> and egress frames was believed to be the same. As that
> assumption turned out to be false, and since this bit
> seems to have zero effect on the behaviour of the switch
> let's drop this bit entirely.
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: tag_rtl4_a: Drop bit 9 from egress frames
    https://git.kernel.org/netdev/net-next/c/339133f6c318

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


