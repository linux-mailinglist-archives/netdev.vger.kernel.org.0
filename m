Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51D9E455C11
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 14:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235158AbhKRNEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 08:04:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:52682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244433AbhKRNDN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 08:03:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 981556124B;
        Thu, 18 Nov 2021 13:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637240412;
        bh=drOXdrLs1gvxQSOKb/m+6uXo0ib3X0iwjOT3EhXYufc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XhVIs/APCZwGNgxPeyzyqSOIFuYciUYZvt+ZmsQIwovvN0Wxvpcz7lzQvvejShbBW
         LBNoVsCjWt4GuLldwQBlDnRFHrtxP7bdKqA5muuKNuVM2+jZj+DOB3+Krit7dr6Ov9
         tq2ypRWvYliiz3CFK0tJaXt8c/OuWq4C+46BmQOJTCM5MWTFnHUNmxb4tjZaxGamt8
         r763GSWBlQA9d+uSXlVY6/yWwKgomBk2EJEGOFl11W20vbceCQVcx5S8oSBOCkW8g6
         CLTjCAdogrHwHUj/BdGvNmzm7n45s4GlFJz+ORaRKXRGfl3gQ1CKOW8SDH9awblP2M
         7pLnadp/UHv0w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8511860BE1;
        Thu, 18 Nov 2021 13:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v7 net-next 0/8] net: dsa: felix: psfp support on vsc9959
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163724041253.16944.2537212050004573959.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Nov 2021 13:00:12 +0000
References: <20211118101204.4338-1-xiaoliang.yang_1@nxp.com>
In-Reply-To: <20211118101204.4338-1-xiaoliang.yang_1@nxp.com>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, allan.nielsen@microchip.com,
        joergen.andreasen@microchip.com, UNGLinuxDriver@microchip.com,
        vinicius.gomes@intel.com, jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, po.liu@nxp.com, leoyang.li@nxp.com,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, matthias.bgg@gmail.com,
        horatiu.vultur@microchip.com, vladimir.oltean@nxp.com,
        kuba@kernel.org, mingkai.hu@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 18 Nov 2021 18:11:56 +0800 you wrote:
> VSC9959 hardware supports Per-Stream Filtering and Policing(PSFP).
> This patch series add PSFP support on tc flower offload of ocelot
> driver. Use chain 30000 to distinguish PSFP from VCAP blocks. Add gate
> and police set to support PSFP in VSC9959 driver.
> 
> v6-v7 changes:
>  - Add a patch to restrict psfp rules on ingress port.
>  - Using stats.drops to show the packet count discarded by the rule.
> 
> [...]

Here is the summary with links:
  - [v7,net-next,1/8] net: mscc: ocelot: add MAC table stream learn and lookup operations
    https://git.kernel.org/netdev/net-next/c/0568c3bf3f34
  - [v7,net-next,2/8] net: mscc: ocelot: set vcap IS2 chain to goto PSFP chain
    https://git.kernel.org/netdev/net-next/c/5b1918a54a91
  - [v7,net-next,3/8] net: mscc: ocelot: add gate and police action offload to PSFP
    https://git.kernel.org/netdev/net-next/c/23e2c506ad6c
  - [v7,net-next,4/8] net: dsa: felix: support psfp filter on vsc9959
    https://git.kernel.org/netdev/net-next/c/7d4b564d6add
  - [v7,net-next,5/8] net: dsa: felix: add stream gate settings for psfp
    https://git.kernel.org/netdev/net-next/c/23ae3a787771
  - [v7,net-next,6/8] net: mscc: ocelot: use index to set vcap policer
    https://git.kernel.org/netdev/net-next/c/77043c37096d
  - [v7,net-next,7/8] net: dsa: felix: use vcap policer to set flow meter for psfp
    https://git.kernel.org/netdev/net-next/c/76c13ede7120
  - [v7,net-next,8/8] net: dsa: felix: restrict psfp rules on ingress port
    https://git.kernel.org/netdev/net-next/c/a7e13edf37be

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


