Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D460A472FC2
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 15:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239724AbhLMOuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 09:50:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239568AbhLMOuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 09:50:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E662C061574
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 06:50:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0B91B81115
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 14:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8F1A2C34603;
        Mon, 13 Dec 2021 14:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639407009;
        bh=VYCaQZfrP1yZptLwcn9OaIXIcl3Jlp1dcSY0RSGoyLI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MLH1uzW1pPMooEUp1nDnuWeGfj35Fjz7ROYwJvMAKBJ79RD6z2AgPiXMX/qHGe5V7
         2xx8bL61B8gRRAQlXyIpykWUmuEwQY7XrqdxMzWYNUz+aLevRBQBELFo9Uo7hkaZ4P
         mzZg7Mt/D1BPn6AXAAPDm2MYZdvyuT5wqBmgbmW/2QvD3D3qWiXtMQxsTLFZfsYPcn
         m3loIl4mOS4r9ZvidIJZXvUdI84VKkSF/BmgckY9Vm3oyXVkJ5hWp/qNotU0uGfsrp
         BQrZRcOnBfvchh2O9MZD7PomPdftPwCxdGRTokHfmjwpSv+Gyy+8SowhICniDOLyWG
         JwbiId1itdWiA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 565E8609F5;
        Mon, 13 Dec 2021 14:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: Unforce speed & duplex in
 mac_link_down()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163940700934.22565.1597859508541338036.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Dec 2021 14:50:09 +0000
References: <20211211225141.6626-1-kabel@kernel.org>
In-Reply-To: <20211211225141.6626-1-kabel@kernel.org>
To:     =?utf-8?q?Marek_Beh=C3=BAn_=3Ckabel=40kernel=2Eorg=3E?=@ci.codeaurora.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        andrew@lunn.ch, rmk+kernel@armlinux.org.uk
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 11 Dec 2021 23:51:41 +0100 you wrote:
> Commit 64d47d50be7a ("net: dsa: mv88e6xxx: configure interface settings
> in mac_config") removed forcing of speed and duplex from
> mv88e6xxx_mac_config(), where the link is forced down, and left it only
> in mv88e6xxx_mac_link_up(), by which time link is unforced.
> 
> It seems that (at least on 88E6190) when changing cmode to 2500base-x,
> if the link is not forced down, but the speed or duplex are still
> forced, the forcing of new settings for speed & duplex doesn't take in
> mv88e6xxx_mac_link_up().
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: mv88e6xxx: Unforce speed & duplex in mac_link_down()
    https://git.kernel.org/netdev/net/c/9d591fc028b6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


