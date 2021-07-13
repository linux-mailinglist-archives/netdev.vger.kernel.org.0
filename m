Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB573C7512
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 18:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231793AbhGMQmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 12:42:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:42560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230087AbhGMQmx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Jul 2021 12:42:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8856460FF4;
        Tue, 13 Jul 2021 16:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626194403;
        bh=dIzjORgVfyazFDF9NHfZplwarqYDhNoktd5DuLwYqvg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=m8BLs1jNhKqi+BNe2FhRQWCsCT8dOKxm5ljj6uRWgf6CLZu14uwZ25vWaJB1+gWzD
         7pUccVLcs8E9Ett7EztpUcfbwhrxYZpNs9hU1mm+EyfWL/q0OGAqYRxFRFlDmIBAsp
         isuzdSpU6VApLAzGyp0otz7/6HAHBXibedhQNcvL5H4Pe27FwqlLXB83uvvWrKjwfJ
         mEdwzzwW+3BOAhuHiEvmSlh3ctRSBNDPK1jQtSWcqIcQMbslR00FnCAygsp0lGSjP+
         13MmKzR8Euo10WCTaKyfRxB6oEmTQOSJCtFL/3IvZDi1RgWqrTXRh6CGGVnDM0vEAv
         Cc9BwDfMP9YQw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7F3EB60A49;
        Tue, 13 Jul 2021 16:40:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ocelot: fix switchdev objects synced for wrong
 netdev with LAG offload
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162619440351.1289.6066043113914320699.git-patchwork-notify@kernel.org>
Date:   Tue, 13 Jul 2021 16:40:03 +0000
References: <20210713093350.939559-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210713093350.939559-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 13 Jul 2021 12:33:50 +0300 you wrote:
> The point with a *dev and a *brport_dev is that when we have a LAG net
> device that is a bridge port, *dev is an ocelot net device and
> *brport_dev is the bonding/team net device. The ocelot net device
> beneath the LAG does not exist from the bridge's perspective, so we need
> to sync the switchdev objects belonging to the brport_dev and not to the
> dev.
> 
> [...]

Here is the summary with links:
  - [net] net: ocelot: fix switchdev objects synced for wrong netdev with LAG offload
    https://git.kernel.org/netdev/net/c/e56c6bbd98dc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


