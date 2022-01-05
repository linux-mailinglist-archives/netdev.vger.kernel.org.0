Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A27C7485897
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 19:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243119AbiAESkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 13:40:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243111AbiAESkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 13:40:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE37C061245
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 10:40:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5166CB81D42
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 18:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0265CC36AE9;
        Wed,  5 Jan 2022 18:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641408010;
        bh=CAosNxvgPhN8cuQX3t+oiLHDTw7swXo+l2gXqoheb7Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uFxIFhbM4v4g8bz7Pg90DnhPpEGU1PoL1vm3LdBI9dVgYai2hZ9+He3sMuH8SQ/aG
         MqUCyFq2/ph/n/2rnfj+zBL0H0F1Sj5DKG+kkn1JVENqjG/gMH3nTFHu07P8TajmH6
         S5CVggCJTIIKQCkYGHh9H3JoLmBO4VWGx25+csj/8PaHkUsJdlviN0y3UQwa3sRaTS
         i9Xc5mC0qZWRZrnSPA0AriG9g5awAzCzKlmqd3khW+W5iqrKsr99HZq5sscuFuYvLu
         gxbnBnzRPHxixtrlNZrJIqLcFW0UY3a0jeozWYyRiDtxE/Ql6K/xiRQU+aywXIlnwV
         g6F4QnVstY52g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D68F6F79404;
        Wed,  5 Jan 2022 18:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] Fix RGMII delays for 88E1118
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164140800987.26997.5157711967698870664.git-patchwork-notify@kernel.org>
Date:   Wed, 05 Jan 2022 18:40:09 +0000
References: <YdR3wYFkm4eJApwb@shell.armlinux.org.uk>
In-Reply-To: <YdR3wYFkm4eJApwb@shell.armlinux.org.uk>
To:     Russell King (Oracle) <linux@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, clabbe.montjoie@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 4 Jan 2022 16:37:21 +0000 you wrote:
> Hi,
> 
> This series fixes the RGMII delays for 88E1118 Marvell PHYs, after a
> report by Corentin Labbe that the Marvell driver fails to work.
> 
> Patch 1 cleans up the paged register accesses in m88e1118_config_init()
> and patch 2 adds the RGMII delay configuration.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: phy: marvell: use phy_write_paged() to set MSCR
    https://git.kernel.org/netdev/net-next/c/5b8f970309dd
  - [net-next,2/2] net: phy: marvell: configure RGMII delays for 88E1118
    https://git.kernel.org/netdev/net-next/c/f22725c95ece

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


