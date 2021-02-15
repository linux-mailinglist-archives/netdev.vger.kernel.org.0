Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8621631C33F
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 21:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbhBOUvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 15:51:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:55078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229717AbhBOUus (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 15:50:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id B1D8E64DFD;
        Mon, 15 Feb 2021 20:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613422207;
        bh=u8DTV9oG73RJehGqnUlkBxjxW5jtI17fBA+fTgUPct4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=G0dXnTz9yCx65y60/tazucXkSzzOgoY05jgXHNammEqUPOjn2fr5r3kDgH86elpZf
         Neg9+yYIhadty+WdOO5fpH21Kv+MqRl0rsh/kElFpgZx2l92UDeGQ1HNIs9aPK5y+J
         Gi1+bSICWGzLKb/1dyFz9Qf+6fsbzmgPe2wkmiEaAom0cndQT0xCDw6DC9abdtRVqb
         aJ2MfzgOMzJxyC13v97gXQ4nmIIAAJFLJPyEC5hGCp3ZWA0875ZQU7XydFiic4dV3g
         /dUxuWzLx68EKLn+WNlZB8qKpSeex2bIynAtiLPD/FleSg1Qh+w5vW14kLNmCZQo44
         t+Qm0Q7G6leIg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AC13B6097B;
        Mon, 15 Feb 2021 20:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: mscc: ocelot: avoid type promotion when calling
 ocelot_ifh_set_dest
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161342220770.9745.16165409500210675219.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Feb 2021 20:50:07 +0000
References: <20210215133143.2425016-1-olteanv@gmail.com>
In-Reply-To: <20210215133143.2425016-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        vladimir.oltean@nxp.com, UNGLinuxDriver@microchip.com,
        dan.carpenter@oracle.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 15 Feb 2021 15:31:43 +0200 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Smatch is confused by the fact that a 32-bit BIT(port) macro is passed
> as argument to the ocelot_ifh_set_dest function and warns:
> 
> ocelot_xmit() warn: should '(((1))) << (dp->index)' be a 64 bit type?
> seville_xmit() warn: should '(((1))) << (dp->index)' be a 64 bit type?
> 
> [...]

Here is the summary with links:
  - [net-next] net: mscc: ocelot: avoid type promotion when calling ocelot_ifh_set_dest
    https://git.kernel.org/netdev/net-next/c/1f778d500df3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


