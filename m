Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0AB340FD6
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 22:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233189AbhCRVaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 17:30:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233071AbhCRVaK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 17:30:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 10E9164F04;
        Thu, 18 Mar 2021 21:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616103010;
        bh=dodt2zfBtUPZ2Vaqq2iMQL4WaLFMh7ND3Df1/qPw8kM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Zz8BxaHg0yX2UwJi97wz0j9gIWh++r8KR1BcIsdX97kmWQSyf8SWpP2i8guKr5v6x
         as79VfBpJOCyCuqueb3r0zK5WIdjDYETFK6kWqvJbgZTWV91GmktrP0QOHn8BlP69N
         mQ9qeBOfcslOq0Ib49j06VfNjq5d8SUpm3lV3T/kuCxvODtNqM6Q/cFB1Wjr+muk29
         2tzUkFcmoIQKZat1EkKJIy1QT9FN4cNoUNRO8PR27zDSqxkt8jxc/cV284DmrrqkkB
         n1075v5KwsyQ8FCO2yjotjjCDwsLnUA22VhCq70RWldnSCCfYqfiSn/oTeJ+KwRxK9
         jH/ZWLqs5sg6Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 00D03600DF;
        Thu, 18 Mar 2021 21:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net PATCH v2 0/8] octeontx2: miscellaneous fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161610300999.15925.7886227573771700760.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Mar 2021 21:30:09 +0000
References: <20210318141549.2622-1-hkelam@marvell.com>
In-Reply-To: <20210318141549.2622-1-hkelam@marvell.com>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net,
        willemdebruijn.kernel@gmail.com, andrew@lunn.ch,
        sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, sbhatta@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Thu, 18 Mar 2021 19:45:41 +0530 you wrote:
> This series of patches fixes various issues related to NPC MCAM entry
> management, debugfs, devlink, CGX LMAC mapping, RSS config etc
> 
> Change-log:
> v2:
> Fixed below review comments
> 	- corrected Fixed tag syntax with 12 digits SHA1
>           and providing space between SHA1 and subject line
> 	- remove code improvement patch
> 	- make commit description more clear
> 
> [...]

Here is the summary with links:
  - [net,v2,1/8] octeontx2-pf: Do not modify number of rules
    https://git.kernel.org/netdev/net/c/f41b2d67d767
  - [net,v2,2/8] octeontx2-af: Formatting debugfs entry rsrc_alloc.
    https://git.kernel.org/netdev/net/c/f7884097141b
  - [net,v2,3/8] octeontx2-af: Remove TOS field from MKEX TX
    https://git.kernel.org/netdev/net/c/ce86c2a531e2
  - [net,v2,4/8] octeontx2-af: Return correct CGX RX fifo size
    https://git.kernel.org/netdev/net/c/297887872973
  - [net,v2,5/8] octeontx2-af: Fix irq free in rvu teardown
    https://git.kernel.org/netdev/net/c/ae2619dd4fcc
  - [net,v2,6/8] octeontx2-pf: Clear RSS enable flag on interace down
    https://git.kernel.org/netdev/net/c/f12098ce9b43
  - [net,v2,7/8] octeontx2-af: fix infinite loop in unmapping NPC counter
    https://git.kernel.org/netdev/net/c/64451b98306b
  - [net,v2,8/8] octeontx2-af: Fix uninitialized variable warning
    https://git.kernel.org/netdev/net/c/8c16cb0304cd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


