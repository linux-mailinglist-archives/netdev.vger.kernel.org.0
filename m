Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A41A634309B
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 03:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbhCUCLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 22:11:42 -0400
Received: from [198.145.29.99] ([198.145.29.99]:50908 "EHLO mail.kernel.org"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S229834AbhCUCLN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Mar 2021 22:11:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C78236194D;
        Sun, 21 Mar 2021 02:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616292608;
        bh=BrJc3dmfIC5P5ZWCT8tGF2K9I4MjrVwJrdtbj1OGB8A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=J1mpTtQmqiDvqOGp2S7vO4e/HZAuPG6YTPZfs3wORtrZwfwCq1+1Qk+ic2WmRypz8
         2TxBT+NcFI/HX/vR9/EDl9jb8qDskKhf3+skOWmHhheIAwN1i2E+CFWxn/pbTChucI
         22kC9rlboskYnQUXVj0vuS+hudza1ViX0oqZ8iaPeyqedfCAZ1yJ0+f2L4lkTUc66O
         0HMINaT8mIbgPQaXcaknSvdVccU3+eStLkMQOZliEEOgNmGUgE/y+4S5EuVZsmmglh
         AXWtlUI6bsZT3JoWwHKOUd7X/tM1kPbKazAHxtl+0VkoYmqzpB7bCHD6/9aqcbQx3y
         BMjOJ9p6ZCtmw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BCC16626ED;
        Sun, 21 Mar 2021 02:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] r8169: fix DMA being used after buffer free if WoL is
 enabled
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161629260876.5230.4981674636008267669.git-patchwork-notify@kernel.org>
Date:   Sun, 21 Mar 2021 02:10:08 +0000
References: <ed72d614-d6a2-a837-8faa-eaaef08ef6d8@gmail.com>
In-Reply-To: <ed72d614-d6a2-a837-8faa-eaaef08ef6d8@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     nic_swsd@realtek.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, paulb@blazebox.homeip.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat, 20 Mar 2021 21:40:08 +0100 you wrote:
> IOMMU errors have been reported if WoL is enabled and interface is
> brought down. It turned out that the network chip triggers DMA
> transfers after the DMA buffers have been freed. For WoL to work we
> need to leave rx enabled, therefore simply stop the chip from being
> a DMA busmaster.
> 
> Fixes: 567ca57faa62 ("r8169: add rtl8169_up")
> Tested-by: Paul Blazejowski <paulb@blazebox.homeip.net>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] r8169: fix DMA being used after buffer free if WoL is enabled
    https://git.kernel.org/netdev/net/c/f658b90977d2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


