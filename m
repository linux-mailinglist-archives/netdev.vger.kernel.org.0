Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF43E2EE99A
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 00:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728653AbhAGXKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 18:10:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:49940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728425AbhAGXKt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 18:10:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id A1E34235FF;
        Thu,  7 Jan 2021 23:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610061008;
        bh=PRRm0Dc1tBqYOrQb/6pIdTSSYIdiQix41Q9fXnVVQEQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aPoJX3LDryy0zgp5fRTHai+xZbtcOn9oo12PDC1K6xGc3Fs+ScY7CC+/uHQMuCaFZ
         sd25A21vhvgqWK37gGFQqntGF35Hc+AJXS/KzyIZO7nQ5A+P7VrSajDqlUvXFUVK16
         xZfaYenKWnYFXFNE3UzcFPE1vROS9NgjdyMaJNgP5Akde/fBKzSr36UF7kaVXI7oq0
         UsBxWt+9xVjf/ed9/v5GaA4WoCgnV6QA+VTfDvDnnBUW2X3n5V6Q20+Va+CSRJHXMd
         3oaxoMcdgrvFx5URYJ0CdRvnL2iH1MzJ9BeYw1RPWdcar49O3PBWDsQVJJSNaXzxt9
         RKcdqardXSFZg==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 96BCA60508;
        Thu,  7 Jan 2021 23:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] r8169: improve RTL8168g PHY suspend quirk
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161006100861.24984.14746491360218138628.git-patchwork-notify@kernel.org>
Date:   Thu, 07 Jan 2021 23:10:08 +0000
References: <9303c2cf-c521-beea-c09f-63b5dfa91b9c@gmail.com>
In-Reply-To: <9303c2cf-c521-beea-c09f-63b5dfa91b9c@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 6 Jan 2021 11:44:53 +0100 you wrote:
> According to Realtek the ERI register 0x1a8 quirk is needed to work
> around a hw issue with the PHY on RTL8168g. The register needs to be
> changed before powering down the PHY. Currently we don't meet this
> requirement, however I'm not aware of any problems caused by this.
> Therefore I see the change as an improvement.
> 
> The PHY driver has no means to access the chip ERI registers,
> therefore we have to intercept MDIO writes to the BMCR register.
> If the BMCR_PDOWN bit is going to be set, then let's apply the
> quirk before actually powering down the PHY.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] r8169: move ERI access functions to avoid forward declaration
    https://git.kernel.org/netdev/net-next/c/c6cff9dfebb3
  - [net-next,2/2] r8169: improve RTL8168g PHY suspend quirk
    https://git.kernel.org/netdev/net-next/c/acb58657c869

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


