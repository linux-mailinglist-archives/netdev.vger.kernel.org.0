Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31C80436E63
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 01:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232164AbhJUXm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 19:42:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:54554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229512AbhJUXmZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 19:42:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CB0D861208;
        Thu, 21 Oct 2021 23:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634859608;
        bh=TRjAishGZW/mEXzyo6a17dS1h5NFtEhAgreGj7cD/MY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=T8SQPXfJP7vEXxhrov9+kLkKPRmnzAMqGNa7NJp9tVU08qobJl241ezro29id3PwI
         lxh/9QxECcW/U1E+f+J+Pz1qLHUTF+iIJ4P+vPuYhKTFHKh0Z1Y8Pe6jBSMMvOsa5W
         f5zIWi31KFIIozWRK/zimVQ9sXXWlgmHtvP3I65U48uob2LaeafMPNbE1aYbLtWQdf
         lsxAVkraK53s9UurYNpRx8iW0m8bf2ul+/pUjaPpaTTXLastBWiPiVq4F+Pf1ubcYd
         0VZUUPkeqSW5+FPMI7rNE19nZPV4sUUt/AXm8tC5v5vEyElTHK1K3/+ynk4FAe7xP3
         8hLHIsqIjhpVg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BC4D460A24;
        Thu, 21 Oct 2021 23:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v17 0/3] AX88796C SPI Ethernet Adapter
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163485960876.25151.11012064455389480138.git-patchwork-notify@kernel.org>
Date:   Thu, 21 Oct 2021 23:40:08 +0000
References: <20211020182422.362647-1-l.stelmach@samsung.com>
In-Reply-To: <20211020182422.362647-1-l.stelmach@samsung.com>
To:     =?utf-8?q?=C5=81ukasz_Stelmach_=3Cl=2Estelmach=40samsung=2Ecom=3E?=@ci.codeaurora.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        jim.cromie@gmail.com, hkallweit1@gmail.com, robh+dt@kernel.org,
        kgene@kernel.org, krzk@kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 20 Oct 2021 20:24:19 +0200 you wrote:
> This is a driver for AX88796C Ethernet Adapter connected in SPI mode as
> found on ARTIK5 evaluation board. The driver has been ported from a
> v3.10.9 vendor kernel for ARTIK5 board.
> 
> Changes in v17:
>   - marked no_regs_list as const
>   - added myself as MODULE_AUTHOR()
>   - rearranged locking in ax88796c_close() to prevent race condition in
>     case ax88796c_work() wakes the queue after trasmission.
> 
> [...]

Here is the summary with links:
  - [net-next,v17,1/3] dt-bindings: vendor-prefixes: Add asix prefix
    https://git.kernel.org/netdev/net-next/c/4def0acb63ce
  - [net-next,v17,2/3] dt-bindings: net: Add bindings for AX88796C SPI Ethernet Adapter
    https://git.kernel.org/netdev/net-next/c/b13c7a88a7b6
  - [net-next,v17,3/3] net: ax88796c: ASIX AX88796C SPI Ethernet Adapter Driver
    https://git.kernel.org/netdev/net-next/c/a97c69ba4f30

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


