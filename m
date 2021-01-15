Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9632F6FFD
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 02:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731541AbhAOBax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 20:30:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:58670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731514AbhAOBaw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 20:30:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id C176023A58;
        Fri, 15 Jan 2021 01:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610674211;
        bh=jO/7VoBdnp153aZ/9GAuOHrCO2FXId9zyeMWEtwoWDE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DSMmtHXS44Lg/LVb8GgWRenx7My2LSDyIENZo2BGwMRXildhTkeYGkJj1MT7Ni5Kn
         hmnHZvExZ9K3XBZauVpdYVcKEM4vf8QZdrxWg8YurbnbVhHfZgFxOPodbfLPJ5fDsj
         iDJW+op0AX4FL925gf7TwIYxEZNTGSi3fQYRxvzcS9P+rmlKy05WdVV6d2uVHKM91M
         xVS8gxXF3hlUvfGr8nuFlLW9MImDFx4Yj5VnBISxBbHylskIYfxp2gTtstSrMof1x2
         EV18byyyfo6f7PROgOyd3Kr2kD39Tr7GDVn/oP+oc78eKszPa6P6QnEXyVYEL2nm2K
         jgU2sPeNt5eqQ==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id B165760593;
        Fri, 15 Jan 2021 01:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 net-next 0/5] net: dsa: Link aggregation support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161067421172.20666.7709387943269301612.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Jan 2021 01:30:11 +0000
References: <20210113084255.22675-1-tobias@waldekranz.com>
In-Reply-To: <20210113084255.22675-1-tobias@waldekranz.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 13 Jan 2021 09:42:50 +0100 you wrote:
> Start of by adding an extra notification when adding a port to a bond,
> this allows static LAGs to be offloaded using the bonding driver.
> 
> Then add the generic support required to offload link aggregates to
> drivers built on top of the DSA subsystem.
> 
> Finally, implement offloading for the mv88e6xxx driver, i.e. Marvell's
> LinkStreet family.
> 
> [...]

Here is the summary with links:
  - [v5,net-next,1/5] net: bonding: Notify ports about their initial state
    https://git.kernel.org/netdev/net-next/c/32d4c5647aad
  - [v5,net-next,2/5] net: dsa: Don't offload port attributes on standalone ports
    https://git.kernel.org/netdev/net-next/c/5696c8aedfcc
  - [v5,net-next,3/5] net: dsa: Link aggregation support
    https://git.kernel.org/netdev/net-next/c/058102a6e9eb
  - [v5,net-next,4/5] net: dsa: mv88e6xxx: Link aggregation support
    https://git.kernel.org/netdev/net-next/c/57e661aae6a8
  - [v5,net-next,5/5] net: dsa: tag_dsa: Support reception of packets from LAG devices
    https://git.kernel.org/netdev/net-next/c/5b60dadb71db

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


