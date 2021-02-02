Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0D1F30C69C
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 17:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236671AbhBBQx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 11:53:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:35562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236885AbhBBQux (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 11:50:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 7E49D64F92;
        Tue,  2 Feb 2021 16:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612284607;
        bh=33MF8xaV1X+WLY/e2qeSCiPrdba02mvtMP/guDX5b44=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qdDSZWA/PHoJK4JY81TH81UKUnOOg86H85at/mEheQNFQUBSyrrBH0coGCkbCTlL4
         DZazAPXlajttyYt7nYVtHBkH5tzdnR7tC2UFZevrMNUH3rooyjACwpNpPrfkPvkaVx
         SCFlz0f3pFb66M1lKwQd1ut/KODwvHFh0blIVLLLabiM16i9lhuOc8/K7rdhSlzEEZ
         x4ueckHKjo3mqTy9snP5WRZLha4LD9oTxQnRLNXSz8BooMqfi9z2WXg+2PEh7DxT4P
         HbGlSuSYW+eXUrL5KvywPJ0NdX/0VbZ6Ea+N2czqv33ysY1SKaSShhyE41QVBP2D9m
         OZ4eBsmRvNtkg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 711FC609E3;
        Tue,  2 Feb 2021 16:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] r8169: fix WoL on shutdown if CONFIG_DEBUG_SHIRQ is set
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161228460745.23213.17364594330636586574.git-patchwork-notify@kernel.org>
Date:   Tue, 02 Feb 2021 16:50:07 +0000
References: <fe732c2c-a473-9088-3974-df83cfbd6efd@gmail.com>
In-Reply-To: <fe732c2c-a473-9088-3974-df83cfbd6efd@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 1 Feb 2021 21:50:56 +0100 you wrote:
> So far phy_disconnect() is called before free_irq(). If CONFIG_DEBUG_SHIRQ
> is set and interrupt is shared, then free_irq() creates an "artificial"
> interrupt by calling the interrupt handler. The "link change" flag is set
> in the interrupt status register, causing phylib to eventually call
> phy_suspend(). Because the net_device is detached from the PHY already,
> the PHY driver can't recognize that WoL is configured and powers down the
> PHY.
> 
> [...]

Here is the summary with links:
  - [net] r8169: fix WoL on shutdown if CONFIG_DEBUG_SHIRQ is set
    https://git.kernel.org/netdev/net/c/cc9f07a838c4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


