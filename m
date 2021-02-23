Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBD033223DD
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 02:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbhBWBvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 20:51:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:40844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230306AbhBWBu7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 20:50:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id AF8E06148E;
        Tue, 23 Feb 2021 01:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614045018;
        bh=k5cw67OB1Dh43kPNXbmJnFCSZPXw0rvMJUvwXkrETWo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JX/efaIW7CBGRyHZqdJmxIl3ZdxCqP1VkKJpExgCAEhw2uUnMaB+43dnfMV13MVCQ
         9iiMcFERMavNIwM1zlvn4+rjSPwxW/2vewJhH7vpsDt5ue7Dx31HEWBi3ZFUiaVLJa
         tMCkgQKNz/BzbG2iHxT1EWCrQDZtFa1x1MQhhKDofeAJWEVpuoRbhOK6vAtHF+1CVT
         UVnFCEm1Vh9NfSG40CWR54dWcAHR5N/nYFOJoR54flPWt55UTdwQ8afAQnPxqQPjoF
         aYcl2kifosvrqR/7BTdp5iGfmc11YbIFlFhSS6LbZBCK4HgliFL4wxU3HvYbuk6rXJ
         y60GnEqvY532Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A3FAD609F4;
        Tue, 23 Feb 2021 01:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ag71xx: remove unnecessary MTU reservation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161404501866.32555.16906265914403348947.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Feb 2021 01:50:18 +0000
References: <20210218034514.3421-1-dqfext@gmail.com>
In-Reply-To: <20210218034514.3421-1-dqfext@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     linux@rempel-privat.de, chris.snook@gmail.com, davem@davemloft.net,
        kuba@kernel.org, p.zabel@pengutronix.de, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rosenp@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 18 Feb 2021 11:45:14 +0800 you wrote:
> 2 bytes of the MTU are reserved for Atheros DSA tag, but DSA core
> has already handled that since commit dc0fe7d47f9f.
> Remove the unnecessary reservation.
> 
> Fixes: d51b6ce441d3 ("net: ethernet: add ag71xx driver")
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] net: ag71xx: remove unnecessary MTU reservation
    https://git.kernel.org/netdev/net/c/04b385f32508

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


