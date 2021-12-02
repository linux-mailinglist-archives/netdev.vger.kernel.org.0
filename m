Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8430946637B
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 13:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357916AbhLBMYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 07:24:00 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:58672 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357803AbhLBMXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 07:23:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BC4ABCE2287;
        Thu,  2 Dec 2021 12:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E6AB6C53FD0;
        Thu,  2 Dec 2021 12:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638447610;
        bh=6J6AwA04SRZ1NmKk3leojBGv3J9nUQAPs/X1VtO134s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=alpQaMlJR5zScWa3liovxUUaynH2iEs1y4dbTku1Blijse84bs/GeRKurRh3x1hRt
         E47bR4nb1aJsEokD1YtU6yldcNeR9ekFJ7OhGj6KrJOS6+I3wpulZ/diM+/b0uqwYF
         DKzHEkvDmlY8fiAaJFaeFIgzBZcrz+Otvgcej600YLe9xhLW9+8MCPwYtXC814JNKJ
         FaU1LfQzu38OWbv7gnAxQjjhz7Q2kUl2eeoinE6+4iLqLm7IGxILD+fyEFENo7cflZ
         Z3Qm8fHNbhXBPM3jvyfGx5cuTWU9DOVKl7lG2gCrXy9XYRBVejWXplYZoi4UT6677u
         VcRLoV0O6/YQA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CA7AA60C73;
        Thu,  2 Dec 2021 12:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Fix Comment of ETH_P_802_3_MIN
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163844761082.9736.16565927232767799008.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Dec 2021 12:20:10 +0000
References: <20211201025713.185516-1-xiayu.zhang@mediatek.com>
In-Reply-To: <20211201025713.185516-1-xiayu.zhang@mediatek.com>
To:     <xiayu.zhang@mediatek.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, haijun.liu@mediatek.com,
        zhaoping.shu@mediatek.com, hw.he@mediatek.com,
        srv_heupstream@mediatek.com, Xiayu.Zhang@mediatek.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 1 Dec 2021 10:57:13 +0800 you wrote:
> From: Xiayu Zhang <Xiayu.Zhang@mediatek.com>
> 
> The description of ETH_P_802_3_MIN is misleading.
> The value of EthernetType in Ethernet II frame is more than 0x0600,
> the value of Length in 802.3 frame is less than 0x0600.
> 
> Signed-off-by: Xiayu Zhang <Xiayu.Zhang@mediatek.com>
> 
> [...]

Here is the summary with links:
  - Fix Comment of ETH_P_802_3_MIN
    https://git.kernel.org/netdev/net/c/72f6a45202f2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


