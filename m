Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 792E631D27D
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 23:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbhBPWLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 17:11:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:49154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230218AbhBPWKt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 17:10:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id C009F64EB1;
        Tue, 16 Feb 2021 22:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613513408;
        bh=7kpw3NaBnfp5O8XYPhdPrDoRAux2K1tgYOtaNRyuBBo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kpWOT5QGejB7uIA8QbnjW5tEgMJ4DjDKXc6tILLY3Rg/lI1QqxSnzJfeltR9799va
         cr4Wee0f/U44R9vA+XREIhc9gGL56dh4pptsPKaSwInF52cgDEglCAqlnGq4NnPqQk
         sPOYu6tGL80nr9MpMxlkI0okKQydrEDvif4lndFCZ9k2NkF7vSNxOBjyA1X5FFE/H1
         njcs+habemOEx6pyBFE4E4SOrFwYSTzYt1qKHRbiGC31p2GuZ9zh+Gk0MtEvdJQHu3
         P7xZ2zv6jKC86o+MnmS5gukO3a+CdjkyFW1HYmPf1vuvO4pH0sIxm9NiF9meR8GozT
         Tg/w9r9tVJv+A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AF1E860A21;
        Tue, 16 Feb 2021 22:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH RESEND net-next 0/2] Fix buggy brport flags offload for
 SJA1105 DSA
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161351340871.15084.5846603188911703598.git-patchwork-notify@kernel.org>
Date:   Tue, 16 Feb 2021 22:10:08 +0000
References: <20210216114119.2856299-1-olteanv@gmail.com>
In-Reply-To: <20210216114119.2856299-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 16 Feb 2021 13:41:17 +0200 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> I am resending this series because the title and the patches were mixed
> up and these patches were lost. This series' cover letter was used as
> the merge commit for the unrelated "Fixing build breakage after "Merge
> branch 'Propagate-extack-for-switchdev-LANs-from-DSA'"" series, as can
> be seen below:
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=ca04422afd6998611a81d0ea1b61d5a5f4923f84
> 
> [...]

Here is the summary with links:
  - [RESEND,net-next,1/2] net: dsa: sja1105: fix configuration of source address learning
    https://git.kernel.org/netdev/net-next/c/4c44fc5e9400
  - [RESEND,net-next,2/2] net: dsa: sja1105: fix leakage of flooded frames outside bridging domain
    https://git.kernel.org/netdev/net-next/c/7f7ccdea8c73

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


