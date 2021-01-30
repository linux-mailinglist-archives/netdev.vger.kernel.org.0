Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABC833091C6
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 05:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233679AbhA3EBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 23:01:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:36120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233617AbhA3DpT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 22:45:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 71DD764E16;
        Sat, 30 Jan 2021 02:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611973808;
        bh=vrCIt7R7uNXxIi8c+2LGfRaxNjJnE/LLfVnOulXfObE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=X+rQVa71nes7FNmmHKGq0O9XyzneFoK222UZm681DaeKjwYPONCG65aOxewz2eBsz
         4awHMkR9y0K+pLKRsxiX0X2g3C/6vuv5+n1SkC396Q7zMeBQ/iVPBrW1B4jt7fZHl0
         jmWMZ3MuqmKco50R+HP9C2efO3d3B6bqyhlRKlS7Fnp5gxIFB+nVBgDI0oqqUHrxzs
         oRffSaPetWRTWd3nc73UBHi8PthMZppRNvSPioORBhSQuc6u8Km9F7PPhcsm3NwWaU
         kg1KVLMwhMdY+ziA5QC9jnd9LfgLOYZZJL4STg8LlCHsB6E9Cacth/UE7GnuCCH5y1
         Pdemd74kbPKHg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 63B6F6095D;
        Sat, 30 Jan 2021 02:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/2] net: atm: pppoatm: use tasklet_init to initialize wakeup
 tasklet
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161197380840.28728.8716479368308672118.git-patchwork-notify@kernel.org>
Date:   Sat, 30 Jan 2021 02:30:08 +0000
References: <20210127173256.13954-1-kernel@esmil.dk>
In-Reply-To: <20210127173256.13954-1-kernel@esmil.dk>
To:     Emil Renner Berthing <kernel@esmil.dk>
Cc:     netdev@vger.kernel.org, mitch@sfgoth.com, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 27 Jan 2021 18:32:55 +0100 you wrote:
> Previously a temporary tasklet structure was initialized on the stack
> using DECLARE_TASKLET_OLD() and then copied over and modified. Nothing
> else in the kernel seems to use this pattern, so let's just call
> tasklet_init() like everyone else.
> 
> Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
> 
> [...]

Here is the summary with links:
  - [1/2] net: atm: pppoatm: use tasklet_init to initialize wakeup tasklet
    https://git.kernel.org/netdev/net-next/c/a5b88632fc96
  - [2/2] net: atm: pppoatm: use new API for wakeup tasklet
    https://git.kernel.org/netdev/net-next/c/a58745979cdd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


