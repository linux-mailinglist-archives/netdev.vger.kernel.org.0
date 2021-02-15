Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D982031C398
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 22:31:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhBOVav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 16:30:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:59684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229806AbhBOVas (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 16:30:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id EACA664E04;
        Mon, 15 Feb 2021 21:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613424608;
        bh=OVvntZiy32DAyaGWWDck39HdMqaTOfBUwOvpvBVVuiU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NQpiVVto0FF48RCYXK2PHVW5OsmDCb52eQHThKurR0L6PxXruzO9LYgfwpP888qOZ
         ByLfCOccdtxctU2IqXNVtqJctOPzw8+fBgNp5ORPDqRlN4KIxAB5sw87dWZ+ZdfBnK
         LdY5qjwSq38gFawUo1FUkSgF6Y58L+3Ty+WYlvUzPJaUCfjmFUekZo4ybloaJaEDst
         eF0+ppnqGmEsQj7Us2eqp6s6C3A41sdKEKpsCo45daA3SnjOq8fWLzCfM16nR68sV4
         AAiNUi2HCxJj4wnJhbBSapMqdUtI6424hB9DbHIXMMcZdq5iJhlGxXQw/UEL07zsaP
         1F1xP82YIW09Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E42C4609D9;
        Mon, 15 Feb 2021 21:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: sja1105: make devlink property
 best_effort_vlan_filtering true by default
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161342460793.27343.7413548209539655176.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Feb 2021 21:30:07 +0000
References: <20210213204632.1227098-1-olteanv@gmail.com>
In-Reply-To: <20210213204632.1227098-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 13 Feb 2021 22:46:32 +0200 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The sja1105 driver has a limitation, extensively described under
> Documentation/networking/dsa/sja1105.rst and
> Documentation/networking/devlink/sja1105.rst, which says that when the
> ports are under a bridge with vlan_filtering=1, traffic to and from
> the network stack is not possible, unless the driver-specific
> best_effort_vlan_filtering devlink parameter is enabled.
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: sja1105: make devlink property best_effort_vlan_filtering true by default
    https://git.kernel.org/netdev/net-next/c/8841f6e63f2c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


