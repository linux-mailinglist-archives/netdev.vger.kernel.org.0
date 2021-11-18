Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0927455AF1
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 12:51:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344272AbhKRLyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 06:54:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:36050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344353AbhKRLxK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 06:53:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9D10161994;
        Thu, 18 Nov 2021 11:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637236209;
        bh=luZrSJNrajW/HvZNQ7nYVE7oQ7UDWEbtkpXz7J2ClDQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PBm3E0wJ5q5gPiM2iQxOKL/eSPCGdEcq+81l9xnCe3v7gbTdGbB3VWb0YaSsJfM28
         qg3qX7HEgwMAb+guu8KsI0OnELC1JOVWQTOIvr5XtsCSKqVgsuWoYPu+297gGGIGv/
         JeuCszfFszeBLq/rBG4F4zvrAgm3n0mm2UuZ4G2InEtBZF2ZqNuU+/IopV8CdobMq0
         5OfGUIVLOu4AGKzv9AA1xN7c8sPZIydOwxQS6IT0Vp9Xxi916D90mDWpZz8keQsLOf
         OMNJ6Y733Wdpz1jTCp7foCy5AkBK8K8u+Ouqd5lMMPqGYVGVvgAKPkwoTcANe4i8Uk
         IsjzgCx7iJwdg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 970BD60A4E;
        Thu, 18 Nov 2021 11:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: mdio: Replaced BUG_ON() with WARN()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163723620961.17258.12436380280268172746.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Nov 2021 11:50:09 +0000
References: <20211117173629.2734752-1-f.fainelli@gmail.com>
In-Reply-To: <20211117173629.2734752-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 17 Nov 2021 09:36:29 -0800 you wrote:
> Killing the kernel because a certain MDIO bus object is not in the
> desired state at various points in the registration or unregistration
> paths is excessive and is not helping in troubleshooting or fixing
> issues. Replace the BUG_ON() with WARN() and print out the MDIO bus name
> to facilitate debugging.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: mdio: Replaced BUG_ON() with WARN()
    https://git.kernel.org/netdev/net-next/c/867ae8a7993b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


