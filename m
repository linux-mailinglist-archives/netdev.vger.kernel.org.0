Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1DE38CFA1
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 23:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbhEUVLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 17:11:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:34436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229589AbhEUVLe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 17:11:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C9D0E613F6;
        Fri, 21 May 2021 21:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621631410;
        bh=4TY0mNhSnF1PS8/AXXe5UyKtAtoZmScYIMrKGiQT+g8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DGxDYGN4Uu/O82qqNAQw71POYUlx86tBH6nLE7E1j8WaPwIXI1sPXQTKL4VmHeru6
         CwO0D0UrYfM+U1su9ToyCRTzYo1UQ1+VKXGNrDcL/pPUp5YsCnNgIPV6fr1SGGt1i/
         eWQudV2yiqUhJwuBUeN0yBiYnbIKNgUad/MynINmU0Xo2ysE14s7lmM3IoBRClem+5
         +XvZtaBxNl6Vy6jyI5h3ABofGlENtzu6lOb/GV+lt5sTFE66lPUqOzOUkl672DTcoo
         nZZkiCK8LxQEgCt3X/tqmwl27cMc82Ht/FWEPV+qgxs7dskoTFXoqd79hibR+fa5zg
         v0/OwITLZ3gdg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BB29460BCF;
        Fri, 21 May 2021 21:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] Ethtool statistics counters cleanup for SJA1105
 DSA driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162163141076.28899.14145976767970780002.git-patchwork-notify@kernel.org>
Date:   Fri, 21 May 2021 21:10:10 +0000
References: <20210521131608.4018058-1-olteanv@gmail.com>
In-Reply-To: <20210521131608.4018058-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 21 May 2021 16:16:06 +0300 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This series removes some reported data from ethtool -S which were not
> counters at all, and reorganizes the code such that counters can be read
> individually and not just all at once.
> 
> Vladimir Oltean (2):
>   net: dsa: sja1105: stop reporting the queue levels in ethtool port
>     counters
>   net: dsa: sja1105: don't use burst SPI reads for port statistics
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: dsa: sja1105: stop reporting the queue levels in ethtool port counters
    https://git.kernel.org/netdev/net-next/c/30a2e9c0f5cf
  - [net-next,2/2] net: dsa: sja1105: don't use burst SPI reads for port statistics
    https://git.kernel.org/netdev/net-next/c/039b167d68a3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


