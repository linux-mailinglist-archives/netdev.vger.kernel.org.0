Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A966C488DB2
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 02:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237759AbiAJBAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 20:00:23 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59004 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237699AbiAJBAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 20:00:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 804AD610A7;
        Mon, 10 Jan 2022 01:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 42901C36B0D;
        Mon, 10 Jan 2022 01:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641776414;
        bh=YvLDByRfF2X2n4Xcwxe3RiePY6WQIqiC/svno//r7vs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MX2KyUa48e3zm7/yTyn7ExaHlmCjnKxTfnqon6BK8dDglUt9BemZfw4sw29tC0zcE
         6jYP1OSGWv9a9/+UdhI1asxL0wuRyn9pa8AukQjFirNRonHhSsRMTc02povXwihjwd
         zEVkEgZ0JiVjQJOowB/dWvJLawGOxlGQGqoLyCfSJQuXOgRW/ZZYkPQqVHq1g+oxDH
         GeVFYQ7V/exSyKG+R+JVPy737qQPJuOnVzxSwosYhFd6Xtyirrch/aQQxAv61Lwgcn
         d1HyudBBrKygbS1LZbxMfzz050hbEoUzW2/t4E0kIjN03itHQ2VtjHD2d7cTZvMGjF
         CI5YBaq9Z2F/g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 31532F60790;
        Mon, 10 Jan 2022 01:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] rocker: Remove useless DMA-32 fallback configuration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164177641419.18208.6006211503621263592.git-patchwork-notify@kernel.org>
Date:   Mon, 10 Jan 2022 01:00:14 +0000
References: <9ba2d13099d216f3df83e50ad33a05504c90fe7c.1641744274.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <9ba2d13099d216f3df83e50ad33a05504c90fe7c.1641744274.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     jiri@resnulli.us, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun,  9 Jan 2022 17:04:48 +0100 you wrote:
> As stated in [1], dma_set_mask() with a 64-bit mask never fails if
> dev->dma_mask is non-NULL.
> So, if it fails, the 32 bits case will also fail for the same reason.
> 
> Simplify code and remove some dead code accordingly.
> 
> [1]: https://lkml.org/lkml/2021/6/7/398
> 
> [...]

Here is the summary with links:
  - rocker: Remove useless DMA-32 fallback configuration
    https://git.kernel.org/netdev/net-next/c/7ac2d77c97d0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


