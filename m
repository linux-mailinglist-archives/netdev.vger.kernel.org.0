Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66CD348E928
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 12:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240819AbiANLaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 06:30:15 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52996 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240117AbiANLaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 06:30:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0397861F17
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 11:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BEEB4C36AF2;
        Fri, 14 Jan 2022 11:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642159810;
        bh=E5LT+oAo5Fk/JdTiZrtl9GV7Ce9I5RZcBDE51mYUc74=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BnVKdrWa7BDhVsEmHiiU5QgsGhaQe2wkrLy6e26CVmcjVW4zvssLUBiA5RwtiuE1A
         D5rm0QuZQzxOWZLlj7ZFbESihxHiQsFtgXdZlzEnqGtL86LyuArl0aMJyyos00bHGl
         d85MDkMMzrvzDvyn4lh+NwSJBUOag2UIQL85h2N9nyLs46bDuRC2d4yZNUm8D15MmI
         CviYRyAphES/BtmIB1+yMvmJPiCw7WA4dnZ0V5F4GPkZ4Ehfwe6QAkhDByx53NKUSK
         aZ4bT6ynngjgraNceyIwhzyhH9X2qFIaOk+JzUFOXuAf/8HJlXLi7LBLHKQf3D8VOw
         s1VhzvDP7O+0Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7AED7F6079E;
        Fri, 14 Jan 2022 11:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: apple: bmac: Fix build since dev_addr constification
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164215981049.30922.9359003030904189013.git-patchwork-notify@kernel.org>
Date:   Fri, 14 Jan 2022 11:30:10 +0000
References: <20220114031316.2419293-1-mpe@ellerman.id.au>
In-Reply-To: <20220114031316.2419293-1-mpe@ellerman.id.au>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        linuxppc-dev@lists.ozlabs.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 14 Jan 2022 14:13:16 +1100 you wrote:
> Since commit adeef3e32146 ("net: constify netdev->dev_addr") the bmac
> driver no longer builds with the following errors (pmac32_defconfig):
> 
>   linux/drivers/net/ethernet/apple/bmac.c: In function ‘bmac_probe’:
>   linux/drivers/net/ethernet/apple/bmac.c:1287:20: error: assignment of read-only location ‘*(dev->dev_addr + (sizetype)j)’
>    1287 |   dev->dev_addr[j] = rev ? bitrev8(addr[j]): addr[j];
>         |                    ^
> 
> [...]

Here is the summary with links:
  - net: apple: bmac: Fix build since dev_addr constification
    https://git.kernel.org/netdev/net/c/ea938248557a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


