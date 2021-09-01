Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB9853FD827
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 12:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239124AbhIAKvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 06:51:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:36610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234977AbhIAKvC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Sep 2021 06:51:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4FAD161054;
        Wed,  1 Sep 2021 10:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630493406;
        bh=uHRCHp0OWAtByBUP52vPT0yMGb+XsLjYIvhMuA9VNx4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AwVHNXIZMq022IDUyTvG/o8Kz5CR9/QBs80SnGnigPPpoGkpQsfuYWUJ2g4QCoF3O
         KDekMtrcZAplcS1XgMamPeo78s7KPnXt27D2TpsbaEJNsOtZkF91tGesEABD1T4XAg
         BaESUodBS3EjUSBGm2yA2J8aE664qidJ+zAiQ6Fz2EPvicVfQMrYLU0Cg1xqJ9SRTL
         wTchJJa8LYEa1GmvM4XkQKMAwvGde1KYsFqCDZC6hZ+k6mng5NfLErZ4ORWT4GzKOX
         L6Fb9eh+98vKqvvNnp/aHAEOkGbl+yll7vT1Ic9thyzPigjpVnS1Y1kHSx9B05uyrb
         mjdwYdjPscOyA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3FD0E609CF;
        Wed,  1 Sep 2021 10:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH] octeontx2-af: Add additional register check to
 rvu_poll_reg()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163049340625.3899.18268706137182004228.git-patchwork-notify@kernel.org>
Date:   Wed, 01 Sep 2021 10:50:06 +0000
References: <1630474739-25470-1-git-send-email-sgoutham@marvell.com>
In-Reply-To: <1630474739-25470-1-git-send-email-sgoutham@marvell.com>
To:     Sunil Goutham <sgoutham@marvell.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        smadarf@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 1 Sep 2021 11:08:59 +0530 you wrote:
> From: Smadar Fuks <smadarf@marvell.com>
> 
> Check one more time before exiting the API with an error.
> Fix API to poll at least twice, in case there are other high priority
> tasks and this API doesn't get CPU cycles for multiple jiffies update.
> 
> In addition, increase timeout from usecs_to_jiffies(10000) to
> usecs_to_jiffies(20000), to prevent the case that for CONFIG_100HZ
> timeout will be a single jiffies.
> A single jiffies results actual timeout that can be any time between
> 1usec and 10msec. To solve this, a value of usecs_to_jiffies(20000)
> ensures that timeout is 2 jiffies.
> 
> [...]

Here is the summary with links:
  - [net-next] octeontx2-af: Add additional register check to rvu_poll_reg()
    https://git.kernel.org/netdev/net/c/21274aa17819

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


