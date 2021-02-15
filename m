Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A80FB31C3B8
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 22:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbhBOVkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 16:40:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:32862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229672AbhBOVkr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 16:40:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 5CDB664DEB;
        Mon, 15 Feb 2021 21:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613425207;
        bh=xXDgbmCvMByeguzNNrVs0rzribh/UXqQZkR8JiA1cac=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mEklzFyITI7HfGvxcTNomBeYqavx9L5YeN5V1jXn7TerxmrudAQlBH6j7hhttcVZP
         tYael+rWEtJvwS7oE5hkBSa1bja3nQ7MjvrIxlaQDUKWYqnB2Nzco11nrYwhua36Hx
         d67JS8bUiN3SgosURH4Jle9iNDbzNw+STFX6aRn2jKpkFzeBogVMjsp6mNUHmZfpFt
         JfsGwTviW1Ow36nGD1uq0tkdZnB1RsioJVRjGrZFAE0y0Q9d9EskQGOnXR18c5o/aJ
         pACXrg3FBvx3+7nkZpVQdeOijYmGIoXnpjxHK6EfPvJFLvmAHZZXNpfi/mBR/c+xlc
         CkY9nasm5VEAg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4B9DD609D9;
        Mon, 15 Feb 2021 21:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next] net: mvpp2: Add TX flow control support for jumbo frames
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161342520730.31720.8887474879408839310.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Feb 2021 21:40:07 +0000
References: <1613402622-11451-1-git-send-email-stefanc@marvell.com>
In-Reply-To: <1613402622-11451-1-git-send-email-stefanc@marvell.com>
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org,
        linux@armlinux.org.uk, mw@semihalf.com, andrew@lunn.ch,
        rmk+kernel@armlinux.org.uk, atenart@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 15 Feb 2021 17:23:42 +0200 you wrote:
> From: Stefan Chulski <stefanc@marvell.com>
> 
> With MTU less than 1500B on all ports, the driver uses per CPU pool mode.
> If one of the ports set to jumbo frame MTU size, all ports move
> to shared pools mode.
> Here, buffer manager TX Flow Control reconfigured on all ports.
> 
> [...]

Here is the summary with links:
  - [net-next] net: mvpp2: Add TX flow control support for jumbo frames
    https://git.kernel.org/netdev/net-next/c/3a616b92a9d1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


