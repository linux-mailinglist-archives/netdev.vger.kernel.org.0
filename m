Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEC0E4388DD
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 14:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbhJXMm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 08:42:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:43272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229867AbhJXMm1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Oct 2021 08:42:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 302E260F45;
        Sun, 24 Oct 2021 12:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635079207;
        bh=o7yue6WtkU4vnlDTWpyPInVW12kLaUYuydp3aqZlXcQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Z4l0YeP9O8TzVsWJ5kAVBXZuVFs+TWblH00kRIoZ687cHEPinnUCUfmFK4pF4M3T7
         QpfJbq7IjP+sp8I1o9Y9paHPio+kWEfMeiwnwN9efPzW+EXRrmc0OLRWeSgpJSb5+U
         1JTV2ThtrZeeKIhVzAGKr++W4CmN7BABh6DTxoFbcSxKRPf8GmXajNu2Y7wj+ZmQHb
         A7U8LX6NAGAYua98k/VWEHKVI97ei6BjnQLLpWipbGvXxfsQelZI8N+nU8DTEBQtdf
         MhdT5PaIEpwCx3XyDZckeJsuuFgB2PCvG7e57jHTgIz6b6+VDC/6xMLeyt2sfUkVe8
         mEW2RRiEt45Kg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1DD7960AA3;
        Sun, 24 Oct 2021 12:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ethernet: microchip: lan743x: Fix dma allocation
 failure by using dma_set_mask_and_coherent
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163507920711.28969.16811399167147186936.git-patchwork-notify@kernel.org>
Date:   Sun, 24 Oct 2021 12:40:07 +0000
References: <20211022155343.91841-1-yuiko.oshino@microchip.com>
In-Reply-To: <20211022155343.91841-1-yuiko.oshino@microchip.com>
To:     Yuiko Oshino <yuiko.oshino@microchip.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        bryan.whitehead@microchip.com, UNGLinuxDriver@microchip.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 22 Oct 2021 11:53:43 -0400 you wrote:
> The dma failure was reported in the raspberry pi github (issue #4117).
> https://github.com/raspberrypi/linux/issues/4117
> The use of dma_set_mask_and_coherent fixes the issue.
> Tested on 32/64-bit raspberry pi CM4 and 64-bit ubuntu x86 PC with EVB-LAN7430.
> 
> Fixes: 23f0703c125b ("lan743x: Add main source files for new lan743x driver")
> Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>
> 
> [...]

Here is the summary with links:
  - [net] net: ethernet: microchip: lan743x: Fix dma allocation failure by using dma_set_mask_and_coherent
    https://git.kernel.org/netdev/net/c/95a359c95533

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


