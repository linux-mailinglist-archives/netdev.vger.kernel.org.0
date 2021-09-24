Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8D8D41750A
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 15:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346760AbhIXNOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 09:14:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:38844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346921AbhIXNMO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 09:12:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CD0B361107;
        Fri, 24 Sep 2021 13:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632489007;
        bh=UHXYWEwl3iCIu8JpZuPoXawNHyW1sFFmUuXapSS/vrg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ag8zYqAgC0D5Q6mb7tIMzYYImcWnGbwInmZTlRJz0YUifrFYTDVDckrFpci8JshT9
         Bsp8IbanpHX3BKZPqoN/hEaVgJagtRNpvjPysACkqSLf0/mUicdWzkuFbRIbInE5IM
         FqgyTZw+cX9DydnNPwutKjNFoAXKK/bV+uOhmcmFoHsDsl0rfy089csjwBlnm7+ate
         qgBAB8UErITAMKe7lcwUKmdkSkfU7yJ6g507c2WFtJ4YbJhjpF3dW7SIc4dbG11MZl
         zLrFCtF9BbRbjasrKEzixXB1AjAbIAtmJH0Zj3KW+1Wnw/+B0u4QK/yA7Ygsw/MFP3
         4N93JsD5YHfZg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B515860BC9;
        Fri, 24 Sep 2021 13:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: enetc: fix the incorrect clearing of IF_MODE bits
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163248900773.23178.3959977128709226870.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Sep 2021 13:10:07 +0000
References: <20210923132333.2929379-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210923132333.2929379-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, claudiu.manoil@nxp.com,
        davem@davemloft.net, kuba@kernel.org, rmk+kernel@armlinux.org.uk,
        pavel@denx.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 23 Sep 2021 16:23:33 +0300 you wrote:
> The enetc phylink .mac_config handler intends to clear the IFMODE field
> (bits 1:0) of the PM0_IF_MODE register, but incorrectly clears all the
> other fields instead.
> 
> For normal operation, the bug was inconsequential, due to the fact that
> we write the PM0_IF_MODE register in two stages, first in
> phylink .mac_config (which incorrectly cleared out a bunch of stuff),
> then we update the speed and duplex to the correct values in
> phylink .mac_link_up.
> 
> [...]

Here is the summary with links:
  - [net] net: enetc: fix the incorrect clearing of IF_MODE bits
    https://git.kernel.org/netdev/net/c/325fd36ae76a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


