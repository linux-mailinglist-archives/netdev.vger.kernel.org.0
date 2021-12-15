Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED25F475771
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 12:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236971AbhLOLK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 06:10:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236869AbhLOLKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 06:10:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D300C061401;
        Wed, 15 Dec 2021 03:10:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5EA41B81EC8;
        Wed, 15 Dec 2021 11:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 15FE2C34610;
        Wed, 15 Dec 2021 11:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639566613;
        bh=/9SGSmznkAYvwsAB4BUXl/njyTR/hG6Li1x5OQaZhcE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XZXw0n2g1dUsAe3nKEfzGdQXIqwgWr5W0O88xtL1zh1YZeOR+T2GL9iy9ZwusZcli
         hQ9mvtUiBh45+omc3lOTATZGDpMFRQOReOETGkGoD0g0HuHLalsRxK/Mqj4zTUOqag
         YN7G42nInEjUSVxiQrX/sRQyxka6akEerRPTn8FSCYt2uzCTRnmnJ73J9ClPn2Oq4X
         9+vKWec94LFWTmHq/a/BKUPE/Q9BLCJVLOgWx5Aohpp/mqCUFRnFW2GOIrObzt9CkZ
         jLFzfpImIZkCElCtAADTbI4PymkSA2gvwfxWAZR+C5siJAPivrwUW+1gyPBUfcnUTS
         8wwBqrxDS2p4A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E391660A53;
        Wed, 15 Dec 2021 11:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2 net-next] net: fec: fix system hang during suspend/resume
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163956661292.16045.5095227847396469452.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Dec 2021 11:10:12 +0000
References: <20211214105046.31901-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20211214105046.31901-1-qiangqing.zhang@nxp.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 14 Dec 2021 18:50:46 +0800 you wrote:
> 1. During normal suspend (WoL not enabled) process, system has posibility
> to hang. The root cause is TXF interrupt coming after clocks disabled,
> system hang when accessing registers from interrupt handler. To fix this
> issue, disable all interrupts when system suspend.
> 
> 2. System also has posibility to hang with WoL enabled during suspend,
> after entering stop mode, then magic pattern coming after clocks
> disabled, system will be waked up, and interrupt handler will be called,
> system hang when access registers. To fix this issue, disable wakeup
> irq in .suspend(), and enable it in .resume().
> 
> [...]

Here is the summary with links:
  - [V2,net-next] net: fec: fix system hang during suspend/resume
    https://git.kernel.org/netdev/net-next/c/0b6f65c707e5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


