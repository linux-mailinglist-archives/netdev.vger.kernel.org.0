Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68AA73A5AA3
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 23:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbhFMVcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Jun 2021 17:32:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:56400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232087AbhFMVcJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Jun 2021 17:32:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B7FE761357;
        Sun, 13 Jun 2021 21:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623619807;
        bh=EPnmic1qiae6Uj6aIPU4YXMIMUGygUDIQszUiKijFwA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GrOzcHc/XFdYsOFQdlaAiQbk2xYskMw/LYdYxOxWxw8EGKQ63gTtgG8K2zUKBiuob
         ZZqnwceg2sYZ01UyNPHwJp+BgZ4zw+Ix14/ov9i5pPvzVknHbdRGe85QTttfogvsX0
         HQeIiZDo//TtTDopGtYBDdisFv42O8nV0dqL9GBigdIEaGgPshFZcFIdktSOCn4cDI
         z/tFq1CSSpereSr43mZK4LFSZl9LuSSZLOwgT3k+n+Ot2UrSV8cCVRs32+9W1l+RU+
         lg4EoH0GJ+v8/4RSMcupRAg4dz1cXVx28u0HBgtkp7vHEIdP79Im3mXNCl+G6qa7nE
         l9isl0Me/hKjg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AA872609AE;
        Sun, 13 Jun 2021 21:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V5 00/16] net: iosm: PCIe Driver for Intel M.2 Modem
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162361980669.14320.17522019509048799009.git-patchwork-notify@kernel.org>
Date:   Sun, 13 Jun 2021 21:30:06 +0000
References: <20210613125023.18945-1-m.chetan.kumar@intel.com>
In-Reply-To: <20210613125023.18945-1-m.chetan.kumar@intel.com>
To:     M Chetan Kumar <m.chetan.kumar@intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        johannes@sipsolutions.net, krishna.c.sudi@intel.com,
        linuxwwan@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sun, 13 Jun 2021 18:20:07 +0530 you wrote:
> The IOSM (IPC over Shared Memory) driver is a PCIe host driver implemented
> for linux or chrome platform for data exchange over PCIe interface between
> Host platform & Intel M.2 Modem. The driver exposes interface conforming to
> the MBIM protocol. Any front end application ( eg: Modem Manager) could
> easily manage the MBIM interface to enable data communication towards WWAN.
> 
> Intel M.2 modem uses 2 BAR regions. The first region is dedicated to Doorbell
> register for IRQs and the second region is used as scratchpad area for book
> keeping modem execution stage details along with host system shared memory
> region context details. The upper edge of the driver exposes the control and
> data channels for user space application interaction. At lower edge these data
> and control channels are associated to pipes. The pipes are lowest level
> interfaces used over PCIe as a logical channel for message exchange. A single
> channel maps to UL and DL pipe and are initialized on device open.
> 
> [...]

Here is the summary with links:
  - [V5,01/16] net: iosm: entry point
    https://git.kernel.org/netdev/net-next/c/7e98d785ae61
  - [V5,02/16] net: iosm: irq handling
    https://git.kernel.org/netdev/net-next/c/7f41ce085de0
  - [V5,03/16] net: iosm: mmio scratchpad
    https://git.kernel.org/netdev/net-next/c/dc0514f5d828
  - [V5,04/16] net: iosm: shared memory IPC interface
    https://git.kernel.org/netdev/net-next/c/3670970dd8c6
  - [V5,05/16] net: iosm: shared memory I/O operations
    https://git.kernel.org/netdev/net-next/c/edf6423c0403
  - [V5,06/16] net: iosm: channel configuration
    https://git.kernel.org/netdev/net-next/c/30ebda7a313d
  - [V5,07/16] net: iosm: wwan port control device
    https://git.kernel.org/netdev/net-next/c/10685b6e9868
  - [V5,08/16] net: iosm: bottom half
    https://git.kernel.org/netdev/net-next/c/3b575260cb86
  - [V5,09/16] net: iosm: multiplex IP sessions
    https://git.kernel.org/netdev/net-next/c/51c45fa95435
  - [V5,10/16] net: iosm: encode or decode datagram
    https://git.kernel.org/netdev/net-next/c/9413491e20e1
  - [V5,11/16] net: iosm: power management
    https://git.kernel.org/netdev/net-next/c/be8c936e540f
  - [V5,12/16] net: iosm: shared memory protocol
    https://git.kernel.org/netdev/net-next/c/faed4c6f6f48
  - [V5,13/16] net: iosm: protocol operations
    https://git.kernel.org/netdev/net-next/c/64516f633bfd
  - [V5,14/16] net: iosm: uevent support
    https://git.kernel.org/netdev/net-next/c/110e6e02eb19
  - [V5,15/16] net: iosm: net driver
    https://git.kernel.org/netdev/net-next/c/2a54f2c77934
  - [V5,16/16] net: iosm: infrastructure
    https://git.kernel.org/netdev/net-next/c/f7af616c632e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


