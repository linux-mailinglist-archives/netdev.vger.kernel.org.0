Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9746481211
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 12:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239949AbhL2LkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 06:40:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60480 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbhL2LkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 06:40:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ACA73B818CA;
        Wed, 29 Dec 2021 11:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 50468C36AED;
        Wed, 29 Dec 2021 11:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640778009;
        bh=7hrZQRzziyMaAU7Q1yyuExgdIP7rDtd8yIiNpXhh/pI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FPXjBWsIBYrLuWIFXyiLB01gCkUv+zJ/0CoSRFINyyC06LJZTTyrNiDoFsgHMC1bG
         RkZBl3rfAPM8qm/aXWwLpl3a+d59TXPXI6ruocTW+jYzrdke4WrAr/blhjWtFNpTvT
         HSrf/5d7HzZmMNSsTF/bL1j59m+JJ4Q9fv23Ma7GJpdtQkjFZvaKQ/pLrNFVd46Jrr
         j4xn5RLUmFjzUXbG6KQdkeWsUEt11MKKtbNAf4DpcE08I9/UaI27/ex7+AqppuXsfI
         YLzzARJfOq1y40DtemhXBpreCacb6zXRf3BO2JNDDYCVolsfjT0TKYbuLbKgFJxMXc
         /U5XsFCwOIUdA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 341AEC395DD;
        Wed, 29 Dec 2021 11:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] of: net: support NVMEM cells with MAC in text format
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164077800920.21586.15235934371283917526.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Dec 2021 11:40:09 +0000
References: <20211223122747.30448-1-zajec5@gmail.com>
In-Reply-To: <20211223122747.30448-1-zajec5@gmail.com>
To:     =?utf-8?b?UmFmYcWCIE1pxYJlY2tpIDx6YWplYzVAZ21haWwuY29tPg==?=@ci.codeaurora.org
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, rafal@milecki.pl
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 23 Dec 2021 13:27:47 +0100 you wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> Some NVMEM devices have text based cells. In such cases MAC is stored in
> a XX:XX:XX:XX:XX:XX format. Use mac_pton() to parse such data and
> support those NVMEM cells. This is required to support e.g. a very
> popular U-Boot and its environment variables.
> 
> [...]

Here is the summary with links:
  - of: net: support NVMEM cells with MAC in text format
    https://git.kernel.org/netdev/net-next/c/9ed319e41191

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


