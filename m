Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 084423DFE28
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 11:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237143AbhHDJkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 05:40:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:41708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237035AbhHDJkU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 05:40:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BFD7C60EFD;
        Wed,  4 Aug 2021 09:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628070007;
        bh=QXpULJATBq1ZyXA3JX9FK+mWuomZpAHxFxxPXQSCX6g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JvmOqXldfE/BVuyTcMgRpXC0tK+0fyQ19jbtO/0K7LSUxLQYRuaMxmzwtvUV/JzlW
         3fJHgcVu75AyKAmUi9R+hLiuRYzuaTr01V/8l351dvdLalxjX/cWrC3hqdHwcmAdTA
         vOL7zsmZAlYoklbcVd09CT6aoE2saJbNfbEwWOxmXceqmj3XXYxOPmPUGvCGAlI9Kh
         zxo6k/2phGkRUgRh+kt/SiIGlC009iAMFnvGNFK54xWC0xVgKFKrxfKZg8QkVes9s6
         Znm+cOCtk8to8P74Imrl49luMcl7TrdlTtqVJKyDQzmFP00RZX1elQ6mK489SweGJx
         6EI5UE6Zih4Ww==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B0CC060A49;
        Wed,  4 Aug 2021 09:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/4] mt7530 software fallback bridging fix
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162807000771.29242.1625831528843804010.git-patchwork-notify@kernel.org>
Date:   Wed, 04 Aug 2021 09:40:07 +0000
References: <20210803160405.3025624-1-dqfext@gmail.com>
In-Reply-To: <20210803160405.3025624-1-dqfext@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     sean.wang@mediatek.com, Landen.Chao@mediatek.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, matthias.bgg@gmail.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        ericwouds@gmail.com, opensource@vdorst.com,
        frank-w@public-files.de, ilya.lipnitskiy@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed,  4 Aug 2021 00:04:00 +0800 you wrote:
> DSA core has gained software fallback support since commit 2f5dc00f7a3e
> ("net: bridge: switchdev: let drivers inform which bridge ports are
> offloaded"), but it does not work properly on mt7530. This patch series
> fixes the issues.
> 
> DENG Qingfang (4):
>   net: dsa: mt7530: enable assisted learning on CPU port
>   net: dsa: mt7530: use independent VLAN learning on VLAN-unaware
>     bridges
>   net: dsa: mt7530: set STP state on filter ID 1
>   net: dsa: mt7530: always install FDB entries with IVL and FID 1
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/4] net: dsa: mt7530: enable assisted learning on CPU port
    https://git.kernel.org/netdev/net-next/c/0b69c54c74bc
  - [net-next,v2,2/4] net: dsa: mt7530: use independent VLAN learning on VLAN-unaware bridges
    https://git.kernel.org/netdev/net-next/c/6087175b7991
  - [net-next,v2,3/4] net: dsa: mt7530: set STP state on filter ID 1
    https://git.kernel.org/netdev/net-next/c/a9e3f62dff3c
  - [net-next,v2,4/4] net: dsa: mt7530: always install FDB entries with IVL and FID 1
    https://git.kernel.org/netdev/net-next/c/73c447cacbbd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


