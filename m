Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCB3B2F8935
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 00:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbhAOXLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 18:11:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:35090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726176AbhAOXLK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 18:11:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 295A5239E5;
        Fri, 15 Jan 2021 23:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610752230;
        bh=eybBFxYoP8FqQdbFVj6zvQXc8uGIwGWtn4xP5y3DQ2o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Jg7d9mx9oDVOCRgZE9Rp5eBfQhe0mCF02/Ww/a16syR9cZ8NpxsY9xwRUd52Vapu8
         yu4doI83Iq4EW5oXS/qQtX1Ho4+rkwIupZZ+pIlTXcY7vbIGMWnfj1oxwpFweO0/3q
         diDbdKu8tEV4T2Sy1Bge8vONuF/POdrodeRUmO3m5NQN6SrK/oLp4GhHRAA/1ynEDn
         bd9cart7gVhA8ItvlmHcLREIsoBzhLCMaFqXecm0OFy3fhEjogjt/Bn4QnPL8Fxp3H
         1/1kkaFsrYW0c0RnG+Bs9DTwEObk+Ov/qg1nsSzxwXgyIrX6x5l6GSNhb79v/q3xnH
         P/ufKQBMrkqkw==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 1EE1E60593;
        Fri, 15 Jan 2021 23:10:30 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] Add further DT configuration for AT803x PHYs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161075223012.26680.6453584853333825296.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Jan 2021 23:10:30 +0000
References: <20210114104455.GP1551@shell.armlinux.org.uk>
In-Reply-To: <20210114104455.GP1551@shell.armlinux.org.uk>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        devicetree@vger.kernel.org, f.fainelli@gmail.com, kuba@kernel.org,
        netdev@vger.kernel.org, robh+dt@kernel.org, jon@solid-run.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 14 Jan 2021 10:44:56 +0000 you wrote:
> Hi,
> 
> This patch series adds the ability to configure the SmartEEE feature
> in AT803x PHYs. SmartEEE defaults to enabled on these PHYs, and has
> a history of causing random sporadic link drops at Gigabit speeds.
> 
> There appears to be two solutions to this. There is the approach that
> Freescale adopted early on, which is to disable the SmartEEE feature.
> However, this loses the power saving provided by EEE. Another solution
> was found by Jon Nettleton is to increase the Tw parameter for Gigabit
> links.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] dt: ar803x: document SmartEEE properties
    https://git.kernel.org/netdev/net-next/c/623c13295cf4
  - [net-next,2/2] net: phy: at803x: add support for configuring SmartEEE
    https://git.kernel.org/netdev/net-next/c/390b4cad8148

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


