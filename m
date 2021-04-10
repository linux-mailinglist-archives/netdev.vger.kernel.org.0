Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 573C435AAA8
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 06:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231573AbhDJEL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Apr 2021 00:11:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:58818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229437AbhDJEL1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Apr 2021 00:11:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BECD8611AF;
        Sat, 10 Apr 2021 04:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618027873;
        bh=AyKTQz3diuZcepHqxJ9DHk8auhUU1Lp6XSHBUmhJcBU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gGDAXtj2AkKtOn3bthXPbWmspxSFxQPlItKWQfML/KQ6kczaJ3ZbnaM0jRZH/s31a
         8fCfiuG+SA1Jnyma3wZzvecV+3l91/Iw+oPCtcFbrNyi51XArpxmE1YQqLlek/XkVR
         CLM5T9MEqAgncAbUFiHbEUDGxr8ZpS8bECiv57vaATHfRGYDRVCla0Y4k0XT2T/OQW
         izdi7iWI2v9NspZM+hxFmL9fwipKpuuXzAM/3UI6hn+whJv2fvlMnyLiatNExbU0ay
         wk5Zx3iUKcoCm/TCqsFEHKKeuFtUnLA6q3u33iEmvBPvtRBIS43x8AKwwqkgKZB64L
         U9MQFaX89j2oQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AC61460BFF;
        Sat, 10 Apr 2021 04:11:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/7] net: ipa: a few small fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161802787370.22966.5421763361774209604.git-patchwork-notify@kernel.org>
Date:   Sat, 10 Apr 2021 04:11:13 +0000
References: <20210409180722.1176868-1-elder@linaro.org>
In-Reply-To: <20210409180722.1176868-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri,  9 Apr 2021 13:07:15 -0500 you wrote:
> This series implements some minor bug fixes or improvements.
> 
> The first patch removes an apparently unnecessary restriction, which
> results in an error on a 32-bit ARM build.
> 
> The second makes a definition used for SDM845 match what is used in
> the downstream code.
> 
> [...]

Here is the summary with links:
  - [net-next,1/7] net: ipa: relax pool entry size requirement
    https://git.kernel.org/netdev/net-next/c/7ad3bd52cbcb
  - [net-next,2/7] net: ipa: update sequence type for modem TX endpoint
    https://git.kernel.org/netdev/net-next/c/49e76a418981
  - [net-next,3/7] net: ipa: only set endpoint netdev pointer when in use
    https://git.kernel.org/netdev/net-next/c/57f63faf0562
  - [net-next,4/7] net: ipa: ipa_stop() does not return an error
    https://git.kernel.org/netdev/net-next/c/077e770f2601
  - [net-next,5/7] net: ipa: get rid of empty IPA functions
    https://git.kernel.org/netdev/net-next/c/74858b63c47c
  - [net-next,6/7] net: ipa: get rid of empty GSI functions
    https://git.kernel.org/netdev/net-next/c/57ab8ca42fa0
  - [net-next,7/7] net: ipa: three small fixes
    https://git.kernel.org/netdev/net-next/c/602a1c76f847

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


