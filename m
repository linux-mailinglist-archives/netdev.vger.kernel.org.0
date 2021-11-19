Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A758456E96
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 13:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234692AbhKSMD3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 07:03:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:53896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234610AbhKSMDN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 07:03:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 7403B61A7D;
        Fri, 19 Nov 2021 12:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637323211;
        bh=kA2KK8YuXrw1PKsVWIH0KuhpSQ3a+ufOU+5LfFmrzow=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tjfDbQztzqGYUHWhFOZRQbi+eq69XsyvJ3R5WQ0lakEDGnwHyNbTW+tJADKsSCG8U
         GeGV1oPn2O2yksUkUZk5DX/0RUJd7YpR8CF61X1UzBlDbvcngy7bAKoolhrG61eOmA
         rWejxorlcLMasZVFK/7xl3t0IvC+SiecbSN5yaVZhUpg6J7eJGRSZxQh8BB+/jzj9o
         Pq0gWnvRyXB7aZNz0oLnMMO5wF0QrH14pyIDUt2xzuEj0obfYEbqRXjdx8LlkmkDAF
         GF5NhLCKU7VmlPWmVYy/RYBXJkEQJZzKg68UjIMEiVovEy8O0QP02/EDeCzCqejLBE
         QrZYOSU3zzc+w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 677E060A0F;
        Fri, 19 Nov 2021 12:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] stmmac_pci: Fix underflow size in stmmac_rx
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163732321141.14736.10382429911164710117.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Nov 2021 12:00:11 +0000
References: <YZbI12/g04GlzdIU@a-10-27-17-117.dynapool.vpn.nyu.edu>
In-Reply-To: <YZbI12/g04GlzdIU@a-10-27-17-117.dynapool.vpn.nyu.edu>
To:     Zekun Shen <bruceshenzk@gmail.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        brendandg@nyu.edu
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 18 Nov 2021 16:42:47 -0500 you wrote:
> This bug report came up when we were testing the device driver
> by fuzzing. It shows that buf1_len can get underflowed and be
> 0xfffffffc (4294967292).
> 
> This bug is triggerable with a compromised/malfunctioning device.
> We found the bug through QEMU emulation tested the patch with
> emulation. We did NOT test it on real hardware.
> 
> [...]

Here is the summary with links:
  - stmmac_pci: Fix underflow size in stmmac_rx
    https://git.kernel.org/netdev/net/c/0f296e782f21

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


