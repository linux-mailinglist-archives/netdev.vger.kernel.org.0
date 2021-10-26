Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 084DB43B42B
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 16:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234864AbhJZOcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 10:32:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:45894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232502AbhJZOca (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 10:32:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D53DB6112D;
        Tue, 26 Oct 2021 14:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635258606;
        bh=PYXaPW41wVoZ0r4p0t1qDJhNc8Dj2xJBk3m5yGPN8A0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=X/XrnWz5lbRfRTrMzleKoX/PP1KKefKCavuvBgP3FH+Zld/sSunzjIxX+Of9XruS3
         lmym3OafBv7T8saYRoTNv2Aj1WharbCrOwJ7wiEtfqraLCMvrNc/JFmzn+ywyZopsm
         qTlGXtWkZCkGWdA2I4vMR7C1r5hZZzGAw5FAzeR062bZ11lt6uWuBz1yv1PQ2hN4ZS
         7bzMG2w+TIfmWCju4odaoFzQTdR/QuQeQZO+AZM6VVkFGcFk39pTj+IgtUQZjGL3CF
         qriRsWNL+gwc1I6KtJpjBltQPus9N1QEZeH+lqI1MU1Ob+NTEr0qY0BaTcelJhDSko
         ndC9XBVWBLurQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CAD96608FE;
        Tue, 26 Oct 2021 14:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] MAINTAINERS: please remove myself from the Prestera driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163525860682.23091.11533291061879015554.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Oct 2021 14:30:06 +0000
References: <20211026121907.6066-1-vadym.kochan@plvision.eu>
In-Reply-To: <20211026121907.6066-1-vadym.kochan@plvision.eu>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        tchornyi@marvell.com, vkochan@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 26 Oct 2021 15:19:07 +0300 you wrote:
> From: Vadym Kochan <vkochan@marvell.com>
> 
> Signed-off-by: Vadym Kochan <vkochan@marvell.com>
> ---
>  MAINTAINERS | 1 -
>  1 file changed, 1 deletion(-)

Here is the summary with links:
  - MAINTAINERS: please remove myself from the Prestera driver
    https://git.kernel.org/netdev/net/c/19fa0887c57d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


