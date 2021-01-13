Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 937AF2F42DF
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 05:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbhAMEKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 23:10:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:50208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726386AbhAMEKv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 23:10:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id B6E9E2313E;
        Wed, 13 Jan 2021 04:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610511010;
        bh=qGko8g3jOeTLuDZ5E8kdQj1Nb68o+qzHFwMkHzT5zs4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uTtZaxIyhiRmiJkzYy7lI5/7/kN1N+GUYIeft4PPc/li0/5Q6Vb/cm7KyvpiYz2I7
         aWO/iYQiGPcGAJuLZi/rYpDlw3L1uw2bIF3EJvskXIjqy0nHGUiudqwuV4tCMpPswc
         GdDkErY2T0eumKvoBGso/0ADQ2nTQDXA+U++YQfgk0NfQ0F+WKXUOSc2gbmrGOsZJA
         iuYeIDHiqP3e7Pro2MFTcTGKCNzi5I9pcTBgK630ijD4dVBDK1TLmA5cjxYVRjGZSm
         uFG919kpONrerj3471lXG1lTC4il/Xcyr/iEteFtgc+ATXv3exlg2TrV/Amp6zwWFR
         spvX4P7jVa+jA==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id AE2EC60156;
        Wed, 13 Jan 2021 04:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH RESEND net-next] net: sfp: add debugfs support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161051101070.28597.7554599803901323807.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Jan 2021 04:10:10 +0000
References: <E1kyYRe-0004kN-3F@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1kyYRe-0004kN-3F@rmk-PC.armlinux.org.uk>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 10 Jan 2021 10:59:38 +0000 you wrote:
> Add debugfs support to SFP so that the internal state of the SFP state
> machines and hardware signal state can be viewed from userspace, rather
> than having to compile a debug kernel to view state state transitions
> in the kernel log.  The 'state' output looks like:
> 
> Module state: empty
> Module probe attempts: 0 0
> Device state: up
> Main state: down
> Fault recovery remaining retries: 5
> PHY probe remaining retries: 12
> moddef0: 0
> rx_los: 1
> tx_fault: 1
> tx_disable: 1
> 
> [...]

Here is the summary with links:
  - [RESEND,net-next] net: sfp: add debugfs support
    https://git.kernel.org/netdev/net-next/c/9cc8976c69eb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


