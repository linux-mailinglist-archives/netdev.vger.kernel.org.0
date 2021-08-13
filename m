Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91BBA3EBEA1
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 01:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235504AbhHMXUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 19:20:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:33000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235330AbhHMXUe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 19:20:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BC112610CF;
        Fri, 13 Aug 2021 23:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628896806;
        bh=T2A21R94Fzcz0y7VLVrd8w/ME4Ih2eGUotIe/d4lqnM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ScXVnwYQPmfDFTf7eq09z3qUgspNCmhluxoTkOCcJ8OuCS9ZCMOik70fQRsQnKzbO
         7yAU//lXumyf60KP6BCKM3S/4e4c6VdIVmk21df//gDHdtM+5R68OwLdUGgw5FDW4W
         gJaZBJjOs1pai78ieWGxMA55ifhaUaIBopRcXTF+cU+YuKCHmT3ycm2jUe29IJq5qW
         bC9ZhvOquJ0Xn9DU5R6eNrDwQX6MigcASyEeH7pwQqCNe1R4Cza93Qj1yT+ohCVWc6
         XtiiLlU8CMj1MCIvtsB2Ii72IC0Q0AlU6pVeXlYWBSJBi/7PQ81ywSTaBQn6eGhVQj
         ZHzCd5Ycmjgqg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AD44060A9E;
        Fri, 13 Aug 2021 23:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/2] net: macb: Add PTP support for SAMA5D29
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162889680670.8729.9762612075032276005.git-patchwork-notify@kernel.org>
Date:   Fri, 13 Aug 2021 23:20:06 +0000
References: <20210812074422.13487-1-Hari.PrasathGE@microchip.com>
In-Reply-To: <20210812074422.13487-1-Hari.PrasathGE@microchip.com>
To:     Hari Prasath <Hari.PrasathGE@microchip.com>
Cc:     nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        palmer@dabbelt.com, paul.walmsley@sifive.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org, robh@kernel.org,
        devicetree@vger.kernel.org, mpuswlinux@microchip.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 12 Aug 2021 13:14:21 +0530 you wrote:
> Add PTP capability to the macb config object for sama5d29.
> 
> Signed-off-by: Hari Prasath <Hari.PrasathGE@microchip.com>
> ---
>  drivers/net/ethernet/cadence/macb_main.c | 9 +++++++++
>  1 file changed, 9 insertions(+)

Here is the summary with links:
  - [net-next,1/2] net: macb: Add PTP support for SAMA5D29
    https://git.kernel.org/netdev/net-next/c/7d13ad501169
  - [net-next,2/2] dt-bindings: net: macb: add documentation for sama5d29 ethernet interface
    https://git.kernel.org/netdev/net-next/c/593f8c44cc8b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


