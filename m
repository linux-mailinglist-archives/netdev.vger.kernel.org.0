Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73DC130EB5B
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 05:02:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232893AbhBDEB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 23:01:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:33428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231580AbhBDEAv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 23:00:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id CA91364F59;
        Thu,  4 Feb 2021 04:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612411208;
        bh=dC6YDXLaPlk3oZMq5v9ba/lwJu3P5hpKYRpxHhOicn8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=f3p9z4FMdrq815asAytwtONdRioMZUOV4E6agfqDoewcWOV3MkFpiXqPr8pGe8EFW
         WllZAwGUsBBQwill/5gKQNIc9YkzHvbkvUOvHP/5jjUyZP/IFuGc5UOUvcH7x7dEWx
         OW0t7kd0BgmdNp2j5ejJJNnlE6wcWegjOkc5awBZigBRLU2oFBvtimwA/LSmUUTmKC
         uuqKDUI0r9h/Fh6IJ8Tz+nsNbVadn4gcb3Ch4UAD9MWiPnxRVaM4DJHzYmEYmlRZY0
         GJPXNOcqDltDQuTRQVpUcdJ52Y/AkcXXawcyzSLEnKGP1l+JWaoQzJ5rfnXYlHtldK
         ljneAfQlVf/gA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B7C23609EB;
        Thu,  4 Feb 2021 04:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: fix
 SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING getting ignored
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161241120874.9496.9831318515299344960.git-patchwork-notify@kernel.org>
Date:   Thu, 04 Feb 2021 04:00:08 +0000
References: <20210202233109.1591466-1-olteanv@gmail.com>
In-Reply-To: <20210202233109.1591466-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        tobias@waldekranz.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed,  3 Feb 2021 01:31:09 +0200 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The bridge emits VLAN filtering events and quite a few others via
> switchdev with orig_dev = br->dev. After the blamed commit, these events
> started getting ignored.
> 
> The point of the patch was to not offload switchdev objects for ports
> that didn't go through dsa_port_bridge_join, because the configuration
> is unsupported:
> - ports that offload a bonding/team interface go through
>   dsa_port_bridge_join when that bonding/team interface is later bridged
>   with another switch port or LAG
> - ports that don't offload LAG don't get notified of the bridge that is
>   on top of that LAG.
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: fix SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING getting ignored
    https://git.kernel.org/netdev/net-next/c/99b8202b179f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


