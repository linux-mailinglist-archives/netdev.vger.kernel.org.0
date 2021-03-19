Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C31E3412B7
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 03:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbhCSCUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 22:20:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:54226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231208AbhCSCUR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 22:20:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6C6FE64F59;
        Fri, 19 Mar 2021 02:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616120412;
        bh=ABAV+GtWTj0yNWmVaKVC+ztiljfXjUsAHuDycuirLTc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ukLc2Kz/jdiqXpnQCiFofHMuEZS2Kc2/P2avympQTj/6KYGzpHoD9yZVvJ1ic340U
         c2bHrnpg4SV9h2ZkXizRev8LxH7MFKar8x4wj0V4SlO93sr2pubgUJ2Bp2OQhWtrsH
         uqY9+8CNpyH2fEbKwEom1HALkoCnwCXOl7rXEI4AWREM9OO0vihAgpYGqcVxZnd86P
         SzGRpLAjIMakY4LyeHwirSDrTSEJL6A8z648CTw/RnsI57M+lW1FBQkij5aH3m/q0r
         uz+UpWijE6fJPUMir2Di2gDlrcUeGYtuMfBLUTBnkHJ/+7TaByWqfbRTIp2onJmYbT
         ik0/FSdZCetlQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6111B60191;
        Fri, 19 Mar 2021 02:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ocelot: support multiple bridges
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161612041239.22955.16889628451195926756.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Mar 2021 02:20:12 +0000
References: <20210318233636.3901069-1-olteanv@gmail.com>
In-Reply-To: <20210318233636.3901069-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        claudiu.manoil@nxp.com, UNGLinuxDriver@microchip.com,
        vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 19 Mar 2021 01:36:36 +0200 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The ocelot switches are a bit odd in that they do not have an STP state
> to put the ports into. Instead, the forwarding configuration is delayed
> from the typical port_bridge_join into stp_state_set, when the port enters
> the BR_STATE_FORWARDING state.
> 
> [...]

Here is the summary with links:
  - [net-next] net: ocelot: support multiple bridges
    https://git.kernel.org/netdev/net-next/c/df291e54ccca

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


