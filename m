Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EAAC3DFE29
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 11:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237133AbhHDJkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 05:40:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:41718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237118AbhHDJkU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 05:40:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CB41860F22;
        Wed,  4 Aug 2021 09:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628070007;
        bh=fDI2qqVb4rZosMJR1Fmnx61zIET9fIZFEKPkbnTI5TU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DGSfElqquXKQF62gDZ38PaejPCGmLcu2kkzq4FRMDPv5X2Y+1DK5VcCKx8AJPZiff
         YND2QwMlm9bI6VT86aKEVButhv9WKJYKL44eXx3ZA3Kda4rxw1ZuJI02xq4sVOA5UF
         lznJFF2rCEB4CgG2imv76HM9FqCWsLaa6ZH2sTRd6B+TJ+Tn+5U2IBoV6gIG/ACp6Z
         1fxiUjoEAaL2PlDJfQkdq0aLbV14I1Ubv2LaCr/PHtp1oFVw1oY1gF8yO4ZuOdlUkr
         Bn02xZE4t+lHF2E2+RG68l4YhOzkV/nzVMWX4ZHnN/Z+vrOHQUKfTkwNGD24sXqod7
         oCfbciQ/YL8OA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BA5B460A72;
        Wed,  4 Aug 2021 09:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] net: ipa: prepare GSI interrupts for runtime PM
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162807000775.29242.7117719006534625586.git-patchwork-notify@kernel.org>
Date:   Wed, 04 Aug 2021 09:40:07 +0000
References: <20210803140103.1012697-1-elder@linaro.org>
In-Reply-To: <20210803140103.1012697-1-elder@linaro.org>
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

On Tue,  3 Aug 2021 09:00:57 -0500 you wrote:
> The last patch in this series arranges for GSI interrupts to be
> disabled when the IPA hardware is suspended.  This ensures the clock
> is always operational when a GSI interrupt fires.  Leading up to
> that are patches that rearrange the code a bit to allow this to
> be done.
> 
> The first two patches aren't *directly* related.  They remove some
> flag arguments to some GSI suspend/resume related functions, using
> the version field now present in the GSI structure.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] net: ipa: use gsi->version for channel suspend/resume
    https://git.kernel.org/netdev/net-next/c/decfef0fa6b2
  - [net-next,2/6] net: ipa: move version check for channel suspend/resume
    https://git.kernel.org/netdev/net-next/c/4a4ba483e4a5
  - [net-next,3/6] net: ipa: move some GSI setup functions
    https://git.kernel.org/netdev/net-next/c/a7860a5f898c
  - [net-next,4/6] net: ipa: have gsi_irq_setup() return an error code
    https://git.kernel.org/netdev/net-next/c/1657d8a45823
  - [net-next,5/6] net: ipa: move gsi_irq_init() code into setup
    https://git.kernel.org/netdev/net-next/c/b176f95b5728
  - [net-next,6/6] net: ipa: disable GSI interrupts while suspended
    https://git.kernel.org/netdev/net-next/c/45a42a3c50b5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


