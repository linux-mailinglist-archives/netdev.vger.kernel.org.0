Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03886319641
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 00:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbhBKXBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 18:01:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:46476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230158AbhBKXBB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 18:01:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 5643164E45;
        Thu, 11 Feb 2021 23:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613084420;
        bh=hUAjqC2ipIs0Uawoeq3MF0KtoPUw2dEume6J2zh1Ok8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ChPHLGJR8M7fV0WOl7AU6sIHS2iI2uOJfasXJnzJDgJPlCVVLNxYHQFEFWGQmO6FI
         XE+DpVy0bm+NPz+62uHwsJhku474vUPnxP6zgiFkpTqIwFfdA5QBXvWZl5zDVm8Vi1
         LJAbvxk6HEuZgGdVuo2YO6zoHoRSsRZLC65M+/wDfDGTGe0pGrAxnUBGc40fTPJDX1
         VEPu9nOOJuPkMCYjp3f92UdQM7UYSlXn7A+hgXsQJCGjRHiJk4kKIycDFbajcAT2BZ
         ohBT04MBuvj29OJHnhz/j7qg/c8ReORddae8XgxWuqKFNH2q5OlTy04HRQkl3cDWZp
         B69j/Cwf74S5Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4170760A0F;
        Thu, 11 Feb 2021 23:00:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v13 net-next 00/15] net: mvpp2: Add TX Flow Control support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161308442026.22878.3631243118969933506.git-patchwork-notify@kernel.org>
Date:   Thu, 11 Feb 2021 23:00:20 +0000
References: <1613040542-16500-1-git-send-email-stefanc@marvell.com>
In-Reply-To: <1613040542-16500-1-git-send-email-stefanc@marvell.com>
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org,
        linux@armlinux.org.uk, mw@semihalf.com, andrew@lunn.ch,
        rmk+kernel@armlinux.org.uk, atenart@kernel.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        sebastian.hesselbarth@gmail.com, gregory.clement@bootlin.com,
        linux-arm-kernel@lists.infradead.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 11 Feb 2021 12:48:47 +0200 you wrote:
> From: Stefan Chulski <stefanc@marvell.com>
> 
> Armada hardware has a pause generation mechanism in GOP (MAC).
> The GOP generate flow control frames based on an indication programmed in Ports Control 0 Register. There is a bit per port.
> However assertion of the PortX Pause bits in the ports control 0 register only sends a one time pause.
> To complement the function the GOP has a mechanism to periodically send pause control messages based on periodic counters.
> This mechanism ensures that the pause is effective as long as the Appropriate PortX Pause is asserted.
> 
> [...]

Here is the summary with links:
  - [v13,net-next,01/15] doc: marvell: add CM3 address space and PPv2.3 description
    https://git.kernel.org/netdev/net-next/c/1c2b4812b7da
  - [v13,net-next,02/15] dts: marvell: add CM3 SRAM memory to cp11x ethernet device tree
    https://git.kernel.org/netdev/net-next/c/60523583b07c
  - [v13,net-next,03/15] net: mvpp2: add CM3 SRAM memory map
    https://git.kernel.org/netdev/net-next/c/e54ad1e01c00
  - [v13,net-next,04/15] net: mvpp2: always compare hw-version vs MVPP21
    https://git.kernel.org/netdev/net-next/c/60dcd6b7d96e
  - [v13,net-next,05/15] net: mvpp2: add PPv23 version definition
    https://git.kernel.org/netdev/net-next/c/6af27a1dc422
  - [v13,net-next,06/15] net: mvpp2: increase BM pool and RXQ size
    https://git.kernel.org/netdev/net-next/c/d07ea73f37f9
  - [v13,net-next,07/15] net: mvpp2: add FCA periodic timer configurations
    https://git.kernel.org/netdev/net-next/c/2788d8418af5
  - [v13,net-next,08/15] net: mvpp2: add FCA RXQ non occupied descriptor threshold
    https://git.kernel.org/netdev/net-next/c/bf270fa3c445
  - [v13,net-next,09/15] net: mvpp2: enable global flow control
    https://git.kernel.org/netdev/net-next/c/a59d354208a7
  - [v13,net-next,10/15] net: mvpp2: add RXQ flow control configurations
    https://git.kernel.org/netdev/net-next/c/3bd17fdc08e9
  - [v13,net-next,11/15] net: mvpp2: add ethtool flow control configuration support
    https://git.kernel.org/netdev/net-next/c/76055831cf84
  - [v13,net-next,12/15] net: mvpp2: add BM protection underrun feature support
    https://git.kernel.org/netdev/net-next/c/eb30b269549a
  - [v13,net-next,13/15] net: mvpp2: add PPv23 RX FIFO flow control
    https://git.kernel.org/netdev/net-next/c/aca0e23584c9
  - [v13,net-next,14/15] net: mvpp2: set 802.3x GoP Flow Control mode
    https://git.kernel.org/netdev/net-next/c/262412d55acd
  - [v13,net-next,15/15] net: mvpp2: add TX FC firmware check
    https://git.kernel.org/netdev/net-next/c/9ca5e767ec34

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


