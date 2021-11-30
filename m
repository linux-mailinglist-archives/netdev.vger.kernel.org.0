Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0107463441
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 13:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241590AbhK3Mdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 07:33:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241583AbhK3Mdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 07:33:33 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C19F7C061574;
        Tue, 30 Nov 2021 04:30:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0900DCE198D;
        Tue, 30 Nov 2021 12:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3889BC53FC1;
        Tue, 30 Nov 2021 12:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638275410;
        bh=BJ9T3FNnRvhxz4szJraDXAdjmi4P9UuJ+CNLkgZW7Jk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mg9JoyndL3QzFic26VDYKDhiyC6GzjAdc/d6Oq+I+I3vwpENw5JWrB4kvjlF/r8bb
         NKLczQ9fmg7b0o3PEUSZ1BCZhnmY7O2fjDsIttJSE7VB9DlqixjHcFf35wqdTcA11e
         b74idoUHsP2EGwoCSOnQdyLyHXmeoUxDQUUr9xqDIH/XJ0KZtq83JZfIq3YN8PnPsF
         4+A82dzKduAgKCpHQNqVqFwtXkLq1wrBa06aelG6vp9qlAEz02XB09ibV/CE3ds1cA
         vVXV0Tah/Pc/r0Ao/TIG00noXIpD320f3zkd1pRzAcc+PbTZoiyIc/LZiAW1y/QL5x
         5WudH+Hdyg9+g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 109F560A50;
        Tue, 30 Nov 2021 12:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] dpaa2-eth: destroy workqueue at the end of remove function
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163827541006.1181.5056135751143485597.git-patchwork-notify@kernel.org>
Date:   Tue, 30 Nov 2021 12:30:10 +0000
References: <20211130040554.868846-1-mudongliangabcd@gmail.com>
In-Reply-To: <20211130040554.868846-1-mudongliangabcd@gmail.com>
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     ioana.ciornei@nxp.com, davem@davemloft.net, kuba@kernel.org,
        yangbo.lu@nxp.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 30 Nov 2021 12:05:54 +0800 you wrote:
> The commit c55211892f46 ("dpaa2-eth: support PTP Sync packet one-step
> timestamping") forgets to destroy workqueue at the end of remove
> function.
> 
> Fix this by adding destroy_workqueue before fsl_mc_portal_free and
> free_netdev.
> 
> [...]

Here is the summary with links:
  - dpaa2-eth: destroy workqueue at the end of remove function
    https://git.kernel.org/netdev/net/c/f4a8adbfe484

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


