Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93FB948E924
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 12:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240799AbiANLaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 06:30:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52968 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbiANLaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 06:30:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E16561F12;
        Fri, 14 Jan 2022 11:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 96872C36AEC;
        Fri, 14 Jan 2022 11:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642159810;
        bh=iv/QOvqC9qyOc3SjCNDYCNqSP2ggbWCYneFvulLQWxU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KPaPzLdhx70hl13pH+duFJ6n1hyfe8GkTm2aPHupCMzKUd2NO2AKWeYlBiipnJ6nb
         o7+0SBH8cmFsGwuNhCS2i5y9Pko/E4zdyzdRdflCKGfZqwicNCwIZJYRmYxnTRpjiT
         1WOTDtjb7bHUsjbgj1nfWe2y8v6v1uq70J+HpV/14HdEH/nHW5eSje9j5U9ThVWyBN
         F9/PtdLHXAr8PVdGItqm7V4yd1qExjaPxnP8nCzW9hhb+4vLk98YdgMfaK0xLWCaFT
         rmTneiUahxV+8FpJKM8ZFVIjemqY0SRRcEzTZZ5Tz5+2MPSeUzN4MoXvw1uEfDmlPy
         t146DtBccTnvg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6FAD6F60799;
        Fri, 14 Jan 2022 11:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: stmmac: Fix "Unbalanced pm_runtime_enable!" warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164215981045.30922.3548719266097575473.git-patchwork-notify@kernel.org>
Date:   Fri, 14 Jan 2022 11:30:10 +0000
References: <20220114071430.1335872-1-kai.heng.feng@canonical.com>
In-Reply-To: <20220114071430.1335872-1-kai.heng.feng@canonical.com>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 14 Jan 2022 15:14:30 +0800 you wrote:
> If the device is PCI based like intel-eth-pci, pm_runtime_enable() is
> already called by pci_pm_init().
> 
> So only pm_runtime_enable() when it's not already enabled.
> 
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> 
> [...]

Here is the summary with links:
  - net: stmmac: Fix "Unbalanced pm_runtime_enable!" warning
    https://git.kernel.org/netdev/net/c/d90d0c175cf2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


