Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12273482BDB
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 17:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233361AbiABQUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 11:20:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232476AbiABQUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 11:20:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B6B7C061784;
        Sun,  2 Jan 2022 08:20:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9335A60F2F;
        Sun,  2 Jan 2022 16:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F383DC36AF7;
        Sun,  2 Jan 2022 16:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641140410;
        bh=fHPkSq5tuHNMpjNNmo9oVMCrgs3exCVtpW3lELTZ5K4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EnxPB1s0xXndQc0+K0fe45YKUg4ICwuF6GweOjRf4FNOTQW4MvhMMkz5zYXFrzDjx
         hHDx2TW28Itxe0AJyb6w4pGs29msPnTdoaPEudY8M9PeDbstslpZyYzQ+YOXiXVpUp
         dMNEPauaT8Kq52I7gTwua81xXDYdFXGGUYgPHrrBgoXAeu35IZemF/r+lEOiy/oI3x
         UGqe3krmvBkipVYK7jTWX1kzwdcHRbTQJGWvaXhOMJiaJ45mAyEbbeZnWyXcCFfu0f
         F8orVoUv18hBJuHZo2B31pVPA7DAVTDu67Hlt37HSyk/5PcFFxItgREenLDbwXsjfI
         vKTgIqi49YWBQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DD5B8C395ED;
        Sun,  2 Jan 2022 16:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] enic: Remove usage of the deprecated "pci-dma-compat.h" API
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164114040990.20715.4916088969148860027.git-patchwork-notify@kernel.org>
Date:   Sun, 02 Jan 2022 16:20:09 +0000
References: <5080845d91e115300252298fe17fac5333458491.1641118952.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <5080845d91e115300252298fe17fac5333458491.1641118952.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     benve@cisco.com, _govind@gmx.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun,  2 Jan 2022 11:23:39 +0100 you wrote:
> In [1], Christoph Hellwig has proposed to remove the wrappers in
> include/linux/pci-dma-compat.h.
> 
> Some reasons why this API should be removed have been given by Julia
> Lawall in [2].
> 
> A coccinelle script has been used to perform the needed transformation
> Only relevant parts are given below.
> 
> [...]

Here is the summary with links:
  - enic: Remove usage of the deprecated "pci-dma-compat.h" API
    https://git.kernel.org/netdev/net-next/c/60c332029c8d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


