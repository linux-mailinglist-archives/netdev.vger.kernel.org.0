Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9577C3F0E4D
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 00:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234708AbhHRWko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 18:40:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:55336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234586AbhHRWkl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 18:40:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AA3BF610CE;
        Wed, 18 Aug 2021 22:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629326406;
        bh=wz6MzdwSwLw9gaJnvpInjAB+7DDXbqkPXfHPq+iTxSg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=phm7m/Wubyt1WzdJAZvIF1lNAFjtpcilVw+1LFfQruUWwavGh3wk16bjmxA8rr/UE
         ENRwj/7yzKY9TA2qJBDow9xWGqTh29b9IGznN9JOWdF8PlxIMpN7Jf1KEEyf32Lp8t
         TD1bm9ATICtaqdaZn/W6rMl1z46s99BmzEOOra4dkeeb301xi2GS9uCnNyzJD512Gr
         g/ifVl/ki/eps+wfZfX6zcHdSvToQKwgEtr6gunXdw+ocG/mokPP9F9l6b0wyOfBV9
         Xxmlg2v8+PACjiZprP9C9XPRWKjEebr0XtRYUrZV6IlhcwMbG/j0dO2Qp3hwRf3Zi6
         Xj26JqkZcCDHA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A3DE060A2E;
        Wed, 18 Aug 2021 22:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: mscc: ocelot: allow forwarding from bridge ports to
 the tag_8021q CPU port
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162932640666.7744.10430826033368113071.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Aug 2021 22:40:06 +0000
References: <20210817160425.3702809-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210817160425.3702809-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 17 Aug 2021 19:04:25 +0300 you wrote:
> Currently we are unable to ping a bridge on top of a felix switch which
> uses the ocelot-8021q tagger. The packets are dropped on the ingress of
> the user port and the 'drop_local' counter increments (the counter which
> denotes drops due to no valid destinations).
> 
> Dumping the PGID tables, it becomes clear that the PGID_SRC of the user
> port is zero, so it has no valid destinations.
> 
> [...]

Here is the summary with links:
  - [net] net: mscc: ocelot: allow forwarding from bridge ports to the tag_8021q CPU port
    https://git.kernel.org/netdev/net/c/c1930148a394

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


