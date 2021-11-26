Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8A345E681
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 04:22:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357923AbhKZDZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 22:25:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:56582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244683AbhKZDXV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 22:23:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id A324761154;
        Fri, 26 Nov 2021 03:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637896809;
        bh=T4N8sJHo+2cMhYiDVQVu+nYJPLPLYHlE5oaY4wR1+AQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=N8FI2UAxXg1lwto48E3P8Qkz/keG5TIHGaQ3XC1/2F2QTOMW/40G8rUOB08DjTAlt
         gl0qsTp2uZsyLEtFqg5UAjKNy2JAVYaRFy2mqbvJv0kT1hPEszCTSCv+u4dpNJEcMQ
         /7nIb0pefrliCGW0EXCKbxznHZ7EIA1Jih3l8Kd8Ljr+T4yPNEGug/CrHW5cNBtBuc
         kho3PfRnQlYQzkJyD3uLsjovRb0mdwijNU/gA6wDIXadJMtHdMJDZj2oQjeSWwmTyV
         BysHJU4qkwtaYTO4skwCgVGu0qHoyVBCL+q0JMvMpn4IjIYk0yIDUGufiD1vcX6IRo
         VbRw6/mZ6bT0Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 91C8B609B9;
        Fri, 26 Nov 2021 03:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: macb: convert to phylink_generic_validate()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163789680959.4222.5489835335806033875.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Nov 2021 03:20:09 +0000
References: <E1mpuRv-00D4rb-Lz@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1mpuRv-00D4rb-Lz@rmk-PC.armlinux.org.uk>
To:     Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc:     claudiu.beznea@microchip.com, nicolas.ferre@microchip.com,
        sean.anderson@seco.com, pthombar@cadence.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 24 Nov 2021 15:44:43 +0000 you wrote:
> Populate the supported interfaces bitmap and MAC capabilities mask for
> the macb driver and remove the old validate implementation.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/ethernet/cadence/macb_main.c | 133 +++++------------------
>  1 file changed, 30 insertions(+), 103 deletions(-)

Here is the summary with links:
  - [net-next] net: macb: convert to phylink_generic_validate()
    https://git.kernel.org/netdev/net-next/c/cc0a75eb0375

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


