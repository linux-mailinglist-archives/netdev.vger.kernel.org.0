Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D960E3EC2D4
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 15:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238464AbhHNNUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 09:20:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:57670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235352AbhHNNUg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Aug 2021 09:20:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4813F60F4B;
        Sat, 14 Aug 2021 13:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628947206;
        bh=u3joZo33K1BMERI6Nfy8tsRx+Q4OxCCgCXmenGuQimM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ATGSnZREyU6JsRdF8vxScOkM19lOhduprJC0qyAINuAyvoAhMWb7mrrNR4r48VIhh
         qgDwncjTSct3EtkgvFwW/e4THWE2jq0rOGz5mS1JWPvzGTKcS0EDrWdRW4e8LA+1vN
         4+XBe0zkxpqo3X/Alpgtc1l7yk7OG1Kle+UpLH+AGCTQHH3FeeG065nnisvB0TxVBS
         DYm4exYX/S3BYpmzkZoXI8b4sPBn0s9AlShxD2SpgKgAhC79MIb//GXEgrecFTtFPy
         r0qOCeWfxdeZvapb9pgqY03GUHGrNoGx66MCCcoMFZWFcg8jGb18X8FbUu6PIB26ge
         mNqwidR5vPdvA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3B5D460A69;
        Sat, 14 Aug 2021 13:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] net: ipa: last things before PM conversion
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162894720623.8342.3825370378058195273.git-patchwork-notify@kernel.org>
Date:   Sat, 14 Aug 2021 13:20:06 +0000
References: <20210812195035.2816276-1-elder@linaro.org>
In-Reply-To: <20210812195035.2816276-1-elder@linaro.org>
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

On Thu, 12 Aug 2021 14:50:29 -0500 you wrote:
> This series contains a few remaining changes needed before fully
> switching over to using runtime power management rather than the
> previous "IPA clock" mechanism.
> 
> The first patch moves the calls to enable and disable the IPA
> interrupt as a system wakeup interrupt into "ipa_clock.c" with the
> rest of the power-related code.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] net: ipa: enable wakeup in ipa_power_setup()
    https://git.kernel.org/netdev/net-next/c/d430fe4bac02
  - [net-next,2/6] net: ipa: distinguish system from runtime suspend
    https://git.kernel.org/netdev/net-next/c/b9c532c11cab
  - [net-next,3/6] net: ipa: re-enable transmit in PM WQ context
    https://git.kernel.org/netdev/net-next/c/a96e73fa1269
  - [net-next,4/6] net: ipa: ensure hardware has power in ipa_start_xmit()
    https://git.kernel.org/netdev/net-next/c/6b51f802d652
  - [net-next,5/6] net: ipa: don't stop TX on suspend
    https://git.kernel.org/netdev/net-next/c/8dcf8bb30f17
  - [net-next,6/6] net: ipa: don't hold clock reference while netdev open
    https://git.kernel.org/netdev/net-next/c/8dc181f2cd62

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


