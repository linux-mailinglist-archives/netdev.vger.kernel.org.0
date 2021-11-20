Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38412457B2A
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 05:30:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236984AbhKTEdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 23:33:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:43240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236836AbhKTEdM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 23:33:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id C6DD4604D1;
        Sat, 20 Nov 2021 04:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637382609;
        bh=I0erAr73wCqEQ53OcoZ+z/K5jnlK55rswmPWxC07YU8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IdxZptB3Afn0oNHWAFPJEPPPiqFdnC7SbOktVgQ/QBskTou/EwQX/IVrZ4zqT91VG
         8a65wjIKB2VVrkLq4D+4ApNMOJbW9AW0ydIFmamCz6NxlqYB9aveVesnX91fuFPxxJ
         z8i10QgsAYqr9/Ncpv4FGh2/fm5mFglxKb/jZ5xF83lM4cMHeuEbHsxEQ6b3OczHsW
         JgLuy51qX74auiBWjAA/et/9uj/FWkOygyJ6gA9787XRpmRRKoNDSaNYmrz6jir/Ao
         IGn7L+a6eTgqj6Cbq9DwftTDmvIAo+IK+7q5Y0Ag/jFEfkurvI+Yqw3bLkFtJpVEIP
         oLnp+ZpHdKTGg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id ACDF16096E;
        Sat, 20 Nov 2021 04:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: phy: add support for TI DP83561-SP phy
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163738260970.5569.5157883489066456892.git-patchwork-notify@kernel.org>
Date:   Sat, 20 Nov 2021 04:30:09 +0000
References: <20211118102532.9835-1-hnagalla@ti.com>
In-Reply-To: <20211118102532.9835-1-hnagalla@ti.com>
To:     Hari Nagalla <hnagalla@ti.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, geet.modi@ti.com,
        vikram.sharma@ti.com, kishon@ti.com, grygorii.strashko@ti.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 18 Nov 2021 04:25:32 -0600 you wrote:
> From: Hari Nagalla <hnagalla@ti.com>
> 
> Add support for the TI DP83561-SP Gigabit ethernet phy device.
> 
> The dp83561-sp is a radiation hardened space grade gigabit ethernet
> PHY. It has been tested for single event latch upto 121 MeV, the
> critical reliability parameter for space designs. It interfaces directly to
> twisted pair media through an external transformer. And the device also
> interfaces directly to the MAC layer through Reduced GMII (RGMII) and MII.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: phy: add support for TI DP83561-SP phy
    https://git.kernel.org/netdev/net-next/c/1388d4ad9d82

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


