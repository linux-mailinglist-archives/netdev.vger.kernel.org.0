Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF856358E39
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 22:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232261AbhDHUUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 16:20:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:47666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231676AbhDHUUY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 16:20:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6C01F610CF;
        Thu,  8 Apr 2021 20:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617913212;
        bh=Z5NPhE1GYFRdPh9DAc8sDrpHPz7u/KUs/IsqU2zf15U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XxrHcxGKdnHLLPD2C1hsgzVGGPc0nVrIfGOcFjuXXYGJi7kPD7gcWiEZZrwDEdoto
         hhWteraseZelaDQDrmvBZVoSM2lnFRJqyDvl7t0+sBeK4W2XclDi8wJjhGEv5ryUK7
         m7UzUepbyUMLaoM+g1OA1ZXRuvKFyQ3riCsExRKG7sFEC12DRlbpkD0insFtJGTX97
         KGV5dP9C6Rs9McvMugjek29jzQODbEdaYO1lUP/mjNUBwPYOhpXN8Keek41AEYyD84
         CF8uK3ekRY0YUWflrPmJ0FgL9I9uCDnc2yntt8g6UHCvB/LKoqDJ1aym+CYti97Uve
         e7Zy2UgSOpKIA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 618EE60A71;
        Thu,  8 Apr 2021 20:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 00/16] net: phy: marvell10g updates
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161791321239.18816.4767764835394602820.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Apr 2021 20:20:12 +0000
References: <20210407202254.29417-1-kabel@kernel.org>
In-Reply-To: <20210407202254.29417-1-kabel@kernel.org>
To:     =?utf-8?q?Marek_Beh=C3=BAn_=3Ckabel=40kernel=2Eorg=3E?=@ci.codeaurora.org
Cc:     netdev@vger.kernel.org, rmk+kernel@armlinux.org.uk, andrew@lunn.ch,
        davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed,  7 Apr 2021 22:22:38 +0200 you wrote:
> Here are some updates for marvell10g PHY driver.
> 
> I am still working on some more changes for this driver, but I would
> like to have at least something reviewed / applied.
> 
> Changes since v3:
> - added Andrew's Reviewed-by tags
> - removed patches adding variadic-macro library and bitmap
>   initialization macro - it causes warning that we are not currently
>   able to fix easily. Instead the supported_interfaces bitmap is now
>   initialized via a chip specific method
> - added explanation of mactype initialization to commit message of patch
>   07/16
> - fixed repeated word in commit message of second to last patch
> 
> [...]

Here is the summary with links:
  - [net-next,v4,01/16] net: phy: marvell10g: rename register
    https://git.kernel.org/netdev/net-next/c/bd79d9aa6145
  - [net-next,v4,02/16] net: phy: marvell10g: fix typo
    https://git.kernel.org/netdev/net-next/c/283828142fad
  - [net-next,v4,03/16] net: phy: marvell10g: allow 5gbase-r and usxgmii
    https://git.kernel.org/netdev/net-next/c/0d3755428d69
  - [net-next,v4,04/16] net: phy: marvell10g: indicate 88X33x0 only port control registers
    https://git.kernel.org/netdev/net-next/c/9893f3169016
  - [net-next,v4,05/16] net: phy: marvell10g: add all MACTYPE definitions for 88X33x0
    https://git.kernel.org/netdev/net-next/c/f8ee45fcbc5a
  - [net-next,v4,06/16] net: phy: marvell10g: add MACTYPE definitions for 88E21xx
    https://git.kernel.org/netdev/net-next/c/9ab0fbd0ffce
  - [net-next,v4,07/16] net: phy: marvell10g: support all rate matching modes
    https://git.kernel.org/netdev/net-next/c/97bbe3bd6922
  - [net-next,v4,08/16] net: phy: marvell10g: check for correct supported interface mode
    https://git.kernel.org/netdev/net-next/c/261a74c64bb6
  - [net-next,v4,09/16] net: phy: marvell10g: store temperature read method in chip strucutre
    https://git.kernel.org/netdev/net-next/c/884d9a6758a1
  - [net-next,v4,10/16] net: phy: marvell10g: support other MACTYPEs
    https://git.kernel.org/netdev/net-next/c/ccbf2891de98
  - [net-next,v4,11/16] net: phy: marvell10g: add separate structure for 88X3340
    https://git.kernel.org/netdev/net-next/c/9885d016ffa9
  - [net-next,v4,12/16] net: phy: marvell10g: fix driver name for mv88e2110
    https://git.kernel.org/netdev/net-next/c/c89f27d4d239
  - [net-next,v4,13/16] net: phy: add constants for 2.5G and 5G speed in PCS speed register
    https://git.kernel.org/netdev/net-next/c/53f111cbfac6
  - [net-next,v4,14/16] net: phy: marvell10g: differentiate 88E2110 vs 88E2111
    https://git.kernel.org/netdev/net-next/c/0fca947cbb27
  - [net-next,v4,15/16] net: phy: marvell10g: change module description
    https://git.kernel.org/netdev/net-next/c/c7dce05e63eb
  - [net-next,v4,16/16] MAINTAINERS: add myself as maintainer of marvell10g driver
    https://git.kernel.org/netdev/net-next/c/9187b6cfe7fc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


