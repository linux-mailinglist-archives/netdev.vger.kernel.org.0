Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60A364464F1
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 15:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233184AbhKEOcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 10:32:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:47772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233105AbhKEOcr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Nov 2021 10:32:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D4B086120E;
        Fri,  5 Nov 2021 14:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636122607;
        bh=RabxvYF8MZZnaFfJhLDyKcDazTYwHz1HTQ/AJEYwWIE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NNEy01GitXRvkQh1ABqGilGKA9Y7xFQlmtN+DPsrdmWZSBG1qZ2WjBy2VcnIuSl25
         DSafvpvMUp72AL3WFAP53wiKBlZfUVJjZilXLWv92q4n5aq7jgrozZ3WQ9OIUI+WJH
         64Nsz2WvCdvcApOYBWEjmVEoOapB7kpuxWkCb+Ab7qGLU4XbtFN7nFoVRGgTeeOyTN
         xujPThafhKXYiuUhnqIsKNKSf7V3BRt6+b1diJEZkK18dlBWsV3/eCDiviZyqgJ8QQ
         fF3nsdWh9lyjlFJJdjv/ZrpwPPlfwK97LI7tWsJ4l+OsdHtdrwrur3lyVSG2FOzOou
         y/zwPpgFrRtEg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C77FE60A3C;
        Fri,  5 Nov 2021 14:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: marvell: prestera: fix patchwork build problems
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163612260781.32748.8817987999743419122.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Nov 2021 14:30:07 +0000
References: <1636031573-20006-1-git-send-email-volodymyr.mytnyk@plvision.eu>
In-Reply-To: <1636031573-20006-1-git-send-email-volodymyr.mytnyk@plvision.eu>
To:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Cc:     netdev@vger.kernel.org, taras.chornyi@plvision.eu,
        mickeyr@marvell.com, serhiy.pshyk@plvision.eu, andrew@lunn.ch,
        arnd@arndb.de, geert@linux-m68k.org, dkirjanov@suse.de,
        vmytnyk@marvell.com, tchornyi@marvell.com, davem@davemloft.net,
        kuba@kernel.org, vkochan@marvell.com, yevhen.orlov@plvision.eu,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu,  4 Nov 2021 15:12:52 +0200 you wrote:
> From: Volodymyr Mytnyk <vmytnyk@marvell.com>
> 
> fix the remaining build issues reported by patchwork
> in firmware v4.0 support commit which has been already
> merged.
> 
> Fix patchwork issues:
>  - source inline
>  - checkpatch
> 
> [...]

Here is the summary with links:
  - [net] net: marvell: prestera: fix patchwork build problems
    https://git.kernel.org/netdev/net/c/a46a5036e7d2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


