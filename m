Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E977D31D278
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 23:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbhBPWKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 17:10:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:49138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229722AbhBPWKt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 17:10:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id A3B4364E7A;
        Tue, 16 Feb 2021 22:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613513408;
        bh=RqZHkgFXDCElnT+yDP+zNwkPe/1CFdxlaqOgzUsRqUg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=omicZVUHUIwgjcRdLqRkm/+u6aNLwk/UTf6/D1zfDbZfwYcDYkoNLFhHMnMmiDzJP
         UWNBb497AhK2AJ4+Q50GZiYFfY82HYFiBDGlD0METHt+IjTKzns0RnWIrr5aOfdVAi
         quXVTex8RgoQCZaq5vXltNIwuNFshv3DbrzVouAZxdOFtgRGR5kcIxGZgYNRZS2Zxe
         nq0rZ4SPRvGSwA6SfjUL6e2E/yG+c4MozStWA5kPn30co6Ar7UOE0HVkqk6xcwPq83
         fVgi+RPqa+BfHxvf/FFW0HHAHkp2kTdSLWlWVgl1CjVFAo0bRiU7Ne5eTj4XSvPVQS
         odRxcJ0EH3RWA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9AF9C60A17;
        Tue, 16 Feb 2021 22:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/3] Fixes applied to VCS8514
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161351340863.15084.10381362758534192005.git-patchwork-notify@kernel.org>
Date:   Tue, 16 Feb 2021 22:10:08 +0000
References: <20210216152944.27266-1-bjarni.jonasson@microchip.com>
In-Reply-To: <20210216152944.27266-1-bjarni.jonasson@microchip.com>
To:     Bjarni Jonasson <bjarni.jonasson@microchip.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, atenart@kernel.org,
        f.fainelli@gmail.com, vladimir.oltean@nxp.com,
        ioana.ciornei@nxp.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 16 Feb 2021 16:29:41 +0100 you wrote:
> 3 different fixes applied to VSC8514:
> LCPLL reset, serdes calibration and coma mode disabled.
> Especially the serdes calibration is large and is now placed
> in a new file 'mscc_serdes.c' which can act as
> a placeholder for future serdes configuration.
> 
> v1 -> v2:
>   Preserved reversed christmas tree
>   Removed forward definitions
>   Fixed build issues
>   Changed net to net-next
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/3] net: phy: mscc: adding LCPLL reset to VSC8514
    https://git.kernel.org/netdev/net-next/c/3cc2c646be0b
  - [net-next,v3,2/3] net: phy: mscc: improved serdes calibration applied to VSC8514
    https://git.kernel.org/netdev/net-next/c/85e97f0b984e
  - [net-next,v3,3/3] net: phy: mscc: coma mode disabled for VSC8514
    https://git.kernel.org/netdev/net-next/c/ca0d7fd0a58d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


