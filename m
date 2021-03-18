Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C065F341024
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 23:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbhCRWAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 18:00:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:52070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231671AbhCRWAI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 18:00:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4B78B64F6C;
        Thu, 18 Mar 2021 22:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616104808;
        bh=rL5ST9Hj7XLE+lK0HBuR/l1w2Y2XDMoHGLj3jLXzyFk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SgM3e0OAYEohRvODRXe/Fdi/Wb0rth+sBkAruoNJqv9wYvsaf+yp3Mt3knDZ9vfuB
         mnkByv4unhzALbc4ykIHqyz51ZKtbkRk323xS5TCBO5c/A6BTASu3FMUMpQTu9Fari
         TKquufs+SLkzahh/BNCseUqv6Ty7PLQLIPwMjNPbuIxvNt8IX/Xh9SibbZntsO6gM1
         NXw7TyJ7G1CL0lNjD0PYqnwAji5DbL3fm7ftHKqqTAEe7L2tBgCHqFsfRbXdnQFhql
         wlQu1CiNN/6AXV2FhUinZUSUFq8NN7TUNmV0uPQVR3CJiUEKPQFAcGvrgHOal1ZgQX
         w18ygcBK26YcQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 37959600E8;
        Thu, 18 Mar 2021 22:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next V2 1/2] net: dsa: bcm_sf2: add function finding RGMII
 register
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161610480822.28103.17350861771579510660.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Mar 2021 22:00:08 +0000
References: <20210318080143.32449-1-zajec5@gmail.com>
In-Reply-To: <20210318080143.32449-1-zajec5@gmail.com>
To:     =?utf-8?b?UmFmYcWCIE1pxYJlY2tpIDx6YWplYzVAZ21haWwuY29tPg==?=@ci.codeaurora.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        rafal@milecki.pl
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 18 Mar 2021 09:01:42 +0100 you wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> Simple macro like REG_RGMII_CNTRL_P() is insufficient as:
> 1. It doesn't validate port argument
> 2. It doesn't support chipsets with non-lineral RGMII regs layout
> 
> Missing port validation could result in getting register offset from out
> of array. Random memory -> random offset -> random reads/writes. It
> affected e.g. BCM4908 for REG_RGMII_CNTRL_P(7).
> 
> [...]

Here is the summary with links:
  - [net-next,V2,1/2] net: dsa: bcm_sf2: add function finding RGMII register
    https://git.kernel.org/netdev/net-next/c/55cfeb396965
  - [net-next,V2,2/2] net: dsa: bcm_sf2: fix BCM4908 RGMII reg(s)
    https://git.kernel.org/netdev/net-next/c/6859d9154934

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


