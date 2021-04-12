Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA9FC35B78C
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 02:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236129AbhDLAA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 20:00:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:37016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235761AbhDLAA0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Apr 2021 20:00:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 14DBB60FE5;
        Mon, 12 Apr 2021 00:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618185609;
        bh=Ep0oVyD22xDacAhnrCxqKpILUQNVltZCjRY3F91XcRs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=H2BEqOES8D75o2oYWayapcqQAxbJAEcCCZuSMduuXESaaCOwN6wXEsbvSUgNbZ1G2
         Zc6Sq6k+S3FAxqIbphpNp7tMqcxmdSSGT3sR1ZhVZsv5UIcn3DkxqcYtcyzR1AURhp
         fIa9maSq39s8ti2Ol/cFse307n26K3EVplVQMK0E6C7R27Hldh1Zj5AIb7ztrss72O
         qNiYPPGKe7iFCAa1gn2ze5xj5EGroHe5TwI0tDr2JcMejUWMVUsYVv9vZqv4oKcfam
         e0zvg8NmbFB4FHnXIxkb/fW0cRuHRKeeJO2C3EendiuQMwgBwCznLjh+4ITkTVQbv9
         K93gJrEc7hsYQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F01CE60A09;
        Mon, 12 Apr 2021 00:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: davicom: Fix regulator not turned off on failed probe
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161818560897.30810.8669236543689433820.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Apr 2021 00:00:08 +0000
References: <88d396a107aad8059cabc3eb1f05f7d325287bf2.1618131620.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <88d396a107aad8059cabc3eb1f05f7d325287bf2.1618131620.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     davem@davemloft.net, kuba@kernel.org, paul@crapouillou.net,
        andrew@lunn.ch, gustavoars@kernel.org, paulburton@kernel.org,
        Zubair.Kakakhel@imgtec.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun, 11 Apr 2021 11:02:08 +0200 you wrote:
> When the probe fails, we must disable the regulator that was previously
> enabled.
> 
> This patch is a follow-up to commit ac88c531a5b3
> ("net: davicom: Fix regulator not turned off on failed probe") which missed
> one case.
> 
> [...]

Here is the summary with links:
  - net: davicom: Fix regulator not turned off on failed probe
    https://git.kernel.org/netdev/net/c/31457db3750c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


