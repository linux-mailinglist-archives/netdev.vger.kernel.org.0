Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49CE74711B0
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 06:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbhLKFXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 00:23:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbhLKFXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 00:23:50 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D937C061714;
        Fri, 10 Dec 2021 21:20:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C8363CE2F2A;
        Sat, 11 Dec 2021 05:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F1350C341CC;
        Sat, 11 Dec 2021 05:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639200011;
        bh=bDE5jB5DJs4EW+BBUMZ7xF0HH/3wVQi6lfXAvPPLZTY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EuB+J43G1RjOnBPrMXqDFsR8/FCkaJ+Iw3qnf2dn/BLDew3yg+Gw5e6Nd8qnxqxCt
         FnRH7qSVjtnk9DWJFxtm0bqnKlwGDlhLi2gCkyqLn3Kg/fMnGRUv6lBB1QfaidUpL3
         GRClbFShnhTkrYL1wLsRuuyHaeyTay0JnqYHuBYRf3DSg2Ac9i7tncyXhX0TjzLp+1
         KyrAgwxPmH8XrDERsURaie32d8jym6kFXrb0IBycWTnr5UZawdXiqbOYJnIqUXFbin
         mQ5yttAk7ObrpYYhztu2iyj/eGa7B/pqa85ijjV5uOele4ooJaRgVMB70WrTePJWVC
         7hgrbh7eanttQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DCD7060A36;
        Sat, 11 Dec 2021 05:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v8 0/4] Add FDMA support on ocelot switch driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163920001089.8891.12593419816777020015.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Dec 2021 05:20:10 +0000
References: <20211209154911.3152830-1-clement.leger@bootlin.com>
In-Reply-To: <20211209154911.3152830-1-clement.leger@bootlin.com>
To:     =?utf-8?b?Q2zDqW1lbnQgTMOpZ2VyIDxjbGVtZW50LmxlZ2VyQGJvb3RsaW4uY29tPg==?=@ci.codeaurora.org
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, f.fainelli@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        dkirjanov@suse.de, jwi@linux.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  9 Dec 2021 16:49:07 +0100 you wrote:
> This series adds support for the Frame DMA present on the VSC7514
> switch. The FDMA is able to extract and inject packets on the various
> ethernet interfaces present on the switch.
> 
> ------------------
> Changes in V8:
>   - Rebase on net-next/master
> 
> [...]

Here is the summary with links:
  - [net-next,v8,1/4] net: ocelot: export ocelot_ifh_port_set() to setup IFH
    https://git.kernel.org/netdev/net-next/c/e5150f00721f
  - [net-next,v8,2/4] net: ocelot: add and export ocelot_ptp_rx_timestamp()
    https://git.kernel.org/netdev/net-next/c/b471a71e525c
  - [net-next,v8,3/4] net: ocelot: add support for ndo_change_mtu
    https://git.kernel.org/netdev/net-next/c/de5841e1c93f
  - [net-next,v8,4/4] net: ocelot: add FDMA support
    https://git.kernel.org/netdev/net-next/c/753a026cfec1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


