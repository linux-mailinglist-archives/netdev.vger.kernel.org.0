Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E891131C454
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 00:22:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbhBOXWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 18:22:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:33258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229936AbhBOXUt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 18:20:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 0249C64E04;
        Mon, 15 Feb 2021 23:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613431209;
        bh=8EVwURMOMylkkgtQs4aFRN5AK4DcxVFDMeiGf9D6jpE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=opzRcp0KNrt4eOIfYyPjTAwhQIO1DtD+qALCvpA1nGshhR+jRJMW4oVwWEOrQlYsb
         z1irM+npRT5okmLfeMqsIrhXHJ9PuQkXIlRf0NcIWjQxpPBIQFtvlfFU/K5oB1GOOb
         2gT+3SJk5aqkCM4xuGr1BQPQaWYemUhUEy7Lqk4J0Fd1xp+qUvdrvTHR//oOkaYKvL
         cpA4Bt/VT9aUWw2w7LovK1gRfExzYDl59vAxEN6l+SWqkOwhuRHvXqzrZ3AwgVaz6B
         72MX8KpuhzJcrgxLippIm873hc4Ss569gP7UP0o5LeZrHOekIL88mPMi6D5zvqVHp+
         uLZFsBH346Z7w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F04FB6097B;
        Mon, 15 Feb 2021 23:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/3] net: phy: broadcom: Cleanups and APD
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161343120898.10830.15810308932296125274.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Feb 2021 23:20:08 +0000
References: <20210213034632.2420998-1-f.fainelli@gmail.com>
In-Reply-To: <20210213034632.2420998-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        mchan@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, olteanv@gmail.com, michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 12 Feb 2021 19:46:29 -0800 you wrote:
> This patch series cleans up the brcmphy.h header and its numerous unused
> phydev->dev_flags, fixes the RXC/TXC clock disabling bit and allows the
> BCM54210E PHY to utilize APD.
> 
> Changes in v2:
> 
> - dropped the patch that attempted to fix a possible discrepancy between
>   the datasheet and the actual hardware
> - added a patch to remove a forward declaration
> - do additional flags cleanup
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/3] net: phy: broadcom: Avoid forward for bcm54xx_config_clock_delay()
    https://git.kernel.org/netdev/net-next/c/133bf7b4fbbe
  - [net-next,v2,2/3] net: phy: broadcom: Remove unused flags
    https://git.kernel.org/netdev/net-next/c/17d3a83afbbf
  - [net-next,v2,3/3] net: phy: broadcom: Allow BCM54210E to configure APD
    https://git.kernel.org/netdev/net-next/c/5d4358ede8eb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


