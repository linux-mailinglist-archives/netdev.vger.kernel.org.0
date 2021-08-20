Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36C513F2D45
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 15:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240772AbhHTNkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 09:40:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:56726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229707AbhHTNkq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 09:40:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 949F76113B;
        Fri, 20 Aug 2021 13:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629466808;
        bh=rk4vLjCFkIyzeoQXoEgheO8tsy8mtZr39pH0sMQnd6U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OY2iBWW8fOqAQv84cEzeUHStRehNbBa4JJzFGJgPG5T/dLACq6TuQT+I/lPCG7zRb
         GM2UGc7BB7GmTI9gKCFgXTlxocc95WVSivtu5f4ayC6dhq62vw0KArEFZdXa/ilEIj
         wx+uANVAQ/lwEk5CYxRJ96Wjoy03u4pVBcrUZE4US1X0wa+mNbZ2MzWYXUcEEF5aDs
         6hGMGAwwJhrtEztcbVBMvm3AMQKQIRMQffzi+7O/w0bDOep6AfREoka/WOZjte3s+s
         cXf9iv3Y59hS/m/e2sLrTtlfySAqBysOldhYy7oVralYMR6nwruqX1fvDdIO2p6BKP
         EVt/K8wkN94Mg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8741F60A89;
        Fri, 20 Aug 2021 13:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] dpaa2-switch phylink fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162946680854.23508.11291320760114268111.git-patchwork-notify@kernel.org>
Date:   Fri, 20 Aug 2021 13:40:08 +0000
References: <20210819144019.2013052-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210819144019.2013052-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        ioana.ciornei@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 19 Aug 2021 17:40:17 +0300 you wrote:
> This is fixing two regressions introduced by the recent conversion of
> the dpaa2-switch driver to phylink.
> 
> Vladimir Oltean (2):
>   net: dpaa2-switch: phylink_disconnect_phy needs rtnl_lock
>   net: dpaa2-switch: call dpaa2_switch_port_disconnect_mac on probe
>     error path
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: dpaa2-switch: phylink_disconnect_phy needs rtnl_lock
    https://git.kernel.org/netdev/net-next/c/d52ef12f7d6c
  - [net-next,2/2] net: dpaa2-switch: call dpaa2_switch_port_disconnect_mac on probe error path
    https://git.kernel.org/netdev/net-next/c/860fe1f87eca

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


