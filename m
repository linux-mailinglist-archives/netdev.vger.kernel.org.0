Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A163631C31E
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 21:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbhBOUlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 15:41:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:53664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229706AbhBOUkt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 15:40:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id BB54064DE0;
        Mon, 15 Feb 2021 20:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613421608;
        bh=L6EiOcCQUysvHdkTDhzvQP2HWY3qW0TmmQBGZa+cY1s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aMtqKak2C1V5nRRpUs1hKH1UtzD+72iQ3Z6JLgTBntjXsqAsmATDw7JJNXTwcOUwb
         er0kvh85ALXbU0vYpL2XXzOV07Yvay7AUjJHSdT1dw7Qa2kNR2EwM+71bo6YRaHmM4
         OPEm0okJMW4uhN9gouTGwTYDTo8tZ2JXmndIRef6zkz2OcU1Y3RQGkpN9Au8xmtEFT
         uX52nNlmBTzNbfwVBzRZSgJG+2UVY3r1aP55hh3jgi4U0ZHOPWiOVfhh2j4DTRmbXc
         X5j5CCZXbKCQtTGdNlKnlZpr6/KANR/n05XuM83kCuvMcHx0idhNBXGfVJpZyGDoDr
         8vtLM2uZz9qDA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AA246609EA;
        Mon, 15 Feb 2021 20:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 0/4] net: mvpp2: Minor non functional driver code
 improvements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161342160869.4070.12270754155424060613.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Feb 2021 20:40:08 +0000
References: <1613309917-17569-1-git-send-email-stefanc@marvell.com>
In-Reply-To: <1613309917-17569-1-git-send-email-stefanc@marvell.com>
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org,
        linux@armlinux.org.uk, mw@semihalf.com, andrew@lunn.ch,
        rmk+kernel@armlinux.org.uk, atenart@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sun, 14 Feb 2021 15:38:33 +0200 you wrote:
> From: Stefan Chulski <stefanc@marvell.com>
> 
> The patch series contains minor code improvements and did not change any functionality.
> 
> Stefan Chulski (4):
>   net: mvpp2: simplify PPv2 version ID read
>   net: mvpp2: improve Packet Processor version check
>   net: mvpp2: improve mvpp2_get_sram return
>   net: mvpp2: improve Networking Complex Control register naming
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] net: mvpp2: simplify PPv2 version ID read
    https://git.kernel.org/netdev/net-next/c/8b986866b252
  - [net-next,2/4] net: mvpp2: improve Packet Processor version check
    https://git.kernel.org/netdev/net-next/c/f704177e4721
  - [net-next,3/4] net: mvpp2: improve mvpp2_get_sram return
    https://git.kernel.org/netdev/net-next/c/9ad78d81cb76
  - [net-next,4/4] net: mvpp2: improve Networking Complex Control register naming
    https://git.kernel.org/netdev/net-next/c/935a11845aef

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


