Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBE745A2DD
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 13:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237126AbhKWMnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 07:43:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:41652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237068AbhKWMnR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 07:43:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9F96261075;
        Tue, 23 Nov 2021 12:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637671209;
        bh=TGXpN8Urwm0phMUKAkUk7rVbxzKLQvhMFx8M3rrzCWM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VbhRamQGqHaGZFECqtjilYIARv0PNurcMyBCJW3kMmPWRlAoer9z25botohWEtpA7
         2WFpjL+SdpCnQoUwkb9vHTqDNQ1IdPG8mabAWj1otvcJOecSQaH8GXxv8/Nr9Oh8tR
         baITYKxX+o4WLMROALJKwvqqT99wTPqLqB9Zgyq7arhc6Vaa388IaLH4NsvG1PVqRh
         XOOZ6l4S2pfioYaaG9nW2mSw3E9woC6oEQwD35cLPB15X6c0PGCDMOcxNyAvYFKTOI
         EZIzb7QeCpKar15Mib6Iqs7nsd/A6zXGRzK/sKwUFCWOtgkSpLVFkVPCU3gitXMhgx
         wcWE95cl6pyhA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 965A760A6C;
        Tue, 23 Nov 2021 12:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ipa: kill ipa_cmd_pipeline_clear()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163767120961.19545.15374207730093239882.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Nov 2021 12:40:09 +0000
References: <20211123011640.528936-1-elder@linaro.org>
In-Reply-To: <20211123011640.528936-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pkurapat@codeaurora.org,
        avuyyuru@codeaurora.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        evgreen@chromium.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 22 Nov 2021 19:16:40 -0600 you wrote:
> Calling ipa_cmd_pipeline_clear() after stopping the channel
> underlying the AP<-modem RX endpoint can lead to a deadlock.
> 
> This occurs in the ->runtime_suspend device power operation for the
> IPA driver.  While this callback is in progress, any other requests
> for power will block until the callback returns.
> 
> [...]

Here is the summary with links:
  - [net] net: ipa: kill ipa_cmd_pipeline_clear()
    https://git.kernel.org/netdev/net/c/e4e9bfb7c93d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


