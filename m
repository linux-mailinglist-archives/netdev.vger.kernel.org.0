Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A96F3477DDC
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 21:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241479AbhLPUvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 15:51:45 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57514 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234139AbhLPUvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 15:51:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87DAE61F80
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 20:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DC57EC36AF0;
        Thu, 16 Dec 2021 20:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639687900;
        bh=SXquT4UP4ERczoNTYBz6KlFITa06ZR35eL88HGjflDg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qmX90vWgvJXpR2YNXHxGHc2N8AocAmwO39Vj0Cu9tGO26JXgrxfubuwAomfNMNEKe
         u7kaObds5yX0eQ50rA3e/ouNPOYraDGyKGD5/7QTmKb3eH7QMA0Q/qxCH+2iMh/nCq
         7fFlCin/dOJ4t3JD4l6e4bXnsHxonmGoDW8SeIRdmbGzfN07lqpE394IruVldupjcr
         vBvV+pHi3dPPQW/HHsm89knu+J610ecgSHbKopxYcKWlK9k7rYbi3xseXD1JJB1pD6
         HeEwgSIlZLKhc2i2AwvL0cLNp+H9BzUawQ3VIdHOTlmB/ze6gNiplWXCFz4p3POMqL
         xxyi1mKxoPmxQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BC1F860BC9;
        Thu, 16 Dec 2021 20:51:40 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sit: do not call ipip6_dev_free() from sit_init_net()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163968790076.17466.8885189288109698760.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Dec 2021 20:51:40 +0000
References: <20211216111741.1387540-1-eric.dumazet@gmail.com>
In-Reply-To: <20211216111741.1387540-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, syzkaller@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 16 Dec 2021 03:17:41 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> ipip6_dev_free is sit dev->priv_destructor, already called
> by register_netdevice() if something goes wrong.
> 
> Alternative would be to make ipip6_dev_free() robust against
> multiple invocations, but other drivers do not implement this
> strategy.
> 
> [...]

Here is the summary with links:
  - [net] sit: do not call ipip6_dev_free() from sit_init_net()
    https://git.kernel.org/netdev/net/c/e28587cc491e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


