Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA09394E4A
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 23:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbhE2Vbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 May 2021 17:31:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:47264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229476AbhE2Vbk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 May 2021 17:31:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E7BA16112F;
        Sat, 29 May 2021 21:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622323803;
        bh=aAK71qrGwVBqqbDiYf/mmlzUjQxhfFD9zImgOgXNoYQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cIHmSwlyZIkPZ94Fn9NrwOssze+1UzvZznhBBBq+se36B5Ih1sLS25/rnGTmUmKlP
         olZngE/SOqMuYI6BeOfvr3kJjZkwssr6RLHYsyLQuL/p/rTmLnJeyBuCZLA1+hehaI
         /Byhde97f2lVrOPV1yGE3ZgY2lBYZcbdMxqwFdkOCrT6sNs9twG76DlPYET9XnHYwf
         aoCQX4ON14OdP/wq2RsuHxNQLUpzOuuBbViCg++5ul+loJJ/VLKK/NmraZF5OekzDe
         ZFpJeXVAvOrIbWen1l2iLGLXZUA3I/vAUa/bvw+XlTHYK3pJsvR+zlq3GObiBFsJvg
         jmDN/TpHcfPVw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DB4A9609EA;
        Sat, 29 May 2021 21:30:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCHv3 0/5] NPC KPU updates
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162232380389.20597.3426693408177564545.git-patchwork-notify@kernel.org>
Date:   Sat, 29 May 2021 21:30:03 +0000
References: <20210527094439.1910013-1-george.cherian@marvell.com>
In-Reply-To: <20210527094439.1910013-1-george.cherian@marvell.com>
To:     George Cherian <george.cherian@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, gcherian@marvell.com,
        sgoutham@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 27 May 2021 15:14:34 +0530 you wrote:
> Add support for
>  - Loading Custom KPU profile entries
>  - Add NPC profile Load from System Firmware DB
>  - Add Support fo Coalescing KPU profiles
>  - General Updates/Fixes to default KPU profile
> 
> Changelog:
>  v2->v3
>  	Fix compilation warnings.
> 
> [...]

Here is the summary with links:
  - [net-next,PATCHv3,1/5] octeontx2-af: add support for custom KPU entries
    https://git.kernel.org/netdev/net-next/c/3a7244152f9c
  - [net-next,PATCHv3,2/5] octeontx2-af: load NPC profile via firmware database
    https://git.kernel.org/netdev/net-next/c/5d16250b6059
  - [net-next,PATCHv3,3/5] octeontx2-af: adding new lt def registers support
    https://git.kernel.org/netdev/net-next/c/c87e6b139579
  - [net-next,PATCHv3,4/5] octeontx2-af: support for coalescing KPU profiles
    https://git.kernel.org/netdev/net-next/c/11c730bfbf5b
  - [net-next,PATCHv3,5/5] octeontx2-af: Update the default KPU profile and fixes
    https://git.kernel.org/netdev/net-next/c/f9c49be90c05

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


