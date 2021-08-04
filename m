Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDED83DFF74
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 12:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236729AbhHDKkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 06:40:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:33392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235472AbhHDKkS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 06:40:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 46D3361002;
        Wed,  4 Aug 2021 10:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628073606;
        bh=qKhFxitct69BQEWtg/14NvSlzhD2LYnpJkRy3FaufDI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ajAGviox2ZzE/SlkeBerHdfubj7Nt1FnS09Sxsd7/b8+Wt98rTcn/ZvG5AUNM744t
         k0AiCEUyV8h45Tx5ZR36mg8aI4Xmz4/fBHa7bjaXeJX+nWOeolWmgOyly3/3Y3AK3H
         Of6YNusVS8w6UyEOjJ2zBTj9paKSxDe/MdQ+JUksQEi5AYUqaOEvHneQo/dImbg3CT
         ycLl2gMinITcsiXLUXyCkfjV6v+kCRePqLzaCAbNv6d8estk5UYuvfbKvmLbYU0ipS
         o9+ZL2Yp3rkgb5bRXLtdAsk6yYKZ5JpcD0N8d2Q70Ii4w3TPD1iX4hODGrfzr4UPaW
         y629WJJJ3ARiA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3A1C560A6A;
        Wed,  4 Aug 2021 10:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: can-next 2021-08-04
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162807360623.27025.15762249349058033410.git-patchwork-notify@kernel.org>
Date:   Wed, 04 Aug 2021 10:40:06 +0000
References: <20210804101753.23826-1-mkl@pengutronix.de>
In-Reply-To: <20210804101753.23826-1-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (refs/heads/master):

On Wed,  4 Aug 2021 12:17:48 +0200 you wrote:
> Hello Jakub, hello David,
> 
> this is a pull request of 5 patches for net-next/master.
> 
> The first patch is by me and fixes a typo in a comment in the CAN
> J1939 protocol.
> 
> [...]

Here is the summary with links:
  - pull-request: can-next 2021-08-04
    https://git.kernel.org/netdev/net-next/c/9c0532f9cc93
  - [net-next,2/5] can: j1939: rename J1939_ERRQUEUE_* to J1939_ERRQUEUE_TX_*
    https://git.kernel.org/netdev/net-next/c/cd85d3aed5cf
  - [net-next,3/5] can: j1939: extend UAPI to notify about RX status
    https://git.kernel.org/netdev/net-next/c/5b9272e93f2e
  - [net-next,4/5] can: flexcan: flexcan_clks_enable(): add missing variable initialization
    https://git.kernel.org/netdev/net-next/c/336266697213
  - [net-next,5/5] dt-bindings: net: can: Document power-domains property
    https://git.kernel.org/netdev/net-next/c/d85165b2381c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


