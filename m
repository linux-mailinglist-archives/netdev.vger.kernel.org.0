Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11828343095
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 03:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbhCUCBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 22:01:13 -0400
Received: from [198.145.29.99] ([198.145.29.99]:50386 "EHLO mail.kernel.org"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S229834AbhCUCBM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Mar 2021 22:01:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7973561949;
        Sun, 21 Mar 2021 02:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616292008;
        bh=4upLEcWF7lnivhUWmwwuhI20TRP2mDdKcttxEelX34c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QpeN4nat9gNd2KoHDQuxturhjTOpAvoaYKRqdufho+HARln6fvzQLzi423i84l8Rr
         6VEDoawePuX+/YxrJlY2Bh+GSHq3wt+jrzB6b4LilZcTEMRXaRQpwZKee1ctGIr+qJ
         VfK4A1pRQLrHXuZYGE+e0MSSoIwr8ivgPQ/tQbVb9vSJBzo9Lpxk8Sh4unP4s1hrPq
         qYqDYYkVj2o+j8P/S3+YLMRnoPoiuaHWkeMfyJr9YFSm+AuZCzaH3v7YstiD7pGZc6
         ZFAbZscOhtuOrm6aQth8AmR0W61xyz3AgAMC8clkdEjn2B4UrcbvAI0ii9Nw4egUyo
         hbJLzOop3lA2g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6BD40626ED;
        Sun, 21 Mar 2021 02:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: decnet: Fixed multiple coding style issues
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161629200843.1907.8812348851533857336.git-patchwork-notify@kernel.org>
Date:   Sun, 21 Mar 2021 02:00:08 +0000
References: <20210320061512.kztp7hijps4irjrl@ubuntu>
In-Reply-To: <20210320061512.kztp7hijps4irjrl@ubuntu>
To:     Sai Kalyaan Palla <saikalyaan63@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, gaurav1086@gmail.com,
        vfedorenko@novek.ru, andrew@lunn.ch, David.Laight@ACULAB.COM,
        linux-decnet-user@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bkkarthik@pesu.pes.edu
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 20 Mar 2021 11:45:12 +0530 you wrote:
> Made changes to coding style as suggested by checkpatch.pl
> changes are of the type:
> 	open brace '{' following struct go on the same line
> 	do not use assignment in if condition
> 
> Signed-off-by: Sai Kalyaan Palla <saikalyaan63@gmail.com>
> 
> [...]

Here is the summary with links:
  - net: decnet: Fixed multiple coding style issues
    https://git.kernel.org/netdev/net-next/c/b29648ad5b2a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


