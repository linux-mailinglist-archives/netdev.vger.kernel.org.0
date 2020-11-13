Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 129FB2B288B
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 23:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbgKMWaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 17:30:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:33500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbgKMWaF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 17:30:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605306605;
        bh=6z6tTtD9+PiRCUj2TF+yEnjWYj9gpWjEnV8wa7gYs/Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RE+P4YsD/gc73qlZ8NUtDGlm8N4ZS1tJMygQ4tVyGwl7Ul7iXr23e214ZzmgArq4Y
         hs8fN6gZ716HNsAb7rUxoPQwjcF9qq1aHMA7kW9mEybhGQ0UWCb8eIU1aAmqx047Gq
         norcNJHZ2PxQgybtR+vdGEXFH/kgNsLmo3ysVBII=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: ti: cpsw: fix cpts irq after suspend
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160530660503.10508.5316040028509331013.git-patchwork-notify@kernel.org>
Date:   Fri, 13 Nov 2020 22:30:05 +0000
References: <20201112111546.20343-1-grygorii.strashko@ti.com>
In-Reply-To: <20201112111546.20343-1-grygorii.strashko@ti.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        tony@atomide.com, nsekhar@ti.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, vigneshr@ti.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 12 Nov 2020 13:15:46 +0200 you wrote:
> Depending on the SoC/platform the CPSW can completely lose context after a
> suspend/resume cycle, including CPSW wrapper (WR) which will cause reset of
> WR_C0_MISC_EN register, so CPTS IRQ will became disabled.
> 
> Fix it by moving CPTS IRQ enabling in cpsw_ndo_open() where CPTS is
> actually started.
> 
> [...]

Here is the summary with links:
  - net: ethernet: ti: cpsw: fix cpts irq after suspend
    https://git.kernel.org/netdev/net/c/2b5668733050

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


