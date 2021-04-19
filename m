Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFD27364E77
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 01:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232431AbhDSXK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 19:10:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:59276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229723AbhDSXKp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 19:10:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4EE19613B0;
        Mon, 19 Apr 2021 23:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618873815;
        bh=b6blVwfl2DhdusyHGWjEMcVc0oUxN/8m8X1QHPFPsZw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=J4i2ImTQBC2nI/KALuGGJfVvzWcvou6fBhJMZd+dTBhoyQJK2KLO74pPR6VbzmFhb
         MChQpt9dBuiY/Y19KOckyIq9I8OTOtXMp8snpl8rt+EJQs/+bR6oLujUbsABpr742B
         1Z5kJe2VWo7o3SE4m4HeH9uPAB0rJdKD2bJTKv77obxlWiuft406x1MzE5sb4OL88R
         /Z6nt/PARzC7HWcNIW0fd2AEPpF3n+VwBWr/Co1UBr2xXX7TUCCS6zEeX+MVQYdRMZ
         NTlm0EiDM+n3bOKmAu9m5KuWugVym2NferQYuEEBX93GWgzMDUNbyC/rpbnoszO2GZ
         6F38WYcFcwouw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4394860970;
        Mon, 19 Apr 2021 23:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v6 net-next 00/10] net: Korina improvements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161887381527.661.5050099431763141238.git-patchwork-notify@kernel.org>
Date:   Mon, 19 Apr 2021 23:10:15 +0000
References: <20210418221949.130779-1-tsbogend@alpha.franken.de>
In-Reply-To: <20210418221949.130779-1-tsbogend@alpha.franken.de>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 19 Apr 2021 00:19:38 +0200 you wrote:
> While converting Mikrotik RB532 support to use device tree I stumbled
> over the korina ethernet driver, which used way too many MIPS specific
> hacks. This series cleans this all up and adds support for device tree.
> 
> Changes in v6:
>  - remove korina from resource names and adapt DT binding to it
>  - removed superfluous braces around of_get_mac_address
> 
> [...]

Here is the summary with links:
  - [v6,net-next,01/10] net: korina: Fix MDIO functions
    https://git.kernel.org/netdev/net-next/c/89f9d5400b53
  - [v6,net-next,02/10] net: korina: Use devres functions
    https://git.kernel.org/netdev/net-next/c/b4cd249a8cc0
  - [v6,net-next,03/10] net: korina: Remove not needed cache flushes
    https://git.kernel.org/netdev/net-next/c/e42f10533d7c
  - [v6,net-next,04/10] net: korina: Remove nested helpers
    https://git.kernel.org/netdev/net-next/c/0fe632471aeb
  - [v6,net-next,05/10] net: korina: Use DMA API
    https://git.kernel.org/netdev/net-next/c/0fc96939a97f
  - [v6,net-next,06/10] net: korina: Only pass mac address via platform data
    https://git.kernel.org/netdev/net-next/c/af80425e05b2
  - [v6,net-next,07/10] net: korina: Add support for device tree
    https://git.kernel.org/netdev/net-next/c/10b26f078151
  - [v6,net-next,08/10] net: korina: Get mdio input clock via common clock framework
    https://git.kernel.org/netdev/net-next/c/e4cd854ec487
  - [v6,net-next,09/10] net: korina: Make driver COMPILE_TESTable
    https://git.kernel.org/netdev/net-next/c/6ef92063bf94
  - [v6,net-next,10/10] dt-bindings: net: korina: Add DT bindings for IDT 79RC3243x SoCs
    https://git.kernel.org/netdev/net-next/c/d1a2c2315cc9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


