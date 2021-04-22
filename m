Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 622F33687F9
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 22:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239676AbhDVUaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 16:30:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:34422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239528AbhDVUaq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 16:30:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 73AC96145C;
        Thu, 22 Apr 2021 20:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619123410;
        bh=yNYeqL66XO0WHxOM7CSJy+F6m+c9yd6RuSsrv6TGDyM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DqqQHWWyNkXX0Lg0GMb912KbFhITeFfgk3SIK0mQzzBtv0VTNa/ZpKp/937o5r/7w
         XPMdzhf/obq2mleYjYI6dPO93BNYf+S57bulqHj7GvsjpinOVYMb944hJYJPkExxWa
         vKSd920wPqsbwm8m2sKo1UCLeN1Yip+mf6rIeOr3c8sziMCmgV3qF7d98AIXW9WUST
         w4XotVMwy/yI2knyHlKShGdvpKKo33bjUfK9dQUSgAajZo1JzKdLTIXbIcz4Th5QMF
         TIuvymvGRg+7R34rS4cF0k0NJUjyE3rJ2WQeRo2qH37k5Ew/oWL1TIYwoJv/bVSqwx
         sC1MipJZzDH3Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6A3DC60A5C;
        Thu, 22 Apr 2021 20:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: mana: fix PCI_HYPERV dependency
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161912341043.26269.9754111043829320260.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Apr 2021 20:30:10 +0000
References: <20210422133444.1793327-1-arnd@kernel.org>
In-Reply-To: <20210422133444.1793327-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, davem@davemloft.net,
        kuba@kernel.org, arnd@arndb.de, shacharr@microsoft.com,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 22 Apr 2021 15:34:34 +0200 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The MANA driver causes a build failure in some configurations when
> it selects an unavailable symbol:
> 
> WARNING: unmet direct dependencies detected for PCI_HYPERV
>   Depends on [n]: PCI [=y] && X86_64 [=y] && HYPERV [=n] && PCI_MSI [=y] && PCI_MSI_IRQ_DOMAIN [=y] && SYSFS [=y]
>   Selected by [y]:
>   - MICROSOFT_MANA [=y] && NETDEVICES [=y] && ETHERNET [=y] && NET_VENDOR_MICROSOFT [=y] && PCI_MSI [=y] && X86_64 [=y]
> drivers/pci/controller/pci-hyperv.c: In function 'hv_irq_unmask':
> drivers/pci/controller/pci-hyperv.c:1217:9: error: implicit declaration of function 'hv_set_msi_entry_from_desc' [-Werror=implicit-function-declaration]
>  1217 |         hv_set_msi_entry_from_desc(&params->int_entry.msi_entry, msi_desc);
>       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> [...]

Here is the summary with links:
  - net: mana: fix PCI_HYPERV dependency
    https://git.kernel.org/netdev/net-next/c/45b102dd8149

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


