Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA9B43010B
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 10:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239855AbhJPIEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 04:04:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:55608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239870AbhJPICc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Oct 2021 04:02:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1C4D261250;
        Sat, 16 Oct 2021 08:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634371215;
        bh=z7wGmmtu6pRU/n8V87yDR2OS56ZiEYl+zlv7QsE1DCk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MoemE8DV/e60UIkxP14diOF0KpVKe0oA80r9VdGn7jorsG1SZqcsbebLe/DbV16o0
         gWrWYyr1bVxaqMb5+B2qpi9s2rPAY+leLR8MtaXBRnD1nXc2Fz0VKiUNL8reZpDTjj
         CTE3GlvixzX/tHw7v+Akh5ODm3PiROeLCNJRO5OWqdvrmoBjJ3bcV1Ro68na4Tdo2S
         YhSdHT9VOAoaR8DXdVc3LN3PQTXxigzX6Vgf/lnEOdKcgO3xcnqn6FufaRO663R9g5
         LGBgIREVe+n9gQHgZmmDT7m/z0LrbHmb3eVThJ9hsq+gd9J7TcIY5nBLwur6DhRhkB
         1fHY9Ow+nKizg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0B96C60AA3;
        Sat, 16 Oct 2021 08:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/12] ethernet: manual netdev->dev_addr conversions
 (part 1)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163437121504.28528.4573595521963466241.git-patchwork-notify@kernel.org>
Date:   Sat, 16 Oct 2021 08:00:15 +0000
References: <20211015221652.827253-1-kuba@kernel.org>
In-Reply-To: <20211015221652.827253-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 15 Oct 2021 15:16:40 -0700 you wrote:
> Manual conversions of drivers writing directly
> to netdev->dev_addr (part 1 out of 3).
> 
> Jakub Kicinski (12):
>   ethernet: adaptec: use eth_hw_addr_set()
>   ethernet: aeroflex: use eth_hw_addr_set()
>   ethernet: alteon: use eth_hw_addr_set()
>   ethernet: amd: use eth_hw_addr_set()
>   ethernet: aquantia: use eth_hw_addr_set()
>   ethernet: bnx2x: use eth_hw_addr_set()
>   ethernet: bcmgenet: use eth_hw_addr_set()
>   ethernet: enic: use eth_hw_addr_set()
>   ethernet: ec_bhf: use eth_hw_addr_set()
>   ethernet: enetc: use eth_hw_addr_set()
>   ethernet: ibmveth: use ether_addr_to_u64()
>   ethernet: ixgb: use eth_hw_addr_set()
> 
> [...]

Here is the summary with links:
  - [net-next,01/12] ethernet: adaptec: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/8ec53ed9af1f
  - [net-next,02/12] ethernet: aeroflex: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/0d4c7517159f
  - [net-next,03/12] ethernet: alteon: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/ffaeca68fb5f
  - [net-next,04/12] ethernet: amd: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/f98c50509a20
  - [net-next,05/12] ethernet: aquantia: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/698c33d8b489
  - [net-next,06/12] ethernet: bnx2x: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/a85c8f9ad2f6
  - [net-next,07/12] ethernet: bcmgenet: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/0c9e0c7931c6
  - [net-next,08/12] ethernet: enic: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/41edfff572d9
  - [net-next,09/12] ethernet: ec_bhf: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/10e6ded81235
  - [net-next,10/12] ethernet: enetc: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/d9ca87233b68
  - [net-next,11/12] ethernet: ibmveth: use ether_addr_to_u64()
    https://git.kernel.org/netdev/net-next/c/5c8b348534ac
  - [net-next,12/12] ethernet: ixgb: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/ec356edef78c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


