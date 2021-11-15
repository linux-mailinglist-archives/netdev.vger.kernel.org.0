Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 413AC45069E
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 15:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232572AbhKOOYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 09:24:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:38606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236400AbhKOOXG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 09:23:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 70E6861BE2;
        Mon, 15 Nov 2021 14:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636986011;
        bh=BfZL5q0sK440f18vgm4f08TDEGzd0llC2s0A/rJ9bOo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Epks0kEWaYmiq+B9Vm7t/qnf7YAhJEpp7bRE4U61Nf5Lz0LowoUUH9FC1lv9LuvCs
         GvsYe74YFH4zYePE6PUkI/D2gMVsMSuP8ocPPSHfpXQaQUz5y2qjOry1wTwz2zeDis
         MSq4SPYh4bm6xxSVmLYgstZEWDaow+t9Bk+GWef/Ek/m6bZtJC3WT24NXC9P6kmpw5
         coYFUP5mbDu4Ntv4DjBShcOEHlaXlTCldh4UFsacV9RsKD21RmLjVpFFH89CgWWkMv
         D32PBKDTI2FrsCTkYVUUFAa/x7bwPBq9rxehxzsMgEuzeve15vWipchDEGU2Oh8b9a
         qEtwT/ZOqs/dg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6824560A49;
        Mon, 15 Nov 2021 14:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/6] MCTP I2C driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163698601142.19991.3686735228078461111.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Nov 2021 14:20:11 +0000
References: <20211115024926.205385-1-matt@codeconstruct.com.au>
In-Reply-To: <20211115024926.205385-1-matt@codeconstruct.com.au>
To:     Matt Johnston <matt@codeconstruct.com.au>
Cc:     zev@bewilderbeest.net, wsa@kernel.org, robh+dt@kernel.org,
        davem@davemloft.net, kuba@kernel.org, brendanhiggins@google.com,
        benh@kernel.crashing.org, joel@jms.id.au, andrew@aj.id.au,
        avifishman70@gmail.com, tmaimon77@gmail.com, tali.perry1@gmail.com,
        venture@google.com, yuenn@google.com, benjaminfair@google.com,
        jk@codeconstruct.com.au, linux-i2c@vger.kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 15 Nov 2021 10:49:20 +0800 you wrote:
> Hi,
> 
> This patch series adds a netdev driver providing MCTP transport over
> I2C.
> 
> It applies against net-next using recent MCTP changes there, though also
> has I2C core changes for review. I'll leave it to maintainers where it
> should be applied - please let me know if it needs to be submitted
> differently.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/6] i2c: core: Allow 255 byte transfers for SMBus 3.x
    https://git.kernel.org/netdev/net-next/c/13cae4a104d2
  - [net-next,v3,2/6] i2c: dev: Handle 255 byte blocks for i2c ioctl
    https://git.kernel.org/netdev/net-next/c/84a107e68b34
  - [net-next,v3,3/6] i2c: aspeed: Allow 255 byte block transfers
    https://git.kernel.org/netdev/net-next/c/1b2ba1f591c9
  - [net-next,v3,4/6] i2c: npcm7xx: Allow 255 byte block SMBus transfers
    https://git.kernel.org/netdev/net-next/c/3ef2de27a05a
  - [net-next,v3,5/6] dt-bindings: net: New binding mctp-i2c-controller
    https://git.kernel.org/netdev/net-next/c/0b6141eb2b14
  - [net-next,v3,6/6] mctp i2c: MCTP I2C binding driver
    https://git.kernel.org/netdev/net-next/c/80be9b2c0d93

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


