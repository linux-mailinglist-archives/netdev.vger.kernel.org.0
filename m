Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EEE03896BA
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 21:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbhESTbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 15:31:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:56146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232018AbhESTbg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 15:31:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B1BE56135A;
        Wed, 19 May 2021 19:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621452616;
        bh=zNu+U2DOuuDH36WyYNUAEJAp9Ze1gI/CPIOX7TM9OBU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CZ5czRXprkhImE28V+EGRWxYsoBZPNIlBhGytMlH0DDxvG9zRtoTKw3BlUvlWAROl
         j55lB+XG3eo7e9ytYrne2kGZFZouR1n1SDIhR3oVt0kh64TCsBMmzuzEHc7Wu8F4Bp
         PmsMbE1VivtnVRM7oKKteMaYueb/Cxxtr0SGJOVQEl/LBqsp7gMh3GwiRYFXe7mFOp
         hV2c+hTreVUc/r+AyY1zkLcxZrBnVgDs/1Cw9V1vnetk1EMx+H6SQqYSZQcDwXYb60
         +cepyc1SZNvNoIM+zwjXnGYaRSzGjA+GErHl44d1JATrFSHXs8QzFFDLzq4HR+1Wpx
         NtJpfa/2IFxWA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A3AF860CD8;
        Wed, 19 May 2021 19:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 00/20] net: ethernet: remove leading spaces before tabs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162145261666.25646.9025623390559721482.git-patchwork-notify@kernel.org>
Date:   Wed, 19 May 2021 19:30:16 +0000
References: <1621402253-27200-1-git-send-email-tanghui20@huawei.com>
In-Reply-To: <1621402253-27200-1-git-send-email-tanghui20@huawei.com>
To:     Hui Tang <tanghui20@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 19 May 2021 13:30:33 +0800 you wrote:
> There are a few leading spaces before tabs and remove it by running the
> following commard:
> 
>         $ find . -name '*.c' | xargs sed -r -i 's/^[ ]+\t/\t/'
>         $ find . -name '*.h' | xargs sed -r -i 's/^[ ]+\t/\t/'
> 
> Hui Tang (20):
>   net: 3com: remove leading spaces before tabs
>   net: alteon: remove leading spaces before tabs
>   net: amd: remove leading spaces before tabs
>   net: apple: remove leading spaces before tabs
>   net: broadcom: remove leading spaces before tabs
>   net: chelsio: remove leading spaces before tabs
>   net: dec: remove leading spaces before tabs
>   net: dlink: remove leading spaces before tabs
>   net: ibm: remove leading spaces before tabs
>   net: marvell: remove leading spaces before tabs
>   net: natsemi: remove leading spaces before tabs
>   net: realtek: remove leading spaces before tabs
>   net: seeq: remove leading spaces before tabs
>   net: sis: remove leading spaces before tabs
>   net: smsc: remove leading spaces before tabs
>   net: sun: remove leading spaces before tabs
>   net: fealnx: remove leading spaces before tabs
>   net: xircom: remove leading spaces before tabs
>   net: 8390: remove leading spaces before tabs
>   net: fujitsu: remove leading spaces before tabs
> 
> [...]

Here is the summary with links:
  - [01/20] net: 3com: remove leading spaces before tabs
    https://git.kernel.org/netdev/net-next/c/959dc069aed8
  - [02/20] net: alteon: remove leading spaces before tabs
    https://git.kernel.org/netdev/net-next/c/40b1f92676f2
  - [03/20] net: amd: remove leading spaces before tabs
    https://git.kernel.org/netdev/net-next/c/106b4cb59766
  - [04/20] net: apple: remove leading spaces before tabs
    https://git.kernel.org/netdev/net-next/c/a22cf81d634c
  - [05/20] net: broadcom: remove leading spaces before tabs
    https://git.kernel.org/netdev/net-next/c/90e4403a6d37
  - [06/20] net: chelsio: remove leading spaces before tabs
    https://git.kernel.org/netdev/net-next/c/21b128fde6e0
  - [07/20] net: dec: remove leading spaces before tabs
    https://git.kernel.org/netdev/net-next/c/cf82f9b165e4
  - [08/20] net: dlink: remove leading spaces before tabs
    https://git.kernel.org/netdev/net-next/c/e6f0f977407f
  - [09/20] net: ibm: remove leading spaces before tabs
    https://git.kernel.org/netdev/net-next/c/c11c900143e4
  - [10/20] net: marvell: remove leading spaces before tabs
    https://git.kernel.org/netdev/net-next/c/717dc24dc5d6
  - [11/20] net: natsemi: remove leading spaces before tabs
    https://git.kernel.org/netdev/net-next/c/4a0949778c4e
  - [12/20] net: realtek: remove leading spaces before tabs
    https://git.kernel.org/netdev/net-next/c/f95a73a8a8a8
  - [13/20] net: seeq: remove leading spaces before tabs
    https://git.kernel.org/netdev/net-next/c/bf53445d81e3
  - [14/20] net: sis: remove leading spaces before tabs
    https://git.kernel.org/netdev/net-next/c/a294ddfccb45
  - [15/20] net: smsc: remove leading spaces before tabs
    https://git.kernel.org/netdev/net-next/c/996d7ab8badf
  - [16/20] net: sun: remove leading spaces before tabs
    https://git.kernel.org/netdev/net-next/c/b54f440cb871
  - [17/20] net: fealnx: remove leading spaces before tabs
    https://git.kernel.org/netdev/net-next/c/d1e4916fa703
  - [18/20] net: xircom: remove leading spaces before tabs
    https://git.kernel.org/netdev/net-next/c/223f02acce1a
  - [19/20] net: 8390: remove leading spaces before tabs
    https://git.kernel.org/netdev/net-next/c/59909c1ab71d
  - [20/20] net: fujitsu: remove leading spaces before tabs
    https://git.kernel.org/netdev/net-next/c/2174fbd71914

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


