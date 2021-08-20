Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA6643F2D47
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 15:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240703AbhHTNk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 09:40:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:56754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232665AbhHTNkq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 09:40:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B63B061157;
        Fri, 20 Aug 2021 13:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629466808;
        bh=OgFeBlAxzRYUo/gT3DfEvqcX+cDoxg9wP38wmVK+Nz4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CkdkZFZvtJf6XMrPrRzLMJ345hBZG53FKhr/ZpZ8fSqUGxJTWO2qMjTczheINUVbx
         wVprrOlE+Ebty/r0z7G2Z+V/5aeIKKYlcSQYluggJgO9mD64/m6kqPWuYFbRnqKGg+
         sUyp08Xih0Op2+iFaahgwFkFHHMFdlatlEWLrQgjKkJAaZihcIe6PzfC8oXDylnoKp
         93+Z5UIu+AIZ7DUDBIFqbpjy19E3sGuv9H3zKt9d3pBGC4Cb96B3iMLOg1cJ/+EPey
         JdliVBl7OzigsTgd3XVQoabrb7pdt3zynFmJanSgmWtpZSntkgEUqploNTcsp4PE8z
         UdVsBI1K+M24A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A538960A94;
        Fri, 20 Aug 2021 13:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/3] Add Xilinx GMII2RGMII loopback support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162946680867.23508.17751840651047181515.git-patchwork-notify@kernel.org>
Date:   Fri, 20 Aug 2021 13:40:08 +0000
References: <20210819131154.6586-1-gerhard@engleder-embedded.com>
In-Reply-To: <20210819131154.6586-1-gerhard@engleder-embedded.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 19 Aug 2021 15:11:51 +0200 you wrote:
> The Xilinx GMII2RGMII driver overrides PHY driver functions in order to
> configure the device according to the link speed of the PHY attached to
> it. This is implemented for a normal link but not for loopback.
> 
> Andrew told me to use phy_loopback and this changes make phy_loopback
> work in combination with Xilinx GMII2RGMII.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/3] net: phy: Support set_loopback override
    https://git.kernel.org/netdev/net-next/c/4ed311b08a91
  - [net-next,v2,2/3] net: phy: Uniform PHY driver access
    https://git.kernel.org/netdev/net-next/c/3ac8eed62596
  - [net-next,v2,3/3] net: phy: gmii2rgmii: Support PHY loopback
    https://git.kernel.org/netdev/net-next/c/ceaeaafc8b62

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


