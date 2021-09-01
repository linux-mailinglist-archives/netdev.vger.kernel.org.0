Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 930513FD82A
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 12:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240666AbhIAKvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 06:51:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:36632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236310AbhIAKvD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Sep 2021 06:51:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6844461074;
        Wed,  1 Sep 2021 10:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630493406;
        bh=st4GADhuxx6BbE2BwKF3i1QhHN8Iv/32rOvsZjB4rdg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O02ygn7APxeUMbxX3zxOwNsNPYBOA9Yo7scCfIXSlVuAsP1Hyzo4secAl2pAfd+6j
         wF+HbdxWAsv15o8GJTGDaHOMV15MxivaiTDR8RjQ4QFl1hG+qWs0FhABWNSQ6SdYZ0
         E+cDvtIOQtC+6XIrwuYgGfErRTciSpZNBUgg+TJ255X71C8Fh+yxgf6X6H32uBrA6O
         OATwQmGBdAqdb0Cn6j8Oz6Q73pew/RDHWDTOdaDpEdNb6WXcN3izVqwzHvmkecmsVI
         md/kpd34vk3FaaCcgZwbH9VC351WTnPbjQUzHk7n5iWJGJQs60zrY31RFvHIJGF2c7
         7Ge/9wFtE1XAg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5A4C1609E7;
        Wed,  1 Sep 2021 10:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: dsa: tag_rtl4_a: Fix egress tags
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163049340636.3899.14664285703791719516.git-patchwork-notify@kernel.org>
Date:   Wed, 01 Sep 2021 10:50:06 +0000
References: <20210831185050.435767-1-linus.walleij@linaro.org>
In-Reply-To: <20210831185050.435767-1-linus.walleij@linaro.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, dqfext@gmail.com, sandberg@mailfence.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 31 Aug 2021 20:50:50 +0200 you wrote:
> I noticed that only port 0 worked on the RTL8366RB since we
> started to use custom tags.
> 
> It turns out that the format of egress custom tags is actually
> different from ingress custom tags. While the lower bits just
> contain the port number in ingress tags, egress tags need to
> indicate destination port by setting the bit for the
> corresponding port.
> 
> [...]

Here is the summary with links:
  - [net,v2] net: dsa: tag_rtl4_a: Fix egress tags
    https://git.kernel.org/netdev/net/c/0e90dfa7a8d8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


