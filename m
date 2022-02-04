Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 069E24A97F6
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 11:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354446AbiBDKkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 05:40:17 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58450 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240339AbiBDKkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 05:40:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83CB3B8370A;
        Fri,  4 Feb 2022 10:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 085C9C340F1;
        Fri,  4 Feb 2022 10:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643971213;
        bh=lUAV3AfO+c5A1LMdq46tWOi4TK6LQxolaSmqDKSg4z4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GN7SpYDOQSLM5O4nLV7a6MMwdTGqz5RuAtiT7M2Y/P5Pi31eeqt163D2pRwPxki2L
         HucIzBnD/YFHGKIc7Fn3QFsJfHI6966sIR8QpA/SbVVcgfu35QRUv3D2N9LMN1pgWf
         L40X7rJb8Zk+kvaDohJaA0q0aB6YTdGi+/y7OudEjFNteZLO0R25PWTedT5ZvUUWf/
         RoSDac2J1v0TA2J3D2Zm+VbrHrNAKkakYYk6MRcEpyvBwnpp+mSR/VmGsGOO5Xpm8D
         C85RQVqCpqVY1LgWkp7pGhdrLRwzfXIG8LJzD1/23IZ+TN7UXB2Z6s64NzHLhlZPbt
         VdH22VmNo30aQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E23CDE5D08C;
        Fri,  4 Feb 2022 10:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/10] net: ipa: improve RX buffer replenishing
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164397121292.5815.16093042564142954985.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Feb 2022 10:40:12 +0000
References: <20220203170927.770572-1-elder@linaro.org>
In-Reply-To: <20220203170927.770572-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, bjorn.andersson@linaro.org,
        mka@chromium.org, evgreen@chromium.org, cpratapa@codeaurora.org,
        avuyyuru@codeaurora.org, jponduru@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu,  3 Feb 2022 11:09:17 -0600 you wrote:
> This series revises the algorithm used for replenishing receive
> buffers on RX endpoints.  Currently there are two atomic variables
> that track how many receive buffers can be sent to the hardware.
> The new algorithm obviates the need for those, by just assuming we
> always want to provide the hardware with buffers until it can hold
> no more.
> 
> [...]

Here is the summary with links:
  - [net-next,01/10] net: ipa: kill replenish_saved
    https://git.kernel.org/netdev/net-next/c/a9bec7ae70c1
  - [net-next,02/10] net: ipa: allocate transaction before pages when replenishing
    https://git.kernel.org/netdev/net-next/c/b4061c136b56
  - [net-next,03/10] net: ipa: increment backlog in replenish caller
    https://git.kernel.org/netdev/net-next/c/4b22d8419549
  - [net-next,04/10] net: ipa: decide on doorbell in replenish loop
    https://git.kernel.org/netdev/net-next/c/b9dbabc5ca84
  - [net-next,05/10] net: ipa: allocate transaction in replenish loop
    (no matching commit)
  - [net-next,06/10] net: ipa: don't use replenish_backlog
    https://git.kernel.org/netdev/net-next/c/d0ac30e74ea0
  - [net-next,07/10] net: ipa: introduce gsi_channel_trans_idle()
    https://git.kernel.org/netdev/net-next/c/5fc7f9ba2e51
  - [net-next,08/10] net: ipa: kill replenish_backlog
    https://git.kernel.org/netdev/net-next/c/09b337dedaca
  - [net-next,09/10] net: ipa: replenish after delivering payload
    https://git.kernel.org/netdev/net-next/c/5d6ac24fb10f
  - [net-next,10/10] net: ipa: determine replenish doorbell differently
    https://git.kernel.org/netdev/net-next/c/9654d8c462ce

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


