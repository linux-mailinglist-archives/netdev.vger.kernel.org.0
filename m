Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B40F31985A
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 03:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbhBLCat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 21:30:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:48230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229575AbhBLCar (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 21:30:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 1F8CF64E65;
        Fri, 12 Feb 2021 02:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613097007;
        bh=cLEU5KwihEzzWwdwaSDhFeg0rAMxN1KJdp83CnIDpR8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CC9MPVGXp8RAvtDcKQmlhaK7q8PRaJcUuJnXCDMPLHZlBO8hihsJEND03a4kiAZ49
         1l9y4pnC2wxC0etiF+aEX06u39M3j5ucUG23xiLZpg34ynprm02jbzdizTLlROTXob
         YUSY2iUTLk+z7zw9/XaZxgNkCKBy/Abp+hJYCVGTQY31/cMIQZ5r3DWlPjrE2WaEkB
         7UnhqDfArzA7h0n5qMhKLdvvx078W8ZQZArWlEmDcnceX0qI/TQ4znCqo8BT75Ry7E
         83/Y2qKIyva2Vz/vOiiuL3kDv9Rl0WWtEnkAaF38ZIBWFZm4xyrDk3K7W6WSjnznV+
         hhYM88+RVKwAA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 02D0960A2B;
        Fri, 12 Feb 2021 02:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: phy: consider that suspend2ram may cut off PHY power
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161309700700.16682.9228652055785839659.git-patchwork-notify@kernel.org>
Date:   Fri, 12 Feb 2021 02:30:07 +0000
References: <fcd4c005-22b0-809b-4474-0435313a5a47@gmail.com>
In-Reply-To: <fcd4c005-22b0-809b-4474-0435313a5a47@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     andrew@lunn.ch, linux@armlinux.org.uk, kuba@kernel.org,
        davem@davemloft.net, Claudiu.Beznea@microchip.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 11 Feb 2021 22:32:52 +0100 you wrote:
> Claudiu reported that on his system S2R cuts off power to the PHY and
> after resuming certain PHY settings are lost. The PM folks confirmed
> that cutting off power to selected components in S2R is a valid case.
> Therefore resuming from S2R, same as from hibernation, has to assume
> that the PHY has power-on defaults. As a consequence use the restore
> callback also as resume callback.
> In addition make sure that the interrupt configuration is restored.
> Let's do this in phy_init_hw() and ensure that after this call
> actual interrupt configuration is in sync with phydev->interrupts.
> Currently, if interrupt was enabled before hibernation, we would
> resume with interrupt disabled because that's the power-on default.
> 
> [...]

Here is the summary with links:
  - [net] net: phy: consider that suspend2ram may cut off PHY power
    https://git.kernel.org/netdev/net/c/4c0d2e96ba05

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


