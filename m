Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 219E9386C27
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 23:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239452AbhEQVVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 17:21:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:55656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238124AbhEQVVa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 17:21:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id ECC1C611EE;
        Mon, 17 May 2021 21:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621286414;
        bh=+7M+VlqeZQxM9ksym7Mnl5N0vl4vKgIxFLWxNmzJDvs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JlQ+f8aIt01/E1YbyXJrcNSUAWUZwXxV8DRDeHoZyC+JVixM1ZKBnFatoXqBqvqkw
         7pdIir+h/zm1uZWmqW7inhuXhin4BKsm4p9CRZ7VOEQMi3YtiJ90Dzs63+np98vJNn
         1bELqszm75X+B0hf6T+GRhsShZulZ937PmbdF40KCxVcIt2clX4rO0vnmSdoXsAr1K
         UDuC5YhJ0tjAf+Xfw5Cdn3aRvkJdiiHhk3bSyTXlZ5peZ2lzyA/W574vOe0U8gD2R8
         4P47YCYwebtZHDcOVa8vKa/GMNYl1xdW0drQMCMAL+LJH88OFLLkkCBPfe3YRegy2x
         TFlrONgQazf2w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E7B0360963;
        Mon, 17 May 2021 21:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 00/24] Rid W=1 warnings in net
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162128641394.11371.3320357643522584205.git-patchwork-notify@kernel.org>
Date:   Mon, 17 May 2021 21:20:13 +0000
References: <20210517044535.21473-1-shenyang39@huawei.com>
In-Reply-To: <20210517044535.21473-1-shenyang39@huawei.com>
To:     Yang Shen <shenyang39@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 17 May 2021 12:45:11 +0800 you wrote:
> This is 1 of 2 sets to fully clean drivers/net.
> 
> Changes since v1:
>  - add some warnings missed in v1
>  - move the patches about drivers/net/wireless into another series
> 
> Yang Shen (24):
>   net: arc: Demote non-compliant kernel-doc headers
>   net: atheros: atl1c: Fix wrong function name in comments
>   net: atheros: atl1e: Fix wrong function name in comments
>   net: atheros: atl1x: Fix wrong function name in comments
>   net: broadcom: bnx2x: Fix wrong function name in comments
>   net: brocade: bna: Fix wrong function name in comments
>   net: cadence: Demote non-compliant kernel-doc headers
>   net: calxeda: Fix wrong function name in comments
>   net: chelsio: cxgb3: Fix wrong function name in comments
>   net: chelsio: cxgb4: Fix wrong function name in comments
>   net: chelsio: cxgb4vf: Fix wrong function name in comments
>   net: huawei: hinic: Fix wrong function name in comments
>   net: micrel: Fix wrong function name in comments
>   net: microchip: Demote non-compliant kernel-doc headers
>   net: neterion: Fix wrong function name in comments
>   net: neterion: vxge: Fix wrong function name in comments
>   net: netronome: nfp: Fix wrong function name in comments
>   net: calxeda: Fix wrong function name in comments
>   net: samsung: sxgbe: Fix wrong function name in comments
>   net: socionext: Demote non-compliant kernel-doc headers
>   net: ti: Fix wrong struct name in comments
>   net: via: Fix wrong function name in comments
>   net: phy: Demote non-compliant kernel-doc headers
>   net: hisilicon: hns: Fix wrong function name in comments
> 
> [...]

Here is the summary with links:
  - [v2,01/24] net: arc: Demote non-compliant kernel-doc headers
    https://git.kernel.org/netdev/net-next/c/1d7f7ecadc5a
  - [v2,02/24] net: atheros: atl1c: Fix wrong function name in comments
    https://git.kernel.org/netdev/net-next/c/8965c1c535b1
  - [v2,03/24] net: atheros: atl1e: Fix wrong function name in comments
    https://git.kernel.org/netdev/net-next/c/b43e1554a7cf
  - [v2,04/24] net: atheros: atl1x: Fix wrong function name in comments
    https://git.kernel.org/netdev/net-next/c/c706c75aaee2
  - [v2,05/24] net: broadcom: bnx2x: Fix wrong function name in comments
    https://git.kernel.org/netdev/net-next/c/76d85049173b
  - [v2,06/24] net: brocade: bna: Fix wrong function name in comments
    https://git.kernel.org/netdev/net-next/c/5a02bf4fefd5
  - [v2,07/24] net: cadence: Demote non-compliant kernel-doc headers
    https://git.kernel.org/netdev/net-next/c/c1167cee462d
  - [v2,08/24] net: calxeda: Fix wrong function name in comments
    https://git.kernel.org/netdev/net-next/c/2e45d961a6a8
  - [v2,09/24] net: chelsio: cxgb3: Fix wrong function name in comments
    https://git.kernel.org/netdev/net-next/c/aeed744a49ba
  - [v2,10/24] net: chelsio: cxgb4: Fix wrong function name in comments
    https://git.kernel.org/netdev/net-next/c/e0333b1bb174
  - [v2,11/24] net: chelsio: cxgb4vf: Fix wrong function name in comments
    https://git.kernel.org/netdev/net-next/c/1eb00ff517f4
  - [v2,12/24] net: huawei: hinic: Fix wrong function name in comments
    https://git.kernel.org/netdev/net-next/c/d6174870c0f1
  - [v2,13/24] net: micrel: Fix wrong function name in comments
    https://git.kernel.org/netdev/net-next/c/229fd41f6447
  - [v2,14/24] net: microchip: Demote non-compliant kernel-doc headers
    https://git.kernel.org/netdev/net-next/c/331a3219d3b6
  - [v2,15/24] net: neterion: Fix wrong function name in comments
    https://git.kernel.org/netdev/net-next/c/dc432f5acb86
  - [v2,16/24] net: neterion: vxge: Fix wrong function name in comments
    https://git.kernel.org/netdev/net-next/c/146c91e2bc9a
  - [v2,17/24] net: netronome: nfp: Fix wrong function name in comments
    https://git.kernel.org/netdev/net-next/c/a507b1644524
  - [v2,18/24] net: calxeda: Fix wrong function name in comments
    https://git.kernel.org/netdev/net-next/c/9f2e6fb63413
  - [v2,19/24] net: samsung: sxgbe: Fix wrong function name in comments
    https://git.kernel.org/netdev/net-next/c/61633d71a71c
  - [v2,20/24] net: socionext: Demote non-compliant kernel-doc headers
    https://git.kernel.org/netdev/net-next/c/40d9fca8b3fd
  - [v2,21/24] net: ti: Fix wrong struct name in comments
    https://git.kernel.org/netdev/net-next/c/85ead77dc3d5
  - [v2,22/24] net: via: Fix wrong function name in comments
    https://git.kernel.org/netdev/net-next/c/03055a25213b
  - [v2,23/24] net: phy: Demote non-compliant kernel-doc headers
    https://git.kernel.org/netdev/net-next/c/1f2d109e8363
  - [v2,24/24] net: hisilicon: hns: Fix wrong function name in comments
    https://git.kernel.org/netdev/net-next/c/5a9594cf1d14

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


