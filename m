Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1CE43350F
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 13:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235440AbhJSLwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 07:52:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:37352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235389AbhJSLwX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 07:52:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D17AB610C7;
        Tue, 19 Oct 2021 11:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634644210;
        bh=RS3mIyWW4AjOOZbqahh6aTtzz6xlzTtW36X1kQuEZh8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gXVaS+0aDKR5GeDgLJbBlLDZcO0qH1iGULYwZtoz9Ys8wL/w6Nil/AGh1vsQB566a
         SVY3S4LeCZtkzHxyX8sfLi0tspUHwb36yIxfEJPWDTKsAc6k72Cyq8gZKoDDlgAhCV
         eY48fpHHZbdFtx6eCSqtIIRcyc8Gl7cjaklFxhby6KKO9usbiUCvh0U/1LKYZox7OR
         uc9S7SKFJ1NNgd2TYvbYJptTn5150pXdv77A8ZHE3N4YJja9Gqgti+g0cN8ZbvLkvq
         qzQPrDnheZ+tBHh6O1uJRuP5HCNw1osWE84aM3puZ7xkmpBOO7BGL6zu9Q069iEB34
         NQcwda5CReoug==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C6105609D8;
        Tue, 19 Oct 2021 11:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/12] ethernet: manual netdev->dev_addr conversions
 (part 2)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163464421080.25315.12461985201611151061.git-patchwork-notify@kernel.org>
Date:   Tue, 19 Oct 2021 11:50:10 +0000
References: <20211018142932.1000613-1-kuba@kernel.org>
In-Reply-To: <20211018142932.1000613-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 18 Oct 2021 07:29:20 -0700 you wrote:
> Manual conversions of Ethernet drivers writing directly
> to netdev->dev_addr (part 2 out of 3).
> 
> Jakub Kicinski (12):
>   ethernet: mv643xx: use eth_hw_addr_set()
>   ethernet: sky2/skge: use eth_hw_addr_set()
>   ethernet: lpc: use eth_hw_addr_set()
>   ethernet: netxen: use eth_hw_addr_set()
>   ethernet: r8169: use eth_hw_addr_set()
>   ethernet: renesas: use eth_hw_addr_set()
>   ethernet: rocker: use eth_hw_addr_set()
>   ethernet: sxgbe: use eth_hw_addr_set()
>   ethernet: sis190: use eth_hw_addr_set()
>   ethernet: sis900: use eth_hw_addr_set()
>   ethernet: smc91x: use eth_hw_addr_set()
>   ethernet: smsc: use eth_hw_addr_set()
> 
> [...]

Here is the summary with links:
  - [net-next,01/12] ethernet: mv643xx: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/15c343eb0588
  - [net-next,02/12] ethernet: sky2/skge: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/4789b57af37f
  - [net-next,03/12] ethernet: lpc: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/b814d3286923
  - [net-next,04/12] ethernet: netxen: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/88e102e8777e
  - [net-next,05/12] ethernet: r8169: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/1c5d09d58748
  - [net-next,06/12] ethernet: renesas: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/0b08956cd532
  - [net-next,07/12] ethernet: rocker: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/298b0e0c5fec
  - [net-next,08/12] ethernet: sxgbe: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/15fa05bf41ab
  - [net-next,09/12] ethernet: sis190: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/f60e8b06e0cc
  - [net-next,10/12] ethernet: sis900: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/74fad215ee3d
  - [net-next,11/12] ethernet: smc91x: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/02bfb6beb695
  - [net-next,12/12] ethernet: smsc: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/f15fef4c0675

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


