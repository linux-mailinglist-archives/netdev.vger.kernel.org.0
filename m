Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C26C534F1FA
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 22:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233025AbhC3UKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 16:10:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:45886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232490AbhC3UKS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 16:10:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E3C43619CF;
        Tue, 30 Mar 2021 20:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617135017;
        bh=ES1zYMUoM0elRzZLXT3U58kwYaHThsITrHYDeAX7fG0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uTkpPCpyX+jxhfv2JAiyBRZF0uSHmXQNyU/yHPfZcxdrXCEab3/IUWX+hNdxNHfNX
         SYz6iTO0/vY0RqjrPwqBTHjif1f08w3jlf3uF9bKcQ3Hc1R+2wFpIQoke4NuUYsJRP
         RxBBjAzixNrv6y91cUN11tuOKiIdzy4jTYGTCBhcajTkrAOSY7w4qtAGCLhArpTFyI
         1cJcBkaU9PlQfirQaKyz/An0+PaZvkbZqaBpEhmWUkRibJ/j853p3h3NVb1YtJwzgK
         okrRr3NYN14WCUnyVCmutrrW9+CrHNrbK21RTudeP9KFRGKfefuCXIf1kU7SspX5ni
         ZBaf9dF+Qj12g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D616660A72;
        Tue, 30 Mar 2021 20:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: can-next 2021-03-30
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161713501787.31227.6004047342956439209.git-patchwork-notify@kernel.org>
Date:   Tue, 30 Mar 2021 20:10:17 +0000
References: <20210330114559.1114855-1-mkl@pengutronix.de>
In-Reply-To: <20210330114559.1114855-1-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (refs/heads/master):

On Tue, 30 Mar 2021 13:45:20 +0200 you wrote:
> Hello Jakub, hello David,
> 
> this is a pull request of 39 patches for net-next/master.
> 
> The first two patches update the MAINTAINERS file. One is by me and
> removes Dan Murphy from the from m_can and tcan4x5x. The other one is
> by Pankaj Sharma and updates the maintainership of the m-can mmio
> driver.
> 
> [...]

Here is the summary with links:
  - pull-request: can-next 2021-03-30
    https://git.kernel.org/netdev/net-next/c/9c0ee085c49c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


