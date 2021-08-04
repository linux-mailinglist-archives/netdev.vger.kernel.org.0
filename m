Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0753E0057
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 13:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237757AbhHDLkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 07:40:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:45648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237592AbhHDLkS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 07:40:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 038F560F6F;
        Wed,  4 Aug 2021 11:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628077206;
        bh=XJaPec5/QHyjwGWIlKEDZ0VG4U3aPIU3P+nAsdhBwPk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HP/JX1SCq3YkDqETXyF7AZCtdvPukk6NVtfUIYjW6isxzvFKIl+uAQKxJ03v1OAt/
         yb8oamdizt0Sq2R8NVK2GBxwstPxAqdwlQYPa03TfWszzU226F+UIiEy7v7syI7k3v
         SAomqwWNeS2hJ+xE2N4LVyEppwa/n8pwPnOR6lP8dUTJy6RW0ZDl+2eiEPO2VriKgj
         ALJlqAhAwoEyN0bXynBlPbxM/zZsvwJ8jFY0+JlWTv59HEoiv8tUccYcAqlgLqxCFY
         DdKOIEiic1CXEHUb8Gw0+kVXhYr/ag0+X2Ryhgo2alghiRynbUtqBJ3LcKHqQVUmUg
         oDkGUKzUaanEQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E805760A6A;
        Wed,  4 Aug 2021 11:40:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/2] Convert switchdev_bridge_port_{,un}offload to
 notifiers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162807720594.23179.2687228457044533864.git-patchwork-notify@kernel.org>
Date:   Wed, 04 Aug 2021 11:40:05 +0000
References: <20210803203409.1274807-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210803203409.1274807-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        jiri@resnulli.us, idosch@idosch.org, roopa@nvidia.com,
        nikolay@nvidia.com, stephen@networkplumber.org,
        bridge@lists.linux-foundation.org, grygorii.strashko@ti.com,
        arnd@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue,  3 Aug 2021 23:34:07 +0300 you wrote:
> The introduction of the explicit switchdev bridge port offloading API
> has introduced dependency regressions between switchdev drivers and the
> bridge, with some drivers where switchdev support was optional before
> being now compiled as a module when the bridge is a module, or worse.
> 
> This patch makes the switchdev bridge port offload/unoffload events
> visible on the blocking notifier call chain, so that the bridge can
> indirectly do something when those events happen, without the driver
> explicitly calling a symbol exported by the bridge driver.
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/2] net: make switchdev_bridge_port_{,unoffload} loosely coupled with the bridge
    https://git.kernel.org/netdev/net-next/c/957e2235e526
  - [v2,net-next,2/2] Revert "net: build all switchdev drivers as modules when the bridge is a module"
    https://git.kernel.org/netdev/net-next/c/a54182b2a518

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


