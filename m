Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 158C92FAADF
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 21:06:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437779AbhARUEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 15:04:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:51150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437878AbhARUCD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 15:02:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 2DDD922C9D;
        Mon, 18 Jan 2021 20:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611000081;
        bh=wTUj/qqu+DOdpJ7t1Y5SKjMazNvE1kcPpJFIGeM9TRE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LgJlzDBXV5vJW0XEB4qiH15RKxYFzxX+oJiErkaZzXq5/6RMUK0tc4N6iVmmz10oT
         RHErDdFM9md9CuI7Sd68KfBcWUcYF3606MFX0Odi1F7VModP2kGAHQfCC3W3DB9tPE
         M5Jy2QKLDPtEL5iDAPkaZeD+nw8BotvtBOtH82igfzHlnw1wOBMQg78Tlyh425Y3IY
         zN0eM0HjuI22RoLfZT65q/++fStpR5iLK4seGyzGeEJqE0Pm2u7TJPfAkCG8aZ/fPO
         aQUmbFbXPx06qrutJ40vDZPymK63r2sxXVQ+8wMreeW733sLekhTTegurhQ38mQWG1
         HYyXUMlOAEN7Q==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 24405602DA;
        Mon, 18 Jan 2021 20:01:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: mscc: ocelot: allow offloading of bridge on top of
 LAG
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161100008114.27498.14137284904429172922.git-patchwork-notify@kernel.org>
Date:   Mon, 18 Jan 2021 20:01:21 +0000
References: <20210118135210.2666246-1-olteanv@gmail.com>
In-Reply-To: <20210118135210.2666246-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 18 Jan 2021 15:52:10 +0200 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The blamed commit was too aggressive, and it made ocelot_netdevice_event
> react only to network interface events emitted for the ocelot switch
> ports.
> 
> In fact, only the PRECHANGEUPPER should have had that check.
> 
> [...]

Here is the summary with links:
  - [net] net: mscc: ocelot: allow offloading of bridge on top of LAG
    https://git.kernel.org/netdev/net/c/79267ae22615

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


