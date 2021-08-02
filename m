Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED563DD712
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 15:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233866AbhHBNaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 09:30:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:45738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233785AbhHBNaS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 09:30:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C1FD460FA0;
        Mon,  2 Aug 2021 13:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627911008;
        bh=6byxklf3tXmbGBuOIwTISyxM/MeDA9y5F1VzAhqlYt0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=meezNmxSDLW6Cjmzw3SDNoUZvFONp+gMMjZYDewQaOljiK6t6QPsls4zuzPCDdxCq
         cXHZ8d7/71+iQGn0yjsBybAudOob+MwHc34CkTlcygInEC2ZKC5hTHu6b8vGkeNshu
         /U9LLUdZhOGgJFRac9fsty1uX2ZRS/2iMSMPghbohoEd+wEsYiVOuolVYPgGAhLFce
         fHoB9rAqo0hU2LZqAmD5DGsHkA86SIR1/Djm4aU3agOMac1XRGmSQG+R+y9Soe+mRF
         XEa86k5YYiR13CDz4FcKLI+dwekGqUxBAJEqy9Iea7OBAiCbaFX4+c8xniMe/t5l06
         zTYhs3niHpJzw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BCBD160A44;
        Mon,  2 Aug 2021 13:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/6] FDB fixes for NXP SJA1105
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162791100876.19987.8798167357147623017.git-patchwork-notify@kernel.org>
Date:   Mon, 02 Aug 2021 13:30:08 +0000
References: <20210730171815.1773287-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210730171815.1773287-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Fri, 30 Jul 2021 20:18:09 +0300 you wrote:
> I have some upcoming patches that make heavy use of statically installed
> FDB entries, and when testing them on SJA1105P/Q/R/S and SJA1110, it
> became clear that these switches do not behave reliably at all.
> 
> - On SJA1110, a static FDB entry cannot be installed at all
> - On SJA1105P/Q/R/S, it is very picky about the inner/outer VLAN type
> - Dynamically learned entries will make us not install static ones, or
>   even if we do, they might not take effect
> 
> [...]

Here is the summary with links:
  - [net,1/6] net: dsa: sja1105: fix static FDB writes for SJA1110
    https://git.kernel.org/netdev/net/c/cb81698fddbc
  - [net,2/6] net: dsa: sja1105: overwrite dynamic FDB entries with static ones in .port_fdb_add
    https://git.kernel.org/netdev/net/c/e11e865bf84e
  - [net,3/6] net: dsa: sja1105: invalidate dynamic FDB entries learned concurrently with statically added ones
    https://git.kernel.org/netdev/net/c/6c5fc159e092
  - [net,4/6] net: dsa: sja1105: ignore the FDB entry for unknown multicast when adding a new address
    https://git.kernel.org/netdev/net/c/728db843df88
  - [net,5/6] net: dsa: sja1105: be stateless with FDB entries on SJA1105P/Q/R/S/SJA1110 too
    https://git.kernel.org/netdev/net/c/589918df9322
  - [net,6/6] net: dsa: sja1105: match FDB entries regardless of inner/outer VLAN tag
    https://git.kernel.org/netdev/net/c/47c2c0c23121

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


